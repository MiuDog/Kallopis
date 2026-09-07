# klp_file_field.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/form/structured/klp_file_field.dart)

## 範圍

核心是 `lib/src/form/structured/klp_file_field.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_file_field.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/form/structured/klp_file_field.dart:1](../../../../../lib/src/form/structured/klp_file_field.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFileValue"]
	class n1["KlpFileField"]
```

```mermaid
classDiagram
	class n0["KlpFileField"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFileValue

ClassDeclaration · public · [lib/src/form/structured/klp_file_field.dart:3](../../../../../lib/src/form/structured/klp_file_field.dart#L3)

<code>class KlpFileValue</code>

來源註解摘要：[KlpFileField] 顯示的一個已選檔案：識別碼、檔名，與選填的中繼資料文字 （例如檔案大小或上傳時間，顯示格式由呼叫端自行組字串）。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFileValue</code> | public | <code>const KlpFileValue({required this.id, required this.name, this.metadata})</code> |  | [lib/src/form/structured/klp_file_field.dart:7](../../../../../lib/src/form/structured/klp_file_field.dart#L7) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/form/structured/klp_file_field.dart:9](../../../../../lib/src/form/structured/klp_file_field.dart#L9) |
| field <code>name</code> | public | <code>final String name</code> |  | [lib/src/form/structured/klp_file_field.dart:10](../../../../../lib/src/form/structured/klp_file_field.dart#L10) |
| field <code>metadata</code> | public | <code>final String? metadata</code> |  | [lib/src/form/structured/klp_file_field.dart:11](../../../../../lib/src/form/structured/klp_file_field.dart#L11) |

### KlpFileField

ClassDeclaration · public · [lib/src/form/structured/klp_file_field.dart:13](../../../../../lib/src/form/structured/klp_file_field.dart#L13)

<code>class KlpFileField extends StatelessWidget</code>

來源註解摘要：簡易的檔案選擇欄位：一排已選檔案的預覽卡片，加一顆選擇檔案按鈕。 不處理實際的檔案選取或上傳邏輯——[onChoose] 只是回報「使用者按了選擇」， 開檔案對話框、讀取內容、上傳進度都由呼叫端接手；需要顯示上傳進度時請改用 [KlpFileDropzoneField]。

- `extends` → <code>StatelessWidget</code>：[lib/src/form/structured/klp_file_field.dart:18](../../../../../lib/src/form/structured/klp_file_field.dart#L18)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFileField</code> | public | <code>const KlpFileField({ super.key, required this.label, required this.files, required this.chooseLabel, this.onChoose, this.onRemove, })</code> |  | [lib/src/form/structured/klp_file_field.dart:19](../../../../../lib/src/form/structured/klp_file_field.dart#L19) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/form/structured/klp_file_field.dart:28](../../../../../lib/src/form/structured/klp_file_field.dart#L28) |
| field <code>files</code> | public | <code>final List&lt;KlpFileValue&gt; files</code> |  | [lib/src/form/structured/klp_file_field.dart:29](../../../../../lib/src/form/structured/klp_file_field.dart#L29) |
| field <code>chooseLabel</code> | public | <code>final String chooseLabel</code> |  | [lib/src/form/structured/klp_file_field.dart:30](../../../../../lib/src/form/structured/klp_file_field.dart#L30) |
| field <code>onChoose</code> | public | <code>final VoidCallback? onChoose</code> |  | [lib/src/form/structured/klp_file_field.dart:31](../../../../../lib/src/form/structured/klp_file_field.dart#L31) |
| field <code>onRemove</code> | public | <code>final ValueChanged&lt;String&gt;? onRemove</code> |  | [lib/src/form/structured/klp_file_field.dart:32](../../../../../lib/src/form/structured/klp_file_field.dart#L32) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/form/structured/klp_file_field.dart:34](../../../../../lib/src/form/structured/klp_file_field.dart#L34) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
