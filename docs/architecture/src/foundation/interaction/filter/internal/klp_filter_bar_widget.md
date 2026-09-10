# klp_filter_bar_widget.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart)

## 範圍

核心是 `lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_filter_bar_widget.dart"]
	n1["../klp_filter_bar.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_filter_bar.dart&#x27;;</code> | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:1](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFilterBar"]
```

```mermaid
classDiagram
	class n0["KlpFilterBar"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFilterBar

ClassDeclaration · public · [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:3](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L3)

<code>class KlpFilterBar extends StatelessWidget</code>

來源註解摘要：篩選工具列。支援標籤、鍵值對、移除按鈕與新增篩選動作。

- `extends` → <code>StatelessWidget</code>：[lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:4](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFilterBar</code> | public | <code>const KlpFilterBar({ super.key, required this.filters, required this.selectedId, required this.onSelected, this.onRemove, this.onAddFilter, this.onClearAll, this.addLabel = &#x27;+ Filter&#x27;, this.clearAllLabel = &#x27;Clear all&#x27;, this.leading, this.trailing, })</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:5](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L5) |
| field <code>filters</code> | public | <code>final List&lt;KlpFilterOption&gt; filters</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:19](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L19) |
| field <code>selectedId</code> | public | <code>final String? selectedId</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:20](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L20) |
| field <code>onSelected</code> | public | <code>final ValueChanged&lt;String&gt; onSelected</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:21](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L21) |
| field <code>onRemove</code> | public | <code>final ValueChanged&lt;String&gt;? onRemove</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:22](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L22) |
| field <code>onAddFilter</code> | public | <code>final VoidCallback? onAddFilter</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:23](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L23) |
| field <code>onClearAll</code> | public | <code>final VoidCallback? onClearAll</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:24](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L24) |
| field <code>addLabel</code> | public | <code>final String addLabel</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:25](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L25) |
| field <code>clearAllLabel</code> | public | <code>final String clearAllLabel</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:26](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L26) |
| field <code>leading</code> | public | <code>final Widget? leading</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:27](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L27) |
| field <code>trailing</code> | public | <code>final Widget? trailing</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:28](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L28) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart:30](../../../../../../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart#L30) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
