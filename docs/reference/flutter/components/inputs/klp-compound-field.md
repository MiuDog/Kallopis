# KlpCompoundField

Flutter · Stable · 輸入元件

## 主要職責

在單一控制框內組合主要文字與受控尾端選項。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCompoundField createExample(String label, String selectedOptionLabel, List<KlpChoiceOption> options) => KlpCompoundField(label: label, selectedOptionLabel: selectedOptionLabel, options: options);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCompoundField extends StatefulWidget
```

## 建構子 KlpCompoundField



```dart
const KlpCompoundField({
	Key? key,
	required String label,
	required String selectedOptionLabel,
	required List<KlpChoiceOption> options,
	TextEditingController? controller,
	String? initialValue,
	String? placeholder,
	ValueChanged<String>? onChanged,
	ValueChanged<String>? onOptionSelected,
	bool enabled = true,
	bool readOnly = false,
	String? error,
	String? optionsLabel,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `selectedOptionLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `options` | `List<KlpChoiceOption>` | 是 | — | 依公開型別提供此輸入。 |
| `controller` | `TextEditingController?` | 否 | null | 借用產品提供的控制器。 |
| `initialValue` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `placeholder` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(String)?` | 否 | null | 將值的變更交回產品。 |
| `onOptionSelected` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `readOnly` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `optionsLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpCompoundField> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpChoiceOption](../../types/klp-choice-option.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/input/klp_compound_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_compound_field.dart`。
