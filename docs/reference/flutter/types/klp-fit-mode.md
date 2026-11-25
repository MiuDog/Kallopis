# KlpFitMode

Flutter · Stable · 資料與型別

## 主要職責

內容在可用空間中的縮放策略。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpFitMode.contain;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpFitMode
```

## 建構子 KlpFitMode



```dart
const KlpFitMode()
```



## 成員與方法

### contain

```dart
static const KlpFitMode contain
```



### cover

```dart
static const KlpFitMode cover
```



### fill

```dart
static const KlpFitMode fill
```



### fitHeight

```dart
static const KlpFitMode fitHeight
```



### fitWidth

```dart
static const KlpFitMode fitWidth
```



### none

```dart
static const KlpFitMode none
```



### scaleDown

```dart
static const KlpFitMode scaleDown
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/layout/klp_fit_mode.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_fit_mode.dart`。
