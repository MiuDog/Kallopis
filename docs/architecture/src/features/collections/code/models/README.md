# lib/src/features/collections/code/models：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/collections/code/models` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/features/collections/code/models"]
	n1["package:flutter"]
	n0 -->|"import"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>package:flutter</code> | import | 1 | [lib/src/features/collections/code/models/klp_code_models.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_code_models.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_code_language_option.dart → klp_code_models.dart</code> | part of | [lib/src/features/collections/code/models/klp_code_language_option.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_code_language_option.dart#L1) |
| <code>klp_code_languages.dart → klp_code_models.dart</code> | part of | [lib/src/features/collections/code/models/klp_code_languages.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_code_languages.dart#L1) |
| <code>klp_code_models.dart → klp_code_language_option.dart</code> | part | [lib/src/features/collections/code/models/klp_code_models.dart:3](../../../../../../../lib/src/features/collections/code/models/klp_code_models.dart#L3) |
| <code>klp_code_models.dart → klp_code_languages.dart</code> | part | [lib/src/features/collections/code/models/klp_code_models.dart:4](../../../../../../../lib/src/features/collections/code/models/klp_code_models.dart#L4) |
| <code>klp_code_models.dart → klp_code_viewer_labels.dart</code> | part | [lib/src/features/collections/code/models/klp_code_models.dart:5](../../../../../../../lib/src/features/collections/code/models/klp_code_models.dart#L5) |
| <code>klp_code_models.dart → klp_diff_line.dart</code> | part | [lib/src/features/collections/code/models/klp_code_models.dart:6](../../../../../../../lib/src/features/collections/code/models/klp_code_models.dart#L6) |
| <code>klp_code_models.dart → klp_diff_line_type.dart</code> | part | [lib/src/features/collections/code/models/klp_code_models.dart:7](../../../../../../../lib/src/features/collections/code/models/klp_code_models.dart#L7) |
| <code>klp_code_viewer_labels.dart → klp_code_models.dart</code> | part of | [lib/src/features/collections/code/models/klp_code_viewer_labels.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_code_viewer_labels.dart#L1) |
| <code>klp_diff_line.dart → klp_code_models.dart</code> | part of | [lib/src/features/collections/code/models/klp_diff_line.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_diff_line.dart#L1) |
| <code>klp_diff_line_type.dart → klp_code_models.dart</code> | part of | [lib/src/features/collections/code/models/klp_diff_line_type.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_diff_line_type.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/collections/code/models"]
	n1["klp_code_language_option.dart"]
	n2["klp_code_languages.dart"]
	n3["klp_code_models.dart"]
	n4["klp_code_viewer_labels.dart"]
	n5["klp_diff_line.dart"]
	n6["klp_diff_line_type.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_code_language_option.dart` | KlpCodeLanguageOption | [架構與 API](klp_code_language_option.md) | [lib/src/features/collections/code/models/klp_code_language_option.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_code_language_option.dart#L1) |
| `klp_code_languages.dart` | KlpCodeLanguages | [架構與 API](klp_code_languages.md) | [lib/src/features/collections/code/models/klp_code_languages.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_code_languages.dart#L1) |
| `klp_code_models.dart` | 無頂層宣告 | [架構與 API](klp_code_models.md) | [lib/src/features/collections/code/models/klp_code_models.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_code_models.dart#L1) |
| `klp_code_viewer_labels.dart` | KlpCodeViewerLabels | [架構與 API](klp_code_viewer_labels.md) | [lib/src/features/collections/code/models/klp_code_viewer_labels.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_code_viewer_labels.dart#L1) |
| `klp_diff_line.dart` | KlpDiffLine | [架構與 API](klp_diff_line.md) | [lib/src/features/collections/code/models/klp_diff_line.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_diff_line.dart#L1) |
| `klp_diff_line_type.dart` | KlpDiffLineType | [架構與 API](klp_diff_line_type.md) | [lib/src/features/collections/code/models/klp_diff_line_type.dart:1](../../../../../../../lib/src/features/collections/code/models/klp_diff_line_type.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
