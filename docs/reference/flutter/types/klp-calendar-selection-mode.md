# KlpCalendarSelectionMode

Flutter · Stable · 資料與型別

## 主要職責

月曆的選取模式：單日或區間。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpCalendarSelectionMode.range;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpCalendarSelectionMode
```

## 建構子 KlpCalendarSelectionMode



```dart
const KlpCalendarSelectionMode()
```



## 成員與方法

### range

```dart
static const KlpCalendarSelectionMode range
```



### single

```dart
static const KlpCalendarSelectionMode single
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/selection/klp_calendar.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_calendar.dart`。
