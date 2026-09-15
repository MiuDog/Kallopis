# klp_editing_reply.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_editing_reply.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_editing_reply.dart"]
	n1["klp_editing_projection.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;klp_editing_projection.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_reply.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEditingDecision"]
	class n1["KlpEditingReply"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEditingDecision

EnumDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_reply.dart:3](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart#L3)

<code>enum KlpEditingDecision</code>

來源註解摘要：舊正文來源對編輯請求的裁決；畫面依回覆呈現而不重做交易。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>accepted</code> | public | <code>accepted</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_reply.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart#L4) |
| enum value <code>rejected</code> | public | <code>rejected</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_reply.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart#L4) |
| enum value <code>cancelled</code> | public | <code>cancelled</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_reply.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart#L4) |

### KlpEditingReply

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_reply.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart#L6)

<code>final class KlpEditingReply</code>

來源註解摘要：每次明確結果附帶權威投影；accepted 僅代表編輯，不代表保存成功。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>decision</code> | public | <code>final KlpEditingDecision decision</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_reply.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart#L9) |
| field <code>projection</code> | public | <code>final KlpEditingProjection projection</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_reply.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart#L10) |
| constructor <code>KlpEditingReply</code> | public | <code>const KlpEditingReply(this.decision, this.projection)</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_reply.dart:12](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_reply.dart#L12) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
