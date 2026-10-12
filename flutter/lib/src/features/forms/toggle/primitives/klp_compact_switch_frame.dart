part of '../klp_switch.dart';

class _KlpCompactSwitchFrame extends StatelessWidget {
  const _KlpCompactSwitchFrame({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onPressed,
    required this.style,
  });

  final String label;
  final bool value;
  final bool enabled;
  final VoidCallback? onPressed;
  final _KlpCompactSwitchStyle style;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: value,
      enabled: enabled,
      label: label,
      child: KlpPressable(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(style.radius),
        child: SizedBox(
          width: style.trackWidth,
          height: style.trackHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: style.trackColor,
              borderRadius: BorderRadius.circular(style.radius),
            ),
            child: AnimatedAlign(
              duration: style.duration,
              curve: style.curve,
              alignment: style.alignment,
              child: Padding(
                padding: EdgeInsets.all(style.inset),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: style.thumbColor,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(dimension: style.thumb),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
