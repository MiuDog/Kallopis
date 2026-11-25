# KlpPlaceholderMetrics

Flutter · Stable · 語意風格

## 主要職責

舊版 region placeholder 固定幾何。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpPlaceholderMetrics.actionLeadingGap;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpPlaceholderMetrics
```

## 建構子 KlpPlaceholderMetrics



```dart
KlpPlaceholderMetrics()
```



## 成員與方法

### actionLeadingGap

```dart
static const double actionLeadingGap
```



### actionPaddingHorizontal

```dart
static const double actionPaddingHorizontal
```



### actionPaddingVertical

```dart
static const double actionPaddingVertical
```



### contentGap

```dart
static const double contentGap
```



### contentPaddingHorizontal

```dart
static const double contentPaddingHorizontal
```



### contentPaddingVertical

```dart
static const double contentPaddingVertical
```



### darkHatchColorMix

```dart
static const double darkHatchColorMix
```



### detailMaximumWidth

```dart
static const double detailMaximumWidth
```



### hatchBand

```dart
static const double hatchBand
```



### hatchGap

```dart
static const double hatchGap
```



### hatchStrokeWidth

```dart
static const double hatchStrokeWidth
```



### labelLetterSpacing

```dart
static const double labelLetterSpacing
```



### latentStrokeOpacity

```dart
static const double latentStrokeOpacity
```



### markerSize

```dart
static const double markerSize
```



### minimumHeight

```dart
static const double minimumHeight
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_metrics/klp_metrics.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_metrics/klp_metrics.dart`。
