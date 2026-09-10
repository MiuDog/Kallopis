part of '../klp_timeline.dart';

class _KlpTimelineRail extends StatelessWidget {
	const _KlpTimelineRail({
		required this.marker,
		required this.highlighted,
		required this.isFirst,
		required this.isLast,
	});

	final Widget? marker;
	final bool highlighted;
	final bool isFirst;
	final bool isLast;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final tokens = context.klpColors;
		final markerSize = klp.space.indicatorDotLarge;
		final textDefinition = KlpTextStyles.definitionOf(
			KlpTextRole.bodyStrong,
			klp.type,
		);
		final firstLineHeight = textDefinition.fontSize * textDefinition.lineHeight;
		final topOffset = ((firstLineHeight - markerSize) / 2).clamp(
			0.0,
			double.infinity,
		);

		return Column(
			children: [
				if (topOffset > 0)
					SizedBox(
						height: topOffset,
						width: klp.shape.hairline,
						child: !isFirst ? ColoredBox(color: tokens.divider) : null,
					),
				SizedBox(
					width: markerSize,
					height: markerSize,
					child: marker ??
							DecoratedBox(
								decoration: BoxDecoration(
									shape: BoxShape.circle,
									color: highlighted ? tokens.text : tokens.textFaint,
								),
							),
				),
				if (!isLast)
					Expanded(
						child: SizedBox(
							width: klp.shape.hairline,
							child: ColoredBox(color: tokens.divider),
						),
					),
			],
		);
	}
}
