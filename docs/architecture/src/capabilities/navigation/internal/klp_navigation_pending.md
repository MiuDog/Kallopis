# klp_navigation_pending.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart)

## 範圍

核心是 `lib/src/capabilities/navigation/internal/klp_navigation_pending.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_navigation_pending.dart"]
	n1["klp_navigation_machine.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_navigation_machine.dart&#x27;;</code> | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_NavigationPending"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _NavigationPending

ClassDeclaration · private · [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:3](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L3)

<code>final class _NavigationPending</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>candidate</code> | public | <code>final KlpNavigationSnapshot candidate</code> |  | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:4](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L4) |
| field <code>decision</code> | public | <code>final Completer&lt;KlpNavigationDecision&gt; decision</code> |  | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:5](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L5) |
| field <code>onRejected</code> | public | <code>final void Function(KlpNavigationOutcome&lt;void&gt;) onRejected</code> |  | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:6](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L6) |
| field <code>beforeEnter</code> | public | <code>final List&lt;KlpRoutePolicy&gt; beforeEnter</code> |  | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:7](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L7) |
| field <code>replaceRouteInformation</code> | public | <code>final bool replaceRouteInformation</code> |  | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:8](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L8) |
| field <code>cancellation</code> | public | <code>final Completer&lt;void&gt; cancellation</code> |  | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:9](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L9) |
| field <code>signal</code> | public | <code>late final KlpNavigationCancellation signal</code> |  | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:10](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L10) |
| field <code>onCommitted</code> | public | <code>void Function()? onCommitted</code> |  | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:14](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L14) |
| constructor <code>_NavigationPending</code> | private | <code>_NavigationPending( this.candidate, this.decision, this.onRejected, { Iterable&lt;KlpRoutePolicy&gt;? beforeEnter, this.replaceRouteInformation = false, })</code> |  | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:16](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L16) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
