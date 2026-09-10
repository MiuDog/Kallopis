part of '../klp_progress.dart';

/// 呈現確定或未確定比例的通用進度資訊。
class KlpProgress extends StatelessWidget {
	const KlpProgress({
		super.key,
		this.value,
		this.label,
		this.trailing,
		@Deprecated('KlpProgress 使用連續軌道，segments 不影響呈現。')
		this.segments = 12,
		this.detail,
		this.state = KlpProgressState.active,
		this.onCancel,
		this.cancelLabel = 'Cancel',
	});

	/// 介於 0 至 1 的資料比例；超出範圍時會被截斷。
	final double? value;
	final String? label;
	final String? trailing;

	/// 僅為舊版相容保留；連續進度軌道不使用分段數。
	@Deprecated('KlpProgress 使用連續軌道，segments 不影響呈現。')
	final int segments;

	final String? detail;
	final KlpProgressState state;
	final VoidCallback? onCancel;
	final String cancelLabel;

	@override
	Widget build(BuildContext context) {
		final safeValue = value?.clamp(0.0, 1.0).toDouble();

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpRow(
					children: [
						if (label != null)
							KlpExpanded(
								child: KlpText(
									label!,
									role: KlpTextRole.caption,
								),
							)
						else
							const KlpSpacer(),
						if (safeValue != null)
							KlpText(
								trailing ?? '${(safeValue * 100).round()}%',
								role: KlpTextRole.code,
								tone: KlpTextTone.muted,
							),
						if (onCancel != null && state == KlpProgressState.active) ...[
							const KlpGap.widthSize(KlpSpaceSize.contentInline),
							KlpGestureRegion(
								behavior: HitTestBehavior.opaque,
								onTap: onCancel,
								child: KlpText(
									cancelLabel,
									role: KlpTextRole.label,
									tone: KlpTextTone.muted,
								),
							),
						],
					],
				),
				const KlpGap.heightSize(KlpSpaceSize.contentStack),
				_KlpProgressTrack(value: safeValue, state: state),
				if (detail != null) ...[
					const KlpGap.heightSize(KlpSpaceSize.contentStack),
					KlpText(
						detail!,
						role: KlpTextRole.caption,
						tone: KlpTextTone.muted,
					),
				],
			],
		);
	}
}
