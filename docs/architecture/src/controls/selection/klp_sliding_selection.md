# klp_sliding_selection.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/controls/selection/klp_sliding_selection.dart)

## 範圍

核心是 `lib/src/controls/selection/klp_sliding_selection.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_sliding_selection.dart"]
	n1["package:flutter/material.dart"]
	n2["../../foundation/klp_icon.dart"]
	n3["../../theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/controls/selection/klp_sliding_selection.dart:1](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L1) |
| import | <code>import &#x27;../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/controls/selection/klp_sliding_selection.dart:3](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L3) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/controls/selection/klp_sliding_selection.dart:4](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSelectionOption"]
	class n1["KlpSlidingSelection"]
```

```mermaid
classDiagram
	class n0["KlpSlidingSelection"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSelectionOption

ClassDeclaration · public · [lib/src/controls/selection/klp_sliding_selection.dart:6](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L6)

<code>class KlpSelectionOption</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSelectionOption</code> | public | <code>const KlpSelectionOption({required this.icon, required this.color})</code> |  | [lib/src/controls/selection/klp_sliding_selection.dart:8](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L8) |
| field <code>icon</code> | public | <code>final KlpIconData icon</code> |  | [lib/src/controls/selection/klp_sliding_selection.dart:10](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L10) |
| field <code>color</code> | public | <code>final Color color</code> |  | [lib/src/controls/selection/klp_sliding_selection.dart:11](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L11) |

### KlpSlidingSelection

ClassDeclaration · public · [lib/src/controls/selection/klp_sliding_selection.dart:14](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L14)

<code>class KlpSlidingSelection extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/controls/selection/klp_sliding_selection.dart:14](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L14)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSlidingSelection</code> | public | <code>const KlpSlidingSelection({ super.key, required this.label, required this.selectedIndex, required this.options, required this.onSelected, })</code> |  | [lib/src/controls/selection/klp_sliding_selection.dart:15](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L15) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/controls/selection/klp_sliding_selection.dart:24](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L24) |
| field <code>selectedIndex</code> | public | <code>final int selectedIndex</code> |  | [lib/src/controls/selection/klp_sliding_selection.dart:25](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L25) |
| field <code>options</code> | public | <code>final List&lt;KlpSelectionOption&gt; options</code> |  | [lib/src/controls/selection/klp_sliding_selection.dart:26](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L26) |
| field <code>onSelected</code> | public | <code>final ValueChanged&lt;int&gt;? onSelected</code> |  | [lib/src/controls/selection/klp_sliding_selection.dart:27](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L27) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/controls/selection/klp_sliding_selection.dart:29](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L29) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
