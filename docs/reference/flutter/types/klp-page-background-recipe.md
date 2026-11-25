# KlpPageBackgroundRecipe

Flutter · Stable · 資料與型別

## 主要職責

頁面背景的不可變視覺 recipe。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpPageBackgroundRecipe value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
sealed class KlpPageBackgroundRecipe
```

## 建構子 KlpPageBackgroundRecipe



```dart
const KlpPageBackgroundRecipe()
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_recipe.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_recipe.dart`。
