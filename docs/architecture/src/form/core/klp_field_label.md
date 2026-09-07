# klp_field_label.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/form/core/klp_field_label.dart)

## 範圍

核心是 `lib/src/form/core/klp_field_label.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_field_label.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/form/core/klp_field_label.dart:1](../../../../../lib/src/form/core/klp_field_label.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFieldLabel"]
```

```mermaid
classDiagram
	class n0["KlpFieldLabel"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFieldLabel

ClassDeclaration · public · [lib/src/form/core/klp_field_label.dart:3](../../../../../lib/src/form/core/klp_field_label.dart#L3)

<code>class KlpFieldLabel extends StatelessWidget</code>

來源註解摘要：欄位標籤文字，統一使用 [KlpTextRole.caption] 樣式。 [KlpField] 內部就是用它畫標籤——需要在 [KlpField] 版面之外單獨放一個 樣式一致的欄位標籤時（例如自訂版面）才需要直接用它。

- `extends` → <code>StatelessWidget</code>：[lib/src/form/core/klp_field_label.dart:7](../../../../../lib/src/form/core/klp_field_label.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFieldLabel</code> | public | <code>const KlpFieldLabel({super.key, required this.label})</code> |  | [lib/src/form/core/klp_field_label.dart:8](../../../../../lib/src/form/core/klp_field_label.dart#L8) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/form/core/klp_field_label.dart:10](../../../../../lib/src/form/core/klp_field_label.dart#L10) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/form/core/klp_field_label.dart:12](../../../../../lib/src/form/core/klp_field_label.dart#L12) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
