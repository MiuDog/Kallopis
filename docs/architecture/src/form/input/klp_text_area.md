# klp_text_area.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/form/input/klp_text_area.dart)

## 範圍

核心是 `lib/src/form/input/klp_text_area.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_text_area.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/form/input/klp_text_area.dart:1](../../../../../lib/src/form/input/klp_text_area.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpTextArea"]
```

```mermaid
classDiagram
	class n0["KlpTextArea"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpTextArea

ClassDeclaration · public · [lib/src/form/input/klp_text_area.dart:3](../../../../../lib/src/form/input/klp_text_area.dart#L3)

<code>class KlpTextArea extends StatelessWidget</code>

來源註解摘要：多行文字輸入欄位，是 [KlpTextField] 的薄封裝——固定 `multiline: true`， 其餘外觀與行為完全繼承自 [KlpTextField]。

- `extends` → <code>StatelessWidget</code>：[lib/src/form/input/klp_text_area.dart:5](../../../../../lib/src/form/input/klp_text_area.dart#L5)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpTextArea</code> | public | <code>const KlpTextArea({ super.key, this.label, this.value, this.placeholder, this.error, this.onChanged, this.enabled = true, this.minLines, this.maxLines, this.unboundedLines = false, this.outlined = false, })</code> |  | [lib/src/form/input/klp_text_area.dart:6](../../../../../lib/src/form/input/klp_text_area.dart#L6) |
| field <code>label</code> | public | <code>final String? label</code> |  | [lib/src/form/input/klp_text_area.dart:20](../../../../../lib/src/form/input/klp_text_area.dart#L20) |
| field <code>value</code> | public | <code>final String? value</code> |  | [lib/src/form/input/klp_text_area.dart:21](../../../../../lib/src/form/input/klp_text_area.dart#L21) |
| field <code>placeholder</code> | public | <code>final String? placeholder</code> |  | [lib/src/form/input/klp_text_area.dart:22](../../../../../lib/src/form/input/klp_text_area.dart#L22) |
| field <code>error</code> | public | <code>final String? error</code> |  | [lib/src/form/input/klp_text_area.dart:23](../../../../../lib/src/form/input/klp_text_area.dart#L23) |
| field <code>onChanged</code> | public | <code>final ValueChanged&lt;String&gt;? onChanged</code> |  | [lib/src/form/input/klp_text_area.dart:24](../../../../../lib/src/form/input/klp_text_area.dart#L24) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/form/input/klp_text_area.dart:25](../../../../../lib/src/form/input/klp_text_area.dart#L25) |
| field <code>minLines</code> | public | <code>final int? minLines</code> |  | [lib/src/form/input/klp_text_area.dart:26](../../../../../lib/src/form/input/klp_text_area.dart#L26) |
| field <code>maxLines</code> | public | <code>final int? maxLines</code> |  | [lib/src/form/input/klp_text_area.dart:27](../../../../../lib/src/form/input/klp_text_area.dart#L27) |
| field <code>unboundedLines</code> | public | <code>final bool unboundedLines</code> |  | [lib/src/form/input/klp_text_area.dart:28](../../../../../lib/src/form/input/klp_text_area.dart#L28) |
| field <code>outlined</code> | public | <code>final bool outlined</code> |  | [lib/src/form/input/klp_text_area.dart:29](../../../../../lib/src/form/input/klp_text_area.dart#L29) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/form/input/klp_text_area.dart:31](../../../../../lib/src/form/input/klp_text_area.dart#L31) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
