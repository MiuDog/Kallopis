# klp_oklch_color_picker.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart)

## 範圍

核心是 `lib/src/features/forms/color/klp_oklch_color_picker.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_oklch_color_picker.dart"]
	n1["dart:math"]
	n2["package:flutter/material.dart"]
	n3["package:flutter/services.dart"]
	n4["../../../foundation/klp_oklch_color.dart"]
	n5["../../../foundation/interaction/klp_exclude_semantics.dart"]
	n6["../../../foundation/interaction/klp_semantic_region.dart"]
	n7["../../../foundation/layout/klp_layout.dart"]
	n8["../../../application/localization/klp_localizations.dart"]
	n9["../../../styling/legacy_theme/klp_theme.dart"]
	n10["../../../foundation/content/klp_text.dart"]
	n11["klp_oklch_chroma_range.dart"]
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
	n0["klp_oklch_color_picker.dart"]
	n1["klp_oklch_color_editor.dart"]
	n2["internal/klp_oklch_color_picker_content.dart"]
	n3["internal/klp_oklch_color_picker_style.dart"]
	n4["internal/klp_oklch_color_picker_widget.dart"]
	n5["internal/klp_oklch_plane.dart"]
	n6["internal/klp_oklch_plane_kind.dart"]
	n7["internal/klp_oklch_plane_section.dart"]
	n8["internal/klp_oklch_plane_state.dart"]
	n9["internal/klp_oklch_plane_style.dart"]
	n10["internal/klp_oklch_preview.dart"]
	n11["primitives/klp_oklch_plane_extent_frame.dart"]
	n0 -->|"import"| n1
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
	n0["klp_oklch_color_picker.dart"]
	n1["primitives/klp_oklch_plane_frame.dart"]
	n2["primitives/klp_oklch_plane_painter.dart"]
	n3["primitives/klp_oklch_preview_frame.dart"]
	n4["primitives/klp_oklch_section_frame.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:math&#x27; as math;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:1](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L1) |
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:3](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L3) |
| import | <code>import &#x27;package:flutter/services.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:4](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L4) |
| import | <code>import &#x27;../../../foundation/klp_oklch_color.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:6](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L6) |
| import | <code>import &#x27;../../../foundation/interaction/klp_exclude_semantics.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:7](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L7) |
| import | <code>import &#x27;../../../foundation/interaction/klp_semantic_region.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:8](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L8) |
| import | <code>import &#x27;../../../foundation/layout/klp_layout.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:9](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L9) |
| import | <code>import &#x27;../../../application/localization/klp_localizations.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:10](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L10) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:11](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L11) |
| import | <code>import &#x27;../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:12](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L12) |
| import | <code>import &#x27;klp_oklch_chroma_range.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:13](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L13) |
| import | <code>import &#x27;klp_oklch_color_editor.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:14](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L14) |
| part | <code>part &#x27;internal/klp_oklch_color_picker_content.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:16](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L16) |
| part | <code>part &#x27;internal/klp_oklch_color_picker_style.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:17](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L17) |
| part | <code>part &#x27;internal/klp_oklch_color_picker_widget.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:18](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L18) |
| part | <code>part &#x27;internal/klp_oklch_plane.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:19](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L19) |
| part | <code>part &#x27;internal/klp_oklch_plane_kind.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:20](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L20) |
| part | <code>part &#x27;internal/klp_oklch_plane_section.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:21](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L21) |
| part | <code>part &#x27;internal/klp_oklch_plane_state.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:22](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L22) |
| part | <code>part &#x27;internal/klp_oklch_plane_style.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:23](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L23) |
| part | <code>part &#x27;internal/klp_oklch_preview.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:24](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L24) |
| part | <code>part &#x27;primitives/klp_oklch_plane_extent_frame.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:25](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L25) |
| part | <code>part &#x27;primitives/klp_oklch_plane_frame.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:26](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L26) |
| part | <code>part &#x27;primitives/klp_oklch_plane_painter.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:27](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L27) |
| part | <code>part &#x27;primitives/klp_oklch_preview_frame.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:28](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L28) |
| part | <code>part &#x27;primitives/klp_oklch_section_frame.dart&#x27;;</code> | [lib/src/features/forms/color/klp_oklch_color_picker.dart:29](../../../../../../lib/src/features/forms/color/klp_oklch_color_picker.dart#L29) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
