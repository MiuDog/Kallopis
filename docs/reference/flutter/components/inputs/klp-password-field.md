# KlpPasswordField

Flutter · Stable · 輸入元件

## 主要職責

密碼輸入控制項。支援顯示／隱藏密碼切換與密碼強度／規則檢核清單。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPasswordField createExample(String label) => KlpPasswordField(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPasswordField extends StatefulWidget
```

## 建構子 KlpPasswordField



```dart
const KlpPasswordField({
	Key? key,
	required String label,
	String? value,
	String? placeholder,
	String? error,
	ValueChanged<String>? onChanged,
	bool enabled = true,
	bool readOnly = false,
	bool required = false,
	List<KlpPasswordRequirement>? requirements,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `value` | `String?` | 否 | null | 目前值。 |
| `placeholder` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(String)?` | 否 | null | 將值的變更交回產品。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `readOnly` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `required` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `requirements` | `List<KlpPasswordRequirement>?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpPasswordField> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpPasswordRequirement](../../types/klp-password-requirement.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/input/klp_password_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_password_field.dart`。
