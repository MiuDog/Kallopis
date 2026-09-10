part of 'klp_style_value.dart';

/// 經驗證的中立尺度原料，不指定元件用途。
final class KlpRadius extends KlpStyleValue {

	final double value;

	KlpRadius(this.value) {
		if (!value.isFinite || value < 0) {
			throw KlpContractError('invalid_primitive_value', 'radius.value: expected a finite non-negative number.');
		}
	}
}
