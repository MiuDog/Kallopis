# klp_dock_layout_data.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart)

## 範圍

核心是 `lib/src/shell/docking/internal/klp_dock_layout_data.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_dock_layout_data.dart"]
	n1["../klp_dock_layout.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_dock_layout.dart&#x27;;</code> | [lib/src/shell/docking/internal/klp_dock_layout_data.dart:1](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpDockLayoutDataOperations"]
```

```mermaid
classDiagram
	class n0["_KlpDockLayoutDataOperations"]
	class n1["_KlpDockLayoutState"]
	n0 ..> n1 : on
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpDockLayoutDataOperations

ExtensionDeclaration · private · [lib/src/shell/docking/internal/klp_dock_layout_data.dart:3](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart#L3)

<code>extension _KlpDockLayoutDataOperations on _KlpDockLayoutState</code>

- `on` → <code>_KlpDockLayoutState</code>：[lib/src/shell/docking/internal/klp_dock_layout_data.dart:3](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| method <code>_finishStageAreaDrop</code> | private | <code>void _finishStageAreaDrop(_KlpDockPanelDragData data, _KlpDockAreaSlot targetSlot)</code> |  | [lib/src/shell/docking/internal/klp_dock_layout_data.dart:5](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart#L5) |
| method <code>_finishPanelDrop</code> | private | <code>void _finishPanelDrop( _KlpDockPanelDragData data, _KlpDockAreaSlot targetSlot, KlpDockAreaData targetArea, KlpDockGroupData targetGroup, _KlpDockDropPlacement placement, double targetExtent, double handleExtent, { int? insertionIndex, })</code> |  | [lib/src/shell/docking/internal/klp_dock_layout_data.dart:37](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart#L37) |
| method <code>_removePanel</code> | private | <code>KlpDockAreaData? _removePanel(KlpDockAreaData area, _KlpDockPanelDragData data)</code> |  | [lib/src/shell/docking/internal/klp_dock_layout_data.dart:116](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart#L116) |
| method <code>_reorderPanelInGroup</code> | private | <code>void _reorderPanelInGroup( _KlpDockAreaSlot slot, KlpDockAreaData area, KlpDockGroupData group, String panelId, int? insertionIndex, )</code> |  | [lib/src/shell/docking/internal/klp_dock_layout_data.dart:135](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart#L135) |
| method <code>_createGroupId</code> | private | <code>String _createGroupId()</code> |  | [lib/src/shell/docking/internal/klp_dock_layout_data.dart:160](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart#L160) |
| method <code>_areaForSlot</code> | private | <code>KlpDockAreaData _areaForSlot(KlpDockLayoutData layout, _KlpDockAreaSlot slot)</code> |  | [lib/src/shell/docking/internal/klp_dock_layout_data.dart:175](../../../../../../lib/src/shell/docking/internal/klp_dock_layout_data.dart#L175) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
