import '../../../composition/nodes/klp_node.dart';
import '../../../composition/registry/klp_registry.dart';
import '../../../composition/validation/internal/klp_tree_capture.dart';
import '../../../composition/validation/klp_validated_node.dart';
import '../../../foundation/binding/internal/klp_bound_template.dart';
import '../../../foundation/binding/internal/klp_component_compiler.dart';
import '../../../foundation/definitions/klp_component_definition.dart';
import '../../../kernel/lifecycle/internal/klp_frame_lease.dart';
import '../../../kernel/identity/klp_placement_id.dart';
import '../../../styling/primitives/klp_primitive_set.dart';
import '../../../styling/resolution/internal/klp_semantic_resolver.dart';
import '../../../capabilities/actions/klp_action_handler.dart';
import '../../installation/internal/klp_installation.dart';
import '../../installation/internal/klp_installation_exception.dart';
import '../../installation/internal/klp_placement_resource.dart';
import 'klp_node_adapter.dart';
import 'klp_prepare_context.dart';
import 'klp_prepared_node.dart';
import 'klp_prepared_activation_policy.dart';
import 'klp_runtime_frame.dart';

/// 唯一樹更新流程：驗證、投影、安裝、提交畫面，不認識任何功能型別。
final class KlpTreeRuntime {
  KlpInstallation? _installation;
  Map<KlpPlacementId, KlpPreparedNode> _pending = {};
  KlpRuntimeFrame? _frame;
  bool _busy = false;
  bool _disposed = false;

  KlpRuntimeFrame? get frame => _frame;
  bool get isDisposed => _disposed;
  Map<KlpPlacementId, KlpPlacementResource> get resources =>
      _installation?.resources ?? const {};

  void update({
    required KlpNode root,
    required Iterable<KlpNodeAdapter> adapters,
    required Iterable<KlpComponentDefinition<KlpNode>> components,
    required KlpPrimitiveSet primitives,
    KlpActionHandler? actionHandler,
  }) {
    _enter();
    try {
      // 步驟 1：本次註冊完整驗證，資料 selector 全部成功才可建立資源。
      final registered = List<KlpNodeAdapter>.of(adapters);
      final definitions = List<KlpComponentDefinition<KlpNode>>.of(components);
      final registry = KlpRegistry(
        registered.map((adapter) => adapter.contract),
      );
      final customIds = {
        for (final definition in definitions) definition.contract.id,
      };
      final compiler = KlpComponentCompiler(
        definitions,
        sharedDefinitions: registry.definitions.where(
          (definition) => !customIds.contains(definition.id),
        ),
      );
      final captured = captureKlpTree(registry, root);
      final context = KlpPrepareContext(
        sources: captured.sources,
        nodes: {
          for (final node in captured.validation.nodes) node.placementId: node,
        },
        components: compiler,
        primitives: primitives,
        style: KlpSemanticResolver(
          registry.definitions.map((definition) => definition.semantics),
        ).resolve(primitives),
        actionHandler: actionHandler,
      );
      final byDefinition = {
        for (final adapter in registered) adapter.contract.id: adapter,
      };
      final prepared = <KlpPlacementId, KlpPreparedNode>{};
      // 外部模板資格先全樹檢查，避免較晚的模板失配落在文字投影之後。
      for (final node in captured.validation.nodes) {
        if (customIds.contains(node.definitionId)) {
          compiler.validateCaptured(captured.sources[node.placementId]!, node);
        }
      }
      for (final node in captured.validation.nodes) {
        prepared[node.placementId] = byDefinition[node.definitionId]!.prepare(
          captured.sources[node.placementId]!,
          node,
          context,
        );
      }

      // 準備完整成功後沿父子鏈傳遞操作資格，子邊界不能重新啟用停用祖先。
      final lease = KlpFrameLease();
      final leases = <KlpPlacementId, KlpFrameLease>{
        captured.validation.rootPlacement: lease,
      };
      for (final node in captured.validation.nodes) {
        final inherited = leases[node.placementId]!;
        final description = prepared[node.placementId]!;
        final descendants = description is KlpPreparedActivationPolicy
            ? inherited.derive(
                enabled: (description as KlpPreparedActivationPolicy)
                    .descendantsActive,
              )
            : inherited;
        for (final child in node.childrenPlacements) {
          leases[child] = descendants;
        }
      }

      // 步驟 2：建立期失敗保留舊畫面；提交後通知失敗仍必須發布新畫面。
      _pending = prepared;
      final installation = _installation ??= KlpInstallation(
        registry,
        create: _create,
      );
      KlpInstallationException? committedError;
      try {
        installation.updateValidated(
          captured.validation,
          onCommitted: () => _frame?.lease.revoke(),
        );
      } on KlpInstallationException catch (error) {
        if (!error.committed) rethrow;

        committedError = error;
      }

      // 步驟 3：子節點先降為封閉呈現資料，再撤銷舊畫面的操作資格。
      try {
        final bound = <KlpPlacementId, KlpBoundTemplate>{};
        final resources = installation.resources;
        for (final node in captured.validation.nodes.reversed) {
          final content = prepared[node.placementId]!.materialize(
            resources[node.placementId]!,
            [for (final id in node.childrenPlacements) bound[id]!],
            leases[node.placementId]!,
          );
          bound[node.placementId] = KlpBoundPlacement(
            node.placementId,
            content,
          );
        }
        final next = KlpRuntimeFrame(
          captured.validation.rootPlacement,
          bound[captured.validation.rootPlacement]!,
          lease,
        );
        _frame?.lease.revoke();
        _frame = next;
      } catch (error, stackTrace) {
        // 內部 adapter 違約時資源已提交，不能繼續暴露引用舊資源的畫面。
        lease.revoke();
        _frame?.lease.revoke();
        _frame = null;
        throw KlpInstallationException(true, [
          ...?committedError?.issues,
          (error: error, stackTrace: stackTrace),
        ]);
      }
      if (committedError != null) throw committedError;
    } finally {
      _pending = {};
      _busy = false;
    }
  }

  void dispose() {
    if (_disposed) return;

    _enter();
    _disposed = true;
    _frame?.lease.revoke();
    _frame = null;
    try {
      _installation?.dispose();
    } finally {
      _busy = false;
    }
  }

  KlpPlacementResource _create(KlpValidatedNode node) =>
      _pending[node.placementId]!.createResource(node);

  void _enter() {
    if (_disposed) throw StateError('Runtime has been disposed.');
    if (_busy) throw StateError('Runtime cannot be changed reentrantly.');

    _busy = true;
  }
}
