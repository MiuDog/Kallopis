# KlpPageBackgroundElementKind

Flutter · Stable · 資料與型別

## 主要職責

可被選取的背景圖元種類。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpPageBackgroundElementKind.line;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpPageBackgroundElementKind
```

## 建構子 KlpPageBackgroundElementKind



```dart
const KlpPageBackgroundElementKind()
```



## 成員與方法

### line

```dart
static const KlpPageBackgroundElementKind line
```



### point

```dart
static const KlpPageBackgroundElementKind point
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_recipe.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_recipe.dart`。
