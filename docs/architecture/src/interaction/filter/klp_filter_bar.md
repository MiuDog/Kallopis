# klp_filter_bar.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/interaction/filter/klp_filter_bar.dart)

## 範圍

核心是 `lib/src/interaction/filter/klp_filter_bar.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_filter_bar.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../foundation/klp_icon.dart"]
	n3["../../foundation/klp_icons.dart"]
	n4["../../interaction/klp_pressable.dart"]
	n5["../../surface/klp_dashed_border.dart"]
	n6["../../theme/klp_theme.dart"]
	n7["../../typography/klp_text.dart"]
	n8["klp_filter_models.dart"]
	n9["klp_filter_models.dart"]
	n10["klp_presence_indicator.dart"]
	n11["klp_selection_toolbar.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"export"| n9
	n0 -->|"export"| n10
	n0 -->|"export"| n11
```

```mermaid
flowchart TD
	n0["klp_filter_bar.dart"]
	n1["klp_shortcut_hint.dart"]
	n0 -->|"export"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:1](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L1) |
| import | <code>import &#x27;../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:3](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L3) |
| import | <code>import &#x27;../../foundation/klp_icons.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:4](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L4) |
| import | <code>import &#x27;../../interaction/klp_pressable.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:5](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L5) |
| import | <code>import &#x27;../../surface/klp_dashed_border.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:6](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L6) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:7](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L7) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:8](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L8) |
| import | <code>import &#x27;klp_filter_models.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:9](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L9) |
| export | <code>export &#x27;klp_filter_models.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:11](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L11) |
| export | <code>export &#x27;klp_presence_indicator.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:12](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L12) |
| export | <code>export &#x27;klp_selection_toolbar.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:13](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L13) |
| export | <code>export &#x27;klp_shortcut_hint.dart&#x27;;</code> | [lib/src/interaction/filter/klp_filter_bar.dart:14](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L14) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFilterBar"]
	class n1["_KlpFilterChip"]
```

```mermaid
classDiagram
	class n0["KlpFilterBar"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["_KlpFilterChip"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFilterBar

ClassDeclaration · public · [lib/src/interaction/filter/klp_filter_bar.dart:16](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L16)

<code>class KlpFilterBar extends StatelessWidget</code>

來源註解摘要：篩選工具列。支援標籤、鍵值對、移除按鈕與新增篩選動作。

- `extends` → <code>StatelessWidget</code>：[lib/src/interaction/filter/klp_filter_bar.dart:17](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L17)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFilterBar</code> | public | <code>const KlpFilterBar({ super.key, required this.filters, required this.selectedId, required this.onSelected, this.onRemove, this.onAddFilter, this.onClearAll, this.addLabel = &#x27;+ Filter&#x27;, this.clearAllLabel = &#x27;Clear all&#x27;, this.leading, this.trailing, })</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:18](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L18) |
| field <code>filters</code> | public | <code>final List&lt;KlpFilterOption&gt; filters</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:32](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L32) |
| field <code>selectedId</code> | public | <code>final String? selectedId</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:33](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L33) |
| field <code>onSelected</code> | public | <code>final ValueChanged&lt;String&gt; onSelected</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:34](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L34) |
| field <code>onRemove</code> | public | <code>final ValueChanged&lt;String&gt;? onRemove</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:35](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L35) |
| field <code>onAddFilter</code> | public | <code>final VoidCallback? onAddFilter</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:36](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L36) |
| field <code>onClearAll</code> | public | <code>final VoidCallback? onClearAll</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:37](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L37) |
| field <code>addLabel</code> | public | <code>final String addLabel</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:38](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L38) |
| field <code>clearAllLabel</code> | public | <code>final String clearAllLabel</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:39](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L39) |
| field <code>leading</code> | public | <code>final Widget? leading</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:40](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L40) |
| field <code>trailing</code> | public | <code>final Widget? trailing</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:41](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L41) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:43](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L43) |

### _KlpFilterChip

ClassDeclaration · private · [lib/src/interaction/filter/klp_filter_bar.dart:108](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L108)

<code>class _KlpFilterChip extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/interaction/filter/klp_filter_bar.dart:108](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L108)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpFilterChip</code> | private | <code>const _KlpFilterChip({ required this.label, this.value, required this.selected, required this.onPressed, this.onRemove, })</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:109](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L109) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:117](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L117) |
| field <code>value</code> | public | <code>final String? value</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:118](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L118) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:119](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L119) |
| field <code>onPressed</code> | public | <code>final VoidCallback onPressed</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:120](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L120) |
| field <code>onRemove</code> | public | <code>final VoidCallback? onRemove</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:121](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L121) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/interaction/filter/klp_filter_bar.dart:123](../../../../../lib/src/interaction/filter/klp_filter_bar.dart#L123) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
