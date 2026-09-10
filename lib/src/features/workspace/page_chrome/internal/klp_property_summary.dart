part of '../klp_page_chrome.dart';

/// 實體的屬性摘要卡片：一排狀態徽章、一排標籤，再加一行中繼資料文字，
/// 依序垂直排列。
///
/// 三段固定按這個順序（badges → tags → metadata）呈現，不是各自獨立可
/// 重排的插槽；若版面需要不同順序或省略某一段，請直接組合
/// [KlpBadge]／[KlpTag]／[KlpText] 而不是硬塞空清單進來。
class KlpPropertySummary extends StatelessWidget {
	const KlpPropertySummary({
		super.key,
		required this.badges,
		required this.tags,
		required this.metadata,
	});

	final List<KlpPropertyBadgeData> badges;
	final List<String> tags;
	final String metadata;

	@override
	Widget build(BuildContext context) {
		return KlpBox(
			tone: KlpSurfaceTone.component,
			paddingSize: KlpSpaceSize.base,
			child: KlpColumn(
				children: [
					KlpWrap(
						spacingSize: KlpSpaceSize.tight,
						runSpacingSize: KlpSpaceSize.tight,
						children: [
							for (final badge in badges)
								KlpBadge(
									label: badge.label,
									tone: badge.tone,
									dot: badge.dot,
								),
						],
					),
					const KlpGap.stack(),
					KlpWrap(
						spacingSize: KlpSpaceSize.tight,
						runSpacingSize: KlpSpaceSize.tight,
						children: [for (final tag in tags) KlpTag(label: tag)],
					),
					const KlpGap.stack(),
					KlpText(
						metadata,
						role: KlpTextRole.caption,
						tone: KlpTextTone.muted,
					),
				],
			),
		);
	}
}
