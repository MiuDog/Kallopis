# klp_bound_workspace_content.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content.dart)

## 範圍

核心是 `lib/src/features/workspace/presentation/klp_bound_workspace_content.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_bound_workspace_content.dart"]
	n1["klp_workspace_presentation.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_workspace_presentation.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_bound_workspace_content.dart:1](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoundWorkspaceContent"]
```

```mermaid
classDiagram
	class n0["KlpBoundWorkspaceContent"]
	class n1["KlpBoundTemplate"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoundWorkspaceContent

ClassDeclaration · public · [lib/src/features/workspace/presentation/klp_bound_workspace_content.dart:3](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content.dart#L3)

<code>final class KlpBoundWorkspaceContent extends KlpBoundTemplate</code>

來源註解摘要：套件內部的唯讀線性內容呈現紀錄，攜帶軸向與已綁定子項目。 不屬使用端 API，不建立另一棵使用端結構樹或正文模型。

- `extends` → <code>KlpBoundTemplate</code>：[lib/src/features/workspace/presentation/klp_bound_workspace_content.dart:5](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content.dart#L5)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>axis</code> | public | <code>final int axis</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content.dart:6](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content.dart#L6) |
| field <code>children</code> | public | <code>final List&lt;KlpBoundTemplate&gt; children</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content.dart:7](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content.dart#L7) |
| constructor <code>KlpBoundWorkspaceContent</code> | public | <code>KlpBoundWorkspaceContent({required this.axis, required Iterable&lt;KlpBoundTemplate&gt; children})</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content.dart:8](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content.dart#L8) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
