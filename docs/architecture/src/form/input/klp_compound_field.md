# klp_compound_field.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/form/input/klp_compound_field.dart)

## 範圍

核心是 `lib/src/form/input/klp_compound_field.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_compound_field.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n2["../internal/klp_input_editor.dart"]
	n3["../internal/klp_input_frame.dart"]
	n4["../internal/klp_input_segment_divider.dart"]
	n5["../selection/klp_choice_option.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/form/input/klp_compound_field.dart:1](../../../../../lib/src/form/input/klp_compound_field.dart#L1) |
| import | <code>import &#x27;../internal/klp_input_editor.dart&#x27;;</code> | [lib/src/form/input/klp_compound_field.dart:2](../../../../../lib/src/form/input/klp_compound_field.dart#L2) |
| import | <code>import &#x27;../internal/klp_input_frame.dart&#x27;;</code> | [lib/src/form/input/klp_compound_field.dart:3](../../../../../lib/src/form/input/klp_compound_field.dart#L3) |
| import | <code>import &#x27;../internal/klp_input_segment_divider.dart&#x27;;</code> | [lib/src/form/input/klp_compound_field.dart:4](../../../../../lib/src/form/input/klp_compound_field.dart#L4) |
| import | <code>import &#x27;../selection/klp_choice_option.dart&#x27;;</code> | [lib/src/form/input/klp_compound_field.dart:5](../../../../../lib/src/form/input/klp_compound_field.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCompoundField"]
	class n1["_KlpCompoundFieldState"]
```

```mermaid
classDiagram
	class n0["KlpCompoundField"]
	class n1["StatefulWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["_KlpCompoundFieldState"]
	class n1["State&lt;KlpCompoundField&gt;"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCompoundField

ClassDeclaration · public · [lib/src/form/input/klp_compound_field.dart:7](../../../../../lib/src/form/input/klp_compound_field.dart#L7)

<code>class KlpCompoundField extends StatefulWidget</code>

來源註解摘要：在單一控制框內組合主要文字與受控尾端選項。

- `extends` → <code>StatefulWidget</code>：[lib/src/form/input/klp_compound_field.dart:8](../../../../../lib/src/form/input/klp_compound_field.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/form/input/klp_compound_field.dart:9](../../../../../lib/src/form/input/klp_compound_field.dart#L9) |
| field <code>controller</code> | public | <code>final TextEditingController? controller</code> |  | [lib/src/form/input/klp_compound_field.dart:10](../../../../../lib/src/form/input/klp_compound_field.dart#L10) |
| field <code>initialValue</code> | public | <code>final String? initialValue</code> |  | [lib/src/form/input/klp_compound_field.dart:11](../../../../../lib/src/form/input/klp_compound_field.dart#L11) |
| field <code>placeholder</code> | public | <code>final String? placeholder</code> |  | [lib/src/form/input/klp_compound_field.dart:12](../../../../../lib/src/form/input/klp_compound_field.dart#L12) |
| field <code>selectedOptionLabel</code> | public | <code>final String selectedOptionLabel</code> |  | [lib/src/form/input/klp_compound_field.dart:13](../../../../../lib/src/form/input/klp_compound_field.dart#L13) |
| field <code>options</code> | public | <code>final List&lt;KlpChoiceOption&gt; options</code> |  | [lib/src/form/input/klp_compound_field.dart:14](../../../../../lib/src/form/input/klp_compound_field.dart#L14) |
| field <code>onChanged</code> | public | <code>final ValueChanged&lt;String&gt;? onChanged</code> |  | [lib/src/form/input/klp_compound_field.dart:15](../../../../../lib/src/form/input/klp_compound_field.dart#L15) |
| field <code>onOptionSelected</code> | public | <code>final ValueChanged&lt;String&gt;? onOptionSelected</code> |  | [lib/src/form/input/klp_compound_field.dart:16](../../../../../lib/src/form/input/klp_compound_field.dart#L16) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/form/input/klp_compound_field.dart:17](../../../../../lib/src/form/input/klp_compound_field.dart#L17) |
| field <code>readOnly</code> | public | <code>final bool readOnly</code> |  | [lib/src/form/input/klp_compound_field.dart:18](../../../../../lib/src/form/input/klp_compound_field.dart#L18) |
| field <code>error</code> | public | <code>final String? error</code> |  | [lib/src/form/input/klp_compound_field.dart:19](../../../../../lib/src/form/input/klp_compound_field.dart#L19) |
| field <code>optionsLabel</code> | public | <code>final String? optionsLabel</code> |  | [lib/src/form/input/klp_compound_field.dart:20](../../../../../lib/src/form/input/klp_compound_field.dart#L20) |
| constructor <code>KlpCompoundField</code> | public | <code>const KlpCompoundField({ super.key, required this.label, required this.selectedOptionLabel, required this.options, this.controller, this.initialValue, this.placeholder, this.onChanged, this.onOptionSelected, this.enabled = true, this.readOnly = false, this.error, this.optionsLabel, })</code> |  | [lib/src/form/input/klp_compound_field.dart:22](../../../../../lib/src/form/input/klp_compound_field.dart#L22) |
| method <code>createState</code> | public | <code>State&lt;KlpCompoundField&gt; createState()</code> |  | [lib/src/form/input/klp_compound_field.dart:38](../../../../../lib/src/form/input/klp_compound_field.dart#L38) |

### _KlpCompoundFieldState

ClassDeclaration · private · [lib/src/form/input/klp_compound_field.dart:41](../../../../../lib/src/form/input/klp_compound_field.dart#L41)

<code>class _KlpCompoundFieldState extends State&lt;KlpCompoundField&gt;</code>

- `extends` → <code>State&lt;KlpCompoundField&gt;</code>：[lib/src/form/input/klp_compound_field.dart:41](../../../../../lib/src/form/input/klp_compound_field.dart#L41)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_expanded</code> | private | <code>bool _expanded</code> |  | [lib/src/form/input/klp_compound_field.dart:42](../../../../../lib/src/form/input/klp_compound_field.dart#L42) |
| method <code>_toggleOptions</code> | private | <code>void _toggleOptions()</code> |  | [lib/src/form/input/klp_compound_field.dart:44](../../../../../lib/src/form/input/klp_compound_field.dart#L44) |
| method <code>_selectOption</code> | private | <code>void _selectOption(String id)</code> |  | [lib/src/form/input/klp_compound_field.dart:50](../../../../../lib/src/form/input/klp_compound_field.dart#L50) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/form/input/klp_compound_field.dart:55](../../../../../lib/src/form/input/klp_compound_field.dart#L55) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
