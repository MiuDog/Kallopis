part of '../klp_key_value_editor.dart';

/// [KlpKeyValueEditor] 裡的一組鍵值對，[id] 用來在清單改動時識別是哪一列
/// （純文字的 key 可能重複或暫時是空字串，不適合當識別碼）。
@immutable
class KlpKeyValueEntry {
	const KlpKeyValueEntry({
		required this.id,
		required this.keyText,
		required this.value,
	});

	final String id;
	final String keyText;
	final String value;

	KlpKeyValueEntry copyWith({String? keyText, String? value}) {
		return KlpKeyValueEntry(
			id: id,
			keyText: keyText ?? this.keyText,
			value: value ?? this.value,
		);
	}
}
