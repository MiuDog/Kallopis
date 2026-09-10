# klp_filter_bar.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart)

## 範圍

核心是 `lib/src/foundation/interaction/filter/klp_filter_bar.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_filter_bar.dart"]
	n1["package:flutter/material.dart"]
	n2["../../klp_icon.dart"]
	n3["../../klp_icons.dart"]
	n4["../../layout/klp_layout.dart"]
	n5["../../surface/klp_dashed_border.dart"]
	n6["../../../styling/legacy_theme/klp_theme.dart"]
	n7["../../content/klp_text.dart"]
	n8["../klp_action_region.dart"]
	n9["../klp_action_region_shape.dart"]
	n10["../klp_gesture_region.dart"]
	n11["klp_filter_models.dart"]
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
	n0["klp_filter_bar.dart"]
	n1["klp_filter_models.dart"]
	n2["klp_presence_indicator.dart"]
	n3["klp_selection_toolbar.dart"]
	n4["klp_shortcut_hint.dart"]
	n5["internal/klp_filter_bar_widget.dart"]
	n6["internal/klp_filter_chip.dart"]
	n7["primitives/klp_filter_chip_frame.dart"]
	n8["primitives/klp_filter_chip_style.dart"]
	n9["primitives/klp_filter_remove_action.dart"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"export"| n3
	n0 -->|"export"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:1](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L1) |
| import | <code>import &#x27;../../klp_icon.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:3](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L3) |
| import | <code>import &#x27;../../klp_icons.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:4](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L4) |
| import | <code>import &#x27;../../layout/klp_layout.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:5](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L5) |
| import | <code>import &#x27;../../surface/klp_dashed_border.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:6](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L6) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:7](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L7) |
| import | <code>import &#x27;../../content/klp_text.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:8](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L8) |
| import | <code>import &#x27;../klp_action_region.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:9](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L9) |
| import | <code>import &#x27;../klp_action_region_shape.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:10](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L10) |
| import | <code>import &#x27;../klp_gesture_region.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:11](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L11) |
| import | <code>import &#x27;klp_filter_models.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:12](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L12) |
| export | <code>export &#x27;klp_filter_models.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:14](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L14) |
| export | <code>export &#x27;klp_presence_indicator.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:15](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L15) |
| export | <code>export &#x27;klp_selection_toolbar.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:16](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L16) |
| export | <code>export &#x27;klp_shortcut_hint.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:17](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L17) |
| part | <code>part &#x27;internal/klp_filter_bar_widget.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:19](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L19) |
| part | <code>part &#x27;internal/klp_filter_chip.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:20](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L20) |
| part | <code>part &#x27;primitives/klp_filter_chip_frame.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:21](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L21) |
| part | <code>part &#x27;primitives/klp_filter_chip_style.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:22](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L22) |
| part | <code>part &#x27;primitives/klp_filter_remove_action.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:23](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L23) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
