part of 'klp_finite_workflow.dart';

/// 將有限工作流狀態轉成可讀、可宣告的狀態表面。
class KlpWorkflowStateSurface extends StatelessWidget {
	const KlpWorkflowStateSurface({
		super.key,
		required this.state,
		required this.title,
		required this.message,
		required this.statusLabel,
		this.actionLabel,
		this.onAction,
		this.child,
	});

	final KlpWorkflowState state;
	final String title;
	final String message;
	final String statusLabel;
	final String? actionLabel;
	final VoidCallback? onAction;
	final Widget? child;

	KlpFeedbackTone get _tone => switch (state) {
		KlpWorkflowState.applied => KlpFeedbackTone.success,
		KlpWorkflowState.stale => KlpFeedbackTone.warning,
		KlpWorkflowState.failed => KlpFeedbackTone.danger,
		KlpWorkflowState.empty ||
		KlpWorkflowState.collecting ||
		KlpWorkflowState.reviewing ||
		KlpWorkflowState.ready ||
		KlpWorkflowState.applying => KlpFeedbackTone.info,
	};

	@override
	Widget build(BuildContext context) {
		final applying = state == KlpWorkflowState.applying;

		return KlpLiveRegion(
			message: '$title. $message',
			child: KlpSurface(
				tone: KlpSurfaceTone.component,
				child: KlpBox(
					paddingSize: KlpSpaceSize.base,
					child: KlpColumn(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							KlpRow(
								children: [
									if (applying) ...[
										const KlpGeometricSpinner(),
										const KlpGap.widthSize(KlpSpaceSize.contentInline),
									],
									KlpExpanded(child: KlpText(title, role: KlpTextRole.bodyStrong)),
									KlpBadge(label: statusLabel, tone: _tone),
								],
							),
							const KlpGap.heightSize(KlpSpaceSize.contentStack),
							KlpText(message, tone: KlpTextTone.muted),
							if (child != null) ...[
								const KlpGap.heightSize(KlpSpaceSize.base),
								child!,
							],
							if (actionLabel != null) ...[
								const KlpGap.heightSize(KlpSpaceSize.base),
								KlpAlign(
									alignment: AlignmentDirectional.centerStart,
									child: KlpButton(label: actionLabel!, onPressed: onAction),
								),
							],
						],
					),
				),
			),
		);
	}
}
