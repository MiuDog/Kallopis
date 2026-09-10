import 'package:kallopis/kallopis_declarative.dart';

import 'klp_test_rail_item.dart';

final class KlpTestRail implements KlpNode {
  @override
  final String id;
  @override
  final List<KlpTestRailItem> children;

  KlpTestRail(this.id, this.children);

  @override
  String get definitionId => 'rail';
}
