# klp_file_explorer.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_file_explorer.dart"]
	n1["package:flutter/material.dart"]
	n2["../../../feedback/klp_feedback_tone.dart"]
	n3["../../../../foundation/klp_icon.dart"]
	n4["../../../../foundation/klp_icons.dart"]
	n5["../../../../foundation/interaction/klp_pressable.dart"]
	n6["../../../../foundation/interaction/klp_gesture_region.dart"]
	n7["../../../../foundation/interaction/klp_state_highlight.dart"]
	n8["../../../../foundation/layout/klp_layout.dart"]
	n9["../../../../styling/legacy_theme/klp_theme.dart"]
	n10["../../../../foundation/content/klp_text.dart"]
	n11["internal/klp_file_explorer_disclosure_size.dart"]
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
	n0 -->|"part"| n11
```

```mermaid
flowchart LR
	n0["klp_file_explorer.dart"]
	n1["internal/klp_file_explorer_folder_view.dart"]
	n2["internal/klp_file_explorer_folder_view_state.dart"]
	n3["internal/klp_file_explorer_item_view.dart"]
	n4["internal/klp_file_explorer_item_view_state.dart"]
	n5["internal/klp_file_explorer_node_view.dart"]
	n6["internal/klp_file_explorer_row_areas.dart"]
	n7["internal/klp_file_explorer_section_view.dart"]
	n8["internal/klp_file_explorer_state.dart"]
	n9["internal/klp_file_explorer_widget.dart"]
	n10["models/klp_file_explorer_item.dart"]
	n11["models/klp_file_explorer_section.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
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
flowchart LR
	n0["klp_file_explorer.dart"]
	n1["models/klp_file_explorer_spacing.dart"]
	n2["primitives/klp_file_explorer_disclosure.dart"]
	n3["primitives/klp_file_explorer_interactive_row.dart"]
	n4["primitives/klp_file_explorer_list_viewport.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:1](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L1) |
| import | <code>import &#x27;../../../feedback/klp_feedback_tone.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:3](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L3) |
| import | <code>import &#x27;../../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:4](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L4) |
| import | <code>import &#x27;../../../../foundation/klp_icons.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:5](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L5) |
| import | <code>import &#x27;../../../../foundation/interaction/klp_pressable.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:6](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L6) |
| import | <code>import &#x27;../../../../foundation/interaction/klp_gesture_region.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:7](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L7) |
| import | <code>import &#x27;../../../../foundation/interaction/klp_state_highlight.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:8](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L8) |
| import | <code>import &#x27;../../../../foundation/layout/klp_layout.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:9](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L9) |
| import | <code>import &#x27;../../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:10](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L10) |
| import | <code>import &#x27;../../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:11](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L11) |
| part | <code>part &#x27;internal/klp_file_explorer_disclosure_size.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:13](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L13) |
| part | <code>part &#x27;internal/klp_file_explorer_folder_view.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:14](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L14) |
| part | <code>part &#x27;internal/klp_file_explorer_folder_view_state.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:15](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L15) |
| part | <code>part &#x27;internal/klp_file_explorer_item_view.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:16](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L16) |
| part | <code>part &#x27;internal/klp_file_explorer_item_view_state.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:17](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L17) |
| part | <code>part &#x27;internal/klp_file_explorer_node_view.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:18](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L18) |
| part | <code>part &#x27;internal/klp_file_explorer_row_areas.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:19](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L19) |
| part | <code>part &#x27;internal/klp_file_explorer_section_view.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:20](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L20) |
| part | <code>part &#x27;internal/klp_file_explorer_state.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:21](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L21) |
| part | <code>part &#x27;internal/klp_file_explorer_widget.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:22](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L22) |
| part | <code>part &#x27;models/klp_file_explorer_item.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:23](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L23) |
| part | <code>part &#x27;models/klp_file_explorer_section.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:24](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L24) |
| part | <code>part &#x27;models/klp_file_explorer_spacing.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:25](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L25) |
| part | <code>part &#x27;primitives/klp_file_explorer_disclosure.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:26](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L26) |
| part | <code>part &#x27;primitives/klp_file_explorer_interactive_row.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:27](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L27) |
| part | <code>part &#x27;primitives/klp_file_explorer_list_viewport.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart:28](../../../../../../../lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart#L28) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
