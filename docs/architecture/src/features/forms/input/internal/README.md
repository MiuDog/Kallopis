# lib/src/features/forms/input/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/forms/input/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/features/forms/input/internal"]
	n1["lib/src/features/forms/input"]
	n0 -->|"part of"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/forms/input</code> | part of | 12 | [lib/src/features/forms/input/internal/klp_combobox_option.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_combobox_option.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/forms/input/internal"]
	n1["klp_combobox_option.dart"]
	n2["klp_combobox_state.dart"]
	n3["klp_combobox_widget.dart"]
	n4["klp_compound_field_option.dart"]
	n5["klp_compound_field_state.dart"]
	n6["klp_compound_field_widget.dart"]
	n7["klp_password_field_state.dart"]
	n8["klp_password_field_widget.dart"]
	n9["klp_text_field_state.dart"]
	n10["klp_text_field_style.dart"]
	n11["klp_text_field_suffix.dart"]
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
	n0["lib/src/features/forms/input/internal"]
	n1["klp_text_field_widget.dart"]
	n0 -->|"contains"| n1
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_combobox_option.dart` | KlpComboboxOption | [架構與 API](klp_combobox_option.md) | [lib/src/features/forms/input/internal/klp_combobox_option.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_combobox_option.dart#L1) |
| `klp_combobox_state.dart` | _KlpComboboxState | [架構與 API](klp_combobox_state.md) | [lib/src/features/forms/input/internal/klp_combobox_state.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_combobox_state.dart#L1) |
| `klp_combobox_widget.dart` | KlpCombobox | [架構與 API](klp_combobox_widget.md) | [lib/src/features/forms/input/internal/klp_combobox_widget.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_combobox_widget.dart#L1) |
| `klp_compound_field_option.dart` | _KlpCompoundFieldOption | [架構與 API](klp_compound_field_option.md) | [lib/src/features/forms/input/internal/klp_compound_field_option.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_compound_field_option.dart#L1) |
| `klp_compound_field_state.dart` | _KlpCompoundFieldState | [架構與 API](klp_compound_field_state.md) | [lib/src/features/forms/input/internal/klp_compound_field_state.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_compound_field_state.dart#L1) |
| `klp_compound_field_widget.dart` | KlpCompoundField | [架構與 API](klp_compound_field_widget.md) | [lib/src/features/forms/input/internal/klp_compound_field_widget.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_compound_field_widget.dart#L1) |
| `klp_password_field_state.dart` | _KlpPasswordFieldState | [架構與 API](klp_password_field_state.md) | [lib/src/features/forms/input/internal/klp_password_field_state.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_password_field_state.dart#L1) |
| `klp_password_field_widget.dart` | KlpPasswordField | [架構與 API](klp_password_field_widget.md) | [lib/src/features/forms/input/internal/klp_password_field_widget.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_password_field_widget.dart#L1) |
| `klp_text_field_state.dart` | _KlpTextFieldState | [架構與 API](klp_text_field_state.md) | [lib/src/features/forms/input/internal/klp_text_field_state.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_state.dart#L1) |
| `klp_text_field_style.dart` | _KlpTextFieldStyle | [架構與 API](klp_text_field_style.md) | [lib/src/features/forms/input/internal/klp_text_field_style.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L1) |
| `klp_text_field_suffix.dart` | _KlpTextFieldSuffix | [架構與 API](klp_text_field_suffix.md) | [lib/src/features/forms/input/internal/klp_text_field_suffix.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_suffix.dart#L1) |
| `klp_text_field_widget.dart` | KlpTextField | [架構與 API](klp_text_field_widget.md) | [lib/src/features/forms/input/internal/klp_text_field_widget.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_widget.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
