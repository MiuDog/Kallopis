part of '../klp_approval_steps_field.dart';

/// 審批步驟排序欄位。支援步驟上下移動、刪除與新增。
class KlpApprovalStepsField extends StatelessWidget {
	const KlpApprovalStepsField({
		super.key,
		required this.label,
		this.subtitle,
		required this.steps,
		this.onAddStep,
		this.onMoveUp,
		this.onMoveDown,
		this.onRemove,
		this.maxSteps,
	});

	final String label;
	final String? subtitle;
	final List<KlpApprovalStepData> steps;
	final VoidCallback? onAddStep;
	final ValueChanged<int>? onMoveUp;
	final ValueChanged<int>? onMoveDown;
	final ValueChanged<int>? onRemove;
	final int? maxSteps;

	@override
	Widget build(BuildContext context) {
		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(label, role: KlpTextRole.caption),
				if (subtitle != null) ...[
					const KlpGap.heightSize(KlpSpaceSize.tight),
					KlpText(
						subtitle!,
						role: KlpTextRole.caption,
						tone: KlpTextTone.muted,
					),
				],
				const KlpGap.heightSize(KlpSpaceSize.tight),
				for (var index = 0; index < steps.length; index++) ...[
					KlpStructuredFrame(
						style: KlpStructuredFrameStyle.approvalRow(context),
						child: KlpRow(
							children: [
								KlpText(
									'${index + 1}',
									role: KlpTextRole.code,
									tone: KlpTextTone.muted,
								),
								const KlpGap.widthSize(KlpSpaceSize.contentInline),
								KlpExpanded(
									child: KlpStructuredFrame(
										style: KlpStructuredFrameStyle.approvalRole(context),
										child: KlpRow(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												KlpText(steps[index].roleLabel),
												const KlpText(
													'⌄',
													role: KlpTextRole.caption,
													tone: KlpTextTone.muted,
												),
											],
										),
									),
								),
								const KlpGap.widthSize(KlpSpaceSize.contentInline),
								_buildAction(index: index, label: '⌃', onPressed: onMoveUp),
								_buildAction(index: index, label: '⌄', onPressed: onMoveDown),
								_buildAction(index: index, label: '×', onPressed: onRemove),
							],
						),
					),
					const KlpGap.heightSize(KlpSpaceSize.tight),
				],
				KlpRow(
					children: [
						if (onAddStep != null)
							KlpGestureRegion(
								behavior: HitTestBehavior.opaque,
								onTap: onAddStep,
								child: const KlpText('+ Add step', role: KlpTextRole.caption),
							),
						if (maxSteps != null) ...[
							const KlpGap.widthSize(KlpSpaceSize.contentInline),
							KlpText(
								'${steps.length}/$maxSteps',
								role: KlpTextRole.caption,
								tone: KlpTextTone.faint,
							),
						],
					],
				),
			],
		);
	}

	Widget _buildAction({
		required int index,
		required String label,
		required ValueChanged<int>? onPressed,
	}) {
		return KlpGestureRegion(
			behavior: HitTestBehavior.opaque,
			onTap: onPressed == null ? null : () => onPressed(index),
			child: KlpBox(
				paddingSize: KlpSpaceSize.tight,
				child: KlpText(
					label,
					role: KlpTextRole.caption,
					tone: KlpTextTone.muted,
				),
			),
		);
	}
}
