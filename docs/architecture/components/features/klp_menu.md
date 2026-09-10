# KlpMenu：元件樹架構

## 範圍

- **核心元件**：`KlpMenu`
- **所屬領域**：`features`
- **核心職責**：彈出式選單面板：標題列加上一組 [KlpMenuItemData]。  只畫面板本身（含陰影與圓角），不處理定位或觸發——插入 overlay 的位置請用 [KlpMenuLayout] 先算好，選單的顯示／關閉時機也由呼叫端控制。
- **包含範圍**：`build()` 內部建構的完整 Widget 樹（展開 Flutter 原生元件與純容器）
- **外部引用**：本專案其他非純容器元件（遇引用即停下並鏈結）

## 架構圖

```mermaid
flowchart TD
  classDef default fill:#1E222B,stroke:#4C566A,stroke-width:1px,color:#ECEFF4;
  classDef root fill:#2E3440,stroke:#88C0D0,stroke-width:2px,color:#ECEFF4,font-weight:bold;
  classDef reference fill:#3B4252,stroke:#EBCB8B,stroke-width:1.5px,stroke-dasharray: 4 3,color:#EBCB8B;
  classDef container fill:#2E3440,stroke:#A3BE8C,stroke-width:1.5px,color:#A3BE8C;
  classDef slot fill:#2E3440,stroke:#D08770,stroke-width:1px,stroke-dasharray: 2 2,color:#D08770;

  root["KlpMenu"]:::root
  n1["KlpFocusRegion"]:::reference
  root --> n1
  n2["KlpSurface"]:::container
  root --> n2
  n3["KlpBox"]:::reference
  n2 --> n3
  n4["KlpColumn"]:::reference
  n2 --> n4
  n5["KlpAlign"]:::reference
  n2 --> n5
  n6["KlpText"]:::reference
  n2 --> n6
  n7["KlpDashedDivider"]:::reference
  n2 --> n7
  n8["KlpDivider"]:::reference
  n2 --> n8
  n9["KlpMenuItem"]:::reference
  n2 --> n9
  n10["child / slot"]:::slot
  n2 --> n10
```

## 外部元件引用

- [`KlpAlign`](../foundation/klp_align.md) — `foundation — 圖示、色盤、度量`
- [`KlpBox`](../foundation/klp_box.md) — `foundation — 圖示、色盤、度量`
- [`KlpColumn`](../foundation/klp_column.md) — `foundation — 圖示、色盤、度量`
- [`KlpDashedDivider`](../foundation/klp_dashed_divider.md) — `foundation — 圖示、色盤、度量`
- [`KlpDivider`](../foundation/klp_divider.md) — `foundation — 圖示、色盤、度量`
- [`KlpFocusRegion`](../foundation/klp_focus_region.md) — `foundation — 圖示、色盤、度量`
- [`KlpMenuItem`](./klp_menu_item.md) — `features`
- [`KlpSurface`](../foundation/klp_surface.md) — `foundation — 圖示、色盤、度量` *(純容器，已繼續向下展開)*
- [`KlpText`](../foundation/klp_text.md) — `foundation — 圖示、色盤、度量`

## 程式碼證據

- 檔案路徑：[`lib/src/features/overlays/menu/klp_menu_widget.dart`](../../../../lib/src/features/overlays/menu/klp_menu_widget.dart#L7)
- 宣告型態：`StatefulWidget`

## 閱讀說明

- **實線節點**：Flutter 原生元件或本元件自身節點。
- **容器節點（圓角/綠框）**：本專案之純容器元件（如 `KlpSurface` 等），已持續向下展開其子樹。
- **虛線/引號節點（黃框/:::reference）**：本專案其他功能性元件，依規則停止展開並提供文件引用。
- **插槽節點（橘框/:::slot）**：外部傳入之 `child`、`builder` 或內容參數。
