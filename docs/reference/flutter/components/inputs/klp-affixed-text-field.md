# KlpAffixedTextField

Flutter · Stable · 輸入元件

## 主要職責

在文字輸入旁提供不可編輯前綴與尾端語意動作。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAffixedTextField createExample(String label) => KlpAffixedTextField(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpAffixedTextField extends StatelessWidget
```

## 建構子 KlpAffixedTextField



```dart
const KlpAffixedTextField({
	Key? key,
	required String label,
	TextEditingController? controller,
	String? initialValue,
	String? placeholder,
	String? prefixText,
	KlpIconData? actionIcon,
	String? actionLabel,
	VoidCallback? onAction,
	ValueChanged<String>? onChanged,
	bool enabled = true,
	bool readOnly = false,
	String? error,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `controller` | `TextEditingController?` | 否 | null | 借用產品提供的控制器。 |
| `initialValue` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `placeholder` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `prefixText` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `actionIcon` | `KlpIconData?` | 否 | null | 依公開型別提供此輸入。 |
| `actionLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onAction` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(String)?` | 否 | null | 將值的變更交回產品。 |
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
- [KlpIconData](../../types/klp-icon-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/input/klp_affixed_text_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_affixed_text_field.dart`。
