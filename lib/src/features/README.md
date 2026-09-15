# lib/src/features：業務功能元件與適配層

[返回上層 (lib/src)](../README.md)

## 目錄職責

`lib/src/features` 承載面向使用者與業務場景的高階功能元件（Features）。在全新宣告式架構下，Feature 元件不直接編寫 Widget，而是透過專屬的 Adapter 將高階功能與狀態投影降維為 `foundation` 的受控基礎模板（文字、表面、線性容器、三區佈局等）與 `runtime` 放置資源。

## 子目錄結構與職責

| 子目錄 | 核心職責 | 關鍵型別與實作 |
|---|---|---|
| `navigation/` | **宣告式導覽元件**：提供符合 `KlpScreenBody` 資格的高階導覽欄位（如 `KlpRail`），內建 Top/Center/Bottom 三區受控插槽與選取狀態管理。 | `KlpRail`, `KlpRailItem`, `adapters/klp_rail_adapter.dart`, `internal/klp_prepared_rail.dart` |
| `editing/` | **筆記與富文字編輯功能**：筆記編輯畫布、區塊操作列、錨點定位選單、模式切換列等編輯器功能實作。 | 編輯器高階元件與適配器 |
| `actions/` | **操作與按鈕功能**：按鈕群組、操作工具列等業務互動功能。 | 按鈕與操作元件 |
| `collections/` | **資料集合呈現**：清單、網格、樹狀檢視等結構化資料集合。 | 集合展示元件 |
| `feedback/` | **進度與反饋元件**：載入指示器、提示條、對話框狀態展示。 | 反饋與狀態元件 |
| `forms/` | **受控表單與輸入**：受控欄位、表單驗證與資料提交。 | 表單元件 |
| `infinite_canvas/` | **無限畫布功能**：畫布平移、縮放與節點放置候選實作。 | 畫布視角與節點管理 |
| `overlays/` | **覆層與彈窗功能**：浮動提示 (Tooltip)、快顯視窗、選單覆層。 | 覆層管理原語 |
| `workspace/` | **工作區框架**：IDE/筆記多窗格工作區、側邊欄、分頁與 Shell 容器。 | 工作區 Shell 與面板佈局 |

## 架構依賴與邊界約定

- **降維至模板**：Feature 元件內部透過 `KlpNodeAdapter` 將功能屬性轉換為 `KlpPreparedNode` 與 `foundation` 模板，不自建第二套渲染體系。
- **無 Flutter 直接相依**：新架構下的 Feature 核心規格保持純 Dart，鍵盤焦點、按鍵事件與無障礙語意全交由共用渲染原語處置。
- **不回流產品語意**：通用元件不寫入特定應用（如 Notist）的領域模型（如 Notebook/Page/Task），維持共用視覺層純潔性。
