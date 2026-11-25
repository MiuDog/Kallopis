# KlpRadius

Flutter · Stable · 語意風格

## 主要職責

舊版 static const 圓角階梯；新元件必須改讀 context.klp.shape。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpRadius.card;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpRadius
```

## 建構子 KlpRadius



```dart
KlpRadius()
```



## 成員與方法

### card

```dart
static const double card
```



### control

```dart
static const double control
```



### full

```dart
static const double full
```



### lg

```dart
static const double lg
```



### md

```dart
static const double md
```



### none

```dart
static const double none
```



### panel

```dart
static const double panel
```



### pill

```dart
static const double pill
```



### sm

```dart
static const double sm
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_metrics/klp_metrics.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_metrics/klp_metrics.dart`。
