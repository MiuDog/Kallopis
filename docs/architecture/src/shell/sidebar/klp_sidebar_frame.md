# klp_sidebar_frame.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart)

## 範圍

核心是 `lib/src/shell/sidebar/klp_sidebar_frame.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_sidebar_frame.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../theme/klp_theme.dart"]
	n3["../panel/klp_panel_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/shell/sidebar/klp_sidebar_frame.dart:1](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L1) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/shell/sidebar/klp_sidebar_frame.dart:3](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L3) |
| import | <code>import &#x27;../panel/klp_panel_frame.dart&#x27;;</code> | [lib/src/shell/sidebar/klp_sidebar_frame.dart:4](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSidebarFrame"]
```

```mermaid
classDiagram
	class n0["KlpSidebarFrame"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSidebarFrame

ClassDeclaration · public · [lib/src/shell/sidebar/klp_sidebar_frame.dart:6](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L6)

<code>class KlpSidebarFrame extends StatelessWidget</code>

來源註解摘要：側邊欄：由側邊欄自己決定內容與 footer 的內距，再交給無內距的 PanelFrame 提供背景、圓角與外側 dock margin。

- `extends` → <code>StatelessWidget</code>：[lib/src/shell/sidebar/klp_sidebar_frame.dart:8](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSidebarFrame</code> | public | <code>const KlpSidebarFrame({ super.key, required this.content, this.footer, this.padding, })</code> |  | [lib/src/shell/sidebar/klp_sidebar_frame.dart:9](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L9) |
| field <code>content</code> | public | <code>final Widget content</code> |  | [lib/src/shell/sidebar/klp_sidebar_frame.dart:16](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L16) |
| field <code>footer</code> | public | <code>final Widget? footer</code> |  | [lib/src/shell/sidebar/klp_sidebar_frame.dart:17](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L17) |
| field <code>padding</code> | public | <code>final EdgeInsetsGeometry? padding</code> |  | [lib/src/shell/sidebar/klp_sidebar_frame.dart:18](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L18) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/shell/sidebar/klp_sidebar_frame.dart:20](../../../../../lib/src/shell/sidebar/klp_sidebar_frame.dart#L20) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
