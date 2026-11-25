# KlpTextField

Flutter · Stable · 輸入元件

## 主要職責

單行或多行文字輸入。底層輸入能力由 Kallopis primitive 提供，消費者不需要
額外準備 `Material` 祖先。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTextField createExample() => KlpTextField();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTextField extends StatefulWidget
```

## 建構子 KlpTextField



```dart
const KlpTextField({
	Key? key,
	String? label,
	String? placeholder,
	String? helper,
	String? error,
	KlpIconData? leadingIcon,
	KlpIconWeight leadingIconWeight = KlpIconWeight.regular,
	String? initialValue,
	TextEditingController? controller,
	int? maxLength,
	KlpControlSize size = KlpControlSize.md,
	ValueChanged<String>? onChanged,
	ValueChanged<String>? onSubmitted,
	FocusNode? focusNode,
	bool autofocus = false,
	bool enabled = true,
	bool multiline = false,
	int? minLines,
	int? maxLines,
	bool unboundedLines = false,
	bool outlined = false,
	String? suffixText,
	bool obscureText = false,
	KlpIconData? trailingActionIcon,
	KlpIconWeight trailingActionIconWeight = KlpIconWeight.regular,
	String? trailingActionLabel,
	VoidCallback? onTrailingActionPressed,
	bool stepper = false,
	bool clearable = false,
	bool conflict = false,
	bool readOnly = false,
	VoidCallback? onClear,
	VoidCallback? onStepUp,
	VoidCallback? onStepDown,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |
| `placeholder` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `helper` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `leadingIcon` | `KlpIconData?` | 否 | null | 依公開型別提供此輸入。 |
| `leadingIconWeight` | `KlpIconWeight` | 否 | KlpIconWeight.regular | 依公開型別提供此輸入。 |
| `initialValue` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `controller` | `TextEditingController?` | 否 | null | 外部持有的文字控制器。沒有給時本元件用 [initialValue] 自行管理；給了<br>[controller] 就由呼叫端全權掌控文字內容，兩者互斥。 |
| `maxLength` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `size` | `KlpControlSize` | 否 | KlpControlSize.md | 尺寸選擇。 |
| `onChanged` | `void Function(String)?` | 否 | null | 將值的變更交回產品。 |
| `onSubmitted` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `focusNode` | `FocusNode?` | 否 | null | 依公開型別提供此輸入。 |
| `autofocus` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `multiline` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `minLines` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `maxLines` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `unboundedLines` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `outlined` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `suffixText` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `obscureText` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `trailingActionIcon` | `KlpIconData?` | 否 | null | 依公開型別提供此輸入。 |
| `trailingActionIconWeight` | `KlpIconWeight` | 否 | KlpIconWeight.regular | 依公開型別提供此輸入。 |
| `trailingActionLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onTrailingActionPressed` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `stepper` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `clearable` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `conflict` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `readOnly` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `onClear` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onStepUp` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onStepDown` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpTextField> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpControlSize](../../types/klp-control-size.md)
- [KlpIconData](../../types/klp-icon-data.md)
- [KlpIconWeight](../../types/klp-icon-weight.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/input/klp_text_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_text_field.dart`。
