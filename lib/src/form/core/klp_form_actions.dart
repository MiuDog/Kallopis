import '../internal/klp_form_dependencies.dart';

/// 表單底部的動作列：送出／取消／重設按鈕，靠右對齊並在寬度不足時自動換行。
///
/// [cancelLabel]／[resetLabel] 為 null 時對應按鈕不會出現，[submitLabel] 與
/// [onSubmit] 恆為必填——表單至少要能送出。[submitting] 為 true 時三個按鈕
/// 一併停用，避免送出過程中使用者重複觸發或誤按取消／重設。
class KlpFormActions extends StatelessWidget {
	const KlpFormActions({
		super.key,
		required this.submitLabel,
		required this.onSubmit,
		this.cancelLabel,
		this.onCancel,
		this.resetLabel,
		this.onReset,
		this.submitting = false,
	});

	final String submitLabel;
	final VoidCallback? onSubmit;
	final String? cancelLabel;
	final VoidCallback? onCancel;
	final String? resetLabel;
	final VoidCallback? onReset;
	final bool submitting;

	@override
	Widget build(BuildContext context) {
		return Wrap(
			alignment: WrapAlignment.end,
			spacing: context.klp.space.actionGap,
			runSpacing: context.klp.space.contentStackGap,
			children: [
				if (resetLabel != null)
					KlpButton(
						label: resetLabel!,
						tone: KlpButtonTone.ghost,
						onPressed: submitting ? null : onReset,
					),
				if (cancelLabel != null)
					KlpButton(
						label: cancelLabel!,
						onPressed: submitting ? null : onCancel,
					),
				KlpButton(
					label: submitLabel,
					tone: KlpButtonTone.primary,
					onPressed: submitting ? null : onSubmit,
				),
			],
		);
	}
}
