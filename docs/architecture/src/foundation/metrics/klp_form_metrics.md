# klp_form_metrics.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart)

## 範圍

核心是 `lib/src/foundation/metrics/klp_form_metrics.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_form_metrics.dart"]
	n1["../klp_metrics.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_metrics.dart&#x27;;</code> | [lib/src/foundation/metrics/klp_form_metrics.dart:1](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFormMetrics"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFormMetrics

ClassDeclaration · public · [lib/src/foundation/metrics/klp_form_metrics.dart:3](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L3)

<code>abstract final class KlpFormMetrics</code>

來源註解摘要：舊版表單控制項固定幾何。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>fieldHeight</code> | public | <code>static const double fieldHeight</code> |  | [lib/src/foundation/metrics/klp_form_metrics.dart:5](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L5) |
| field <code>selectionControl</code> | public | <code>static const double selectionControl</code> |  | [lib/src/foundation/metrics/klp_form_metrics.dart:6](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L6) |
| field <code>selectionIndicatorInset</code> | public | <code>static const double selectionIndicatorInset</code> |  | [lib/src/foundation/metrics/klp_form_metrics.dart:7](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L7) |
| field <code>selectionIndicator</code> | public | <code>static const double selectionIndicator</code> |  | [lib/src/foundation/metrics/klp_form_metrics.dart:8](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L8) |
| field <code>selectionIcon</code> | public | <code>static const double selectionIcon</code> |  | [lib/src/foundation/metrics/klp_form_metrics.dart:10](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L10) |
| field <code>toggleWidth</code> | public | <code>static const double toggleWidth</code> |  | [lib/src/foundation/metrics/klp_form_metrics.dart:11](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L11) |
| field <code>toggleHeight</code> | public | <code>static const double toggleHeight</code> |  | [lib/src/foundation/metrics/klp_form_metrics.dart:12](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L12) |
| field <code>toggleThumb</code> | public | <code>static const double toggleThumb</code> |  | [lib/src/foundation/metrics/klp_form_metrics.dart:13](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L13) |
| field <code>toggleInset</code> | public | <code>static const double toggleInset</code> |  | [lib/src/foundation/metrics/klp_form_metrics.dart:14](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
