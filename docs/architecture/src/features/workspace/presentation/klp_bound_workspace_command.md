# klp_bound_workspace_command.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart)

## 範圍

核心是 `lib/src/features/workspace/presentation/klp_bound_workspace_command.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_bound_workspace_command.dart"]
	n1["klp_workspace_presentation.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_workspace_presentation.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:1](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoundWorkspaceCommand"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoundWorkspaceCommand

ClassDeclaration · public · [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:3](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L3)

<code>final class KlpBoundWorkspaceCommand</code>

來源註解摘要：套件內部的唯讀命令呈現資料，攜帶輸入、確認文案與呼叫回呼。 不屬使用端 API，不自行執行產品命令或決定授權。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:6](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L6) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:7](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L7) |
| field <code>destructive</code> | public | <code>final bool destructive</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:8](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L8) |
| field <code>inputLabel</code> | public | <code>final String? inputLabel</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:9](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L9) |
| field <code>initialValue</code> | public | <code>final String? initialValue</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:10](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L10) |
| field <code>confirmation</code> | public | <code>final String? confirmation</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:11](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L11) |
| field <code>submitLabel</code> | public | <code>final String submitLabel</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:12](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L12) |
| field <code>cancelLabel</code> | public | <code>final String cancelLabel</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:13](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L13) |
| field <code>shortcut</code> | public | <code>final int? shortcut</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:14](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L14) |
| field <code>onInvoke</code> | public | <code>final void Function(String?) onInvoke</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:15](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L15) |
| constructor <code>KlpBoundWorkspaceCommand</code> | public | <code>const KlpBoundWorkspaceCommand({required this.label, required this.enabled, required this.destructive, this.inputLabel, this.initialValue, this.confirmation, required this.submitLabel, required this.cancelLabel, this.shortcut, required this.onInvoke})</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_command.dart:16](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_command.dart#L16) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
