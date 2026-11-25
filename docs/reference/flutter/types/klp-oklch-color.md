# KlpOklchColor

Flutter · Stable · 資料與型別

## 主要職責

以 OKLCH 表示的裝置無關色彩。

[lightness] 與 [alpha] 使用 0 到 1；[chroma] 不限制上界；[hue] 以角度表示。
轉成 Flutter [Color] 時會逐通道限制在 sRGB 色域內，原值是否超出色域可先由
[isInSrgbGamut] 判斷。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpOklchColor createExample(double lightness, double chroma, double hue) => KlpOklchColor(lightness: lightness, chroma: chroma, hue: hue);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpOklchColor
```

## 建構子 KlpOklchColor



```dart
const KlpOklchColor({
	required double lightness,
	required double chroma,
	required double hue,
	double alpha = 1,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `lightness` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `chroma` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `hue` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `alpha` | `double` | 否 | 1 | 依公開型別提供此輸入。 |


## 建構子 KlpOklchColor.fromColor

從 Flutter sRGB 色彩建立 OKLCH 值。

```dart
KlpOklchColor.fromColor(Color color)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `color` | `Color` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### closestSrgbFallback

```dart
KlpOklchColor get closestSrgbFallback
```

固定 Lightness 與 Hue，找出 sRGB 色域內的最大 Chroma。

### copyWith

```dart
KlpOklchColor copyWith({
	double? lightness,
	double? chroma,
	double? hue,
	double? alpha,
})
```

建立只替換指定座標的新值。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `lightness` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `chroma` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `hue` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `alpha` | `double?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



### isInSrgbGamut

```dart
bool get isInSrgbGamut
```

未限制通道前的轉換結果是否完整落在 sRGB 色域。

### toColor

```dart
Color toColor()
```

轉成 Flutter sRGB 色彩；超出色域的通道會限制在 0 到 1。

### toSrgbFallbackColor

```dart
Color toSrgbFallbackColor()
```

取得以 Chroma fallback 映射後的 sRGB 色彩。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/klp_oklch_color.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/klp_oklch_color.dart`。
