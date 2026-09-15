# klp_bound_workspace_content_block.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart)

## 範圍

核心是 `lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_bound_workspace_content_block.dart"]
	n1["klp_workspace_presentation.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_workspace_presentation.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:1](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoundWorkspaceContentBlock"]
```

```mermaid
classDiagram
	class n0["KlpBoundWorkspaceContentBlock"]
	class n1["KlpBoundTemplate"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoundWorkspaceContentBlock

ClassDeclaration · public · [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:3](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L3)

<code>final class KlpBoundWorkspaceContentBlock extends KlpBoundTemplate</code>

來源註解摘要：套件內部的唯讀內容區塊呈現紀錄，攜帶文字、勾選輸入、回呼與已綁定子項目。 不屬使用端 API，不擁有正文交易或勾選狀態。

- `extends` → <code>KlpBoundTemplate</code>：[lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:5](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L5)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>kind</code> | public | <code>final int kind</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:6](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L6) |
| field <code>text</code> | public | <code>final String text</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:7](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L7) |
| field <code>subtitle</code> | public | <code>final String? subtitle</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:8](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L8) |
| field <code>icon</code> | public | <code>final int? icon</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:9](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L9) |
| field <code>checked</code> | public | <code>final bool? checked</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:10](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L10) |
| field <code>onPressed</code> | public | <code>final void Function()? onPressed</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:11](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L11) |
| field <code>onCheckedChanged</code> | public | <code>final void Function(bool)? onCheckedChanged</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:12](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L12) |
| field <code>axis</code> | public | <code>final int axis</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:13](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L13) |
| field <code>children</code> | public | <code>final List&lt;KlpBoundTemplate&gt; children</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:14](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L14) |
| constructor <code>KlpBoundWorkspaceContentBlock</code> | public | <code>KlpBoundWorkspaceContentBlock({required this.kind, required this.text, this.subtitle, this.icon, this.checked, this.onPressed, this.onCheckedChanged, required this.axis, required Iterable&lt;KlpBoundTemplate&gt; children})</code> |  | [lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart:15](../../../../../../lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart#L15) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
