# klp_calendar_range.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/forms/selection/models/klp_calendar_range.dart)

## 範圍

核心是 `lib/src/features/forms/selection/models/klp_calendar_range.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_calendar_range.dart"]
	n1["../klp_calendar.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_calendar.dart&#x27;;</code> | [lib/src/features/forms/selection/models/klp_calendar_range.dart:1](../../../../../../../lib/src/features/forms/selection/models/klp_calendar_range.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCalendarRange"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCalendarRange

ClassDeclaration · public · [lib/src/features/forms/selection/models/klp_calendar_range.dart:3](../../../../../../../lib/src/features/forms/selection/models/klp_calendar_range.dart#L3)

<code>class KlpCalendarRange</code>

來源註解摘要：一段日期區間，用於 [KlpCalendarSelectionMode.range]。 [end] 為 `null` 表示只選了起點、尚未選終點——這時 [contains] 只有 [start] 本身算落在區間內。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpCalendarRange</code> | public | <code>const KlpCalendarRange({required this.start, this.end})</code> |  | [lib/src/features/forms/selection/models/klp_calendar_range.dart:9](../../../../../../../lib/src/features/forms/selection/models/klp_calendar_range.dart#L9) |
| field <code>start</code> | public | <code>final DateTime start</code> |  | [lib/src/features/forms/selection/models/klp_calendar_range.dart:11](../../../../../../../lib/src/features/forms/selection/models/klp_calendar_range.dart#L11) |
| field <code>end</code> | public | <code>final DateTime? end</code> |  | [lib/src/features/forms/selection/models/klp_calendar_range.dart:12](../../../../../../../lib/src/features/forms/selection/models/klp_calendar_range.dart#L12) |
| method <code>contains</code> | public | <code>bool contains(DateTime date)</code> | [date] 是否落在（含端點）目前的區間內。[start] 與 [end] 先後顛倒時會自動校正。 | [lib/src/features/forms/selection/models/klp_calendar_range.dart:14](../../../../../../../lib/src/features/forms/selection/models/klp_calendar_range.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
