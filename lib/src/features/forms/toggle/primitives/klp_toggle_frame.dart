part of '../klp_toggle.dart';

class _KlpToggleFrame extends StatelessWidget {
  const _KlpToggleFrame({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onPressed,
    required this.style,
    required this.child,
  });

  final String label;
  final bool value;
  final bool enabled;
  final VoidCallback? onPressed;
  final _KlpToggleFrameStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      toggled: value,
      child: Material(
        color: style.clear,
        borderRadius: BorderRadius.circular(style.radius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(style.radius),
          overlayColor: WidgetStatePropertyAll(style.clear),
          child: child,
        ),
      ),
    );
  }
}
