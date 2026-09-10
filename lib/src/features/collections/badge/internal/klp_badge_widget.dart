part of '../klp_badge.dart';

/// 狀態標記。文字、內距與 pill 幾何皆由目前 Kallopis theme 解析。
class KlpBadge extends StatelessWidget {
	const KlpBadge({
		super.key,
		required this.label,
		this.tone = KlpFeedbackTone.neutral,
		this.variant = KlpBadgeVariant.filled,
		this.dot = false,
	});

	/// 標籤文字。
	final String label;

	/// 語意色調。
	final KlpFeedbackTone tone;

	/// 視覺樣式。
	final KlpBadgeVariant variant;

	/// 是否顯示狀態圓點。
	final bool dot;

	@override
	Widget build(BuildContext context) {
		return _KlpBadgeFrame(
			tone: tone,
			variant: variant,
			builder: (context, style) => KlpRow(
				mainAxisSize: MainAxisSize.min,
				children: [
					if (dot) ...[
						_KlpBadgeDot(color: style.dot),
						const KlpGap.widthSize(KlpSpaceSize.tight),
					],
					KlpFlexible(
						child: KlpText(
							label.toUpperCase(),
							role: KlpTextRole.caption,
							color: style.text,
							maxLines: 1,
							overflow: TextOverflow.ellipsis,
						),
					),
				],
			),
		);
	}
}
