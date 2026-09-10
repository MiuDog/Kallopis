import '../internal/klp_form_dependencies.dart';
import 'klp_choice_option.dart';
import 'klp_select_field.dart';

/// 從一組色彩角色（例如 semantic token 名稱）中選擇一個的下拉欄位。
///
/// 是 [KlpSelectField] 針對「選項本身就是色彩角色」這個情境的薄封裝——
/// [roles] 直接複用 [KlpChoiceOption]，實際渲染完全委派給 [KlpSelectField]。
/// 找不到 [selectedId] 對應的角色時會退回顯示 [roles] 的第一項。
class KlpColorRoleField extends StatelessWidget {
	const KlpColorRoleField({
		super.key,
		required this.label,
		required this.roles,
		required this.selectedId,
		required this.onSelected,
	});

	final String label;
	final List<KlpChoiceOption> roles;
	final String selectedId;
	final ValueChanged<String>? onSelected;

	@override
	Widget build(BuildContext context) {
		return KlpSelectField(
			label: label,
			valueLabel: roles
					.firstWhere(
						(role) => role.id == selectedId,
						orElse: () => roles.first,
					)
					.label,
			options: roles,
			onSelected: onSelected,
		);
	}
}
