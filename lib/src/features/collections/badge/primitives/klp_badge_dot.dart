part of '../klp_badge.dart';

class _KlpBadgeDot extends StatelessWidget {
	const _KlpBadgeDot({required this.color});

	final Color color;

	@override
	Widget build(BuildContext context) {
		final extent = context.klp.space.indicatorDot;

		return Container(
			width: extent,
			height: extent,
			decoration: BoxDecoration(
				color: color,
				shape: BoxShape.circle,
			),
		);
	}
}
