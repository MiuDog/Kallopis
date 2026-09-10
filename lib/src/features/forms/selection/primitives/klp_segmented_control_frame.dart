part of '../klp_segmented_control.dart';

class _KlpSegmentedControlFrame extends StatelessWidget {
  const _KlpSegmentedControlFrame({required this.style, required this.child});

  final _KlpSegmentedControlStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: style.height,
      padding: EdgeInsets.all(style.inset),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(style.radius),
      ),
      child: child,
    );
  }
}
