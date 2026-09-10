# klp_document_edit_actions.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart)

## 範圍

核心是 `lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_document_edit_actions.dart"]
	n1["../klp_artifact_workspace.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_artifact_workspace.dart&#x27;;</code> | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:1](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDocumentEditActions"]
```

```mermaid
classDiagram
	class n0["KlpDocumentEditActions"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDocumentEditActions

ClassDeclaration · public · [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:3](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L3)

<code>class KlpDocumentEditActions extends StatelessWidget</code>

來源註解摘要：文件的進入編輯、儲存與取消動作組。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:4](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpDocumentEditActions</code> | public | <code>const KlpDocumentEditActions({ super.key, required this.editing, required this.editLabel, required this.saveLabel, required this.cancelLabel, this.onEdit, this.onSave, this.onCancel, })</code> |  | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:5](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L5) |
| field <code>editing</code> | public | <code>final bool editing</code> |  | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:16](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L16) |
| field <code>editLabel</code> | public | <code>final String editLabel</code> |  | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:17](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L17) |
| field <code>saveLabel</code> | public | <code>final String saveLabel</code> |  | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:18](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L18) |
| field <code>cancelLabel</code> | public | <code>final String cancelLabel</code> |  | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:19](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L19) |
| field <code>onEdit</code> | public | <code>final VoidCallback? onEdit</code> |  | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:20](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L20) |
| field <code>onSave</code> | public | <code>final VoidCallback? onSave</code> |  | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:21](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L21) |
| field <code>onCancel</code> | public | <code>final VoidCallback? onCancel</code> |  | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:22](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L22) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart:24](../../../../../../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart#L24) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
