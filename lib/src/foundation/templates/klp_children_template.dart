part of 'klp_template.dart';

/// 定義期宣告合格子項的唯一位置與排列，實例只能填入插槽資料。
final class KlpChildrenTemplate<T extends KlpNode, C extends KlpNode>
    extends KlpTemplate<T> {
  final KlpSlot<C> slot;
  final KlpAxis axis;
  final KlpSemanticKey<KlpDistance> gap;

  const KlpChildrenTemplate({
    required this.slot,
    required this.axis,
    required this.gap,
  });
}
