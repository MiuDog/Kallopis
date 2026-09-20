part of '../klp_anchored_popup.dart';

final class _KlpAnchoredPopupLayout extends SingleChildLayoutDelegate {
	const _KlpAnchoredPopupLayout({required this.anchor, required this.direction, required this.inset});

	final Rect anchor;
	final TextDirection direction;
	final double inset;

	@override
	BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
		return BoxConstraints(
			maxWidth: math.max(0, constraints.maxWidth - inset * 2),
			maxHeight: math.max(0, constraints.maxHeight - inset * 2),
		);
	}

	@override
	Offset getPositionForChild(Size size, Size childSize) {
		final start = direction == TextDirection.ltr ? anchor.left : anchor.right - childSize.width;
		final availableBelow = size.height - inset - anchor.bottom;
		final top = childSize.height > availableBelow ? anchor.top - childSize.height : anchor.bottom;
		final maxX = math.max(inset, size.width - inset - childSize.width);
		final maxY = math.max(inset, size.height - inset - childSize.height);
		return Offset(start.clamp(inset, maxX), top.clamp(inset, maxY));
	}

	@override
	bool shouldRelayout(covariant _KlpAnchoredPopupLayout oldDelegate) {
		return oldDelegate.anchor != anchor || oldDelegate.direction != direction || oldDelegate.inset != inset;
	}
}
