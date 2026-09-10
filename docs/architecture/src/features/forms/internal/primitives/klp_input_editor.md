# klp_input_editor.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart)

## 範圍

核心是 `lib/src/features/forms/internal/primitives/klp_input_editor.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_input_editor.dart"]
	n1["../klp_form_dependencies.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../klp_form_dependencies.dart&#x27;;</code> | [lib/src/features/forms/internal/primitives/klp_input_editor.dart:1](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpInputEditor"]
```

```mermaid
classDiagram
	class n0["KlpInputEditor"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpInputEditor

ClassDeclaration · public · [lib/src/features/forms/internal/primitives/klp_input_editor.dart:3](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L3)

<code>class KlpInputEditor extends StatelessWidget</code>

來源註解摘要：Form recipe 共用的無外框文字編輯 primitive，不屬於公開元件 API。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/forms/internal/primitives/klp_input_editor.dart:4](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>controller</code> | public | <code>final TextEditingController? controller</code> |  | [lib/src/features/forms/internal/primitives/klp_input_editor.dart:5](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L5) |
| field <code>initialValue</code> | public | <code>final String? initialValue</code> |  | [lib/src/features/forms/internal/primitives/klp_input_editor.dart:6](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L6) |
| field <code>placeholder</code> | public | <code>final String? placeholder</code> |  | [lib/src/features/forms/internal/primitives/klp_input_editor.dart:7](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L7) |
| field <code>onChanged</code> | public | <code>final ValueChanged&lt;String&gt;? onChanged</code> |  | [lib/src/features/forms/internal/primitives/klp_input_editor.dart:8](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L8) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/features/forms/internal/primitives/klp_input_editor.dart:9](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L9) |
| field <code>readOnly</code> | public | <code>final bool readOnly</code> |  | [lib/src/features/forms/internal/primitives/klp_input_editor.dart:10](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L10) |
| constructor <code>KlpInputEditor</code> | public | <code>const KlpInputEditor({ super.key, this.controller, this.initialValue, this.placeholder, this.onChanged, required this.enabled, required this.readOnly, })</code> |  | [lib/src/features/forms/internal/primitives/klp_input_editor.dart:12](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L12) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/forms/internal/primitives/klp_input_editor.dart:22](../../../../../../../lib/src/features/forms/internal/primitives/klp_input_editor.dart#L22) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
