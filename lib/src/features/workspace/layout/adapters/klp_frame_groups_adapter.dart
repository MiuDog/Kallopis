import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/features/workspace/layout/klp_frame_groups.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/installation/klp_default_placement.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_index.dart';
import 'package:kallopis/src/styling/primitives/klp_style_kind.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolution.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';

/// 將 Frame 的群組與內距樣式解析成封閉呈現資料。
final class KlpFrameGroupsAdapter implements KlpNodeAdapter {

	static final horizontalPadding = KlpSemanticKey(KlpFrameGroup.typeId, 'horizontal_padding', KlpStyleKind.distance);
	static final noHorizontalPadding = KlpSemanticKey(KlpFrameGroup.typeId, 'no_horizontal_padding', KlpStyleKind.distance);
	static final dividerColor = KlpSemanticKey(KlpFrameGroup.typeId, 'divider_color', KlpStyleKind.color);
	static final dividerStroke = KlpSemanticKey(KlpFrameGroup.typeId, 'divider_stroke', KlpStyleKind.strokeWidth);
	static final groupGap = KlpSemanticKey(KlpFrameGroup.typeId, 'group_gap', KlpStyleKind.distance);
	static final contentGap = KlpSemanticKey(KlpFrameGroup.typeId, 'content_gap', KlpStyleKind.distance);

	final KlpDefinition<KlpNode> _contract;

	KlpFrameGroupsAdapter._(this._contract);

	@override
	KlpDefinition<KlpNode> get contract => _contract;

	static List<KlpNodeAdapter> createAll() => [
		KlpFrameGroupsAdapter._(KlpDefinition<KlpFrameGroups>(KlpFrameGroups.typeId, semantics: KlpSemanticSchema(KlpFrameGroups.typeId, const []), slots: [KlpFrameGroups.groupSlot, KlpFrameGroups.footerSlot])),
		KlpFrameGroupsAdapter._(KlpDefinition<KlpFrameGroup>(KlpFrameGroup.typeId, semantics: KlpSemanticSchema(KlpFrameGroup.typeId, [
			KlpSemanticToken(horizontalPadding, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i2)),
			KlpSemanticToken(noHorizontalPadding, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i0)),
			KlpSemanticToken(dividerColor, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i5)),
			KlpSemanticToken(dividerStroke, const KlpPrimitiveRef(KlpStyleKind.strokeWidth, KlpPrimitiveIndex.i1)),
			KlpSemanticToken(groupGap, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i1)),
			KlpSemanticToken(contentGap, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i4)),
		]), slots: [KlpFrameGroup.childSlot])),
	];

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		if (node is KlpFrameGroup) return _prepareGroup(node, context.style);

		return _KlpPreparedFrameGroups(hasFooter: (node as KlpFrameGroups).footer != null);
	}

	KlpPreparedNode _prepareGroup(KlpFrameGroup group, KlpSemanticResolution style) {
		final horizontalInset = group.style.padding == KlpFrameGroupPadding.standard
			? style.read(horizontalPadding)
			: style.read(noHorizontalPadding);
		return _KlpPreparedFrameGroup(
			horizontalInset: horizontalInset,
			divider: group.style.divider.index,
			dividerColor: style.read(dividerColor),
			dividerStroke: style.read(dividerStroke),
			groupGap: style.read(group.style.divider == KlpFrameGroupDivider.sectionGap ? horizontalPadding : groupGap),
			contentGap: group.style.contentSpacing == KlpFrameGroupContentSpacing.standard ? style.read(contentGap) : KlpDistance(0),
		);
	}
}

final class _KlpPreparedFrameGroups implements KlpPreparedNode {

	final bool hasFooter;
	const _KlpPreparedFrameGroups({required this.hasFooter});

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundFrameGroups(children, hasFooter: hasFooter);
}

final class _KlpPreparedFrameGroup implements KlpPreparedNode {

	final KlpDistance horizontalInset;
	final int divider;
	final KlpColor dividerColor;
	final KlpStrokeWidth dividerStroke;
	final KlpDistance groupGap;
	final KlpDistance contentGap;

	const _KlpPreparedFrameGroup({
		required this.horizontalInset,
		required this.divider,
		required this.dividerColor,
		required this.dividerStroke,
		required this.groupGap,
		required this.contentGap,
	});

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundFrameGroup(
		children: children,
		horizontalInset: horizontalInset,
		divider: divider,
		dividerColor: dividerColor,
		dividerStroke: dividerStroke,
		groupGap: groupGap,
		contentGap: contentGap,
	);
}
