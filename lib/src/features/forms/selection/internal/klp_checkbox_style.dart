part of '../klp_checkbox.dart';

class _KlpCheckboxStyle {
  const _KlpCheckboxStyle({
    required this.activeColor,
    required this.inactiveBorderColor,
    required this.checkColor,
    required this.clearColor,
    required this.controlExtent,
    required this.iconExtent,
    required this.controlRadius,
    required this.indicatorRadius,
    required this.strokeWidth,
    required this.verticalInset,
    required this.duration,
  });

  final Color activeColor;
  final Color inactiveBorderColor;
  final Color checkColor;
  final Color clearColor;
  final double controlExtent;
  final double iconExtent;
  final double controlRadius;
  final double indicatorRadius;
  final double strokeWidth;
  final double verticalInset;
  final Duration duration;

  factory _KlpCheckboxStyle.resolve(KlpTheme klp, {required bool enabled}) {
    final colors = klp.color;
    return _KlpCheckboxStyle(
      activeColor: enabled ? colors.text : colors.textMuted,
      inactiveBorderColor: enabled ? colors.textMuted : colors.textFaint,
      checkColor: colors.stageSurface,
      clearColor: colors.clear,
      controlExtent: klp.geometry.control.selectionControl,
      iconExtent: klp.geometry.control.selectionIcon,
      controlRadius: klp.shape.control,
      indicatorRadius: klp.shape.sm,
      strokeWidth: klp.shape.stroke,
      verticalInset: klp.space.tight,
      duration: klp.motion.styleTransition,
    );
  }
}
