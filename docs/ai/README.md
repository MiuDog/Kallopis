# AI 使用手冊

本目錄是供 AI 與消費端工程師執行新 Kallopis 宣告式架構的操作契約。目標是讓一個畫面只有一種結構入口，並讓所有風格、生命週期與 renderer 決策留在本庫。

## 從這裡開始

舊元件遷移的固定清冊及完成／刪除條件見 [Catalog 遷移](../architecture/catalog-migration/README.md)。新選單宣告與合法組裝見 [Menu](menu-model.md)；其餘元件不能因舊 Catalog 有展示便當成新版已交付。

1. 初次使用先讀[四階段入門](getting-started.md)，只完成目前階段：視覺組成 → 產品資料模型 → 資料／互動接線 → 動畫／體驗優化。
2. 想確認某個產品意圖能否完成，查[完整生產力能力清冊](productivity-capabilities.md)；想追查舊名稱則查[固定 254 項逐項轉接](catalog-capability-map.md)。
3. 進入某項能力後，再讀對應的完整配方與 API 契約；所有 consumer 程式只匯入 `package:kallopis/kallopis_declarative.dart`。
4. 若現有節點不足，依[元件能力與庫內擴充](external-components.md)提出資料、事件、插槽與平台契約；不要在 consumer 建立新 component type。
5. 以[驗證指南](verification.md)檢查 consumer。`systems.md`、內部 module 與架構圖集只供 Kallopis 維護者查證，不是初學者的先修內容。

## 消費端可提供的內容

| 類別 | 可提供內容 | Kallopis 持有內容 |
|---|---|---|
| application | 標題、完整 primitive set、router | 完整元件目錄、host、renderer、安裝交易 |
| node 實例 | 已公開型別的 id、資料、合格子項、`KlpAction`／callback | 元件 identity、樣式解析、布局、互動狀態 |
| route | 型別化參數、畫面映射、進出 guard | navigation session、回退與保留頁 |
| primitive set | 固定欄位各八個值的完整替換 | schema、semantic 演算法、局部樣式決定 |

## 禁止的輸入

以下內容一律不屬於 consumer API：

- `Widget build(BuildContext context)`、任何 `Widget` 值或 renderer callback。
- `BuildContext`、`ThemeData`、`AnimationController`、`NavigatorState`。
- 個別元件的 style、color、padding、radius、duration、font 或 curve。
- 不受容器資格限制的 child、任意 provider、手動 mount 或平台分支。
- `KlpComponentDefinition`、`KlpDefinition`、`KlpRegistry`、adapter 或 compiler。
- 部分 primitive 覆寫、增加 primitive 種類，或在實例覆寫 semantic token。

## 文件索引

- [四階段入門](getting-started.md)：依視覺組成、產品資料模型、資料／互動接線、動畫／體驗優化逐步前進；目前只展開第一個可執行步驟。
- [完整生產力能力清冊](productivity-capabilities.md)：依使用者意圖查詢可用狀態、證據、缺口與下一 owner。
- [固定 254 項逐項轉接](catalog-capability-map.md)：查詢每個舊 Catalog 名稱的能力、階段、coverage 與預定處置。

- [Workspace.Explorer / EXP-V1-r2](explorer-model.md)：正式 interface、能力、狀態、事件與宣告 → 組裝；[視覺 Catalog](explorer-catalog.md)。
- [公開錨定 Popup](anchored-popup-model.md)：受控開關、穩定列 ID、原地回饋、子命令及錨點生命週期；[交付證據](../architecture/anchored-popup-delivery.md)。

- [功能名稱、組裝與視覺維護入口（DEFINE）](feature-contracts.md)：實際組裝層級與來源位置、固定功能名稱提案、人類契約卡及跨 agent 交接方式；尚非全部已接受的功能契約。

- [BlockNote 正文編輯器（實驗）](blocknote-editor.md)：組裝正式正文節點、版本化 JSON、宿主保存與關閉契約，以及目前平台與圖片限制。
- [編輯內容系統（實驗）](editor.md)：Workspace 組裝、唯讀／重排／可編輯來源能力、輸入生命週期與目前驗收限制。
- [區塊控制系統（實驗）](block-controls.md)：受限控制插槽、唯一來源、滑鼠／鍵盤區塊操作與清單選單；完整實機及讀屏驗收尚未完成。
- [定位命令系統（實驗）](anchored-commands.md)：同源命令插槽、候選與錨點資料、組裝模板；操作機制已驗證，可見入口尚未交付。
- [編輯模式與導覽（實驗）](editor-modes.md)：模式工具列插槽、工具能力、切換生命週期與核心捲動機制；可見切換入口尚未交付。
- [手寫暫態資料（實驗）](handwriting-state.md)：同一來源的筆劃快照、預覽資料與發布模板；資料機制已驗證，正式手寫尚未接入。
- [編輯器保存與重開（實驗）](editor-saving.md)：正式 owner、同源保存投影、明確重試及文件重開已經驗證；可見入口仍在實作。
- [編輯提供者資料契約（實驗）](editing-provider.md)：提供者入口、投影與幾何格式、來源通知及 Krepis 真實資料轉接。

- [Catalog 開發入口](catalog.md)：VS Code F5、深淺色、打包與新舊展示範圍。

- [消費端畫面組裝指南](screen-composition.md)：自訂 ScreenBody、無預設 Workbench、Bento Grid / 多面板模板與自適應組裝。
- [平台策略 Adaptive](adaptive-platform-strategies.md)：由 Kallopis 選定平台後才建立單一宣告式策略樹。
- [宣告式公開面清冊](../architecture/declarative-public-surface.md)：L0–L7 唯一擁有者、可組裝內容與刻意不公開的 authoring/runtime 型別。

- [組裝模板](composition-templates.md)：application、router、screen、受限容器與資料更新。
- [系統索引與能力範例](systems.md)：維護者依 application、composition、styling、navigation、state、foundation、features、runtime 與 legacy 系統查證實作；不是初學者入口。
- [元件能力與庫內擴充](external-components.md)：封閉元件目錄、consumer 邊界與新能力申請資料。
- [驗證指南](verification.md)：CI 指令、預期結果與排錯。
- [架構總覽](../architecture/current-refactor-overview.md)：目前實作、legacy 收納位置與未完成能力。
- [遷移決策](../../spec/decisions/KLP-0019-declarative-framework-migration.md)：長期約束與驗收條件。

表單尚未有可用 renderer。不要生成表單 consumer 範例或用 Flutter widget 暫時繞過此限制。
