part of 'klp_style_value.dart';

/// 經驗證的中立尺度原料，不指定元件用途。
final class KlpLetterSpacing extends KlpStyleValue {

	final double value;

	KlpLetterSpacing(this.value) {
		if (!value.isFinite) {
			throw KlpContractError('invalid_primitive_value', 'letter_spacing.value: expected a finite number.');
		}
	}
}
