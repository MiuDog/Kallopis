# klp_form_section.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/core/klp_form_section.dart)

## 範圍

核心是 `lib/src/features/forms/core/klp_form_section.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_form_section.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/features/forms/core/klp_form_section.dart:1](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFormSection"]
```

```mermaid
classDiagram
	class n0["KlpFormSection"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFormSection

ClassDeclaration · public · [lib/src/features/forms/core/klp_form_section.dart:3](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L3)

<code>class KlpFormSection extends StatelessWidget</code>

來源註解摘要：表單中的一個可摺疊分組，帶標題、選填說明與一組欄位。 [collapsed] 與 [onToggle] 由呼叫端持有狀態——這個元件本身不記憶展開與否， 純粹依 [collapsed] 決定要不要畫出 [children]。標題整列可點擊觸發 [onToggle]，即使 [onToggle] 為 null 也一樣可安全點擊（等同無反應）。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/forms/core/klp_form_section.dart:8](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFormSection</code> | public | <code>const KlpFormSection({ super.key, required this.title, required this.children, this.description, this.collapsed = false, this.onToggle, })</code> |  | [lib/src/features/forms/core/klp_form_section.dart:9](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L9) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/features/forms/core/klp_form_section.dart:18](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L18) |
| field <code>description</code> | public | <code>final String? description</code> |  | [lib/src/features/forms/core/klp_form_section.dart:19](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L19) |
| field <code>children</code> | public | <code>final List&lt;Widget&gt; children</code> |  | [lib/src/features/forms/core/klp_form_section.dart:20](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L20) |
| field <code>collapsed</code> | public | <code>final bool collapsed</code> |  | [lib/src/features/forms/core/klp_form_section.dart:21](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L21) |
| field <code>onToggle</code> | public | <code>final VoidCallback? onToggle</code> |  | [lib/src/features/forms/core/klp_form_section.dart:22](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L22) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/forms/core/klp_form_section.dart:24](../../../../../../lib/src/features/forms/core/klp_form_section.dart#L24) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
