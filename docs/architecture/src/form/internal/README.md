# lib/src/form/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/form/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/form/internal"]
	n1["lib/src/controls/button"]
	n2["lib/src/controls/input"]
	n3["lib/src/data/advanced"]
	n4["lib/src/data/badge"]
	n5["lib/src/data/code"]
	n6["lib/src/foundation"]
	n7["lib/src/interaction"]
	n8["lib/src/l10n"]
	n9["lib/src/surface"]
	n10["lib/src/theme"]
	n11["lib/src/typography"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"export"| n3
	n0 -->|"export"| n4
	n0 -->|"export"| n5
	n0 -->|"export"| n6
	n0 -->|"export"| n7
	n0 -->|"export"| n8
	n0 -->|"export"| n9
	n0 -->|"export"| n10
	n0 -->|"export"| n11
```

```mermaid
flowchart TD
	n0["lib/src/form/internal"]
	n1["package:flutter"]
	n0 -->|"export"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/controls/button</code> | export | 2 | [lib/src/form/internal/klp_form_dependencies.dart:3](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L3) |
| <code>lib/src/controls/input</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:5](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L5) |
| <code>lib/src/data/advanced</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:6](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L6) |
| <code>lib/src/data/badge</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:7](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L7) |
| <code>lib/src/data/code</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:8](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L8) |
| <code>lib/src/foundation</code> | export | 2 | [lib/src/form/internal/klp_form_dependencies.dart:9](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L9) |
| <code>lib/src/interaction</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:11](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L11) |
| <code>lib/src/l10n</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:12](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L12) |
| <code>lib/src/surface</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:13](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L13) |
| <code>lib/src/theme</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:14](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L14) |
| <code>lib/src/typography</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:15](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L15) |
| <code>package:flutter</code> | export | 1 | [lib/src/form/internal/klp_form_dependencies.dart:1](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_input_action.dart → klp_form_dependencies.dart</code> | import | [lib/src/form/internal/klp_input_action.dart:1](../../../../../lib/src/form/internal/klp_input_action.dart#L1) |
| <code>klp_input_editor.dart → klp_form_dependencies.dart</code> | import | [lib/src/form/internal/klp_input_editor.dart:1](../../../../../lib/src/form/internal/klp_input_editor.dart#L1) |
| <code>klp_input_frame.dart → klp_form_dependencies.dart</code> | import | [lib/src/form/internal/klp_input_frame.dart:1](../../../../../lib/src/form/internal/klp_input_frame.dart#L1) |
| <code>klp_input_segment_divider.dart → klp_form_dependencies.dart</code> | import | [lib/src/form/internal/klp_input_segment_divider.dart:1](../../../../../lib/src/form/internal/klp_input_segment_divider.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/form/internal"]
	n1["klp_form_dependencies.dart"]
	n2["klp_input_action.dart"]
	n3["klp_input_editor.dart"]
	n4["klp_input_frame.dart"]
	n5["klp_input_segment_divider.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_form_dependencies.dart` | 無頂層宣告 | [架構與 API](klp_form_dependencies.md) | [lib/src/form/internal/klp_form_dependencies.dart:1](../../../../../lib/src/form/internal/klp_form_dependencies.dart#L1) |
| `klp_input_action.dart` | KlpInputAction | [架構與 API](klp_input_action.md) | [lib/src/form/internal/klp_input_action.dart:1](../../../../../lib/src/form/internal/klp_input_action.dart#L1) |
| `klp_input_editor.dart` | KlpInputEditor | [架構與 API](klp_input_editor.md) | [lib/src/form/internal/klp_input_editor.dart:1](../../../../../lib/src/form/internal/klp_input_editor.dart#L1) |
| `klp_input_frame.dart` | KlpInputFrame, _KlpInputFrameState | [架構與 API](klp_input_frame.md) | [lib/src/form/internal/klp_input_frame.dart:1](../../../../../lib/src/form/internal/klp_input_frame.dart#L1) |
| `klp_input_segment_divider.dart` | KlpInputSegmentDivider | [架構與 API](klp_input_segment_divider.md) | [lib/src/form/internal/klp_input_segment_divider.dart:1](../../../../../lib/src/form/internal/klp_input_segment_divider.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
