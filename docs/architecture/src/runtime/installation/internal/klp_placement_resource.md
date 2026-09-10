# klp_placement_resource.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/runtime/installation/internal/klp_placement_resource.dart)

## 範圍

核心是 `lib/src/runtime/installation/internal/klp_placement_resource.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_placement_resource.dart"]
	n1["../../../composition/validation/klp_validated_node.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/runtime/installation/internal/klp_placement_resource.dart:1](../../../../../../lib/src/runtime/installation/internal/klp_placement_resource.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPlacementResource"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPlacementResource

ClassDeclaration · public · [lib/src/runtime/installation/internal/klp_placement_resource.dart:3](../../../../../../lib/src/runtime/installation/internal/klp_placement_resource.dart#L3)

<code>abstract interface class KlpPlacementResource</code>

來源註解摘要：本庫安裝器持有的放置資源，不是消費端可注入的功能工廠。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| method <code>update</code> | public | <code>void update(KlpValidatedNode node)</code> | 先提交本地資料再通知；通知拋錯時已提交的資料不得退回。 | [lib/src/runtime/installation/internal/klp_placement_resource.dart:5](../../../../../../lib/src/runtime/installation/internal/klp_placement_resource.dart#L5) |
| method <code>dispose</code> | public | <code>void dispose()</code> | 必須使本地資源終止且可重複呼叫，完成清理後才可回報外部錯誤。 | [lib/src/runtime/installation/internal/klp_placement_resource.dart:8](../../../../../../lib/src/runtime/installation/internal/klp_placement_resource.dart#L8) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
