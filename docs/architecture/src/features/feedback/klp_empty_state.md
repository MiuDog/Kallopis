# klp_empty_state.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/features/feedback/klp_empty_state.dart)

## 範圍

核心是 `lib/src/features/feedback/klp_empty_state.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_empty_state.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../foundation/klp_icon.dart"]
	n3["../../foundation/interaction/klp_exclude_semantics.dart"]
	n4["../../foundation/layout/klp_layout.dart"]
	n5["../../foundation/surface/klp_dashed_border.dart"]
	n6["../../foundation/surface/klp_surface.dart"]
	n7["../../styling/legacy_theme/klp_theme.dart"]
	n8["../../foundation/content/klp_text.dart"]
	n9["empty_state/klp_empty_state_widget.dart"]
	n10["empty_state/klp_skeleton_line.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"part"| n9
	n0 -->|"part"| n10
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:1](../../../../../lib/src/features/feedback/klp_empty_state.dart#L1) |
| import | <code>import &#x27;../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:3](../../../../../lib/src/features/feedback/klp_empty_state.dart#L3) |
| import | <code>import &#x27;../../foundation/interaction/klp_exclude_semantics.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:4](../../../../../lib/src/features/feedback/klp_empty_state.dart#L4) |
| import | <code>import &#x27;../../foundation/layout/klp_layout.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:5](../../../../../lib/src/features/feedback/klp_empty_state.dart#L5) |
| import | <code>import &#x27;../../foundation/surface/klp_dashed_border.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:6](../../../../../lib/src/features/feedback/klp_empty_state.dart#L6) |
| import | <code>import &#x27;../../foundation/surface/klp_surface.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:7](../../../../../lib/src/features/feedback/klp_empty_state.dart#L7) |
| import | <code>import &#x27;../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:8](../../../../../lib/src/features/feedback/klp_empty_state.dart#L8) |
| import | <code>import &#x27;../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:9](../../../../../lib/src/features/feedback/klp_empty_state.dart#L9) |
| part | <code>part &#x27;empty_state/klp_empty_state_widget.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:11](../../../../../lib/src/features/feedback/klp_empty_state.dart#L11) |
| part | <code>part &#x27;empty_state/klp_skeleton_line.dart&#x27;;</code> | [lib/src/features/feedback/klp_empty_state.dart:12](../../../../../lib/src/features/feedback/klp_empty_state.dart#L12) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
