import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/runtime/installation/klp_default_placement.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_index.dart';
import 'package:kallopis/src/styling/primitives/klp_style_kind.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolution.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';
import 'package:kallopis/src/styling/presets/klp_menu_recipe.dart';
import 'klp_menu.dart';
import 'klp_menu_item.dart';
import 'klp_bound_menu.dart';

/// 將純資料選單轉為已解析風格與受 frame lease 保護的呈現事件。
final class KlpMenuAdapter implements KlpNodeAdapter {

	static const _owner = KlpMenu.typeId;
	static final surface = KlpSemanticKey(_owner, 'surface', KlpStyleKind.color);
	static final foreground = KlpSemanticKey(_owner, 'foreground', KlpStyleKind.color);
	static final muted = KlpSemanticKey(_owner, 'muted', KlpStyleKind.color);
	static final interaction = KlpSemanticKey(_owner, 'interaction', KlpStyleKind.color);
	static final shadow = KlpSemanticKey(_owner, 'shadow', KlpStyleKind.color);
	static final toggleOffTrack = KlpSemanticKey(_owner, 'toggleOffTrack', KlpStyleKind.color);
	static final toggleWidth = KlpSemanticKey(_owner, 'toggleWidth', KlpStyleKind.distance);
	static final toggleHeight = KlpSemanticKey(_owner, 'toggleHeight', KlpStyleKind.distance);
	static final toggleThumb = KlpSemanticKey(_owner, 'toggleThumb', KlpStyleKind.distance);
	static final toggleInset = KlpSemanticKey(_owner, 'toggleInset', KlpStyleKind.distance);
	static final toggleTrackRadius = KlpSemanticKey(_owner, 'toggleTrackRadius', KlpStyleKind.distance);
	static final toggleThumbRadius = KlpSemanticKey(_owner, 'toggleThumbRadius', KlpStyleKind.distance);
	static final width = KlpSemanticKey(_owner, 'width', KlpStyleKind.distance);
	static final rowExtent = KlpSemanticKey(_owner, 'rowExtent', KlpStyleKind.distance);
	static final headerExtent = KlpSemanticKey(_owner, 'headerExtent', KlpStyleKind.distance);
	static final padding = KlpSemanticKey(_owner, 'padding', KlpStyleKind.distance);
	static final inset = KlpSemanticKey(_owner, 'inset', KlpStyleKind.distance);
	static final gap = KlpSemanticKey(_owner, 'gap', KlpStyleKind.distance);
	static final itemGap = KlpSemanticKey(_owner, 'itemGap', KlpStyleKind.distance);
	static final iconExtent = KlpSemanticKey(_owner, 'iconExtent', KlpStyleKind.distance);
	static final iconOffset = KlpSemanticKey(_owner, 'iconOffset', KlpStyleKind.distance);
	static final dashLength = KlpSemanticKey(_owner, 'dashLength', KlpStyleKind.distance);
	static final dashGap = KlpSemanticKey(_owner, 'dashGap', KlpStyleKind.distance);
	static final shadowBlur = KlpSemanticKey(_owner, 'shadowBlur', KlpStyleKind.distance);
	static final shadowOffset = KlpSemanticKey(_owner, 'shadowOffset', KlpStyleKind.distance);
	static final panelRadius = KlpSemanticKey(_owner, 'panelRadius', KlpStyleKind.radius);
	static final itemRadius = KlpSemanticKey(_owner, 'itemRadius', KlpStyleKind.radius);
	static final stroke = KlpSemanticKey(_owner, 'stroke', KlpStyleKind.strokeWidth);
	static final fontFamily = KlpSemanticKey(_owner, 'fontFamily', KlpStyleKind.fontFamily);
	static final fontSize = KlpSemanticKey(_owner, 'fontSize', KlpStyleKind.fontSize);
	static final fontWeight = KlpSemanticKey(_owner, 'fontWeight', KlpStyleKind.fontWeight);
	static final lineHeight = KlpSemanticKey(_owner, 'lineHeight', KlpStyleKind.lineHeight);
	static final letterSpacing = KlpSemanticKey(_owner, 'letterSpacing', KlpStyleKind.letterSpacing);
	final KlpDefinition<KlpNode> _contract;

	KlpMenuAdapter._(this._contract);

	@override
	KlpDefinition<KlpNode> get contract => _contract;

	static List<KlpNodeAdapter> createAll() => [KlpMenuAdapter._(KlpDefinition<KlpMenu>(_owner, semantics: _schema()))];

	static KlpSemanticSchema _schema() {
		KlpSemanticToken<T> token<T extends KlpStyleValue>(KlpSemanticKey<T> key, KlpPrimitiveIndex index) => KlpSemanticToken(key, KlpPrimitiveRef(key.kind, index));
		return KlpSemanticSchema(_owner, [
			token(surface, KlpPrimitiveIndex.i3),
			token(foreground, KlpPrimitiveIndex.i1),
			token(muted, KlpPrimitiveIndex.i4),
			token(interaction, KlpPrimitiveIndex.i5),
			token(shadow, KlpPrimitiveIndex.i6),
			token(toggleOffTrack, KlpPrimitiveIndex.i2),
			token(toggleWidth, KlpPrimitiveIndex.i1),
			token(toggleHeight, KlpPrimitiveIndex.i1),
			token(toggleThumb, KlpPrimitiveIndex.i1),
			token(toggleInset, KlpPrimitiveIndex.i1),
			token(toggleTrackRadius, KlpPrimitiveIndex.i1),
			token(toggleThumbRadius, KlpPrimitiveIndex.i1),
			token(width, KlpPrimitiveIndex.i1),
			token(rowExtent, KlpPrimitiveIndex.i1),
			token(headerExtent, KlpPrimitiveIndex.i1),
			token(padding, KlpPrimitiveIndex.i1),
			token(inset, KlpPrimitiveIndex.i1),
			token(gap, KlpPrimitiveIndex.i1),
			token(itemGap, KlpPrimitiveIndex.i1),
			token(iconExtent, KlpPrimitiveIndex.i1),
			token(iconOffset, KlpPrimitiveIndex.i1),
			token(dashLength, KlpPrimitiveIndex.i1),
			token(dashGap, KlpPrimitiveIndex.i1),
			token(shadowBlur, KlpPrimitiveIndex.i1),
			token(shadowOffset, KlpPrimitiveIndex.i1),
			token(panelRadius, KlpPrimitiveIndex.i2),
			token(itemRadius, KlpPrimitiveIndex.i2),
			token(stroke, KlpPrimitiveIndex.i1),
			token(fontFamily, KlpPrimitiveIndex.i1),
			token(fontSize, KlpPrimitiveIndex.i2),
			token(fontWeight, KlpPrimitiveIndex.i3),
			token(lineHeight, KlpPrimitiveIndex.i2),
			token(letterSpacing, KlpPrimitiveIndex.i3),
		]);
	}

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) => _PreparedMenu(node as KlpMenu, context.style);
}

final class _PreparedMenu implements KlpPreparedNode {

	final KlpMenu menu;
	final KlpSemanticResolution style;

	const _PreparedMenu(this.menu, this.style);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) {
		// 步驟 1：複製封閉資料，停用項目不保留可執行事件。
		KlpMenuItem bind(KlpMenuItem item) => KlpMenuItem(
			id: item.id,
			label: item.label,
			icon: item.icon,
			shortcut: item.shortcut,
			toggleValue: item.toggleValue,
			hasSubmenu: item.hasSubmenu,
			children: item.children.map(bind).toList(growable: false),
			destructive: item.destructive,
			separatedBefore: item.separatedBefore,
			dashedSeparatorBefore: item.dashedSeparatorBefore,
			selected: item.selected,
			enabled: item.enabled,
			onPressed: !item.enabled || item.onPressed == null ? null : () => lease.run(item.onPressed!),
		);
		final items = menu.items.map(bind).toList(growable: false);

		// 步驟 2：幾何用途各自由唯一解析值套用配方，避免互相牽連。
		final resolvedStyle = KlpBoundMenuStyle(
			surface: style.read(KlpMenuAdapter.surface),
			foreground: style.read(KlpMenuAdapter.foreground),
			muted: style.read(KlpMenuAdapter.muted),
			interaction: style.read(KlpMenuAdapter.interaction),
			shadow: style.read(KlpMenuAdapter.shadow),
			toggleOffTrack: style.read(KlpMenuAdapter.toggleOffTrack),
			toggleWidth: KlpMenuRecipe.toggleWidth(style.read(KlpMenuAdapter.toggleWidth)),
			toggleHeight: KlpMenuRecipe.toggleHeight(style.read(KlpMenuAdapter.toggleHeight)),
			toggleThumb: KlpMenuRecipe.toggleThumb(style.read(KlpMenuAdapter.toggleThumb)),
			toggleInset: KlpMenuRecipe.toggleInset(style.read(KlpMenuAdapter.toggleInset)),
			toggleTrackRadius: KlpMenuRecipe.toggleTrackRadius(style.read(KlpMenuAdapter.toggleTrackRadius)),
			toggleThumbRadius: KlpMenuRecipe.toggleThumbRadius(style.read(KlpMenuAdapter.toggleThumbRadius)),
			destructive: KlpMenuRecipe.destructive,
			width: KlpMenuRecipe.width(style.read(KlpMenuAdapter.width)),
			rowExtent: KlpMenuRecipe.rowExtent(style.read(KlpMenuAdapter.rowExtent)),
			headerExtent: KlpMenuRecipe.headerExtent(style.read(KlpMenuAdapter.headerExtent)),
			padding: KlpMenuRecipe.padding(style.read(KlpMenuAdapter.padding)),
			inset: KlpMenuRecipe.inset(style.read(KlpMenuAdapter.inset)),
			gap: KlpMenuRecipe.gap(style.read(KlpMenuAdapter.gap)),
			itemGap: KlpMenuRecipe.itemGap(style.read(KlpMenuAdapter.itemGap)),
			iconExtent: KlpMenuRecipe.iconExtent(style.read(KlpMenuAdapter.iconExtent)),
			iconOffset: KlpMenuRecipe.iconOffset(style.read(KlpMenuAdapter.iconOffset)),
			dashLength: KlpMenuRecipe.dashLength(style.read(KlpMenuAdapter.dashLength)),
			dashGap: KlpMenuRecipe.dashGap(style.read(KlpMenuAdapter.dashGap)),
			shadowBlur: KlpMenuRecipe.shadowBlur(style.read(KlpMenuAdapter.shadowBlur)),
			shadowOffset: KlpMenuRecipe.shadowOffset(style.read(KlpMenuAdapter.shadowOffset)),
			panelRadius: KlpMenuRecipe.panelRadius(style.read(KlpMenuAdapter.panelRadius)),
			itemRadius: KlpMenuRecipe.itemRadius(style.read(KlpMenuAdapter.itemRadius)),
			stroke: style.read(KlpMenuAdapter.stroke).value,
			text: KlpBoundTextStyle(
				color: style.read(KlpMenuAdapter.foreground),
				fontFamily: style.read(KlpMenuAdapter.fontFamily),
				fontSize: style.read(KlpMenuAdapter.fontSize),
				fontWeight: style.read(KlpMenuAdapter.fontWeight),
				lineHeight: style.read(KlpMenuAdapter.lineHeight),
				letterSpacing: style.read(KlpMenuAdapter.letterSpacing),
			),
		);
		return KlpBoundMenu(
			style: resolvedStyle,
			items: items,
			label: menu.label,
			triggerLabel: menu.triggerLabel,
			autofocus: menu.autofocus,
			onEscape: menu.onEscape == null ? null : () => lease.run(menu.onEscape!),
		);
	}
}
