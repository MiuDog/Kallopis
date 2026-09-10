part of '../klp_preview_card.dart';

/// 預覽內容、標題與中繼資訊的通用卡片。
class KlpPreviewCard extends StatelessWidget {
	const KlpPreviewCard({
		super.key,
		required this.title,
		required this.preview,
		this.metadata = const [],
		this.previewSize = KlpPreviewCardSize.large,
	});

	final String title;
	final Widget preview;
	final List<String> metadata;
	final KlpPreviewCardSize previewSize;

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;

		return KlpSurface(
			tone: KlpSurfaceTone.base,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					_KlpPreviewCardViewport(size: previewSize, child: preview),
					KlpBox(
						insets: KlpBoxInsets.directional(
							start: space.contentInset,
							top: space.contentInset,
							end: space.contentInset,
							bottom: space.itemGap,
						),
						child: KlpColumn(
							children: [
								KlpText(title, role: KlpTextRole.body),
								if (metadata.isNotEmpty) ...[
									const KlpGap.heightSize(KlpSpaceSize.tight),
									KlpWrap(
										spacingSize: KlpSpaceSize.contentInline,
										runSpacingSize: KlpSpaceSize.hairline,
										children: [
											for (final item in metadata)
												KlpText(
													item,
													role: KlpTextRole.code,
													tone: KlpTextTone.faint,
												),
										],
									),
								],
							],
						),
					),
				],
			),
		);
	}
}
