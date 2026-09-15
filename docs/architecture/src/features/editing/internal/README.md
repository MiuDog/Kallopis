# lib/src/features/editing/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/editing/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/editing/internal"]
	n1["dart:async"]
	n2["lib/src/capabilities/editing/contracts"]
	n3["lib/src/capabilities/state"]
	n4["lib/src/composition/validation"]
	n5["lib/src/features/editing/contracts"]
	n6["lib/src/features/editing/presentation"]
	n7["lib/src/foundation/binding/contracts"]
	n8["lib/src/kernel/diagnostics"]
	n9["lib/src/kernel/lifecycle"]
	n10["lib/src/runtime/contracts"]
	n11["lib/src/styling/primitives"]
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
flowchart TD
	n0["lib/src/features/editing/internal"]
	n1["lib/src/styling/references"]
	n2["lib/src/styling/semantics"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>dart:async</code> | import | 1 | [lib/src/features/editing/internal/klp_editing_placement.dart:2](../../../../../../lib/src/features/editing/internal/klp_editing_placement.dart#L2) |
| <code>lib/src/capabilities/editing/contracts</code> | import | 23 | [lib/src/features/editing/internal/klp_editing_placement.dart:4](../../../../../../lib/src/features/editing/internal/klp_editing_placement.dart#L4) |
| <code>lib/src/capabilities/state</code> | import | 2 | [lib/src/features/editing/internal/klp_editing_placement.dart:22](../../../../../../lib/src/features/editing/internal/klp_editing_placement.dart#L22) |
| <code>lib/src/composition/validation</code> | import | 2 | [lib/src/features/editing/internal/klp_editing_placement.dart:24](../../../../../../lib/src/features/editing/internal/klp_editing_placement.dart#L24) |
| <code>lib/src/features/editing/contracts</code> | import | 2 | [lib/src/features/editing/internal/klp_block_note_editing_semantics.dart:1](../../../../../../lib/src/features/editing/internal/klp_block_note_editing_semantics.dart#L1) |
| <code>lib/src/features/editing/presentation</code> | import | 3 | [lib/src/features/editing/internal/klp_editing_placement.dart:1](../../../../../../lib/src/features/editing/internal/klp_editing_placement.dart#L1) |
| <code>lib/src/foundation/binding/contracts</code> | import | 1 | [lib/src/features/editing/internal/klp_prepared_editing.dart:7](../../../../../../lib/src/features/editing/internal/klp_prepared_editing.dart#L7) |
| <code>lib/src/kernel/diagnostics</code> | import | 2 | [lib/src/features/editing/internal/klp_editing_placement.dart:25](../../../../../../lib/src/features/editing/internal/klp_editing_placement.dart#L25) |
| <code>lib/src/kernel/lifecycle</code> | import | 1 | [lib/src/features/editing/internal/klp_prepared_editing.dart:8](../../../../../../lib/src/features/editing/internal/klp_prepared_editing.dart#L8) |
| <code>lib/src/runtime/contracts</code> | import | 4 | [lib/src/features/editing/internal/klp_editing_placement.dart:26](../../../../../../lib/src/features/editing/internal/klp_editing_placement.dart#L26) |
| <code>lib/src/styling/primitives</code> | import | 5 | [lib/src/features/editing/internal/klp_block_note_editing_semantics.dart:2](../../../../../../lib/src/features/editing/internal/klp_block_note_editing_semantics.dart#L2) |
| <code>lib/src/styling/references</code> | import | 2 | [lib/src/features/editing/internal/klp_block_note_editing_semantics.dart:4](../../../../../../lib/src/features/editing/internal/klp_block_note_editing_semantics.dart#L4) |
| <code>lib/src/styling/semantics</code> | import | 6 | [lib/src/features/editing/internal/klp_block_note_editing_semantics.dart:5](../../../../../../lib/src/features/editing/internal/klp_block_note_editing_semantics.dart#L5) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_editing_placement.dart → klp_editor_mode_capability.dart</code> | import | [lib/src/features/editing/internal/klp_editing_placement.dart:27](../../../../../../lib/src/features/editing/internal/klp_editing_placement.dart#L27) |
| <code>klp_prepared_editing.dart → klp_editing_placement.dart</code> | import | [lib/src/features/editing/internal/klp_prepared_editing.dart:12](../../../../../../lib/src/features/editing/internal/klp_prepared_editing.dart#L12) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/editing/internal"]
	n1["klp_block_note_editing_semantics.dart"]
	n2["klp_editing_placement.dart"]
	n3["klp_editing_semantics.dart"]
	n4["klp_editor_mode_capability.dart"]
	n5["klp_prepared_editing.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_block_note_editing_semantics.dart` | KlpBlockNoteEditingSemantics | [架構與 API](klp_block_note_editing_semantics.md) | [lib/src/features/editing/internal/klp_block_note_editing_semantics.dart:1](../../../../../../lib/src/features/editing/internal/klp_block_note_editing_semantics.dart#L1) |
| `klp_editing_placement.dart` | KlpEditingPlacement | [架構與 API](klp_editing_placement.md) | [lib/src/features/editing/internal/klp_editing_placement.dart:1](../../../../../../lib/src/features/editing/internal/klp_editing_placement.dart#L1) |
| `klp_editing_semantics.dart` | KlpEditingSemantics | [架構與 API](klp_editing_semantics.md) | [lib/src/features/editing/internal/klp_editing_semantics.dart:1](../../../../../../lib/src/features/editing/internal/klp_editing_semantics.dart#L1) |
| `klp_editor_mode_capability.dart` | validateKlpEditorModeCapability | [架構與 API](klp_editor_mode_capability.md) | [lib/src/features/editing/internal/klp_editor_mode_capability.dart:1](../../../../../../lib/src/features/editing/internal/klp_editor_mode_capability.dart#L1) |
| `klp_prepared_editing.dart` | KlpPreparedEditing | [架構與 API](klp_prepared_editing.md) | [lib/src/features/editing/internal/klp_prepared_editing.dart:1](../../../../../../lib/src/features/editing/internal/klp_prepared_editing.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
