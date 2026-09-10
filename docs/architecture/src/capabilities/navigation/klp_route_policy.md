# klp_route_policy.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/capabilities/navigation/klp_route_policy.dart)

## 範圍

核心是 `lib/src/capabilities/navigation/klp_route_policy.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_route_policy.dart"]
	n1["dart:async"]
	n2["klp_destination.dart"]
	n3["klp_navigation_transition.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:async&#x27;;</code> | [lib/src/capabilities/navigation/klp_route_policy.dart:1](../../../../../lib/src/capabilities/navigation/klp_route_policy.dart#L1) |
| import | <code>import &#x27;klp_destination.dart&#x27;;</code> | [lib/src/capabilities/navigation/klp_route_policy.dart:3](../../../../../lib/src/capabilities/navigation/klp_route_policy.dart#L3) |
| import | <code>import &#x27;klp_navigation_transition.dart&#x27;;</code> | [lib/src/capabilities/navigation/klp_route_policy.dart:4](../../../../../lib/src/capabilities/navigation/klp_route_policy.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpRoutePolicy"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpRoutePolicy

ClassDeclaration · public · [lib/src/capabilities/navigation/klp_route_policy.dart:6](../../../../../lib/src/capabilities/navigation/klp_route_policy.dart#L6)

<code>final class KlpRoutePolicy</code>

來源註解摘要：非視覺路由政策；畫面宣告由 application 綁定。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>destination</code> | public | <code>final KlpDestination&lt;Object?, Object?&gt; destination</code> |  | [lib/src/capabilities/navigation/klp_route_policy.dart:8](../../../../../lib/src/capabilities/navigation/klp_route_policy.dart#L8) |
| field <code>beforeEnter</code> | public | <code>final FutureOr&lt;bool&gt; Function(KlpNavigationTransition)? beforeEnter</code> |  | [lib/src/capabilities/navigation/klp_route_policy.dart:9](../../../../../lib/src/capabilities/navigation/klp_route_policy.dart#L9) |
| field <code>beforeLeave</code> | public | <code>final FutureOr&lt;bool&gt; Function(KlpNavigationTransition)? beforeLeave</code> |  | [lib/src/capabilities/navigation/klp_route_policy.dart:10](../../../../../lib/src/capabilities/navigation/klp_route_policy.dart#L10) |
| constructor <code>KlpRoutePolicy</code> | public | <code>const KlpRoutePolicy({ required this.destination, this.beforeEnter, this.beforeLeave, })</code> |  | [lib/src/capabilities/navigation/klp_route_policy.dart:12](../../../../../lib/src/capabilities/navigation/klp_route_policy.dart#L12) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
