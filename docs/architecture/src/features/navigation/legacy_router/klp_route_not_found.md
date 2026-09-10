# klp_route_not_found.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart)

## 範圍

核心是 `lib/src/features/navigation/legacy_router/klp_route_not_found.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_route_not_found.dart"]
	n1["klp_router.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_router.dart&#x27;;</code> | [lib/src/features/navigation/legacy_router/klp_route_not_found.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpRouteNotFound"]
```

```mermaid
classDiagram
	class n0["KlpRouteNotFound"]
	class n1["Error"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpRouteNotFound

ClassDeclaration · public · [lib/src/features/navigation/legacy_router/klp_route_not_found.dart:3](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart#L3)

<code>class KlpRouteNotFound extends Error</code>

來源註解摘要：找不到已註冊目的地時拋出的明確程式錯誤。

- `extends` → <code>Error</code>：[lib/src/features/navigation/legacy_router/klp_route_not_found.dart:4](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpRouteNotFound</code> | public | <code>KlpRouteNotFound(this.id, this.known)</code> |  | [lib/src/features/navigation/legacy_router/klp_route_not_found.dart:5](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart#L5) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/features/navigation/legacy_router/klp_route_not_found.dart:7](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart#L7) |
| field <code>known</code> | public | <code>final Iterable&lt;String&gt; known</code> |  | [lib/src/features/navigation/legacy_router/klp_route_not_found.dart:8](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart#L8) |
| method <code>toString</code> | public | <code>String toString()</code> |  | [lib/src/features/navigation/legacy_router/klp_route_not_found.dart:10](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart#L10) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
