# KlpDockLayout：元件樹架構

## 範圍

- **核心元件**：`KlpDockLayout`
- **所屬領域**：`shell — 應用外殼`
- **核心職責**：Kallopis KlpDockLayout 元件
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

  root["KlpDockLayout"]:::root
  n1["ColoredBox"]
  root --> n1
  n2["Padding"]
  n1 --> n2
  n3["LayoutBuilder"]
  n2 --> n3
  n4["Stack"]
  n2 --> n4
  n5["Row"]
  n4 --> n5
  n6["SizedBox"]
  n5 --> n6
  n7["Expanded"]
  n6 --> n7
  n8["Column"]
  n7 --> n8
  n9["Builder"]
  n8 --> n9
  n10["Positioned"]
  n8 --> n10
  n11["IgnorePointer"]
  n8 --> n11
  n12["Container"]
  n8 --> n12
  n13["Align"]
  n12 --> n13
  n14["KlpPanelFrame"]:::container
  n13 --> n14
  n15["KlpDockHeader"]:::reference
  n14 --> n15
  n16["Text"]
  n14 --> n16
  n17["Material"]
  n14 --> n17
  n18["InkWell"]
  n17 --> n18
  n19["Center"]
  n17 --> n19
  n20["MouseRegion"]
  n19 --> n20
  n21["KlpDragPreview"]:::reference
  n20 --> n21
  n22["Opacity"]
  n20 --> n22
  n23["DecoratedBox"]
  n20 --> n23
  n24["leading (slot)"]:::slot
  n23 --> n24
  n25["child / slot"]:::slot
  n23 --> n25
```

## 外部元件引用

- [`KlpDockHeader`](./klp_dock_header.md) — `shell — 應用外殼`
- [`KlpDragPreview`](../interaction/klp_drag_preview.md) — `interaction — 互動`
- [`KlpPanelFrame`](./klp_panel_frame.md) — `shell — 應用外殼` *(純容器，已繼續向下展開)*

## 程式碼證據

- 檔案路徑：[`lib/src/shell/docking/klp_dock_layout.dart`](../../../../lib/src/shell/docking/klp_dock_layout.dart#L15)
- 宣告型態：`StatefulWidget`

## 閱讀說明

- **實線節點**：Flutter 原生元件或本元件自身節點。
- **容器節點（圓角/綠框）**：本專案之純容器元件（如 `KlpSurface` 等），已持續向下展開其子樹。
- **虛線/引號節點（黃框/:::reference）**：本專案其他功能性元件，依規則停止展開並提供文件引用。
- **插槽節點（橘框/:::slot）**：外部傳入之 `child`、`builder` 或內容參數。
