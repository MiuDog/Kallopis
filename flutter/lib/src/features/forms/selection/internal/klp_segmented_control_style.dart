part of '../klp_segmented_control.dart';

class _KlpSegmentedControlStyle {
  const _KlpSegmentedControlStyle({
    required this.background,
    required this.height,
    required this.inset,
    required this.radius,
  });

  final Color background;
  final double? height;
  final double inset;
  final double radius;

  factory _KlpSegmentedControlStyle.resolve(
    KlpTheme klp, {
    required bool dense,
  }) {
    return _KlpSegmentedControlStyle(
      background: klp.color.interactionSoft,
      height: dense ? klp.geometry.control.segmentedDenseHeight : null,
      inset: dense ? klp.geometry.control.segmentedDenseInset : klp.space.tight,
      radius: klp.shape.card,
    );
  }
}
