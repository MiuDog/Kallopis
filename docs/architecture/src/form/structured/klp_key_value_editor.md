# klp_key_value_editor.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/form/structured/klp_key_value_editor.dart)

## 範圍

核心是 `lib/src/form/structured/klp_key_value_editor.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_key_value_editor.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/form/structured/klp_key_value_editor.dart:1](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpKeyValueEntry"]
	class n1["KlpKeyValueEditor"]
```

```mermaid
classDiagram
	class n0["KlpKeyValueEditor"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpKeyValueEntry

ClassDeclaration · public · [lib/src/form/structured/klp_key_value_editor.dart:3](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L3)

<code>class KlpKeyValueEntry</code>

來源註解摘要：[KlpKeyValueEditor] 裡的一組鍵值對，[id] 用來在清單改動時識別是哪一列 （純文字的 key 可能重複或暫時是空字串，不適合當識別碼）。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpKeyValueEntry</code> | public | <code>const KlpKeyValueEntry({ required this.id, required this.keyText, required this.value, })</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:7](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L7) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:13](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L13) |
| field <code>keyText</code> | public | <code>final String keyText</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:14](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L14) |
| field <code>value</code> | public | <code>final String value</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:15](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L15) |
| method <code>copyWith</code> | public | <code>KlpKeyValueEntry copyWith({String? keyText, String? value})</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:17](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L17) |

### KlpKeyValueEditor

ClassDeclaration · public · [lib/src/form/structured/klp_key_value_editor.dart:25](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L25)

<code>class KlpKeyValueEditor extends StatelessWidget</code>

來源註解摘要：任意鍵值對清單的編輯器（例如 HTTP header、環境變數），每列一個 key 輸入 框與一個 value 輸入框。 不提供新增／刪除列的按鈕——這個元件只負責編輯既有 [entries] 的內容， 增減列數請自行在 [entries] 外包一層（可參考 [KlpRepeaterField] 的模式）。

- `extends` → <code>StatelessWidget</code>：[lib/src/form/structured/klp_key_value_editor.dart:30](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L30)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpKeyValueEditor</code> | public | <code>const KlpKeyValueEditor({ super.key, required this.label, required this.entries, required this.onChanged, })</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:31](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L31) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:38](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L38) |
| field <code>entries</code> | public | <code>final List&lt;KlpKeyValueEntry&gt; entries</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:39](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L39) |
| field <code>onChanged</code> | public | <code>final ValueChanged&lt;List&lt;KlpKeyValueEntry&gt;&gt;? onChanged</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:40](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L40) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:42](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L42) |
| method <code>_replace</code> | private | <code>void _replace(int index, KlpKeyValueEntry entry)</code> |  | [lib/src/form/structured/klp_key_value_editor.dart:84](../../../../../lib/src/form/structured/klp_key_value_editor.dart#L84) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
