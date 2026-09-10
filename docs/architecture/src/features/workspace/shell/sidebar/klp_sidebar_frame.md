# klp_sidebar_frame.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_sidebar_frame.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../../foundation/layout/klp_box.dart"]
	n3["../panel/klp_panel_frame.dart"]
	n4["klp_sidebar_inset.dart"]
	n5["klp_sidebar_inset.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"export"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:1](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L1) |
| import | <code>import &#x27;../../../../foundation/layout/klp_box.dart&#x27;;</code> | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:3](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L3) |
| import | <code>import &#x27;../panel/klp_panel_frame.dart&#x27;;</code> | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:4](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L4) |
| import | <code>import &#x27;klp_sidebar_inset.dart&#x27;;</code> | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:5](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L5) |
| export | <code>export &#x27;klp_sidebar_inset.dart&#x27;;</code> | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:7](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L7) |

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

ClassDeclaration · public · [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:9](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L9)

<code>class KlpSidebarFrame extends StatelessWidget</code>

來源註解摘要：側邊欄：由側邊欄自己決定內容與 footer 的內距，再交給無內距的 PanelFrame 提供背景、圓角與外側 dock margin。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:11](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L11)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpSidebarFrame</code> | public | <code>const KlpSidebarFrame({ super.key, required this.content, this.footer, this.inset = KlpSidebarInset.chromePanel, })</code> |  | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:12](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L12) |
| field <code>content</code> | public | <code>final Widget content</code> |  | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:19](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L19) |
| field <code>footer</code> | public | <code>final Widget? footer</code> |  | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:20](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L20) |
| field <code>inset</code> | public | <code>final KlpSidebarInset inset</code> |  | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:21](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L21) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart:23](../../../../../../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart#L23) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
