# klp_workspace_command.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart)

## 範圍

核心是 `lib/src/features/workspace/components/klp_workspace_command.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_workspace_command.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/features/workspace/components/klp_workspace_command.dart:1](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpWorkspaceCommandShortcut"]
	class n1["KlpWorkspaceCommand"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpWorkspaceCommandShortcut

EnumDeclaration · public · [lib/src/features/workspace/components/klp_workspace_command.dart:1](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L1)

<code>enum KlpWorkspaceCommandShortcut</code>

來源註解摘要：可選快捷鍵語意；renderer 不從顯示文字推測命令用途。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>rename</code> | public | <code>rename</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:2](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L2) |
| enum value <code>delete</code> | public | <code>delete</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:2](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L2) |

### KlpWorkspaceCommand

ClassDeclaration · public · [lib/src/features/workspace/components/klp_workspace_command.dart:4](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L4)

<code>final class KlpWorkspaceCommand</code>

來源註解摘要：工作區選單命令；互動流程由 Kallopis 呈現，資料變更仍由 consumer 執行。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:6](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L6) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:7](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L7) |
| field <code>destructive</code> | public | <code>final bool destructive</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:8](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L8) |
| field <code>inputLabel</code> | public | <code>final String? inputLabel</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:9](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L9) |
| field <code>initialValue</code> | public | <code>final String? initialValue</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:10](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L10) |
| field <code>confirmation</code> | public | <code>final String? confirmation</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:11](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L11) |
| field <code>submitLabel</code> | public | <code>final String submitLabel</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:12](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L12) |
| field <code>cancelLabel</code> | public | <code>final String cancelLabel</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:13](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L13) |
| field <code>shortcut</code> | public | <code>final KlpWorkspaceCommandShortcut? shortcut</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:14](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L14) |
| field <code>onInvoke</code> | public | <code>final void Function(String?) onInvoke</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:15](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L15) |
| constructor <code>KlpWorkspaceCommand</code> | public | <code>KlpWorkspaceCommand({required this.label, this.enabled = true, this.destructive = false, this.inputLabel, this.initialValue, this.confirmation, this.submitLabel = &#x27;OK&#x27;, this.cancelLabel = &#x27;Cancel&#x27;, this.shortcut, required this.onInvoke})</code> |  | [lib/src/features/workspace/components/klp_workspace_command.dart:17](../../../../../../lib/src/features/workspace/components/klp_workspace_command.dart#L17) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
