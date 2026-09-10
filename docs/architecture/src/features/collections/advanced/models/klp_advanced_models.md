# klp_advanced_models.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart)

## 範圍

核心是 `lib/src/features/collections/advanced/models/klp_advanced_models.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_advanced_models.dart"]
	n1["package:flutter/foundation.dart"]
	n2["../../../feedback/klp_feedback_tone.dart"]
	n3["../../../../foundation/klp_icon.dart"]
	n4["klp_data_alignment.dart"]
	n5["klp_data_column.dart"]
	n6["klp_data_column_span.dart"]
	n7["klp_data_row.dart"]
	n8["klp_data_sort.dart"]
	n9["klp_file_preview_size.dart"]
	n10["klp_file_preview_state.dart"]
	n11["klp_sort_direction.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
	n0 -->|"part"| n10
	n0 -->|"part"| n11
```

```mermaid
flowchart TD
	n0["klp_advanced_models.dart"]
	n1["klp_tree_node.dart"]
	n0 -->|"part"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/foundation.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L1) |
| import | <code>import &#x27;../../../feedback/klp_feedback_tone.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:3](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L3) |
| import | <code>import &#x27;../../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:4](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L4) |
| part | <code>part &#x27;klp_data_alignment.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:6](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L6) |
| part | <code>part &#x27;klp_data_column.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:7](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L7) |
| part | <code>part &#x27;klp_data_column_span.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:8](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L8) |
| part | <code>part &#x27;klp_data_row.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:9](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L9) |
| part | <code>part &#x27;klp_data_sort.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:10](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L10) |
| part | <code>part &#x27;klp_file_preview_size.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:11](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L11) |
| part | <code>part &#x27;klp_file_preview_state.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:12](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L12) |
| part | <code>part &#x27;klp_sort_direction.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:13](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L13) |
| part | <code>part &#x27;klp_tree_node.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:14](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L14) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
