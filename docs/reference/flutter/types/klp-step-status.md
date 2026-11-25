# KlpStepStatus

Flutter · Stable · 資料與型別

## 主要職責

單一步驟相對於 [KlpStepper.currentIndex] 的狀態。

由 [KlpStepper] 依步驟位置自動推導，呼叫端不需要（也不應該）自行指定——
三態永遠只由「目前在第幾步」這一個事實決定。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpStepStatus.completed;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpStepStatus
```

## 建構子 KlpStepStatus



```dart
const KlpStepStatus()
```



## 成員與方法

### completed

```dart
static const KlpStepStatus completed
```



### current

```dart
static const KlpStepStatus current
```



### upcoming

```dart
static const KlpStepStatus upcoming
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/stepper/klp_stepper.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/stepper/klp_stepper.dart`。
