# klp_dock_header_widget.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_dock_header_widget.dart"]
	n1["../klp_dock_header.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_dock_header.dart&#x27;;</code> | [lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart:1](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDockHeader"]
```

```mermaid
classDiagram
	class n0["KlpDockHeader"]
	class n1["StatefulWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDockHeader

ClassDeclaration · public · [lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart:3](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L3)

<code>class KlpDockHeader extends StatefulWidget</code>

來源註解摘要：Dock Group 專用的緊湊 Header。 左側區域可由 Layout 包成拖曳來源；右側 actions 是獨立 clickable 區域， 因此操作按鈕不會誤觸 panel 拖曳。

- `extends` → <code>StatefulWidget</code>：[lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart:7](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>extent</code> | public | <code>static const double extent</code> |  | [lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart:8](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L8) |
| constructor <code>KlpDockHeader</code> | public | <code>const KlpDockHeader({ super.key, required this.leading, this.actions = const [], this.dragRegionBuilder, })</code> |  | [lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart:10](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L10) |
| field <code>leading</code> | public | <code>final Widget leading</code> |  | [lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart:17](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L17) |
| field <code>actions</code> | public | <code>final List&lt;KlpDockHeaderAction&gt; actions</code> |  | [lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart:18](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L18) |
| field <code>dragRegionBuilder</code> | public | <code>final KlpDockHeaderDragRegionBuilder? dragRegionBuilder</code> |  | [lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart:19](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L19) |
| method <code>createState</code> | public | <code>State&lt;KlpDockHeader&gt; createState()</code> |  | [lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart:21](../../../../../../../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart#L21) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
