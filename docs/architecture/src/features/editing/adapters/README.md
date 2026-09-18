# lib/src/features/editing/adapters：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/editing/adapters` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/editing/adapters"]
	n1["lib/src/capabilities/editing/contracts"]
	n2["lib/src/composition/definitions"]
	n3["lib/src/composition/nodes"]
	n4["lib/src/composition/validation"]
	n5["lib/src/features/editing/contracts"]
	n6["lib/src/features/editing/internal"]
	n7["lib/src/features/editing/presentation"]
	n8["lib/src/foundation/binding/contracts"]
	n9["lib/src/kernel/diagnostics"]
	n10["lib/src/kernel/lifecycle"]
	n11["lib/src/runtime/contracts"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["lib/src/features/editing/adapters"]
	n1["lib/src/runtime/installation"]
	n2["lib/src/styling/primitives"]
	n3["lib/src/styling/semantics"]
	n4["package:krepis_block_note"]
	n5["package:krepis_canva"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/capabilities/editing/contracts</code> | import | 1 | [lib/src/features/editing/adapters/klp_editing_adapter.dart:9](../../../../../../lib/src/features/editing/adapters/klp_editing_adapter.dart#L9) |
| <code>lib/src/composition/definitions</code> | import | 6 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:2](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L2) |
| <code>lib/src/composition/nodes</code> | import | 6 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:3](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L3) |
| <code>lib/src/composition/validation</code> | import | 6 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:4](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L4) |
| <code>lib/src/features/editing/contracts</code> | import | 9 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:13](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L13) |
| <code>lib/src/features/editing/internal</code> | import | 4 | [lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart:14](../../../../../../lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart#L14) |
| <code>lib/src/features/editing/presentation</code> | import | 6 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:1](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L1) |
| <code>lib/src/foundation/binding/contracts</code> | import | 7 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:5](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L5) |
| <code>lib/src/kernel/diagnostics</code> | import | 4 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:6](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L6) |
| <code>lib/src/kernel/lifecycle</code> | import | 5 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:7](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L7) |
| <code>lib/src/runtime/contracts</code> | import | 23 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:8](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L8) |
| <code>lib/src/runtime/installation</code> | import | 3 | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:11](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L11) |
| <code>lib/src/styling/primitives</code> | import | 2 | [lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart:13](../../../../../../lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart#L13) |
| <code>lib/src/styling/semantics</code> | import | 1 | [lib/src/features/editing/adapters/klp_editing_adapter.dart:8](../../../../../../lib/src/features/editing/adapters/klp_editing_adapter.dart#L8) |
| <code>package:krepis_block_note</code> | import | 1 | [lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart:2](../../../../../../lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart#L2) |
| <code>package:krepis_canva</code> | import | 1 | [lib/src/features/editing/adapters/klp_canva_editing_adapter.dart:3](../../../../../../lib/src/features/editing/adapters/klp_canva_editing_adapter.dart#L3) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/editing/adapters"]
	n1["klp_anchored_commands_adapter.dart"]
	n2["klp_block_controls_adapter.dart"]
	n3["klp_block_note_editing_adapter.dart"]
	n4["klp_canva_editing_adapter.dart"]
	n5["klp_editing_adapter.dart"]
	n6["klp_mode_toolbar_adapter.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_anchored_commands_adapter.dart` | KlpAnchoredCommandsAdapter, _KlpPreparedAnchoredCommands | [架構與 API](klp_anchored_commands_adapter.md) | [lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart:1](../../../../../../lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart#L1) |
| `klp_block_controls_adapter.dart` | KlpBlockControlsAdapter, _KlpPreparedBlockControls | [架構與 API](klp_block_controls_adapter.md) | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:1](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L1) |
| `klp_block_note_editing_adapter.dart` | KlpBlockNoteEditingAdapter, _KlpPreparedBlockNoteEditing, _KlpBlockNotePlacement | [架構與 API](klp_block_note_editing_adapter.md) | [lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart:1](../../../../../../lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart#L1) |
| `klp_canva_editing_adapter.dart` | KlpCanvaEditingAdapter, _KlpPreparedCanvaEditing, _KlpCanvaPlacement | [架構與 API](klp_canva_editing_adapter.md) | [lib/src/features/editing/adapters/klp_canva_editing_adapter.dart:1](../../../../../../lib/src/features/editing/adapters/klp_canva_editing_adapter.dart#L1) |
| `klp_editing_adapter.dart` | KlpEditingAdapter | [架構與 API](klp_editing_adapter.md) | [lib/src/features/editing/adapters/klp_editing_adapter.dart:1](../../../../../../lib/src/features/editing/adapters/klp_editing_adapter.dart#L1) |
| `klp_mode_toolbar_adapter.dart` | KlpModeToolbarAdapter, _KlpPreparedModeToolbar | [架構與 API](klp_mode_toolbar_adapter.md) | [lib/src/features/editing/adapters/klp_mode_toolbar_adapter.dart:1](../../../../../../lib/src/features/editing/adapters/klp_mode_toolbar_adapter.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
