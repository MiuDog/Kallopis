part of '../klp_artifact_workspace.dart';

/// 結構化文件的標頭；修訂與狀態文字由產品提供。
class KlpDocumentHeader extends StatelessWidget {
	const KlpDocumentHeader({
		super.key,
		required this.title,
		required this.revisionLabel,
		required this.statusLabel,
		this.stale = false,
		this.actions = const [],
	});

	final String title;
	final String revisionLabel;
	final String statusLabel;
	final bool stale;
	final List<Widget> actions;

	@override
	Widget build(BuildContext context) {
		return KlpRow(
			children: [
				KlpExpanded(
					child: KlpColumn(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							KlpText(title, role: KlpTextRole.title),
							const KlpGap.heightSize(KlpSpaceSize.tight),
							KlpWrap(
								spacingSize: KlpSpaceSize.tight,
								children: [
									KlpBadge(
										label: revisionLabel,
										tone: stale
												? KlpFeedbackTone.warning
												: KlpFeedbackTone.neutral,
									),
									KlpBadge(label: statusLabel),
								],
							),
						],
					),
				),
				if (actions.isNotEmpty)
					KlpWrap(
						spacingSize: KlpSpaceSize.tight,
						children: actions,
					),
			],
		);
	}
}
