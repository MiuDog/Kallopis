# klp_field_group.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/form/core/klp_field_group.dart)

## 範圍

核心是 `lib/src/form/core/klp_field_group.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_field_group.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n2["klp_field.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/form/core/klp_field_group.dart:1](../../../../../lib/src/form/core/klp_field_group.dart#L1) |
| import | <code>import &#x27;klp_field.dart&#x27;;</code> | [lib/src/form/core/klp_field_group.dart:3](../../../../../lib/src/form/core/klp_field_group.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFieldGroup"]
```

```mermaid
classDiagram
	class n0["KlpFieldGroup"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFieldGroup

ClassDeclaration · public · [lib/src/form/core/klp_field_group.dart:5](../../../../../lib/src/form/core/klp_field_group.dart#L5)

<code>class KlpFieldGroup extends StatelessWidget</code>

來源註解摘要：把多個相關輸入（例如一組 checkbox）當成單一 [KlpField] 呈現，用 [legend] 取代單一欄位的 `label`。 內部直接委派給 [KlpField]，因此標籤／錯誤的排版與單一欄位完全一致； 差別只在 `child` 換成 [children] 這組垂直排列的子項目。

- `extends` → <code>StatelessWidget</code>：[lib/src/form/core/klp_field_group.dart:10](../../../../../lib/src/form/core/klp_field_group.dart#L10)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFieldGroup</code> | public | <code>const KlpFieldGroup({ super.key, required this.legend, required this.children, this.error, })</code> |  | [lib/src/form/core/klp_field_group.dart:11](../../../../../lib/src/form/core/klp_field_group.dart#L11) |
| field <code>legend</code> | public | <code>final String legend</code> |  | [lib/src/form/core/klp_field_group.dart:18](../../../../../lib/src/form/core/klp_field_group.dart#L18) |
| field <code>children</code> | public | <code>final List&lt;Widget&gt; children</code> |  | [lib/src/form/core/klp_field_group.dart:19](../../../../../lib/src/form/core/klp_field_group.dart#L19) |
| field <code>error</code> | public | <code>final String? error</code> |  | [lib/src/form/core/klp_field_group.dart:20](../../../../../lib/src/form/core/klp_field_group.dart#L20) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/form/core/klp_field_group.dart:22](../../../../../lib/src/form/core/klp_field_group.dart#L22) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
