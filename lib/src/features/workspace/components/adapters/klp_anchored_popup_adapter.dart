import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/features/workspace/components/klp_anchored_popup.dart';
import 'package:kallopis/src/features/workspace/components/klp_workspace_command.dart';
import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/installation/klp_default_placement.dart';
import 'package:kallopis/src/styling/presets/internal/klp_workspace_material_recipe.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_index.dart';
import 'package:kallopis/src/styling/primitives/klp_style_kind.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolution.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';

/// 通用錨定 popup 的唯一宣告轉接器；只投影目前 frame 的資料與操作資格。
final class KlpAnchoredPopupAdapter implements KlpNodeAdapter {
	static const _owner = KlpAnchoredPopup.typeId;
	static KlpSemanticKey<T> _key<T extends KlpStyleValue>(String name, KlpStyleKind<T> kind) => KlpSemanticKey<T>(_owner, name, kind);
	static final surface = _key('surface', KlpStyleKind.color);
	static final foreground = _key('foreground', KlpStyleKind.color);
	static final muted = _key('muted', KlpStyleKind.color);
	static final interaction = _key('interaction', KlpStyleKind.color);
	static final shadow = _key('shadow', KlpStyleKind.color);
	static final inset = _key('inset', KlpStyleKind.distance);
	static final gap = _key('gap', KlpStyleKind.distance);
	static final rowExtent = _key('row_extent', KlpStyleKind.distance);
	static final viewportInset = _key('viewport_inset', KlpStyleKind.distance);
	static final radius = _key('radius', KlpStyleKind.radius);
	static final family = _key('family', KlpStyleKind.fontFamily);
	static final size = _key('size', KlpStyleKind.fontSize);
	static final weight = _key('weight', KlpStyleKind.fontWeight);
	static final height = _key('height', KlpStyleKind.lineHeight);
	static final spacing = _key('spacing', KlpStyleKind.letterSpacing);

	@override
	final KlpDefinition<KlpAnchoredPopup> contract = KlpDefinition<KlpAnchoredPopup>(
		_owner,
		semantics: KlpSemanticSchema(_owner, [
			_token(surface, KlpPrimitiveIndex.i3),
			_token(foreground, KlpPrimitiveIndex.i1),
			_token(muted, KlpPrimitiveIndex.i4),
			_token(interaction, KlpPrimitiveIndex.i5),
			_token(shadow, KlpPrimitiveIndex.i6),
			_token(inset, KlpPrimitiveIndex.i2),
			_token(gap, KlpPrimitiveIndex.i1),
			_token(rowExtent, KlpPrimitiveIndex.i5),
			_token(viewportInset, KlpPrimitiveIndex.i2),
			_token(radius, KlpPrimitiveIndex.i2),
			_token(family, KlpPrimitiveIndex.i0),
			_token(size, KlpPrimitiveIndex.i2),
			_token(weight, KlpPrimitiveIndex.i3),
			_token(height, KlpPrimitiveIndex.i4),
			_token(spacing, KlpPrimitiveIndex.i3),
		]),
		slots: [KlpAnchoredPopup.triggerSlot],
	);

	static KlpSemanticToken<T> _token<T extends KlpStyleValue>(KlpSemanticKey<T> key, KlpPrimitiveIndex index) => KlpSemanticToken<T>(key, KlpPrimitiveRef<T>(key.kind, index));

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) => _PreparedAnchoredPopup(node as KlpAnchoredPopup, context.style);
}

final class _PreparedAnchoredPopup implements KlpPreparedNode {
	final KlpAnchoredPopup popup;
	final KlpSemanticResolution style;

	const _PreparedAnchoredPopup(this.popup, this.style);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) {
		final surface = style.read(KlpAnchoredPopupAdapter.surface);
		final inset = style.read(KlpAnchoredPopupAdapter.inset);
		final gap = style.read(KlpAnchoredPopupAdapter.gap);
		final rowExtent = style.read(KlpAnchoredPopupAdapter.rowExtent);
		return KlpBoundAnchoredPopup(
			trigger: children.single,
			open: popup.open,
			accessibilityLabel: popup.accessibilityLabel,
			title: popup.title,
			items: popup.items?.map((item) => KlpBoundAnchoredPopupItem(
				id: item.id,
				label: item.label,
				subtitle: item.subtitle,
				icon: item.icon?.index,
				current: item.current,
				enabled: item.enabled,
				onPressed: item.onPressed == null ? null : () => lease.runAsync(() async => await item.onPressed!()),
				commands: item.commands.map((command) => _bindCommand(command, lease)),
			)),
			actions: popup.actions?.map((command) => _bindCommand(command, lease)),
			state: popup.state.index,
			message: popup.message,
			onOpenChanged: (open, reason) => lease.run(() => popup.onOpenChanged(open, reason)),
			surface: surface,
			foreground: style.read(KlpAnchoredPopupAdapter.foreground),
			mutedForeground: style.read(KlpAnchoredPopupAdapter.muted),
			interaction: style.read(KlpAnchoredPopupAdapter.interaction),
			shadow: style.read(KlpAnchoredPopupAdapter.shadow),
			destructive: KlpWorkspaceMaterialRecipe.accent(surface),
			inset: inset,
			gap: gap,
			rowExtent: rowExtent,
			viewportInset: style.read(KlpAnchoredPopupAdapter.viewportInset),
			panelWidth: KlpDistance(rowExtent.value * 9),
			shadowOffset: gap,
			shadowBlur: KlpDistance(inset.value * 2),
			radius: style.read(KlpAnchoredPopupAdapter.radius),
			textStyle: KlpBoundTextStyle(
				color: style.read(KlpAnchoredPopupAdapter.foreground),
				fontFamily: style.read(KlpAnchoredPopupAdapter.family),
				fontSize: style.read(KlpAnchoredPopupAdapter.size),
				fontWeight: style.read(KlpAnchoredPopupAdapter.weight),
				lineHeight: style.read(KlpAnchoredPopupAdapter.height),
				letterSpacing: style.read(KlpAnchoredPopupAdapter.spacing),
			),
		);
	}

	KlpBoundWorkspaceCommand _bindCommand(KlpWorkspaceCommand command, KlpFrameLease lease) => KlpBoundWorkspaceCommand(
		label: command.label,
		enabled: command.enabled,
		destructive: command.destructive,
		inputLabel: command.inputLabel,
		initialValue: command.initialValue,
		confirmation: command.confirmation,
		submitLabel: command.submitLabel,
		cancelLabel: command.cancelLabel,
		shortcut: command.shortcut?.index,
		onInvoke: (value) => lease.runAsync(() async => await command.onInvoke(value)),
		onResult: command.onResult == null ? null : (result) => lease.run(() => command.onResult!(result)),
	);
}
