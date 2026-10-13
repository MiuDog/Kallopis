part of '../klp_canvas_workspace.dart';

class _KlpCanvasMinimapFrame extends StatelessWidget {
  const _KlpCanvasMinimapFrame({
    required this.label,
    required this.onPressed,
    required this.child,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: onPressed != null,
      child: GestureDetector(
        onTap: onPressed,
        child: KlpSurface(
          tone: KlpSurfaceTone.inset,
          padding: EdgeInsets.all(context.klp.space.tight),
          child: child,
        ),
      ),
    );
  }
}
