part of '../klp_phase_toggle.dart';

@immutable
class _KlpPhaseToggleStyle {
  const _KlpPhaseToggleStyle._({
    required this.segmentExtent,
    required this.totalWidth,
    required this.totalHeight,
    required this.padding,
    required this.trackRadius,
    required this.selectionRadius,
    required this.trackColor,
    required this.border,
    required this.activeBackground,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.danger,
    required this.success,
    required this.onActiveBackground,
    required this.positionDuration,
    required this.styleDuration,
    required this.positionCurve,
  });

  final double segmentExtent;
  final double totalWidth;
  final double totalHeight;
  final EdgeInsets padding;
  final double trackRadius;
  final double selectionRadius;
  final Color trackColor;
  final Border border;
  final Color activeBackground;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color danger;
  final Color success;
  final Color onActiveBackground;
  final Duration positionDuration;
  final Duration styleDuration;
  final Curve positionCurve;

  factory _KlpPhaseToggleStyle.resolve(
    KlpTheme klp, {
    required int optionCount,
    required bool enabled,
    required KlpFeedbackTone? selectedTone,
  }) {
    final colors = klp.color;
    final segmentExtent = klp.space.controlHeightXSmall;
    final paddingExtent = klp.space.hairline * 2;
    final borderExtent = klp.shape.hairline * 2;
    var activeBackground = colors.text;
    if (!enabled) {
      activeBackground = colors.text.withValues(
        alpha: klp.surface.statusFillOpacity,
      );
    } else if (selectedTone != null) {
      activeBackground = switch (selectedTone) {
        KlpFeedbackTone.success => colors.success,
        KlpFeedbackTone.warning => colors.warning,
        KlpFeedbackTone.danger => colors.danger,
        KlpFeedbackTone.info => colors.info,
        KlpFeedbackTone.neutral => colors.text,
      };
    }
    final onActiveBackground = switch (selectedTone) {
      KlpFeedbackTone.success ||
      KlpFeedbackTone.danger ||
      KlpFeedbackTone.info => klp.byBrightness(
        light: colors.surface,
        dark: colors.text,
      ),
      KlpFeedbackTone.warning => klp.byBrightness(
        light: colors.text,
        dark: colors.surface,
      ),
      KlpFeedbackTone.neutral || null => colors.onBackground(colors.text).text,
    };
    return _KlpPhaseToggleStyle._(
      segmentExtent: segmentExtent,
      totalWidth:
          segmentExtent * optionCount + paddingExtent * 2 + borderExtent,
      totalHeight: segmentExtent + paddingExtent * 2 + borderExtent,
      padding: EdgeInsets.all(paddingExtent),
      trackRadius: klp.shape.control,
      selectionRadius: klp.shape.controlInner,
      trackColor: colors.surfaceInset,
      border: Border.all(color: colors.border, width: klp.shape.hairline),
      activeBackground: activeBackground,
      text: colors.text,
      textMuted: colors.textMuted,
      textFaint: colors.textFaint,
      danger: colors.danger,
      success: colors.success,
      onActiveBackground: onActiveBackground,
      positionDuration: klp.motion.stateTransition,
      styleDuration: klp.motion.styleTransition,
      positionCurve: Curves.easeOutCubic,
    );
  }

  Color foregroundFor(
    KlpFeedbackTone? tone, {
    required bool selected,
    required bool enabled,
  }) {
    if (!enabled) return textFaint;
    if (selected) return onActiveBackground;
    if (tone == KlpFeedbackTone.danger) return danger;
    if (tone == KlpFeedbackTone.success) return success;
    return textMuted;
  }
}
