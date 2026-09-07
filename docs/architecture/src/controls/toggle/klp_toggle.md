# klp_toggle.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/controls/toggle/klp_toggle.dart)

## 範圍

核心是 `lib/src/controls/toggle/klp_toggle.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_toggle.dart"]
	n1["package:flutter/material.dart"]
	n2["../../theme/klp_theme.dart"]
	n3["../../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/controls/toggle/klp_toggle.dart:1](../../../../../lib/src/controls/toggle/klp_toggle.dart#L1) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/controls/toggle/klp_toggle.dart:3](../../../../../lib/src/controls/toggle/klp_toggle.dart#L3) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/controls/toggle/klp_toggle.dart:4](../../../../../lib/src/controls/toggle/klp_toggle.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpToggle"]
	class n1["KlpToggleIndicator"]
```

```mermaid
classDiagram
	class n0["KlpToggle"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["KlpToggleIndicator"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpToggle

ClassDeclaration · public · [lib/src/controls/toggle/klp_toggle.dart:6](../../../../../lib/src/controls/toggle/klp_toggle.dart#L6)

<code>class KlpToggle extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/controls/toggle/klp_toggle.dart:6](../../../../../lib/src/controls/toggle/klp_toggle.dart#L6)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpToggle</code> | public | <code>const KlpToggle({ super.key, required this.value, required this.label, required this.onChanged, this.showLabel = true, })</code> |  | [lib/src/controls/toggle/klp_toggle.dart:7](../../../../../lib/src/controls/toggle/klp_toggle.dart#L7) |
| field <code>value</code> | public | <code>final bool value</code> |  | [lib/src/controls/toggle/klp_toggle.dart:15](../../../../../lib/src/controls/toggle/klp_toggle.dart#L15) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/controls/toggle/klp_toggle.dart:16](../../../../../lib/src/controls/toggle/klp_toggle.dart#L16) |
| field <code>onChanged</code> | public | <code>final ValueChanged&lt;bool&gt;? onChanged</code> |  | [lib/src/controls/toggle/klp_toggle.dart:17](../../../../../lib/src/controls/toggle/klp_toggle.dart#L17) |
| field <code>showLabel</code> | public | <code>final bool showLabel</code> |  | [lib/src/controls/toggle/klp_toggle.dart:18](../../../../../lib/src/controls/toggle/klp_toggle.dart#L18) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/controls/toggle/klp_toggle.dart:20](../../../../../lib/src/controls/toggle/klp_toggle.dart#L20) |

### KlpToggleIndicator

ClassDeclaration · public · [lib/src/controls/toggle/klp_toggle.dart:57](../../../../../lib/src/controls/toggle/klp_toggle.dart#L57)

<code>class KlpToggleIndicator extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/controls/toggle/klp_toggle.dart:57](../../../../../lib/src/controls/toggle/klp_toggle.dart#L57)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpToggleIndicator</code> | public | <code>const KlpToggleIndicator({ super.key, required this.value, this.enabled = true, })</code> |  | [lib/src/controls/toggle/klp_toggle.dart:58](../../../../../lib/src/controls/toggle/klp_toggle.dart#L58) |
| field <code>value</code> | public | <code>final bool value</code> |  | [lib/src/controls/toggle/klp_toggle.dart:64](../../../../../lib/src/controls/toggle/klp_toggle.dart#L64) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/controls/toggle/klp_toggle.dart:65](../../../../../lib/src/controls/toggle/klp_toggle.dart#L65) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/controls/toggle/klp_toggle.dart:67](../../../../../lib/src/controls/toggle/klp_toggle.dart#L67) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
