# KlpGeometryTheme

Flutter · Stable · 語意風格

## 主要職責

不屬於密度尺度的精確元件幾何。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpGeometryTheme createExample(KlpControlGeometry control, KlpDataGeometry data, KlpLayoutGeometry layout, KlpOpticalGeometry optical) => KlpGeometryTheme(control: control, data: data, layout: layout, optical: optical);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpGeometryTheme extends ThemeExtension<KlpGeometryTheme>
```

## 建構子 KlpGeometryTheme



```dart
const KlpGeometryTheme({
	required KlpControlGeometry control,
	required KlpDataGeometry data,
	required KlpLayoutGeometry layout,
	required KlpOpticalGeometry optical,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `control` | `KlpControlGeometry` | 是 | — | 依公開型別提供此輸入。 |
| `data` | `KlpDataGeometry` | 是 | — | 依公開型別提供此輸入。 |
| `layout` | `KlpLayoutGeometry` | 是 | — | 依公開型別提供此輸入。 |
| `optical` | `KlpOpticalGeometry` | 是 | — | 依公開型別提供此輸入。 |


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
KlpGeometryTheme copyWith({
	KlpControlGeometry? control,
	KlpDataGeometry? data,
	KlpLayoutGeometry? layout,
	KlpOpticalGeometry? optical,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `control` | `KlpControlGeometry?` | 否 | null | 依公開型別提供此輸入。 |
| `data` | `KlpDataGeometry?` | 否 | null | 依公開型別提供此輸入。 |
| `layout` | `KlpLayoutGeometry?` | 否 | null | 依公開型別提供此輸入。 |
| `optical` | `KlpOpticalGeometry?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



### lerp

```dart
KlpGeometryTheme lerp(KlpGeometryTheme? other, double t)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpGeometryTheme?` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### standard

```dart
static const KlpGeometryTheme standard
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ThemeExtension<KlpGeometryTheme>](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)。
- [KlpControlGeometry](klp-control-geometry.md)
- [KlpDataGeometry](klp-data-geometry.md)
- [KlpLayoutGeometry](klp-layout-geometry.md)
- [KlpOpticalGeometry](klp-optical-geometry.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_geometry_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_geometry_theme.dart`。
