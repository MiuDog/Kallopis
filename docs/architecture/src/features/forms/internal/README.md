# lib/src/features/forms/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/forms/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/forms/internal"]
	n1["lib/src/application/localization"]
	n2["lib/src/features/actions/button"]
	n3["lib/src/features/collections/advanced"]
	n4["lib/src/features/collections/badge"]
	n5["lib/src/features/collections/code"]
	n6["lib/src/features/feedback"]
	n7["lib/src/features/forms/input"]
	n8["lib/src/features/forms/internal/primitives"]
	n9["lib/src/foundation"]
	n10["lib/src/foundation/content"]
	n11["lib/src/foundation/interaction"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"export"| n3
	n0 -->|"export"| n4
	n0 -->|"export"| n5
	n0 -->|"export"| n6
	n0 -->|"export"| n7
	n0 -->|"part"| n8
	n0 -->|"export"| n9
	n0 -->|"export"| n10
	n0 -->|"export"| n11
```

```mermaid
flowchart LR
	n0["lib/src/features/forms/internal"]
	n1["lib/src/foundation/layout"]
	n2["lib/src/foundation/surface"]
	n3["lib/src/styling/legacy_theme"]
	n4["package:flutter"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"export"| n3
	n0 -->|"export"| n4
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/application/localization</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:26](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L26) |
| <code>lib/src/features/actions/button</code> | export | 2 | [lib/src/features/forms/internal/klp_form_dependencies.dart:3](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L3) |
| <code>lib/src/features/collections/advanced</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:6](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L6) |
| <code>lib/src/features/collections/badge</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:7](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L7) |
| <code>lib/src/features/collections/code</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:8](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L8) |
| <code>lib/src/features/feedback</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:11](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L11) |
| <code>lib/src/features/forms/input</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:5](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L5) |
| <code>lib/src/features/forms/internal/primitives</code> | part | 1 | [lib/src/features/forms/internal/klp_input_frame.dart:4](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L4) |
| <code>lib/src/foundation</code> | export | 2 | [lib/src/features/forms/internal/klp_form_dependencies.dart:9](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L9) |
| <code>lib/src/foundation/content</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:29](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L29) |
| <code>lib/src/foundation/interaction</code> | export | 2 | [lib/src/features/forms/internal/klp_form_dependencies.dart:12](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L12) |
| <code>lib/src/foundation/layout</code> | export | 12 | [lib/src/features/forms/internal/klp_form_dependencies.dart:14](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L14) |
| <code>lib/src/foundation/surface</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:27](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L27) |
| <code>lib/src/styling/legacy_theme</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:28](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L28) |
| <code>package:flutter</code> | export | 1 | [lib/src/features/forms/internal/klp_form_dependencies.dart:1](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_input_frame.dart → klp_form_dependencies.dart</code> | import | [lib/src/features/forms/internal/klp_input_frame.dart:1](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L1) |
| <code>klp_input_frame.dart → klp_input_frame_state.dart</code> | part | [lib/src/features/forms/internal/klp_input_frame.dart:3](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L3) |
| <code>klp_input_frame_state.dart → klp_input_frame.dart</code> | part of | [lib/src/features/forms/internal/klp_input_frame_state.dart:1](../../../../../../lib/src/features/forms/internal/klp_input_frame_state.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/forms/internal"]
	n1["primitives/"]
	n2["klp_form_dependencies.dart"]
	n3["klp_input_frame.dart"]
	n4["klp_input_frame_state.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../lib/src/features/forms/internal/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_form_dependencies.dart` | 無頂層宣告 | [架構與 API](klp_form_dependencies.md) | [lib/src/features/forms/internal/klp_form_dependencies.dart:1](../../../../../../lib/src/features/forms/internal/klp_form_dependencies.dart#L1) |
| `klp_input_frame.dart` | KlpInputFrame | [架構與 API](klp_input_frame.md) | [lib/src/features/forms/internal/klp_input_frame.dart:1](../../../../../../lib/src/features/forms/internal/klp_input_frame.dart#L1) |
| `klp_input_frame_state.dart` | _KlpInputFrameState | [架構與 API](klp_input_frame_state.md) | [lib/src/features/forms/internal/klp_input_frame_state.dart:1](../../../../../../lib/src/features/forms/internal/klp_input_frame_state.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
