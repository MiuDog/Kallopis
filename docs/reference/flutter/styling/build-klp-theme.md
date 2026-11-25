# buildKlpTheme

Flutter · Stable · 語意風格

## 主要職責

由一套視覺風格建出 `ThemeData`。

色彩的來源規則刻意是**明確的，不做推測**：

- 不給 [style]：依 [brightness] 取內建 preset，套用 defaultStyle 風格。
- 給了 [style]：**`style.colors` 就是色彩，[brightness] 不再干涉。**

曾經試過「偵測消費者有沒有動過色彩，沒動過才依 brightness 挑」，那是行不通的：
Dart 會把欄位值相同的 `const` 實例正規化成同一個物件，因此一組剛好等於內建
preset 的自訂色盤會被誤判為未修改，然後被靜默換掉。**能被靜默搞錯的推測就不要做。**

[accent] 為 `null` 時保留色彩層原本的 interaction 色；給定值才覆寫它。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

final productBuildKlpTheme = buildKlpTheme;
```

<!-- reference-api:start -->

## 公開簽名

```dart
ThemeData buildKlpTheme(
	Brightness brightness, {
	KlpAccent? accent,
	KlpVisualStyle? style,
})
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `brightness` | `Brightness` | 是 | — | 依公開型別提供此輸入。 |
| `accent` | `KlpAccent?` | 否 | null | 依公開型別提供此輸入。 |
| `style` | `KlpVisualStyle?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [1. 建立產品根節點](../../../guides/flutter/02-build-klp-theme.md)：跨元件使用流程。

- [KlpAccent](klp-accent.md)
- [KlpVisualStyle](klp-visual-style.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_theme.dart`。
