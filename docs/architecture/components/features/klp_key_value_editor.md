# KlpKeyValueEditor：元件樹架構

## 範圍

- **核心元件**：`KlpKeyValueEditor`
- **所屬領域**：`features`
- **核心職責**：任意鍵值對清單的編輯器（例如 HTTP header、環境變數），每列一個 key 輸入 框與一個 value 輸入框。  不提供新增／刪除列的按鈕——這個元件只負責編輯既有 [entries] 的內容， 增減列數請自行在 [entries] 外包一層（可參考 [KlpRepeaterField] 的模式）。
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

  root["KlpKeyValueEditor"]:::root
  n1["KlpColumn"]:::reference
  root --> n1
  n2["KlpText"]:::reference
  root --> n2
  n3["KlpRow"]:::reference
  root --> n3
  n4["KlpExpanded"]:::reference
  root --> n4
  n5["KlpTextField"]:::reference
  root --> n5
  n6["child / slot"]:::slot
  root --> n6
```

## 外部元件引用

- [`KlpColumn`](../foundation/klp_column.md) — `foundation — 圖示、色盤、度量`
- [`KlpExpanded`](../foundation/klp_expanded.md) — `foundation — 圖示、色盤、度量`
- [`KlpRow`](../foundation/klp_row.md) — `foundation — 圖示、色盤、度量`
- [`KlpText`](../foundation/klp_text.md) — `foundation — 圖示、色盤、度量`
- [`KlpTextField`](./klp_text_field.md) — `features`

## 程式碼證據

- 檔案路徑：[`lib/src/features/forms/structured/internal/klp_key_value_editor_widget.dart`](../../../../lib/src/features/forms/structured/internal/klp_key_value_editor_widget.dart#L8)
- 宣告型態：`StatelessWidget`

## 閱讀說明

- **實線節點**：Flutter 原生元件或本元件自身節點。
- **容器節點（圓角/綠框）**：本專案之純容器元件（如 `KlpSurface` 等），已持續向下展開其子樹。
- **虛線/引號節點（黃框/:::reference）**：本專案其他功能性元件，依規則停止展開並提供文件引用。
- **插槽節點（橘框/:::slot）**：外部傳入之 `child`、`builder` 或內容參數。
