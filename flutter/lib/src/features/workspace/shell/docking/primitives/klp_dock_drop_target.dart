part of '../klp_dock_layout.dart';

class _KlpDockDropTarget extends StatelessWidget {
  const _KlpDockDropTarget({
    this.hitTestBehavior = HitTestBehavior.translucent,
    this.onWillAcceptWithDetails,
    this.onMove,
    this.onLeave,
    this.onAcceptWithDetails,
    required this.builder,
  });

  final HitTestBehavior hitTestBehavior;
  final bool Function(BuildContext, DragTargetDetails<_KlpDockPanelDragData>)?
  onWillAcceptWithDetails;
  final void Function(BuildContext, DragTargetDetails<_KlpDockPanelDragData>)?
  onMove;
  final void Function(BuildContext, _KlpDockPanelDragData?)? onLeave;
  final void Function(BuildContext, DragTargetDetails<_KlpDockPanelDragData>)?
  onAcceptWithDetails;
  final DragTargetBuilder<_KlpDockPanelDragData> builder;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (targetContext) => DragTarget<_KlpDockPanelDragData>(
        hitTestBehavior: hitTestBehavior,
        onWillAcceptWithDetails: onWillAcceptWithDetails == null
            ? null
            : (details) => onWillAcceptWithDetails!(targetContext, details),
        onMove: onMove == null
            ? null
            : (details) => onMove!(targetContext, details),
        onLeave: onLeave == null
            ? null
            : (data) => onLeave!(targetContext, data),
        onAcceptWithDetails: onAcceptWithDetails == null
            ? null
            : (details) => onAcceptWithDetails!(targetContext, details),
        builder: builder,
      ),
    );
  }
}
