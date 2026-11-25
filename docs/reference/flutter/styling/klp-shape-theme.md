# KlpShapeTheme

Flutter · Stable · 語意風格

## 主要職責

Layer 2：形狀（圓角與線寬）的 semantic token。

欄位以**使用位置的角色**命名而非尺寸命名：`control` 而不是 `sm`。消費者調整
`control` 時，所有控制項一起改變，不需要知道哪些元件恰好用了 `sm`。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpShapeTheme createExample(double none, double control, double card, double panel, double pill, double hairline, double stroke, double dashedLength, double dashedGap, double dashedOpacity) => KlpShapeTheme(none: none, control: control, card: card, panel: panel, pill: pill, hairline: hairline, stroke: stroke, dashedLength: dashedLength, dashedGap: dashedGap, dashedOpacity: dashedOpacity);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpShapeTheme extends ThemeExtension<KlpShapeTheme>
```

## 建構子 KlpShapeTheme



```dart
const KlpShapeTheme({
	required double none,
	double sm = KlpScale.radius50,
	required double control,
	double controlInner = 7,
	double toggleTrack = 4,
	required double card,
	required double panel,
	required double pill,
	required double hairline,
	required double stroke,
	required double dashedLength,
	required double dashedGap,
	required double dashedOpacity,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `none` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `sm` | `double` | 否 | KlpScale.radius50 | Checkbox、極小標籤 (radius-sm: 2px)。 |
| `control` | `double` | 是 | — | 按鈕、輸入框等標準操作元件 (radius-md: 6px~8px)。 |
| `controlInner` | `double` | 否 | 7 | 依公開型別提供此輸入。 |
| `toggleTrack` | `double` | 否 | 4 | 依公開型別提供此輸入。 |
| `card` | `double` | 是 | — | 卡片、清單項目等內容容器 (radius-md: 6px~8px)。 |
| `panel` | `double` | 是 | — | 面板、對話框等大面積容器 (radius-lg: 12px~16px)。 |
| `pill` | `double` | 是 | — | 膠囊形、頭像、圓形標籤 (radius-full: 9999px)。 |
| `hairline` | `double` | 是 | — | 分隔線與邊框的細線寬度。 |
| `stroke` | `double` | 是 | — | 需要強調的邊框（focus ring、選取框）。 |
| `dashedLength` | `double` | 是 | — | 虛線描邊的節奏。 |
| `dashedGap` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `dashedOpacity` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### cardRadius

```dart
BorderRadius get cardRadius
```



### controlRadius

```dart
BorderRadius get controlRadius
```



### copyWith

```dart
KlpShapeTheme copyWith({
	double? none,
	double? sm,
	double? control,
	double? controlInner,
	double? toggleTrack,
	double? card,
	double? panel,
	double? pill,
	double? hairline,
	double? stroke,
	double? dashedLength,
	double? dashedGap,
	double? dashedOpacity,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `none` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `sm` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `control` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `controlInner` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `toggleTrack` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `card` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `panel` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `pill` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `hairline` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `stroke` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `dashedLength` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `dashedGap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `dashedOpacity` | `double?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



### lerp

```dart
KlpShapeTheme lerp(KlpShapeTheme? other, double t)
```

*不做內插。**

`MaterialApp` 在 theme 變更時會跑一段過場並沿路呼叫 `lerp`。各層若各自內插，
中途會出現「某幾層已經換了、某幾層還沒」的混合狀態——那正是切換深淺色時看起來
「有些元件沒有跟著變」的原因：它們不是沒變，是停在中間值上。

因此整個 token 疊層一律在中點原子性地翻轉，任何時刻都只會是完整的其中一套。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpShapeTheme?` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### lerpDouble

```dart
static double lerpDouble(
	double a,
	double b,
	double t,
)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `a` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `b` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### panelRadius

```dart
BorderRadius get panelRadius
```



### pillRadius

```dart
BorderRadius get pillRadius
```



### smRadius

```dart
BorderRadius get smRadius
```



### standardShape

```dart
static const KlpShapeTheme standardShape
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ThemeExtension<KlpShapeTheme>](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)。
- [KlpScale](klp-scale.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_shape_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_shape_theme.dart`。
