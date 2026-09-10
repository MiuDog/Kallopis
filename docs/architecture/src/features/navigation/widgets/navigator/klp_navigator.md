# klp_navigator.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/navigator/klp_navigator.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_navigator.dart"]
	n1["package:flutter/material.dart"]
	n2["../../../../foundation/klp_icon.dart"]
	n3["../../../../foundation/klp_icons.dart"]
	n4["../../../../foundation/interaction/klp_gesture_region.dart"]
	n5["../../../../foundation/interaction/klp_pressable.dart"]
	n6["../../../../foundation/interaction/klp_state_highlight.dart"]
	n7["../../../../foundation/layout/klp_layout.dart"]
	n8["../../../../foundation/surface/klp_surface.dart"]
	n9["../../../../styling/legacy_theme/klp_theme.dart"]
	n10["../../../../foundation/content/klp_text.dart"]
	n11["klp_navigator_models.dart"]
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
	n0["klp_navigator.dart"]
	n1["internal/klp_navigator_category_view.dart"]
	n2["internal/klp_navigator_element_row.dart"]
	n3["internal/klp_navigator_element_view.dart"]
	n4["internal/klp_navigator_element_view_state.dart"]
	n5["internal/klp_navigator_item_view.dart"]
	n6["internal/klp_navigator_scope.dart"]
	n7["internal/klp_navigator_state.dart"]
	n8["internal/klp_navigator_widget.dart"]
	n9["primitives/klp_navigator_disclosure.dart"]
	n10["primitives/klp_navigator_interactive_row.dart"]
	n11["primitives/klp_navigator_list_viewport.dart"]
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

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:1](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L1) |
| import | <code>import &#x27;../../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:3](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L3) |
| import | <code>import &#x27;../../../../foundation/klp_icons.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:4](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L4) |
| import | <code>import &#x27;../../../../foundation/interaction/klp_gesture_region.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:5](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L5) |
| import | <code>import &#x27;../../../../foundation/interaction/klp_pressable.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:6](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L6) |
| import | <code>import &#x27;../../../../foundation/interaction/klp_state_highlight.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:7](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L7) |
| import | <code>import &#x27;../../../../foundation/layout/klp_layout.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:8](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L8) |
| import | <code>import &#x27;../../../../foundation/surface/klp_surface.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:9](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L9) |
| import | <code>import &#x27;../../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:10](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L10) |
| import | <code>import &#x27;../../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:11](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L11) |
| import | <code>import &#x27;klp_navigator_models.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:12](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L12) |
| part | <code>part &#x27;internal/klp_navigator_category_view.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:14](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L14) |
| part | <code>part &#x27;internal/klp_navigator_element_row.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:15](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L15) |
| part | <code>part &#x27;internal/klp_navigator_element_view.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:16](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L16) |
| part | <code>part &#x27;internal/klp_navigator_element_view_state.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:17](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L17) |
| part | <code>part &#x27;internal/klp_navigator_item_view.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:18](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L18) |
| part | <code>part &#x27;internal/klp_navigator_scope.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:19](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L19) |
| part | <code>part &#x27;internal/klp_navigator_state.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:20](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L20) |
| part | <code>part &#x27;internal/klp_navigator_widget.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:21](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L21) |
| part | <code>part &#x27;primitives/klp_navigator_disclosure.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:22](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L22) |
| part | <code>part &#x27;primitives/klp_navigator_interactive_row.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:23](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L23) |
| part | <code>part &#x27;primitives/klp_navigator_list_viewport.dart&#x27;;</code> | [lib/src/features/navigation/widgets/navigator/klp_navigator.dart:24](../../../../../../../lib/src/features/navigation/widgets/navigator/klp_navigator.dart#L24) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
