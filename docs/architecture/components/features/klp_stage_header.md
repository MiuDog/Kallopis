# KlpStageHeader：元件樹架構

## 範圍

- **核心元件**：`KlpStageHeader`
- **所屬領域**：`features`
- **核心職責**：Stage 頂部的兩行識別標頭。  第一行顯示專案與區域，第二行顯示目前項目與類型；呼叫端只提供語意資料， 排版、間距與文字層級一律由 Kallopis theme 決定。
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

  root["KlpStageHeader"]:::root
  n1["KlpBox"]:::reference
  root --> n1
  n2["KlpRow"]:::reference
  root --> n2
  n3["KlpExpanded"]:::reference
  root --> n3
  n4["KlpColumn"]:::reference
  root --> n4
  n5["KlpFlexible"]:::reference
  root --> n5
  n6["KlpText"]:::reference
  root --> n6
  n7["child / slot"]:::slot
  root --> n7
```

## 外部元件引用

- [`KlpBox`](../foundation/klp_box.md) — `foundation — 圖示、色盤、度量`
- [`KlpColumn`](../foundation/klp_column.md) — `foundation — 圖示、色盤、度量`
- [`KlpExpanded`](../foundation/klp_expanded.md) — `foundation — 圖示、色盤、度量`
- [`KlpFlexible`](../foundation/klp_flexible.md) — `foundation — 圖示、色盤、度量`
- [`KlpRow`](../foundation/klp_row.md) — `foundation — 圖示、色盤、度量`
- [`KlpText`](../foundation/klp_text.md) — `foundation — 圖示、色盤、度量`

## 程式碼證據

- 檔案路徑：[`lib/src/features/workspace/shell/stage/klp_stage_header.dart`](../../../../lib/src/features/workspace/shell/stage/klp_stage_header.dart#L11)
- 宣告型態：`StatelessWidget`

## 閱讀說明

- **實線節點**：Flutter 原生元件或本元件自身節點。
- **容器節點（圓角/綠框）**：本專案之純容器元件（如 `KlpSurface` 等），已持續向下展開其子樹。
- **虛線/引號節點（黃框/:::reference）**：本專案其他功能性元件，依規則停止展開並提供文件引用。
- **插槽節點（橘框/:::slot）**：外部傳入之 `child`、`builder` 或內容參數。
