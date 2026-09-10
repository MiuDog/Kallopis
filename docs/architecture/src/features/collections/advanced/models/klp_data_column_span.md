# klp_data_column_span.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart)

## 範圍

核心是 `lib/src/features/collections/advanced/models/klp_data_column_span.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_data_column_span.dart"]
	n1["klp_advanced_models.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_advanced_models.dart&#x27;;</code> | [lib/src/features/collections/advanced/models/klp_data_column_span.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDataColumnSpan"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDataColumnSpan

EnumDeclaration · public · [lib/src/features/collections/advanced/models/klp_data_column_span.dart:3](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart#L3)

<code>enum KlpDataColumnSpan</code>

來源註解摘要：資料表欄位相對於其他欄位所占的比例。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>single</code> | public | <code>single</code> |  | [lib/src/features/collections/advanced/models/klp_data_column_span.dart:5](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart#L5) |
| enum value <code>double</code> | public | <code>double</code> |  | [lib/src/features/collections/advanced/models/klp_data_column_span.dart:6](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart#L6) |
| enum value <code>triple</code> | public | <code>triple</code> |  | [lib/src/features/collections/advanced/models/klp_data_column_span.dart:7](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart#L7) |
| constructor <code>KlpDataColumnSpan</code> | public | <code>const KlpDataColumnSpan(this.flex)</code> |  | [lib/src/features/collections/advanced/models/klp_data_column_span.dart:9](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart#L9) |
| field <code>flex</code> | public | <code>final int flex</code> |  | [lib/src/features/collections/advanced/models/klp_data_column_span.dart:11](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart#L11) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
