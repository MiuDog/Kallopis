part of '../klp_radio_group.dart';

class _KlpRadioItemFrame extends StatelessWidget {
  const _KlpRadioItemFrame({
    required this.label,
    required this.onPressed,
    required this.style,
    required this.child,
  });

  final String label;
  final VoidCallback onPressed;
  final _KlpRadioItemStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KlpPressable(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(style.controlRadius),
      child: KlpBox(
        insets: KlpBoxInsets.uniform(style.contentInset),
        child: child,
      ),
    );
  }
}
