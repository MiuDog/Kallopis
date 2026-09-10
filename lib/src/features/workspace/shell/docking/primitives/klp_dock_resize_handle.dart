part of '../klp_dock_layout.dart';

class _KlpDockResizeHandle extends StatelessWidget {
  final Axis axis;
  final ValueChanged<Offset> onPosition;
  final bool showIndicator;

  const _KlpDockResizeHandle({
    super.key,
    required this.axis,
    required this.onPosition,
    this.showIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final isHorizontal = axis == Axis.horizontal;
    final lineLength = context.klp.space.loose - context.klp.space.tight;

    return MouseRegion(
      cursor: isHorizontal
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: isHorizontal
            ? (details) => onPosition(details.globalPosition)
            : null,
        onVerticalDragUpdate: isHorizontal
            ? null
            : (details) => onPosition(details.globalPosition),
        child: SizedBox(
          width: isHorizontal
              ? context.klp.geometry.layout.resizeHandleExtent
              : null,
          height: isHorizontal
              ? null
              : context.klp.geometry.layout.resizeHandleExtent,
          child: showIndicator
              ? Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.klpColors.border,
                      borderRadius: BorderRadius.circular(
                        context.klp.shape.stroke,
                      ),
                    ),
                    child: SizedBox(
                      width: isHorizontal
                          ? context.klp.space.hairline
                          : lineLength,
                      height: isHorizontal
                          ? lineLength
                          : context.klp.space.hairline,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
