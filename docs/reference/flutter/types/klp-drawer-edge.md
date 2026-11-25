# KlpDrawerEdge

Flutter · Stable · 資料與型別

## 主要職責

面板從畫面邊緣滑入的方向。`bottom` 即一般所稱的 sheet。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpDrawerEdge.bottom;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpDrawerEdge
```

## 建構子 KlpDrawerEdge



```dart
const KlpDrawerEdge()
```



## 成員與方法

### bottom

```dart
static const KlpDrawerEdge bottom
```



### left

```dart
static const KlpDrawerEdge left
```



### right

```dart
static const KlpDrawerEdge right
```



### top

```dart
static const KlpDrawerEdge top
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/overlays/klp_drawer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_drawer.dart`。
