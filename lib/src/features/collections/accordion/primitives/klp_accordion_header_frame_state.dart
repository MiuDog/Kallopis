part of '../klp_accordion.dart';

class _KlpAccordionHeaderFrameState
		extends State<_KlpAccordionHeaderFrame> {
	bool _hovered = false;
	bool _focused = false;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final isHighlighted = _hovered || _focused;

		return Material(
			color: isHighlighted ? klp.selectionWash : klp.color.clear,
			borderRadius: BorderRadius.circular(klp.shape.control),
			child: InkWell(
				onTap: widget.onTap,
				onHover: (value) => setState(() => _hovered = value),
				onFocusChange: (value) => setState(() => _focused = value),
				overlayColor: WidgetStatePropertyAll(klp.color.clear),
				borderRadius: BorderRadius.circular(klp.shape.control),
				child: Semantics(
					button: true,
					expanded: widget.expanded,
					child: Padding(
						padding: EdgeInsets.symmetric(
							horizontal: klp.space.controlInset,
							vertical: klp.space.controlInset,
						),
						child: widget.child,
					),
				),
			),
		);
	}
}
