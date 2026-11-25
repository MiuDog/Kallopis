# KlpActionRegionShape

Flutter · Stable · 資料與型別

## 主要職責

Action region 的型別化圓角語意。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpActionRegionShape.card;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpActionRegionShape
```

## 建構子 KlpActionRegionShape



```dart
const KlpActionRegionShape()
```



## 成員與方法

### card

```dart
static const KlpActionRegionShape card
```



### control

```dart
static const KlpActionRegionShape control
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/klp_action_region_shape.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_action_region_shape.dart`。
