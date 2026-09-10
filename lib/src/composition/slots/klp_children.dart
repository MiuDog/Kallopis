import 'dart:collection';

import '../nodes/klp_node.dart';
import 'klp_slot.dart';

/// 複合節點的唯一子樹來源；配置與展平結果來自同一份不可變快照。
final class KlpChildren extends IterableBase<KlpNode> {
  final List<KlpSlotAssignment<KlpNode>> assignments;
  late final List<KlpNode> _children;

  KlpChildren(List<KlpSlotAssignment<KlpNode>> assignments)
    : assignments = List.unmodifiable(assignments) {
    _children = List.unmodifiable(
      this.assignments.expand((assignment) => assignment.children),
    );
  }

  @override
  Iterator<KlpNode> get iterator => _children.iterator;

  @override
  int get length => _children.length;
}
