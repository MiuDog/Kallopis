# klp_pagination.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/controls/klp_pagination.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_pagination.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../actions/button/klp_button.dart"]
	n3["../../../../foundation/layout/klp_gap.dart"]
	n4["../../../../foundation/layout/klp_row.dart"]
	n5["../../../../foundation/layout/klp_space_size.dart"]
	n6["../../../../foundation/content/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:1](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L1) |
| import | <code>import &#x27;../../../actions/button/klp_button.dart&#x27;;</code> | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:3](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L3) |
| import | <code>import &#x27;../../../../foundation/layout/klp_gap.dart&#x27;;</code> | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:4](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L4) |
| import | <code>import &#x27;../../../../foundation/layout/klp_row.dart&#x27;;</code> | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:5](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L5) |
| import | <code>import &#x27;../../../../foundation/layout/klp_space_size.dart&#x27;;</code> | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:6](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L6) |
| import | <code>import &#x27;../../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:7](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L7) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPagination"]
```

```mermaid
classDiagram
	class n0["KlpPagination"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPagination

ClassDeclaration · public · [lib/src/features/navigation/widgets/controls/klp_pagination.dart:9](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L9)

<code>class KlpPagination extends StatelessWidget</code>

來源註解摘要：上一頁／頁碼／下一頁的受控分頁元件。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/navigation/widgets/controls/klp_pagination.dart:10](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L10)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPagination</code> | public | <code>const KlpPagination({ super.key, required this.page, required this.pageCount, required this.previousLabel, required this.nextLabel, required this.onPageChanged, })</code> |  | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:11](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L11) |
| field <code>page</code> | public | <code>final int page</code> |  | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:20](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L20) |
| field <code>pageCount</code> | public | <code>final int pageCount</code> |  | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:21](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L21) |
| field <code>previousLabel</code> | public | <code>final String previousLabel</code> |  | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:22](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L22) |
| field <code>nextLabel</code> | public | <code>final String nextLabel</code> |  | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:23](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L23) |
| field <code>onPageChanged</code> | public | <code>final ValueChanged&lt;int&gt;? onPageChanged</code> |  | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:24](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L24) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/navigation/widgets/controls/klp_pagination.dart:26](../../../../../../../lib/src/features/navigation/widgets/controls/klp_pagination.dart#L26) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
