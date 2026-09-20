# Direct Workspace 能力差異審核

日期：2026-09-20

基線：薄型架構切換前的 `0edbc3e0^` 與切換 commit `0edbc3e0`。本審核只追蹤舊
workspace public surface 中具有產品無關視覺或互動價值的能力；application、navigation
machine、declarative node、adapter、bound model 與 renderer 依 KLP-0022 屬刻意移除，
不視為待恢復元件。

## 直接能力對照

| 舊 public family | 現行直接 Flutter owner | 結果 |
| --- | --- | --- |
| `KlpAppLayout`、`LayoutRow`／`LayoutColumn`、pane、frame、spacer、resize gutter | 同名 `KlpAppLayout` 系列 | 已恢復；保留遞迴布局、8px gap／gutter、frame role／surface 與 floating action，移除 ID／slot tree。 |
| `KlpFrameGroups`、`KlpFrameGroup`、padding／divider style | 同名 Frame Groups 系列 | 已恢復；保留固定 footer、主內容捲動、五種 divider 與 8px 語意。 |
| `KlpDocumentTabs`、tab data、selection／close／pin intents | `KlpDocumentTabs`、`KlpDocumentTab` 與 callbacks | 已恢復；受控資料與 callback 取代 intent node，保留 dirty、pin、close、鍵盤及 accessibility。 |
| `KlpAnchoredPopup`、item、state、open reason | 同名 `KlpAnchoredPopup` 系列 | 已恢復；直接 Widget builder 取代 slot／renderer，保留受控 open、定位、focus 與 feedback。 |
| `KlpWorkspaceCommand`、result、shortcut | 同名 command 系列與 `showKlpWorkspaceCommand` | 已恢復；保留輸入、確認、async invoke 與結果流程，不接管產品提交狀態。 |
| `KlpWindowControls`、`KlpWindowCommands` | `KlpWindowControls`、`KlpAppWindowHeader` | 已由既有直接 Widget 覆蓋；命令以建構 callback 傳入，不需要第二個 commands node。 |
| `KlpExplorer`、controller／snapshot／tree models | `KlpFileExplorer`、`KlpFileExplorerSection`、`KlpFileExplorerItem` | 已由 EXP-V1 直接替換；產品資料投影與事件 callback 取代 capture／adapter／snapshot runtime。 |
| `KlpWorkspaceBlock`、content／item／choice 與 kind enums | 具名 foundation／experimental components | 不恢復總 schema；各 kind 的完整去向見 Workspace Block 能力審核。 |

## 刻意移除的中介層

- `Klp*Adapter`：只把 node 轉成 prepared／bound 資料，直接 Widget API 不再需要。
- `KlpBound*`：複製產品資料與事件的第二份 presentation model，不再是公開能力。
- `KlpFlutter*` renderer：元件本身即 Flutter Widget，不再另建 renderer family。
- `KlpId`、slot、children qualification：產品 Widget tree 由 consumer 擁有，不建立全域樹。
- application host、router、navigation machine、state controller：屬產品流程與狀態 owner。
- editing host／bridge：依 KLP-0023 移交 Planist Flow／Canva modules。

## 完成證據

- 上述恢復 family 全部可由 `kallopis_foundation.dart` 取得，並出現在正式 API reference。
- Catalog 提供 App Layout／floating action、Frame Groups、Document Tabs 與 Anchored Popup／Command 的可操作 specimen。
- `klp_restored_workspace_contract_test.dart` 直接驗證受控 tabs、固定 footer、popup open ownership，以及 8px layout／floating-action clamp。
- Explorer、Window Controls 與 Workspace Block 各有現行 Catalog／測試或獨立能力對照，不依賴舊 runtime。

因此，薄型架構切換所刪除的直接 workspace 能力均已恢復、由既有元件取代，或依新責任
邊界明確拒絕；目前沒有未分類的 direct workspace family。
