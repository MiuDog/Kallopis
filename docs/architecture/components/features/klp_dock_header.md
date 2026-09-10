# KlpDockHeader：元件樹架構

## 範圍

- **核心元件**：`KlpDockHeader`
- **所屬領域**：`features`
- **核心職責**：Dock Group 專用的緊湊 Header。  左側區域可由 Layout 包成拖曳來源；右側 actions 是獨立 clickable 區域， 因此操作按鈕不會誤觸 panel 拖曳。
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

  root["KlpDockHeader"]:::root
  n1["KlpBox"]:::reference
  root --> n1
  n2["KlpLayoutBuilder"]:::reference
  root --> n2
  n3["KlpPanelHeader"]:::reference
  root --> n3
  n4["KlpIconButton"]:::reference
  root --> n4
  n5["KlpContextMenu"]:::reference
  root --> n5
  n6["leading (slot)"]:::slot
  root --> n6
  n7["child / slot"]:::slot
  root --> n7
```

## 外部元件引用

- [`KlpBox`](../foundation/klp_box.md) — `foundation — 圖示、色盤、度量`
- [`KlpContextMenu`](./klp_context_menu.md) — `features`
- [`KlpIconButton`](./klp_icon_button.md) — `features`
- [`KlpLayoutBuilder`](../foundation/klp_layout_builder.md) — `foundation — 圖示、色盤、度量`
- [`KlpPanelHeader`](./klp_panel_header.md) — `features`

## 程式碼證據

- 檔案路徑：[`lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart`](../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L7)
- 宣告型態：`StatefulWidget`

## 閱讀說明

- **實線節點**：Flutter 原生元件或本元件自身節點。
- **容器節點（圓角/綠框）**：本專案之純容器元件（如 `KlpSurface` 等），已持續向下展開其子樹。
- **虛線/引號節點（黃框/:::reference）**：本專案其他功能性元件，依規則停止展開並提供文件引用。
- **插槽節點（橘框/:::slot）**：外部傳入之 `child`、`builder` 或內容參數。
