part of '../klp_switch.dart';

@immutable
class _KlpCompactSwitchStyle {
  const _KlpCompactSwitchStyle._({
    required this.trackWidth,
    required this.trackHeight,
    required this.thumb,
    required this.inset,
    required this.radius,
    required this.trackColor,
    required this.thumbColor,
    required this.alignment,
    required this.duration,
    required this.curve,
  });

  final double trackWidth;
  final double trackHeight;
  final double thumb;
  final double inset;
  final double radius;
  final Color trackColor;
  final Color thumbColor;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;

  factory _KlpCompactSwitchStyle.resolve(KlpTheme klp, {required bool value}) {
    final colors = klp.color;
    return _KlpCompactSwitchStyle._(
      trackWidth: klp.geometry.control.switchTrackWidth,
      trackHeight: klp.geometry.control.switchTrackHeight,
      thumb: klp.geometry.control.switchThumb,
      inset: klp.space.space0_5,
      radius: klp.shape.pill,
      trackColor: value ? colors.selectionBackground : colors.surfaceMuted,
      thumbColor: value ? colors.selectionForeground : colors.textFaint,
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      duration: klp.motion.stateTransition,
      curve: Curves.easeOut,
    );
  }
}
