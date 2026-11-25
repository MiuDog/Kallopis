# KlpCalendarRange

Flutter · Stable · 資料與型別

## 主要職責

一段日期區間，用於 [KlpCalendarSelectionMode.range]。

[end] 為 `null` 表示只選了起點、尚未選終點——這時 [contains] 只有 [start]
本身算落在區間內。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCalendarRange createExample(DateTime start) => KlpCalendarRange(start: start);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCalendarRange
```

## 建構子 KlpCalendarRange



```dart
const KlpCalendarRange({required DateTime start, DateTime? end})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `start` | `DateTime` | 是 | — | 依公開型別提供此輸入。 |
| `end` | `DateTime?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### contains

```dart
bool contains(DateTime date)
```

[date] 是否落在（含端點）目前的區間內。[start] 與 [end] 先後顛倒時會自動校正。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `date` | `DateTime` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/selection/klp_calendar.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_calendar.dart`。
