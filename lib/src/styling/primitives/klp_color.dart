part of 'klp_style_value.dart';

/// 中立的整數色彩通道，不依賴渲染框架。
final class KlpColor extends KlpStyleValue {

	final int red;
	final int green;
	final int blue;
	final int alpha;

	KlpColor(this.red, this.green, this.blue, {this.alpha = 255}) {
		_checkChannel(red, 'red');
		_checkChannel(green, 'green');
		_checkChannel(blue, 'blue');
		_checkChannel(alpha, 'alpha');
	}

	static void _checkChannel(int value, String path) {
		if (value < 0 || value > 255) {
			throw KlpContractError('invalid_primitive_value', 'color.$path: expected an integer from 0 to 255.');
		}
	}
}
