# klp_table_line.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart)

## 範圍

核心是 `lib/src/features/collections/advanced/internal/klp_table_line.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_table_line.dart"]
	n1["../klp_advanced_data.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_advanced_data.dart&#x27;;</code> | [lib/src/features/collections/advanced/internal/klp_table_line.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpTableLine"]
```

```mermaid
classDiagram
	class n0["_KlpTableLine"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpTableLine

ClassDeclaration · private · [lib/src/features/collections/advanced/internal/klp_table_line.dart:3](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L3)

<code>class _KlpTableLine extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/features/collections/advanced/internal/klp_table_line.dart:3](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpTableLine</code> | private | <code>const _KlpTableLine({ required this.columns, required this.values, this.header = false, this.rowId, this.selectable = false, this.selected = false, this.sort, this.onPressed, this.onSelectionChanged, this.onSort, })</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:4](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L4) |
| field <code>columns</code> | public | <code>final List&lt;KlpDataColumn&gt; columns</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:17](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L17) |
| field <code>values</code> | public | <code>final Map&lt;String, Object?&gt; values</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:18](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L18) |
| field <code>header</code> | public | <code>final bool header</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:19](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L19) |
| field <code>rowId</code> | public | <code>final String? rowId</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:20](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L20) |
| field <code>selectable</code> | public | <code>final bool selectable</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:21](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L21) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:22](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L22) |
| field <code>sort</code> | public | <code>final KlpDataSort? sort</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:23](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L23) |
| field <code>onPressed</code> | public | <code>final VoidCallback? onPressed</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:24](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L24) |
| field <code>onSelectionChanged</code> | public | <code>final ValueChanged&lt;bool&gt;? onSelectionChanged</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:25](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L25) |
| field <code>onSort</code> | public | <code>final ValueChanged&lt;String&gt;? onSort</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:26](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L26) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:28](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L28) |
| method <code>_buildCell</code> | private | <code>Widget _buildCell(_KlpAdvancedStyle style, KlpDataColumn column)</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:58](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L58) |
| method <code>_buildValue</code> | private | <code>Widget _buildValue(KlpDataColumn column)</code> |  | [lib/src/features/collections/advanced/internal/klp_table_line.dart:92](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L92) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
