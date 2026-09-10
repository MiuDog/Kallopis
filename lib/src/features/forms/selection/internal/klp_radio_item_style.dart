part of '../klp_radio_group.dart';

class _KlpRadioItemStyle {
	const _KlpRadioItemStyle({
		required this.borderColor,
		required this.fillColor,
		required this.clearColor,
		required this.controlRadius,
		required this.controlExtent,
		required this.indicatorInset,
		required this.strokeWidth,
		required this.contentInset,
		required this.duration,
	});

	final Color borderColor;
	final Color fillColor;
	final Color clearColor;
	final double controlRadius;
	final double controlExtent;
	final double indicatorInset;
	final double strokeWidth;
	final double contentInset;
	final Duration duration;

	factory _KlpRadioItemStyle.resolve(KlpTheme klp, {required bool selected}) {
		return _KlpRadioItemStyle(
			borderColor: selected ? klp.color.text : klp.color.textMuted,
			fillColor: klp.color.text,
			clearColor: klp.color.clear,
			controlRadius: klp.shape.control,
			controlExtent: klp.geometry.control.selectionControl,
			indicatorInset: klp.geometry.control.selectionIndicatorInset,
			strokeWidth: klp.shape.stroke,
			contentInset: klp.space.tight,
			duration: klp.motion.styleTransition,
		);
	}
}
