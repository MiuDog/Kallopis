# klp_selection_toolbar.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart)

## 範圍

核心是 `lib/src/interaction/filter/klp_selection_toolbar.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_selection_toolbar.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../controls/button/klp_button.dart"]
	n3["../../surface/klp_dashed_border.dart"]
	n4["../../surface/klp_surface.dart"]
	n5["../../theme/klp_theme.dart"]
	n6["../../typography/klp_text.dart"]
	n7["../../interaction/klp_pressable.dart"]
	n8["klp_filter_models.dart"]
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
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/interaction/filter/klp_selection_toolbar.dart:1](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L1) |
| import | <code>import &#x27;../../controls/button/klp_button.dart&#x27;;</code> | [lib/src/interaction/filter/klp_selection_toolbar.dart:3](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L3) |
| import | <code>import &#x27;../../surface/klp_dashed_border.dart&#x27;;</code> | [lib/src/interaction/filter/klp_selection_toolbar.dart:4](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L4) |
| import | <code>import &#x27;../../surface/klp_surface.dart&#x27;;</code> | [lib/src/interaction/filter/klp_selection_toolbar.dart:5](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L5) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/interaction/filter/klp_selection_toolbar.dart:6](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L6) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/interaction/filter/klp_selection_toolbar.dart:7](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L7) |
| import | <code>import &#x27;../../interaction/klp_pressable.dart&#x27;;</code> | [lib/src/interaction/filter/klp_selection_toolbar.dart:8](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L8) |
| import | <code>import &#x27;klp_filter_models.dart&#x27;;</code> | [lib/src/interaction/filter/klp_selection_toolbar.dart:9](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L9) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSelectionToolbar"]
```

```mermaid
classDiagram
	class n0["KlpSelectionToolbar"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSelectionToolbar

ClassDeclaration · public · [lib/src/interaction/filter/klp_selection_toolbar.dart:11](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L11)

<code>class KlpSelectionToolbar extends StatelessWidget</code>

來源註解摘要：批次選取浮動／固定操作列。

- `extends` → <code>StatelessWidget</code>：[lib/src/interaction/filter/klp_selection_toolbar.dart:12](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L12)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSelectionToolbar</code> | public | <code>const KlpSelectionToolbar({ super.key, required this.count, required this.countLabel, required this.actions, this.onClear, this.clearLabel = &#x27;Clear&#x27;, this.dashed = true, })</code> |  | [lib/src/interaction/filter/klp_selection_toolbar.dart:13](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L13) |
| field <code>count</code> | public | <code>final int count</code> |  | [lib/src/interaction/filter/klp_selection_toolbar.dart:23](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L23) |
| field <code>countLabel</code> | public | <code>final String countLabel</code> |  | [lib/src/interaction/filter/klp_selection_toolbar.dart:24](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L24) |
| field <code>actions</code> | public | <code>final List&lt;KlpSelectionAction&gt; actions</code> |  | [lib/src/interaction/filter/klp_selection_toolbar.dart:25](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L25) |
| field <code>onClear</code> | public | <code>final VoidCallback? onClear</code> |  | [lib/src/interaction/filter/klp_selection_toolbar.dart:26](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L26) |
| field <code>clearLabel</code> | public | <code>final String? clearLabel</code> |  | [lib/src/interaction/filter/klp_selection_toolbar.dart:27](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L27) |
| field <code>dashed</code> | public | <code>final bool dashed</code> |  | [lib/src/interaction/filter/klp_selection_toolbar.dart:28](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L28) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/interaction/filter/klp_selection_toolbar.dart:30](../../../../../lib/src/interaction/filter/klp_selection_toolbar.dart#L30) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
