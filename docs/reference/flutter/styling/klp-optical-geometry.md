# KlpOpticalGeometry

Flutter · Stable · 語意風格

## 主要職責

不改變配置語意、只校正視覺重心的幾何值。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpOpticalGeometry createExample(double menuIconOffsetY, double railBadgeInset, double statusIconOffsetY, double monoBaselineOffsetY, double uiBaselineOffsetY) => KlpOpticalGeometry(menuIconOffsetY: menuIconOffsetY, railBadgeInset: railBadgeInset, statusIconOffsetY: statusIconOffsetY, monoBaselineOffsetY: monoBaselineOffsetY, uiBaselineOffsetY: uiBaselineOffsetY);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpOpticalGeometry
```

## 建構子 KlpOpticalGeometry



```dart
const KlpOpticalGeometry({
	required double menuIconOffsetY,
	required double railBadgeInset,
	required double statusIconOffsetY,
	required double monoBaselineOffsetY,
	required double uiBaselineOffsetY,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `menuIconOffsetY` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `railBadgeInset` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `statusIconOffsetY` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `monoBaselineOffsetY` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `uiBaselineOffsetY` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_optical_geometry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_optical_geometry.dart`。
