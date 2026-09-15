import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/capabilities/actions/klp_action_handler.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/features/workspace/components/klp_workspace_block.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
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
import 'package:kallopis/src/styling/presets/internal/klp_workspace_material_recipe.dart';

/// 內建工作區區塊與內容的語意繫結轉接器；產品資料和事件仍由使用端提供。
final class KlpWorkspaceBlockAdapter implements KlpNodeAdapter {
	static const _owner = KlpWorkspaceBlock.typeId;
	static KlpSemanticKey<T> _key<T extends KlpStyleValue>(String name, KlpStyleKind<T> kind) => KlpSemanticKey<T>(_owner, name, kind);
	static final background = _key('background', KlpStyleKind.color);
	static final foreground = _key('foreground', KlpStyleKind.color);
	static final muted = _key('muted', KlpStyleKind.color);
	static final selected = _key('selected', KlpStyleKind.color);
	static final shadow = _key('shadow', KlpStyleKind.color);
	static final compactGap = _key('compact_gap', KlpStyleKind.distance);
	static final gap = _key('gap', KlpStyleKind.distance);
	static final row = _key('row', KlpStyleKind.distance);
	static final header = _key('header', KlpStyleKind.distance);
	static final inset = _key('inset', KlpStyleKind.distance);
	static final radius = _key('radius', KlpStyleKind.radius);
	static final family = _key('family', KlpStyleKind.fontFamily);
	static final size = _key('size', KlpStyleKind.fontSize);
	static final weight = _key('weight', KlpStyleKind.fontWeight);
	static final height = _key('height', KlpStyleKind.lineHeight);
	static final spacing = _key('spacing', KlpStyleKind.letterSpacing);
	static final eyebrowSize = _key('eyebrow_size', KlpStyleKind.fontSize);
	static final titleSize = _key('title_size', KlpStyleKind.fontSize);
	static final bodySize = _key('body_size', KlpStyleKind.fontSize);
	static final sectionSize = _key('section_size', KlpStyleKind.fontSize);
	static final bodyHeight = _key('body_height', KlpStyleKind.lineHeight);
	static final dividerStroke = _key('divider_stroke', KlpStyleKind.strokeWidth);
	static final brandFamily = _key('brand_family', KlpStyleKind.fontFamily);
	static final brandMarkSize = _key('brand_mark_size', KlpStyleKind.fontSize);
	static final brandNameSize = _key('brand_name_size', KlpStyleKind.fontSize);

	final KlpDefinition<KlpNode> _contract;
	KlpWorkspaceBlockAdapter._(this._contract);
	@override
	KlpDefinition<KlpNode> get contract => _contract;

	static List<KlpNodeAdapter> createAll() => [
		KlpWorkspaceBlockAdapter._(KlpDefinition<KlpWorkspaceBlock>(_owner, semantics: KlpSemanticSchema(_owner, [
		_token(background, KlpPrimitiveIndex.i3), _token(foreground, KlpPrimitiveIndex.i1), _token(muted, KlpPrimitiveIndex.i4), _token(selected, KlpPrimitiveIndex.i5), _token(shadow, KlpPrimitiveIndex.i6),
		_token(compactGap, KlpPrimitiveIndex.i1), _token(gap, KlpPrimitiveIndex.i2), _token(row, KlpPrimitiveIndex.i5), _token(header, KlpPrimitiveIndex.i5), _token(inset, KlpPrimitiveIndex.i4), _token(radius, KlpPrimitiveIndex.i2),
		_token(family, KlpPrimitiveIndex.i0), _token(size, KlpPrimitiveIndex.i2), _token(weight, KlpPrimitiveIndex.i3), _token(height, KlpPrimitiveIndex.i4), _token(spacing, KlpPrimitiveIndex.i3), _token(eyebrowSize, KlpPrimitiveIndex.i0), _token(titleSize, KlpPrimitiveIndex.i7), _token(bodySize, KlpPrimitiveIndex.i2), _token(sectionSize, KlpPrimitiveIndex.i4), _token(bodyHeight, KlpPrimitiveIndex.i5),
		_token(dividerStroke, KlpPrimitiveIndex.i1),
		_token(brandFamily, KlpPrimitiveIndex.i1), _token(brandMarkSize, KlpPrimitiveIndex.i6), _token(brandNameSize, KlpPrimitiveIndex.i4),
	]), slots: [KlpWorkspaceBlock.contentSlot])),
		KlpWorkspaceBlockAdapter._(KlpDefinition<KlpWorkspaceContent>(KlpWorkspaceContent.typeId, slots: [KlpWorkspaceContent.childSlot])),
		KlpWorkspaceBlockAdapter._(KlpDefinition<KlpWorkspaceContentBlock>(KlpWorkspaceContentBlock.typeId, slots: [KlpWorkspaceContentBlock.childSlot])),
	];

	static KlpSemanticToken<T> _token<T extends KlpStyleValue>(KlpSemanticKey<T> key, KlpPrimitiveIndex index) => KlpSemanticToken<T>(key, KlpPrimitiveRef<T>(key.kind, index));

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) => switch (node) {
		KlpWorkspaceBlock value => _prepareBlock(value, snapshot, context),
		KlpWorkspaceContent value => _PreparedContent(value),
		KlpWorkspaceContentBlock value => _PreparedContentBlock(value),
		_ => throw StateError('Unexpected workspace node.'),
	};

	KlpPreparedNode _prepareBlock(KlpWorkspaceBlock block, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final action = block.action;
		if (action != null && !acceptsKlpAction(context.actionHandler, action)) throw KlpContractError('unsupported_workspace_action', snapshot.placementId.toString());
		return _Prepared(block, context.style, snapshot.placementId, context.actionHandler);
	}
}

final class _PreparedContent implements KlpPreparedNode {
	final KlpWorkspaceContent content;
	const _PreparedContent(this.content);
	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);
	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundWorkspaceContent(axis: content.axis.index, children: children);
}

final class _PreparedContentBlock implements KlpPreparedNode {
	final KlpWorkspaceContentBlock block;
	const _PreparedContentBlock(this.block);
	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);
	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundWorkspaceContentBlock(kind: block.kind.index, text: block.text, subtitle: block.subtitle, icon: block.icon?.index, checked: block.checked, onPressed: block.onPressed, onCheckedChanged: block.onCheckedChanged, axis: block.axis.index, children: children);
}

final class _Prepared implements KlpPreparedNode {
	final KlpWorkspaceBlock block;
	final KlpSemanticResolution style;
	final KlpPlacementId placementId;
	final KlpActionHandler? actionHandler;
	const _Prepared(this.block, this.style, this.placementId, this.actionHandler);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) {
		final compact = style.read(KlpWorkspaceBlockAdapter.compactGap);
		final standard = style.read(KlpWorkspaceBlockAdapter.gap);
		final contentInset = style.read(KlpWorkspaceBlockAdapter.inset);
		final blockRadius = style.read(KlpWorkspaceBlockAdapter.radius);
		final action = block.action;
		final onPressed = action == null ? block.onPressed : () => lease.runAsync(() async => await dispatchKlpAction(actionHandler, action, placementId));
		return KlpBoundWorkspaceBlock(
			kind: block.kind.index, title: block.title, symbol: block.symbol, icon: block.icon?.index, subtitle: block.subtitle, lines: block.lines, checklist: block.checklist, checklistTitle: block.checklistTitle,
			items: [for (final item in block.items) KlpBoundWorkspaceItem(title: item.title, subtitle: item.subtitle, symbol: item.symbol, icon: item.icon?.index, checked: item.checked, selected: item.selected, onPressed: item.onPressed, onCheckedChanged: item.onCheckedChanged)],
			choices: [for (final choice in block.choices) KlpBoundWorkspaceChoice(label: choice.label, selected: choice.selected, onSelected: choice.onSelected)],
			query: block.query, hint: block.hint, onQueryChanged: block.onQueryChanged, toggleLabel: block.toggleLabel, toggleValue: block.toggleValue, onToggleChanged: block.onToggleChanged,
			selected: block.selected, actions: block.actions.map((command) => KlpBoundWorkspaceCommand(label: command.label, enabled: command.enabled, destructive: command.destructive, inputLabel: command.inputLabel, initialValue: command.initialValue, confirmation: command.confirmation, submitLabel: command.submitLabel, cancelLabel: command.cancelLabel, shortcut: command.shortcut?.index, onInvoke: command.onInvoke)).toList(growable: false), actionsLabel: block.actionsLabel, onPressed: onPressed, secondaryActionLabel: block.secondaryActionLabel, onSecondaryAction: block.onSecondaryAction, tertiaryActionLabel: block.tertiaryActionLabel, onTertiaryAction: block.onTertiaryAction, material: block.material.index, shadowed: block.shadowed, materialBackground: KlpWorkspaceMaterialRecipe.sticky(style.read(KlpWorkspaceBlockAdapter.background), sage: block.material == KlpWorkspaceMaterial.sage), calloutBackground: KlpWorkspaceMaterialRecipe.sticky(style.read(KlpWorkspaceBlockAdapter.background), sage: true), content: children.isEmpty ? null : children.single,
			background: style.read(KlpWorkspaceBlockAdapter.background), foreground: style.read(KlpWorkspaceBlockAdapter.foreground), mutedForeground: style.read(KlpWorkspaceBlockAdapter.muted), selectedBackground: style.read(KlpWorkspaceBlockAdapter.selected), shadowColor: style.read(KlpWorkspaceBlockAdapter.shadow),
			accentColor: KlpWorkspaceMaterialRecipe.accent(style.read(KlpWorkspaceBlockAdapter.background)),
			detailSize: KlpFontSize(style.read(KlpWorkspaceBlockAdapter.bodySize).value - compact.value / 4),
			detailLineHeight: KlpLineHeight(style.read(KlpWorkspaceBlockAdapter.bodyHeight).value + compact.value * 0.075),
			controlExtent: KlpDistance(style.read(KlpWorkspaceBlockAdapter.bodySize).value + style.read(KlpWorkspaceBlockAdapter.dividerStroke).value),
			controlRadius: KlpRadius(blockRadius.value / 2), controlGap: KlpDistance(standard.value - compact.value / 2),
			iconExtent: KlpDistance(style.read(KlpWorkspaceBlockAdapter.bodySize).value + compact.value), columnGap: KlpDistance(standard.value * 2),
			compactGap: compact, gap: standard, rowExtent: style.read(KlpWorkspaceBlockAdapter.row), headerExtent: style.read(KlpWorkspaceBlockAdapter.header), inset: contentInset, radius: blockRadius, stickyRadius: KlpRadius(blockRadius.value + compact.value / 4),
			textStyle: KlpBoundTextStyle(color: style.read(KlpWorkspaceBlockAdapter.foreground), fontFamily: style.read(KlpWorkspaceBlockAdapter.family), fontSize: style.read(KlpWorkspaceBlockAdapter.size), fontWeight: style.read(KlpWorkspaceBlockAdapter.weight), lineHeight: style.read(KlpWorkspaceBlockAdapter.height), letterSpacing: style.read(KlpWorkspaceBlockAdapter.spacing)),
			eyebrowSize: style.read(KlpWorkspaceBlockAdapter.eyebrowSize), titleSize: KlpFontSize(style.read(KlpWorkspaceBlockAdapter.titleSize).value - compact.value / 2), bodySize: style.read(KlpWorkspaceBlockAdapter.bodySize), sectionSize: style.read(KlpWorkspaceBlockAdapter.sectionSize), bodyLineHeight: style.read(KlpWorkspaceBlockAdapter.bodyHeight), shadowOffset: KlpDistance(standard.value / 2), shadowBlur: KlpDistance(contentInset.value - compact.value / 2), dividerStroke: style.read(KlpWorkspaceBlockAdapter.dividerStroke), brandFamily: style.read(KlpWorkspaceBlockAdapter.brandFamily), brandMarkSize: KlpFontSize(style.read(KlpWorkspaceBlockAdapter.brandMarkSize).value + compact.value / 4), brandNameSize: style.read(KlpWorkspaceBlockAdapter.brandNameSize),
		);
	}
}
