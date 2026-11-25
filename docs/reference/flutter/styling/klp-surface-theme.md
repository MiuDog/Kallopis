# KlpSurfaceTheme

Flutter · Stable · 語意風格

## 主要職責

Layer 2：表面分層與陰影的 semantic token。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSurfaceTheme createExample(KlpSurfaceSeparation separation, double overlayBlur, double overlaySpread, double overlayOffsetY, double overlayShadowOpacity, double scrimOpacity, double selectionWashOpacity, double focusWashOpacity, double statusFillOpacity, double pressProgressOpacity, double diffFillOpacity, double gridLineOpacity, double veilOpacity, double statusRowOpacity, double statusRowSelectedOpacity, double statusRowOpacityDark, double statusRowSelectedOpacityDark, double frostedOpacity, double frostedVeilOpacity) => KlpSurfaceTheme(separation: separation, overlayBlur: overlayBlur, overlaySpread: overlaySpread, overlayOffsetY: overlayOffsetY, overlayShadowOpacity: overlayShadowOpacity, scrimOpacity: scrimOpacity, selectionWashOpacity: selectionWashOpacity, focusWashOpacity: focusWashOpacity, statusFillOpacity: statusFillOpacity, pressProgressOpacity: pressProgressOpacity, diffFillOpacity: diffFillOpacity, gridLineOpacity: gridLineOpacity, veilOpacity: veilOpacity, statusRowOpacity: statusRowOpacity, statusRowSelectedOpacity: statusRowSelectedOpacity, statusRowOpacityDark: statusRowOpacityDark, statusRowSelectedOpacityDark: statusRowSelectedOpacityDark, frostedOpacity: frostedOpacity, frostedVeilOpacity: frostedVeilOpacity);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSurfaceTheme extends ThemeExtension<KlpSurfaceTheme>
```

## 建構子 KlpSurfaceTheme



```dart
const KlpSurfaceTheme({
	required KlpSurfaceSeparation separation,
	required double overlayBlur,
	required double overlaySpread,
	required double overlayOffsetY,
	required double overlayShadowOpacity,
	required double scrimOpacity,
	required double selectionWashOpacity,
	required double focusWashOpacity,
	required double statusFillOpacity,
	required double pressProgressOpacity,
	required double diffFillOpacity,
	required double gridLineOpacity,
	required double veilOpacity,
	required double statusRowOpacity,
	required double statusRowSelectedOpacity,
	required double statusRowOpacityDark,
	required double statusRowSelectedOpacityDark,
	required double frostedOpacity,
	required double frostedVeilOpacity,
	double backdropBlurSigma = 12,
	double dragOpacity = KlpScale.opacity820,
	double dragSourceOpacity = KlpScale.opacity350,
	double themePreviewDisabledOpacity = KlpScale.opacity620,
	double listStatusOpacity = KlpScale.opacity140,
	double listStatusSelectedOpacity = KlpScale.opacity320,
	double accentSoftOpacityLight = KlpScale.opacity160,
	double accentSoftOpacityDark = KlpScale.opacity220,
	double windowPaneOpacityLight = KlpTransparency.lightPaneOpacity,
	double windowPaneOpacityDark = KlpTransparency.darkPaneOpacity,
	double invalidFillOpacity = KlpScale.opacity180,
	double contactBlur = 0,
	double contactOffsetY = 0,
	double contactShadowOpacity = 0,
	Color overlayShadowColor = _defaultOverlayShadowColor,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `separation` | `KlpSurfaceSeparation` | 是 | — | 依公開型別提供此輸入。 |
| `overlayBlur` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `overlaySpread` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `overlayOffsetY` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `overlayShadowOpacity` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `scrimOpacity` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `selectionWashOpacity` | `double` | 是 | — | 一般互動狀態的背景高亮強度。用前景色以低 alpha 疊上，因此亮態壓暗、暗態壓亮，<br>且底下表面原本的階層差不會被蓋掉。<br><br>Explorer 與表單不使用這層，改以低／高對比虛線區分 hover 與選取。 |
| `focusWashOpacity` | `double` | 是 | — | 鍵盤聚焦時的高亮強度。<br><br>必須比 [selectionWashOpacity] 強：hover 與 focus 若同強度，鍵盤使用者在<br>滑鼠同時停在別處時就分不出焦點在哪。也不能借用其他角色的透明度——借用會在<br>調整那個角色時靜默失去同步。 |
| `statusFillOpacity` | `double` | 是 | — | 語意色當底時的疊層強度（danger 按鈕、狀態晶片）。 |
| `pressProgressOpacity` | `double` | 是 | — | 長按進度條的疊層強度。 |
| `diffFillOpacity` | `double` | 是 | — | 差異檢視中整行增刪底色的強度。 |
| `gridLineOpacity` | `double` | 是 | — | 資料格線由前景色推導時的強度。 |
| `veilOpacity` | `double` | 是 | — | 載入／禁用時蓋在內容上的遮罩強度。 |
| `statusRowOpacity` | `double` | 是 | — | 資料列以語意色染底時的強度。亮暗兩態分開，因為同一個 alpha 疊在深底與淺底上<br>讀起來的強度差很多。 |
| `statusRowSelectedOpacity` | `double` | 是 | — | 同上，選取中的資料列。 |
| `statusRowOpacityDark` | `double` | 是 | — | 同 [statusRowOpacity]，暗態。 |
| `statusRowSelectedOpacityDark` | `double` | 是 | — | 同 [statusRowSelectedOpacity]，暗態。 |
| `frostedOpacity` | `double` | 是 | — | 霧化表面本身的透明度。 |
| `frostedVeilOpacity` | `double` | 是 | — | 霧化套在透明表面上時借用的底色強度。 |
| `backdropBlurSigma` | `double` | 否 | 12 | 依公開型別提供此輸入。 |
| `dragOpacity` | `double` | 否 | KlpScale.opacity820 | 依公開型別提供此輸入。 |
| `dragSourceOpacity` | `double` | 否 | KlpScale.opacity350 | 拖曳期間原位置內容的保留強度。 |
| `themePreviewDisabledOpacity` | `double` | 否 | KlpScale.opacity620 | 主題預覽選項停用時保留的內容強度。 |
| `listStatusOpacity` | `double` | 否 | KlpScale.opacity140 | 依公開型別提供此輸入。 |
| `listStatusSelectedOpacity` | `double` | 否 | KlpScale.opacity320 | 依公開型別提供此輸入。 |
| `accentSoftOpacityLight` | `double` | 否 | KlpScale.opacity160 | 依公開型別提供此輸入。 |
| `accentSoftOpacityDark` | `double` | 否 | KlpScale.opacity220 | 依公開型別提供此輸入。 |
| `windowPaneOpacityLight` | `double` | 否 | KlpTransparency.lightPaneOpacity | 依公開型別提供此輸入。 |
| `windowPaneOpacityDark` | `double` | 否 | KlpTransparency.darkPaneOpacity | 依公開型別提供此輸入。 |
| `invalidFillOpacity` | `double` | 否 | KlpScale.opacity180 | 依公開型別提供此輸入。 |
| `contactBlur` | `double` | 否 | 0 | 接觸陰影與環境陰影共用色彩，透明度可各自調整。 |
| `contactOffsetY` | `double` | 否 | 0 | 依公開型別提供此輸入。 |
| `contactShadowOpacity` | `double` | 否 | 0 | 依公開型別提供此輸入。 |
| `overlayShadowColor` | `Color` | 否 | _defaultOverlayShadowColor | 依公開型別提供此輸入。 |


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
KlpSurfaceTheme copyWith({
	KlpSurfaceSeparation? separation,
	double? overlayBlur,
	double? overlaySpread,
	double? overlayOffsetY,
	double? overlayShadowOpacity,
	double? scrimOpacity,
	double? selectionWashOpacity,
	double? focusWashOpacity,
	double? statusFillOpacity,
	double? pressProgressOpacity,
	double? diffFillOpacity,
	double? gridLineOpacity,
	double? veilOpacity,
	double? statusRowOpacity,
	double? statusRowSelectedOpacity,
	double? statusRowOpacityDark,
	double? statusRowSelectedOpacityDark,
	double? frostedOpacity,
	double? frostedVeilOpacity,
	double? backdropBlurSigma,
	double? dragOpacity,
	double? dragSourceOpacity,
	double? themePreviewDisabledOpacity,
	double? listStatusOpacity,
	double? listStatusSelectedOpacity,
	double? accentSoftOpacityLight,
	double? accentSoftOpacityDark,
	double? windowPaneOpacityLight,
	double? windowPaneOpacityDark,
	double? invalidFillOpacity,
	double? contactBlur,
	double? contactOffsetY,
	double? contactShadowOpacity,
	Color? overlayShadowColor,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `separation` | `KlpSurfaceSeparation?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayBlur` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `overlaySpread` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayOffsetY` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayShadowOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `scrimOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `selectionWashOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `focusWashOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `statusFillOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `pressProgressOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `diffFillOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `gridLineOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `veilOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `statusRowOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `statusRowSelectedOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `statusRowOpacityDark` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `statusRowSelectedOpacityDark` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `frostedOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `frostedVeilOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `backdropBlurSigma` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `dragOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `dragSourceOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `themePreviewDisabledOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `listStatusOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `listStatusSelectedOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `accentSoftOpacityLight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `accentSoftOpacityDark` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `windowPaneOpacityLight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `windowPaneOpacityDark` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `invalidFillOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `contactBlur` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `contactOffsetY` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `contactShadowOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayShadowColor` | `Color?` | 否 | null | 依公開型別提供此輸入。 |


### elevated

```dart
static const KlpSurfaceTheme elevated
```



### hashCode

```dart
int get hashCode
```



### lerp

```dart
KlpSurfaceTheme lerp(KlpSurfaceTheme? other, double t)
```

*不做內插。**

`MaterialApp` 在 theme 變更時會跑一段過場並沿路呼叫 `lerp`。各層若各自內插，
中途會出現「某幾層已經換了、某幾層還沒」的混合狀態——那正是切換深淺色時看起來
「有些元件沒有跟著變」的原因：它們不是沒變，是停在中間值上。

因此整個 token 疊層一律在中點原子性地翻轉，任何時刻都只會是完整的其中一套。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpSurfaceTheme?` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### overlayShadow

```dart
List<BoxShadow> overlayShadow(Color shadowColor)
```

依分層手法產生浮層陰影；非陰影風格回傳空清單。
舊呼叫端的前景色參數保留相容，實際陰影色由主題負責。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `shadowColor` | `Color` | 是 | — | 依公開型別提供此輸入。 |


### usesShadow

```dart
bool get usesShadow
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ThemeExtension<KlpSurfaceTheme>](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)。
- [KlpScale](klp-scale.md)
- [KlpSurfaceSeparation](klp-surface-separation.md)
- [KlpTransparency](klp-transparency.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_surface_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_surface_theme.dart`。
