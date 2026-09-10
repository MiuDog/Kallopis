part of '../klp_checkbox.dart';

class _KlpCheckboxFrame extends StatelessWidget {
  const _KlpCheckboxFrame({
    required this.value,
    required this.label,
    required this.onPressed,
    required this.style,
  });

  final bool value;
  final String label;
  final VoidCallback? onPressed;
  final _KlpCheckboxStyle style;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      enabled: onPressed != null,
      label: label,
      child: Material(
        color: style.clearColor,
        borderRadius: BorderRadius.circular(style.controlRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(style.controlRadius),
          child: AnimatedContainer(
            duration: style.duration,
            width: style.controlExtent,
            height: style.controlExtent,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: value ? style.activeColor : null,
              border: Border.all(
                color: value ? style.activeColor : style.inactiveBorderColor,
                width: style.strokeWidth,
              ),
              borderRadius: BorderRadius.circular(style.indicatorRadius),
            ),
            child: value
                ? KlpIcon(
                    KlpIcons.check,
                    size: style.iconExtent,
                    color: style.checkColor,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
