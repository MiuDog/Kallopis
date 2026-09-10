part of '../klp_page_chrome.dart';

/// [KlpPropertySummary.badges] 的一筆徽章資料，直接對應 [KlpBadge] 的
/// `label`／`tone`／`dot` 參數。
@immutable
class KlpPropertyBadgeData {
	const KlpPropertyBadgeData({
		required this.label,
		this.tone = KlpFeedbackTone.neutral,
		this.dot = false,
	});

	final String label;
	final KlpFeedbackTone tone;
	final bool dot;
}
