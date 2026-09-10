part of 'klp_code_models.dart';

/// Code Viewer 可用的語言選項。
@immutable
class KlpCodeLanguageOption {
	const KlpCodeLanguageOption({
		required this.id,
		required this.label,
		this.supportsView = false,
	});

	final String id;
	final String label;
	final bool supportsView;
}
