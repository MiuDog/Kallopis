# klp_empty_state.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/feedback/klp_empty_state.dart)

## 範圍

核心是 `lib/src/feedback/klp_empty_state.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_empty_state.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../foundation/klp_icon.dart"]
	n3["../surface/klp_dashed_border.dart"]
	n4["../theme/klp_theme.dart"]
	n5["../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/feedback/klp_empty_state.dart:1](../../../../lib/src/feedback/klp_empty_state.dart#L1) |
| import | <code>import &#x27;../foundation/klp_icon.dart&#x27;;</code> | [lib/src/feedback/klp_empty_state.dart:3](../../../../lib/src/feedback/klp_empty_state.dart#L3) |
| import | <code>import &#x27;../surface/klp_dashed_border.dart&#x27;;</code> | [lib/src/feedback/klp_empty_state.dart:4](../../../../lib/src/feedback/klp_empty_state.dart#L4) |
| import | <code>import &#x27;../theme/klp_theme.dart&#x27;;</code> | [lib/src/feedback/klp_empty_state.dart:5](../../../../lib/src/feedback/klp_empty_state.dart#L5) |
| import | <code>import &#x27;../typography/klp_text.dart&#x27;;</code> | [lib/src/feedback/klp_empty_state.dart:6](../../../../lib/src/feedback/klp_empty_state.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEmptyState"]
	class n1["KlpSkeletonLine"]
```

```mermaid
classDiagram
	class n0["KlpEmptyState"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["KlpSkeletonLine"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEmptyState

ClassDeclaration · public · [lib/src/feedback/klp_empty_state.dart:8](../../../../lib/src/feedback/klp_empty_state.dart#L8)

<code>class KlpEmptyState extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/feedback/klp_empty_state.dart:8](../../../../lib/src/feedback/klp_empty_state.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpEmptyState</code> | public | <code>const KlpEmptyState({ super.key, required this.icon, required this.title, required this.message, this.action, })</code> |  | [lib/src/feedback/klp_empty_state.dart:9](../../../../lib/src/feedback/klp_empty_state.dart#L9) |
| field <code>icon</code> | public | <code>final KlpIconData icon</code> |  | [lib/src/feedback/klp_empty_state.dart:17](../../../../lib/src/feedback/klp_empty_state.dart#L17) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/feedback/klp_empty_state.dart:18](../../../../lib/src/feedback/klp_empty_state.dart#L18) |
| field <code>message</code> | public | <code>final String message</code> |  | [lib/src/feedback/klp_empty_state.dart:19](../../../../lib/src/feedback/klp_empty_state.dart#L19) |
| field <code>action</code> | public | <code>final Widget? action</code> |  | [lib/src/feedback/klp_empty_state.dart:20](../../../../lib/src/feedback/klp_empty_state.dart#L20) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/feedback/klp_empty_state.dart:22](../../../../lib/src/feedback/klp_empty_state.dart#L22) |

### KlpSkeletonLine

ClassDeclaration · public · [lib/src/feedback/klp_empty_state.dart:60](../../../../lib/src/feedback/klp_empty_state.dart#L60)

<code>class KlpSkeletonLine extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/feedback/klp_empty_state.dart:60](../../../../lib/src/feedback/klp_empty_state.dart#L60)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSkeletonLine</code> | public | <code>const KlpSkeletonLine({super.key, this.width = double.infinity})</code> |  | [lib/src/feedback/klp_empty_state.dart:61](../../../../lib/src/feedback/klp_empty_state.dart#L61) |
| field <code>width</code> | public | <code>final double width</code> |  | [lib/src/feedback/klp_empty_state.dart:63](../../../../lib/src/feedback/klp_empty_state.dart#L63) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/feedback/klp_empty_state.dart:65](../../../../lib/src/feedback/klp_empty_state.dart#L65) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
