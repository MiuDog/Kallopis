# klp_data_column.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart)

## 範圍

核心是 `lib/src/features/collections/advanced/models/klp_data_column.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_data_column.dart"]
	n1["klp_advanced_models.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_advanced_models.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_data_column.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDataColumn"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDataColumn

ClassDeclaration · public · [lib/src/features/collections/advanced/models/klp_data_column.dart:3](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L3)

<code>class KlpDataColumn</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpDataColumn</code> | public | <code>const KlpDataColumn({ required this.id, required this.label, this.span = KlpDataColumnSpan.single, this.sortable = false, this.alignment = KlpDataAlignment.start, this.verbatim = false, })</code> |  | [lib/src/features/collections/advanced/models/klp_data_column.dart:5](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L5) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/features/collections/advanced/models/klp_data_column.dart:14](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L14) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/collections/advanced/models/klp_data_column.dart:15](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L15) |
| field <code>span</code> | public | <code>final KlpDataColumnSpan span</code> |  | [lib/src/features/collections/advanced/models/klp_data_column.dart:16](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L16) |
| field <code>sortable</code> | public | <code>final bool sortable</code> |  | [lib/src/features/collections/advanced/models/klp_data_column.dart:17](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L17) |
| field <code>alignment</code> | public | <code>final KlpDataAlignment alignment</code> |  | [lib/src/features/collections/advanced/models/klp_data_column.dart:18](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L18) |
| field <code>verbatim</code> | public | <code>final bool verbatim</code> |  | [lib/src/features/collections/advanced/models/klp_data_column.dart:19](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L19) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
