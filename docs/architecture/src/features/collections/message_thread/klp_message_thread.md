# klp_message_thread.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart)

## 範圍

核心是 `lib/src/features/collections/message_thread/klp_message_thread.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_message_thread.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../actions/button/klp_button.dart"]
	n3["../../../foundation/layout/klp_align.dart"]
	n4["../../../foundation/layout/klp_box.dart"]
	n5["../../../foundation/layout/klp_box_insets.dart"]
	n6["../../../foundation/layout/klp_column.dart"]
	n7["../../../foundation/layout/klp_gap.dart"]
	n8["../../../foundation/layout/klp_row.dart"]
	n9["../../../foundation/layout/klp_space_size.dart"]
	n10["../../../foundation/surface/klp_surface.dart"]
	n11["../../../styling/legacy_theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["klp_message_thread.dart"]
	n1["../../../foundation/content/klp_text.dart"]
	n2["klp_message_alignment.dart"]
	n3["klp_message_alignment.dart"]
	n4["internal/klp_message_bubble_widget.dart"]
	n5["internal/klp_message_thread_widget.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"export"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:1](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L1) |
| import | <code>import &#x27;../../actions/button/klp_button.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:3](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L3) |
| import | <code>import &#x27;../../../foundation/layout/klp_align.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:4](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L4) |
| import | <code>import &#x27;../../../foundation/layout/klp_box.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:5](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L5) |
| import | <code>import &#x27;../../../foundation/layout/klp_box_insets.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:6](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L6) |
| import | <code>import &#x27;../../../foundation/layout/klp_column.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:7](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L7) |
| import | <code>import &#x27;../../../foundation/layout/klp_gap.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:8](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L8) |
| import | <code>import &#x27;../../../foundation/layout/klp_row.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:9](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L9) |
| import | <code>import &#x27;../../../foundation/layout/klp_space_size.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:10](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L10) |
| import | <code>import &#x27;../../../foundation/surface/klp_surface.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:11](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L11) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:12](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L12) |
| import | <code>import &#x27;../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:13](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L13) |
| import | <code>import &#x27;klp_message_alignment.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:14](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L14) |
| export | <code>export &#x27;klp_message_alignment.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:16](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L16) |
| part | <code>part &#x27;internal/klp_message_bubble_widget.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:18](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L18) |
| part | <code>part &#x27;internal/klp_message_thread_widget.dart&#x27;;</code> | [lib/src/features/collections/message_thread/klp_message_thread.dart:19](../../../../../../lib/src/features/collections/message_thread/klp_message_thread.dart#L19) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
