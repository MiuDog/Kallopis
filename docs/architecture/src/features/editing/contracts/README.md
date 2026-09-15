# lib/src/features/editing/contracts：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/editing/contracts` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/editing/contracts"]
	n1["lib/src/capabilities/editing/contracts"]
	n2["lib/src/composition/nodes"]
	n3["lib/src/composition/slots"]
	n4["lib/src/kernel/identity"]
	n5["package:krepis_block_note"]
	n6["package:krepis_canva"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/capabilities/editing/contracts</code> | import | 1 | [lib/src/features/editing/contracts/klp_editing_content.dart:1](../../../../../../lib/src/features/editing/contracts/klp_editing_content.dart#L1) |
| <code>lib/src/composition/nodes</code> | import | 6 | [lib/src/features/editing/contracts/klp_block_control_slot_child.dart:1](../../../../../../lib/src/features/editing/contracts/klp_block_control_slot_child.dart#L1) |
| <code>lib/src/composition/slots</code> | import | 7 | [lib/src/features/editing/contracts/klp_block_note_editing_content.dart:3](../../../../../../lib/src/features/editing/contracts/klp_block_note_editing_content.dart#L3) |
| <code>lib/src/kernel/identity</code> | import | 6 | [lib/src/features/editing/contracts/klp_anchored_commands.dart:1](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L1) |
| <code>package:krepis_block_note</code> | import | 1 | [lib/src/features/editing/contracts/klp_block_note_editing_content.dart:1](../../../../../../lib/src/features/editing/contracts/klp_block_note_editing_content.dart#L1) |
| <code>package:krepis_canva</code> | import | 1 | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:1](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_anchored_commands.dart → klp_command_slot_child.dart</code> | import | [lib/src/features/editing/contracts/klp_anchored_commands.dart:2](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L2) |
| <code>klp_block_controls.dart → klp_block_control_slot_child.dart</code> | import | [lib/src/features/editing/contracts/klp_block_controls.dart:2](../../../../../../lib/src/features/editing/contracts/klp_block_controls.dart#L2) |
| <code>klp_editing_content.dart → klp_block_control_slot_child.dart</code> | import | [lib/src/features/editing/contracts/klp_editing_content.dart:7](../../../../../../lib/src/features/editing/contracts/klp_editing_content.dart#L7) |
| <code>klp_editing_content.dart → klp_command_slot_child.dart</code> | import | [lib/src/features/editing/contracts/klp_editing_content.dart:8](../../../../../../lib/src/features/editing/contracts/klp_editing_content.dart#L8) |
| <code>klp_editing_content.dart → klp_mode_tool_slot_child.dart</code> | import | [lib/src/features/editing/contracts/klp_editing_content.dart:9](../../../../../../lib/src/features/editing/contracts/klp_editing_content.dart#L9) |
| <code>klp_mode_toolbar.dart → klp_mode_tool_slot_child.dart</code> | import | [lib/src/features/editing/contracts/klp_mode_toolbar.dart:2](../../../../../../lib/src/features/editing/contracts/klp_mode_toolbar.dart#L2) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/editing/contracts"]
	n1["klp_anchored_commands.dart"]
	n2["klp_block_control_slot_child.dart"]
	n3["klp_block_controls.dart"]
	n4["klp_block_note_editing_content.dart"]
	n5["klp_canva_editing_content.dart"]
	n6["klp_command_slot_child.dart"]
	n7["klp_editing_content.dart"]
	n8["klp_editing_host_failure.dart"]
	n9["klp_mode_tool_slot_child.dart"]
	n10["klp_mode_toolbar.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
	n0 -->|"contains"| n9
	n0 -->|"contains"| n10
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_anchored_commands.dart` | KlpAnchoredCommands | [架構與 API](klp_anchored_commands.md) | [lib/src/features/editing/contracts/klp_anchored_commands.dart:1](../../../../../../lib/src/features/editing/contracts/klp_anchored_commands.dart#L1) |
| `klp_block_control_slot_child.dart` | KlpBlockControlSlotChild | [架構與 API](klp_block_control_slot_child.md) | [lib/src/features/editing/contracts/klp_block_control_slot_child.dart:1](../../../../../../lib/src/features/editing/contracts/klp_block_control_slot_child.dart#L1) |
| `klp_block_controls.dart` | KlpBlockControls | [架構與 API](klp_block_controls.md) | [lib/src/features/editing/contracts/klp_block_controls.dart:1](../../../../../../lib/src/features/editing/contracts/klp_block_controls.dart#L1) |
| `klp_block_note_editing_content.dart` | KlpResolvedAsset, KlpBlockNoteEditingContent | [架構與 API](klp_block_note_editing_content.md) | [lib/src/features/editing/contracts/klp_block_note_editing_content.dart:1](../../../../../../lib/src/features/editing/contracts/klp_block_note_editing_content.dart#L1) |
| `klp_canva_editing_content.dart` | KlpCanvaEditingContent | [架構與 API](klp_canva_editing_content.md) | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:1](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L1) |
| `klp_command_slot_child.dart` | KlpCommandSlotChild | [架構與 API](klp_command_slot_child.md) | [lib/src/features/editing/contracts/klp_command_slot_child.dart:1](../../../../../../lib/src/features/editing/contracts/klp_command_slot_child.dart#L1) |
| `klp_editing_content.dart` | KlpEditingContent | [架構與 API](klp_editing_content.md) | [lib/src/features/editing/contracts/klp_editing_content.dart:1](../../../../../../lib/src/features/editing/contracts/klp_editing_content.dart#L1) |
| `klp_editing_host_failure.dart` | KlpEditingHostOrigin, KlpEditingHostPhase, KlpEditingHostFailure, KlpEditingHostFailureSink | [架構與 API](klp_editing_host_failure.md) | [lib/src/features/editing/contracts/klp_editing_host_failure.dart:1](../../../../../../lib/src/features/editing/contracts/klp_editing_host_failure.dart#L1) |
| `klp_mode_tool_slot_child.dart` | KlpModeToolSlotChild | [架構與 API](klp_mode_tool_slot_child.md) | [lib/src/features/editing/contracts/klp_mode_tool_slot_child.dart:1](../../../../../../lib/src/features/editing/contracts/klp_mode_tool_slot_child.dart#L1) |
| `klp_mode_toolbar.dart` | KlpModeToolbar | [架構與 API](klp_mode_toolbar.md) | [lib/src/features/editing/contracts/klp_mode_toolbar.dart:1](../../../../../../lib/src/features/editing/contracts/klp_mode_toolbar.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
