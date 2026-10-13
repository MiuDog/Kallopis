part of '../klp_canvas_workspace.dart';

class _KlpCanvasDropIntentFrame extends StatelessWidget {
  const _KlpCanvasDropIntentFrame({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Semantics(
      liveRegion: true,
      label: label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: klp.color.interaction,
            width: klp.shape.hairline,
          ),
        ),
        child: child,
      ),
    );
  }
}
