# klp_primary_sidebar_frame.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart)

## 範圍

核心是 `lib/src/shell/sidebar/klp_primary_sidebar_frame.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_primary_sidebar_frame.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../theme/klp_theme.dart"]
	n3["klp_sidebar_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:1](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L1) |
| import | <code>import &#x27;../../theme/klp_theme.dart&#x27;;</code> | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:3](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L3) |
| import | <code>import &#x27;klp_sidebar_frame.dart&#x27;;</code> | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:4](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPrimarySidebarFrame"]
```

```mermaid
classDiagram
	class n0["KlpPrimarySidebarFrame"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPrimarySidebarFrame

ClassDeclaration · public · [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:6](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L6)

<code>class KlpPrimarySidebarFrame extends StatelessWidget</code>

來源註解摘要：桌面工作區的 Primary Sidebar 外框。 Identity、導覽與 Explorer 緊密排列；上下節奏由各區域自行決定。 content 與 footer 沿用 [KlpSidebarFrame] 的水平 padding 規則；footer 不再 額外包覆垂直 padding。

- `extends` → <code>StatelessWidget</code>：[lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:11](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L11)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPrimarySidebarFrame</code> | public | <code>const KlpPrimarySidebarFrame({ super.key, this.header, this.navigation, required this.explorer, this.footer, this.padding, this.headerNavigationPadding, this.headerNavigationGap, })</code> |  | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:12](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L12) |
| field <code>header</code> | public | <code>final Widget? header</code> |  | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:23](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L23) |
| field <code>navigation</code> | public | <code>final Widget? navigation</code> |  | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:24](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L24) |
| field <code>explorer</code> | public | <code>final Widget explorer</code> |  | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:25](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L25) |
| field <code>footer</code> | public | <code>final Widget? footer</code> |  | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:26](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L26) |
| field <code>padding</code> | public | <code>final EdgeInsetsGeometry? padding</code> |  | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:27](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L27) |
| field <code>headerNavigationPadding</code> | public | <code>final EdgeInsetsGeometry? headerNavigationPadding</code> |  | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:28](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L28) |
| field <code>headerNavigationGap</code> | public | <code>final double? headerNavigationGap</code> |  | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:29](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L29) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/shell/sidebar/klp_primary_sidebar_frame.dart:31](../../../../../lib/src/shell/sidebar/klp_primary_sidebar_frame.dart#L31) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
