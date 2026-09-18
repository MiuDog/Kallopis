# lib/src/runtime：執行期整樹編譯與資源安裝

[返回上層 (lib/src)](../README.md)

## 目錄職責

`lib/src/runtime` 是 Kallopis 宣告式 runtime 的引擎中樞。它負責整合結構樹驗證、節點準備（Prepare）、放置資源安裝（Installation）、跨 Frame 資源重用，以及產生不可變的呈現快照（Bound Frame）。本目錄為全封閉內部實作，不對外部消費端公開。

## 子目錄結構與職責

| 子目錄 | 核心職責 | 關鍵型別與實作 |
|---|---|---|
| `compilation/` | **整樹編譯與快照生成 (Compilation)**：透過 `KlpTreeRuntime` 調度單次擷取、執行所有節點的 adapter 準備工作，自底向上組合成封閉的 `KlpBoundPlacement` 樹，並產出當前 frame 與操作租約。 | `KlpTreeRuntime`, `KlpRuntimeFrame`, `KlpNodeAdapter`, `KlpPreparedNode` |
| `installation/` | **放置資源交易與重用 (Installation)**：以不可變的 `KlpPlacementId` 為鍵，管理元件內部資源（State、Controller 等）的建立、更新、跨 frame 重用與逆序安全銷毀。 | `KlpInstallation`, `KlpPlacementResource`, `KlpDefaultPlacement`, `KlpInstallationException` |

## 架構依賴與邊界約定

- **交易式提交**：準備或資源建立失敗時，保留舊有畫面與既有操作；只有在新畫面整樹準備成功後，才以交易方式提交新 frame 並撤銷舊 frame 的操作租約。
- **身分連續性**：資源重用依賴由 `kernel/identity` 定義的 `KlpPlacementId` 與定義類型，同位置同定義的節點重用其資源，避免畫面重建時丟失輸入中狀態。
- **無 UI 相依**：編譯與安裝核心不引用 `package:flutter`，僅專注於狀態與資料結構的拓撲計算。
