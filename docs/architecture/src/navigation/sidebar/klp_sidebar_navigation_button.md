# klp_sidebar_navigation_button.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart)

## 範圍

核心是 `lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_sidebar_navigation_button.dart"]
	n1["dart:math"]
	n2["package:flutter/widgets.dart"]
	n3["../../foundation/klp_icon.dart"]
	n4["../../interaction/klp_pressable.dart"]
	n5["../../theme/klp_theme.dart"]
	n6["../../typography/klp_text.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:math&#x27; as math;</code> | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:1](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L1) |
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:3](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L3) |
| import | <code>import &#x27;../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:5](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L5) |
| import | <code>import &#x27;../../interaction/klp_pressable.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:6](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L6) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:7](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L7) |
| import | <code>import &#x27;../../typography/klp_text.dart&#x27;;</code> | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:8](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L8) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSidebarNavigationButton"]
	class n1["_KlpSidebarNavigationButtonState"]
```

```mermaid
classDiagram
	class n0["KlpSidebarNavigationButton"]
	class n1["StatefulWidget"]
	n0 --|> n1 : extends
```

```mermaid
classDiagram
	class n0["_KlpSidebarNavigationButtonState"]
	class n1["State&lt;KlpSidebarNavigationButton&gt;"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### klpNavigationIconBoxKey

top-level variable · public · [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:13](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L13)

<code>const String klpNavigationIconBoxKey</code>

來源註解摘要：導覽項目圖示格的識別鍵。 圖示格與字形各有自己的 semantic token；版面測試可用此鍵分別量測兩者。


### KlpSidebarNavigationButton

ClassDeclaration · public · [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:15](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L15)

<code>class KlpSidebarNavigationButton extends StatefulWidget</code>

來源註解摘要：Primary Sidebar 內的全寬導覽按鈕。 消費者只提供圖示、標籤、選取狀態與事件；高度、內距、圓角、圖示尺寸、 hover 與選取色全部由 Kallopis theme 決定。

- `extends` → <code>StatefulWidget</code>：[lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:19](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L19)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSidebarNavigationButton</code> | public | <code>const KlpSidebarNavigationButton({ super.key, required this.icon, required this.label, required this.onPressed, this.selected = false, })</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:20](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L20) |
| field <code>icon</code> | public | <code>final KlpIconData icon</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:28](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L28) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:29](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L29) |
| field <code>onPressed</code> | public | <code>final VoidCallback? onPressed</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:30](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L30) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:31](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L31) |
| method <code>createState</code> | public | <code>State&lt;KlpSidebarNavigationButton&gt; createState()</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:33](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L33) |

### _KlpSidebarNavigationButtonState

ClassDeclaration · private · [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:38](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L38)

<code>class _KlpSidebarNavigationButtonState extends State&lt;KlpSidebarNavigationButton&gt;</code>

- `extends` → <code>State&lt;KlpSidebarNavigationButton&gt;</code>：[lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:39](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L39)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_hovered</code> | private | <code>bool _hovered</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:40](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L40) |
| field <code>_focused</code> | private | <code>bool _focused</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:41](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L41) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart:43](../../../../../lib/src/navigation/sidebar/klp_sidebar_navigation_button.dart#L43) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
