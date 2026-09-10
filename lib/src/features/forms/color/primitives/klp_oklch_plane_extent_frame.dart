part of '../klp_oklch_color_picker.dart';

class _KlpOklchPlaneExtentFrame extends StatelessWidget {
  const _KlpOklchPlaneExtentFrame({required this.style, required this.child});

  final _KlpOklchColorPickerStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(dimension: style.planeExtent, child: child);
  }
}
