part of '../klp_toggle.dart';

@immutable
class _KlpToggleIndicatorStyle {
  const _KlpToggleIndicatorStyle._({
    required this.width,
    required this.height,
    required this.inset,
    required this.thumb,
    required this.trackRadius,
    required this.thumbRadius,
    required this.trackColor,
    required this.thumbColor,
    required this.alignment,
  });

  final double width;
  final double height;
  final double inset;
  final double thumb;
  final double trackRadius;
  final double thumbRadius;
  final Color trackColor;
  final Color thumbColor;
  final Alignment alignment;

  factory _KlpToggleIndicatorStyle.resolve(
    KlpTheme klp, {
    required bool value,
    required bool enabled,
  }) {
    final colors = klp.color;
    final trackColor = switch ((enabled, value)) {
      (false, _) => colors.component,
      (true, true) => colors.selection,
      (true, false) => colors.surfaceMuted,
    };
    final thumbColor = switch ((enabled, value)) {
      (false, _) => colors.textFaint,
      (true, true) => colors.onSelection,
      (true, false) => colors.textMuted,
    };
    return _KlpToggleIndicatorStyle._(
      width: klp.geometry.control.toggleWidth,
      height: klp.geometry.control.toggleHeight,
      inset: klp.geometry.control.toggleInset,
      thumb: klp.geometry.control.toggleThumb,
      trackRadius: klp.shape.toggleTrack,
      thumbRadius: klp.shape.sm,
      trackColor: trackColor,
      thumbColor: thumbColor,
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
