import '../../../../composition/validation/klp_validated_node.dart';
import '../../../../foundation/binding/internal/klp_bound_choice_style.dart';
import '../../../../foundation/binding/internal/klp_bound_template.dart';
import '../../../../foundation/templates/klp_axis.dart';
import '../../../../kernel/lifecycle/internal/klp_frame_lease.dart';
import '../../../../kernel/identity/klp_placement_id.dart';
import '../../../../runtime/compilation/internal/klp_prepared_node.dart';
import '../../../../runtime/installation/internal/klp_placement_resource.dart';
import '../../../../styling/primitives/klp_style_value.dart';
import '../../../../capabilities/actions/klp_action.dart';
import '../../../../capabilities/actions/klp_action_handler.dart';
import 'klp_rail_placement.dart';

/// 已投影的 Rail 資料；實體化不再讀取外部節點或執行 selector。
final class KlpPreparedRail implements KlpPreparedNode {

	final List<({KlpPlacementId id, String label, KlpAction? action})> items;
	final int topCount;
	final int centerCount;
	final void Function(String)? onSelected;
	final KlpBoundChoiceStyle choiceStyle;
	final KlpColor background;
	final KlpDistance width;
	final KlpDistance inset;
	final KlpDistance gap;
	final KlpDistance topExtent;
	final KlpDistance bottomExtent;
	final KlpDistance minimumBodyExtent;
	final KlpActionHandler? actionHandler;

	KlpPreparedRail({required Iterable<({KlpPlacementId id, String label, KlpAction? action})> items, required this.topCount, required this.centerCount, required this.onSelected, required this.choiceStyle, required this.background, required this.width, required this.inset, required this.gap, required this.topExtent, required this.bottomExtent, required this.minimumBodyExtent, required this.actionHandler}) : items = List.unmodifiable(items);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpRailPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) {
		final placement = resource as KlpRailPlacement;
		final choices = <KlpBoundTemplate>[];
		for (var index = 0; index < items.length; index++) {
			final item = items[index];
			final action = item.action;
			choices.add(KlpBoundChoice(
				id: item.id,
				label: item.label,
				selection: placement.selection,
				onActivate: action == null ? null : () => lease.runAsync(() => placement.activate(item.id, action, actionHandler, onSelected)),
				child: children[index],
				style: choiceStyle,
			));
		}
		KlpBoundLinear group(int start, int end) => KlpBoundLinear(KlpAxis.vertical, gap, choices.sublist(start, end));
		return KlpBoundExtent(KlpAxis.horizontal, width, KlpBoundSurface(
			background: background,
			radius: choiceStyle.radius,
			inset: inset,
			child: KlpBoundRegions(
				axis: KlpAxis.vertical,
				leading: group(0, topCount),
				body: group(topCount, topCount + centerCount),
				trailing: group(topCount + centerCount, items.length),
				leadingExtent: topExtent,
				trailingExtent: bottomExtent,
				minimumBodyExtent: minimumBodyExtent,
			),
		));
	}
}
