part of '../klp_navigation_rail.dart';

class _KlpRailGroupView extends StatelessWidget {
  const _KlpRailGroupView({
    required this.slot,
    required this.group,
    required this.activeDropIndex,
    required this.onDropIndexChanged,
    required this.onDragStarted,
    required this.onDragEnded,
    required this.onAccepted,
  });

  final _KlpRailGroupSlot slot;
  final KlpRailItemGroup group;
  final int? activeDropIndex;
  final ValueChanged<int> onDropIndexChanged;
  final ValueChanged<int> onDragStarted;
  final VoidCallback onDragEnded;
  final ValueChanged<_KlpRailDragData> onAccepted;

  bool _accepts(_KlpRailDragData data) {
    return group.isReorderable &&
        group.onReorder != null &&
        data.slot == slot &&
        data.sourceIndex >= 0 &&
        data.sourceIndex < group.items.length;
  }

  @override
  Widget build(BuildContext context) {
    if (group.items.isEmpty) return const KlpBox.shrink();
    if (!group.isReorderable || group.onReorder == null) {
      return KlpColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < group.items.length; index++) ...[
            group.items[index].build(context),
            if (index < group.items.length - 1)
              const KlpGap.heightSize(KlpSpaceSize.navigationRailItem),
          ],
        ],
      );
    }

    return KlpColumn(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < group.items.length; index++) ...[
          _KlpRailDropSlot(
            active: activeDropIndex == index,
            onWillAccept: _accepts,
            onMove: () => onDropIndexChanged(index),
            onAccepted: onAccepted,
          ),
          if (group.items[index].isDraggable)
            _KlpRailDraggableEntry(
              data: _KlpRailDragData(slot, index),
              targetIndex: index,
              onWillAccept: _accepts,
              onDropIndexChanged: onDropIndexChanged,
              onAccepted: onAccepted,
              onDragStarted: () => onDragStarted(index),
              onDragEnded: onDragEnded,
              item: group.items[index].build(context),
            )
          else
            group.items[index].build(context),
        ],
        _KlpRailDropSlot(
          active: activeDropIndex == group.items.length,
          onWillAccept: _accepts,
          onMove: () => onDropIndexChanged(group.items.length),
          onAccepted: onAccepted,
        ),
      ],
    );
  }
}
