part of 'klp_style_value.dart';

/// 經驗證的中立尺度原料，不指定元件用途。
final class KlpLineHeight extends KlpStyleValue {

	final double value;

	KlpLineHeight(this.value) {
		if (!value.isFinite || value <= 0) {
			throw KlpContractError('invalid_primitive_value', 'line_height.value: expected a finite positive number.');
		}
	}
}
