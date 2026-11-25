# KlpTextStyles

Flutter · Stable · 資料與型別

## 主要職責

把 [KlpTextRole] 解析成具體樣式與顏色的靜態工具集合。[KlpText] 內部就是
透過這個類別取得樣式，只有要繞過 [KlpText]（例如自訂 `RichText`）時才需要
直接呼叫 [definitionOf] 或 [colorFor]。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpTextStyles.tiers;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpTextStyles
```

## 建構子 KlpTextStyles



```dart
KlpTextStyles()
```



## 成員與方法

### colorFor

```dart
static Color colorFor(
	KlpThemeData tokens, {
	required KlpTextRole role,
	KlpTextTone tone = KlpTextTone.automatic,
	Color? requestedColor,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `tokens` | `KlpThemeData` | 是 | — | 依公開型別提供此輸入。 |
| `role` | `KlpTextRole` | 是 | — | 依公開型別提供此輸入。 |
| `tone` | `KlpTextTone` | 否 | KlpTextTone.automatic | 選擇語意呈現。 |
| `requestedColor` | `Color?` | 否 | null | 依公開型別提供此輸入。 |


### definitionOf

```dart
static KlpTextStyleDefinition definitionOf(KlpTextRole role, KlpTypographyTheme type)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `role` | `KlpTextRole` | 是 | — | 依公開型別提供此輸入。 |
| `type` | `KlpTypographyTheme` | 是 | — | 原生 HTML 元素的 type。 |


### definitionsFor

```dart
static Map<KlpTextRole, KlpTextStyleDefinition> definitionsFor(KlpTypographyTheme type)
```

字級與行高由 theme 決定，因此不能是編譯期常數的 map。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `type` | `KlpTypographyTheme` | 是 | — | 原生 HTML 元素的 type。 |


### tiers

```dart
static const Map<KlpTextRole, KlpTextColorTier> tiers
```

角色對應的色階預設皆為 prominent（淺色最黑 ink900，深色最白 ink50）。
只有註解與說明 explicitly 傳入 tone 時才套用 muted / faint。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpTextColorTier](klp-text-color-tier.md)
- [KlpTextRole](klp-text-role.md)
- [KlpTextStyleDefinition](klp-text-style-definition.md)
- [KlpTextTone](klp-text-tone.md)
- [KlpThemeData](../styling/klp-theme-data.md)
- [KlpTypographyTheme](../styling/klp-typography-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/content/klp_text.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/content/klp_text.dart`。
