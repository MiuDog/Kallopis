import '../../../../capabilities/controllers/klp_state_controller.dart';
import '../../../../capabilities/state/klp_mutable_state.dart';
import '../../../../capabilities/state/klp_state.dart';
import '../../../../composition/validation/klp_validated_node.dart';
import '../../../../kernel/identity/klp_placement_id.dart';
import '../../../../runtime/installation/internal/klp_placement_resource.dart';
import 'klp_rail_activation_exception.dart';
import '../../../../capabilities/actions/klp_action.dart';
import '../../../../capabilities/actions/klp_action_handler.dart';

/// Rail 擁有選取狀態；畫面與控制器只借用同一來源。
final class KlpRailPlacement implements KlpPlacementResource {
  KlpValidatedNode _node;
  final KlpMutableState<KlpPlacementId?> _selection = KlpMutableState(null);
  final KlpStateController<KlpPlacementId?> controller = KlpStateController();
  bool _activating = false;

  KlpRailPlacement(this._node) {
    controller.attach(_selection.readOnly);
  }

  KlpState<KlpPlacementId?> get selection => _selection.readOnly;
  bool get isDisposed => _selection.isDisposed;

  @override
  void update(KlpValidatedNode node) {
    if (isDisposed) throw StateError('Rail placement has been disposed.');
    _node = node;
    if (!_node.childrenPlacements.contains(_selection.value)) {
      _selection.value = null;
    }
  }

  Future<void> activate(
    KlpPlacementId id,
    KlpAction action,
    KlpActionHandler? actionHandler,
    void Function(String)? onSelected,
  ) async {
    if (isDisposed || !_node.childrenPlacements.contains(id)) return;
    if (_activating) throw StateError('Rail activation cannot reenter.');
    _activating = true;
    final failures = <({Object error, StackTrace stackTrace})>[];
    void attempt(void Function() action) {
      try {
        action();
      } catch (error, stackTrace) {
        failures.add((error: error, stackTrace: stackTrace));
      }
    }

    try {
      // 導覽 action 只有核心提交後才會選取；一般 callback 仍保有本地選取。
      final activation = await dispatchKlpAction(actionHandler, action, id);
      // 導覽提交可在 await 期間替換整個放置；舊 rail 不得再寫入已釋放狀態。
      if (isDisposed) return;
      if (activation.committed) {
        attempt(() => _selection.value = id);
        if (onSelected != null) attempt(() => onSelected(id.localId));
      }
    } finally {
      _activating = false;
    }
    if (failures.length == 1) {
      Error.throwWithStackTrace(
        failures.single.error,
        failures.single.stackTrace,
      );
    }
    if (failures.isNotEmpty) throw KlpRailActivationException(failures);
  }

  @override
  void dispose() {
    controller.dispose();
    _selection.dispose();
  }
}
