# klp_card.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/data/card/klp_card.dart)

## 範圍

核心是 `lib/src/data/card/klp_card.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_card.dart"]
	n1["package:flutter/material.dart"]
	n2["../../feedback/klp_feedback_tone.dart"]
	n3["../../theme/klp_theme.dart"]
	n4["../../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/data/card/klp_card.dart:1](../../../../../lib/src/data/card/klp_card.dart#L1) |
| import | <code>import &#x27;../../feedback/klp_feedback_tone.dart&#x27;;</code> | [lib/src/data/card/klp_card.dart:3](../../../../../lib/src/data/card/klp_card.dart#L3) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/data/card/klp_card.dart:4](../../../../../lib/src/data/card/klp_card.dart#L4) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/data/card/klp_card.dart:5](../../../../../lib/src/data/card/klp_card.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCard"]
	class n1["KlpMetricCard"]
```

```mermaid
classDiagram
	class n0["KlpCard"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["KlpMetricCard"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCard

ClassDeclaration · public · [lib/src/data/card/klp_card.dart:7](../../../../../lib/src/data/card/klp_card.dart#L7)

<code>class KlpCard extends StatelessWidget</code>

來源註解摘要：內容卡片。

- `extends` → <code>StatelessWidget</code>：[lib/src/data/card/klp_card.dart:8](../../../../../lib/src/data/card/klp_card.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpCard</code> | public | <code>const KlpCard({ super.key, required this.title, required this.child, this.label, this.leading, this.trailing, this.footer, this.selected = false, this.backgroundColor, })</code> |  | [lib/src/data/card/klp_card.dart:9](../../../../../lib/src/data/card/klp_card.dart#L9) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/data/card/klp_card.dart:21](../../../../../lib/src/data/card/klp_card.dart#L21) |
| field <code>label</code> | public | <code>final String? label</code> |  | [lib/src/data/card/klp_card.dart:22](../../../../../lib/src/data/card/klp_card.dart#L22) |
| field <code>leading</code> | public | <code>final Widget? leading</code> |  | [lib/src/data/card/klp_card.dart:23](../../../../../lib/src/data/card/klp_card.dart#L23) |
| field <code>trailing</code> | public | <code>final Widget? trailing</code> |  | [lib/src/data/card/klp_card.dart:24](../../../../../lib/src/data/card/klp_card.dart#L24) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/data/card/klp_card.dart:25](../../../../../lib/src/data/card/klp_card.dart#L25) |
| field <code>footer</code> | public | <code>final Widget? footer</code> |  | [lib/src/data/card/klp_card.dart:26](../../../../../lib/src/data/card/klp_card.dart#L26) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/data/card/klp_card.dart:27](../../../../../lib/src/data/card/klp_card.dart#L27) |
| field <code>backgroundColor</code> | public | <code>final Color? backgroundColor</code> |  | [lib/src/data/card/klp_card.dart:28](../../../../../lib/src/data/card/klp_card.dart#L28) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/data/card/klp_card.dart:30](../../../../../lib/src/data/card/klp_card.dart#L30) |

### KlpMetricCard

ClassDeclaration · public · [lib/src/data/card/klp_card.dart:79](../../../../../lib/src/data/card/klp_card.dart#L79)

<code>class KlpMetricCard extends StatelessWidget</code>

來源註解摘要：指標呈現卡片 (Metric Card)。 呈現標籤、核心數值、單位、趨勢箭頭、狀態說明或迷你進度長條。 支援正常（neutral/success）與違規告警（danger 具備紅色外框與文字）。

- `extends` → <code>StatelessWidget</code>：[lib/src/data/card/klp_card.dart:83](../../../../../lib/src/data/card/klp_card.dart#L83)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpMetricCard</code> | public | <code>const KlpMetricCard({ super.key, required this.label, this.value, this.unit, this.trend, this.subtitle, this.tone = KlpFeedbackTone.neutral, this.child, })</code> |  | [lib/src/data/card/klp_card.dart:84](../../../../../lib/src/data/card/klp_card.dart#L84) |
| field <code>label</code> | public | <code>final String label</code> | 指標標籤（如 &#x27;PASS RATE&#x27;, &#x27;P95 LATENCY&#x27;）。 | [lib/src/data/card/klp_card.dart:96](../../../../../lib/src/data/card/klp_card.dart#L96) |
| field <code>value</code> | public | <code>final String? value</code> | 數值（如 &#x27;98.2&#x27;, &#x27;1420&#x27;）。 | [lib/src/data/card/klp_card.dart:99](../../../../../lib/src/data/card/klp_card.dart#L99) |
| field <code>unit</code> | public | <code>final String? unit</code> | 數值單位（如 &#x27;%&#x27;, &#x27;ms&#x27;）。 | [lib/src/data/card/klp_card.dart:102](../../../../../lib/src/data/card/klp_card.dart#L102) |
| field <code>trend</code> | public | <code>final String? trend</code> | 趨勢或指標符號（如 &#x27;↑&#x27;, &#x27;↓&#x27;）。 | [lib/src/data/card/klp_card.dart:105](../../../../../lib/src/data/card/klp_card.dart#L105) |
| field <code>subtitle</code> | public | <code>final String? subtitle</code> | 底部說明（如 &#x27;Threshold 95%&#x27;, &#x27;Breached · threshold 800ms&#x27;）。 | [lib/src/data/card/klp_card.dart:108](../../../../../lib/src/data/card/klp_card.dart#L108) |
| field <code>tone</code> | public | <code>final KlpFeedbackTone tone</code> | 狀態語意色調。為 danger 時卡片邊框與數值呈現紅色。 | [lib/src/data/card/klp_card.dart:111](../../../../../lib/src/data/card/klp_card.dart#L111) |
| field <code>child</code> | public | <code>final Widget? child</code> | 自訂內容（如進度條）。 | [lib/src/data/card/klp_card.dart:114](../../../../../lib/src/data/card/klp_card.dart#L114) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/data/card/klp_card.dart:116](../../../../../lib/src/data/card/klp_card.dart#L116) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
