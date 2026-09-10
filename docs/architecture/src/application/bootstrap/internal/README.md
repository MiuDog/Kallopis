# lib/src/application/bootstrap/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/application/bootstrap/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/application/bootstrap/internal"]
	n1["lib/src/application/structure"]
	n2["lib/src/application/structure"]
	n3["lib/src/application/structure/internal"]
	n4["lib/src/composition/definitions"]
	n5["lib/src/composition/nodes"]
	n6["lib/src/composition/validation"]
	n7["lib/src/features/navigation/rail/internal"]
	n8["lib/src/foundation/binding/internal"]
	n9["lib/src/kernel/identity"]
	n10["lib/src/kernel/lifecycle/internal"]
	n11["lib/src/runtime/compilation/internal"]
	n0 -->|"import"| n1
	n0 -->|"part of"| n2
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
	n0["lib/src/application/bootstrap/internal"]
	n1["lib/src/runtime/installation/internal"]
	n2["lib/src/styling/primitives"]
	n3["lib/src/styling/references"]
	n4["lib/src/styling/semantics"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/application/structure</code> | import | 2 | [lib/src/application/bootstrap/internal/klp_application_adapters.dart:5](../../../../../../lib/src/application/bootstrap/internal/klp_application_adapters.dart#L5) |
| <code>lib/src/application/structure</code> | part of | 5 | [lib/src/application/bootstrap/internal/klp_application_host.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_application_host.dart#L1) |
| <code>lib/src/application/structure/internal</code> | import | 1 | [lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart:12](../../../../../../lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart#L12) |
| <code>lib/src/composition/definitions</code> | import | 2 | [lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart#L1) |
| <code>lib/src/composition/nodes</code> | import | 2 | [lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart:2](../../../../../../lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart#L2) |
| <code>lib/src/composition/validation</code> | import | 3 | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L1) |
| <code>lib/src/features/navigation/rail/internal</code> | import | 1 | [lib/src/application/bootstrap/internal/klp_application_adapters.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_application_adapters.dart#L1) |
| <code>lib/src/foundation/binding/internal</code> | import | 2 | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:2](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L2) |
| <code>lib/src/kernel/identity</code> | import | 1 | [lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart:5](../../../../../../lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart#L5) |
| <code>lib/src/kernel/lifecycle/internal</code> | import | 2 | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:3](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L3) |
| <code>lib/src/runtime/compilation/internal</code> | import | 10 | [lib/src/application/bootstrap/internal/klp_application_adapters.dart:2](../../../../../../lib/src/application/bootstrap/internal/klp_application_adapters.dart#L2) |
| <code>lib/src/runtime/installation/internal</code> | import | 4 | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:5](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L5) |
| <code>lib/src/styling/primitives</code> | import | 3 | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:7](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L7) |
| <code>lib/src/styling/references</code> | import | 1 | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:9](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L9) |
| <code>lib/src/styling/semantics</code> | import | 3 | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:10](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L10) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_application_adapters.dart → klp_screen_adapter.dart</code> | import | [lib/src/application/bootstrap/internal/klp_application_adapters.dart:6](../../../../../../lib/src/application/bootstrap/internal/klp_application_adapters.dart#L6) |
| <code>klp_application_adapters.dart → klp_retained_screens_adapter.dart</code> | import | [lib/src/application/bootstrap/internal/klp_application_adapters.dart:7](../../../../../../lib/src/application/bootstrap/internal/klp_application_adapters.dart#L7) |
| <code>klp_screen_adapter.dart → klp_prepared_screen.dart</code> | import | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:14](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L14) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/application/bootstrap/internal"]
	n1["klp_application_adapters.dart"]
	n2["klp_application_host.dart"]
	n3["klp_application_host_state.dart"]
	n4["klp_application_session.dart"]
	n5["klp_application_session_actions.dart"]
	n6["klp_application_session_commit.dart"]
	n7["klp_prepared_screen.dart"]
	n8["klp_retained_screens_adapter.dart"]
	n9["klp_screen_adapter.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
	n0 -->|"contains"| n9
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_application_adapters.dart` | klpApplicationAdapters | [架構與 API](klp_application_adapters.md) | [lib/src/application/bootstrap/internal/klp_application_adapters.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_application_adapters.dart#L1) |
| `klp_application_host.dart` | _KlpApplicationHost | [架構與 API](klp_application_host.md) | [lib/src/application/bootstrap/internal/klp_application_host.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_application_host.dart#L1) |
| `klp_application_host_state.dart` | _KlpApplicationHostState | [架構與 API](klp_application_host_state.md) | [lib/src/application/bootstrap/internal/klp_application_host_state.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_application_host_state.dart#L1) |
| `klp_application_session.dart` | _KlpApplicationSession | [架構與 API](klp_application_session.md) | [lib/src/application/bootstrap/internal/klp_application_session.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_application_session.dart#L1) |
| `klp_application_session_actions.dart` | _KlpApplicationEpoch, _KlpSessionRouteActions, _KlpApplicationActionHandler | [架構與 API](klp_application_session_actions.md) | [lib/src/application/bootstrap/internal/klp_application_session_actions.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_application_session_actions.dart#L1) |
| `klp_application_session_commit.dart` | _KlpApplicationSessionCommit | [架構與 API](klp_application_session_commit.md) | [lib/src/application/bootstrap/internal/klp_application_session_commit.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_application_session_commit.dart#L1) |
| `klp_prepared_screen.dart` | KlpPreparedScreen | [架構與 API](klp_prepared_screen.md) | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L1) |
| `klp_retained_screens_adapter.dart` | KlpRetainedScreensAdapter, _PreparedRetainedScreens | [架構與 API](klp_retained_screens_adapter.md) | [lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart#L1) |
| `klp_screen_adapter.dart` | KlpScreenAdapter | [架構與 API](klp_screen_adapter.md) | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
