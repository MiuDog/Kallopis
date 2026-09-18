# Frame 與工作區間距：8px／微立體

狀態：READY。2026-09-15 使用者接受 catalog 的全 8px、微立體，並要求降低深色亮邊對比。此契約取代 style-v1.md 的 Frame 外距／欄距 12px 與一律無陰影限制。

## 接受範圍

- `app_layout.frame_inset`、`frame_group.horizontal_padding`、`workspace_block.gap` 改讀 distance i2（預設 8px）；sectionGap 共用群組內距，Layout gap 共用 frameInset。
- 不修改 primitive 距離表、12px 圓角、20px 內容內距、正文編輯內距、4px compact gap 或 32px header／控制尺寸。
- 新增公開 `KlpAppFrameSurface { flat, raised }`；`KlpAppFrame.surface` 預設 flat，Planist sidebar 與 stage 明確選 raised。toolbarControls／rightSidebar 的 bare 行為不變。
- 微立體配方：陰影 offset(2,3)、blur5、spread-1；左上亮邊 offset(-1,-1)、blur0。尺度由已解析 compactGap 4px 成比例換算。淺／深陰影 alpha 分別 46／122，亮邊 alpha 分別 217／18（約 85%／7%）；使用已解析 surface 色判別深色，陰影 RGB 由 shadow 語意提供。
- 所有風格由 styling 配方與 features adapter 解析為 bound 欄位；renderer 只轉為 Flutter，陰影在 ClipRRect 外，child bounds 不變。
- Planist main LayoutColumn 恢復 standard spacing，header–stage 為 8px；內容 noHorizontalPadding 維持。

## 責任與本輪切片

Styling：`presets/klp_frame_relief_recipe.dart` 擁有比例、陰影與亮邊配方，不匯入 Flutter。Features workspace：layout／components adapter 與 presentation 擁有 enum、語意及 bound 傳遞。Rendering：`flutter/internal/klp_flutter_app_layout.dart` 擁有外層裝飾與內容裁切。Planist workspace 只選 surface 與 spacing。

實作按配方 → adapter/bound/renderer → consumer 順序進行。測試作者獨立更新受影響 Frame、FrameGroup 契約，並驗證 Planist 幾何／原生控制；不更動 golden。完成證據為局部測試、宣告式 consumer 邊界與實際渲染圖片。視覺接受由使用者判斷。

## 本輪驗證

- Kallopis：`flutter test test/klp_app_frame_style_test.dart test/klp_frame_groups_test.dart`，17 項通過。
- Planist frontend：`flutter test test/frame_spacing_relief_test.dart`，3 項通過；含兩種外觀、三組 8px、Frame 零內容 padding、32px 視窗控制及原生 callback／拖曳。
- 改動的產品來源與三個測試檔局部 Dart analyze 通過；沒有執行全量測試。
- 實際 Flutter 圖片位於 Planist `frontend/build/frame-relief-review/frame-relief-light.png` 與 `frame-relief-dark.png`；capture 啟用完整陰影模糊，測試以記憶體資料執行，未重錄 golden。視覺已供人工審查，不宣稱人類接受。
- 宣告式 consumer 邊界仍失敗：Planist 本輪未修改的 `frontend/lib/features/workspace/content/pln_assets_content.dart:54` 匯入 `package:kallopis/kallopis_legacy_file_picker.dart`。此問題未在本輪擴張修復。
- 現有 Windows Planist 視窗未關閉或重啟；本輪未重建 Windows 執行檔、未提交或發布。
