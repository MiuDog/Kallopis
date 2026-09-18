# klp_editor_mode_request.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_editor_mode_request.dart"]
	n1["klp_editing_stamp.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;klp_editing_stamp.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpEditorModeRequest"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpEditorModeRequest

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart:3](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart#L3)

<code>final class KlpEditorModeRequest</code>

來源註解摘要：模式確認只攜帶註冊 ID、完整 stamp 與全 editor 共用序號。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>sequence</code> | public | <code>final int sequence</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart:5](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart#L5) |
| field <code>expected</code> | public | <code>final KlpEditingStamp expected</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart#L6) |
| field <code>modeRevision</code> | public | <code>final int modeRevision</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart:7](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart#L7) |
| field <code>modeId</code> | public | <code>final String modeId</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart#L8) |
| field <code>toolId</code> | public | <code>final String toolId</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart#L9) |
| constructor <code>KlpEditorModeRequest</code> | public | <code>KlpEditorModeRequest({required this.sequence, required this.expected, required this.modeRevision, required this.modeId, required this.toolId})</code> |  | [lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart:11](../../../../../../lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart#L11) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
