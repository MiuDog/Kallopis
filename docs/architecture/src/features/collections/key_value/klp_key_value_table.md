# klp_key_value_table.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart)

## 範圍

核心是 `lib/src/features/collections/key_value/klp_key_value_table.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_key_value_table.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../foundation/klp_icon.dart"]
	n3["../../../foundation/klp_icons.dart"]
	n4["../../../foundation/interaction/klp_gesture_region.dart"]
	n5["../../../foundation/layout/klp_box.dart"]
	n6["../../../foundation/layout/klp_column.dart"]
	n7["../../../foundation/layout/klp_expanded.dart"]
	n8["../../../foundation/layout/klp_gap.dart"]
	n9["../../../foundation/layout/klp_row.dart"]
	n10["../../../foundation/layout/klp_space_size.dart"]
	n11["../../../foundation/surface/klp_surface.dart"]
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
	n0["klp_key_value_table.dart"]
	n1["../../../styling/legacy_theme/klp_theme.dart"]
	n2["../../../foundation/content/klp_text.dart"]
	n3["internal/klp_key_value_list_row.dart"]
	n4["internal/klp_key_value_list_widget.dart"]
	n5["internal/klp_key_value_table_row.dart"]
	n6["internal/klp_key_value_table_widget.dart"]
	n7["models/klp_key_value_item.dart"]
	n8["models/klp_key_value_label_width.dart"]
	n9["models/klp_key_value_row_data.dart"]
	n10["primitives/klp_key_value_label_slot.dart"]
	n11["primitives/klp_key_value_row_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"part"| n3
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
	n0["klp_key_value_table.dart"]
	n1["primitives/klp_key_value_table_frame.dart"]
	n2["primitives/klp_key_value_value_style.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:1](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L1) |
| import | <code>import &#x27;../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:3](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L3) |
| import | <code>import &#x27;../../../foundation/klp_icons.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:4](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L4) |
| import | <code>import &#x27;../../../foundation/interaction/klp_gesture_region.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:5](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L5) |
| import | <code>import &#x27;../../../foundation/layout/klp_box.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:6](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L6) |
| import | <code>import &#x27;../../../foundation/layout/klp_column.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:7](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L7) |
| import | <code>import &#x27;../../../foundation/layout/klp_expanded.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:8](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L8) |
| import | <code>import &#x27;../../../foundation/layout/klp_gap.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:9](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L9) |
| import | <code>import &#x27;../../../foundation/layout/klp_row.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:10](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L10) |
| import | <code>import &#x27;../../../foundation/layout/klp_space_size.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:11](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L11) |
| import | <code>import &#x27;../../../foundation/surface/klp_surface.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:12](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L12) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:13](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L13) |
| import | <code>import &#x27;../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:14](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L14) |
| part | <code>part &#x27;internal/klp_key_value_list_row.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:16](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L16) |
| part | <code>part &#x27;internal/klp_key_value_list_widget.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:17](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L17) |
| part | <code>part &#x27;internal/klp_key_value_table_row.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:18](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L18) |
| part | <code>part &#x27;internal/klp_key_value_table_widget.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:19](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L19) |
| part | <code>part &#x27;models/klp_key_value_item.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:20](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L20) |
| part | <code>part &#x27;models/klp_key_value_label_width.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:21](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L21) |
| part | <code>part &#x27;models/klp_key_value_row_data.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:22](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L22) |
| part | <code>part &#x27;primitives/klp_key_value_label_slot.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:23](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L23) |
| part | <code>part &#x27;primitives/klp_key_value_row_frame.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:24](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L24) |
| part | <code>part &#x27;primitives/klp_key_value_table_frame.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:25](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L25) |
| part | <code>part &#x27;primitives/klp_key_value_value_style.dart&#x27;;</code> | [lib/src/features/collections/key_value/klp_key_value_table.dart:26](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L26) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
