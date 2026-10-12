# Panel 微立體選項

READY：使用者要求把既有微立體接回為可選元件選項。KLP-0022 的直接 Flutter 架構保持。

KlpPanelFrame 新增 KlpPanelElevation { flat, raised }，預設 flat。raised 由 context.klp 的表面色、surface.overlayShadowColor 與 space.space1 基準套用原 KlpFrameReliefRecipe；陰影位於內容 ClipRRect 外，不更改布局、圓角、內外距或資料事件。只增加此元件選項，不自動變更任何產品 caller。

配方保留 offset(2,3)、blur5、spread-1、左上(-1,-1)亮邊，以及既有淺深alpha。style轉換屬styling；Panel僅選配方。保護路徑：test、既有其他元件及 theme 預設。

本切片寫入：features/workspace/shell/panel/klp_panel_frame.dart、同目錄 primitives/klp_panel_frame_view.dart、styling/presets/klp_frame_relief_recipe.dart（相對lib/src）。Catalog追加raised展示。驗收：局部analyze、實際淺深／flat raised對照；純視覺可逆變更不新增測試。估算10–20分鐘，M1接線、M2展示。人類接受視覺。

實作證據：局部 Dart analyze 無問題；Web debug build 通過；已檢視真實公開 Panel 的淺深色 flat／raised 並排畫面。陰影與亮邊已呈現，視覺品質待使用者接受。本次未執行測試或 Windows build。
