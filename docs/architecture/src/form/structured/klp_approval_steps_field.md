# klp_approval_steps_field.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/form/structured/klp_approval_steps_field.dart)

## 範圍

核心是 `lib/src/form/structured/klp_approval_steps_field.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_approval_steps_field.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/form/structured/klp_approval_steps_field.dart:1](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpApprovalStepData"]
	class n1["KlpApprovalStepsField"]
```

```mermaid
classDiagram
	class n0["KlpApprovalStepsField"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpApprovalStepData

ClassDeclaration · public · [lib/src/form/structured/klp_approval_steps_field.dart:3](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L3)

<code>class KlpApprovalStepData</code>

來源註解摘要：審批步驟資料。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpApprovalStepData</code> | public | <code>const KlpApprovalStepData({required this.id, required this.roleLabel})</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:6](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L6) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:8](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L8) |
| field <code>roleLabel</code> | public | <code>final String roleLabel</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:9](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L9) |

### KlpApprovalStepsField

ClassDeclaration · public · [lib/src/form/structured/klp_approval_steps_field.dart:11](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L11)

<code>class KlpApprovalStepsField extends StatelessWidget</code>

來源註解摘要：審批步驟排序欄位。支援步驟上下移動、刪除與新增。

- `extends` → <code>StatelessWidget</code>：[lib/src/form/structured/klp_approval_steps_field.dart:12](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L12)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpApprovalStepsField</code> | public | <code>const KlpApprovalStepsField({ super.key, required this.label, this.subtitle, required this.steps, this.onAddStep, this.onMoveUp, this.onMoveDown, this.onRemove, this.maxSteps, })</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:13](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L13) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:25](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L25) |
| field <code>subtitle</code> | public | <code>final String? subtitle</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:26](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L26) |
| field <code>steps</code> | public | <code>final List&lt;KlpApprovalStepData&gt; steps</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:27](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L27) |
| field <code>onAddStep</code> | public | <code>final VoidCallback? onAddStep</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:28](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L28) |
| field <code>onMoveUp</code> | public | <code>final ValueChanged&lt;int&gt;? onMoveUp</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:29](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L29) |
| field <code>onMoveDown</code> | public | <code>final ValueChanged&lt;int&gt;? onMoveDown</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:30](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L30) |
| field <code>onRemove</code> | public | <code>final ValueChanged&lt;int&gt;? onRemove</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:31](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L31) |
| field <code>maxSteps</code> | public | <code>final int? maxSteps</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:32](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L32) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/form/structured/klp_approval_steps_field.dart:34](../../../../../lib/src/form/structured/klp_approval_steps_field.dart#L34) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
