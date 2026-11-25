# KlpPeriodicPageBackgroundRecipe

Flutter · Stable · 資料與型別

## 主要職責

具有主軸與次軸週期的背景共用契約。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpPeriodicPageBackgroundRecipe value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
sealed class KlpPeriodicPageBackgroundRecipe extends KlpPageBackgroundRecipe
```

## 建構子 KlpPeriodicPageBackgroundRecipe



```dart
KlpPeriodicPageBackgroundRecipe({
	KlpPageBackgroundAxisStyle? minorAxis,
	KlpPageBackgroundAxisStyle? majorAxis,
	double? majorSpacing,
	int minorAxisCount = 0,
	KlpPageBackgroundStrokeBehavior strokeBehavior = KlpPageBackgroundStrokeBehavior.fixed,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `minorAxis` | `KlpPageBackgroundAxisStyle?` | 否 | null | 依公開型別提供此輸入。 |
| `majorAxis` | `KlpPageBackgroundAxisStyle?` | 否 | null | 依公開型別提供此輸入。 |
| `majorSpacing` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `minorAxisCount` | `int` | 否 | 0 | 依公開型別提供此輸入。 |
| `strokeBehavior` | `KlpPageBackgroundStrokeBehavior` | 否 | KlpPageBackgroundStrokeBehavior.fixed | 依公開型別提供此輸入。 |


## 成員與方法

### equalsPeriodic

```dart
bool equalsPeriodic(KlpPeriodicPageBackgroundRecipe other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpPeriodicPageBackgroundRecipe` | 是 | — | 依公開型別提供此輸入。 |


### minorSpacing

```dart
double? get minorSpacing
```



### periodicHashCode

```dart
int get periodicHashCode
```



<!-- reference-api:end -->

## 使用限制與關聯

- 繼承／實作：[KlpPageBackgroundRecipe](klp-page-background-recipe.md)。
- [KlpPageBackgroundAxisStyle](klp-page-background-axis-style.md)
- [KlpPageBackgroundRecipe](klp-page-background-recipe.md)
- [KlpPageBackgroundStrokeBehavior](klp-page-background-stroke-behavior.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_recipe.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_recipe.dart`。
