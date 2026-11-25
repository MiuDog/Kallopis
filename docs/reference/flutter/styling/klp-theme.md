# KlpTheme

Flutter · Stable · 語意風格

## 主要職責

元件取得所有 token 的唯一入口。

元件寫 `context.klp.space.base`，不寫 `KlpSpace.md` 之類的編譯期常數——後者換 theme
時不會跟著變，而且不會有任何錯誤訊息告訴你它沒變。

每個 getter 在對應的 `ThemeExtension` 缺席時回退到預設值而非拋錯：庫被放進一個沒有
設定 Kallopis theme 的 app 時應該仍能渲染，只是長成預設風格。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTheme createExample(KlpThemeData color, KlpTypographyTheme type, KlpSpacingTheme space, KlpShapeTheme shape, KlpMotionTheme motion, KlpSurfaceTheme surface, KlpComponentTheme component) => KlpTheme(color: color, type: type, space: space, shape: shape, motion: motion, surface: surface, component: component);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTheme
```

## 建構子 KlpTheme



```dart
const KlpTheme({
	required KlpThemeData color,
	required KlpTypographyTheme type,
	required KlpSpacingTheme space,
	required KlpShapeTheme shape,
	required KlpMotionTheme motion,
	required KlpSurfaceTheme surface,
	required KlpComponentTheme component,
	KlpDataVisualizationTheme dataVisualization = KlpDataVisualizationTheme.light,
	KlpGeometryTheme geometry = KlpGeometryTheme.standard,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `color` | `KlpThemeData` | 是 | — | 依公開型別提供此輸入。 |
| `type` | `KlpTypographyTheme` | 是 | — | 原生 HTML 元素的 type。 |
| `space` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |
| `motion` | `KlpMotionTheme` | 是 | — | 依公開型別提供此輸入。 |
| `surface` | `KlpSurfaceTheme` | 是 | — | 依公開型別提供此輸入。 |
| `component` | `KlpComponentTheme` | 是 | — | 依公開型別提供此輸入。 |
| `dataVisualization` | `KlpDataVisualizationTheme` | 否 | KlpDataVisualizationTheme.light | 依公開型別提供此輸入。 |
| `geometry` | `KlpGeometryTheme` | 否 | KlpGeometryTheme.standard | 依公開型別提供此輸入。 |


## 成員與方法

### badgePaddingX

```dart
double get badgePaddingX
```



### badgeRadius

```dart
double get badgeRadius
```



### buttonBorderWidth

```dart
double get buttonBorderWidth
```



### buttonHeight

```dart
double get buttonHeight
```



### buttonHeightLarge

```dart
double get buttonHeightLarge
```



### buttonHeightSmall

```dart
double get buttonHeightSmall
```



### buttonHeightXLarge

```dart
double get buttonHeightXLarge
```



### buttonHeightXSmall

```dart
double get buttonHeightXSmall
```



### buttonInsets

```dart
EdgeInsets get buttonInsets
```



### buttonRadius

```dart
double get buttonRadius
```



### byBrightness

```dart
T byBrightness<T>({required T light, required T dark})
```

依目前明暗挑一個值。兩個分支都必須是 token，不是字面值。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `light` | `T` | 是 | — | 依公開型別提供此輸入。 |
| `dark` | `T` | 是 | — | 依公開型別提供此輸入。 |


### cardPadding

```dart
double get cardPadding
```



### cardRadius

```dart
double get cardRadius
```



### fieldBorderWidth

```dart
double get fieldBorderWidth
```



### fieldHeight

```dart
double get fieldHeight
```



### fieldPaddingX

```dart
double get fieldPaddingX
```



### fieldRadius

```dart
double get fieldRadius
```



### isDark

```dart
bool get isDark
```

目前是不是暗色主題。

由主表面的相對亮度推導，而不是讀 `Theme.of(context).brightness`：後者是
Material 自己的狀態，與這個庫的色彩層各自獨立——消費者只覆寫 [KlpThemeData]
而沒同步 Material 的 brightness 時，兩者就會給出相反的答案。

*元件不得自己寫 `computeLuminance() < 0.5`**：那會讓「什麼算暗色」這條規則
散成好幾份，各自的門檻還可能不同。

### menuItemHeight

```dart
double get menuItemHeight
```



### menuPadding

```dart
double get menuPadding
```



### menuRadius

```dart
double get menuRadius
```



### of

```dart
static KlpTheme of(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### onPrimary

```dart
Color get onPrimary
```

依 primary 背景的 8-bit sRGB luma 選擇淺色或深色前景。

0–159 使用淺色字，160–255 使用深色字。

### overlayShadow

```dart
List<BoxShadow> get overlayShadow
```



### primary

```dart
Color get primary
```

產品主要動作的不透明主題色。品牌識別是唯一可由消費產品設定的色彩入口。

### primaryForegroundFor

```dart
Color primaryForegroundFor(Color background)
```

依實際繪製的 primary 狀態背景解析前景，確保 hover／selected 混色後仍遵守門檻。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `background` | `Color` | 是 | — | 依公開型別提供此輸入。 |


### selectedWash

```dart
Color get selectedWash
```

一般互動元件的 selected 半透明選取色。

色相跟隨 interaction semantic token，透明度則沿用 surface 層的 wash 強度，
讓不同 preset 能完整決定狀態視覺，消費端不必自行混色。

### selectionWash

```dart
Color get selectionWash
```

hover／focus 的半透明中性高亮。

*全庫唯一的 hover 表達方式。** 混合比例來自 surface 層，因此不同風格的
互動對比可以不同。先前 explorer 與表單走另一套虛線框，同一個狀態兩種畫法，
消費者無從預期——那條路徑已經移除。

### styleOf

```dart
static KlpVisualStyle styleOf(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


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
- [KlpVisualStyle](klp-visual-style.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_theme_scope.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_theme_scope.dart`。
