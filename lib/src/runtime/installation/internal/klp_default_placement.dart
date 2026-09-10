import '../../../capabilities/controllers/klp_state_controller.dart';
import '../../../capabilities/state/klp_mutable_state.dart';
import '../../../capabilities/state/klp_state.dart';
import '../../../composition/validation/klp_validated_node.dart';
import 'klp_placement_resource.dart';

/// 為每個放置位置建立獨立狀態與借用控制器。
final class KlpDefaultPlacement implements KlpPlacementResource {
  final KlpMutableState<KlpValidatedNode> _owner;
  final KlpStateController<KlpValidatedNode> controller = KlpStateController();

  KlpDefaultPlacement(KlpValidatedNode node) : _owner = KlpMutableState(node) {
    controller.attach(_owner.readOnly);
  }

  KlpState<KlpValidatedNode> get state => _owner.readOnly;
  bool get isDisposed => _owner.isDisposed;

  @override
  void update(KlpValidatedNode node) {
    _owner.value = node;
  }

  @override
  void dispose() {
    // 先解除控制器，再釋放本放置位置擁有的狀態。
    controller.dispose();
    _owner.dispose();
  }
}
