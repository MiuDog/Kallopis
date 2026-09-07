# klp_select_field.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/form/selection/klp_select_field.dart)

## 範圍

核心是 `lib/src/form/selection/klp_select_field.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_select_field.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n2["klp_choice_option.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/form/selection/klp_select_field.dart:1](../../../../../lib/src/form/selection/klp_select_field.dart#L1) |
| import | <code>import &#x27;klp_choice_option.dart&#x27;;</code> | [lib/src/form/selection/klp_select_field.dart:2](../../../../../lib/src/form/selection/klp_select_field.dart#L2) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSelectField"]
	class n1["_KlpSelectFieldState"]
```

```mermaid
classDiagram
	class n0["KlpSelectField"]
	class n1["StatefulWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["_KlpSelectFieldState"]
	class n1["State&lt;KlpSelectField&gt;"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSelectField

ClassDeclaration · public · [lib/src/form/selection/klp_select_field.dart:4](../../../../../lib/src/form/selection/klp_select_field.dart#L4)

<code>class KlpSelectField extends StatefulWidget</code>

來源註解摘要：單選下拉欄位：目前值顯示為一列文字，點擊展開選項清單並就地插入版面 （不是彈出層），選中後自動收合。 [valueLabel] 是呼叫端算好的顯示文字，不會反查 [options] 對應哪一項—— 這個元件不知道「目前選的是哪個 id」，只負責畫出清單與回報點擊。 需要彈出式選單而非就地展開時請改用 [KlpMenu]。

- `extends` → <code>StatefulWidget</code>：[lib/src/form/selection/klp_select_field.dart:10](../../../../../lib/src/form/selection/klp_select_field.dart#L10)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSelectField</code> | public | <code>const KlpSelectField({ super.key, required this.label, required this.valueLabel, required this.options, required this.onSelected, this.enabled = true, this.readOnly = false, this.error, })</code> |  | [lib/src/form/selection/klp_select_field.dart:11](../../../../../lib/src/form/selection/klp_select_field.dart#L11) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/form/selection/klp_select_field.dart:22](../../../../../lib/src/form/selection/klp_select_field.dart#L22) |
| field <code>valueLabel</code> | public | <code>final String valueLabel</code> |  | [lib/src/form/selection/klp_select_field.dart:23](../../../../../lib/src/form/selection/klp_select_field.dart#L23) |
| field <code>options</code> | public | <code>final List&lt;KlpChoiceOption&gt; options</code> |  | [lib/src/form/selection/klp_select_field.dart:24](../../../../../lib/src/form/selection/klp_select_field.dart#L24) |
| field <code>onSelected</code> | public | <code>final ValueChanged&lt;String&gt;? onSelected</code> |  | [lib/src/form/selection/klp_select_field.dart:25](../../../../../lib/src/form/selection/klp_select_field.dart#L25) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/form/selection/klp_select_field.dart:26](../../../../../lib/src/form/selection/klp_select_field.dart#L26) |
| field <code>readOnly</code> | public | <code>final bool readOnly</code> |  | [lib/src/form/selection/klp_select_field.dart:27](../../../../../lib/src/form/selection/klp_select_field.dart#L27) |
| field <code>error</code> | public | <code>final String? error</code> |  | [lib/src/form/selection/klp_select_field.dart:28](../../../../../lib/src/form/selection/klp_select_field.dart#L28) |
| method <code>createState</code> | public | <code>State&lt;KlpSelectField&gt; createState()</code> |  | [lib/src/form/selection/klp_select_field.dart:30](../../../../../lib/src/form/selection/klp_select_field.dart#L30) |

### _KlpSelectFieldState

ClassDeclaration · private · [lib/src/form/selection/klp_select_field.dart:33](../../../../../lib/src/form/selection/klp_select_field.dart#L33)

<code>class _KlpSelectFieldState extends State&lt;KlpSelectField&gt;</code>

- `extends` → <code>State&lt;KlpSelectField&gt;</code>：[lib/src/form/selection/klp_select_field.dart:33](../../../../../lib/src/form/selection/klp_select_field.dart#L33)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_expanded</code> | private | <code>bool _expanded</code> |  | [lib/src/form/selection/klp_select_field.dart:34](../../../../../lib/src/form/selection/klp_select_field.dart#L34) |
| field <code>_hovered</code> | private | <code>bool _hovered</code> |  | [lib/src/form/selection/klp_select_field.dart:35](../../../../../lib/src/form/selection/klp_select_field.dart#L35) |
| field <code>_focused</code> | private | <code>bool _focused</code> |  | [lib/src/form/selection/klp_select_field.dart:36](../../../../../lib/src/form/selection/klp_select_field.dart#L36) |
| getter <code>_interactive</code> | private | <code>bool get _interactive</code> |  | [lib/src/form/selection/klp_select_field.dart:38](../../../../../lib/src/form/selection/klp_select_field.dart#L38) |
| method <code>_setHovered</code> | private | <code>void _setHovered(bool value)</code> |  | [lib/src/form/selection/klp_select_field.dart:40](../../../../../lib/src/form/selection/klp_select_field.dart#L40) |
| method <code>_setFocused</code> | private | <code>void _setFocused(bool value)</code> |  | [lib/src/form/selection/klp_select_field.dart:46](../../../../../lib/src/form/selection/klp_select_field.dart#L46) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/form/selection/klp_select_field.dart:52](../../../../../lib/src/form/selection/klp_select_field.dart#L52) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
