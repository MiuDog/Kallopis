import '../../../../composition/definitions/klp_definition.dart';
import '../../../../composition/nodes/klp_node.dart';
import '../../../../composition/validation/klp_validated_node.dart';
import '../../../../foundation/binding/internal/klp_bound_choice_style.dart';
import '../../../../kernel/diagnostics/klp_contract_error.dart';
import '../../../../kernel/identity/klp_placement_id.dart';
import '../../../../runtime/compilation/internal/klp_node_adapter.dart';
import '../../../../runtime/compilation/internal/klp_prepare_context.dart';
import '../../../../runtime/compilation/internal/klp_prepared_node.dart';
import '../../../../styling/primitives/klp_style_value.dart';
import '../../../../capabilities/actions/klp_action.dart';
import '../../../../capabilities/actions/klp_action_handler.dart';
import '../contracts/klp_rail.dart';
import '../contracts/klp_rail_item.dart';
import 'klp_prepared_rail.dart';
import 'klp_rail_semantics.dart';

/// 本庫功能轉譯器，將資格插槽降為受控基礎層，不依賴 Flutter。
final class KlpRailAdapter implements KlpNodeAdapter {

	const KlpRailAdapter();

	@override
	KlpDefinition<KlpNode> get contract => KlpDefinition<KlpRail>(KlpRail.typeId, semantics: KlpRailSemantics.createSchema(), slots: [KlpRail.topSlot, KlpRail.centerSlot, KlpRail.bottomSlot]);

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final rail = node as KlpRail;
		final style = context.style;
		final width = style.read(KlpRailSemantics.width);
		final extent = style.read(KlpRailSemantics.itemExtent);
		final inset = style.read(KlpRailSemantics.inset);
		final gap = style.read(KlpRailSemantics.gap);
		final focusWidth = style.read(KlpRailSemantics.focusWidth);
		if (extent.value <= 0 || width.value <= inset.value * 2 || focusWidth.value <= 0) {
			throw KlpContractError('invalid_rail_geometry', '${snapshot.id}: positive item, inner width and focus stroke required.');
		}
		final items = <({KlpPlacementId id, String label, KlpAction? action})>[];
		for (final id in snapshot.childrenPlacements) {
			final item = context.sources[id] as KlpRailItem;
			final label = item.accessibilityLabel;
			if (label.trim().isEmpty) throw KlpContractError('invalid_rail_label', id.toString());
			final action = item.action;
			if (action != null && !acceptsKlpAction(context.actionHandler, action)) throw KlpContractError('unsupported_rail_action', id.toString());
			items.add((id: id, label: label, action: action));
		}
		// 衍生幾何在配置資源前驗證有限性，避免提交後才發現溢位。
		KlpDistance groupExtent(int count) => KlpDistance(count == 0 ? 0 : count * extent.value + (count - 1) * gap.value);
		final topCount = snapshot.slotRanges[0].end - snapshot.slotRanges[0].start;
		final centerCount = snapshot.slotRanges[1].end - snapshot.slotRanges[1].start;
		final bottomCount = snapshot.slotRanges[2].end - snapshot.slotRanges[2].start;
		final topExtent = groupExtent(topCount);
		final bottomExtent = groupExtent(bottomCount);
		final minimumBodyExtent = groupExtent(centerCount == 0 ? 0 : 1);
		groupExtent(centerCount);
		if (!(topExtent.value + bottomExtent.value + minimumBodyExtent.value).isFinite) {
			throw KlpContractError('invalid_rail_geometry', '${snapshot.id}: combined region extent must be finite.');
		}
		return KlpPreparedRail(
			items: items,
			topCount: topCount,
			centerCount: centerCount,
			onSelected: rail.onSelected,
			choiceStyle: KlpBoundChoiceStyle(background: style.read(KlpRailSemantics.itemBackground), selectedBackground: style.read(KlpRailSemantics.selectedBackground), focusColor: style.read(KlpRailSemantics.focusColor), extent: extent, radius: style.read(KlpRailSemantics.radius), focusWidth: focusWidth),
			background: style.read(KlpRailSemantics.background),
			width: width,
			inset: inset,
			gap: gap,
			topExtent: topExtent,
			bottomExtent: bottomExtent,
			minimumBodyExtent: minimumBodyExtent,
			actionHandler: context.actionHandler,
		);
	}
}
