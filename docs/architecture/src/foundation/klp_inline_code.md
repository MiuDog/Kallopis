# klp_inline_code.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../lib/src/foundation/klp_inline_code.dart)

## 範圍

核心是 `lib/src/foundation/klp_inline_code.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_inline_code.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../theme/klp_theme.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/foundation/klp_inline_code.dart:1](../../../../lib/src/foundation/klp_inline_code.dart#L1) |
| import | <code>import &#x27;../theme/klp_theme.dart&#x27;;</code> | [lib/src/foundation/klp_inline_code.dart:3](../../../../lib/src/foundation/klp_inline_code.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpInlineCode"]
```

```mermaid
classDiagram
	class n0["KlpInlineCode"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpInlineCode

ClassDeclaration · public · [lib/src/foundation/klp_inline_code.dart:5](../../../../lib/src/foundation/klp_inline_code.dart#L5)

<code>class KlpInlineCode extends StatelessWidget</code>

來源註解摘要：行內程式碼片段。帶有圓角背景與等寬字體，適合在段落文字中呈現指令、變數或路徑。

- `extends` → <code>StatelessWidget</code>：[lib/src/foundation/klp_inline_code.dart:6](../../../../lib/src/foundation/klp_inline_code.dart#L6)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpInlineCode</code> | public | <code>const KlpInlineCode( this.text, { super.key, this.color, this.backgroundColor, this.fontSize, this.radius, })</code> |  | [lib/src/foundation/klp_inline_code.dart:7](../../../../lib/src/foundation/klp_inline_code.dart#L7) |
| field <code>text</code> | public | <code>final String text</code> | 程式碼文字內容。 | [lib/src/foundation/klp_inline_code.dart:17](../../../../lib/src/foundation/klp_inline_code.dart#L17) |
| field <code>color</code> | public | <code>final Color? color</code> | 文字顏色。預設為 `context.klp.color.text`。 | [lib/src/foundation/klp_inline_code.dart:20](../../../../lib/src/foundation/klp_inline_code.dart#L20) |
| field <code>backgroundColor</code> | public | <code>final Color? backgroundColor</code> | 背景填色。預設為 `context.klp.color.surfaceInset`。 | [lib/src/foundation/klp_inline_code.dart:23](../../../../lib/src/foundation/klp_inline_code.dart#L23) |
| field <code>fontSize</code> | public | <code>final double? fontSize</code> | 字體大小。預設為 `context.klp.type.sub` (14px)。 | [lib/src/foundation/klp_inline_code.dart:26](../../../../lib/src/foundation/klp_inline_code.dart#L26) |
| field <code>radius</code> | public | <code>final double? radius</code> | 圓角半徑。預設為 `context.klp.shape.control`。 | [lib/src/foundation/klp_inline_code.dart:29](../../../../lib/src/foundation/klp_inline_code.dart#L29) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/foundation/klp_inline_code.dart:31](../../../../lib/src/foundation/klp_inline_code.dart#L31) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
