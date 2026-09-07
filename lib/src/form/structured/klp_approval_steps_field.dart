import '../internal/klp_form_dependencies.dart';

/// 審批步驟資料。
@immutable
class KlpApprovalStepData {
	const KlpApprovalStepData({required this.id, required this.roleLabel});

	final String id;
	final String roleLabel;
}
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
		final tokens = context.klpColors;
		final klp = context.klp;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(label, role: KlpTextRole.caption),
				if (subtitle != null) ...[
					SizedBox(height: klp.space.tight),
					KlpText(
						subtitle!,
						role: KlpTextRole.caption,
						tone: KlpTextTone.muted,
					),
				],
				SizedBox(height: klp.space.tight),
				for (var index = 0; index < steps.length; index++) ...[
					Container(
						padding: EdgeInsets.symmetric(
							horizontal: klp.space.contentInset,
							vertical: klp.space.tight,
						),
						decoration: BoxDecoration(
							color: tokens.surfaceInset,
							borderRadius: BorderRadius.circular(klp.shape.control),
							border: Border.all(
								color: tokens.border,
								width: klp.shape.hairline,
							),
						),
						child: Row(
							children: [
								KlpText(
									'${index + 1}',
									role: KlpTextRole.code,
									tone: KlpTextTone.muted,
								),
								SizedBox(width: klp.space.contentInlineGap),
								Expanded(
									child: Container(
										height: klp.space.controlHeightSmall,
										alignment: Alignment.centerLeft,
										padding: EdgeInsets.symmetric(
											horizontal: klp.space.controlInset,
										),
										decoration: BoxDecoration(
											color: tokens.component,
											borderRadius: BorderRadius.circular(klp.shape.control),
										),
										child: Row(
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
								SizedBox(width: klp.space.contentInlineGap),
								GestureDetector(
									behavior: HitTestBehavior.opaque,
									onTap: onMoveUp == null ? null : () => onMoveUp!(index),
									child: Padding(
										padding: EdgeInsets.all(klp.space.tight),
										child: const KlpText(
											'⌃',
											role: KlpTextRole.caption,
											tone: KlpTextTone.muted,
										),
									),
								),
								GestureDetector(
									behavior: HitTestBehavior.opaque,
									onTap: onMoveDown == null ? null : () => onMoveDown!(index),
									child: Padding(
										padding: EdgeInsets.all(klp.space.tight),
										child: const KlpText(
											'⌄',
											role: KlpTextRole.caption,
											tone: KlpTextTone.muted,
										),
									),
								),
								GestureDetector(
									behavior: HitTestBehavior.opaque,
									onTap: onRemove == null ? null : () => onRemove!(index),
									child: Padding(
										padding: EdgeInsets.all(klp.space.tight),
										child: const KlpText(
											'×',
											role: KlpTextRole.caption,
											tone: KlpTextTone.muted,
										),
									),
								),
							],
						),
					),
					SizedBox(height: klp.space.tight),
				],
				Row(
					children: [
						if (onAddStep != null)
							GestureDetector(
								behavior: HitTestBehavior.opaque,
								onTap: onAddStep,
								child: const KlpText('+ Add step', role: KlpTextRole.caption),
							),
						if (maxSteps != null) ...[
							SizedBox(width: klp.space.contentInlineGap),
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
}
