part of '../klp_timeline.dart';

class _KlpTimelineRow extends StatelessWidget {
	const _KlpTimelineRow({
		required this.item,
		required this.isFirst,
		required this.isLast,
	});

	final KlpTimelineItemData item;
	final bool isFirst;
	final bool isLast;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return _KlpTimelineIntrinsicHeight(
			child: KlpRow(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					_KlpTimelineRail(
						marker: item.marker,
						highlighted: item.highlighted,
						isFirst: isFirst,
						isLast: isLast,
					),
					const KlpGap.widthSize(KlpSpaceSize.contentInline),
					KlpExpanded(
						child: KlpBox(
							insets: KlpBoxInsets.directional(
								bottom: klp.space.comfortable,
							),
							child: KlpColumn(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									KlpRow(
										children: [
											KlpExpanded(
												child: KlpText(
													item.title,
													role: KlpTextRole.bodyStrong,
												),
											),
											if (item.time != null) ...[
												const KlpGap.widthSize(
													KlpSpaceSize.contentInline,
												),
												KlpText(
													item.time!,
													role: KlpTextRole.code,
													tone: KlpTextTone.muted,
												),
											],
										],
									),
									if (item.content != null) ...[
										const KlpGap.heightSize(KlpSpaceSize.tight),
										item.content!,
									],
								],
							),
						),
					),
				],
			),
		);
	}
}
