# klp_dock_drop_target.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart)

## 範圍

核心是 `lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_dock_drop_target.dart"]
	n1["../klp_dock_layout.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_dock_layout.dart&#x27;;</code> | [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:1](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpDockDropTarget"]
```

```mermaid
classDiagram
	class n0["_KlpDockDropTarget"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpDockDropTarget

ClassDeclaration · private · [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:3](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L3)

<code>class _KlpDockDropTarget extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:3](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpDockDropTarget</code> | private | <code>const _KlpDockDropTarget({ this.hitTestBehavior = HitTestBehavior.translucent, this.onWillAcceptWithDetails, this.onMove, this.onLeave, this.onAcceptWithDetails, required this.builder, })</code> |  | [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:4](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L4) |
| field <code>hitTestBehavior</code> | public | <code>final HitTestBehavior hitTestBehavior</code> |  | [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:13](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L13) |
| field <code>onWillAcceptWithDetails</code> | public | <code>final bool Function(BuildContext, DragTargetDetails&lt;_KlpDockPanelDragData&gt;)? onWillAcceptWithDetails</code> |  | [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:15](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L15) |
| field <code>onMove</code> | public | <code>final void Function(BuildContext, DragTargetDetails&lt;_KlpDockPanelDragData&gt;)? onMove</code> |  | [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:17](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L17) |
| field <code>onLeave</code> | public | <code>final void Function(BuildContext, _KlpDockPanelDragData?)? onLeave</code> |  | [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:18](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L18) |
| field <code>onAcceptWithDetails</code> | public | <code>final void Function(BuildContext, DragTargetDetails&lt;_KlpDockPanelDragData&gt;)? onAcceptWithDetails</code> |  | [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:20](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L20) |
| field <code>builder</code> | public | <code>final DragTargetBuilder&lt;_KlpDockPanelDragData&gt; builder</code> |  | [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:21](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L21) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart:23](../../../../../../../../lib/src/features/workspace/shell/docking/primitives/klp_dock_drop_target.dart#L23) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
