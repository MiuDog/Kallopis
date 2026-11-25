# KlpComponentTheme

Flutter · Stable · 語意風格

## 主要職責

Layer 3：component token。

只有當某個元件**需要偏離** semantic 預設時才在這裡出現。每個欄位都是 nullable，
`null` 表示「沿用 semantic」——因此這一層是稀疏的，不是把 semantic 抄一遍。

元件永遠透過 [resolve] 系列方法取值，拿到的一定是已解析的具體數值，元件本身不需要
知道值來自哪一層。這是「風格繼承樹」的落點：primitive → semantic → component，
由下往上找第一個有定義的值。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpComponentTheme createExample() => KlpComponentTheme();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpComponentTheme extends ThemeExtension<KlpComponentTheme>
```

## 建構子 KlpComponentTheme



```dart
const KlpComponentTheme({
	double? buttonRadius,
	double? buttonPaddingX,
	double? buttonPaddingY,
	double? buttonHeight,
	double? buttonBorderWidth,
	double? fieldRadius,
	double? fieldPaddingX,
	double? fieldHeight,
	double? fieldBorderWidth,
	double? menuRadius,
	double? menuPadding,
	double? menuItemHeight,
	double? cardRadius,
	double? cardPadding,
	double? badgeRadius,
	double? badgePaddingX,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `buttonRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonPaddingX` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonPaddingY` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonBorderWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `fieldRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `fieldPaddingX` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `fieldHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `fieldBorderWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `menuRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `menuPadding` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `menuItemHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `cardRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `cardPadding` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `badgeRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `badgePaddingX` | `double?` | 否 | null | 依公開型別提供此輸入。 |


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
KlpComponentTheme copyWith({
	double? buttonRadius,
	double? buttonPaddingX,
	double? buttonPaddingY,
	double? buttonHeight,
	double? buttonBorderWidth,
	double? fieldRadius,
	double? fieldPaddingX,
	double? fieldHeight,
	double? fieldBorderWidth,
	double? menuRadius,
	double? menuPadding,
	double? menuItemHeight,
	double? cardRadius,
	double? cardPadding,
	double? badgeRadius,
	double? badgePaddingX,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `buttonRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonPaddingX` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonPaddingY` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonBorderWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `fieldRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `fieldPaddingX` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `fieldHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `fieldBorderWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `menuRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `menuPadding` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `menuItemHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `cardRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `cardPadding` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `badgeRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `badgePaddingX` | `double?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



### inherited

```dart
static const KlpComponentTheme inherited
```

沒有任何偏離，全部沿用 semantic。這是預設，也是應該最常見的狀態——
component token 大量出現代表 semantic 層沒設計好。

### lerp

```dart
KlpComponentTheme lerp(KlpComponentTheme? other, double t)
```

*不做內插。**

`MaterialApp` 在 theme 變更時會跑一段過場並沿路呼叫 `lerp`。各層若各自內插，
中途會出現「某幾層已經換了、某幾層還沒」的混合狀態——那正是切換深淺色時看起來
「有些元件沒有跟著變」的原因：它們不是沒變，是停在中間值上。

因此整個 token 疊層一律在中點原子性地翻轉，任何時刻都只會是完整的其中一套。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpComponentTheme?` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### resolveBadgePaddingX

```dart
double resolveBadgePaddingX(KlpSpacingTheme spacing)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `spacing` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveBadgeRadius

```dart
double resolveBadgeRadius(KlpShapeTheme shape)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveButtonBorderWidth

```dart
double resolveButtonBorderWidth(KlpShapeTheme shape, KlpSurfaceTheme _)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |
| `_` | `KlpSurfaceTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveButtonHeight

```dart
double resolveButtonHeight(KlpControlGeometry geometry)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `geometry` | `KlpControlGeometry` | 是 | — | 依公開型別提供此輸入。 |


### resolveButtonPaddingX

```dart
double resolveButtonPaddingX(KlpSpacingTheme s)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `s` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveButtonPaddingY

```dart
double resolveButtonPaddingY(KlpSpacingTheme s)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `s` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveButtonRadius

```dart
double resolveButtonRadius(KlpShapeTheme shape)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveCardPadding

```dart
double resolveCardPadding(KlpSpacingTheme s)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `s` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveCardRadius

```dart
double resolveCardRadius(KlpShapeTheme shape)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveFieldBorderWidth

```dart
double resolveFieldBorderWidth(KlpShapeTheme shape)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveFieldHeight

```dart
double resolveFieldHeight(KlpSpacingTheme s)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `s` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveFieldPaddingX

```dart
double resolveFieldPaddingX(KlpSpacingTheme s)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `s` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveFieldRadius

```dart
double resolveFieldRadius(KlpShapeTheme shape)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveMenuItemHeight

```dart
double resolveMenuItemHeight(KlpSpacingTheme s)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `s` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveMenuItemHeightWithGeometry

```dart
double resolveMenuItemHeightWithGeometry(KlpGeometryTheme geometry)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `geometry` | `KlpGeometryTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveMenuPadding

```dart
double resolveMenuPadding(KlpSpacingTheme s)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `s` | `KlpSpacingTheme` | 是 | — | 依公開型別提供此輸入。 |


### resolveMenuRadius

```dart
double resolveMenuRadius(KlpShapeTheme shape)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ThemeExtension<KlpComponentTheme>](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)。
- [KlpControlGeometry](klp-control-geometry.md)
- [KlpGeometryTheme](klp-geometry-theme.md)
- [KlpShapeTheme](klp-shape-theme.md)
- [KlpSpacingTheme](klp-spacing-theme.md)
- [KlpSurfaceTheme](klp-surface-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_component_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_component_theme.dart`。
