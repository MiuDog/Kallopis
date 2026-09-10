# klp_list_tile.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart)

## 範圍

核心是 `lib/src/features/collections/list_tile/klp_list_tile.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_list_tile.dart"]
	n1["package:flutter/material.dart"]
	n2["../../feedback/klp_feedback_tone.dart"]
	n3["../../../foundation/klp_icon.dart"]
	n4["../../../foundation/layout/klp_column.dart"]
	n5["../../../foundation/layout/klp_expanded.dart"]
	n6["../../../foundation/layout/klp_gap.dart"]
	n7["../../../foundation/layout/klp_row.dart"]
	n8["../../../foundation/layout/klp_space_size.dart"]
	n9["../../../styling/legacy_theme/klp_theme.dart"]
	n10["../../../foundation/content/klp_text.dart"]
	n11["internal/klp_list_tile_widget.dart"]
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
flowchart TD
	n0["klp_list_tile.dart"]
	n1["primitives/klp_list_tile_frame.dart"]
	n2["primitives/klp_list_tile_frame_state.dart"]
	n3["primitives/klp_list_tile_frame_style.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:1](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L1) |
| import | <code>import &#x27;../../feedback/klp_feedback_tone.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:3](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L3) |
| import | <code>import &#x27;../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:4](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L4) |
| import | <code>import &#x27;../../../foundation/layout/klp_column.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:5](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L5) |
| import | <code>import &#x27;../../../foundation/layout/klp_expanded.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:6](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L6) |
| import | <code>import &#x27;../../../foundation/layout/klp_gap.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:7](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L7) |
| import | <code>import &#x27;../../../foundation/layout/klp_row.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:8](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L8) |
| import | <code>import &#x27;../../../foundation/layout/klp_space_size.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:9](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L9) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:10](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L10) |
| import | <code>import &#x27;../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:11](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L11) |
| part | <code>part &#x27;internal/klp_list_tile_widget.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:13](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L13) |
| part | <code>part &#x27;primitives/klp_list_tile_frame.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:14](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L14) |
| part | <code>part &#x27;primitives/klp_list_tile_frame_state.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:15](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L15) |
| part | <code>part &#x27;primitives/klp_list_tile_frame_style.dart&#x27;;</code> | [lib/src/features/collections/list_tile/klp_list_tile.dart:16](../../../../../../lib/src/features/collections/list_tile/klp_list_tile.dart#L16) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
