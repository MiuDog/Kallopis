# KlpCalendar

Flutter · Stable · 內容元件

## 主要職責

月曆面板：月份切換、日期格、今天標記、選取狀態，並可停用特定日期。

*這是純顯示元件，不持有任何日期狀態**——目前顯示的月份、選取的日期都由呼叫端
透過 [month]、[selectedDate]／[selectedRange] 傳入，切換月份與選日期一律經
[onPreviousMonth]／[onNextMonth]／[onDateSelected] 回呼，由呼叫端決定下一步狀態。

*不內建任何語言字串。** 月份標題（[monthLabel]）與星期縮寫（[weekdayLabels]）
一律由呼叫端組出——本庫沒有 l10n 機制，不替產品決定用哪種語言、哪一天是一週的
開始（見 [firstWeekday]）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCalendar createExample(DateTime month, String monthLabel, List<String> weekdayLabels, String previousMonthLabel, String nextMonthLabel) => KlpCalendar(month: month, monthLabel: monthLabel, weekdayLabels: weekdayLabels, previousMonthLabel: previousMonthLabel, nextMonthLabel: nextMonthLabel);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCalendar extends StatelessWidget
```

## 建構子 KlpCalendar



```dart
const KlpCalendar({
	Key? key,
	required DateTime month,
	required String monthLabel,
	required List<String> weekdayLabels,
	required String previousMonthLabel,
	required String nextMonthLabel,
	KlpCalendarSelectionMode mode = KlpCalendarSelectionMode.single,
	DateTime? selectedDate,
	KlpCalendarRange? selectedRange,
	DateTime? today,
	bool Function(DateTime)? isDateDisabled,
	ValueChanged<DateTime>? onDateSelected,
	VoidCallback? onPreviousMonth,
	VoidCallback? onNextMonth,
	int firstWeekday = DateTime.monday,
	Widget? Function(DateTime)? dayContentBuilder,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `month` | `DateTime` | 是 | — | 目前顯示的月份；只有年與月有意義，日的部分會被忽略。 |
| `monthLabel` | `String` | 是 | — | 月份標題文字，例如「2026 年 8 月」——由呼叫端組出。 |
| `weekdayLabels` | `List<String>` | 是 | — | 星期縮寫，長度必須是 7，順序須對齊從 [firstWeekday] 起算的一週。 |
| `previousMonthLabel` | `String` | 是 | — | 「上一個月」按鈕的無障礙標籤。 |
| `nextMonthLabel` | `String` | 是 | — | 「下一個月」按鈕的無障礙標籤。 |
| `mode` | `KlpCalendarSelectionMode` | 否 | KlpCalendarSelectionMode.single | 單日或區間選取。 |
| `selectedDate` | `DateTime?` | 否 | null | [KlpCalendarSelectionMode.single] 時使用的目前選取日期。 |
| `selectedRange` | `KlpCalendarRange?` | 否 | null | [KlpCalendarSelectionMode.range] 時使用的目前選取區間。 |
| `today` | `DateTime?` | 否 | null | 「今天」標記使用的日期，`null` 表示不畫標記。<br><br>*本元件不會自行呼叫 `DateTime.now()`**——那會讓渲染結果依執行當下時間而異，<br>golden test 也無法穩定比對；「今天」是誰由呼叫端決定並傳入。 |
| `isDateDisabled` | `bool Function(DateTime)?` | 否 | null | 判斷某個日期是否停用。回傳 `true` 的日期不可點擊，樣式也會轉為 faint。 |
| `onDateSelected` | `void Function(DateTime)?` | 否 | null | 使用者點擊某個未停用日期時呼叫。 |
| `onPreviousMonth` | `void Function()?` | 否 | null | 使用者點擊「上一個月」時呼叫。傳 `null` 停用該按鈕。 |
| `onNextMonth` | `void Function()?` | 否 | null | 使用者點擊「下一個月」時呼叫。傳 `null` 停用該按鈕。 |
| `firstWeekday` | `int` | 否 | DateTime.monday | 一週的第一天，採 `DateTime.monday`（1）～`DateTime.sunday`（7）編碼。 |
| `dayContentBuilder` | `Widget? Function(DateTime)?` | 否 | null | 每一格日期底下要放什麼。<br><br>`null` 表示只顯示日期數字，格高用 [KlpSpacingTheme.controlHeightSmall]；<br>給了 builder 就切換成內容格，格高改用<br>[KlpSpacingTheme.calendarContentCell]——日期數字加內容擠在選擇器的格高裡會糊成一團。<br><br>*這是 slot 而不是布林參數**：月曆不需要知道格子裡放的是待辦、排程還是別的東西，<br>那屬於呼叫端的語意。回傳 `null` 代表這一格沒有內容。 |


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
- [KlpCalendarRange](../../types/klp-calendar-range.md)
- [KlpCalendarSelectionMode](../../types/klp-calendar-selection-mode.md)
- [KlpSpacingTheme](../../styling/klp-spacing-theme.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/selection/klp_calendar.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_calendar.dart`。
