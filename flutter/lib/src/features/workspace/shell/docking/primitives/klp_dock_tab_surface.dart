part of '../klp_dock_layout.dart';

class _KlpDockTabSurface extends StatelessWidget {
  const _KlpDockTabSurface({
    required this.selected,
    required this.onPressed,
    required this.child,
  });

  final bool selected;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.klp.shape.control);
    return Material(
      color: selected
          ? context.klpColors.surfaceMuted
          : context.klpColors.surfaceInset,
      borderRadius: radius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.klp.space.base),
          child: Center(child: child),
        ),
      ),
    );
  }
}
