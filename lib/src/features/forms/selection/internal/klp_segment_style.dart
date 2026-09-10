part of '../klp_segmented_control.dart';

class _KlpSegmentStyle {
	const _KlpSegmentStyle({
		required this.background,
		required this.clearColor,
		required this.iconColor,
		required this.radius,
		required this.height,
		required this.horizontalInset,
		required this.verticalInset,
	});

	final Color background;
	final Color clearColor;
	final Color iconColor;
	final double radius;
	final double? height;
	final double horizontalInset;
	final double verticalInset;

	factory _KlpSegmentStyle.resolve(KlpTheme klp, {required bool selected, required bool hovered, required bool dense}) {
		final background = selected
				? klp.color.component
				: hovered
				? klp.selectionWash
				: klp.color.clear;
		return _KlpSegmentStyle(
			background: background,
			clearColor: klp.color.clear,
			iconColor: selected ? klp.color.text : klp.color.textMuted,
			radius: klp.shape.control,
			height: dense ? klp.geometry.control.segmentedDenseItemHeight : null,
			horizontalInset: klp.space.base,
			verticalInset: dense ? klp.geometry.control.segmentedDenseContentInset : klp.space.controlInset,
		);
	}
}
