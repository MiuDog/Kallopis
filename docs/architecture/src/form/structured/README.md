# lib/src/form/structured：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/form/structured` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/form/structured"]
	n1["lib/src/form/input"]
	n2["lib/src/form/internal"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/form/input</code> | import | 1 | [lib/src/form/structured/klp_code_field.dart:2](../../../../../lib/src/form/structured/klp_code_field.dart#L2) |
| <code>lib/src/form/internal</code> | import | 7 | [lib/src/form/structured/klp_approval_steps_field.dart:1](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/form/structured"]
	n1["klp_approval_steps_field.dart"]
	n2["klp_code_editor_field.dart"]
	n3["klp_code_field.dart"]
	n4["klp_file_dropzone_field.dart"]
	n5["klp_file_field.dart"]
	n6["klp_key_value_editor.dart"]
	n7["klp_repeater_field.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_approval_steps_field.dart` | KlpApprovalStepData, KlpApprovalStepsField | [架構與 API](klp_approval_steps_field.md) | [lib/src/form/structured/klp_approval_steps_field.dart:1](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L1) |
| `klp_code_editor_field.dart` | KlpCodeEditorField | [架構與 API](klp_code_editor_field.md) | [lib/src/form/structured/klp_code_editor_field.dart:1](../../../../../lib/src/form/structured/klp_code_editor_field.dart#L1) |
| `klp_code_field.dart` | KlpCodeField | [架構與 API](klp_code_field.md) | [lib/src/form/structured/klp_code_field.dart:1](../../../../../lib/src/form/structured/klp_code_field.dart#L1) |
| `klp_file_dropzone_field.dart` | KlpFileAttachment, KlpFileDropzoneField | [架構與 API](klp_file_dropzone_field.md) | [lib/src/form/structured/klp_file_dropzone_field.dart:1](../../../../../lib/src/form/structured/klp_file_dropzone_field.dart#L1) |
| `klp_file_field.dart` | KlpFileValue, KlpFileField | [架構與 API](klp_file_field.md) | [lib/src/form/structured/klp_file_field.dart:1](../../../../../lib/src/form/structured/klp_file_field.dart#L1) |
| `klp_key_value_editor.dart` | KlpKeyValueEntry, KlpKeyValueEditor | [架構與 API](klp_key_value_editor.md) | [lib/src/form/structured/klp_key_value_editor.dart:1](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L1) |
| `klp_repeater_field.dart` | KlpRepeaterItem, KlpRepeaterField | [架構與 API](klp_repeater_field.md) | [lib/src/form/structured/klp_repeater_field.dart:1](../../../../../lib/src/form/structured/klp_repeater_field.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
