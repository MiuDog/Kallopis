import '../../definitions/klp_definition.dart';
import '../../slots/klp_children.dart';
import '../../slots/klp_slot.dart';
import '../klp_composite_node.dart';
import '../klp_node.dart';

/// 只有本庫組合根建立的作用域邊界，外部定義不能自行開啟識別作用域。
final class KlpScopeBoundary implements KlpCompositeNode {
  static const typeId = 'kallopis.scopeBoundary';
  static final childSlot = KlpSlot<KlpNode>(
    owner: typeId,
    name: 'child',
    min: 1,
    max: 1,
  );
  static final contract = KlpDefinition<KlpScopeBoundary>(
    typeId,
    slots: [childSlot],
  );

  @override
  final String id;
  @override
  final KlpChildren children;
  final bool active;

  KlpScopeBoundary({
    required this.id,
    required KlpNode child,
    this.active = true,
  }) : children = KlpChildren([
         childSlot.assign([child]),
       ]);

  @override
  String get definitionId => typeId;
}
