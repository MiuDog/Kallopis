## 分析入口

`styles/` 目前只有預設風格組裝表 `default_style.dart`。它將色彩、字型、間距、形狀、動態、表面、元件、資料視覺化與幾何 preset 組成 _defaultStyle，經 KlpVisualStyle.defaultStyle 對外取得。此目錄沒有獨立 style registry 或巢狀子目錄。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 預設組合在哪？ | _defaultStyle — `lib/src/styles/default_style.dart:5` |
| 消費入口是哪個符號？ | KlpVisualStyle.defaultStyle — `lib/src/theme/klp_visual_style.dart:49` |
| 明暗如何衍生？ | KlpVisualStyle.forBrightness — `lib/src/theme/klp_visual_style.dart:58` |

重要關係：

- `klp_visual_style.dart` → `default_style.dart` 是 `part`，後者以 `part of` 回指；兩檔同屬一個 Dart library，不能標為雙向 import 循環（`lib/src/theme/klp_visual_style.dart:13`、`lib/src/styles/default_style.dart:1`）。
- `_defaultStyle` → 各 theme preset：組裝值直接列於建構式（`lib/src/styles/default_style.dart:7`），component 使用 inherited、geometry 使用 standard。
- `KlpVisualStyle.defaultStyle` → `_defaultStyle`：公開靜態常數引用組裝表（`lib/src/theme/klp_visual_style.dart:49`）。

part 與 import 均不代表執行先後；這裡描述常數組成關係。
