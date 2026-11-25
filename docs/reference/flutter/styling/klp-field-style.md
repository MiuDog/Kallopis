# KlpFieldStyle

Flutter · Stable · 語意風格

## 主要職責

輸入欄位的邊框與底色查表工具。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
void acceptValue(KlpFieldStyle value) {
	// 產品接收此抽象契約；請使用公開子型別或靜態方法。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpFieldStyle
```

## 建構子 KlpFieldStyle



```dart
KlpFieldStyle()
```



## 成員與方法

### borderFor

```dart
static OutlineInputBorder borderFor(KlpShapeTheme shape)
```

需要 shape token，因此不能是無參數的 getter——欄位圓角屬於風格。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `shape` | `KlpShapeTheme` | 是 | — | 依公開型別提供此輸入。 |


### colorFor

```dart
static Color colorFor(
	KlpThemeData tokens,
	KlpFieldFillState state, {
	KlpSurfaceTheme surface = KlpSurfaceTheme.elevated,
})
```

欄位底色。

*hover 以高亮底色表達，不畫邊框。** 欄位本來就有自己的底色，狀態直接反映在
那個底色上，不必在外面再包一層框——包框會讓欄位在 hover 時尺寸感改變，
也讓同一個狀態在欄位與其他元件長得不一樣。

高亮是把前景色以低 alpha 疊上去，因此亮態壓暗、暗態提亮，且不必知道底下
實際是哪個表面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `tokens` | `KlpThemeData` | 是 | — | 依公開型別提供此輸入。 |
| `state` | `KlpFieldFillState` | 是 | — | 依公開型別提供此輸入。 |
| `surface` | `KlpSurfaceTheme` | 否 | KlpSurfaceTheme.elevated | 依公開型別提供此輸入。 |


### inputFill

```dart
static WidgetStateColor inputFill(
	KlpThemeData tokens, {
	bool error = false,
	KlpSurfaceTheme surface = KlpSurfaceTheme.elevated,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `tokens` | `KlpThemeData` | 是 | — | 依公開型別提供此輸入。 |
| `error` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `surface` | `KlpSurfaceTheme` | 否 | KlpSurfaceTheme.elevated | 依公開型別提供此輸入。 |


### resolveInputColor

```dart
static Color resolveInputColor(
	KlpThemeData tokens,
	Set<WidgetState> states, {
	KlpSurfaceTheme surface = KlpSurfaceTheme.elevated,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `tokens` | `KlpThemeData` | 是 | — | 依公開型別提供此輸入。 |
| `states` | `Set<WidgetState>` | 是 | — | 依公開型別提供此輸入。 |
| `surface` | `KlpSurfaceTheme` | 否 | KlpSurfaceTheme.elevated | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFieldFillState](klp-field-fill-state.md)
- [KlpShapeTheme](klp-shape-theme.md)
- [KlpSurfaceTheme](klp-surface-theme.md)
- [KlpThemeData](klp-theme-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_theme.dart`。
