part of '../klp_canvas_workspace.dart';

class _KlpCanvasSelectionFrame extends StatelessWidget {
  const _KlpCanvasSelectionFrame({
    required this.selected,
    required this.showHandles,
    required this.child,
  });

  final bool selected;
  final bool showHandles;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: selected
                ? Border.all(
                    color: klp.color.selection,
                    width: klp.shape.hairline,
                  )
                : null,
          ),
          child: child,
        ),
        if (selected && showHandles)
          for (final alignment in const [
            Alignment.topLeft,
            Alignment.topRight,
            Alignment.bottomLeft,
            Alignment.bottomRight,
          ])
            Align(
              alignment: alignment,
              child: Container(
                width: klp.space.indicatorDot,
                height: klp.space.indicatorDot,
                decoration: BoxDecoration(
                  color: klp.color.stageSurface,
                  border: Border.all(
                    color: klp.color.selection,
                    width: klp.shape.hairline,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
