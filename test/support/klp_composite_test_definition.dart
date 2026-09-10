import 'package:kallopis/kallopis_declarative.dart';

import 'klp_component_test_definition.dart';
import 'klp_component_test_item.dart';
import 'klp_composite_test_node.dart';

final klpCompositeLeading = KlpSlot<KlpRailItem>(owner: 'fixture', name: 'leading');
final klpCompositeTrailing = KlpSlot<KlpRailItem>(owner: 'fixture', name: 'trailing');

/// 由同一份模板推導插槽，不讓消費端重複列出安裝清單。
KlpComponentDefinition<KlpCompositeTestNode> klpCompositeTestDefinition({String Function(KlpCompositeTestNode)? select}) {
	final original = klpComponentTestDefinition();
	final surface = original.content as KlpSurfaceTemplate<KlpComponentTestItem>;
	final row = surface.child as KlpLinearTemplate<KlpComponentTestItem>;
	final text = row.children.first as KlpTextTemplate<KlpComponentTestItem>;
	return KlpComponentDefinition('fixture', semantics: original.contract.semantics, content: KlpLinearTemplate(
		axis: KlpAxis.vertical,
		gap: row.gap,
		children: [
			KlpTextTemplate<KlpCompositeTestNode>(text: select ?? (node) => node.label, semantics: text.semantics),
			KlpChildrenTemplate<KlpCompositeTestNode, KlpRailItem>(slot: klpCompositeLeading, axis: KlpAxis.horizontal, gap: row.gap),
			KlpSurfaceTemplate<KlpCompositeTestNode>(
				background: surface.background,
				radius: surface.radius,
				inset: surface.inset,
				child: KlpChildrenTemplate<KlpCompositeTestNode, KlpRailItem>(slot: klpCompositeTrailing, axis: KlpAxis.vertical, gap: row.gap),
			),
		],
	));
}

KlpChildren klpCompositeChildren({List<KlpRailItem> leading = const [], List<KlpRailItem> trailing = const []}) => KlpChildren([klpCompositeLeading.assign(leading), klpCompositeTrailing.assign(trailing)]);
