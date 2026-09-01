import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controls/klp_button.dart';
import '../controls/klp_icon_button.dart';
import '../data/klp_badge.dart';
import '../feedback/klp_feedback_tone.dart';
import '../feedback/klp_inline_notice.dart';
import '../foundation/klp_icons.dart';
import '../surface/klp_divider.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 由產品提供的附件呈現資料；Kallopis 不擁有附件內容。
@immutable
class KlpAttachmentData {
	const KlpAttachmentData({required this.id, required this.label, this.detail});

	final String id;
	final String label;
	final String? detail;
}

/// 顯示並移除目前提示範圍內的附件。
class KlpAttachmentTray extends StatelessWidget {
	const KlpAttachmentTray({super.key, required this.attachments, required this.removeLabel, this.onRemove});

	final List<KlpAttachmentData> attachments;
	final String removeLabel;
	final ValueChanged<String>? onRemove;

	@override
	Widget build(BuildContext context) => Wrap(
		spacing: context.klp.space.compact,
		runSpacing: context.klp.space.tight,
		children: [
			for (final attachment in attachments)
				Semantics(
					label: [attachment.label, attachment.detail, if (onRemove != null) removeLabel].whereType<String>().join(', '),
					child: KlpTag(
						label: attachment.label,
						prefix: attachment.detail,
						onRemove: onRemove == null ? null : () => onRemove!(attachment.id),
					),
				),
		],
	);
}

/// 提示範例只回填草稿，不代表提交或產品預設值。
class KlpPromptExamples extends StatelessWidget {
	const KlpPromptExamples({super.key, required this.examples, required this.onSelected});

	final List<String> examples;
	final ValueChanged<String> onSelected;

	@override
	Widget build(BuildContext context) => Wrap(
		spacing: context.klp.space.tight,
		runSpacing: context.klp.space.tight,
		children: [
			for (final example in examples)
				KlpButton(
					label: example,
					tone: KlpButtonTone.dashed,
					compact: true,
					onPressed: () => onSelected(example),
				),
		],
	);
}

/// 多行提示欄位；Enter 提交，Shift+Enter 保留給換行。
class KlpPromptTextField extends StatelessWidget {
	const KlpPromptTextField({
		super.key,
		required this.controller,
		required this.placeholder,
		required this.onChanged,
		this.onSubmit,
		this.focusNode,
	});

	final TextEditingController controller;
	final FocusNode? focusNode;
	final String placeholder;
	final ValueChanged<String> onChanged;
	final VoidCallback? onSubmit;

	@override
	Widget build(BuildContext context) => CallbackShortcuts(
		bindings: {
			const SingleActivator(LogicalKeyboardKey.enter): () {
				if (onSubmit != null) onSubmit!();
			},
		},
		child: TextField(
			controller: controller,
			focusNode: focusNode,
			keyboardType: TextInputType.multiline,
			textInputAction: TextInputAction.newline,
			minLines: null,
			maxLines: null,
			onChanged: onChanged,
			decoration: InputDecoration(hintText: placeholder),
		),
	);
}

/// 對話輸入器的產品中立組合；草稿與附件的權威狀態由呼叫端保存。
class KlpWorkflowComposer extends StatelessWidget {
	const KlpWorkflowComposer({
		super.key,
		required this.controller,
		required this.placeholder,
		required this.sendLabel,
		required this.attachLabel,
		required this.removeAttachmentLabel,
		required this.onChanged,
		this.onSend,
		this.onAttach,
		this.attachments = const [],
		this.examples = const [],
		this.onRemoveAttachment,
		this.onExampleSelected,
	});

	final TextEditingController controller;
	final String placeholder;
	final String sendLabel;
	final String attachLabel;
	final String removeAttachmentLabel;
	final ValueChanged<String> onChanged;
	final VoidCallback? onSend;
	final VoidCallback? onAttach;
	final List<KlpAttachmentData> attachments;
	final List<String> examples;
	final ValueChanged<String>? onRemoveAttachment;
	final ValueChanged<String>? onExampleSelected;

	@override
	Widget build(BuildContext context) => KlpSurface(
		tone: KlpSurfaceTone.muted,
		padding: EdgeInsets.all(context.klp.space.base),
		child: Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				if (attachments.isNotEmpty) ...[
					KlpAttachmentTray(
						attachments: attachments,
						removeLabel: removeAttachmentLabel,
						onRemove: onRemoveAttachment,
					),
					SizedBox(height: context.klp.space.compact),
				],
				KlpPromptTextField(
					controller: controller,
					placeholder: placeholder,
					onChanged: onChanged,
					onSubmit: onSend,
				),
				if (examples.isNotEmpty && onExampleSelected != null) ...[
					SizedBox(height: context.klp.space.compact),
					KlpPromptExamples(examples: examples, onSelected: onExampleSelected!),
				],
				SizedBox(height: context.klp.space.compact),
				Row(
					children: [
						KlpIconButton(icon: KlpIcons.folderPlus, label: attachLabel, onPressed: onAttach),
						const Spacer(),
						KlpButton(label: sendLabel, compact: true, onPressed: onSend),
					],
				),
			],
		),
	);
}

/// 需求來源的有限分類。
enum KlpRequirementSource { user, assumption }

/// 需求的有限審查狀態。
enum KlpRequirementStatus { unknown, assumed, answered, conflicting, confirmed }

/// 一筆不可變的需求呈現資料。
@immutable
class KlpRequirementData {
	const KlpRequirementData({
		required this.id,
		required this.label,
		required this.value,
		required this.sourceLabel,
		required this.statusLabel,
		required this.source,
		required this.status,
		this.impact,
	});

	final String id;
	final String label;
	final String value;
	final String sourceLabel;
	final String statusLabel;
	final KlpRequirementSource source;
	final KlpRequirementStatus status;
	final String? impact;
}

/// 呈現單一探索問題、輔助提示與有限導覽動作。
class KlpDiscoveryQuestionCard extends StatelessWidget {
	const KlpDiscoveryQuestionCard({
		super.key,
		required this.question,
		required this.answer,
		required this.onChanged,
		this.relatedPrompts = const [],
		this.actions = const [],
	});

	final String question;
	final String answer;
	final ValueChanged<String> onChanged;
	final List<String> relatedPrompts;
	final List<Widget> actions;

	@override
	Widget build(BuildContext context) => KlpSurface(
		tone: KlpSurfaceTone.component,
		padding: EdgeInsets.all(context.klp.space.base),
		child: Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(question, role: KlpTextRole.lead),
				if (relatedPrompts.isNotEmpty) ...[
					SizedBox(height: context.klp.space.compact),
					for (final prompt in relatedPrompts)
						KlpText(prompt, role: KlpTextRole.sub, tone: KlpTextTone.muted),
				],
				SizedBox(height: context.klp.space.base),
				TextFormField(initialValue: answer, onChanged: onChanged, maxLines: null),
				if (actions.isNotEmpty) ...[
					SizedBox(height: context.klp.space.base),
					Wrap(spacing: context.klp.space.tight, runSpacing: context.klp.space.tight, children: actions),
				],
			],
		),
	);
}

/// 需求摘要；衝突與假設透過不同語意名稱與色調呈現。
class KlpRequirementSummary extends StatelessWidget {
	const KlpRequirementSummary({super.key, required this.title, required this.requirements, this.confidenceLabel});

	final String title;
	final List<KlpRequirementData> requirements;
	final String? confidenceLabel;

	KlpFeedbackTone _tone(KlpRequirementStatus status) => switch (status) {
		KlpRequirementStatus.confirmed => KlpFeedbackTone.success,
		KlpRequirementStatus.conflicting => KlpFeedbackTone.danger,
		KlpRequirementStatus.assumed => KlpFeedbackTone.warning,
		KlpRequirementStatus.answered => KlpFeedbackTone.info,
		KlpRequirementStatus.unknown => KlpFeedbackTone.neutral,
	};

	@override
	Widget build(BuildContext context) => Semantics(
		container: true,
		label: title,
		child: Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Row(
					children: [
						Expanded(child: KlpText(title, role: KlpTextRole.bodyStrong)),
						if (confidenceLabel != null) KlpBadge(label: confidenceLabel!),
					],
				),
				SizedBox(height: context.klp.space.compact),
				for (final requirement in requirements) ...[
					KlpSurface(
						tone: KlpSurfaceTone.inset,
						padding: EdgeInsets.all(context.klp.space.compact),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								Row(
									children: [
										Expanded(child: KlpText(requirement.label, role: KlpTextRole.bodyStrong)),
										KlpBadge(label: requirement.sourceLabel, tone: requirement.source == KlpRequirementSource.assumption ? KlpFeedbackTone.warning : KlpFeedbackTone.info),
										SizedBox(width: context.klp.space.tight),
										KlpBadge(label: requirement.statusLabel, tone: _tone(requirement.status)),
									],
								),
								SizedBox(height: context.klp.space.tight),
								KlpText(requirement.value),
								if (requirement.impact != null) KlpText(requirement.impact!, role: KlpTextRole.sub, tone: KlpTextTone.muted),
							],
						),
					),
					SizedBox(height: context.klp.space.tight),
				],
			],
		),
	);
}

/// 提案變更的有限種類。
enum KlpProposalChangeKind { create, replace, remove }

/// 一筆提案變更的呈現資料。
@immutable
class KlpProposalChangeData {
	const KlpProposalChangeData({required this.path, required this.kindLabel, required this.reason, required this.kind});

	final String path;
	final String kindLabel;
	final String reason;
	final KlpProposalChangeKind kind;
}

/// 一筆提案問題的呈現資料。
@immutable
class KlpProposalIssueData {
	const KlpProposalIssueData({required this.message, required this.tone, this.path});

	final String message;
	final String? path;
	final KlpFeedbackTone tone;
}

/// 提案審查表面；確認、拒絕與要求修訂是三個獨立的 typed callback。
class KlpProposalReview extends StatelessWidget {
	const KlpProposalReview({
		super.key,
		required this.title,
		required this.summary,
		required this.versionLabel,
		required this.statusLabel,
		required this.affectedLabel,
		required this.changes,
		required this.confirmLabel,
		required this.rejectLabel,
		required this.reviseLabel,
		this.issues = const [],
		this.diff,
		this.dependencies,
		this.staleMessage,
		this.onConfirm,
		this.onReject,
		this.onRevise,
	});

	final String title;
	final String summary;
	final String versionLabel;
	final String statusLabel;
	final String affectedLabel;
	final List<KlpProposalChangeData> changes;
	final List<KlpProposalIssueData> issues;
	final String confirmLabel;
	final String rejectLabel;
	final String reviseLabel;
	final Widget? diff;
	final Widget? dependencies;
	final String? staleMessage;
	final VoidCallback? onConfirm;
	final VoidCallback? onReject;
	final VoidCallback? onRevise;

	@override
	Widget build(BuildContext context) {
		final stale = staleMessage != null;
		return Semantics(
			container: true,
			label: '$title. $statusLabel',
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					KlpText(title, role: KlpTextRole.title),
					SizedBox(height: context.klp.space.tight),
					Wrap(
						spacing: context.klp.space.tight,
						runSpacing: context.klp.space.tight,
						children: [
							KlpBadge(label: versionLabel),
							KlpBadge(label: statusLabel, tone: stale ? KlpFeedbackTone.warning : KlpFeedbackTone.info),
						],
					),
					SizedBox(height: context.klp.space.compact),
					KlpText(affectedLabel, role: KlpTextRole.sub, tone: KlpTextTone.muted),
					SizedBox(height: context.klp.space.base),
					KlpText(summary, role: KlpTextRole.bodyStrong),
					if (stale) ...[
						SizedBox(height: context.klp.space.base),
						KlpInlineNotice(title: statusLabel, message: staleMessage!, tone: KlpFeedbackTone.warning),
					],
					for (final change in changes) ...[
						SizedBox(height: context.klp.space.compact),
						KlpSurface(
							tone: KlpSurfaceTone.inset,
							padding: EdgeInsets.all(context.klp.space.compact),
							child: Row(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									KlpBadge(label: change.kindLabel, tone: change.kind == KlpProposalChangeKind.remove ? KlpFeedbackTone.danger : KlpFeedbackTone.info),
									SizedBox(width: context.klp.space.compact),
									Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [KlpText(change.path, role: KlpTextRole.code), KlpText(change.reason, role: KlpTextRole.sub, tone: KlpTextTone.muted)])),
								],
							),
						),
					],
					for (final issue in issues) ...[
						SizedBox(height: context.klp.space.compact),
						KlpInlineNotice(title: issue.path ?? statusLabel, message: issue.message, tone: issue.tone),
					],
					if (diff != null) ...[SizedBox(height: context.klp.space.base), diff!],
					if (dependencies != null) ...[SizedBox(height: context.klp.space.base), dependencies!],
					SizedBox(height: context.klp.space.base),
					const KlpDivider(),
					SizedBox(height: context.klp.space.base),
					Wrap(
						spacing: context.klp.space.tight,
						runSpacing: context.klp.space.tight,
						children: [
							KlpButton(label: confirmLabel, onPressed: stale ? null : onConfirm),
							KlpButton(label: reviseLabel, tone: KlpButtonTone.secondary, onPressed: onRevise),
							KlpButton(label: rejectLabel, tone: KlpButtonTone.danger, onPressed: onReject),
						],
					),
				],
			),
		);
	}
}
