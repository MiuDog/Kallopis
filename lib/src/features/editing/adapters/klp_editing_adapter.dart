import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/features/editing/presentation/klp_bound_editing_style.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_control_style.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/semantics/klp_control_density.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_source.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_content.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import '../internal/klp_editing_semantics.dart';
import '../internal/klp_editor_mode_capability.dart';
import '../internal/klp_prepared_editing.dart';

/// 將合格編輯來源與本庫語意繫結成封閉呈現資料。
final class KlpEditingAdapter implements KlpNodeAdapter {
	@override
	KlpDefinition<KlpNode> get contract => KlpDefinition<KlpEditingContent>(KlpEditingContent.typeId, semantics: KlpEditingSemantics.schema(), slots: [KlpEditingContent.blockControlsSlot, KlpEditingContent.anchoredCommandsSlot, KlpEditingContent.modeToolbarSlot]);

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final editing = node as KlpEditingContent;
		final source = editing.source;
		final drawing = source.drawing;
		if (!source.drawings.isBroadcast) throw ArgumentError('Editing drawings must use a broadcast stream.');
		if (editing.blockControls != null && (source is! KlpBlockControlSource || drawing.blocks == null)) {
			throw const KlpContractError('missing_block_control_capability', 'Block controls require the enclosing editing source capability and projection.');
		}
		if (editing.anchoredCommands != null && (source is! KlpAnchoredCommandSource || drawing.anchoredCommands == null)) {
			throw const KlpContractError('missing_anchored_command_capability', 'Anchored commands require the enclosing editing source capability and projection.');
		}
		if (editing.modeToolbar != null && (source is! KlpEditorModeSource || drawing.editorModes == null)) {
			throw const KlpContractError('missing_editor_mode_capability', 'Mode toolbar requires the enclosing editing source capability and projection.');
		}
		if (editing.modeToolbar != null) validateKlpEditorModeCapability(source, drawing);
		final style = context.style;
		final density = KlpControlDensity(style.read(KlpEditingSemantics.controlExtent));
		final controlFont = style.read(KlpEditingSemantics.controlFontSize);
		if (controlFont.value <= 0) throw ArgumentError('Editor control font size must be positive.');

		return KlpPreparedEditing(source, drawing, KlpBoundEditingStyle(
			text: style.read(KlpEditingSemantics.text),
			ink: style.read(KlpEditingSemantics.ink),
			caret: style.read(KlpEditingSemantics.caret),
			selection: style.read(KlpEditingSemantics.selection),
			fontFamily: style.read(KlpEditingSemantics.fontFamily),
			fontWeight: style.read(KlpEditingSemantics.fontWeight),
			fontSize: style.read(KlpEditingSemantics.fontSize),
			lineHeight: style.read(KlpEditingSemantics.lineHeight),
			letterSpacing: style.read(KlpEditingSemantics.letterSpacing),
			horizontalPadding: KlpEditingSemantics.resolveHorizontalPadding(style.read(KlpEditingSemantics.horizontalPadding)),
			verticalPadding: KlpEditingSemantics.resolveVerticalPadding(style.read(KlpEditingSemantics.verticalPadding)),
			blockSpacing: style.read(KlpEditingSemantics.blockSpacing),
			overscan: style.read(KlpEditingSemantics.overscan),
			listIndent: style.read(KlpEditingSemantics.listIndent),
			markerGap: style.read(KlpEditingSemantics.markerGap),
			marker: style.read(KlpEditingSemantics.marker),
			minimumBodyEm: KlpEditingSemantics.minimumBodyEm,
			dragAutoScrollEdge: style.read(KlpEditingSemantics.dragAutoScrollEdge),
			dragAutoScrollStep: style.read(KlpEditingSemantics.dragAutoScrollStep),
			dragAutoScrollInterval: style.read(KlpEditingSemantics.dragAutoScrollInterval),
			control: KlpBoundControlStyle(
				density: density,
				radius: style.read(KlpEditingSemantics.controlRadius),
				background: style.read(KlpEditingSemantics.controlBackground),
				focus: style.read(KlpEditingSemantics.controlFocus),
				text: KlpBoundTextStyle(
					color: style.read(KlpEditingSemantics.text),
					fontSize: controlFont,
					fontFamily: style.read(KlpEditingSemantics.fontFamily),
					fontWeight: style.read(KlpEditingSemantics.fontWeight),
					lineHeight: KlpLineHeight(density.lineHeight / controlFont.value),
					letterSpacing: style.read(KlpEditingSemantics.letterSpacing),
				),
			),
		));
	}
}
