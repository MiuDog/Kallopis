import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/registry/klp_registry.dart';
import 'package:kallopis/src/composition/validation/internal/klp_tree_capture.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_set.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolver.dart';
import 'package:kallopis/src/capabilities/actions/klp_action_handler.dart';
import 'package:kallopis/src/composition/nodes/klp_platform_strategy.dart';
import 'package:kallopis/src/runtime/installation/internal/klp_installation.dart';
import 'package:kallopis/src/runtime/contracts/klp_installation_exception.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_activation_policy.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_resource_policy.dart';
import 'package:kallopis/src/runtime/contracts/klp_runtime_frame.dart';

/// 唯一樹更新流程：驗證、投影、安裝、提交畫面，不認識任何功能型別。
final class KlpTreeRuntime {

	KlpInstallation? _installation;
	Map<KlpPlacementId, KlpPreparedNode> _pending = {};
	KlpRuntimeFrame? _frame;
	bool _busy = false;
	bool _disposed = false;

	KlpRuntimeFrame? get frame => _frame;
	bool get isDisposed => _disposed;
	Map<KlpPlacementId, KlpPlacementResource> get resources => _installation?.resources ?? const {};

	void update({
		required KlpNode root,
		required Iterable<KlpNodeAdapter> adapters,
		required KlpPrimitiveSet primitives,
		KlpActionHandler? actionHandler,
		KlpAdaptiveContext? adaptiveContext,
	}) {
		_enter();
		try {
			// 步驟 1：本庫轉接器建立唯一目錄，全樹擷取與準備成功才可建立資源。
			final registered = List<KlpNodeAdapter>.of(adapters);
			final registry = KlpRegistry(registered.map((adapter) => adapter.contract));
			final captured = captureKlpTree(registry, root, adaptiveContext: adaptiveContext);
			final context = KlpPrepareContext(
				sources: captured.sources,
				nodes: {
					for (final node in captured.validation.nodes) node.placementId: node,
				},
				primitives: primitives,
				style: KlpSemanticResolver(registry.definitions.map((definition) => definition.semantics)).resolve(primitives),
				actionHandler: actionHandler,
			);
			final byDefinition = {
				for (final adapter in registered) adapter.contract.id: adapter,
			};
			final prepared = <KlpPlacementId, KlpPreparedNode>{};
			for (final node in captured.validation.nodes) {
				prepared[node.placementId] = byDefinition[node.definitionId]!.prepare(captured.sources[node.placementId]!, node, context);
			}

			// 準備完整成功後沿父子鏈傳遞操作資格，子邊界不能重新啟用停用祖先。
			final lease = KlpFrameLease();
			final leases = <KlpPlacementId, KlpFrameLease>{
				captured.validation.rootPlacement: lease,
			};
			for (final node in captured.validation.nodes) {
				final inherited = leases[node.placementId]!;
				final description = prepared[node.placementId]!;
				final descendants = description is KlpPreparedActivationPolicy ? inherited.derive(enabled: (description as KlpPreparedActivationPolicy).descendantsActive) : inherited;
				for (final child in node.childrenPlacements) {
					leases[child] = descendants;
				}
			}

			// 步驟 2：建立期失敗保留舊畫面；提交後通知失敗仍必須發布新畫面。
			_pending = prepared;
			final installation = _installation ??= KlpInstallation(registry, create: _create, canReuse: _canReuse);
			KlpInstallationException? committedError;
			try {
				installation.updateValidated(captured.validation, onCommitted: () => _frame?.lease.revoke());
			}
			on KlpInstallationException catch (error) {
				if (!error.committed) rethrow;

				committedError = error;
			}

			// 步驟 3：子節點先降為封閉呈現資料，再撤銷舊畫面的操作資格。
			try {
				final bound = <KlpPlacementId, KlpBoundTemplate>{};
				final resources = installation.resources;
				for (final node in captured.validation.nodes.reversed) {
					final content = prepared[node.placementId]!.materialize(resources[node.placementId]!, [for (final id in node.childrenPlacements) bound[id]!], leases[node.placementId]!);
					bound[node.placementId] = KlpBoundPlacement(node.placementId, content);
				}
				final next = KlpRuntimeFrame(captured.validation.rootPlacement, bound[captured.validation.rootPlacement]!, lease);
				_frame?.lease.revoke();
				_frame = next;
			}
			catch (error, stackTrace) {
				// 內部 adapter 違約時資源已提交，不能繼續暴露引用舊資源的畫面。
				lease.revoke();
				_frame?.lease.revoke();
				_frame = null;
				final issues = [
					...?committedError?.issues,
					(error: error, stackTrace: stackTrace),
				];
				throw KlpInstallationException(true, issues);
			}
			if (committedError != null) throw committedError;
		}
		finally {
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
		}
		finally {
			_busy = false;
		}
	}

	KlpPlacementResource _create(KlpValidatedNode node) => _pending[node.placementId]!.createResource(node);

	bool _canReuse(KlpValidatedNode node, KlpPlacementResource resource) {
		final prepared = _pending[node.placementId]!;
		if (prepared is KlpPreparedResourcePolicy) return (prepared as KlpPreparedResourcePolicy).canReuse(resource);

		return true;
	}

	void _enter() {
		if (_disposed) throw StateError('Runtime has been disposed.');
		if (_busy) throw StateError('Runtime cannot be changed reentrantly.');

		_busy = true;
	}
}
