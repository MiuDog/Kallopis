# klp_message_composer.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/editor/message_composer/klp_message_composer.dart)

## 範圍

核心是 `lib/src/editor/message_composer/klp_message_composer.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_message_composer.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../controls/button/klp_button.dart"]
	n3["../../controls/button/klp_icon_button.dart"]
	n4["../../data/badge/klp_badge.dart"]
	n5["../../form/klp_form_controls.dart"]
	n6["../../foundation/klp_icons.dart"]
	n7["../../surface/klp_surface.dart"]
	n8["../../theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/editor/message_composer/klp_message_composer.dart:1](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L1) |
| import | <code>import &#x27;../../controls/button/klp_button.dart&#x27;;</code> | [lib/src/editor/message_composer/klp_message_composer.dart:3](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L3) |
| import | <code>import &#x27;../../controls/button/klp_icon_button.dart&#x27;;</code> | [lib/src/editor/message_composer/klp_message_composer.dart:4](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L4) |
| import | <code>import &#x27;../../data/badge/klp_badge.dart&#x27;;</code> | [lib/src/editor/message_composer/klp_message_composer.dart:5](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L5) |
| import | <code>import &#x27;../../form/klp_form_controls.dart&#x27;;</code> | [lib/src/editor/message_composer/klp_message_composer.dart:6](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L6) |
| import | <code>import &#x27;../../foundation/klp_icons.dart&#x27;;</code> | [lib/src/editor/message_composer/klp_message_composer.dart:7](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L7) |
| import | <code>import &#x27;../../surface/klp_surface.dart&#x27;;</code> | [lib/src/editor/message_composer/klp_message_composer.dart:8](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L8) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/editor/message_composer/klp_message_composer.dart:9](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L9) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpMessageConversation"]
	class n1["KlpMessageComposer"]
```

```mermaid
classDiagram
	class n0["KlpMessageConversation"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["KlpMessageComposer"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpMessageConversation

ClassDeclaration · public · [lib/src/editor/message_composer/klp_message_composer.dart:11](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L11)

<code>class KlpMessageConversation extends StatelessWidget</code>

來源註解摘要：在有限區域內組合可捲動訊息內容與底部 Composer。

- `extends` → <code>StatelessWidget</code>：[lib/src/editor/message_composer/klp_message_composer.dart:12](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L12)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpMessageConversation</code> | public | <code>const KlpMessageConversation({super.key, required this.content, required this.composer})</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:13](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L13) |
| field <code>content</code> | public | <code>final Widget content</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:15](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L15) |
| field <code>composer</code> | public | <code>final Widget composer</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:16](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L16) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:18](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L18) |

### KlpMessageComposer

ClassDeclaration · public · [lib/src/editor/message_composer/klp_message_composer.dart:49](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L49)

<code>class KlpMessageComposer extends StatelessWidget</code>

來源註解摘要：帶有範圍標籤、附件動作與提交動作的多行訊息輸入器。

- `extends` → <code>StatelessWidget</code>：[lib/src/editor/message_composer/klp_message_composer.dart:50](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L50)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpMessageComposer</code> | public | <code>const KlpMessageComposer({ super.key, required this.placeholder, required this.sendLabel, required this.attachLabel, required this.onSend, required this.onAttach, this.tags = const [], this.value, this.onChanged, this.dense = false, this.inlineActions = false, this.outlined = false, this.minLines = 1, this.maxLines = 5, })</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:51](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L51) |
| field <code>placeholder</code> | public | <code>final String placeholder</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:68](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L68) |
| field <code>sendLabel</code> | public | <code>final String sendLabel</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:69](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L69) |
| field <code>attachLabel</code> | public | <code>final String attachLabel</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:70](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L70) |
| field <code>onSend</code> | public | <code>final VoidCallback? onSend</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:71](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L71) |
| field <code>onAttach</code> | public | <code>final VoidCallback? onAttach</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:72](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L72) |
| field <code>tags</code> | public | <code>final List&lt;String&gt; tags</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:73](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L73) |
| field <code>value</code> | public | <code>final String? value</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:74](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L74) |
| field <code>onChanged</code> | public | <code>final ValueChanged&lt;String&gt;? onChanged</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:75](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L75) |
| field <code>dense</code> | public | <code>final bool dense</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:76](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L76) |
| field <code>inlineActions</code> | public | <code>final bool inlineActions</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:77](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L77) |
| field <code>outlined</code> | public | <code>final bool outlined</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:78](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L78) |
| field <code>minLines</code> | public | <code>final int minLines</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:79](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L79) |
| field <code>maxLines</code> | public | <code>final int? maxLines</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:80](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L80) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:82](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L82) |
| method <code>_buildInlineInput</code> | private | <code>Widget _buildInlineInput(BuildContext context)</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:116](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L116) |
| method <code>_buildStackedInput</code> | private | <code>Widget _buildStackedInput(BuildContext context)</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:130](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L130) |
| method <code>_buildTextArea</code> | private | <code>Widget _buildTextArea()</code> |  | [lib/src/editor/message_composer/klp_message_composer.dart:149](../../../../../lib/src/editor/message_composer/klp_message_composer.dart#L149) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
