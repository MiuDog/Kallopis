# KlpEntityPicker

Flutter · Experimental · 輸入元件

## 主要職責

提供實體選取介面；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpEntityPicker createExample(String title, String initialQuery, List<KlpEntityResultData> results, void Function(String) onQueryChanged, void Function() onClear, void Function() onApply) => KlpEntityPicker(title: title, initialQuery: initialQuery, results: results, onQueryChanged: onQueryChanged, onClear: onClear, onApply: onApply);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpEntityPicker extends StatelessWidget
```

## 建構子 KlpEntityPicker



```dart
const KlpEntityPicker({
	Key? key,
	required String title,
	required String initialQuery,
	required List<KlpEntityResultData> results,
	required ValueChanged<String> onQueryChanged,
	required VoidCallback onClear,
	required VoidCallback onApply,
	ValueChanged<int>? onResultSelected,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `initialQuery` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `results` | `List<KlpEntityResultData>` | 是 | — | 依公開型別提供此輸入。 |
| `onQueryChanged` | `void Function(String)` | 是 | — | 依公開型別提供此輸入。 |
| `onClear` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |
| `onApply` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |
| `onResultSelected` | `void Function(int)?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpEntityResultData](../../types/klp-entity-result-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/entity_picker/klp_entity_picker.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/entity_picker/klp_entity_picker.dart`。
