import '../internal/klp_form_dependencies.dart';
import '../input/klp_text_area.dart';

/// 程式碼欄位：唯讀時走語法高亮的 [KlpCodeViewer]，可編輯時走純文字的
/// [KlpTextArea]。
///
/// [readOnly] 切換的是整套渲染方式而非同一個 widget 加鎖——唯讀模式沒有
/// [onChanged] 也沒有 [error] 提示，這兩者只在可編輯（[readOnly] 為 false）
/// 時才有意義。[language] 只影響唯讀模式下的語法高亮，可編輯模式不使用。
class KlpCodeField extends StatelessWidget {
	const KlpCodeField({
		super.key,
		required this.label,
		required this.value,
		this.language,
		this.onChanged,
		this.readOnly = false,
		this.error,
	});

	final String label;
	final String value;
	final String? language;
	final ValueChanged<String>? onChanged;
	final bool readOnly;
	final String? error;

	@override
	Widget build(BuildContext context) {
		return readOnly
				? Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							KlpText(label, role: KlpTextRole.caption),
							SizedBox(height: context.klp.space.tight),
							KlpCodeViewer(code: value, language: language),
						],
					)
				: KlpTextArea(
						label: label,
						value: value,
						error: error,
						onChanged: onChanged,
					);
	}
}
