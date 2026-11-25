# KlpCodeMetrics

Flutter · Stable · 語意風格

## 主要職責

舊版程式碼展示元件固定幾何。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpCodeMetrics.actionButtonSize;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpCodeMetrics
```

## 建構子 KlpCodeMetrics



```dart
KlpCodeMetrics()
```



## 成員與方法

### actionButtonSize

```dart
static const double actionButtonSize
```



### actionIconSize

```dart
static const double actionIconSize
```



### bodyPaddingHorizontal

```dart
static const double bodyPaddingHorizontal
```



### bodyPaddingVertical

```dart
static const double bodyPaddingVertical
```



### defaultMaximumHeight

```dart
static const double defaultMaximumHeight
```



### headerHeight

```dart
static const double headerHeight
```



### headerPaddingHorizontal

```dart
static const double headerPaddingHorizontal
```



### lineNumberWidth

```dart
static const double lineNumberWidth
```



### terminalDot

```dart
static const double terminalDot
```



### terminalDotGap

```dart
static const double terminalDotGap
```



### terminalGroupGap

```dart
static const double terminalGroupGap
```



### wrappedLineWidth

```dart
static const double wrappedLineWidth
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_metrics/klp_metrics.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_metrics/klp_metrics.dart`。
