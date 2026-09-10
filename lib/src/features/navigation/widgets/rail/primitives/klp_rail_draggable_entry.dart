part of '../klp_navigation_rail.dart';

class _KlpRailDraggableEntry extends StatelessWidget {
	const _KlpRailDraggableEntry({
		required this.data,
		required this.targetIndex,
		required this.onWillAccept,
		required this.onDropIndexChanged,
		required this.onAccepted,
		required this.onDragStarted,
		required this.onDragEnded,
		required this.item,
	});

	final _KlpRailDragData data;
	final int targetIndex;
	final bool Function(_KlpRailDragData) onWillAccept;
	final ValueChanged<int> onDropIndexChanged;
	final ValueChanged<_KlpRailDragData> onAccepted;
	final VoidCallback onDragStarted;
	final VoidCallback onDragEnded;
	final Widget item;

	void _showDropIndex(BuildContext targetContext, Offset globalPosition) {
		final box = targetContext.findRenderObject() as RenderBox?;
		if (box == null || !box.hasSize) return;
		final dragCenter = globalPosition.translate(
			0,
			targetContext.klp.space.railItem / 2,
		);
		final localPosition = box.globalToLocal(dragCenter);
		onDropIndexChanged(
			localPosition.dy < box.size.height / 2 ? targetIndex : targetIndex + 1,
		);
	}

	@override
	Widget build(BuildContext context) {
		return Builder(
			builder: (targetContext) {
				return DragTarget<_KlpRailDragData>(
					onWillAcceptWithDetails: (details) => onWillAccept(details.data),
					onMove: (details) => _showDropIndex(targetContext, details.offset),
					onAcceptWithDetails: (details) => onAccepted(details.data),
					builder: (context, candidateData, rejectedData) {
						return Draggable<_KlpRailDragData>(
							data: data,
							axis: Axis.vertical,
							onDragStarted: onDragStarted,
							onDragEnd: (_) => onDragEnded(),
							onDraggableCanceled: (_, _) => onDragEnded(),
							feedback: ExcludeSemantics(
								child: IgnorePointer(
									child: Material(
										type: MaterialType.transparency,
										child: item,
									),
								),
							),
							childWhenDragging: SizedBox.square(
								dimension: context.klp.space.railItem,
							),
							child: item,
						);
					},
				);
			},
		);
	}
}
