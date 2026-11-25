# KlpRuledPageBackgroundRecipe

Flutter · Stable · 資料與型別

## 主要職責

等距橫線背景，不決定內容行高或文件排版。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRuledPageBackgroundRecipe createExample() => KlpRuledPageBackgroundRecipe();
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpRuledPageBackgroundRecipe extends KlpPageBackgroundRecipe
```

## 建構子 KlpRuledPageBackgroundRecipe



```dart
KlpRuledPageBackgroundRecipe({
	KlpPageBackgroundAxisStyle? axis,
	double? spacing,
	KlpPageBackgroundStrokeBehavior strokeBehavior = KlpPageBackgroundStrokeBehavior.fixed,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `axis` | `KlpPageBackgroundAxisStyle?` | 否 | null | 依公開型別提供此輸入。 |
| `spacing` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `strokeBehavior` | `KlpPageBackgroundStrokeBehavior` | 否 | KlpPageBackgroundStrokeBehavior.fixed | 依公開型別提供此輸入。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### copyWith

```dart
KlpRuledPageBackgroundRecipe copyWith({
	KlpPageBackgroundAxisStyle? axis,
	double? spacing,
	KlpPageBackgroundStrokeBehavior? strokeBehavior,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `axis` | `KlpPageBackgroundAxisStyle?` | 否 | null | 依公開型別提供此輸入。 |
| `spacing` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `strokeBehavior` | `KlpPageBackgroundStrokeBehavior?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
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
