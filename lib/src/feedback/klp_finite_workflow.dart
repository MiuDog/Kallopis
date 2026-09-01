import 'package:flutter/material.dart';

import '../controls/klp_button.dart';
import '../data/klp_badge.dart';
import '../foundation/klp_geometric_spinner.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_feedback_tone.dart';

/// 有限工作流的語意狀態；狀態轉移仍由呼叫端控制。
enum KlpWorkflowState { empty, collecting, reviewing, ready, stale, applying, applied, failed }

/// 一個具名稱的工作流階段，不使用虛構的時間估算。
@immutable
class KlpWorkflowStageData {
	const KlpWorkflowStageData({
		required this.label,
		required this.statusLabel,
		required this.complete,
		this.active = false,
	});

	final String label;
	final String statusLabel;
	final bool complete;
	final bool active;
}

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
		return Semantics(
			container: true,
			liveRegion: true,
			label: '$title. $message',
			child: KlpSurface(
				tone: KlpSurfaceTone.component,
				padding: EdgeInsets.all(context.klp.space.base),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Row(
							children: [
								if (applying) ...[
									const KlpGeometricSpinner(),
									SizedBox(width: context.klp.space.compact),
								],
								Expanded(child: KlpText(title, role: KlpTextRole.bodyStrong)),
								KlpBadge(label: statusLabel, tone: _tone),
							],
						),
						SizedBox(height: context.klp.space.compact),
						KlpText(message, tone: KlpTextTone.muted),
						if (child != null) ...[
							SizedBox(height: context.klp.space.base),
							child!,
						],
						if (actionLabel != null) ...[
							SizedBox(height: context.klp.space.base),
							Align(
								alignment: AlignmentDirectional.centerStart,
								child: KlpButton(label: actionLabel!, onPressed: onAction),
							),
						],
					],
				),
			),
		);
	}
}

/// 顯示具名稱的真實階段，並向輔助技術宣告目前階段。
class KlpWorkflowProgress extends StatelessWidget {
	const KlpWorkflowProgress({super.key, required this.stages, this.label});

	final List<KlpWorkflowStageData> stages;
	final String? label;

	@override
	Widget build(BuildContext context) {
		final active = stages.where((stage) => stage.active).firstOrNull;
		return Semantics(
			container: true,
			liveRegion: true,
			label: [if (label != null) label, active?.label].whereType<String>().join(': '),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					for (var index = 0; index < stages.length; index++)
						Padding(
							padding: EdgeInsets.only(bottom: index < stages.length - 1 ? context.klp.space.tight : context.klp.shape.none),
							child: Row(
								children: [
									KlpBadge(
										label: stages[index].statusLabel,
										tone: stages[index].complete
												? KlpFeedbackTone.success
												: stages[index].active
												? KlpFeedbackTone.info
												: KlpFeedbackTone.neutral,
									),
									SizedBox(width: context.klp.space.compact),
									Expanded(child: KlpText(stages[index].label)),
								],
							),
						),
				],
			),
		);
	}
}

/// 控制重複公告的可及性 live region；呼叫端提供已去重的訊息。
class KlpLiveRegion extends StatelessWidget {
	const KlpLiveRegion({super.key, required this.message, this.child = const SizedBox.shrink()});

	final String message;
	final Widget child;

	@override
	Widget build(BuildContext context) => Semantics(
		container: true,
		liveRegion: true,
		label: message,
		child: child,
	);
}

/// 建立可回復焦點的邊界；對話框或導覽完成後可呼叫 [requestFocus]。
class KlpFocusBoundary extends StatefulWidget {
	const KlpFocusBoundary({super.key, required this.child, this.autofocus = false});

	final Widget child;
	final bool autofocus;

	static void requestFocus(BuildContext context) {
		context.findAncestorStateOfType<_KlpFocusBoundaryState>()?.requestFocus();
	}

	@override
	State<KlpFocusBoundary> createState() => _KlpFocusBoundaryState();
}

class _KlpFocusBoundaryState extends State<KlpFocusBoundary> {
	final FocusNode _node = FocusNode();

	void requestFocus() => _node.requestFocus();

	@override
	void dispose() {
		_node.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => Focus(
		focusNode: _node,
		autofocus: widget.autofocus,
		child: widget.child,
	);
}
