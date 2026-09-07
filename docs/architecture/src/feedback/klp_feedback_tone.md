# klp_feedback_tone.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/feedback/klp_feedback_tone.dart)

## 範圍

核心是 `lib/src/feedback/klp_feedback_tone.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_feedback_tone.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../foundation/klp_icon.dart"]
	n3["../foundation/klp_icons.dart"]
	n4["../theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/feedback/klp_feedback_tone.dart:1](../../../../lib/src/feedback/klp_feedback_tone.dart#L1) |
| import | <code>import &#x27;../foundation/klp_icon.dart&#x27;;</code> | [lib/src/feedback/klp_feedback_tone.dart:3](../../../../lib/src/feedback/klp_feedback_tone.dart#L3) |
| import | <code>import &#x27;../foundation/klp_icons.dart&#x27;;</code> | [lib/src/feedback/klp_feedback_tone.dart:4](../../../../lib/src/feedback/klp_feedback_tone.dart#L4) |
| import | <code>import &#x27;../theme/klp_theme.dart&#x27;;</code> | [lib/src/feedback/klp_feedback_tone.dart:5](../../../../lib/src/feedback/klp_feedback_tone.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFeedbackTone"]
	class n1["KlpFeedbackToneStyle"]
```

```mermaid
classDiagram
	class n0["KlpFeedbackToneStyle"]
	class n1["KlpFeedbackTone"]
	n0 ..> n1 : on
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFeedbackTone

EnumDeclaration · public · [lib/src/feedback/klp_feedback_tone.dart:7](../../../../lib/src/feedback/klp_feedback_tone.dart#L7)

<code>enum KlpFeedbackTone</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>info</code> | public | <code>info</code> |  | [lib/src/feedback/klp_feedback_tone.dart:7](../../../../lib/src/feedback/klp_feedback_tone.dart#L7) |
| enum value <code>success</code> | public | <code>success</code> |  | [lib/src/feedback/klp_feedback_tone.dart:7](../../../../lib/src/feedback/klp_feedback_tone.dart#L7) |
| enum value <code>warning</code> | public | <code>warning</code> |  | [lib/src/feedback/klp_feedback_tone.dart:7](../../../../lib/src/feedback/klp_feedback_tone.dart#L7) |
| enum value <code>danger</code> | public | <code>danger</code> |  | [lib/src/feedback/klp_feedback_tone.dart:7](../../../../lib/src/feedback/klp_feedback_tone.dart#L7) |
| enum value <code>neutral</code> | public | <code>neutral</code> |  | [lib/src/feedback/klp_feedback_tone.dart:7](../../../../lib/src/feedback/klp_feedback_tone.dart#L7) |

### KlpFeedbackToneStyle

ExtensionDeclaration · public · [lib/src/feedback/klp_feedback_tone.dart:9](../../../../lib/src/feedback/klp_feedback_tone.dart#L9)

<code>extension KlpFeedbackToneStyle on KlpFeedbackTone</code>

- `on` → <code>KlpFeedbackTone</code>：[lib/src/feedback/klp_feedback_tone.dart:9](../../../../lib/src/feedback/klp_feedback_tone.dart#L9)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| method <code>color</code> | public | <code>Color color(KlpThemeData tokens)</code> |  | [lib/src/feedback/klp_feedback_tone.dart:10](../../../../lib/src/feedback/klp_feedback_tone.dart#L10) |
| getter <code>icon</code> | public | <code>KlpIconData get icon</code> |  | [lib/src/feedback/klp_feedback_tone.dart:20](../../../../lib/src/feedback/klp_feedback_tone.dart#L20) |
| getter <code>label</code> | public | <code>String get label</code> |  | [lib/src/feedback/klp_feedback_tone.dart:28](../../../../lib/src/feedback/klp_feedback_tone.dart#L28) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
