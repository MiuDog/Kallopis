# klp_form.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/form/klp_form.dart)

## 範圍

核心是 `lib/src/form/klp_form.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_form.dart"]
	n1["core/klp_conditional_field_region.dart"]
	n2["core/klp_field.dart"]
	n3["core/klp_field_description.dart"]
	n4["core/klp_field_error.dart"]
	n5["core/klp_field_group.dart"]
	n6["core/klp_field_label.dart"]
	n7["core/klp_field_visual_state.dart"]
	n8["core/klp_form.dart"]
	n9["core/klp_form_actions.dart"]
	n10["core/klp_form_error_summary.dart"]
	n11["core/klp_form_section.dart"]
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

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| export | <code>export &#x27;core/klp_conditional_field_region.dart&#x27;;</code> | [lib/src/form/klp_form.dart:1](../../../../lib/src/form/klp_form.dart#L1) |
| export | <code>export &#x27;core/klp_field.dart&#x27;;</code> | [lib/src/form/klp_form.dart:2](../../../../lib/src/form/klp_form.dart#L2) |
| export | <code>export &#x27;core/klp_field_description.dart&#x27;;</code> | [lib/src/form/klp_form.dart:3](../../../../lib/src/form/klp_form.dart#L3) |
| export | <code>export &#x27;core/klp_field_error.dart&#x27;;</code> | [lib/src/form/klp_form.dart:4](../../../../lib/src/form/klp_form.dart#L4) |
| export | <code>export &#x27;core/klp_field_group.dart&#x27;;</code> | [lib/src/form/klp_form.dart:5](../../../../lib/src/form/klp_form.dart#L5) |
| export | <code>export &#x27;core/klp_field_label.dart&#x27;;</code> | [lib/src/form/klp_form.dart:6](../../../../lib/src/form/klp_form.dart#L6) |
| export | <code>export &#x27;core/klp_field_visual_state.dart&#x27;;</code> | [lib/src/form/klp_form.dart:7](../../../../lib/src/form/klp_form.dart#L7) |
| export | <code>export &#x27;core/klp_form.dart&#x27;;</code> | [lib/src/form/klp_form.dart:8](../../../../lib/src/form/klp_form.dart#L8) |
| export | <code>export &#x27;core/klp_form_actions.dart&#x27;;</code> | [lib/src/form/klp_form.dart:9](../../../../lib/src/form/klp_form.dart#L9) |
| export | <code>export &#x27;core/klp_form_error_summary.dart&#x27;;</code> | [lib/src/form/klp_form.dart:10](../../../../lib/src/form/klp_form.dart#L10) |
| export | <code>export &#x27;core/klp_form_section.dart&#x27;;</code> | [lib/src/form/klp_form.dart:11](../../../../lib/src/form/klp_form.dart#L11) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
