# KlpVisualStyle

Flutter · Stable · 語意風格

## 主要職責

一整套視覺風格。

這個型別存在的理由是**讓「換一套視覺風格」成為單一動作**。若風格散落在多個
`ThemeExtension` 各自設定，消費者遲早會只換其中三個——換出一個圓角是方的、動畫卻還在
的半套風格。把它們綁成一個必須整組給定的物件，那種狀態就無法表達。

消費者要微調，是取一個現成風格再 [copyWith] 單一層，而不是自己拼所有 extension。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpVisualStyle createExample(String name, KlpThemeData colors, KlpTypographyTheme typography, KlpSpacingTheme spacing, KlpShapeTheme shape, KlpMotionTheme motion, KlpSurfaceTheme surface, KlpComponentTheme components) => KlpVisualStyle(name: name, colors: colors, typography: typography, spacing: spacing, shape: shape, motion: motion, surface: surface, components: components);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpVisualStyle
```

## 建構子 KlpVisualStyle



```dart
const KlpVisualStyle({
	required String name,
	required KlpThemeData colors,
	required KlpTypographyTheme typography,
	required KlpSpacingTheme spacing,
	required KlpShapeTheme shape,
	required KlpMotionTheme motion,
	required KlpSurfaceTheme surface,
	required KlpComponentTheme components,
	KlpDataVisualizationTheme dataVisualization = KlpDataVisualizationTheme.light,
	KlpGeometryTheme geometry = KlpGeometryTheme.standard,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `name` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `colors` | `KlpThemeData` | 是 | — | 依公開型別提供此輸入。 |
| `typography` | `KlpTypographyTheme` | 是 | — | 依公開型別提供此輸入。 |
| `spacing` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |
| `motion` | `KlpMotionTheme` | 是 | — | 依公開型別提供此輸入。 |
| `surface` | `KlpSurfaceTheme` | 是 | — | 依公開型別提供此輸入。 |
| `components` | `KlpComponentTheme` | 是 | — | 依公開型別提供此輸入。 |
| `dataVisualization` | `KlpDataVisualizationTheme` | 否 | KlpDataVisualizationTheme.light | 依公開型別提供此輸入。 |
| `geometry` | `KlpGeometryTheme` | 否 | KlpGeometryTheme.standard | 依公開型別提供此輸入。 |


## 成員與方法

### copyWith

```dart
KlpVisualStyle copyWith({
	String? name,
	KlpThemeData? colors,
	KlpTypographyTheme? typography,
	KlpSpacingTheme? spacing,
	KlpShapeTheme? shape,
	KlpMotionTheme? motion,
	KlpSurfaceTheme? surface,
	KlpComponentTheme? components,
	KlpDataVisualizationTheme? dataVisualization,
	KlpGeometryTheme? geometry,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `name` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `colors` | `KlpThemeData?` | 否 | null | 依公開型別提供此輸入。 |
| `typography` | `KlpTypographyTheme?` | 否 | null | 依公開型別提供此輸入。 |
| `spacing` | `KlpSpacingTheme?` | 否 | null | 依公開型別提供此輸入。 |
| `shape` | `KlpShapeTheme?` | 否 | null | 依公開型別提供此輸入。 |
| `motion` | `KlpMotionTheme?` | 否 | null | 依公開型別提供此輸入。 |
| `surface` | `KlpSurfaceTheme?` | 否 | null | 依公開型別提供此輸入。 |
| `components` | `KlpComponentTheme?` | 否 | null | 依公開型別提供此輸入。 |
| `dataVisualization` | `KlpDataVisualizationTheme?` | 否 | null | 依公開型別提供此輸入。 |
| `geometry` | `KlpGeometryTheme?` | 否 | null | 依公開型別提供此輸入。 |


### defaultStyle

```dart
static const KlpVisualStyle defaultStyle
```

預設風格：比例字體、圓角、陰影分層、寬鬆密度、有過場動畫。

### extensions

```dart
List<ThemeExtension<dynamic>> get extensions
```

交給 `ThemeData.extensions` 的完整清單。少放任何一項，該層就會退回預設值而不會
報錯——因此這裡刻意不提供「部分產生」的版本。

### forBrightness

```dart
static KlpVisualStyle forBrightness(Brightness brightness)
```

取得預設風格在指定明暗模式下的完整色彩組合。

這不是第二套視覺 preset；字體、間距、形狀、動態與元件 token 都沿用
[defaultStyle]，只有本來就隨明暗切換的色彩層與資料視覺化色盤成組切換。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `brightness` | `Brightness` | 是 | — | 依公開型別提供此輸入。 |


### modern

```dart
static const KlpVisualStyle modern
```

舊名稱別名，相容於既有程式碼。

### withReducedMotion

```dart
KlpVisualStyle withReducedMotion(bool reduce)
```

套用系統的「減少動態效果」設定。無障礙規則由庫負責，不交給每個消費者各自實作。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `reduce` | `bool` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpComponentTheme](klp-component-theme.md)
- [KlpDataVisualizationTheme](klp-data-visualization-theme.md)
- [KlpGeometryTheme](klp-geometry-theme.md)
- [KlpMotionTheme](klp-motion-theme.md)
- [KlpShapeTheme](klp-shape-theme.md)
- [KlpSpacingTheme](klp-spacing-theme.md)
- [KlpSurfaceTheme](klp-surface-theme.md)
- [KlpThemeData](klp-theme-data.md)
- [KlpTypographyTheme](klp-typography-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_visual_style.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_visual_style.dart`。
