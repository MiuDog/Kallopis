# KlpPageBackgroundStyle

Flutter · Stable · 資料與型別

## 主要職責

頁面的內建向量背景樣式。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpPageBackgroundStyle.dots;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpPageBackgroundStyle
```

## 建構子 KlpPageBackgroundStyle



```dart
const KlpPageBackgroundStyle()
```



## 成員與方法

### dots

```dart
static const KlpPageBackgroundStyle dots
```



### grid

```dart
static const KlpPageBackgroundStyle grid
```



### plain

```dart
static const KlpPageBackgroundStyle plain
```



### ruled

```dart
static const KlpPageBackgroundStyle ruled
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background.dart`。
