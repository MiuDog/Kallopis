## 分析入口

`foundation/` 同時包含裝飾 palette／metrics 常數、OKLCH 色彩模型，以及 icon、inline code、spinner、progress 等會讀 theme 的視覺元件；不能把整個目錄視為無上游依賴的純常數底層。圖示目前由 KlpIconData 與 KlpIcon 組合 Flutter IconData 字型。設計語言的 KlpPalette 與 KlpAccent 已歸 tokens，這裡只保留非設計語言的 KlpDecorativePalette。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 裝飾色盤定義在哪？ | KlpDecorativePalette — `lib/src/foundation/klp_palette.dart:8` |
| OKLCH 資料入口？ | KlpOklchColor — `lib/src/foundation/klp_oklch_color.dart:12` |
| 圖示如何實際繪出？ | KlpIcon.build — `lib/src/foundation/klp_icon.dart:57` |
| 靜態尺寸常數有哪些分類？ | KlpSpace／KlpControlMetrics — `lib/src/foundation/klp_metrics.dart:8`、`lib/src/foundation/klp_metrics.dart:138` |

重要關係：

- `klp_palette.dart` 僅 import Flutter 色彩型別，定義預覽桌布與視窗控制鈕的裝飾值；未匯出設計語言色盤（`lib/src/foundation/klp_palette.dart:1`、`lib/src/foundation/klp_palette.dart:8`）。
- `KlpIcon.build` → Flutter `IconData`：由字重決定字碼與字型，並指定 fontPackage 為 kallopis（`lib/src/foundation/klp_icon.dart:60`、`lib/src/foundation/klp_icon.dart:64`）。
- 目錄層級 `foundation → theme → tokens`：icon 引入 theme，theme 引入 primitive token（`lib/src/foundation/klp_icon.dart:3`、`lib/src/theme/klp_theme.dart:7`）。兩端是不同職責的檔案。

import 依賴圖不能推導執行順序；圖示載入應以現行 IconData 實作為準。
