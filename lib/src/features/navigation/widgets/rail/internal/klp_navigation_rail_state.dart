part of '../klp_navigation_rail.dart';

class _KlpNavigationRailState extends State<KlpNavigationRail> {
	_KlpRailGroupSlot? _dragSlot;
	int? _dropIndex;

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

	@override
	Widget build(BuildContext context) {
		return _KlpNavigationRailLayout(
			top: _KlpRailGroupView(
				slot: _KlpRailGroupSlot.top,
				group: widget.top,
				activeDropIndex: _dragSlot == _KlpRailGroupSlot.top ? _dropIndex : null,
				onDropIndexChanged: _showDropIndex,
				onDragStarted: (index) => _startDrag(_KlpRailGroupSlot.top, index),
				onDragEnded: _clearDrag,
				onAccepted: (data) => _finishDrag(widget.top, data),
			),
			center: _KlpRailGroupView(
				slot: _KlpRailGroupSlot.center,
				group: widget.center,
				activeDropIndex: _dragSlot == _KlpRailGroupSlot.center ? _dropIndex : null,
				onDropIndexChanged: _showDropIndex,
				onDragStarted: (index) => _startDrag(_KlpRailGroupSlot.center, index),
				onDragEnded: _clearDrag,
				onAccepted: (data) => _finishDrag(widget.center, data),
			),
			bottom: _KlpRailGroupView(
				slot: _KlpRailGroupSlot.bottom,
				group: widget.bottom,
				activeDropIndex: _dragSlot == _KlpRailGroupSlot.bottom ? _dropIndex : null,
				onDropIndexChanged: _showDropIndex,
				onDragStarted: (index) => _startDrag(_KlpRailGroupSlot.bottom, index),
				onDragEnded: _clearDrag,
				onAccepted: (data) => _finishDrag(widget.bottom, data),
			),
			showTop: widget.top.items.isNotEmpty,
			showBottom: widget.bottom.items.isNotEmpty,
		);
	}
}
