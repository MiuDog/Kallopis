import 'package:flutter/material.dart';

import '../../interaction/klp_drag_drop.dart';
import '../../theme/klp_theme.dart';
import 'klp_rail_divider.dart';
import 'klp_rail_entry.dart';
import 'klp_rail_item_group.dart';

/// Workbench 的主要圖示導覽軌。
///
/// 分組模式只接受 [KlpRailItemGroup]；群組之間自動加入分隔線，項目只能在
/// 原群組內排序。
class KlpNavigationRail extends StatefulWidget {
	const KlpNavigationRail({
		super.key,
		required this.top,
		required this.center,
		required this.bottom,
	});

	final KlpRailItemGroup top;
	final KlpRailItemGroup center;
	final KlpRailItemGroup bottom;

	@override
	State<KlpNavigationRail> createState() => _KlpNavigationRailState();
}

enum _KlpRailGroupSlot { top, center, bottom }

class _KlpRailDragData {
	final _KlpRailGroupSlot slot;
	final int sourceIndex;

	const _KlpRailDragData(this.slot, this.sourceIndex);
}

class _KlpNavigationRailState extends State<KlpNavigationRail> {
	_KlpRailGroupSlot? _dragSlot;
	int? _dropIndex;

	bool _accepts(
		_KlpRailGroupSlot slot,
		KlpRailItemGroup group,
		_KlpRailDragData data,
	) {
		return group.isReorderable &&
			group.onReorder != null &&
			data.slot == slot &&
			data.sourceIndex >= 0 &&
			data.sourceIndex < group.items.length;
	}

	void _startDrag(_KlpRailGroupSlot slot, int index) {
		setState(() {
			_dragSlot = slot;
			_dropIndex = index;
		});
	}

	void _showDropIndex(int index) {
		if (_dropIndex == index) return;
		setState(() => _dropIndex = index);
	}

	void _showItemDrop(
		BuildContext targetContext,
		int targetIndex,
		Offset globalPosition,
	) {
		final box = targetContext.findRenderObject() as RenderBox?;
		if (box == null || !box.hasSize) return;
		final localPosition = box.globalToLocal(globalPosition);
		_showDropIndex(
			localPosition.dy < box.size.height / 2
				? targetIndex
				: targetIndex + 1,
		);
	}

	void _finishDrag(KlpRailItemGroup group, _KlpRailDragData data) {
		final insertionIndex = _dropIndex;
		if (insertionIndex != null) {
			var destinationIndex = insertionIndex;
			if (destinationIndex > data.sourceIndex) destinationIndex -= 1;
			if (destinationIndex != data.sourceIndex) {
				group.onReorder?.call(data.sourceIndex, destinationIndex);
			}
		}
		_clearDrag();
	}

	void _clearDrag() {
		if (!mounted || (_dragSlot == null && _dropIndex == null)) return;
		setState(() {
			_dragSlot = null;
			_dropIndex = null;
		});
	}

	Widget _buildDropSlot(
		BuildContext context,
		_KlpRailGroupSlot slot,
		KlpRailItemGroup group,
		int index,
	) {
		return DragTarget<_KlpRailDragData>(
			onWillAcceptWithDetails: (details) => _accepts(slot, group, details.data),
			onMove: (_) => _showDropIndex(index),
			onAcceptWithDetails: (details) => _finishDrag(group, details.data),
			builder: (context, candidateData, rejectedData) {
				return SizedBox(
					width: context.klp.space.railItem,
					height: context.klp.geometry.layout.railDropTargetExtent,
					child: Center(
						child: AnimatedOpacity(
							opacity: _dragSlot == slot && _dropIndex == index ? 1 : 0,
							duration: context.klp.motion.stateTransition,
							curve: context.klp.motion.standard,
							child: const KlpDropIndicator(thickness: 2),
						),
					),
				);
			},
		);
	}

	Widget _buildDraggableEntry(
		BuildContext context,
		_KlpRailGroupSlot slot,
		KlpRailItemGroup group,
		int index,
	) {
		final entry = group.items[index];
		final item = entry.build(context);
		final data = _KlpRailDragData(slot, index);

		return Builder(
			builder: (targetContext) {
				return DragTarget<_KlpRailDragData>(
					onWillAcceptWithDetails: (details) => _accepts(slot, group, details.data),
					onMove: (details) => _showItemDrop(
						targetContext,
						index,
						details.offset,
					),
					onAcceptWithDetails: (details) => _finishDrag(group, details.data),
					builder: (context, candidateData, rejectedData) {
						return Draggable<_KlpRailDragData>(
							data: data,
							axis: Axis.vertical,
							onDragStarted: () => _startDrag(slot, index),
							onDragEnd: (_) => _clearDrag(),
							onDraggableCanceled: (_, _) => _clearDrag(),
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

	Widget _buildGroup(
		BuildContext context,
		_KlpRailGroupSlot slot,
		KlpRailItemGroup group,
	) {
		if (group.items.isEmpty) return const SizedBox.shrink();
		if (!group.isReorderable || group.onReorder == null) {
			return _buildSpacedEntries(context, group.items);
		}

		return Column(
			mainAxisSize: MainAxisSize.min,
			children: [
				for (var index = 0; index < group.items.length; index++) ...[
					_buildDropSlot(context, slot, group, index),
					if (group.items[index].isDraggable) _buildDraggableEntry(context, slot, group, index)
					else group.items[index].build(context),
				],
				_buildDropSlot(context, slot, group, group.items.length),
			],
		);
	}

	Widget _buildSpacedEntries(BuildContext context, List<KlpRailEntry> entries) {
		return Column(
			mainAxisSize: MainAxisSize.min,
			children: [
				for (var index = 0; index < entries.length; index++) ...[
					entries[index].build(context),
					if (index < entries.length - 1)
						SizedBox(height: context.klp.space.navigationRailItemGap),
				],
			],
		);
	}

	Widget _buildGroupDivider(BuildContext context) {
		return Padding(
			padding: EdgeInsets.symmetric(vertical: context.klp.space.navigationRailInset),
			child: const KlpRailDivider(id: 'group-boundary').build(context),
		);
	}

	Widget _buildScrollableCenter(BuildContext context) {
		return LayoutBuilder(
			builder: (context, constraints) {
				return ScrollConfiguration(
					behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
					child: SingleChildScrollView(
						child: ConstrainedBox(
							constraints: BoxConstraints(minHeight: constraints.maxHeight),
							child: Align(
								alignment: Alignment.topCenter,
								child: _buildGroup(
									context,
									_KlpRailGroupSlot.center,
									widget.center,
								),
							),
						),
					),
				);
			},
		);
	}

	Widget _buildGroupedRail(BuildContext context) {
		return Padding(
			padding: EdgeInsets.all(context.klp.space.navigationRailInset),
			child: Column(
				children: [
					if (widget.top.items.isNotEmpty) ...[
						_buildGroup(context, _KlpRailGroupSlot.top, widget.top),
						_buildGroupDivider(context),
					],
					Expanded(
						child: _buildScrollableCenter(context),
					),
					if (widget.bottom.items.isNotEmpty) ...[
						_buildGroupDivider(context),
						_buildGroup(context, _KlpRailGroupSlot.bottom, widget.bottom),
					],
				],
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return _buildGroupedRail(context);
	}
}
