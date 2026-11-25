# KlpSpace

Flutter · Stable · 語意風格

## 主要職責

舊版 static const 間距階梯；新元件必須改讀 context.klp.space。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpSpace.lg;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpSpace
```

## 建構子 KlpSpace



```dart
KlpSpace()
```



## 成員與方法

### lg

```dart
static const double lg
```



### md

```dart
static const double md
```



### page

```dart
static const double page
```



### pageLarge

```dart
static const double pageLarge
```



### sectionLarge

```dart
static const double sectionLarge
```



### sm

```dart
static const double sm
```



### xl

```dart
static const double xl
```



### xs

```dart
static const double xs
```



### xxl

```dart
static const double xxl
```



### xxs

```dart
static const double xxs
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_metrics/klp_metrics.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_metrics/klp_metrics.dart`。
