# Workspace.Explorer：宣告 → 組裝

公開入口：`package:kallopis/kallopis_declarative.dart`。契約：**EXP-V1-r3**。舊 Explorer API 與專用 Widget 已移除，不提供相容入口。2026-09-15 使用者已接受目前 [Explorer Catalog 基準](explorer-catalog.md)；產品組裝另行驗收。

## 職責與合法組裝

Consumer 用 method 包裝節點，或 implements `KlpExplorerItemModel` 加上產品欄位；本庫只讀 `id`、`role`、`canHaveChildren`、`row`、`capabilities`、`children`。Item 是資料，不是可註冊的元件或 renderer。

| 層級／功能 | Consumer 決定 | KLP 決定 |
| --- | --- | --- |
| `Workspace.Explorer` | 資料投影、出現 ID、有限能力、完整狀態、事件提交 | 合法結構、快照、選取／鍵盤／拖放機制、列布局 |
| `Workspace.Command` | label、輸入／確認內容、async 執行與結果處理 | 共用選單、輸入及確認視覺與生命週期 |
| 宿主 Frame／Group | 在合法插槽選用、產品功能順序 | 表面、間距與容器布局規則 |
| Explorer 風格 | 不傳 style、padding、尺寸或 Widget | 獨立 semantic 用途與唯一 renderer |

樹根允許 category 或 node。分類之下只允許 node；node 只有 `canHaveChildren=true` 才能承載 node。禁止巢狀分類、重複出現 ID 與循環。`children` 必須完整；`hasChildren` 為其非空的唯讀投影。空的可承載節點合法，不顯示展開箭頭。分類一律顯示箭頭：可收合空分類也能切換；不可收合分類只有向下指示，沒有展開操作。

## 一個完整的組裝函式

以下函式可放在 consumer 的 feature module。`selectedIds`、`expandedIds` 及資料均由 caller 持有；回呼更新產品狀態後，重新呼叫函式產生新宣告。

```dart
import 'package:kallopis/kallopis_declarative.dart';

KlpFrameGroups composeLibrary({
	required Set<KlpId> selectedIds,
	required Set<KlpId> expandedIds,
	required void Function(KlpExplorerSelectionChange) select,
	required void Function(KlpId) activate,
	required void Function(KlpId, bool) expand,
}) {
	final scope = KlpId.root('library');
	final treeId = scope / 'tree';
	KlpExplorerItemModel page(String key, String title) => KlpExplorerNodeModel(
		id: scope / key,
		row: KlpExplorerRowData(title: title, icon: KlpExplorerGlyph.file),
		canHaveChildren: false,
		capabilities: const KlpExplorerCapabilities(selectable: true, primaryAction: KlpExplorerPrimaryAction.activate),
	);
	final tree = KlpExplorerTreeData(
		id: treeId,
		expandedIds: expandedIds,
		items: [KlpExplorerCategoryModel(
			id: scope / 'category',
			row: KlpExplorerRowData(title: '分類'),
			capabilities: const KlpExplorerCapabilities(collapsible: true, primaryAction: KlpExplorerPrimaryAction.toggleExpansion),
			children: [page('entry', '項目')],
		)],
	);
	final data = KlpExplorerData(trees: [tree], selectionScopes: [
		KlpExplorerSelectionScope(id: scope / 'selection', treeIds: [treeId], mode: KlpExplorerSelectionMode.single, selectedIds: selectedIds),
	]);
	return KlpFrameGroups(id: scope / 'groups', groups: [
		KlpFrameGroup(id: scope / 'group', content: [
			KlpExplorer(id: treeId, data: data, onSelectionChanged: select, onActivate: activate, onExpandedChanged: expand),
		]),
	]);
}
```

回傳的 groups 放入 `KlpAppFrame.child`，frame 放入 `KlpAppLayout.child`，layout 放入 `KlpScreen.child`；application／router 依 [既有組裝模板](composition-templates.md)。Explorer 不是 ScreenBody，不直接放進 Screen.child。這個示例不指定任何產品 sidebar 的功能或順序。

## 資料與事件契約

| API | 可宣告內容及限制 |
| --- | --- |
| `KlpExplorerNodeModel` | 必填 id、row、canHaveChildren；children 預設空；final，可用 method 包裝 |
| `KlpExplorerCategoryModel` | 必填 id、row；可承載子節點，能力不因 category 自動啟用或取消 |
| `KlpExplorerCapabilities` | selectable／collapsible／draggable 預設 false；primaryAction 為 none／activate／toggleExpansion，預設 none；toggleExpansion 必須 collapsible |
| `KlpExplorerRowData` | 非空 title、optional icon／badge；inlineActions 與 contextActions 為各自獨立的命令清單；不自動增加「更多」按鈕 |
| `KlpExplorerGlyph` | file／folder／image／music／board；只決定圖示，不決定產品型別或能力 |
| `KlpExplorerTreeData` | id、items、expandedIds；展開 ID 必須存在且可收合；一般節點須非空，分類可為空 |
| `KlpExplorerSelectionScope` | id、有序 treeIds、mode none／single／multiple、selectedIds、optional anchorId；每棵樹恰屬一個 scope |
| `KlpExplorerData` | 完整 trees 與 selectionScopes；首次 capture 固定不可變快照；更新須建立新 data |
| `KlpExplorer` | id 必須為 data 的樹 ID；所有該森林成員須在同一 runtime 掛載，且共用同一 data instance |
| `onSelectionChanged` | 收到 scopeId、selectedIds、anchorId；多選 consumer 同批持有 selectedIds 及 anchorId |
| `onActivate` | 收到出現 ID，由 consumer 決定導覽或其他主動作 |
| `onExpandedChanged` | 收到出現 ID 及 bool；consumer 更新該樹的 expandedIds |
| `data.expandedIdsAfter(id, expanded, collapseDescendants: false)` | 從已確認快照計算該項所屬樹的不可變完整展開集合；設 true 時收合所有後代含隱藏後代。只回傳提案，不提交；未知或不可切換項拋 `explorer_invalid_expansion` |
| `canDrop`／`onDrop` | 接 `KlpExplorerDropRequest(sourceIds, targetId, position)`；position 為 before／inside／after |
| 輔助標籤 | actionsLabel／expandLabel／collapseLabel 由 consumer 翻譯；預設 Actions／Expand／Collapse |

節點圖示以同層固定起點對齊：圖示左側保留同寬箭頭欄，只有可展開節點顯示箭頭，子項有無不改圖示位置。這個空間用於結構對齊，不是 consumer 可改的插槽。分類箭頭仍在標題後；節點箭頭保持前置。兩者共用 disclosureIconExtent（預設 12px），一般圖示與箭頭命中寬度仍各為 20px。

出現 ID 與產品資料 ID 可不同。同一產品資料多處出現必須給不同 ID；KLP 不自行連動。`KlpId` 字串的階層不決定 Explorer 父子。

### 多棵樹與選取

先建立全部 TreeData，再建立一份 Data，最後以各 tree.id 建立多個 Explorer。同一選取範圍明列多個 treeIds；獨立選取則明列不同 scope。可見順序為 treeIds 順序加每棵樹前序遍歷。收合後隱藏但仍存在的可選節點可保留 selected；anchor 必須存在且可選。

一般點擊分別送選取及已宣告的主動作。Ctrl／⌘、Shift 多選不啟用內容；箭頭只展開；Enter 執行主動作，Space 執行列點擊，方向鍵移動焦點與樹階層。KLP 不在私有狀態保存另一份選取權威。

### 後代收合策略

由產品在展開回呼選擇 `data.expandedIdsAfter(id, value, collapseDescendants: true)`，再一次提交回傳集合為該樹的新 `expandedIds`。省略此參數或設 false 會保留後代展開狀態。遞迴模式重新展開父項後，所有可收合後代仍維持收合；不可收合項的能力不被覆蓋。兩種模式都保留其他樹、選取與原始快照。Consumer 未提交則畫面保持上一份已確認狀態。Planist 在自己的 sidebar 回呼預設選擇 true，KLP 不辨識產品名稱。

### 拖放

`draggable=true` 只允許成為來源。結構合法且本次 `canDrop` 明確允許才可提交；缺少許可一律拒絕。KLP 在預覽與提交重新檢查來源、目標、循環與承載能力；分類只能同樹根層 before／after 排序。Consumer 擁有移動／建立參考等語意、持久化及錯誤回報。

### 命令

`KlpWorkspaceCommand(label, onInvoke, inputLabel?, initialValue?, confirmation?, onResult?)`。onInvoke 可回傳 Future；結果為 `KlpWorkspaceCommandResult`，status 為 completed／canceled／failed，失敗保留 error／stackTrace。取消不 invoke；過期影格與已卸載宿主不發送殘留提交。Consumer 不把命令結果當第二份資料權威。

## 維護與驗收

- [型別／捕捉與 adapter](../../lib/src/features/workspace/explorer/klp_explorer.dart)：資料宣告進入唯一結構樹；internal entry 不公開。
- [語意用途](../../lib/src/features/workspace/explorer/internal/klp_explorer_adapter.dart)：nodeExtent、categoryExtent、iconExtent、categoryFontSize、disclosureIconExtent、indent、inset、gap、disclosureExtent、actionExtent 分開維護。人類改一個用途不須改 consumer。
- [Explorer renderer](../../lib/src/rendering/flutter/internal/klp_flutter_explorer.dart) 與 [共用命令 renderer](../../lib/src/rendering/flutter/internal/klp_flutter_commands.dart)：不維護第二份 theme 或預設樣式。
- [真實 Catalog](explorer-catalog.md)：先比較候選外觀，再接受語意值。資料／互動測試通過不等於外觀接受。
- [模組配對](../architecture/explorer-v1-plan/README.md)：開發與跨 agent 交接入口。

新增產品節點類型：在 consumer 實作 interface／method，使用現有能力。需要新能力或新視覺部件：先提出資料、事件與組裝需求，由 KLP 更新契約與 Catalog；其他 agent 不得另建 renderer 或變體。

交接名稱使用 **Workspace.Explorer / EXP-V1-r3**，附本頁與 consumer 自有 compose method。清楚列出採用的能力、selection scope、事件提交者及使用者決定的產品組裝順序。
