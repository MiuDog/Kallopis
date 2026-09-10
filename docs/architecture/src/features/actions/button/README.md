# lib/src/features/actions/button：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/actions/button` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/actions/button"]
	n1["lib/src/features/actions/button/internal"]
	n2["lib/src/features/actions/button/primitives"]
	n3["lib/src/features/overlays"]
	n4["lib/src/foundation"]
	n5["lib/src/foundation/content"]
	n6["lib/src/foundation/interaction"]
	n7["lib/src/foundation/interaction/controls"]
	n8["lib/src/foundation/interaction/internal"]
	n9["lib/src/foundation/layout"]
	n10["lib/src/foundation/surface"]
	n11["lib/src/styling/legacy_theme"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
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
	n0["lib/src/features/actions/button"]
	n1["package:flutter"]
	n0 -->|"import"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/actions/button/internal</code> | part | 6 | [lib/src/features/actions/button/klp_button.dart:14](../../../../../../lib/src/features/actions/button/klp_button.dart#L14) |
| <code>lib/src/features/actions/button/primitives</code> | part | 2 | [lib/src/features/actions/button/klp_button.dart:17](../../../../../../lib/src/features/actions/button/klp_button.dart#L17) |
| <code>lib/src/features/overlays</code> | import | 1 | [lib/src/features/actions/button/klp_icon_button.dart:4](../../../../../../lib/src/features/actions/button/klp_icon_button.dart#L4) |
| <code>lib/src/foundation</code> | import | 1 | [lib/src/features/actions/button/klp_icon_button.dart:3](../../../../../../lib/src/features/actions/button/klp_icon_button.dart#L3) |
| <code>lib/src/foundation/content</code> | import | 1 | [lib/src/features/actions/button/klp_button.dart:7](../../../../../../lib/src/features/actions/button/klp_button.dart#L7) |
| <code>lib/src/foundation/interaction</code> | import | 1 | [lib/src/features/actions/button/klp_button.dart:3](../../../../../../lib/src/features/actions/button/klp_button.dart#L3) |
| <code>lib/src/foundation/interaction/controls</code> | import | 1 | [lib/src/features/actions/button/klp_button.dart:9](../../../../../../lib/src/features/actions/button/klp_button.dart#L9) |
| <code>lib/src/foundation/interaction/internal</code> | import | 1 | [lib/src/features/actions/button/klp_button.dart:8](../../../../../../lib/src/features/actions/button/klp_button.dart#L8) |
| <code>lib/src/foundation/layout</code> | import | 1 | [lib/src/features/actions/button/klp_button.dart:4](../../../../../../lib/src/features/actions/button/klp_button.dart#L4) |
| <code>lib/src/foundation/surface</code> | import | 1 | [lib/src/features/actions/button/klp_button.dart:5](../../../../../../lib/src/features/actions/button/klp_button.dart#L5) |
| <code>lib/src/styling/legacy_theme</code> | import | 2 | [lib/src/features/actions/button/klp_button.dart:6](../../../../../../lib/src/features/actions/button/klp_button.dart#L6) |
| <code>package:flutter</code> | import | 2 | [lib/src/features/actions/button/klp_button.dart:1](../../../../../../lib/src/features/actions/button/klp_button.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_button.dart → klp_button_types.dart</code> | import | [lib/src/features/actions/button/klp_button.dart:10](../../../../../../lib/src/features/actions/button/klp_button.dart#L10) |
| <code>klp_button.dart → klp_button_types.dart</code> | export | [lib/src/features/actions/button/klp_button.dart:12](../../../../../../lib/src/features/actions/button/klp_button.dart#L12) |
| <code>klp_icon_button.dart → klp_icon_button_size.dart</code> | import | [lib/src/features/actions/button/klp_icon_button.dart:6](../../../../../../lib/src/features/actions/button/klp_icon_button.dart#L6) |
| <code>klp_icon_button.dart → klp_icon_button_tone.dart</code> | import | [lib/src/features/actions/button/klp_icon_button.dart:7](../../../../../../lib/src/features/actions/button/klp_icon_button.dart#L7) |
| <code>klp_icon_button.dart → klp_icon_button_size.dart</code> | export | [lib/src/features/actions/button/klp_icon_button.dart:9](../../../../../../lib/src/features/actions/button/klp_icon_button.dart#L9) |
| <code>klp_icon_button.dart → klp_icon_button_tone.dart</code> | export | [lib/src/features/actions/button/klp_icon_button.dart:10](../../../../../../lib/src/features/actions/button/klp_icon_button.dart#L10) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/actions/button"]
	n1["internal/"]
	n2["primitives/"]
	n3["klp_button.dart"]
	n4["klp_button_types.dart"]
	n5["klp_icon_button.dart"]
	n6["klp_icon_button_size.dart"]
	n7["klp_icon_button_tone.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../lib/src/features/actions/button/internal) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../lib/src/features/actions/button/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_button.dart` | 無頂層宣告 | [架構與 API](klp_button.md) | [lib/src/features/actions/button/klp_button.dart:1](../../../../../../lib/src/features/actions/button/klp_button.dart#L1) |
| `klp_button_types.dart` | KlpButtonTone | [架構與 API](klp_button_types.md) | [lib/src/features/actions/button/klp_button_types.dart:1](../../../../../../lib/src/features/actions/button/klp_button_types.dart#L1) |
| `klp_icon_button.dart` | 無頂層宣告 | [架構與 API](klp_icon_button.md) | [lib/src/features/actions/button/klp_icon_button.dart:1](../../../../../../lib/src/features/actions/button/klp_icon_button.dart#L1) |
| `klp_icon_button_size.dart` | KlpIconButtonSize | [架構與 API](klp_icon_button_size.md) | [lib/src/features/actions/button/klp_icon_button_size.dart:1](../../../../../../lib/src/features/actions/button/klp_icon_button_size.dart#L1) |
| `klp_icon_button_tone.dart` | KlpIconButtonTone | [架構與 API](klp_icon_button_tone.md) | [lib/src/features/actions/button/klp_icon_button_tone.dart:1](../../../../../../lib/src/features/actions/button/klp_icon_button_tone.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
