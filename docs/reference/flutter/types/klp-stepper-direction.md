# KlpStepperDirection

Flutter · Stable · 資料與型別

## 主要職責

Stepper 的語意排列方向。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpStepperDirection.horizontal;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpStepperDirection
```

## 建構子 KlpStepperDirection



```dart
const KlpStepperDirection()
```



## 成員與方法

### horizontal

```dart
static const KlpStepperDirection horizontal
```



### vertical

```dart
static const KlpStepperDirection vertical
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/stepper/klp_stepper.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/stepper/klp_stepper.dart`。
