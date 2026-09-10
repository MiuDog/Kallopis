import 'package:kallopis/kallopis_declarative.dart';

import 'klp_component_test_menu_item.dart';

/// 消費端實例僅保存資料、識別與操作，不提供風格或模板。
final class KlpComponentTestItem
    implements KlpRailItem, KlpComponentTestMenuItem {
  @override
  final String id;
  @override
  final String definitionId;
  final String label;
  @override
  final KlpAction? action;
  @override
  final List<KlpNode> children;

  KlpComponentTestItem({
    this.id = 'placement',
    this.definitionId = 'fixture',
    this.label = 'First',
    this.action,
    Iterable<KlpNode> children = const [],
  }) : children = List.unmodifiable(children);

  @override
  String get accessibilityLabel => label;
}
