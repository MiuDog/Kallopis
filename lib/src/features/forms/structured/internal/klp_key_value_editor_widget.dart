part of '../klp_key_value_editor.dart';

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
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        const KlpGap.heightSize(KlpSpaceSize.tight),
        for (var index = 0; index < entries.length; index++) ...[
          KlpRow(
            children: [
              KlpExpanded(
                child: KlpTextField(
                  initialValue: entries[index].keyText,
                  onChanged: _keyChangedHandler(index),
                ),
              ),
              const KlpGap.widthSize(KlpSpaceSize.tight),
              KlpExpanded(
                child: KlpTextField(
                  initialValue: entries[index].value,
                  onChanged: _valueChangedHandler(index),
                ),
              ),
            ],
          ),
          if (index < entries.length - 1)
            const KlpGap.heightSize(KlpSpaceSize.tight),
        ],
      ],
    );
  }

  ValueChanged<String>? _keyChangedHandler(int index) {
    if (onChanged == null) return null;

    return (value) => _replace(index, entries[index].copyWith(keyText: value));
  }

  ValueChanged<String>? _valueChangedHandler(int index) {
    if (onChanged == null) return null;

    return (value) => _replace(index, entries[index].copyWith(value: value));
  }

  void _replace(int index, KlpKeyValueEntry entry) {
    final next = List<KlpKeyValueEntry>.from(entries)..[index] = entry;

    onChanged?.call(next);
  }
}
