part of '../klp_navigation_rail.dart';

class _KlpRailDropSlot extends StatelessWidget {
  const _KlpRailDropSlot({
    required this.active,
    required this.onWillAccept,
    required this.onMove,
    required this.onAccepted,
  });

  final bool active;
  final bool Function(_KlpRailDragData) onWillAccept;
  final VoidCallback onMove;
  final ValueChanged<_KlpRailDragData> onAccepted;

  @override
  Widget build(BuildContext context) {
    return DragTarget<_KlpRailDragData>(
      onWillAcceptWithDetails: (details) => onWillAccept(details.data),
      onMove: (_) => onMove(),
      onAcceptWithDetails: (details) => onAccepted(details.data),
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          width: context.klp.space.railItem,
          height: context.klp.geometry.layout.railDropTargetExtent,
          child: Center(
            child: AnimatedOpacity(
              opacity: active ? 1 : 0,
              duration: context.klp.motion.stateTransition,
              curve: context.klp.motion.standard,
              child: const KlpDropIndicator(),
            ),
          ),
        );
      },
    );
  }
}
