part of '../klp_canvas_workspace.dart';

/// Flow 風險或驗證訊息清單；風險計算與修復動作由領域層提供。
class KlpFlowValidationPanel extends StatelessWidget {
	const KlpFlowValidationPanel({
		super.key,
		required this.title,
		required this.issues,
		this.recoveryActions = const [],
	});

	final String title;
	final List<(String, KlpFeedbackTone)> issues;
	final List<Widget> recoveryActions;

	@override
	Widget build(BuildContext context) {
		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(title, role: KlpTextRole.bodyStrong),
				for (final issue in issues) ...[
					const KlpGap.heightSize(KlpSpaceSize.tight),
					KlpInlineNotice(
						title: title,
						message: issue.$1,
						tone: issue.$2,
					),
				],
				if (recoveryActions.isNotEmpty) ...[
					const KlpGap.heightSize(KlpSpaceSize.contentStack),
					KlpWrap(
						spacingSize: KlpSpaceSize.tight,
						children: recoveryActions,
					),
				],
			],
		);
	}
}
