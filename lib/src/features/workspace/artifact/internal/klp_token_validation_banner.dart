part of '../klp_artifact_workspace.dart';

/// Token 圖形驗證結果，不自行推導循環或型別相容性。
class KlpTokenValidationBanner extends StatelessWidget {
	const KlpTokenValidationBanner({
		super.key,
		required this.title,
		required this.message,
		required this.valid,
	});

	final String title;
	final String message;
	final bool valid;

	@override
	Widget build(BuildContext context) {
		return KlpInlineNotice(
			title: title,
			message: message,
			tone: valid ? KlpFeedbackTone.success : KlpFeedbackTone.danger,
		);
	}
}
