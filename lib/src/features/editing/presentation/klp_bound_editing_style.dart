import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_draw_command.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_style.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_control_style.dart';

/// 僅供本庫繫結階段建立，提供者不能指定任何局部色彩。
final class KlpBoundEditingStyle {

	final KlpColor text;
	final KlpColor ink;
	final KlpColor caret;
	final KlpColor selection;
	final KlpFontFamily fontFamily;
	final KlpFontWeight fontWeight;
	final KlpFontSize fontSize;
	final KlpLineHeight lineHeight;
	final KlpLetterSpacing letterSpacing;
	final KlpDistance horizontalPadding;
	final KlpDistance verticalPadding;
	final KlpDistance blockSpacing;
	final KlpDistance overscan;
	final KlpDistance listIndent;
	final KlpDistance markerGap;
	final KlpColor marker;
	final double minimumBodyEm;
	final KlpDistance dragAutoScrollEdge;
	final KlpDistance dragAutoScrollStep;
	final KlpDuration dragAutoScrollInterval;
	final KlpBoundControlStyle control;

	KlpBoundEditingStyle({
		required this.text,
		required this.ink,
		required this.caret,
		required this.selection,
		required this.fontFamily,
		required this.fontWeight,
		required this.fontSize,
		required this.lineHeight,
		required this.letterSpacing,
		required this.horizontalPadding,
		required this.verticalPadding,
		required this.blockSpacing,
		required this.overscan,
		required this.listIndent,
		required this.markerGap,
		required this.marker,
		required this.minimumBodyEm,
		required this.dragAutoScrollEdge,
		required this.dragAutoScrollStep,
		required this.dragAutoScrollInterval,
		required this.control,
	}) {
		if (dragAutoScrollEdge.value <= 0 || dragAutoScrollStep.value <= 0 || dragAutoScrollInterval.milliseconds <= 0) throw ArgumentError('Invalid editing drag auto-scroll semantic');
	}

	KlpEditingStyle get core => KlpEditingStyle(
		fontFamily: fontFamily.family,
		fontFallbacks: fontFamily.fallback,
		fontWeight: fontWeight.value,
		fontSize: fontSize.value,
		lineHeight: fontSize.value * lineHeight.value,
		letterSpacing: letterSpacing.value,
		horizontalPadding: horizontalPadding.value,
		verticalPadding: verticalPadding.value,
		blockSpacing: blockSpacing.value,
		overscan: overscan.value,
		textRgba: _rgba(text),
		inkRgba: _rgba(ink),
		caretRgba: _rgba(caret),
		listIndent: listIndent.value,
		markerGap: markerGap.value,
		minimumBodyEm: minimumBodyEm,
		markerRgba: _rgba(marker),
		markerFormat: KlpEditingMarkerFormat.bulletAndDecimal,
	);

	int _rgba(KlpColor color) => color.alpha << 24 | color.red << 16 | color.green << 8 | color.blue;

	KlpColor color(KlpEditingPaintRole role) => switch (role) {
		KlpEditingPaintRole.text => text,
		KlpEditingPaintRole.ink => ink,
		KlpEditingPaintRole.caret => caret,
		KlpEditingPaintRole.selection => selection,
		KlpEditingPaintRole.listMarker => marker,
	};
}
