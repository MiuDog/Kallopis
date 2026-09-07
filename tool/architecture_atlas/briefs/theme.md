## 分析入口

`theme/` 同時容納 semantic／component 模型、KlpVisualStyle 組合、Flutter ThemeData 建構、context.klp 存取，以及 JSON 編解碼。先從 buildKlpTheme 與 KlpTheme.of 追蹤「組裝 → 讀取」，再依需要進入各 ThemeExtension。`internal/` 將 JSON 欄位分為 colors、typography、spacing、effects、surface、components、data visualization、geometry，以及 helpers／validation；geometry 再拆 control、data、layout／optical，encode 有獨立檔。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 如何建立 Flutter 主題？ | buildKlpTheme／buildKlpThemeVariant — `lib/src/theme/klp_theme.dart:530`、`lib/src/theme/klp_theme.dart:544` |
| 元件從哪取得與覆寫 token？ | KlpTheme／KlpTokenOverride — `lib/src/theme/klp_theme_scope.dart:22`、`lib/src/theme/klp_theme_scope.dart:177` |
| 風格組合包含哪些層？ | KlpVisualStyle — `lib/src/theme/klp_visual_style.dart:23` |
| JSON 如何接受局部覆寫？ | KlpVisualStyleJson.decode — `lib/src/theme/klp_visual_style_json.dart:51` |

重要關係：

- `KlpVisualStyleJson.decode` → internal 各欄位 decoder：先拒絕未知 key、驗證版本；缺少的子 map 沿用 base（`lib/src/theme/klp_visual_style_json.dart:55`、`lib/src/theme/klp_visual_style_json.dart:68`）。
- `KlpTokenOverride.build` → Flutter `Theme.copyWith`：替換 KlpThemeData，保留其他 extensions（`lib/src/theme/klp_theme_scope.dart:189`）。
- 實際檔案雙向 import：`klp_theme.dart ↔ klp_visual_style.dart`（`lib/src/theme/klp_theme.dart:6`、`lib/src/theme/klp_visual_style.dart:10`）；不能把目前實作描述為嚴格單向層。styles 的 part 關係另當 library 組成閱讀。

這是目前靜態模組結構；import 不代表主題求值或建構的先後。
