part of 'klp_style_value.dart';

/// 字族及接手順序的不可變原料；不接受空白或未修整名稱。
final class KlpFontFamily extends KlpStyleValue {

	final String family;
	final List<String> fallback;

	KlpFontFamily(this.family, {Iterable<String> fallback = const []}) : fallback = List.unmodifiable(fallback) {
		_checkName(family, 'fontFamily.family');
		for (var index = 0; index < this.fallback.length; index++) {
			_checkName(this.fallback[index], 'fontFamily.fallback[$index]');
		}
	}

	static void _checkName(String name, String path) {
		if (name.isEmpty || name.trim() != name) {
			throw KlpContractError('invalid_primitive_value', '$path: expected a non-empty trimmed font name.');
		}
	}
}
