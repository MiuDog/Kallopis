# klp_form_dependencies.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart)

## 範圍

核心是 `lib/src/features/forms/internal/klp_form_dependencies.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_form_dependencies.dart"]
	n1["package:flutter/material.dart"]
	n2["../../actions/button/klp_button.dart"]
	n3["../../actions/button/klp_icon_button.dart"]
	n4["../input/klp_text_field.dart"]
	n5["../../collections/advanced/klp_advanced_data.dart"]
	n6["../../collections/badge/klp_badge.dart"]
	n7["../../collections/code/klp_code_viewer.dart"]
	n8["../../../foundation/klp_icon.dart"]
	n9["../../../foundation/klp_icons.dart"]
	n10["../../feedback/klp_live_region.dart"]
	n11["../../../foundation/interaction/klp_gesture_region.dart"]
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
flowchart LR
	n0["klp_form_dependencies.dart"]
	n1["../../../foundation/interaction/klp_state_highlight.dart"]
	n2["../../../foundation/layout/klp_align.dart"]
	n3["../../../foundation/layout/klp_box.dart"]
	n4["../../../foundation/layout/klp_box_insets.dart"]
	n5["../../../foundation/layout/klp_column.dart"]
	n6["../../../foundation/layout/klp_constrained_box.dart"]
	n7["../../../foundation/layout/klp_box_constraints.dart"]
	n8["../../../foundation/layout/klp_expanded.dart"]
	n9["../../../foundation/layout/klp_gap.dart"]
	n10["../../../foundation/layout/klp_row.dart"]
	n11["../../../foundation/layout/klp_space_size.dart"]
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
flowchart LR
	n0["klp_form_dependencies.dart"]
	n1["../../../foundation/layout/klp_spacer.dart"]
	n2["../../../foundation/layout/klp_wrap.dart"]
	n3["../../../application/localization/klp_localizations.dart"]
	n4["../../../foundation/surface/klp_surface.dart"]
	n5["../../../styling/legacy_theme/klp_theme.dart"]
	n6["../../../foundation/content/klp_text.dart"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"export"| n3
	n0 -->|"export"| n4
	n0 -->|"export"| n5
	n0 -->|"export"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| export | <code>export &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:1](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L1) |
| export | <code>export &#x27;../../actions/button/klp_button.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:3](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L3) |
| export | <code>export &#x27;../../actions/button/klp_icon_button.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:4](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L4) |
| export | <code>export &#x27;../input/klp_text_field.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:5](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L5) |
| export | <code>export &#x27;../../collections/advanced/klp_advanced_data.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:6](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L6) |
| export | <code>export &#x27;../../collections/badge/klp_badge.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:7](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L7) |
| export | <code>export &#x27;../../collections/code/klp_code_viewer.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:8](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L8) |
| export | <code>export &#x27;../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:9](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L9) |
| export | <code>export &#x27;../../../foundation/klp_icons.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:10](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L10) |
| export | <code>export &#x27;../../feedback/klp_live_region.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:11](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L11) |
| export | <code>export &#x27;../../../foundation/interaction/klp_gesture_region.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:12](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L12) |
| export | <code>export &#x27;../../../foundation/interaction/klp_state_highlight.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:13](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L13) |
| export | <code>export &#x27;../../../foundation/layout/klp_align.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:14](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L14) |
| export | <code>export &#x27;../../../foundation/layout/klp_box.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:15](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L15) |
| export | <code>export &#x27;../../../foundation/layout/klp_box_insets.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:16](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L16) |
| export | <code>export &#x27;../../../foundation/layout/klp_column.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:17](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L17) |
| export | <code>export &#x27;../../../foundation/layout/klp_constrained_box.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:18](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L18) |
| export | <code>export &#x27;../../../foundation/layout/klp_box_constraints.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:19](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L19) |
| export | <code>export &#x27;../../../foundation/layout/klp_expanded.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:20](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L20) |
| export | <code>export &#x27;../../../foundation/layout/klp_gap.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:21](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L21) |
| export | <code>export &#x27;../../../foundation/layout/klp_row.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:22](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L22) |
| export | <code>export &#x27;../../../foundation/layout/klp_space_size.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:23](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L23) |
| export | <code>export &#x27;../../../foundation/layout/klp_spacer.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:24](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L24) |
| export | <code>export &#x27;../../../foundation/layout/klp_wrap.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:25](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L25) |
| export | <code>export &#x27;../../../application/localization/klp_localizations.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:26](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L26) |
| export | <code>export &#x27;../../../foundation/surface/klp_surface.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:27](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L27) |
| export | <code>export &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:28](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L28) |
| export | <code>export &#x27;../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/forms/internal/klp_form_dependencies.dart:29](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L29) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
