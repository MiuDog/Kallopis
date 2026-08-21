# KlpWindowHeader：元件樹架構

## 範圍

- **核心元件**：`KlpWindowHeader`
- **所屬領域**：`shell — 應用外殼`
- **核心職責**：桌面應用程式自帶視窗標題列（Chrome Header）。  - **Windows / Linux 模式**：左側展示 App Icon 與標題，右側展示自訂動作與視窗控制項。 - **macOS 模式**：左側展示視窗控制項（交通燈），中間展示 App Icon 與標題，右側展示自訂動作。
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

  root["KlpWindowHeader"]:::root
  n1["Text"]
  root --> n1
  n2["Row"]
  root --> n2
  n3["SizedBox"]
  n2 --> n3
  n4["KlpWindowControls"]:::reference
  n3 --> n4
  n5["Material"]
  n3 --> n5
  n6["Padding"]
  n5 --> n6
  n7["Expanded"]
  n6 --> n7
  n8["Stack"]
  n7 --> n8
  n9["Spacer"]
  n8 --> n9
  n10["Center"]
  n8 --> n10
  n11["leading (slot)"]:::slot
  n10 --> n11
  n12["trailing (slot)"]:::slot
  n10 --> n12
  n13["child / slot"]:::slot
  n10 --> n13
```

## 外部元件引用

- [`KlpWindowControls`](./klp_window_controls.md) — `shell — 應用外殼`

## 程式碼證據

- 檔案路徑：[`lib/src/shell/klp_window_header.dart`](../../../../lib/src/shell/klp_window_header.dart#L11)
- 宣告型態：`StatelessWidget`

## 閱讀說明

- **實線節點**：Flutter 原生元件或本元件自身節點。
- **容器節點（圓角/綠框）**：本專案之純容器元件（如 `KlpSurface` 等），已持續向下展開其子樹。
- **虛線/引號節點（黃框/:::reference）**：本專案其他功能性元件，依規則停止展開並提供文件引用。
- **插槽節點（橘框/:::slot）**：外部傳入之 `child`、`builder` 或內容參數。

