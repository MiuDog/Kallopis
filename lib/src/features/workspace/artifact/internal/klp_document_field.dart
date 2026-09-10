part of '../klp_artifact_workspace.dart';

/// 文件欄位的標籤、值、說明與驗證組合。
class KlpDocumentField extends StatelessWidget {
	const KlpDocumentField({
		super.key,
		required this.label,
		required this.value,
		this.help,
		this.error,
	});

	final String label;
	final Widget value;
	final String? help;
	final String? error;

	@override
	Widget build(BuildContext context) {
		return KlpField(
			label: label,
			description: help,
			error: error,
			child: value,
		);
	}
}
