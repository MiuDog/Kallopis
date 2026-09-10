import 'package:kallopis/kallopis_declarative.dart';

import 'demo_counter_content.dart';

/// 示範消費端項目只有資料及操作，沒有風格或渲染權限。
final class DemoRailItem implements KlpRailItem, KlpCompositeNode {
  static const typeId = 'demo.railItem';
  static final counterSlot = KlpSlot<DemoCounterContent>(
    owner: typeId,
    name: 'counter',
    min: 1,
    max: 1,
  );

  @override
  final String id;
  final String label;
  final DemoCounterContent counter;
  @override
  final KlpChildren children;
  @override
  final KlpAction? action;

  DemoRailItem({
    required this.id,
    required this.label,
    required this.counter,
    required this.action,
  }) : children = KlpChildren([
         counterSlot.assign([counter]),
       ]);

  @override
  String get definitionId => typeId;
  @override
  String get accessibilityLabel => '$label, ${counter.value}';
}
