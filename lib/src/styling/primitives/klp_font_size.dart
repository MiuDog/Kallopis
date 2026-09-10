part of 'klp_style_value.dart';

/// 經驗證的中立字體原料，不指定元件用途。
final class KlpFontSize extends KlpStyleValue {

	final double value;

	KlpFontSize(this.value) {
		if (!value.isFinite || value <= 0) {
			throw KlpContractError('invalid_primitive_value', 'font_size.value: expected a finite positive number.');
		}
	}
}
