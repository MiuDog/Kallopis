part of '../klp_slider.dart';

class _KlpSliderStyle {
	const _KlpSliderStyle({
		required this.activeTrackColor,
		required this.inactiveTrackColor,
		required this.overlayColor,
		required this.trackHeight,
	});

	final Color activeTrackColor;
	final Color inactiveTrackColor;
	final Color overlayColor;
	final double trackHeight;

	factory _KlpSliderStyle.resolve(KlpTheme klp) {
		return _KlpSliderStyle(
			activeTrackColor: klp.color.interaction,
			inactiveTrackColor: klp.color.surfaceInset,
			overlayColor: klp.color.clear,
			trackHeight: klp.geometry.control.sliderTrackHeight,
		);
	}
}
