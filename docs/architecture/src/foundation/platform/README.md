# lib/src/foundation/platform：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/foundation/platform` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/foundation/platform"]
	n1["dart:async"]
	n2["dart:ui"]
	n3["lib/src/capabilities/environment"]
	n4["lib/src/capabilities/environment"]
	n5["lib/src/kernel/identity"]
	n6["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"export"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>dart:async</code> | import | 1 | [lib/src/foundation/platform/klp_id_scope.dart:1](../../../../../lib/src/foundation/platform/klp_id_scope.dart#L1) |
| <code>dart:ui</code> | import | 1 | [lib/src/foundation/platform/klp_platform_info.dart:1](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L1) |
| <code>lib/src/capabilities/environment</code> | export | 5 | [lib/src/foundation/platform/klp_adaptive_mode.dart:2](../../../../../lib/src/foundation/platform/klp_adaptive_mode.dart#L2) |
| <code>lib/src/capabilities/environment</code> | import | 1 | [lib/src/foundation/platform/klp_platform_info.dart:4](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L4) |
| <code>lib/src/kernel/identity</code> | import | 2 | [lib/src/foundation/platform/klp_id_context.dart:3](../../../../../lib/src/foundation/platform/klp_id_context.dart#L3) |
| <code>package:flutter</code> | import | 5 | [lib/src/foundation/platform/klp_environment_context.dart:1](../../../../../lib/src/foundation/platform/klp_environment_context.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_environment_context.dart → klp_environment_scope.dart</code> | import | [lib/src/foundation/platform/klp_environment_context.dart:3](../../../../../lib/src/foundation/platform/klp_environment_context.dart#L3) |
| <code>klp_environment_context.dart → klp_platform_info.dart</code> | import | [lib/src/foundation/platform/klp_environment_context.dart:4](../../../../../lib/src/foundation/platform/klp_environment_context.dart#L4) |
| <code>klp_environment_scope.dart → klp_platform_info.dart</code> | import | [lib/src/foundation/platform/klp_environment_scope.dart:3](../../../../../lib/src/foundation/platform/klp_environment_scope.dart#L3) |
| <code>klp_id_context.dart → klp_id_scope.dart</code> | import | [lib/src/foundation/platform/klp_id_context.dart:4](../../../../../lib/src/foundation/platform/klp_id_context.dart#L4) |
| <code>klp_platform_info.dart → klp_app_platform.dart</code> | import | [lib/src/foundation/platform/klp_platform_info.dart:5](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L5) |
| <code>klp_platform_info.dart → klp_device_class.dart</code> | import | [lib/src/foundation/platform/klp_platform_info.dart:6](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L6) |
| <code>klp_platform_info.dart → klp_display_mode.dart</code> | import | [lib/src/foundation/platform/klp_platform_info.dart:7](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L7) |
| <code>klp_platform_info.dart → klp_orientation.dart</code> | import | [lib/src/foundation/platform/klp_platform_info.dart:8](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L8) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/foundation/platform"]
	n1["klp_adaptive_mode.dart"]
	n2["klp_app_platform.dart"]
	n3["klp_device_class.dart"]
	n4["klp_display_mode.dart"]
	n5["klp_environment_context.dart"]
	n6["klp_environment_scope.dart"]
	n7["klp_id_context.dart"]
	n8["klp_id_scope.dart"]
	n9["klp_orientation.dart"]
	n10["klp_platform_info.dart"]
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
| `klp_adaptive_mode.dart` | 無頂層宣告 | [架構與 API](klp_adaptive_mode.md) | [lib/src/foundation/platform/klp_adaptive_mode.dart:1](../../../../../lib/src/foundation/platform/klp_adaptive_mode.dart#L1) |
| `klp_app_platform.dart` | 無頂層宣告 | [架構與 API](klp_app_platform.md) | [lib/src/foundation/platform/klp_app_platform.dart:1](../../../../../lib/src/foundation/platform/klp_app_platform.dart#L1) |
| `klp_device_class.dart` | 無頂層宣告 | [架構與 API](klp_device_class.md) | [lib/src/foundation/platform/klp_device_class.dart:1](../../../../../lib/src/foundation/platform/klp_device_class.dart#L1) |
| `klp_display_mode.dart` | 無頂層宣告 | [架構與 API](klp_display_mode.md) | [lib/src/foundation/platform/klp_display_mode.dart:1](../../../../../lib/src/foundation/platform/klp_display_mode.dart#L1) |
| `klp_environment_context.dart` | KlpEnvironmentContext | [架構與 API](klp_environment_context.md) | [lib/src/foundation/platform/klp_environment_context.dart:1](../../../../../lib/src/foundation/platform/klp_environment_context.dart#L1) |
| `klp_environment_scope.dart` | KlpEnvironmentScope | [架構與 API](klp_environment_scope.md) | [lib/src/foundation/platform/klp_environment_scope.dart:1](../../../../../lib/src/foundation/platform/klp_environment_scope.dart#L1) |
| `klp_id_context.dart` | KlpIdBuildContext | [架構與 API](klp_id_context.md) | [lib/src/foundation/platform/klp_id_context.dart:1](../../../../../lib/src/foundation/platform/klp_id_context.dart#L1) |
| `klp_id_scope.dart` | KlpIdScope | [架構與 API](klp_id_scope.md) | [lib/src/foundation/platform/klp_id_scope.dart:1](../../../../../lib/src/foundation/platform/klp_id_scope.dart#L1) |
| `klp_orientation.dart` | 無頂層宣告 | [架構與 API](klp_orientation.md) | [lib/src/foundation/platform/klp_orientation.dart:1](../../../../../lib/src/foundation/platform/klp_orientation.dart#L1) |
| `klp_platform_info.dart` | KlpPlatformInfo | [架構與 API](klp_platform_info.md) | [lib/src/foundation/platform/klp_platform_info.dart:1](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
