# Explorer 契約 v1 — 實作配對

修訂：EXP-V1-r1。依據：[已接受規格](../../../spec/explorer-composition.md)。

## 本次接線與清理修訂 EXP-V1-r2

使用者於實作中再次要求清理舊架構。本輪繼續接線及刪除，不以 DATA 並存作為交付。r1 的 13 項資料測試已通過；下列規則接續它，其餘契約維持。

- `explorer/klp_explorer.dart` 接替舊 `components/klp_explorer.dart`。`KlpExplorer({required id, required data, actionsLabel='Actions', expandLabel='Expand', collapseLabel='Collapse', onSelectionChanged?, onActivate?, onExpandedChanged?, canDrop?, onDrop?})`；id 即 data 所選樹 ID。
- `KlpExplorerData({required trees, required selectionScopes})` 只接資料，首次結構 capture 快取完整 snapshot。同一森林各 Explorer 必須在同一 runtime 使用同一 data instance；資料變更建立新宣告。快取僅固定這份宣告，不是可寫 SnapshotStore。
- 本庫 `internal/klp_explorer_entry_node.dart` 為封閉結構包裝，不匯出。根 ID 保留 `kallopis.explorer`，內部 item 改 `kallopis.explorer.entry`；階層只从 snapshot 投影，無舊 item schema。
- scope 加 optional `anchorId`，須為範圍內存在且可選取的項目。`KlpExplorerSelectionChange({required scopeId, required selectedIds, required anchorId})` 供 onSelectionChanged；共享 consumer 同批更新 selectedIds/anchorId。onActivate 接 KlpId；onExpandedChanged 接 (KlpId,bool)；canDrop 為 r1 permission；onDrop 接 DropRequest。回呼受 frame lease 保護。
- Explorer adapter 分離至 `explorer/internal/klp_explorer_adapter.dart`，在原 catalog 順序替換兩個 Explorer 定義；tabs/window 保持。bound 仍在 workspace/presentation，採平坦可見順序；renderer 不再次用產品角色推導行為。
- 新 renderer `flutter/internal/klp_flutter_explorer.dart` 接替共享 workspace_components 中所有 Explorer 專用邏輯。`flutter/internal/klp_flutter_commands.dart` 是 Explorer 與 WorkspaceBlock 唯一命令選單／輸入／確認呈現。
- `KlpWorkspaceCommand.onInvoke` 接 FutureOr<void>，optional onResult 接 `KlpWorkspaceCommandResult`；status 為 completed/canceled/failed，failed 保留 error/stackTrace。兩個 adapter 都轉接，取消不 invoke、dispose 不觸發殘留提交，結果不代替 consumer 資料提交。
- Explorer 獨立 semantic key：categoryExtent/nodeExtent/iconExtent/categoryFontSize/indent/inset/gap/disclosureExtent/actionExtent；沿用現有 primitive 原料，移除 row-inset、font-gap 衍生。普通樹透明，命令表面另取 semantic surface；真實 Catalog 外觀 human-pending。
- 刪除舊 Widget Explorer 五個專用檔：navigation/widgets/explorer/klp_explorer.dart、klp_explorer_models.dart、models/klp_explorer_category.dart、klp_explorer_node.dart、klp_explorer_node_kind.dart，以及 foundation 的兩個 Explorer export。相鄰 KlpFileExplorer 為不屬本次替換的其他 Stable API，保留。
- 同批遷移 declarative export、feature/application 清冊、Catalog 導航/specimen，以及 Planist sidebar explorer/outline/drag 三個接線檔。Planist 從完整投影建立有效狀態；不在 KLP 加產品特例，不改持久資料。
- 舊 Sidebar v2 Explorer 計畫及舊 Explorer 專用架構頁由 r2 取代；來源 atlas 刪除失效條目。歷史配對 JSON 不列為現行指令。

目前配對 features、rendering、application、Planist workspace；BUILD 各自精確 packet，獨立 Test Author 維護受影響測試。新接線冷啟動估算 20k–40k tokens／60–150 分：M1 新 API/feature 清理；M2 renderer/受控互動；M3 consumer/Catalog/清理證據。超過 50k tokens 或 180 分回報；未量測 token 不臆測。

目前可執行切片為 **EXP-DATA-01：資料／能力／完整快照**。這是 features 內的純資料邊界；不發布第二套 Explorer renderer。整體 v1 尚未交付，consumer 匯出與舊 API 移除須在 renderer、Catalog 及呼叫端配對完成後一次切換。

## 責任與順序

| 切片 | 所有者及範圍 | 規格 | 驗收 |
| --- | --- | --- | --- |
| EXP-DATA-01 | features：item interface、有限能力、完整森林／選取範圍快照、拖放結構資格 | EXP-01/03/04/09/10，EXP-02/11/12/14 的資料面 | 外部實作、非法結構／狀態拒絕、快照不可變、跨樹範圍順序、拖放預設拒絕的獨立測試 |
| EXP-RENDER-02 | features/rendering：封閉節點接合、受控事件、鍵盤、命令共用呈現 | EXP-02/06/07/11/12/13/14 | 真實 runtime 更新失敗保留舊影格；選取、啟用、展開及命令分離；提交時再次驗證拖放 |
| EXP-CATALOG-03 | styling/features/application：獨立語意尺度及真實 Catalog | EXP-05/15 | 正常／選取／焦點／長文字／深層／命令／命中範圍；外觀 human-pending |
| EXP-CUTOVER-04 | 公開 library／文件／Catalog 清冊、Planist 自有呼叫端 | EXP-08/16 | 同批替換、刪除舊 Explorer API 與專用實作、無 shim、完整宣告→組裝文件 |

後三項是本版本尚須完成的配對責任，沒有授權目前 DATA worker 修改其他模組。不得把 DATA 完成標為整體 v1 完成。其他 stage（例如 KBF 的 page reference）須於接線前重新配對，不能直接套用舊 file/category 判定。

## EXP-DATA-01 精確契約

模組 root 為 `lib/src/features`；不增加架構層。檔案限 `workspace/explorer/` 下本計畫列明的資料契約與快照實作。

- `klp_explorer_model.dart`：本切片資料 barrel，僅供模組配對與測試；尚不由 `kallopis_declarative.dart` 匯出。
- `contracts/klp_explorer_item_model.dart`：`KlpExplorerItemModel` 為 consumer 可 implements 的 interface，只有 `id`、`role`、`canHaveChildren`、`row`、`capabilities`、`children`。`KlpExplorerRole` 只有 `category/node`。`hasChildren` 是 extension 投影，不是 interface 輸入。
- `KlpExplorerNodeModel`、`KlpExplorerCategoryModel` 是可直接使用的 final 資料類。Node constructor 必填 `canHaveChildren`；分類可承載節點。Consumer 類型可用 getter 固定能力，或由 method 封裝上述值。KLP 不辨識產品 class 名稱。
- `KlpExplorerCapabilities` 的 `selectable/collapsible/draggable` 預設 false；`primaryAction` 為 `none/activate/toggleExpansion`，預設 none。切換展開需要 collapsible，空 children 不代表失去承載能力。
- `KlpExplorerRowData`：必填 `title`；optional `icon`、`badge`；`inlineActions/contextActions` 分開宣告，均為既有 `KlpWorkspaceCommand` 資料。`KlpExplorerGlyph` 有 file/folder/image/music/board，僅圖示語意，不推導角色或行為。沒有 style/尺寸/Widget/任意插槽。
- `contracts/klp_explorer_tree_data.dart`：`KlpExplorerTreeData(id, items, expandedIds)`；`KlpExplorerSelectionScope(id, treeIds, mode, selectedIds)`。所有參數使用具名 constructor。`mode` 為 `none/single/multiple`，必填。treeIds 明列有序成員；每棵樹恰屬一個範圍。不同 scope 的選取完全獨立。共用範圍可包含多棵樹；範圍可見順序為 treeIds 順序加各樹前序遍歷。
- `klp_explorer_snapshot.dart` 為模組間唯讀入口：`KlpExplorerSnapshot.capture({required trees, required selectionScopes})` 全量驗證後才回傳。輸入只讀一次並複製；不保留可變 interface 或輸入 collection。沒有局部修補或第二份持久狀態。
- 快照欄位：`items: Map<KlpId, KlpExplorerItemSnapshot>`、`trees: Map<KlpId, KlpExplorerTreeSnapshot>`、`selectionScopes: Map<KlpId, KlpExplorerSelectionScope>`、`scopeByTree: Map<KlpId, KlpId>`。item 有 id/role/canHaveChildren/row/capabilities/parentId/treeId/childIds；tree 有 id/rootIds/expandedIds/visibleIds。集合皆不可變。
- `visibleIdsForScope(scopeId)` 回傳該範圍完整可見順序，`selectableIdsForScope(scopeId)` 排除不可選取列。收合隱藏子項；非 collapsible 的子項一直可見。selected 可含收合後不可見但仍存在且可選取的項目。
- 不依 KlpId 的字串階層推導 Explorer 父子；Explorer children 才是階層來源。森林內 tree/item 出現身分不得重複；scope ID 是獨立識別域。使用明確堆疊遍歷，不施加產品深度上限。
- 錯誤使用 `KlpContractError`：`explorer_cycle`、`explorer_duplicate_id`、`explorer_invalid_role`（非 root category）、`explorer_children_not_allowed`、`explorer_invalid_primary_action`、`explorer_invalid_title`、`explorer_invalid_scope`、`explorer_invalid_selection`、`explorer_invalid_expansion`。任何 getter 失敗亦使 capture 失敗；不吞掉錯誤。完整 capture 成功後才交付，runtime 上次影格保留由 RENDER 切片驗證。
- `KlpExplorerDropRequest({required sourceIds, required targetId, required position})`、`KlpExplorerDropPlacement.before/inside/after`；`snapshot.permitsDrop(request, {permission})` 沒有 permission 即 false。拒絕空來源、未知來源／目標、不可拖來源、自我／可见樹判定的後代循環、非法分類巢狀、不可承載的 inside。分類只允許同樹 root before/after 重新排序。節點可在可承載分類／節點 inside，或合法位置 before/after，跨樹仍須 consumer 許可。每次呼叫均重新詢問 permission，不快取；不更動任何資料，不執行業務提交。

刻意不建立 SnapshotStore：現有 runtime 已擁有影格交易；本切片只提供純驗證結果，避免雙狀態權威。也不讓 item interface 成為 KlpNode 或註冊 renderer 的入口；RENDER 由有限本庫結構節點接合既有唯一結構樹。

## 受保護測試與證據

測試為 `test/klp_explorer_model_contract_test.dart`，由 fresh-context Test Author 獨立維護。必要性是外部可變 interface、跨樹身分／狀態一致性及移動資格無法由截圖可靠驗收。產品 worker 不改測試。

Task Packet、隔離 snapshot base 與 scope evidence 放在工作樹外。冷啟動估算 10k–22k tokens／35–90 分鐘；無可比歷史 task ID。M1 資料／快照可編譯（6k／30 分），M2 獨立測試與 scope pass（16k／70 分）；超過 26k tokens 或 110 分鐘報異常。依據實際工具輸出報完成，未量測的 token 不臆測。
