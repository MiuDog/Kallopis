# lib/src/form：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/form` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 模組閱讀重點

## 分析入口

根目錄多個檔案是相容匯出入口；`klp_form.dart` 將實作交給 `core/`。巢狀目錄分別持有 core 欄位框架、input 輸入元件、selection 選擇元件、structured 結構化欄位與 picker 參照選擇器；`internal/` 為共用內部支援。`KlpForm` 只排列外部提供的 sections、錯誤總覽與動作列，不管理資料或驗證。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 公開表單入口如何指向真正實作？ | export directives：lib/src/form/klp_form.dart:1；`KlpForm`：lib/src/form/core/klp_form.dart:9 |
| 標籤與欄位容器從哪裡讀？ | `KlpField`：lib/src/form/core/klp_field.dart:14 |
| 一般輸入與重複結構在哪裡分開？ | `KlpNumberField`：lib/src/form/input/klp_number_field.dart:9；`KlpRepeaterField`：lib/src/form/structured/klp_repeater_field.dart:19 |

重要依賴：`core/klp_form.dart:1` 匯入 `internal/klp_form_dependencies.dart`；:26–38 的建構內容讀取 `context.klp.space` 並插入呼叫端的 widgets。barrel export 是可達性關係，與上述 build 組合應分開畫。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/form"]
	n1["lib/src/form/core"]
	n2["lib/src/form/input"]
	n3["lib/src/form/picker"]
	n4["lib/src/form/selection"]
	n5["lib/src/form/structured"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"export"| n3
	n0 -->|"export"| n4
	n0 -->|"export"| n5
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/form/core</code> | export | 11 | [lib/src/form/klp_form.dart:1](../../../../lib/src/form/klp_form.dart#L1) |
| <code>lib/src/form/input</code> | export | 6 | [lib/src/form/klp_form_controls.dart:1](../../../../lib/src/form/klp_form_controls.dart#L1) |
| <code>lib/src/form/picker</code> | export | 1 | [lib/src/form/klp_reference_picker.dart:1](../../../../lib/src/form/klp_reference_picker.dart#L1) |
| <code>lib/src/form/selection</code> | export | 10 | [lib/src/form/klp_calendar.dart:1](../../../../lib/src/form/klp_calendar.dart#L1) |
| <code>lib/src/form/structured</code> | export | 7 | [lib/src/form/klp_structured_fields.dart:2](../../../../lib/src/form/klp_structured_fields.dart#L2) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/form"]
	n1["core/"]
	n2["input/"]
	n3["internal/"]
	n4["picker/"]
	n5["selection/"]
	n6["structured/"]
	n7["klp_calendar.dart"]
	n8["klp_form.dart"]
	n9["klp_form_controls.dart"]
	n10["klp_input_recipes.dart"]
	n11["klp_reference_picker.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
	n0 -->|"contains"| n9
	n0 -->|"contains"| n10
	n0 -->|"contains"| n11
```

```mermaid
flowchart TD
	n0["lib/src/form"]
	n1["klp_structured_fields.dart"]
	n0 -->|"contains"| n1
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `core/` | [架構入口](core/README.md) | [來源目錄](../../../../lib/src/form/core) |
| `input/` | [架構入口](input/README.md) | [來源目錄](../../../../lib/src/form/input) |
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../lib/src/form/internal) |
| `picker/` | [架構入口](picker/README.md) | [來源目錄](../../../../lib/src/form/picker) |
| `selection/` | [架構入口](selection/README.md) | [來源目錄](../../../../lib/src/form/selection) |
| `structured/` | [架構入口](structured/README.md) | [來源目錄](../../../../lib/src/form/structured) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_calendar.dart` | 無頂層宣告 | [架構與 API](klp_calendar.md) | [lib/src/form/klp_calendar.dart:1](../../../../lib/src/form/klp_calendar.dart#L1) |
| `klp_form.dart` | 無頂層宣告 | [架構與 API](klp_form.md) | [lib/src/form/klp_form.dart:1](../../../../lib/src/form/klp_form.dart#L1) |
| `klp_form_controls.dart` | 無頂層宣告 | [架構與 API](klp_form_controls.md) | [lib/src/form/klp_form_controls.dart:1](../../../../lib/src/form/klp_form_controls.dart#L1) |
| `klp_input_recipes.dart` | 無頂層宣告 | [架構與 API](klp_input_recipes.md) | [lib/src/form/klp_input_recipes.dart:1](../../../../lib/src/form/klp_input_recipes.dart#L1) |
| `klp_reference_picker.dart` | 無頂層宣告 | [架構與 API](klp_reference_picker.md) | [lib/src/form/klp_reference_picker.dart:1](../../../../lib/src/form/klp_reference_picker.dart#L1) |
| `klp_structured_fields.dart` | 無頂層宣告 | [架構與 API](klp_structured_fields.md) | [lib/src/form/klp_structured_fields.dart:1](../../../../lib/src/form/klp_structured_fields.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
