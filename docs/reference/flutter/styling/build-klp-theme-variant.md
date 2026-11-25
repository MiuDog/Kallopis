# buildKlpThemeVariant

Flutter · Stable · 語意風格

## 主要職責

提供依指定模式建立 Flutter ThemeData；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

final productBuildKlpThemeVariant = buildKlpThemeVariant;
```

<!-- reference-api:start -->

## 公開簽名

```dart
ThemeData buildKlpThemeVariant(
	KlpThemeVariant variant, {
	KlpAccent? accent,
	bool transparencyEnabled = false,
	KlpVisualStyle? style,
	KlpStylePack? stylePack,
})
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `variant` | `KlpThemeVariant` | 是 | — | 依公開型別提供此輸入。 |
| `accent` | `KlpAccent?` | 否 | null | 依公開型別提供此輸入。 |
| `transparencyEnabled` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `style` | `KlpVisualStyle?` | 否 | null | 依公開型別提供此輸入。 |
| `stylePack` | `KlpStylePack?` | 否 | null | 此 scope 使用的合法風格包。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [匯入共通風格檔](../../../guides/flutter/01-klp-style-pack.md)：跨元件使用流程。

- [KlpAccent](klp-accent.md)
- [KlpStylePack](klp-style-pack.md)
- [KlpThemeVariant](klp-theme-variant.md)
- [KlpVisualStyle](klp-visual-style.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_theme.dart`。
