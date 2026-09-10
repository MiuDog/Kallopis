# klp_reference_picker.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart)

## 範圍

核心是 `lib/src/features/forms/picker/klp_reference_picker.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_reference_picker.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n2["../../../foundation/layout/klp_center.dart"]
	n3["klp_reference_option.dart"]
	n4["klp_reference_option.dart"]
	n5["internal/klp_reference_option_row.dart"]
	n6["primitives/klp_reference_option_frame.dart"]
	n7["primitives/klp_reference_picker_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"export"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/features/forms/picker/klp_reference_picker.dart:1](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L1) |
| import | <code>import &#x27;../../../foundation/layout/klp_center.dart&#x27;;</code> | [lib/src/features/forms/picker/klp_reference_picker.dart:2](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L2) |
| import | <code>import &#x27;klp_reference_option.dart&#x27;;</code> | [lib/src/features/forms/picker/klp_reference_picker.dart:3](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L3) |
| export | <code>export &#x27;klp_reference_option.dart&#x27;;</code> | [lib/src/features/forms/picker/klp_reference_picker.dart:5](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L5) |
| part | <code>part &#x27;internal/klp_reference_option_row.dart&#x27;;</code> | [lib/src/features/forms/picker/klp_reference_picker.dart:7](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L7) |
| part | <code>part &#x27;primitives/klp_reference_option_frame.dart&#x27;;</code> | [lib/src/features/forms/picker/klp_reference_picker.dart:8](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L8) |
| part | <code>part &#x27;primitives/klp_reference_picker_frame.dart&#x27;;</code> | [lib/src/features/forms/picker/klp_reference_picker.dart:9](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L9) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpReferencePicker"]
```

```mermaid
classDiagram
	class n0["KlpReferencePicker"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpReferencePicker

ClassDeclaration · public · [lib/src/features/forms/picker/klp_reference_picker.dart:11](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L11)

<code>class KlpReferencePicker extends StatelessWidget</code>

來源註解摘要：以查詢、載入狀態與受控結果清單呈現通用參照選擇器。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/forms/picker/klp_reference_picker.dart:12](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L12)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpReferencePicker</code> | public | <code>const KlpReferencePicker({ super.key, required this.title, required this.query, required this.queryPlaceholder, required this.results, required this.onQueryChanged, required this.onSelected, this.loading = false, })</code> |  | [lib/src/features/forms/picker/klp_reference_picker.dart:13](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L13) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/features/forms/picker/klp_reference_picker.dart:24](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L24) |
| field <code>query</code> | public | <code>final String query</code> |  | [lib/src/features/forms/picker/klp_reference_picker.dart:25](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L25) |
| field <code>queryPlaceholder</code> | public | <code>final String queryPlaceholder</code> |  | [lib/src/features/forms/picker/klp_reference_picker.dart:26](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L26) |
| field <code>results</code> | public | <code>final List&lt;KlpReferenceOption&gt; results</code> |  | [lib/src/features/forms/picker/klp_reference_picker.dart:27](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L27) |
| field <code>onQueryChanged</code> | public | <code>final ValueChanged&lt;String&gt; onQueryChanged</code> |  | [lib/src/features/forms/picker/klp_reference_picker.dart:28](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L28) |
| field <code>onSelected</code> | public | <code>final ValueChanged&lt;String&gt;? onSelected</code> |  | [lib/src/features/forms/picker/klp_reference_picker.dart:29](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L29) |
| field <code>loading</code> | public | <code>final bool loading</code> |  | [lib/src/features/forms/picker/klp_reference_picker.dart:30](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L30) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/forms/picker/klp_reference_picker.dart:32](../../../../../../lib/src/features/forms/picker/klp_reference_picker.dart#L32) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
