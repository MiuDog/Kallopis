# KlpTextStyleDefinition

Flutter · Stable · 資料與型別

## 主要職責

單一文字角色由目前 theme 解析後的完整樣式參數。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTextStyleDefinition createExample(double fontSize, double lineHeight, FontWeight fontWeight, KlpTextColorTier tier) => KlpTextStyleDefinition(fontSize: fontSize, lineHeight: lineHeight, fontWeight: fontWeight, tier: tier);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTextStyleDefinition
```

## 建構子 KlpTextStyleDefinition



```dart
const KlpTextStyleDefinition({
	required double fontSize,
	required double lineHeight,
	required FontWeight fontWeight,
	required KlpTextColorTier tier,
	double? letterSpacing,
	KlpFontRole family = KlpFontRole.ui,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `fontSize` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `lineHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `fontWeight` | `FontWeight` | 是 | — | 依公開型別提供此輸入。 |
| `tier` | `KlpTextColorTier` | 是 | — | 依公開型別提供此輸入。 |
| `letterSpacing` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `family` | `KlpFontRole` | 否 | KlpFontRole.ui | 依公開型別提供此輸入。 |


## 成員與方法

### toTextStyle

```dart
TextStyle toTextStyle(KlpTypographyTheme type)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `type` | `KlpTypographyTheme` | 是 | — | 原生 HTML 元素的 type。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFontRole](klp-font-role.md)
- [KlpTextColorTier](klp-text-color-tier.md)
- [KlpTypographyTheme](../styling/klp-typography-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/content/klp_text_style_definition.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/content/klp_text_style_definition.dart`。
