# klp_panel_frame.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/panel/klp_panel_frame.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_panel_frame.dart"]
	n1["package:flutter/material.dart"]
	n2["../../../../foundation/layout/klp_panel_layout.dart"]
	n3["../../../../styling/legacy_theme/klp_theme.dart"]
	n4["klp_panel_footer.dart"]
	n5["klp_panel_header_size.dart"]
	n6["klp_panel_tone.dart"]
	n7["klp_panel_header_size.dart"]
	n8["klp_panel_tone.dart"]
	n9["primitives/klp_panel_frame_view.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"export"| n7
	n0 -->|"export"| n8
	n0 -->|"part"| n9
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:1](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L1) |
| import | <code>import &#x27;../../../../foundation/layout/klp_panel_layout.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:3](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L3) |
| import | <code>import &#x27;../../../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:4](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L4) |
| import | <code>import &#x27;klp_panel_footer.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:5](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L5) |
| import | <code>import &#x27;klp_panel_header_size.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:6](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L6) |
| import | <code>import &#x27;klp_panel_tone.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:7](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L7) |
| export | <code>export &#x27;klp_panel_header_size.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:9](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L9) |
| export | <code>export &#x27;klp_panel_tone.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:10](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L10) |
| part | <code>part &#x27;primitives/klp_panel_frame_view.dart&#x27;;</code> | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:12](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L12) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPanelFrame"]
```

```mermaid
classDiagram
	class n0["KlpPanelFrame"]
	class n1["StatelessWidget"]
	class n2["KlpPanelLayout"]
	n0 --|> n1 : extends
	n0 ..|> n2 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPanelFrame

ClassDeclaration · public · [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:14](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L14)

<code>class KlpPanelFrame extends StatelessWidget implements KlpPanelLayout</code>

來源註解摘要：通用面板：header 與 content，選用 footer。 消費者只選擇語意背景與 header 尺寸；外距、圓角、裁切、footer 高度與 scrollbar 全由 Kallopis token 與 primitive frame 決定。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/panel/klp_panel_frame.dart:18](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L18)
- `implements` → <code>KlpPanelLayout</code>：[lib/src/features/workspace/shell/panel/klp_panel_frame.dart:18](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L18)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPanelFrame</code> | public | <code>const KlpPanelFrame({ super.key, this.header, required this.content, this.footer, this.headerSize = KlpPanelHeaderSize.standard, this.tone = KlpPanelTone.surface, this.contentScrollController, })</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:19](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L19) |
| field <code>header</code> | public | <code>final Widget? header</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:29](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L29) |
| field <code>content</code> | public | <code>final Widget content</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:30](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L30) |
| field <code>footer</code> | public | <code>final Widget? footer</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:31](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L31) |
| field <code>headerSize</code> | public | <code>final KlpPanelHeaderSize headerSize</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:32](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L32) |
| field <code>tone</code> | public | <code>final KlpPanelTone tone</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:33](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L33) |
| field <code>contentScrollController</code> | public | <code>final ScrollController? contentScrollController</code> | 內容區的捲動控制器。提供時，Frame 只負責繪製 Scrollbar；內容的 內距由 [content] 自己決定。 | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:37](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L37) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:39](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L39) |
| method <code>buildPanelLayout</code> | public | <code>Widget buildPanelLayout(BuildContext context)</code> |  | [lib/src/features/workspace/shell/panel/klp_panel_frame.dart:51](../../../../../../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart#L51) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
