# lib/src/foundation：基礎原語、模板與呈現綁定

[返回上層 (lib/src)](../README.md)

## 目錄職責

`lib/src/foundation` 扮演「受控視覺建構積木」的角色：提供庫內元件使用的受控基礎模板（Templates）、呈現資料綁定集合（Binding）、封閉 catalog metadata，以及字型、圖示與色彩空間（OKLCH）等基礎視覺原語。

## 子目錄與核心結構職責

| 子目錄 / 檔案 | 核心職責 | 關鍵型別與實作 |
|---|---|---|
| `templates/` | **受控基礎模板 (Templates)**：庫內 adapter 在定義期使用的封閉模板，包含文字模板、線性排列模板、表面裝飾模板、子插槽模板等。 | `KlpTextTemplate`, `KlpLinearTemplate`, `KlpSurfaceTemplate`, `KlpChildrenTemplate` |
| `definitions/` | **庫內元件 metadata**：連結庫擁有 definition identity、semantic schema 與模板，不提供 consumer 註冊。 | `KlpComponentDefinition`（遷移後僅庫內） |
| `binding/` | **呈現資料綁定 (Binding)**：存放編譯與準備後的不可變 bound 呈現結構資料，包含完成的放置資料與保留畫面堆疊。 | `KlpBoundTemplate`, `KlpBoundPlacement`, `KlpBoundRetainedStack` |
| `content/` | **文字呈現相容與基礎實作**：文字度量與基礎內容呈現支援。 | 文字內容處理原語 |
| `interaction/` | **共用互動與鍵盤合約**：按鍵綁定、互動過濾與操作手勢基本定義。 | 鍵盤綁定與互動模型 |
| `layout/` | **基礎排版原語**：三區配置（regions）、單向尺寸限制等佈局幾何規則。 | 佈局幾何定義 |
| `surface/` | **表面與裝飾**：卡片、背景層、描邊等視覺表面呈現基礎。 | 頁面背景與表面原語 |
| `platform/` | **平台抽象接點**：平台環境與適配底層。 | 平台環境探測 |
| `metrics/` | **度量常數**：間距與控制項幾何尺寸。 | `KlpSpace`, `KlpControlMetrics` |
| 頂層檔案群 | **圖示與色彩模型**：OKLCH 廣色域色彩計算模型、向量圖示字型與資料包裝、幾何 Spinner 等底層元件。 | `KlpOklchColor`, `KlpIcon`, `KlpIcons`, `KlpIconData`, `KlpGeometricSpinner` |

## 架構依賴與邊界約定

- **封閉模板原則**：只有庫內元件擁有者可使用 `foundation/templates/` 的受控模板組合介面；consumer 不建立模板或 Flutter `Widget build(BuildContext context)`。
- **不可直接存取未綁定插槽**：`binding/` 中的 `KlpBoundPlacement` 必定帶有由 `kernel/identity` 定義的完整 `KlpPlacementId`，確保多層與同名元件渲染唯一性。
- **純量與呈現分離**：裝飾色盤 `KlpDecorativePalette` 獨立於設計系統 Token，僅用於特定視窗裝飾或預覽背景。
