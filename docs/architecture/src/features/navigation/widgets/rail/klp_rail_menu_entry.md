# klp_rail_menu_entry.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_rail_menu_entry.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../../foundation/klp_icon.dart"]
	n3["../../../overlays/klp_context_menu.dart"]
	n4["../../../overlays/klp_menu.dart"]
	n5["klp_rail_entry.dart"]
	n6["klp_rail_item.dart"]
	n7["internal/klp_rail_menu_entry_view.dart"]
	n8["internal/klp_rail_menu_entry_view_state.dart"]
	n9["models/klp_rail_menu_entry_model.dart"]
	n10["primitives/klp_rail_pointer_tracker.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
	n0 -->|"part"| n10
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L1) |
| import | <code>import &#x27;../../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:3](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L3) |
| import | <code>import &#x27;../../../overlays/klp_context_menu.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:4](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L4) |
| import | <code>import &#x27;../../../overlays/klp_menu.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:5](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L5) |
| import | <code>import &#x27;klp_rail_entry.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:6](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L6) |
| import | <code>import &#x27;klp_rail_item.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:7](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L7) |
| part | <code>part &#x27;internal/klp_rail_menu_entry_view.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:9](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L9) |
| part | <code>part &#x27;internal/klp_rail_menu_entry_view_state.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:10](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L10) |
| part | <code>part &#x27;models/klp_rail_menu_entry_model.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:11](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L11) |
| part | <code>part &#x27;primitives/klp_rail_pointer_tracker.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:12](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L12) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
