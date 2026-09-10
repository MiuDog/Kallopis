# klp_sliding_selection.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart)

## 範圍

核心是 `lib/src/features/forms/selection/klp_sliding_selection.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_sliding_selection.dart"]
	n1["package:flutter/material.dart"]
	n2["../../../foundation/klp_icon.dart"]
	n3["../../../styling/legacy_theme/klp_theme.dart"]
	n4["klp_selection_option.dart"]
	n5["klp_selection_tone.dart"]
	n6["klp_selection_option.dart"]
	n7["klp_selection_tone.dart"]
	n8["internal/klp_sliding_selection_style.dart"]
	n9["internal/klp_sliding_selection_widget.dart"]
	n10["primitives/klp_sliding_selection_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"export"| n6
	n0 -->|"export"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
	n0 -->|"part"| n10
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:1](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L1) |
| import | <code>import &#x27;../../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:3](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L3) |
| import | <code>import &#x27;../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:4](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L4) |
| import | <code>import &#x27;klp_selection_option.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:5](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L5) |
| import | <code>import &#x27;klp_selection_tone.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:6](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L6) |
| export | <code>export &#x27;klp_selection_option.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:8](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L8) |
| export | <code>export &#x27;klp_selection_tone.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:9](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L9) |
| part | <code>part &#x27;internal/klp_sliding_selection_style.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:11](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L11) |
| part | <code>part &#x27;internal/klp_sliding_selection_widget.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:12](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L12) |
| part | <code>part &#x27;primitives/klp_sliding_selection_frame.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_sliding_selection.dart:13](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L13) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
