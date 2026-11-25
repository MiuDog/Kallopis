# KlpFormMetrics

Flutter · Stable · 語意風格

## 主要職責

舊版表單控制項固定幾何。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpFormMetrics.fieldHeight;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpFormMetrics
```

## 建構子 KlpFormMetrics



```dart
KlpFormMetrics()
```



## 成員與方法

### fieldHeight

```dart
static const double fieldHeight
```



### selectionControl

```dart
static const double selectionControl
```



### selectionIcon

```dart
static const double selectionIcon
```



### selectionIndicator

```dart
static const double selectionIndicator
```



### selectionIndicatorInset

```dart
static const double selectionIndicatorInset
```



### toggleHeight

```dart
static const double toggleHeight
```



### toggleInset

```dart
static const double toggleInset
```



### toggleThumb

```dart
static const double toggleThumb
```



### toggleWidth

```dart
static const double toggleWidth
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_metrics/klp_metrics.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_metrics/klp_metrics.dart`。
