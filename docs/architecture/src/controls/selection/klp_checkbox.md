# klp_checkbox.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/controls/selection/klp_checkbox.dart)

## 範圍

核心是 `lib/src/controls/selection/klp_checkbox.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_checkbox.dart"]
	n1["package:flutter/material.dart"]
	n2["../../foundation/klp_icon.dart"]
	n3["../../foundation/klp_icons.dart"]
	n4["../../theme/klp_theme.dart"]
	n5["../../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/controls/selection/klp_checkbox.dart:1](../../../../../lib/src/controls/selection/klp_checkbox.dart#L1) |
| import | <code>import &#x27;../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/controls/selection/klp_checkbox.dart:3](../../../../../lib/src/controls/selection/klp_checkbox.dart#L3) |
| import | <code>import &#x27;../../foundation/klp_icons.dart&#x27;;</code> | [lib/src/controls/selection/klp_checkbox.dart:4](../../../../../lib/src/controls/selection/klp_checkbox.dart#L4) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/controls/selection/klp_checkbox.dart:5](../../../../../lib/src/controls/selection/klp_checkbox.dart#L5) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/controls/selection/klp_checkbox.dart:6](../../../../../lib/src/controls/selection/klp_checkbox.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCheckbox"]
```

```mermaid
classDiagram
	class n0["KlpCheckbox"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCheckbox

ClassDeclaration · public · [lib/src/controls/selection/klp_checkbox.dart:8](../../../../../lib/src/controls/selection/klp_checkbox.dart#L8)

<code>class KlpCheckbox extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/controls/selection/klp_checkbox.dart:8](../../../../../lib/src/controls/selection/klp_checkbox.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpCheckbox</code> | public | <code>const KlpCheckbox({ super.key, required this.value, required this.label, required this.onChanged, this.showLabel = true, })</code> |  | [lib/src/controls/selection/klp_checkbox.dart:9](../../../../../lib/src/controls/selection/klp_checkbox.dart#L9) |
| field <code>value</code> | public | <code>final bool value</code> |  | [lib/src/controls/selection/klp_checkbox.dart:17](../../../../../lib/src/controls/selection/klp_checkbox.dart#L17) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/controls/selection/klp_checkbox.dart:18](../../../../../lib/src/controls/selection/klp_checkbox.dart#L18) |
| field <code>onChanged</code> | public | <code>final ValueChanged&lt;bool&gt;? onChanged</code> |  | [lib/src/controls/selection/klp_checkbox.dart:19](../../../../../lib/src/controls/selection/klp_checkbox.dart#L19) |
| field <code>showLabel</code> | public | <code>final bool showLabel</code> |  | [lib/src/controls/selection/klp_checkbox.dart:20](../../../../../lib/src/controls/selection/klp_checkbox.dart#L20) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/controls/selection/klp_checkbox.dart:22](../../../../../lib/src/controls/selection/klp_checkbox.dart#L22) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
