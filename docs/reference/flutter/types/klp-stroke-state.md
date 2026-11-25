# KlpStrokeState

Flutter · Stable · 資料與型別

## 主要職責

提供描邊狀態；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpStrokeState.disabled;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpStrokeState
```

## 建構子 KlpStrokeState



```dart
const KlpStrokeState()
```



## 成員與方法

### disabled

```dart
static const KlpStrokeState disabled
```



### focused

```dart
static const KlpStrokeState focused
```



### hovered

```dart
static const KlpStrokeState hovered
```



### rest

```dart
static const KlpStrokeState rest
```



### selected

```dart
static const KlpStrokeState selected
```

由產品持有的選取狀態。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/klp_stroke.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/klp_stroke.dart`。
