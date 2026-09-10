part of '../klp_oklch_color_picker.dart';

class _KlpOklchColorPickerStyle {
	const _KlpOklchColorPickerStyle({
		required this.planeExtent,
		required this.previewHeight,
		required this.previewRadius,
		required this.previewBorderColor,
		required this.previewBorderWidth,
	});

	final double planeExtent;
	final double previewHeight;
	final double previewRadius;
	final Color previewBorderColor;
	final double previewBorderWidth;

	factory _KlpOklchColorPickerStyle.resolve(
		KlpTheme klp,
		BoxConstraints constraints,
	) {
		return _KlpOklchColorPickerStyle(
			planeExtent: math.min(
				klp.geometry.control.colorPlaneExtent,
				constraints.maxWidth,
			),
			previewHeight: klp.space.controlHeightXLarge,
			previewRadius: klp.shape.card,
			previewBorderColor: klp.color.border,
			previewBorderWidth: klp.shape.hairline,
		);
	}
}
