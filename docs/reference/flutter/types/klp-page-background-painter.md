# KlpPageBackgroundPainter

Flutter · Stable · 資料與型別

## 主要職責

所有頁面背景 recipe 共用的 renderer。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPageBackgroundPainter createExample(KlpPageBackgroundRecipe recipe, KlpPageBackgroundViewport viewport, KlpPageBackgroundVisuals visuals) => KlpPageBackgroundPainter(recipe: recipe, viewport: viewport, visuals: visuals);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPageBackgroundPainter extends CustomPainter
```

## 建構子 KlpPageBackgroundPainter



```dart
const KlpPageBackgroundPainter({
	required KlpPageBackgroundRecipe recipe,
	required KlpPageBackgroundViewport viewport,
	required KlpPageBackgroundVisuals visuals,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `recipe` | `KlpPageBackgroundRecipe` | 是 | — | 依公開型別提供此輸入。 |
| `viewport` | `KlpPageBackgroundViewport` | 是 | — | 依公開型別提供此輸入。 |
| `visuals` | `KlpPageBackgroundVisuals` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### paint

```dart
void paint(Canvas canvas, Size size)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `canvas` | `Canvas` | 是 | — | 依公開型別提供此輸入。 |
| `size` | `Size` | 是 | — | 尺寸選擇。 |


### resolveMarkWidth

```dart
double resolveMarkWidth(
	KlpPageBackgroundAxisStyle axis,
	KlpPageBackgroundStrokeBehavior behavior, {
	double? defaultWidth,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `axis` | `KlpPageBackgroundAxisStyle` | 是 | — | 依公開型別提供此輸入。 |
| `behavior` | `KlpPageBackgroundStrokeBehavior` | 是 | — | 依公開型別提供此輸入。 |
| `defaultWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |


### shouldRepaint

```dart
bool shouldRepaint(KlpPageBackgroundPainter oldDelegate)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `oldDelegate` | `KlpPageBackgroundPainter` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[CustomPainter](https://api.flutter.dev/flutter/rendering/CustomPainter-class.html)。
- [KlpPageBackgroundAxisStyle](klp-page-background-axis-style.md)
- [KlpPageBackgroundRecipe](klp-page-background-recipe.md)
- [KlpPageBackgroundStrokeBehavior](klp-page-background-stroke-behavior.md)
- [KlpPageBackgroundViewport](klp-page-background-viewport.md)
- [KlpPageBackgroundVisuals](klp-page-background-visuals.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_painter.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_painter.dart`。
