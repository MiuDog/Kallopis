# klp_date_grid.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/data/date_grid/klp_date_grid.dart)

## 範圍

核心是 `lib/src/data/date_grid/klp_date_grid.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_date_grid.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../surface/klp_surface.dart"]
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
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/data/date_grid/klp_date_grid.dart:1](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L1) |
| import | <code>import &#x27;../../surface/klp_surface.dart&#x27;;</code> | [lib/src/data/date_grid/klp_date_grid.dart:3](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L3) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/data/date_grid/klp_date_grid.dart:4](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L4) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/data/date_grid/klp_date_grid.dart:5](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDateGridItem"]
	class n1["KlpDateGrid"]
```

```mermaid
classDiagram
	class n0["KlpDateGrid"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDateGridItem

ClassDeclaration · public · [lib/src/data/date_grid/klp_date_grid.dart:7](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L7)

<code>class KlpDateGridItem</code>

來源註解摘要：日期格內容；只描述顯示資料，不擁有行事曆領域規則。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpDateGridItem</code> | public | <code>const KlpDateGridItem({ required this.label, this.lines = const [], this.selected = false, })</code> |  | [lib/src/data/date_grid/klp_date_grid.dart:10](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L10) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/data/date_grid/klp_date_grid.dart:16](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L16) |
| field <code>lines</code> | public | <code>final List&lt;String&gt; lines</code> |  | [lib/src/data/date_grid/klp_date_grid.dart:17](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L17) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/data/date_grid/klp_date_grid.dart:18](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L18) |

### KlpDateGrid

ClassDeclaration · public · [lib/src/data/date_grid/klp_date_grid.dart:21](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L21)

<code>class KlpDateGrid extends StatelessWidget</code>

來源註解摘要：一列七欄的日期概覽格。

- `extends` → <code>StatelessWidget</code>：[lib/src/data/date_grid/klp_date_grid.dart:22](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L22)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpDateGrid</code> | public | <code>const KlpDateGrid({super.key, required this.items, this.onSelected})</code> |  | [lib/src/data/date_grid/klp_date_grid.dart:23](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L23) |
| field <code>items</code> | public | <code>final List&lt;KlpDateGridItem&gt; items</code> |  | [lib/src/data/date_grid/klp_date_grid.dart:25](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L25) |
| field <code>onSelected</code> | public | <code>final ValueChanged&lt;int&gt;? onSelected</code> |  | [lib/src/data/date_grid/klp_date_grid.dart:26](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L26) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/data/date_grid/klp_date_grid.dart:28](../../../../../lib/src/data/date_grid/klp_date_grid.dart#L28) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
