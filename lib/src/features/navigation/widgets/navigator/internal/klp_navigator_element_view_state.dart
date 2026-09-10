part of '../klp_navigator.dart';

class _KlpNavigatorElementViewState extends State<_KlpNavigatorElementView> {
	bool _isHovered = false;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final scope = _KlpNavigatorScope.of(context);
		final element = widget.element;
		final isExpanded = scope.expandedElementIds.contains(element.id);
		final isSelected = scope.selectedElementId == element.id;
		final rowHeight = element.isBranch
			? klp.space.controlHeightXSmall
			: klp.space.controlHeightXSmall + klp.geometry.control.fileExplorerRowHeightAdjustment;

		Widget row = KlpBox(
			height: rowHeight,
			insets: KlpBoxInsets.directional(end: klp.space.tight),
			child: _KlpNavigatorElementRow(
				element: element,
				level: widget.level,
				isExpanded: isExpanded,
				isSelected: isSelected,
				onToggle: () => scope.onElementToggle(element.id),
			),
		);

		row = KlpStateHighlight(
			state: isSelected || _isHovered ? KlpHighlightState.hover : KlpHighlightState.none,
			child: row,
		);

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			mainAxisSize: MainAxisSize.min,
			children: [
				_KlpNavigatorInteractiveRow(
					onHoverChanged: (value) => setState(() => _isHovered = value),
					onTap: () {
						if (element.isBranch) scope.onElementToggle(element.id);
						scope.onElementSelected(element.id);
					},
					child: row,
				),
				if (element.isBranch && isExpanded)
					for (final child in element.children)
						_KlpNavigatorElementView(element: child, level: widget.level + 1),
			],
		);
	}
}
