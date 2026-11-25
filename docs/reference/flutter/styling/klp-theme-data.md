# KlpThemeData

Flutter · Stable · 語意風格

## 主要職責

Layer 2：semantic 色彩 token（`ThemeExtension`）。

這是消費者實際覆寫外觀時要動的層——每個欄位是一個色彩的**用途**
（`surface`、`text`、`accent`……），不是某個固定的十六進位值，因此同一份
元件程式碼換一套 [KlpThemeData] 就能整體變色。透過 `context.klpColors`
取用，不要在元件裡直接建構或持有它的實例。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpThemeData createExample(Color app, Color surface, Color surfaceInset, Color surfaceMuted, Color component, Color stageSurface, Color overlay, Color surfaceRaised, Color modalScrim, Color guide, Color divider, Color text, Color textMuted, Color textFaint, Color border, Color borderStrong, Color accent, Color accentSoft, Color interaction, Color interactionSoft, Color success, Color warning, Color danger, Color info) => KlpThemeData(app: app, surface: surface, surfaceInset: surfaceInset, surfaceMuted: surfaceMuted, component: component, stageSurface: stageSurface, overlay: overlay, surfaceRaised: surfaceRaised, modalScrim: modalScrim, guide: guide, divider: divider, text: text, textMuted: textMuted, textFaint: textFaint, border: border, borderStrong: borderStrong, accent: accent, accentSoft: accentSoft, interaction: interaction, interactionSoft: interactionSoft, success: success, warning: warning, danger: danger, info: info);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpThemeData extends ThemeExtension<KlpThemeData>
```

## 建構子 KlpThemeData



```dart
const KlpThemeData({
	required Color app,
	required Color surface,
	required Color surfaceInset,
	required Color surfaceMuted,
	required Color component,
	required Color stageSurface,
	required Color overlay,
	required Color surfaceRaised,
	required Color modalScrim,
	required Color guide,
	required Color divider,
	Color? pagePattern,
	required Color text,
	required Color textMuted,
	required Color textFaint,
	required Color border,
	required Color borderStrong,
	Color? brand,
	required Color accent,
	required Color accentSoft,
	required Color interaction,
	required Color interactionSoft,
	required Color success,
	required Color warning,
	required Color danger,
	required Color info,
	Color clear = KlpPalette.transparent,
	Color onStatus = KlpPalette.pureWhite,
	Color onLightBackground = KlpPalette.ink900,
	Color onDarkBackground = KlpPalette.ink50,
	Color mutedOnLightBackground = KlpPalette.ink550,
	Color mutedOnDarkBackground = KlpPalette.ink300,
	Color faintOnBackground = KlpPalette.ink400,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `app` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `surface` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `surfaceInset` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `surfaceMuted` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `component` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `stageSurface` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `overlay` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `surfaceRaised` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `modalScrim` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `guide` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `divider` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `pagePattern` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `text` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `textMuted` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `textFaint` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `border` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `borderStrong` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `brand` | `Color?` | 否 | null | 產品識別的主題色；不自動覆寫操作用途的 [accent] 或 [interaction]。 |
| `accent` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `accentSoft` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `interaction` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `interactionSoft` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `success` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `warning` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `danger` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `info` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `clear` | `Color` | 否 | KlpPalette.transparent | 完全透明色。名稱避開既有的 static [transparent] 視窗 preset。 |
| `onStatus` | `Color` | 否 | KlpPalette.pureWhite | 依公開型別提供此輸入。 |
| `onLightBackground` | `Color` | 否 | KlpPalette.ink900 | 依公開型別提供此輸入。 |
| `onDarkBackground` | `Color` | 否 | KlpPalette.ink50 | 依公開型別提供此輸入。 |
| `mutedOnLightBackground` | `Color` | 否 | KlpPalette.ink550 | 依公開型別提供此輸入。 |
| `mutedOnDarkBackground` | `Color` | 否 | KlpPalette.ink300 | 依公開型別提供此輸入。 |
| `faintOnBackground` | `Color` | 否 | KlpPalette.ink400 | 依公開型別提供此輸入。 |


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
KlpThemeData copyWith({
	Color? app,
	Color? surface,
	Color? surfaceInset,
	Color? surfaceMuted,
	Color? component,
	Color? stageSurface,
	Color? overlay,
	Color? surfaceRaised,
	Color? modalScrim,
	Color? guide,
	Color? divider,
	Color? pagePattern,
	Color? text,
	Color? textMuted,
	Color? textFaint,
	Color? border,
	Color? borderStrong,
	Color? brand,
	Color? accent,
	Color? accentSoft,
	Color? interaction,
	Color? interactionSoft,
	Color? success,
	Color? warning,
	Color? danger,
	Color? info,
	Color? clear,
	Color? onStatus,
	Color? onLightBackground,
	Color? onDarkBackground,
	Color? mutedOnLightBackground,
	Color? mutedOnDarkBackground,
	Color? faintOnBackground,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `app` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `surface` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `surfaceInset` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `surfaceMuted` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `component` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `stageSurface` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `overlay` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `surfaceRaised` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `modalScrim` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `guide` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `divider` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `pagePattern` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `text` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `textMuted` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `textFaint` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `border` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `borderStrong` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `brand` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `accent` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `accentSoft` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `interaction` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `interactionSoft` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `success` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `warning` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `danger` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `info` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `clear` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `onStatus` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `onLightBackground` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `onDarkBackground` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `mutedOnLightBackground` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `mutedOnDarkBackground` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `faintOnBackground` | `Color?` | 否 | null | 依公開型別提供此輸入。 |


### dark

```dart
static const KlpThemeData dark
```

暗態：整條梯翻轉；輔助文字使用 ink400，確保石墨表面仍達 3:1。

### hashCode

```dart
int get hashCode
```



### lerp

```dart
KlpThemeData lerp(KlpThemeData? other, double t)
```

*不做內插。**

`MaterialApp` 在 theme 變更時會跑一段過場並沿路呼叫 `lerp`。各層若各自內插，
中途會出現「某幾層已經換了、某幾層還沒」的混合狀態——那正是切換深淺色時看起來
「有些元件沒有跟著變」的原因：它們不是沒變，是停在中間值上。

因此整個 token 疊層一律在中點原子性地翻轉，任何時刻都只會是完整的其中一套。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpThemeData?` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### light

```dart
static const KlpThemeData light
```

亮態。**每個角色都落在 ink 色梯上**，沒有例外——一旦有欄位用梯外的顏色，
調整色梯時它就會原地不動，而畫面上只會顯示為「某一塊怪怪的」。

### onBackground

```dart
KlpThemeData onBackground(Color background)
```

依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）產生適用於該背景的文字色彩 token。
若背景為透明，則延續當前（上層）的文字與階層設定。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `background` | `Color` | 是 | — | 依公開型別提供此輸入。 |


### onInteraction

```dart
Color get onInteraction
```



### onSelection

```dart
Color get onSelection
```



### selection

```dart
Color get selection
```



### selectionBackground

```dart
Color get selectionBackground
```



### selectionForeground

```dart
Color get selectionForeground
```



### selectionWash

```dart
Color get selectionWash
```



### selectionWashWith

```dart
Color selectionWashWith(double opacity)
```

選取狀態的半透明壓深層。強度來自 [KlpSurfaceTheme.selectionWashOpacity]；
此處的預設值只在沒有 theme 可讀時使用。
*不要在這裡另訂一份強度**——同一條規則兩份實作必然靜默分岔。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `opacity` | `double` | 是 | — | 依公開型別提供此輸入。 |


### transparent

```dart
static final KlpThemeData transparent
```



### ultraDark

```dart
static const KlpThemeData ultraDark
```

全暗態：比 dark 再往下一階，給 OLED 與長時間閱讀用。

### withWindowTransparency

```dart
KlpThemeData withWindowTransparency(Brightness brightness, {KlpSurfaceTheme surfaceTheme = KlpSurfaceTheme.elevated})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `brightness` | `Brightness` | 是 | — | 依公開型別提供此輸入。 |
| `surfaceTheme` | `KlpSurfaceTheme` | 否 | KlpSurfaceTheme.elevated | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ThemeExtension<KlpThemeData>](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)。
- [KlpPalette](klp-palette.md)
- [KlpSurfaceTheme](klp-surface-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_theme_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_theme_data.dart`。
