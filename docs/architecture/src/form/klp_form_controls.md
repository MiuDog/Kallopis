# klp_form_controls.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/form/klp_form_controls.dart)

## 範圍

核心是 `lib/src/form/klp_form_controls.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_form_controls.dart"]
	n1["input/klp_number_field.dart"]
	n2["input/klp_password_field.dart"]
	n3["input/klp_text_area.dart"]
	n4["selection/klp_choice_option.dart"]
	n5["selection/klp_date_field.dart"]
	n6["selection/klp_multi_select_field.dart"]
	n7["selection/klp_select_field.dart"]
	n8["selection/klp_status_role_swatches.dart"]
	n9["selection/klp_tag_chip.dart"]
	n10["selection/klp_tag_input_field.dart"]
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
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| export | <code>export &#x27;input/klp_number_field.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:1](../../../../lib/src/form/klp_form_controls.dart#L1) |
| export | <code>export &#x27;input/klp_password_field.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:2](../../../../lib/src/form/klp_form_controls.dart#L2) |
| export | <code>export &#x27;input/klp_text_area.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:3](../../../../lib/src/form/klp_form_controls.dart#L3) |
| export | <code>export &#x27;selection/klp_choice_option.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:4](../../../../lib/src/form/klp_form_controls.dart#L4) |
| export | <code>export &#x27;selection/klp_date_field.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:5](../../../../lib/src/form/klp_form_controls.dart#L5) |
| export | <code>export &#x27;selection/klp_multi_select_field.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:6](../../../../lib/src/form/klp_form_controls.dart#L6) |
| export | <code>export &#x27;selection/klp_select_field.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:7](../../../../lib/src/form/klp_form_controls.dart#L7) |
| export | <code>export &#x27;selection/klp_status_role_swatches.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:8](../../../../lib/src/form/klp_form_controls.dart#L8) |
| export | <code>export &#x27;selection/klp_tag_chip.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:9](../../../../lib/src/form/klp_form_controls.dart#L9) |
| export | <code>export &#x27;selection/klp_tag_input_field.dart&#x27;;</code> | [lib/src/form/klp_form_controls.dart:10](../../../../lib/src/form/klp_form_controls.dart#L10) |

## 宣告關係圖

本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。

## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
