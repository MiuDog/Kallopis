# klp_space.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/metrics/klp_space.dart)

## 範圍

核心是 `lib/src/foundation/metrics/klp_space.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_space.dart"]
	n1["../klp_metrics.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_metrics.dart&#x27;;</code> | [lib/src/foundation/metrics/klp_space.dart:1](../../../../../lib/src/foundation/metrics/klp_space.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSpace"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSpace

ClassDeclaration · public · [lib/src/foundation/metrics/klp_space.dart:3](../../../../../lib/src/foundation/metrics/klp_space.dart#L3)

<code>abstract final class KlpSpace</code>

來源註解摘要：舊版 static const 間距階梯；新元件必須改讀 context.klp.space。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>xxs</code> | public | <code>static const double xxs</code> |  | [lib/src/foundation/metrics/klp_space.dart:5](../../../../../lib/src/foundation/metrics/klp_space.dart#L5) |
| field <code>xs</code> | public | <code>static const double xs</code> |  | [lib/src/foundation/metrics/klp_space.dart:6](../../../../../lib/src/foundation/metrics/klp_space.dart#L6) |
| field <code>sm</code> | public | <code>static const double sm</code> |  | [lib/src/foundation/metrics/klp_space.dart:7](../../../../../lib/src/foundation/metrics/klp_space.dart#L7) |
| field <code>md</code> | public | <code>static const double md</code> |  | [lib/src/foundation/metrics/klp_space.dart:8](../../../../../lib/src/foundation/metrics/klp_space.dart#L8) |
| field <code>lg</code> | public | <code>static const double lg</code> |  | [lib/src/foundation/metrics/klp_space.dart:9](../../../../../lib/src/foundation/metrics/klp_space.dart#L9) |
| field <code>xl</code> | public | <code>static const double xl</code> |  | [lib/src/foundation/metrics/klp_space.dart:10](../../../../../lib/src/foundation/metrics/klp_space.dart#L10) |
| field <code>xxl</code> | public | <code>static const double xxl</code> |  | [lib/src/foundation/metrics/klp_space.dart:11](../../../../../lib/src/foundation/metrics/klp_space.dart#L11) |
| field <code>sectionLarge</code> | public | <code>static const double sectionLarge</code> |  | [lib/src/foundation/metrics/klp_space.dart:12](../../../../../lib/src/foundation/metrics/klp_space.dart#L12) |
| field <code>page</code> | public | <code>static const double page</code> |  | [lib/src/foundation/metrics/klp_space.dart:13](../../../../../lib/src/foundation/metrics/klp_space.dart#L13) |
| field <code>pageLarge</code> | public | <code>static const double pageLarge</code> |  | [lib/src/foundation/metrics/klp_space.dart:14](../../../../../lib/src/foundation/metrics/klp_space.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
