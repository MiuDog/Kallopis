# klp_dock_panel.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/shell/docking/klp_dock_panel.dart)

## 範圍

核心是 `lib/src/shell/docking/klp_dock_panel.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_dock_panel.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../foundation/klp_icon.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/shell/docking/klp_dock_panel.dart:1](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L1) |
| import | <code>import &#x27;../../foundation/klp_icon.dart&#x27;;</code> | [lib/src/shell/docking/klp_dock_panel.dart:3](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDockHeaderAction"]
	class n1["KlpDockPanel"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDockHeaderAction

ClassDeclaration · public · [lib/src/shell/docking/klp_dock_panel.dart:5](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L5)

<code>class KlpDockHeaderAction</code>

來源註解摘要：Dock Header 右側的產品動作描述。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>icon</code> | public | <code>final KlpIconData icon</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:9](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L9) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:10](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L10) |
| field <code>onPressed</code> | public | <code>final VoidCallback onPressed</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:11](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L11) |
| field <code>enabled</code> | public | <code>final bool enabled</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:12](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L12) |
| constructor <code>KlpDockHeaderAction</code> | public | <code>const KlpDockHeaderAction({ required this.icon, required this.label, required this.onPressed, this.enabled = true, })</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:14](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L14) |

### KlpDockPanel

ClassDeclaration · public · [lib/src/shell/docking/klp_dock_panel.dart:22](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L22)

<code>class KlpDockPanel</code>

來源註解摘要：可停駐布局中的產品中立面板描述；內容與可放置方向由呼叫端提供。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:26](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L26) |
| field <code>header</code> | public | <code>final Widget? header</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:27](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L27) |
| field <code>content</code> | public | <code>final Widget content</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:28](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L28) |
| field <code>contentScrollController</code> | public | <code>final ScrollController? contentScrollController</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:29](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L29) |
| field <code>isDraggable</code> | public | <code>final bool isDraggable</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:30](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L30) |
| field <code>allowBottom</code> | public | <code>final bool allowBottom</code> | 是否允許放入 Stage 下方的 Bottom Area。 | [lib/src/shell/docking/klp_dock_panel.dart:33](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L33) |
| field <code>allowSide</code> | public | <code>final bool allowSide</code> | 是否允許放入 Stage 左右兩側的 Area。 | [lib/src/shell/docking/klp_dock_panel.dart:36](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L36) |
| field <code>actions</code> | public | <code>final List&lt;KlpDockHeaderAction&gt; actions</code> | Active panel 顯示於 Dock Header 右側的產品動作。 | [lib/src/shell/docking/klp_dock_panel.dart:39](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L39) |
| constructor <code>KlpDockPanel</code> | public | <code>const KlpDockPanel({ required this.id, this.header, required this.content, this.contentScrollController, bool isDraggable = true, this.allowBottom = true, this.allowSide = true, this.actions = const [], })</code> |  | [lib/src/shell/docking/klp_dock_panel.dart:41](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L41) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
