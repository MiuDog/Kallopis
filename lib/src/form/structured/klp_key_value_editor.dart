import '../internal/klp_form_dependencies.dart';

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
/// 任意鍵值對清單的編輯器（例如 HTTP header、環境變數），每列一個 key 輸入
/// 框與一個 value 輸入框。
///
/// 不提供新增／刪除列的按鈕——這個元件只負責編輯既有 [entries] 的內容，
/// 增減列數請自行在 [entries] 外包一層（可參考 [KlpRepeaterField] 的模式）。
class KlpKeyValueEditor extends StatelessWidget {
	const KlpKeyValueEditor({
		super.key,
		required this.label,
		required this.entries,
		required this.onChanged,
	});

	final String label;
	final List<KlpKeyValueEntry> entries;
	final ValueChanged<List<KlpKeyValueEntry>>? onChanged;

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(label, role: KlpTextRole.caption),
				SizedBox(height: context.klp.space.tight),
				for (var index = 0; index < entries.length; index++) ...[
					Row(
						children: [
							Expanded(
								child: KlpTextField(
									initialValue: entries[index].keyText,
									onChanged: onChanged == null
											? null
											: (value) => _replace(
													index,
													entries[index].copyWith(keyText: value),
												),
								),
							),
							SizedBox(width: context.klp.space.tight),
							Expanded(
								child: KlpTextField(
									initialValue: entries[index].value,
									onChanged: onChanged == null
											? null
											: (value) => _replace(
													index,
													entries[index].copyWith(value: value),
												),
								),
							),
						],
					),
					if (index < entries.length - 1)
						SizedBox(height: context.klp.space.tight),
				],
			],
		);
	}

	void _replace(int index, KlpKeyValueEntry entry) {
		final next = List<KlpKeyValueEntry>.from(entries)..[index] = entry;
		onChanged?.call(next);
	}
}
