part of '../klp_select.dart';

class _KlpSelectStyle {
  const _KlpSelectStyle({
    required this.clearColor,
    required this.iconColor,
    required this.radius,
    required this.height,
    required this.horizontalInset,
  });

  final Color clearColor;
  final Color iconColor;
  final double radius;
  final double height;
  final double horizontalInset;

  factory _KlpSelectStyle.resolve(KlpTheme klp, {required bool enabled}) {
    return _KlpSelectStyle(
      clearColor: klp.color.clear,
      iconColor: enabled ? klp.color.textMuted : klp.color.textFaint,
      radius: klp.shape.control,
      height: klp.geometry.control.fieldHeight,
      horizontalInset: klp.space.base,
    );
  }
}
