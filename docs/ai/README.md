# AI 使用手冊

本目錄是供 AI 與消費端工程師執行新 Kallopis 宣告式架構的操作契約。目標是讓一個畫面只有一種結構入口，並讓所有風格、生命週期與 renderer 決策留在本庫。

## 執行順序

1. 只匯入 `package:kallopis/kallopis_declarative.dart`。
2. 先定義資料模型、資料來源與 callback；不要建立 Flutter view。
3. 用 [組裝模板](composition-templates.md) 產生 `KlpApplication`、`KlpRouter`、`KlpScreen` 與合格節點樹。
4. 若現有節點不足，依 [外部元件作者指南](external-components.md) 實作資格介面、節點、semantic schema 與受控模板。
5. 以 [驗證指南](verification.md) 檢查 consumer，最後才執行本庫測試。

## 消費端可提供的內容

| 類別 | 可提供內容 | Kallopis 持有內容 |
|---|---|---|
| application | 標題、完整 primitive set、router、元件定義 | host、renderer、安裝交易 |
| node 實例 | id、資料、合格子項、`KlpAction`／callback | 樣式解析、布局、互動狀態 |
| route | 型別化參數、畫面映射、進出 guard | navigation session、回退與保留頁 |
| custom definition | semantic 參照、封閉 template、可選無障礙名稱 selector | semantic 求值、rendering、slot 驗證 |
| primitive set | 固定欄位各八個值的完整替換 | schema、semantic 演算法、局部樣式決定 |

## 禁止的輸入

以下內容一律不屬於 consumer API：

- `Widget build(BuildContext context)`、任何 `Widget` 值或 renderer callback。
- `BuildContext`、`ThemeData`、`AnimationController`、`NavigatorState`。
- 個別元件的 style、color、padding、radius、duration、font 或 curve。
- 不受容器資格限制的 child、任意 provider、手動 mount 或平台分支。
- 部分 primitive 覆寫、增加 primitive 種類，或在實例覆寫 semantic token。

## 文件索引

- [組裝模板](composition-templates.md)：application、router、screen、rail、資料更新。
- [外部元件作者指南](external-components.md)：定義期與實例期的責任分離。
- [驗證指南](verification.md)：CI 指令、預期結果與排錯。
- [架構總覽](../architecture/current-refactor-overview.md)：目前實作、legacy 收納位置與未完成能力。
- [遷移決策](../../spec/decisions/KLP-0019-declarative-framework-migration.md)：長期約束與驗收條件。

表單尚未有可用 renderer。不要生成表單 consumer 範例或用 Flutter widget 暫時繞過此限制。
