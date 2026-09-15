import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
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
import 'package:kallopis/src/styling/presets/klp_frame_relief_recipe.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';
import 'package:kallopis/src/features/workspace/layout/klp_app_layout.dart';

/// 將 app layout 純資料降為封閉的 Flutter 呈現資料。
final class KlpAppLayoutAdapter implements KlpNodeAdapter {

	static final headerExtent = KlpSemanticKey(KlpAppLayout.typeId, 'header_extent', KlpStyleKind.distance);
	static final frameInset = KlpSemanticKey(KlpAppLayout.typeId, 'frame_inset', KlpStyleKind.distance);
	static final frameBackground = KlpSemanticKey(KlpAppFrame.typeId, 'background', KlpStyleKind.color);
	static final auxiliaryBackground = KlpSemanticKey(KlpAppFrame.typeId, 'auxiliary_background', KlpStyleKind.color);
	static final frameRadius = KlpSemanticKey(KlpAppFrame.typeId, 'radius', KlpStyleKind.radius);
	static final laneUnit = KlpSemanticKey(KlpAppFrame.typeId, 'lane_unit', KlpStyleKind.distance);
	static final compactGap = KlpSemanticKey(KlpAppFrame.typeId, 'compact_gap', KlpStyleKind.distance);
	static final frameShadow = KlpSemanticKey(KlpAppFrame.typeId, 'shadow', KlpStyleKind.color);

	@override
	final KlpDefinition<KlpNode> contract;

	KlpAppLayoutAdapter._(this.contract);

	static List<KlpNodeAdapter> createAll() => [
		KlpAppLayoutAdapter._(KlpDefinition<KlpAppLayout>(KlpAppLayout.typeId, semantics: KlpSemanticSchema(KlpAppLayout.typeId, [KlpSemanticToken(headerExtent, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i5)), KlpSemanticToken(frameInset, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i2))]), slots: [KlpAppLayout.childSlot, KlpAppLayout.floatingActionSlot])),
		KlpAppLayoutAdapter._(KlpDefinition<LayoutRow>(LayoutRow.typeId, semantics: KlpSemanticSchema(LayoutRow.typeId, []), slots: [LayoutRow.childSlot])),
		KlpAppLayoutAdapter._(KlpDefinition<LayoutColumn>(LayoutColumn.typeId, semantics: KlpSemanticSchema(LayoutColumn.typeId, []), slots: [LayoutColumn.childSlot])),
		KlpAppLayoutAdapter._(KlpDefinition<LayoutResizeHandle>(LayoutResizeHandle.typeId, semantics: KlpSemanticSchema(LayoutResizeHandle.typeId, []))),
		KlpAppLayoutAdapter._(KlpDefinition<LayoutSpacer>(LayoutSpacer.typeId, semantics: KlpSemanticSchema(LayoutSpacer.typeId, []))),
		KlpAppLayoutAdapter._(KlpDefinition<KlpLayoutPane>(KlpLayoutPane.typeId, semantics: KlpSemanticSchema(KlpLayoutPane.typeId, []), slots: [KlpLayoutPane.childSlot])),
		KlpAppLayoutAdapter._(KlpDefinition<KlpAppFrame>(KlpAppFrame.typeId, semantics: KlpSemanticSchema(KlpAppFrame.typeId, [KlpSemanticToken(frameBackground, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i3)), KlpSemanticToken(auxiliaryBackground, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i2)), KlpSemanticToken(frameRadius, const KlpPrimitiveRef(KlpStyleKind.radius, KlpPrimitiveIndex.i3)), KlpSemanticToken(laneUnit, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i5)), KlpSemanticToken(compactGap, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i1)), KlpSemanticToken(frameShadow, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i6))]), slots: [KlpAppFrame.childSlot])),
	];

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final style = context.style;
		final background = style.read(node is KlpAppFrame && (node.role == KlpAppFrameRole.auxiliary || node.role == KlpAppFrameRole.sidebar) ? auxiliaryBackground : frameBackground);
		final raised = node is KlpAppFrame && node.surface == KlpAppFrameSurface.raised;
		return _KlpPreparedAppLayout(
			kind: switch (node) { KlpAppLayout() => _KlpAppLayoutKind.root, LayoutRow() => _KlpAppLayoutKind.row, LayoutColumn() => _KlpAppLayoutKind.column, LayoutResizeHandle() => _KlpAppLayoutKind.handle, KlpAppFrame() => _KlpAppLayoutKind.frame, LayoutSpacer() => _KlpAppLayoutKind.spacer, KlpLayoutPane() => _KlpAppLayoutKind.pane, _ => throw StateError('Unexpected app layout node.') },
			inset: style.read(frameInset),
			headerExtent: style.read(headerExtent),
			onHeaderDrag: node is KlpAppLayout ? node.onHeaderDrag : null,
			background: background,
			reliefShadow: raised ? KlpFrameReliefRecipe.shadow(background, style.read(frameShadow)) : null,
			reliefHighlight: raised ? KlpFrameReliefRecipe.highlight(background) : null,
			reliefScale: raised ? style.read(compactGap) : null,
			radius: style.read(frameRadius),
			flex: switch (node) { LayoutRow value => value.flex, LayoutColumn value => value.flex, KlpAppFrame value => value.flex, LayoutSpacer value => value.flex, KlpLayoutPane value => value.flex, _ => 0 },
			laneExtent: switch (node) {
				KlpAppFrame(role: KlpAppFrameRole.sidebar) => KlpDistance(style.read(laneUnit).value * 8 + style.read(compactGap).value),
				KlpAppFrame(role: KlpAppFrameRole.rightSidebar) => KlpDistance(style.read(laneUnit).value * 7 + style.read(compactGap).value * 5),
				KlpLayoutPane(size: KlpLayoutPaneSize.trailing) => KlpDistance(style.read(laneUnit).value * 7 + style.read(compactGap).value * 5),
				KlpAppFrame(role: KlpAppFrameRole.toolbarControls) => KlpDistance(style.read(laneUnit).value * 3 + style.read(compactGap).value * 6),
				_ => null,
			},
			bare: node is KlpAppFrame && (node.role == KlpAppFrameRole.rightSidebar || node.role == KlpAppFrameRole.toolbarControls),
			alignment: node is LayoutRow ? node.alignment.index : 0,
			gapless: switch (node) { LayoutRow(:final spacing) || LayoutColumn(:final spacing) => spacing == KlpLayoutSpacing.none, _ => false },
		);
	}
}

enum _KlpAppLayoutKind { root, row, column, handle, frame, spacer, pane }

final class _KlpPreparedAppLayout implements KlpPreparedNode {

	final _KlpAppLayoutKind kind;
	final KlpDistance inset;
	final KlpDistance headerExtent;
	final void Function()? onHeaderDrag;
	final KlpColor background;
	final KlpRadius radius;
	final KlpColor? reliefShadow;
	final KlpColor? reliefHighlight;
	final KlpDistance? reliefScale;
	final int flex;
	final KlpDistance? laneExtent;
	final bool bare;
	final int alignment;
	final bool gapless;
	const _KlpPreparedAppLayout({required this.kind, required this.inset, required this.headerExtent, required this.onHeaderDrag, required this.background, required this.radius, required this.flex, required this.laneExtent, required this.bare, required this.alignment, required this.gapless, this.reliefShadow, this.reliefHighlight, this.reliefScale});

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundAppLayout(kind: kind.index, inset: inset, headerExtent: headerExtent, onHeaderDrag: onHeaderDrag, background: background, radius: radius, flex: flex, laneExtent: laneExtent, bare: bare, alignment: alignment, gapless: gapless, reliefShadow: reliefShadow, reliefHighlight: reliefHighlight, reliefScale: reliefScale, children: children);
}
