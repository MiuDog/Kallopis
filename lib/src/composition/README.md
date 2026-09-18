# lib/src/composition：結構樹與插槽契約

[返回上層 (lib/src)](../README.md)

## 目錄職責

`lib/src/composition` 負責 Kallopis 純 Dart 宣告式結構樹的定義、合法資格標記、受限插槽系統、元件註冊依賴檢查，以及不可變結構快照的單次擷取。它保證進入 runtime 編譯期之前的結構樹必須在語意、相依與插槽配置上 100% 合法。

## 子目錄結構與職責

| 子目錄 | 核心職責 | 關鍵型別與實作 |
|---|---|---|
| `definitions/` | **元件定義與規格 (Definitions)**：定義元件靜態規格 `KlpDefinition`，綁定元件類型、其所屬語意用途 (Semantics owner) 以及子插槽綱要 (Slot schema)。 | `KlpDefinition` |
| `nodes/` | **節點宣告介面 (Nodes)**：定義純 Dart 樹節點基本介面 `KlpNode`、複合節點 `KlpCompositeNode`、內部作用域邊界 `KlpScopeBoundary`，嚴禁節點帶有任何 Flutter Widget 渲染能力。 | `KlpNode`, `KlpCompositeNode`, `klp_scope_boundary.dart` |
| `slots/` | **受限插槽與資格標籤 (Slots)**：以物件身分、型別資格與數量限制嚴格定義子插槽 `KlpSlot<C>` 與子項容器 `KlpChildren`；並定義特定容器所要求的語意資格（如 `KlpScreenBody`）。 | `KlpSlot`, `KlpChildren`, `KlpScreenBody`, `KlpSlotAssignment` |
| `registry/` | **註冊表與靜態依賴驗證 (Registry)**：集中管理元件定義 `KlpRegistry`，在編譯前全量檢驗元件定義之間的循環依賴、跨定義語意引用公開性以及未公開用途的非法存取。 | `KlpRegistry` |
| `validation/` | **單次擷取與結構快照 (Validation)**：透過 `KlpTreeCapture` 對整棵宣告樹進行單次結構擷取，驗證插槽完整覆蓋與型別資格，產生凍結的不可變快照 `KlpValidatedTree` 與 `KlpValidatedNode`。 | `KlpValidatedTree`, `KlpValidatedNode`, `internal/klp_tree_capture.dart` |

## 架構依賴與邊界約定

- **零 UI 污染**：此目錄純粹由純 Dart 物件組成，不依賴 `package:flutter`，不能存取任何 `BuildContext` 或 Widget。
- **快照凍結原則**：經由 `KlpTreeCapture` 驗證後的不可變快照不再讀取消費端節點的任何 getter，杜絕執行期間結構樹因副作用動態改變。
- **插槽封閉性**：複合節點的子項只能透過 `KlpChildren` 依插槽定義提供，禁止任意無型別約束的 `List<Widget>` 傳遞。
