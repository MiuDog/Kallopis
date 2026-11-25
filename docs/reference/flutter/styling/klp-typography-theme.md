# KlpTypographyTheme

Flutter · Stable · 語意風格

## 主要職責

Layer 2：字體的 semantic token。

字體家族本身是 theme 的一部分——有些風格全域使用等寬字，有些只在程式碼與路徑使用。
元件讀 `body`／`label`／`code` 這些**角色**，不指定家族，因此換 theme 時字體會整體
跟著換，不會只換一半。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTypographyTheme createExample(String sansFamily, List<String> sansFallback, String monoFamily, List<String> monoFallback, String uiFamily, String bodyFamily, String codeFamily, double caption, double body, double label, double section, double headingSmall, double heading, double title, double display, double captionLeading, double bodyLeading, double headingLeading, double displayLeading, double codeLeading, double readingLeading, double labelLeading, double labelTracking, double displayTracking, FontWeight regular, FontWeight medium, FontWeight strong) => KlpTypographyTheme(sansFamily: sansFamily, sansFallback: sansFallback, monoFamily: monoFamily, monoFallback: monoFallback, uiFamily: uiFamily, bodyFamily: bodyFamily, codeFamily: codeFamily, caption: caption, body: body, label: label, section: section, headingSmall: headingSmall, heading: heading, title: title, display: display, captionLeading: captionLeading, bodyLeading: bodyLeading, headingLeading: headingLeading, displayLeading: displayLeading, codeLeading: codeLeading, readingLeading: readingLeading, labelLeading: labelLeading, labelTracking: labelTracking, displayTracking: displayTracking, regular: regular, medium: medium, strong: strong);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTypographyTheme extends ThemeExtension<KlpTypographyTheme>
```

## 建構子 KlpTypographyTheme



```dart
const KlpTypographyTheme({
	required String sansFamily,
	required List<String> sansFallback,
	required String monoFamily,
	required List<String> monoFallback,
	required String uiFamily,
	required String bodyFamily,
	required String codeFamily,
	double micro = KlpScale.font100,
	required double caption,
	double sub = KlpScale.font300,
	required double body,
	double lead = KlpScale.font500,
	double h4 = KlpScale.font600,
	double h3 = KlpScale.font700,
	double h2 = KlpScale.font800,
	double h1 = KlpScale.font900,
	required double label,
	required double section,
	required double headingSmall,
	required double heading,
	required double title,
	required double display,
	double microLeading = KlpScale.leading120,
	required double captionLeading,
	double subLeading = KlpScale.leading142,
	required double bodyLeading,
	double leadLeading = KlpScale.leading155,
	double h4Leading = KlpScale.leading127,
	double h3Leading = KlpScale.leading128,
	double h2Leading = KlpScale.leading122,
	double h1Leading = KlpScale.leading116,
	required double headingLeading,
	required double displayLeading,
	required double codeLeading,
	required double readingLeading,
	required double labelLeading,
	required double labelTracking,
	required double displayTracking,
	required FontWeight regular,
	required FontWeight medium,
	FontWeight semiBold = KlpScale.weight600,
	FontWeight bold = KlpScale.weight700,
	FontWeight extraBold = KlpScale.weight800,
	required FontWeight strong,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `sansFamily` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `sansFallback` | `List<String>` | 是 | — | 依公開型別提供此輸入。 |
| `monoFamily` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `monoFallback` | `List<String>` | 是 | — | 依公開型別提供此輸入。 |
| `uiFamily` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `bodyFamily` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `codeFamily` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `micro` | `double` | 否 | KlpScale.font100 | 依公開型別提供此輸入。 |
| `caption` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `sub` | `double` | 否 | KlpScale.font300 | 依公開型別提供此輸入。 |
| `body` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `lead` | `double` | 否 | KlpScale.font500 | 依公開型別提供此輸入。 |
| `h4` | `double` | 否 | KlpScale.font600 | 依公開型別提供此輸入。 |
| `h3` | `double` | 否 | KlpScale.font700 | 依公開型別提供此輸入。 |
| `h2` | `double` | 否 | KlpScale.font800 | 依公開型別提供此輸入。 |
| `h1` | `double` | 否 | KlpScale.font900 | 依公開型別提供此輸入。 |
| `label` | `double` | 是 | — | 顯示標籤。 |
| `section` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `headingSmall` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `heading` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `title` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `display` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `microLeading` | `double` | 否 | KlpScale.leading120 | 依公開型別提供此輸入。 |
| `captionLeading` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `subLeading` | `double` | 否 | KlpScale.leading142 | 依公開型別提供此輸入。 |
| `bodyLeading` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `leadLeading` | `double` | 否 | KlpScale.leading155 | 依公開型別提供此輸入。 |
| `h4Leading` | `double` | 否 | KlpScale.leading127 | 依公開型別提供此輸入。 |
| `h3Leading` | `double` | 否 | KlpScale.leading128 | 依公開型別提供此輸入。 |
| `h2Leading` | `double` | 否 | KlpScale.leading122 | 依公開型別提供此輸入。 |
| `h1Leading` | `double` | 否 | KlpScale.leading116 | 依公開型別提供此輸入。 |
| `headingLeading` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `displayLeading` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeLeading` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `readingLeading` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `labelLeading` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `labelTracking` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `displayTracking` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `regular` | `FontWeight` | 是 | — | 依公開型別提供此輸入。 |
| `medium` | `FontWeight` | 是 | — | 依公開型別提供此輸入。 |
| `semiBold` | `FontWeight` | 否 | KlpScale.weight600 | 依公開型別提供此輸入。 |
| `bold` | `FontWeight` | 否 | KlpScale.weight700 | 依公開型別提供此輸入。 |
| `extraBold` | `FontWeight` | 否 | KlpScale.weight800 | 依公開型別提供此輸入。 |
| `strong` | `FontWeight` | 是 | — | 依公開型別提供此輸入。 |


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
KlpTypographyTheme copyWith({
	String? sansFamily,
	List<String>? sansFallback,
	String? monoFamily,
	List<String>? monoFallback,
	String? uiFamily,
	String? bodyFamily,
	String? codeFamily,
	double? micro,
	double? caption,
	double? sub,
	double? body,
	double? lead,
	double? h4,
	double? h3,
	double? h2,
	double? h1,
	double? display,
	double? label,
	double? section,
	double? headingSmall,
	double? heading,
	double? title,
	double? microLeading,
	double? captionLeading,
	double? subLeading,
	double? bodyLeading,
	double? leadLeading,
	double? h4Leading,
	double? h3Leading,
	double? h2Leading,
	double? h1Leading,
	double? displayLeading,
	double? headingLeading,
	double? codeLeading,
	double? readingLeading,
	double? labelLeading,
	double? labelTracking,
	double? displayTracking,
	FontWeight? regular,
	FontWeight? medium,
	FontWeight? semiBold,
	FontWeight? bold,
	FontWeight? extraBold,
	FontWeight? strong,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `sansFamily` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `sansFallback` | `List<String>?` | 否 | null | 依公開型別提供此輸入。 |
| `monoFamily` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `monoFallback` | `List<String>?` | 否 | null | 依公開型別提供此輸入。 |
| `uiFamily` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `bodyFamily` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `codeFamily` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `micro` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `caption` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `sub` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `body` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `lead` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `h4` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `h3` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `h2` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `h1` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `display` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `label` | `double?` | 否 | null | 顯示標籤。 |
| `section` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `headingSmall` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `heading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `title` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `microLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `captionLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `subLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `bodyLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `leadLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `h4Leading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `h3Leading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `h2Leading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `h1Leading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `displayLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `headingLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `codeLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `readingLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `labelLeading` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `labelTracking` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `displayTracking` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `regular` | `FontWeight?` | 否 | null | 依公開型別提供此輸入。 |
| `medium` | `FontWeight?` | 否 | null | 依公開型別提供此輸入。 |
| `semiBold` | `FontWeight?` | 否 | null | 依公開型別提供此輸入。 |
| `bold` | `FontWeight?` | 否 | null | 依公開型別提供此輸入。 |
| `extraBold` | `FontWeight?` | 否 | null | 依公開型別提供此輸入。 |
| `strong` | `FontWeight?` | 否 | null | 依公開型別提供此輸入。 |


### fallbackFor

```dart
List<String> fallbackFor(String family)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `family` | `String` | 是 | — | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



### lerp

```dart
KlpTypographyTheme lerp(KlpTypographyTheme? other, double t)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpTypographyTheme?` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### proportional

```dart
static const KlpTypographyTheme proportional
```

現代風：完整 10 階字級排版系統。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ThemeExtension<KlpTypographyTheme>](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)。
- [KlpScale](klp-scale.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_typography_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_typography_theme.dart`。
