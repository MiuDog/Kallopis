part of '../klp_sliding_selection.dart';

class _KlpSlidingSelectionStyle {
	const _KlpSlidingSelectionStyle({
		required this.toneColors,
		required this.surfaceColor,
		required this.dividerColor,
		required this.mutedColor,
		required this.clearColor,
		required this.controlHeight,
		required this.segmentWidth,
		required this.padding,
		required this.borderWidth,
		required this.indicatorHeight,
		required this.controlRadius,
		required this.indicatorRadius,
		required this.statusFillOpacity,
		required this.stateDuration,
		required this.styleDuration,
		required this.curve,
	});

	final Map<KlpSelectionTone, Color> toneColors;
	final Color surfaceColor;
	final Color dividerColor;
	final Color mutedColor;
	final Color clearColor;
	final double controlHeight;
	final double segmentWidth;
	final double padding;
	final double borderWidth;
	final double indicatorHeight;
	final double controlRadius;
	final double indicatorRadius;
	final double statusFillOpacity;
	final Duration stateDuration;
	final Duration styleDuration;
	final Curve curve;

	double totalWidth(int optionCount) => segmentWidth * optionCount + padding * 2 + borderWidth * 2;

	Color toneColor(KlpSelectionTone tone) => toneColors[tone] ?? mutedColor;

	factory _KlpSlidingSelectionStyle.resolve(KlpTheme klp) {
		return _KlpSlidingSelectionStyle(
			toneColors: {
				KlpSelectionTone.primary: klp.color.interaction,
				KlpSelectionTone.info: klp.color.info,
				KlpSelectionTone.success: klp.color.success,
				KlpSelectionTone.warning: klp.color.warning,
				KlpSelectionTone.danger: klp.color.danger,
			},
			surfaceColor: klp.color.surfaceInset,
			dividerColor: klp.color.divider,
			mutedColor: klp.color.textMuted,
			clearColor: klp.color.clear,
			controlHeight: klp.geometry.control.slidingSelectionHeight,
			segmentWidth: klp.geometry.control.slidingSelectionSegmentWidth,
			padding: klp.geometry.control.slidingSelectionPadding,
			borderWidth: klp.shape.hairline,
			indicatorHeight: klp.geometry.control.slidingSelectionIndicatorHeight,
			controlRadius: klp.shape.control,
			indicatorRadius: klp.shape.controlInner,
			statusFillOpacity: klp.surface.statusFillOpacity,
			stateDuration: klp.motion.stateTransition,
			styleDuration: klp.motion.styleTransition,
			curve: klp.motion.standard,
		);
	}
}
