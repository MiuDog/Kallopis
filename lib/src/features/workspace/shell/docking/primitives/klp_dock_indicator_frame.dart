part of '../klp_dock_layout.dart';

class _KlpDockIndicatorFrame extends StatelessWidget {
  const _KlpDockIndicatorFrame({
    this.width,
    this.height,
    this.centered = false,
  });

  final double? width;
  final double? height;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    Widget indicator = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.klp.primary,
        borderRadius: BorderRadius.circular(context.klp.shape.pill),
      ),
    );
    if (centered) indicator = Center(child: indicator);

    return IgnorePointer(child: indicator);
  }
}
