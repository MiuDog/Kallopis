# KlpReferencePicker

Flutter · Stable · 輸入元件

## 主要職責

以查詢、載入狀態與受控結果清單呈現通用參照選擇器。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpReferencePicker createExample(String title, String query, String queryPlaceholder, List<KlpReferenceOption> results, void Function(String) onQueryChanged, void Function(String)? onSelected) => KlpReferencePicker(title: title, query: query, queryPlaceholder: queryPlaceholder, results: results, onQueryChanged: onQueryChanged, onSelected: onSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpReferencePicker extends StatelessWidget
```

## 建構子 KlpReferencePicker



```dart
const KlpReferencePicker({
	Key? key,
	required String title,
	required String query,
	required String queryPlaceholder,
	required List<KlpReferenceOption> results,
	required ValueChanged<String> onQueryChanged,
	required ValueChanged<String>? onSelected,
	bool loading = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `query` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `queryPlaceholder` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `results` | `List<KlpReferenceOption>` | 是 | — | 依公開型別提供此輸入。 |
| `onQueryChanged` | `void Function(String)` | 是 | — | 依公開型別提供此輸入。 |
| `onSelected` | `void Function(String)?` | 是 | — | 將選取意圖交回產品。 |
| `loading` | `bool` | 否 | false | 依公開型別提供此輸入。 |


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
- [KlpReferenceOption](../../types/klp-reference-option.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/picker/klp_reference_picker.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/picker/klp_reference_picker.dart`。
