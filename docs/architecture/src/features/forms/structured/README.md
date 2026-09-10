# lib/src/features/forms/structured：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/forms/structured` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/forms/structured"]
	n1["lib/src/features/forms/input"]
	n2["lib/src/features/forms/internal"]
	n3["lib/src/features/forms/structured/internal"]
	n4["lib/src/features/forms/structured/primitives"]
	n5["lib/src/features/forms/structured/primitives/internal"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
	n0 -->|"import"| n5
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/forms/input</code> | import | 1 | [lib/src/features/forms/structured/klp_code_field.dart:1](../../../../../../lib/src/features/forms/structured/klp_code_field.dart#L1) |
| <code>lib/src/features/forms/internal</code> | import | 7 | [lib/src/features/forms/structured/klp_approval_steps_field.dart:1](../../../../../../lib/src/features/forms/structured/klp_approval_steps_field.dart#L1) |
| <code>lib/src/features/forms/structured/internal</code> | part | 12 | [lib/src/features/forms/structured/klp_approval_steps_field.dart:4](../../../../../../lib/src/features/forms/structured/klp_approval_steps_field.dart#L4) |
| <code>lib/src/features/forms/structured/primitives</code> | part | 1 | [lib/src/features/forms/structured/klp_file_dropzone_field.dart:6](../../../../../../lib/src/features/forms/structured/klp_file_dropzone_field.dart#L6) |
| <code>lib/src/features/forms/structured/primitives/internal</code> | import | 3 | [lib/src/features/forms/structured/klp_approval_steps_field.dart:2](../../../../../../lib/src/features/forms/structured/klp_approval_steps_field.dart#L2) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/forms/structured"]
	n1["internal/"]
	n2["primitives/"]
	n3["klp_approval_steps_field.dart"]
	n4["klp_code_editor_field.dart"]
	n5["klp_code_field.dart"]
	n6["klp_file_dropzone_field.dart"]
	n7["klp_file_field.dart"]
	n8["klp_key_value_editor.dart"]
	n9["klp_repeater_field.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
	n0 -->|"contains"| n9
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../lib/src/features/forms/structured/internal) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../lib/src/features/forms/structured/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_approval_steps_field.dart` | 無頂層宣告 | [架構與 API](klp_approval_steps_field.md) | [lib/src/features/forms/structured/klp_approval_steps_field.dart:1](../../../../../../lib/src/features/forms/structured/klp_approval_steps_field.dart#L1) |
| `klp_code_editor_field.dart` | 無頂層宣告 | [架構與 API](klp_code_editor_field.md) | [lib/src/features/forms/structured/klp_code_editor_field.dart:1](../../../../../../lib/src/features/forms/structured/klp_code_editor_field.dart#L1) |
| `klp_code_field.dart` | 無頂層宣告 | [架構與 API](klp_code_field.md) | [lib/src/features/forms/structured/klp_code_field.dart:1](../../../../../../lib/src/features/forms/structured/klp_code_field.dart#L1) |
| `klp_file_dropzone_field.dart` | 無頂層宣告 | [架構與 API](klp_file_dropzone_field.md) | [lib/src/features/forms/structured/klp_file_dropzone_field.dart:1](../../../../../../lib/src/features/forms/structured/klp_file_dropzone_field.dart#L1) |
| `klp_file_field.dart` | 無頂層宣告 | [架構與 API](klp_file_field.md) | [lib/src/features/forms/structured/klp_file_field.dart:1](../../../../../../lib/src/features/forms/structured/klp_file_field.dart#L1) |
| `klp_key_value_editor.dart` | 無頂層宣告 | [架構與 API](klp_key_value_editor.md) | [lib/src/features/forms/structured/klp_key_value_editor.dart:1](../../../../../../lib/src/features/forms/structured/klp_key_value_editor.dart#L1) |
| `klp_repeater_field.dart` | 無頂層宣告 | [架構與 API](klp_repeater_field.md) | [lib/src/features/forms/structured/klp_repeater_field.dart:1](../../../../../../lib/src/features/forms/structured/klp_repeater_field.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
