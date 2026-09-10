# klp_form_actions.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/core/klp_form_actions.dart)

## 範圍

核心是 `lib/src/features/forms/core/klp_form_actions.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_form_actions.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/features/forms/core/klp_form_actions.dart:1](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFormActions"]
```

```mermaid
classDiagram
	class n0["KlpFormActions"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFormActions

ClassDeclaration · public · [lib/src/features/forms/core/klp_form_actions.dart:3](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L3)

<code>class KlpFormActions extends StatelessWidget</code>

來源註解摘要：表單底部的動作列：送出／取消／重設按鈕，靠右對齊並在寬度不足時自動換行。 [cancelLabel]／[resetLabel] 為 null 時對應按鈕不會出現，[submitLabel] 與 [onSubmit] 恆為必填——表單至少要能送出。[submitting] 為 true 時三個按鈕 一併停用，避免送出過程中使用者重複觸發或誤按取消／重設。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/forms/core/klp_form_actions.dart:8](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFormActions</code> | public | <code>const KlpFormActions({ super.key, required this.submitLabel, required this.onSubmit, this.cancelLabel, this.onCancel, this.resetLabel, this.onReset, this.submitting = false, })</code> |  | [lib/src/features/forms/core/klp_form_actions.dart:9](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L9) |
| field <code>submitLabel</code> | public | <code>final String submitLabel</code> |  | [lib/src/features/forms/core/klp_form_actions.dart:20](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L20) |
| field <code>onSubmit</code> | public | <code>final VoidCallback? onSubmit</code> |  | [lib/src/features/forms/core/klp_form_actions.dart:21](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L21) |
| field <code>cancelLabel</code> | public | <code>final String? cancelLabel</code> |  | [lib/src/features/forms/core/klp_form_actions.dart:22](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L22) |
| field <code>onCancel</code> | public | <code>final VoidCallback? onCancel</code> |  | [lib/src/features/forms/core/klp_form_actions.dart:23](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L23) |
| field <code>resetLabel</code> | public | <code>final String? resetLabel</code> |  | [lib/src/features/forms/core/klp_form_actions.dart:24](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L24) |
| field <code>onReset</code> | public | <code>final VoidCallback? onReset</code> |  | [lib/src/features/forms/core/klp_form_actions.dart:25](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L25) |
| field <code>submitting</code> | public | <code>final bool submitting</code> |  | [lib/src/features/forms/core/klp_form_actions.dart:26](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L26) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/forms/core/klp_form_actions.dart:28](../../../../../../lib/src/features/forms/core/klp_form_actions.dart#L28) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
