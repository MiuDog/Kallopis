# klp_editing_save_reply.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_editing_save_reply.dart"]
	n1["klp_editing_save_projection.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;klp_editing_save_projection.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEditingSaveDecision"]
	class n1["KlpEditingSaveReply"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEditingSaveDecision

EnumDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart:3](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart#L3)

<code>enum KlpEditingSaveDecision</code>

來源註解摘要：來源對保存請求的裁決，包含結果未明；不允許畫面推定保存成功。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>saved</code> | public | <code>saved</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart#L4) |
| enum value <code>rejected</code> | public | <code>rejected</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart#L4) |
| enum value <code>unknown</code> | public | <code>unknown</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart#L4) |

### KlpEditingSaveReply

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart#L6)

<code>final class KlpEditingSaveReply</code>

來源註解摘要：保存裁決與同一來源狀態投影的回覆；不持有文件內容或執行 I/O。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>decision</code> | public | <code>final KlpEditingSaveDecision decision</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart#L8) |
| field <code>projection</code> | public | <code>final KlpEditingSaveProjection projection</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart#L9) |
| constructor <code>KlpEditingSaveReply</code> | public | <code>const KlpEditingSaveReply(this.decision, this.projection)</code> |  | [lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart#L10) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
