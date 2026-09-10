# klp_state_controller.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart)

## 範圍

核心是 `lib/src/capabilities/controllers/klp_state_controller.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_state_controller.dart"]
	n1["../state/klp_state.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../state/klp_state.dart&#x27;;</code> | [lib/src/capabilities/controllers/klp_state_controller.dart:1](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStateController"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStateController

ClassDeclaration · public · [lib/src/capabilities/controllers/klp_state_controller.dart:3](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L3)

<code>final class KlpStateController&lt;T&gt;</code>

來源註解摘要：控制器僅借用狀態來源，不快取值，也不替來源擁有者釋放資源。 同時只允許一個附接；解除後可重新附接，釋放後不可再使用。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_state</code> | private | <code>KlpState&lt;T&gt;? _state</code> |  | [lib/src/capabilities/controllers/klp_state_controller.dart:8](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L8) |
| field <code>_isDisposed</code> | private | <code>bool _isDisposed</code> |  | [lib/src/capabilities/controllers/klp_state_controller.dart:9](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L9) |
| getter <code>isDisposed</code> | public | <code>bool get isDisposed</code> |  | [lib/src/capabilities/controllers/klp_state_controller.dart:11](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L11) |
| getter <code>isAttached</code> | public | <code>bool get isAttached</code> |  | [lib/src/capabilities/controllers/klp_state_controller.dart:12](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L12) |
| getter <code>state</code> | public | <code>KlpState&lt;T&gt; get state</code> |  | [lib/src/capabilities/controllers/klp_state_controller.dart:14](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L14) |
| method <code>attach</code> | public | <code>void attach(KlpState&lt;T&gt; source)</code> |  | [lib/src/capabilities/controllers/klp_state_controller.dart:24](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L24) |
| method <code>detach</code> | public | <code>void detach()</code> |  | [lib/src/capabilities/controllers/klp_state_controller.dart:33](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L33) |
| method <code>dispose</code> | public | <code>void dispose()</code> |  | [lib/src/capabilities/controllers/klp_state_controller.dart:42](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L42) |
| method <code>_requireActive</code> | private | <code>void _requireActive()</code> |  | [lib/src/capabilities/controllers/klp_state_controller.dart:49](../../../../../lib/src/capabilities/controllers/klp_state_controller.dart#L49) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
