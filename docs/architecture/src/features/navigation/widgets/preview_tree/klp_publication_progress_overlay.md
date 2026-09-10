# klp_publication_progress_overlay.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_publication_progress_overlay.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../feedback/workflow/klp_finite_workflow.dart"]
	n3["../../../../foundation/interaction/primitives/klp_pointer_blocker.dart"]
	n4["../../../../foundation/layout/klp_positioned.dart"]
	n5["../../../../foundation/layout/klp_stack.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:1](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L1) |
| import | <code>import &#x27;../../../feedback/workflow/klp_finite_workflow.dart&#x27;;</code> | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:3](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L3) |
| import | <code>import &#x27;../../../../foundation/interaction/primitives/klp_pointer_blocker.dart&#x27;;</code> | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:4](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L4) |
| import | <code>import &#x27;../../../../foundation/layout/klp_positioned.dart&#x27;;</code> | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:5](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L5) |
| import | <code>import &#x27;../../../../foundation/layout/klp_stack.dart&#x27;;</code> | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:6](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPublicationProgressOverlay"]
```

```mermaid
classDiagram
	class n0["KlpPublicationProgressOverlay"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPublicationProgressOverlay

ClassDeclaration · public · [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:8](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L8)

<code>class KlpPublicationProgressOverlay extends StatelessWidget</code>

來源註解摘要：長時間操作期間保持預覽內容穩定，並在其上呈現呼叫端提供的具名階段。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:9](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L9)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPublicationProgressOverlay</code> | public | <code>const KlpPublicationProgressOverlay({ super.key, required this.child, required this.visible, required this.progress, })</code> |  | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:10](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L10) |
| field <code>child</code> | public | <code>final Widget child</code> |  | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:17](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L17) |
| field <code>visible</code> | public | <code>final bool visible</code> |  | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:18](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L18) |
| field <code>progress</code> | public | <code>final KlpWorkflowProgress progress</code> |  | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:19](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L19) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart:21](../../../../../../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart#L21) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
