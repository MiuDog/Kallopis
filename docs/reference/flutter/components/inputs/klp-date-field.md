# KlpDateField

Flutter · Stable · 輸入元件

## 主要職責

日期輸入欄位。文字輸入永遠可用；提供 [calendar] 時額外接上 [KlpCalendar]
作為挑選面板，兩套輸入路徑共用同一個文字結果，不是各自獨立的兩個元件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDateField createExample(String label, String value, void Function(String)? onChanged) => KlpDateField(label: label, value: value, onChanged: onChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDateField extends StatefulWidget
```

## 建構子 KlpDateField



```dart
const KlpDateField({
	Key? key,
	required String label,
	required String value,
	required ValueChanged<String>? onChanged,
	String? placeholder,
	KlpDateFieldCalendar? calendar,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `value` | `String` | 是 | — | 目前值。 |
| `onChanged` | `void Function(String)?` | 是 | — | 將值的變更交回產品。 |
| `placeholder` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `calendar` | `KlpDateFieldCalendar?` | 否 | null | 月曆挑選面板的設定；`null` 時欄位維持純文字輸入。 |


## 成員與方法

### createState

```dart
State<KlpDateField> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpDateFieldCalendar](../../types/klp-date-field-calendar.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/selection/klp_date_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_date_field.dart`。
