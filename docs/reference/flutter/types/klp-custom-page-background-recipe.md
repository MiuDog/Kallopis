# KlpCustomPageBackgroundRecipe

Flutter · Stable · 資料與型別

## 主要職責

只允許 point 與 line 的自訂背景資料，不保存產品狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCustomPageBackgroundRecipe createExample() => KlpCustomPageBackgroundRecipe();
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpCustomPageBackgroundRecipe extends KlpPageBackgroundRecipe
```

## 建構子 KlpCustomPageBackgroundRecipe



```dart
KlpCustomPageBackgroundRecipe({
	List<KlpPageBackgroundPoint> points = const [],
	List<KlpPageBackgroundLine> lines = const [],
	KlpPageBackgroundAxisStyle? pointStyle,
	KlpPageBackgroundAxisStyle? lineStyle,
	double? snapSpacing,
	KlpPageBackgroundStrokeBehavior strokeBehavior = KlpPageBackgroundStrokeBehavior.fixed,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `points` | `List<KlpPageBackgroundPoint>` | 否 | const [] | 依公開型別提供此輸入。 |
| `lines` | `List<KlpPageBackgroundLine>` | 否 | const [] | 依公開型別提供此輸入。 |
| `pointStyle` | `KlpPageBackgroundAxisStyle?` | 否 | null | 依公開型別提供此輸入。 |
| `lineStyle` | `KlpPageBackgroundAxisStyle?` | 否 | null | 依公開型別提供此輸入。 |
| `snapSpacing` | `double?` | 否 | null | 依公開型別提供此輸入。 |
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
KlpCustomPageBackgroundRecipe copyWith({
	List<KlpPageBackgroundPoint>? points,
	List<KlpPageBackgroundLine>? lines,
	KlpPageBackgroundAxisStyle? pointStyle,
	KlpPageBackgroundAxisStyle? lineStyle,
	double? snapSpacing,
	KlpPageBackgroundStrokeBehavior? strokeBehavior,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `points` | `List<KlpPageBackgroundPoint>?` | 否 | null | 依公開型別提供此輸入。 |
| `lines` | `List<KlpPageBackgroundLine>?` | 否 | null | 依公開型別提供此輸入。 |
| `pointStyle` | `KlpPageBackgroundAxisStyle?` | 否 | null | 依公開型別提供此輸入。 |
| `lineStyle` | `KlpPageBackgroundAxisStyle?` | 否 | null | 依公開型別提供此輸入。 |
| `snapSpacing` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `strokeBehavior` | `KlpPageBackgroundStrokeBehavior?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



### nextLineId

```dart
int get nextLineId
```



### nextPointId

```dart
int get nextPointId
```



### pointById

```dart
KlpPageBackgroundPoint? pointById(int id)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `int` | 是 | — | 穩定識別，用於查詢或回報。 |


### removeLine

```dart
KlpCustomPageBackgroundRecipe removeLine(int id)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `int` | 是 | — | 穩定識別，用於查詢或回報。 |


### removePoint

```dart
KlpCustomPageBackgroundRecipe removePoint(int id)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `int` | 是 | — | 穩定識別，用於查詢或回報。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 繼承／實作：[KlpPageBackgroundRecipe](klp-page-background-recipe.md)。
- [KlpPageBackgroundAxisStyle](klp-page-background-axis-style.md)
- [KlpPageBackgroundLine](klp-page-background-line.md)
- [KlpPageBackgroundPoint](klp-page-background-point.md)
- [KlpPageBackgroundRecipe](klp-page-background-recipe.md)
- [KlpPageBackgroundStrokeBehavior](klp-page-background-stroke-behavior.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_recipe.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_recipe.dart`。
