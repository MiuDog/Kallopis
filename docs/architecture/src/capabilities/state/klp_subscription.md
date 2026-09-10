# klp_subscription.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/capabilities/state/klp_subscription.dart)

## 範圍

核心是 `lib/src/capabilities/state/klp_subscription.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_subscription.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/capabilities/state/klp_subscription.dart:1](../../../../../lib/src/capabilities/state/klp_subscription.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSubscription"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSubscription

ClassDeclaration · public · [lib/src/capabilities/state/klp_subscription.dart:1](../../../../../lib/src/capabilities/state/klp_subscription.dart#L1)

<code>final class KlpSubscription</code>

來源註解摘要：可重複取消的訂閱；取消只移除監聽，不釋放資料來源。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_onCancel</code> | private | <code>void Function()? _onCancel</code> |  | [lib/src/capabilities/state/klp_subscription.dart:4](../../../../../lib/src/capabilities/state/klp_subscription.dart#L4) |
| constructor <code>KlpSubscription</code> | public | <code>KlpSubscription(void Function() onCancel)</code> |  | [lib/src/capabilities/state/klp_subscription.dart:6](../../../../../lib/src/capabilities/state/klp_subscription.dart#L6) |
| getter <code>isCancelled</code> | public | <code>bool get isCancelled</code> |  | [lib/src/capabilities/state/klp_subscription.dart:8](../../../../../lib/src/capabilities/state/klp_subscription.dart#L8) |
| method <code>cancel</code> | public | <code>void cancel()</code> |  | [lib/src/capabilities/state/klp_subscription.dart:10](../../../../../lib/src/capabilities/state/klp_subscription.dart#L10) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
