# KlpDataVisualizationTheme

Flutter · Stable · 語意風格

## 主要職責

提供資料視覺化的語意風格；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDataVisualizationTheme createExample(List<Color> series, List<Color> seriesWash, Color axis, Color grid, Color gridStrong, Color label, Color value, Color plotBackground, Color crosshair, Color marketUp, Color marketUpWash, Color marketDown, Color marketDownWash, Color marketFlat) => KlpDataVisualizationTheme(series: series, seriesWash: seriesWash, axis: axis, grid: grid, gridStrong: gridStrong, label: label, value: value, plotBackground: plotBackground, crosshair: crosshair, marketUp: marketUp, marketUpWash: marketUpWash, marketDown: marketDown, marketDownWash: marketDownWash, marketFlat: marketFlat);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDataVisualizationTheme extends ThemeExtension<KlpDataVisualizationTheme>
```

## 建構子 KlpDataVisualizationTheme



```dart
const KlpDataVisualizationTheme({
	required List<Color> series,
	required List<Color> seriesWash,
	required Color axis,
	required Color grid,
	required Color gridStrong,
	required Color label,
	required Color value,
	required Color plotBackground,
	required Color crosshair,
	required Color marketUp,
	required Color marketUpWash,
	required Color marketDown,
	required Color marketDownWash,
	required Color marketFlat,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `series` | `List<Color>` | 是 | — | 依公開型別提供此輸入。 |
| `seriesWash` | `List<Color>` | 是 | — | 依公開型別提供此輸入。 |
| `axis` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `grid` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `gridStrong` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `label` | `Color` | 是 | — | 顯示標籤。 |
| `value` | `Color` | 是 | — | 目前值。 |
| `plotBackground` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `crosshair` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `marketUp` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `marketUpWash` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `marketDown` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `marketDownWash` | `Color` | 是 | — | 依公開型別提供此輸入。 |
| `marketFlat` | `Color` | 是 | — | 依公開型別提供此輸入。 |


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
KlpDataVisualizationTheme copyWith({
	List<Color>? series,
	List<Color>? seriesWash,
	Color? axis,
	Color? grid,
	Color? gridStrong,
	Color? label,
	Color? value,
	Color? plotBackground,
	Color? crosshair,
	Color? marketUp,
	Color? marketUpWash,
	Color? marketDown,
	Color? marketDownWash,
	Color? marketFlat,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `series` | `List<Color>?` | 否 | null | 依公開型別提供此輸入。 |
| `seriesWash` | `List<Color>?` | 否 | null | 依公開型別提供此輸入。 |
| `axis` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `grid` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `gridStrong` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `label` | `Color?` | 否 | null | 顯示標籤。 |
| `value` | `Color?` | 否 | null | 目前值。 |
| `plotBackground` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `crosshair` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `marketUp` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `marketUpWash` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `marketDown` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `marketDownWash` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `marketFlat` | `Color?` | 否 | null | 依公開型別提供此輸入。 |


### dark

```dart
static const KlpDataVisualizationTheme dark
```



### hashCode

```dart
int get hashCode
```



### lerp

```dart
KlpDataVisualizationTheme lerp(KlpDataVisualizationTheme? other, double t)
```

*不做內插。**

`MaterialApp` 在 theme 變更時會跑一段過場並沿路呼叫 `lerp`。各層若各自內插，
中途會出現「某幾層已經換了、某幾層還沒」的混合狀態——那正是切換深淺色時看起來
「有些元件沒有跟著變」的原因：它們不是沒變，是停在中間值上。

因此整個 token 疊層一律在中點原子性地翻轉，任何時刻都只會是完整的其中一套。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpDataVisualizationTheme?` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### light

```dart
static const KlpDataVisualizationTheme light
```



### seriesColor

```dart
Color seriesColor(int index)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `index` | `int` | 是 | — | 依公開型別提供此輸入。 |


### seriesWashColor

```dart
Color seriesWashColor(int index)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `index` | `int` | 是 | — | 依公開型別提供此輸入。 |


### ultraDark

```dart
static const KlpDataVisualizationTheme ultraDark
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ThemeExtension<KlpDataVisualizationTheme>](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_data_visualization_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_data_visualization_theme.dart`。
