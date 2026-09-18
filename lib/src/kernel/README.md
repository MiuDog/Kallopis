# lib/src/kernel：核心基底與契約保證

[返回上層 (lib/src)](../README.md)

## 目錄職責

`lib/src/kernel` 是 Kallopis 整個宣告式架構的最底層基礎設施（純 Dart 實作，零外部 UI 相依）。它為上層的結構驗證、資源生命週期、身分標識與錯誤回報提供核心定義與不可破壞的合約約束。

## 子目錄結構與職責

| 子目錄 | 核心職責 | 關鍵型別與實作 |
|---|---|---|
| `diagnostics/` | **契約診斷與錯誤代碼**：定義統一的契約錯誤型別 `KlpContractError`，確保在結構、註冊、風格、插槽等合約違反時，能輸出穩定的錯誤碼與清晰診斷資訊。 | `KlpContractError` |
| `identity/` | **放置與語意標識**：提供不可變的結構化放置識別碼 `KlpPlacementId`（分段儲存 scope 路徑與 local id），解決重複命名與嵌套碰撞問題；以及語意識別字彙格式驗證器。 | `KlpPlacementId`, `internal/klp_identifier.dart` |
| `lifecycle/` | **操作租約與容錯清理**：提供畫面操作資格租約 `KlpFrameLease`，確保過期或被隱藏/撤銷的畫面回呼無法執行；以及多步驟生命週期容錯清理器，確保個別清理失敗時其餘資源仍能完成釋放。 | `KlpLifecycleException`, `klp_frame_lease.dart`, `klp_run_lifecycle_actions.dart` |

## 架構依賴與邊界約定

- **單向純粹性**：`kernel` 為底層，禁止依賴任何上層目錄（如 `composition`、`runtime`、`rendering`、`application`），更絕對嚴禁依賴 Flutter 或任何 UI 框架。
- **不可變性**：`KlpPlacementId` 具備值相等性（value equality）與 hash，作為跨 frame 快照、資源安裝與渲染層 element key 的單一識別來源。
- **租約約束**：所有從渲染層或非同步回呼出發的操作，都必須經由 `KlpFrameLease` 檢驗有效性，杜絕畫面切換或動畫過渡期間引發的「殭屍回呼（Zombie Callback）」。
