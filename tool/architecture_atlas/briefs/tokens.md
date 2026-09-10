## 分析入口

`tokens/primitive_token.dart` 直接定義 KlpScale 數值階梯與 KlpPalette 色彩階梯，是設計語言的原始值來源。公開顏色只以色族與色階命名；資料視覺化用途與模式由 KlpDataVisualizationTheme 組合。`internal/klp_accent.dart` 以 part 共用同一 library 的私有色值，定義 KlpAccent 明暗配對。語意模型各自位於 `theme/`，由 `lib/kallopis_theme.dart` 明確公開；tokens 目錄不再保存轉接 barrel。裝飾色盤不屬於設計語言，留在 foundation。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 原始數值定義在哪？ | KlpScale — `lib/src/styling/legacy_tokens/primitive_token.dart:16` |
| 原始色彩定義在哪？ | KlpPalette — `lib/src/styling/legacy_tokens/primitive_token.dart:137` |
| accent 如何共用私有色值？ | part — `lib/src/styling/legacy_tokens/primitive_token.dart:3`；KlpAccent — `lib/src/styling/legacy_tokens/internal/klp_accent.dart:8` |
| semantic 類型如何公開？ | 職責入口 — `lib/kallopis_theme.dart` |
| theme 如何讀取階梯？ | KlpSpacingTheme 的 import — `lib/src/styling/legacy_theme/klp_spacing_theme.dart:3` |

重要關係：

- `primitive_token.dart` → `internal/klp_accent.dart` 是 part，共用同一 library；反向 part of 不是循環 import（`lib/src/styling/legacy_tokens/primitive_token.dart:3`、`lib/src/styling/legacy_tokens/internal/klp_accent.dart:1`）。
- theme 各模型單向 import primitive scale；公開可見性由套件根目錄的 `kallopis_theme.dart` 宣告，不在 `src/tokens` 建立反向轉匯。

import／export 顯示可見性與靜態依賴，不是執行順序或資料更新流程。
