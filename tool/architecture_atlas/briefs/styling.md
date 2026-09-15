## 分析入口

新風格資料樣板：`primitives/` 固定量值種類與完整集合；`references/` 是封閉同型參照；`semantics/` 定義用途 owner、名稱與引用公開性；`resolution/internal/` 驗證引用圖並求值。公開型別從 `kallopis_declarative.dart` 匯出，resolver 與結果快照維持 internal。

`KlpDefinition` 將 schema owner 綁定定義 id，`KlpRegistry` 掛載前驗證全量語意。跨 owner 需宣告相依且目標公開，不能覆寫對方用途；實際目標 kind 仍需核對，避免同名假 key。

顏色、padding、圓角與陰影已採 [風格 v1.0.0](../../../../spec/style-v1.md)。`KlpWorkspacePreset` 提供完整暖灰／中性色調，`KlpPaperShadowRecipe` 為新舊表面共用的雙層陰影配方。宣告式 Surface 的陰影由可選 semantic color／scale 解析；Frame 維持平整。此版本不凍結其餘尺寸、完整畫面或擴張八槽原料 schema。引用限制見 [契約樣板](../../styling-contract-prototype.md)。
