part of '../klp_oklch_color_picker.dart';

class _KlpOklchPlaneStyle {
	const _KlpOklchPlaneStyle({
		required this.radius,
		required this.borderColor,
		required this.borderWidth,
		required this.cursorRadius,
		required this.cursorWidth,
	});

	final double radius;
	final Color borderColor;
	final double borderWidth;
	final double cursorRadius;
	final double cursorWidth;

	factory _KlpOklchPlaneStyle.resolve(KlpTheme klp, {required bool focused}) {
		return _KlpOklchPlaneStyle(
			radius: klp.shape.card,
			borderColor: focused ? klp.color.interaction : klp.color.border,
			borderWidth: focused ? klp.shape.stroke : klp.shape.hairline,
			cursorRadius: klp.geometry.control.colorPickerCursorRadius,
			cursorWidth: klp.shape.stroke,
		);
	}
}
