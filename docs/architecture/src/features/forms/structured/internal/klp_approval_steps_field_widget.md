# klp_approval_steps_field_widget.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart)

## 範圍

核心是 `lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_approval_steps_field_widget.dart"]
	n1["../klp_approval_steps_field.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_approval_steps_field.dart&#x27;;</code> | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:1](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpApprovalStepsField"]
```

```mermaid
classDiagram
	class n0["KlpApprovalStepsField"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpApprovalStepsField

ClassDeclaration · public · [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:3](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L3)

<code>class KlpApprovalStepsField extends StatelessWidget</code>

來源註解摘要：審批步驟排序欄位。支援步驟上下移動、刪除與新增。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:4](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpApprovalStepsField</code> | public | <code>const KlpApprovalStepsField({ super.key, required this.label, this.subtitle, required this.steps, this.onAddStep, this.onMoveUp, this.onMoveDown, this.onRemove, this.maxSteps, })</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:5](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L5) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:17](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L17) |
| field <code>subtitle</code> | public | <code>final String? subtitle</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:18](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L18) |
| field <code>steps</code> | public | <code>final List&lt;KlpApprovalStepData&gt; steps</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:19](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L19) |
| field <code>onAddStep</code> | public | <code>final VoidCallback? onAddStep</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:20](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L20) |
| field <code>onMoveUp</code> | public | <code>final ValueChanged&lt;int&gt;? onMoveUp</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:21](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L21) |
| field <code>onMoveDown</code> | public | <code>final ValueChanged&lt;int&gt;? onMoveDown</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:22](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L22) |
| field <code>onRemove</code> | public | <code>final ValueChanged&lt;int&gt;? onRemove</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:23](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L23) |
| field <code>maxSteps</code> | public | <code>final int? maxSteps</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:24](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L24) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:26](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L26) |
| method <code>_buildAction</code> | private | <code>Widget _buildAction({ required int index, required String label, required ValueChanged&lt;int&gt;? onPressed, })</code> |  | [lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart:99](../../../../../../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart#L99) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
