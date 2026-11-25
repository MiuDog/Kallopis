# KlpKeyValueEditor

Flutter · Stable · 內容元件

## 主要職責

任意鍵值對清單的編輯器（例如 HTTP header、環境變數），每列一個 key 輸入
框與一個 value 輸入框。

不提供新增／刪除列的按鈕——這個元件只負責編輯既有 [entries] 的內容，
增減列數請自行在 [entries] 外包一層（可參考 [KlpRepeaterField] 的模式）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpKeyValueEditor createExample(String label, List<KlpKeyValueEntry> entries, void Function(List<KlpKeyValueEntry>)? onChanged) => KlpKeyValueEditor(label: label, entries: entries, onChanged: onChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpKeyValueEditor extends StatelessWidget
```

## 建構子 KlpKeyValueEditor



```dart
const KlpKeyValueEditor({
	Key? key,
	required String label,
	required List<KlpKeyValueEntry> entries,
	required ValueChanged<List<KlpKeyValueEntry>>? onChanged,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `entries` | `List<KlpKeyValueEntry>` | 是 | — | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(List<KlpKeyValueEntry>)?` | 是 | — | 將值的變更交回產品。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpKeyValueEntry](../../types/klp-key-value-entry.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/structured/klp_key_value_editor.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/structured/klp_key_value_editor.dart`。
