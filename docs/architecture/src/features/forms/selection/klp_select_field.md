# klp_select_field.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/selection/klp_select_field.dart)

## 範圍

核心是 `lib/src/features/forms/selection/klp_select_field.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_select_field.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n2["klp_choice_option.dart"]
	n3["internal/klp_select_field_chevron.dart"]
	n4["internal/klp_select_field_option.dart"]
	n5["internal/klp_select_field_state.dart"]
	n6["internal/klp_select_field_widget.dart"]
	n7["primitives/klp_select_field_trigger.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_select_field.dart:1](../../../../../../lib/src/features/forms/selection/klp_select_field.dart#L1) |
| import | <code>import &#x27;klp_choice_option.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_select_field.dart:2](../../../../../../lib/src/features/forms/selection/klp_select_field.dart#L2) |
| part | <code>part &#x27;internal/klp_select_field_chevron.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_select_field.dart:4](../../../../../../lib/src/features/forms/selection/klp_select_field.dart#L4) |
| part | <code>part &#x27;internal/klp_select_field_option.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_select_field.dart:5](../../../../../../lib/src/features/forms/selection/klp_select_field.dart#L5) |
| part | <code>part &#x27;internal/klp_select_field_state.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_select_field.dart:6](../../../../../../lib/src/features/forms/selection/klp_select_field.dart#L6) |
| part | <code>part &#x27;internal/klp_select_field_widget.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_select_field.dart:7](../../../../../../lib/src/features/forms/selection/klp_select_field.dart#L7) |
| part | <code>part &#x27;primitives/klp_select_field_trigger.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_select_field.dart:8](../../../../../../lib/src/features/forms/selection/klp_select_field.dart#L8) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
