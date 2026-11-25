# KlpPageBackgroundStrokeBehavior

Flutter · Stable · 資料與型別

## 主要職責

線寬固定於 viewport，或隨 viewport scale 一起縮放。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpPageBackgroundStrokeBehavior.fixed;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpPageBackgroundStrokeBehavior
```

## 建構子 KlpPageBackgroundStrokeBehavior



```dart
const KlpPageBackgroundStrokeBehavior()
```



## 成員與方法

### fixed

```dart
static const KlpPageBackgroundStrokeBehavior fixed
```



### scaled

```dart
static const KlpPageBackgroundStrokeBehavior scaled
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_recipe.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_recipe.dart`。
