import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/features/navigation/rail/contracts/klp_rail_item.dart';

import 'klp_composite_test_node.dart';

final klpCompositeLeading = KlpSlot<KlpRailItem>(owner: 'fixture', name: 'leading');
final klpCompositeTrailing = KlpSlot<KlpRailItem>(owner: 'fixture', name: 'trailing');

/// 結構契約直接屬於 composition，不再從已退役 compiler 推導。
KlpDefinition<KlpCompositeTestNode> klpCompositeTestDefinition() => KlpDefinition('fixture', slots: [klpCompositeLeading, klpCompositeTrailing]);

KlpChildren klpCompositeChildren({List<KlpRailItem> leading = const [], List<KlpRailItem> trailing = const []}) => KlpChildren([klpCompositeLeading.assign(leading), klpCompositeTrailing.assign(trailing)]);
