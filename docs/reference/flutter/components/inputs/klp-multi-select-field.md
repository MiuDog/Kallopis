# KlpMultiSelectField

Flutter · Stable · 輸入元件

## 主要職責

多選欄位：所有選項以可切換的標籤形式平鋪展示。

[selectedIds] 由呼叫端持有；點擊選項只透過 [onChanged] 回報下一個集合。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpMultiSelectField createExample(String label, List<KlpChoiceOption> options, Set<String> selectedIds, void Function(Set<String>)? onChanged) => KlpMultiSelectField(label: label, options: options, selectedIds: selectedIds, onChanged: onChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpMultiSelectField extends StatelessWidget
```

## 建構子 KlpMultiSelectField



```dart
const KlpMultiSelectField({
	Key? key,
	required String label,
	required List<KlpChoiceOption> options,
	required Set<String> selectedIds,
	required ValueChanged<Set<String>>? onChanged,
	bool enabled = true,
	bool readOnly = false,
	String? error,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `options` | `List<KlpChoiceOption>` | 是 | — | 依公開型別提供此輸入。 |
| `selectedIds` | `Set<String>` | 是 | — | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(Set<String>)?` | 是 | — | 將值的變更交回產品。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `readOnly` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpChoiceOption](../../types/klp-choice-option.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/selection/klp_multi_select_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_multi_select_field.dart`。
