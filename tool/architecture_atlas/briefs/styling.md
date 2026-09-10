## 分析入口

新風格資料樣板：`primitives/` 固定量值種類與完整集合；`references/` 是封閉同型參照；`semantics/` 定義用途 owner、名稱與引用公開性；`resolution/internal/` 驗證引用圖並求值。公開型別從 `kallopis_declarative.dart` 匯出，resolver 與結果快照維持 internal。

`KlpDefinition` 將 schema owner 綁定定義 id，`KlpRegistry` 掛載前驗證全量語意。跨 owner 需宣告相依且目標公開，不能覆寫對方用途；實際目標 kind 仍需核對，避免同名假 key。

目前只提供原料及用途引用，沒有 renderer、正式預設風格、狀態混合或無障礙求值政策。八槽原料 schema 尚未凍結，兩套測試資料只證明資料替換，不證明完整視覺穩定性。詳見 [契約樣板](../../styling-contract-prototype.md)。
