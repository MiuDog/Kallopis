part of '../klp_toast.dart';

/// 短暫通知。**不負責排程與消失**——停留時間取自 `theme.motion.toastDwell`，
/// 但實際的顯示與收起由呼叫端控制。
class KlpToast extends StatelessWidget {
	const KlpToast({
		super.key,
		required this.title,
		this.message,
		this.tone = KlpFeedbackTone.info,
		this.actionLabel,
		this.onAction,
		this.onClose,
		this.closeLabel,
	}) : assert(
			onClose == null || closeLabel != null,
			'提供 onClose 時必須一併提供 closeLabel——庫不替產品決定用什麼語言說「關閉」。',
		);

	final String title;
	final String? message;
	final KlpFeedbackTone tone;
	final String? actionLabel;
	final VoidCallback? onAction;
	final VoidCallback? onClose;

	/// 關閉鈕的文字。有 [onClose] 時必填——庫不替產品決定用什麼語言。
	final String? closeLabel;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final toneColor = tone.color(tokens);

		return KlpLiveRegion.fromDescendants(
			child: KlpConstrainedBox(
				constraints: KlpBoxConstraints(maxWidth: context.klp.geometry.layout.toastMaximumWidth),
				child: KlpSurface(
					tone: KlpSurfaceTone.inset,
					radius: context.klp.shape.card,
					child: KlpBox(
						paddingSize: KlpSpaceSize.base,
						child: KlpColumn(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								KlpRow(
									children: [
										KlpBox(
											widthSize: KlpSpaceSize.toastIconSlot,
											heightSize: KlpSpaceSize.toastIconSlot,
											child: KlpCenter(
												child: KlpIcon(tone.icon, size: context.klp.space.icon, color: toneColor),
											),
										),
										const KlpGap.widthSize(KlpSpaceSize.contentInline),
										KlpExpanded(child: KlpText(tone.label, role: KlpTextRole.label, color: toneColor)),
										KlpText(
											KlpLocalizations.of(context).toastNowLabel,
											role: KlpTextRole.label,
											tone: KlpTextTone.faint,
										),
									],
								),
								const KlpGap.heightSize(KlpSpaceSize.base),
								KlpText(title, role: KlpTextRole.bodyStrong),
								if (message != null) ...[
									const KlpGap.heightSize(KlpSpaceSize.tight),
									KlpText(message!, role: KlpTextRole.caption, tone: KlpTextTone.muted),
								],
								if (actionLabel != null || onClose != null) ...[
									const KlpGap.heightSize(KlpSpaceSize.base),
									KlpWrap(
										alignment: WrapAlignment.end,
										spacingSize: KlpSpaceSize.tight,
										runSpacingSize: KlpSpaceSize.tight,
										children: [
											if (onClose != null)
												KlpButton(
													label: closeLabel!,
													onPressed: onClose,
													tone: KlpButtonTone.ghost,
													compact: true,
												),
											if (actionLabel != null && onAction != null)
												KlpButton(
													label: actionLabel!,
													onPressed: onAction,
													tone: KlpButtonTone.primary,
													compact: true,
												),
										],
									),
								],
							],
						),
					),
				),
			),
		);
	}
}
