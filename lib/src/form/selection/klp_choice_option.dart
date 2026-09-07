import '../internal/klp_form_dependencies.dart';

/// [KlpSelectField]、[KlpMultiSelectField] 與 [KlpColorRoleField] 共用的
/// 選項資料：識別碼、顯示文字，以及是否停用。
@immutable
class KlpChoiceOption {
	const KlpChoiceOption({
		required this.id,
		required this.label,
		this.disabled = false,
	});

	final String id;
	final String label;
	final bool disabled;
}
