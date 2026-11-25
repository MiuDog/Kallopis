# KlpDateFieldCalendar

Flutter · Stable · 資料與型別

## 主要職責

[KlpDateField] 掛上月曆挑選面板所需的受控設定。

月份、選取日期、停用規則全部由呼叫端持有並傳入，欄位本身不記憶任何日期。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDateFieldCalendar createExample(DateTime month, String monthLabel, List<String> weekdayLabels, String previousMonthLabel, String nextMonthLabel, void Function(DateTime) onDateSelected) => KlpDateFieldCalendar(month: month, monthLabel: monthLabel, weekdayLabels: weekdayLabels, previousMonthLabel: previousMonthLabel, nextMonthLabel: nextMonthLabel, onDateSelected: onDateSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDateFieldCalendar
```

## 建構子 KlpDateFieldCalendar



```dart
const KlpDateFieldCalendar({
	required DateTime month,
	required String monthLabel,
	required List<String> weekdayLabels,
	required String previousMonthLabel,
	required String nextMonthLabel,
	required ValueChanged<DateTime> onDateSelected,
	DateTime? selectedDate,
	bool Function(DateTime)? isDateDisabled,
	VoidCallback? onPreviousMonth,
	VoidCallback? onNextMonth,
	DateTime? today,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `month` | `DateTime` | 是 | — | 面板目前顯示的月份，轉發給 [KlpCalendar.month]。 |
| `monthLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `weekdayLabels` | `List<String>` | 是 | — | 依公開型別提供此輸入。 |
| `previousMonthLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `nextMonthLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `onDateSelected` | `void Function(DateTime)` | 是 | — | 使用者在面板上點了某一天。欄位會在轉發這個回呼之後自行收起面板。 |
| `selectedDate` | `DateTime?` | 否 | null | 依公開型別提供此輸入。 |
| `isDateDisabled` | `bool Function(DateTime)?` | 否 | null | 依公開型別提供此輸入。 |
| `onPreviousMonth` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onNextMonth` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `today` | `DateTime?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpCalendar](../components/content/klp-calendar.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/selection/klp_date_field_calendar.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_date_field_calendar.dart`。
