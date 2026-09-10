part of '../klp_dock_layout.dart';

class _KlpDockPanelDraggable extends StatelessWidget {
  const _KlpDockPanelDraggable({
    required this.data,
    required this.feedback,
    required this.onDragFinished,
    required this.child,
  });

  final _KlpDockPanelDragData data;
  final Widget feedback;
  final VoidCallback onDragFinished;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Draggable<_KlpDockPanelDragData>(
        data: data,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        hitTestBehavior: HitTestBehavior.opaque,
        onDragEnd: (_) => onDragFinished(),
        onDraggableCanceled: (_, _) => onDragFinished(),
        feedback: ExcludeSemantics(
          child: IgnorePointer(
            child: Material(
              type: MaterialType.transparency,
              child: KlpDragPreview(child: feedback),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: context.klp.surface.dragSourceOpacity,
          child: child,
        ),
        child: child,
      ),
    );
  }
}
