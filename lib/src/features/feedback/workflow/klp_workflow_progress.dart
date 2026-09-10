part of 'klp_finite_workflow.dart';

/// 顯示具名稱的真實階段，並向輔助技術宣告目前階段。
class KlpWorkflowProgress extends StatelessWidget {
	const KlpWorkflowProgress({super.key, required this.stages, this.label});

	final List<KlpWorkflowStageData> stages;
	final String? label;

	KlpFeedbackTone _toneFor(KlpWorkflowStageData stage) {
		if (stage.complete) return KlpFeedbackTone.success;
		if (stage.active) return KlpFeedbackTone.info;

		return KlpFeedbackTone.neutral;
	}

	@override
	Widget build(BuildContext context) {
		final active = stages.where((stage) => stage.active).firstOrNull;
		final announcement = [if (label != null) label, active?.label].whereType<String>().join(': ');

		return KlpLiveRegion(
			message: announcement,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					for (var index = 0; index < stages.length; index++) ...[
						KlpRow(
							children: [
								KlpBadge(label: stages[index].statusLabel, tone: _toneFor(stages[index])),
								const KlpGap.widthSize(KlpSpaceSize.contentInline),
								KlpExpanded(child: KlpText(stages[index].label)),
							],
						),
						if (index < stages.length - 1) const KlpGap.heightSize(KlpSpaceSize.tight),
					],
				],
			),
		);
	}
}
