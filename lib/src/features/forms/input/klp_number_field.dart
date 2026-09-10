import '../internal/klp_form_dependencies.dart';

/// 數值輸入欄位，底層仍是文字輸入框（[KlpTextField]），但只在能解析成
/// [double] 且落在 [minimum]／[maximum] 範圍內時才呼叫 [onChanged]。
///
/// 超出範圍或無法解析的輸入會被直接忽略——欄位仍顯示使用者打的字，但
/// [onChanged] 不會觸發，因此外部的 `value` 不會更新。需要即時錯誤提示時
/// 請自行比較顯示字串與 [value] 是否一致，而不是依賴 [onChanged] 的呼叫時機。
class KlpNumberField extends StatelessWidget {
	const KlpNumberField({
		super.key,
		required this.label,
		required this.value,
		required this.onChanged,
		this.minimum,
		this.maximum,
		this.unit,
		this.error,
	});

	final String label;
	final double value;
	final ValueChanged<double>? onChanged;
	final double? minimum;
	final double? maximum;
	final String? unit;
	final String? error;

	@override
	Widget build(BuildContext context) {
		return KlpTextField(
			label: label,
			initialValue: value.toString(),
			error: error,
			onChanged: onChanged == null
					? null
					: (text) {
							final parsed = double.tryParse(text);
							if (parsed == null) return;
							if (minimum != null && parsed < minimum!) return;
							if (maximum != null && parsed > maximum!) return;
							onChanged!(parsed);
						},
		);
	}
}
