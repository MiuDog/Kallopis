# KlpSize

Flutter · Stable · 語意風格

## 主要職責

舊版 static const 控制項、圖示、面板與 breakpoint 尺寸。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpSize.commandMenu;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpSize
```

## 建構子 KlpSize



```dart
KlpSize()
```



## 成員與方法

### commandMenu

```dart
static const double commandMenu
```



### control

```dart
static const double control
```



### controlLarge

```dart
static const double controlLarge
```



### controlSmall

```dart
static const double controlSmall
```



### controlXLarge

```dart
static const double controlXLarge
```



### disclosure

```dart
static const double disclosure
```



### header

```dart
static const double header
```

標頭內容。

### icon

```dart
static const double icon
```

操作或內容圖示。

### iconBase

```dart
static const double iconBase
```



### iconButton

```dart
static const double iconButton
```



### iconLarge

```dart
static const double iconLarge
```



### iconMedium

```dart
static const double iconMedium
```



### iconSmall

```dart
static const double iconSmall
```



### inspector

```dart
static const double inspector
```



### listTileTrailingMax

```dart
static const double listTileTrailingMax
```



### menu

```dart
static const double menu
```



### menuHeader

```dart
static const double menuHeader
```



### menuItem

```dart
static const double menuItem
```



### primaryPaneBreakpoint

```dart
static const double primaryPaneBreakpoint
```



### primaryPaneContentBreakpoint

```dart
static const double primaryPaneContentBreakpoint
```



### rail

```dart
static const double rail
```



### secondaryPaneBreakpoint

```dart
static const double secondaryPaneBreakpoint
```



### segmentedDense

```dart
static const double segmentedDense
```



### segmentedDenseItem

```dart
static const double segmentedDenseItem
```



### sidebar

```dart
static const double sidebar
```



### statusBar

```dart
static const double statusBar
```



### tab

```dart
static const double tab
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_metrics/klp_metrics.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_metrics/klp_metrics.dart`。
