# klp_panel_header.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/panel/klp_panel_header.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_panel_header.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../../../foundation/layout/klp_layout.dart"]
	n3["../../../../styling/legacy_theme/klp_theme.dart"]
	n4["../../../../foundation/content/klp_text.dart"]
	n5["klp_panel_header_drag_region_builder.dart"]
	n6["klp_panel_header_drag_region_builder.dart"]
	n7["primitives/klp_panel_header_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"export"| n6
	n0 -->|"part"| n7
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:1](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L1) |
| import | <code>import &#x27;../../../../foundation/layout/klp_layout.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:3](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L3) |
| import | <code>import &#x27;../../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:4](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L4) |
| import | <code>import &#x27;../../../../foundation/content/klp_text.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:5](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L5) |
| import | <code>import &#x27;klp_panel_header_drag_region_builder.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:6](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L6) |
| export | <code>export &#x27;klp_panel_header_drag_region_builder.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:8](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L8) |
| part | <code>part &#x27;primitives/klp_panel_header_frame.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:10](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L10) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPanelHeader"]
```

```mermaid
classDiagram
	class n0["KlpPanelHeader"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPanelHeader

ClassDeclaration · public · [lib/src/features/workspace/shell/panel/klp_panel_header.dart:12](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L12)

<code>class KlpPanelHeader extends StatelessWidget</code>

來源註解摘要：面板標題列，集中排列標題、拖曳區、leading 與 actions。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/panel/klp_panel_header.dart:13](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L13)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPanelHeader</code> | public | <code>const KlpPanelHeader({ super.key, this.title, this.content, this.label, this.leading, this.actions = const [], this.titleRole = KlpTextRole.header, this.dragRegionBuilder, })</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:14](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L14) |
| field <code>title</code> | public | <code>final String? title</code> | 標準文字標題；與 [content] 擇一提供。 | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:26](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L26) |
| field <code>content</code> | public | <code>final Widget? content</code> | Dock tabs 或其他非文字標題的共通內容入口。 | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:29](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L29) |
| field <code>label</code> | public | <code>final String? label</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:30](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L30) |
| field <code>leading</code> | public | <code>final Widget? leading</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:31](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L31) |
| field <code>actions</code> | public | <code>final List&lt;Widget&gt; actions</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:32](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L32) |
| field <code>titleRole</code> | public | <code>final KlpTextRole titleRole</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:33](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L33) |
| field <code>dragRegionBuilder</code> | public | <code>final KlpPanelHeaderDragRegionBuilder? dragRegionBuilder</code> | 只包住標題／內容抓取區，不會包住右側 actions。 | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:36](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L36) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_header.dart:38](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_header.dart#L38) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
