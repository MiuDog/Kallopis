## 分析入口

新 Klp 路徑位於 `templates/`、`definitions/` 與 `binding/internal/`：外部作者只在定義期組合文字、線性排版、表面與 `KlpChildrenTemplate<T, C>`。元件定義遍歷模板取得唯一插槽 schema；compiler 先驗證 semantic 使用權限、模板資格及已擷取的 slot 範圍，再投影資料。`prepareCaptured` 產生不可變 `KlpPreparedComponent`，資源安裝後才嵌入已完成子呈現；不重新讀取外部結構 getter。

內部 bound 集合另含選擇操作、三區配置、單方向尺寸與完成的 `KlpBoundPlacement`，供 feature adapter／runtime 組合；renderer 不會收到未完成插槽。放置包裝保存識別，支援同層重排時延續 element。這些內部 bound 型別不等於外部公開模板，也不與以下 Klp 舊元件互相轉接。詳見 [元件模板樣板](../../component-template-prototype.md) 與 [合格子插槽](../../component-slots-prototype.md)。

`KlpBoundPlacement.id` 使用結構化 `KlpPlacementId`，不同 scope 的同名元件不共用呈現 key。`KlpBoundRetainedStack` 只接受已完成的頁面放置與有效 activeId，拒絕空頁集合、重複識別及不存在的目前頁；這是內部呈現資料，不是公開 Router 或任意畫面 builder。

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
- 目錄層級 `foundation → theme → tokens`：icon 引入 theme，theme 引入 primitive token（`lib/src/foundation/klp_icon.dart:3`、`lib/src/styling/legacy_theme/klp_theme.dart:7`）。兩端是不同職責的檔案。

import 依賴圖不能推導執行順序；圖示載入應以現行 IconData 實作為準。
