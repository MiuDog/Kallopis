# klp_placeholder_metrics.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart)

## 範圍

核心是 `lib/src/foundation/metrics/klp_placeholder_metrics.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_placeholder_metrics.dart"]
	n1["../klp_metrics.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_metrics.dart&#x27;;</code> | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:1](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPlaceholderMetrics"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPlaceholderMetrics

ClassDeclaration · public · [lib/src/foundation/metrics/klp_placeholder_metrics.dart:3](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L3)

<code>abstract final class KlpPlaceholderMetrics</code>

來源註解摘要：舊版 region placeholder 固定幾何。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>minimumHeight</code> | public | <code>static const double minimumHeight</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:5](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L5) |
| field <code>markerSize</code> | public | <code>static const double markerSize</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:6](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L6) |
| field <code>contentPaddingHorizontal</code> | public | <code>static const double contentPaddingHorizontal</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:7](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L7) |
| field <code>contentPaddingVertical</code> | public | <code>static const double contentPaddingVertical</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:8](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L8) |
| field <code>contentGap</code> | public | <code>static const double contentGap</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:9](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L9) |
| field <code>actionLeadingGap</code> | public | <code>static const double actionLeadingGap</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:10](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L10) |
| field <code>actionPaddingHorizontal</code> | public | <code>static const double actionPaddingHorizontal</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:11](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L11) |
| field <code>actionPaddingVertical</code> | public | <code>static const double actionPaddingVertical</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:12](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L12) |
| field <code>hatchBand</code> | public | <code>static const double hatchBand</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:13](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L13) |
| field <code>hatchGap</code> | public | <code>static const double hatchGap</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:14](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L14) |
| field <code>hatchStrokeWidth</code> | public | <code>static const double hatchStrokeWidth</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:15](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L15) |
| field <code>darkHatchColorMix</code> | public | <code>static const double darkHatchColorMix</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:16](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L16) |
| field <code>latentStrokeOpacity</code> | public | <code>static const double latentStrokeOpacity</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:17](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L17) |
| field <code>labelLetterSpacing</code> | public | <code>static const double labelLetterSpacing</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:18](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L18) |
| field <code>detailMaximumWidth</code> | public | <code>static const double detailMaximumWidth</code> |  | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:19](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L19) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
