# Workspace.Explorer：宣告 → 組裝

公開入口：`package:kallopis/kallopis_declarative.dart`。契約：**SFC-V1-r1／EXP-V1-r3**。舊 Explorer callbacks、consumer drop query、callback command 與專用 Widget 已移除，不提供相容入口。2026-09-15 使用者已接受目前 [Explorer Catalog 基準](explorer-catalog.md)；產品組裝另行驗收。

## 職責與合法組裝

Consumer 用 method 包裝節點，或 implements `KlpExplorerItemModel` 加上產品欄位；本庫只讀 `id`、`role`、`canHaveChildren`、`row`、`capabilities`、`children`。Item 是資料，不是可註冊的元件或 renderer。

| 層級／功能 | Consumer 決定 | KLP 決定 |
| --- | --- | --- |
| `Workspace.Explorer` | 資料投影、出現 ID、有限能力、完整狀態、事件提交 | 合法結構、快照、選取／鍵盤／拖放機制、列布局 |
| Explorer command | command ID、label、輸入／確認資料；收到 intent 後執行產品命令 | 共用選單、輸入、確認視覺與暫態生命週期 |
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
	required void Function(KlpExplorerIntent) onIntent,
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
			KlpExplorer(id: treeId, data: data, onIntent: onIntent),
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
| `KlpExplorerCommand` | 唯一 id、非空 label、enabled／destructive 與可選 input／confirmation／shortcut；只描述命令，不接受 callback |
| `KlpExplorerRowData` | 非空 title、optional icon／badge；inlineActions 與 contextActions 為各自獨立的 `KlpExplorerCommand` 清單；命令 ID 在同一 item 內不得重複 |
| `KlpExplorerGlyph` | file／folder／image／music／board；只決定圖示，不決定產品型別或能力 |
| `KlpExplorerTreeData` | id、items、expandedIds；展開 ID 必須存在且可收合；一般節點須非空，分類可為空 |
| `KlpExplorerSelectionScope` | id、有序 treeIds、mode none／single／multiple、selectedIds、optional anchorId；每棵樹恰屬一個 scope |
| `KlpExplorerDropAcceptance` | 預先宣告精確 sourceIds／targetId／position；capture 時驗證結構並固定，不在手勢期間查詢 consumer |
| `KlpExplorerData` | 完整 trees、selectionScopes 與 acceptedDrops；首次 capture 固定不可變快照；更新須建立新 data |
| `KlpExplorer` | id 必須為 data 的樹 ID；只接受 `data`、單一 `onIntent` 與可選 `controller`；有互動能力時 handler 必填 |
| `KlpExplorerSelectionRequested` | 收到 scopeId、selectedIds、anchorId；多選 consumer 同批持有 selectedIds 及 anchorId |
| `KlpExplorerActivationRequested` | 收到 itemId，由 consumer 決定導覽或其他主動作 |
| `KlpExplorerExpansionRequested` | 收到 itemId、expanded 與完整 expandedIds 提案；consumer 決定是否提交新 data |
| `KlpExplorerDropRequested` | 收到 sourceIds、targetId、position；consumer 執行移動／參考與持久化，再提交新投影 |
| `KlpExplorerCommandRequested` | 收到 itemId、commandId 與可選 input；consumer 執行產品命令 |
| `data.expandedIdsAfter(id, expanded, collapseDescendants: false)` | 從已確認快照計算該項所屬樹的不可變完整展開集合；設 true 時收合所有後代含隱藏後代。只回傳提案，不提交；未知或不可切換項拋 `explorer_invalid_expansion` |
| `KlpExplorerController` | 可選的一次性 `focusItem`／`revealItem` 命令；回傳 completed／unavailable／targetMissing／superseded，不暴露 Flutter controller |
| chrome 文案 | Actions／Expand／Collapse 由唯一 `KlpLocalizations` 提供，不是 feature constructor 輸入 |

節點圖示以同層固定起點對齊：圖示左側保留同寬箭頭欄，只有可展開節點顯示箭頭，子項有無不改圖示位置。這個空間用於結構對齊，不是 consumer 可改的插槽。分類箭頭仍在標題後；節點箭頭保持前置。兩者共用 disclosureIconExtent（預設 12px），一般圖示與箭頭命中寬度仍各為 20px。

出現 ID 與產品資料 ID 可不同。同一產品資料多處出現必須給不同 ID；KLP 不自行連動。`KlpId` 字串的階層不決定 Explorer 父子。

### 多棵樹與選取

先建立全部 TreeData，再建立一份 Data，最後以各 tree.id 建立多個 Explorer。同一選取範圍明列多個 treeIds；獨立選取則明列不同 scope。可見順序為 treeIds 順序加每棵樹前序遍歷。收合後隱藏但仍存在的可選節點可保留 selected；anchor 必須存在且可選。

一般點擊分別送選取及已宣告的主動作。Ctrl／⌘、Shift 多選不啟用內容；箭頭只展開；Enter 執行主動作，Space 執行列點擊，方向鍵移動焦點與樹階層。KLP 不在私有狀態保存另一份選取權威。

### 後代收合策略

由產品在 `KlpExplorerExpansionRequested` 處理中選擇 intent 已附的 `expandedIds`，或呼叫 `data.expandedIdsAfter(itemId, expanded, collapseDescendants: true)`，再一次提交回傳集合為該樹的新 `expandedIds`。省略遞迴參數或設 false 會保留後代展開狀態。兩種模式都保留其他樹、選取與原始快照；consumer 未提交則畫面保持上一份已確認狀態。

### 拖放

`draggable=true` 只允許成為來源。Consumer 在建立 `KlpExplorerData` 時，以 `acceptedDrops` 預先列出這一版投影允許的精確放置；缺少 acceptance 一律拒絕。KLP 在 capture、預覽與提交檢查來源、目標、循環與承載能力，手勢期間不重新呼叫產品邏輯；分類只能同樹根層 before／after 排序。Consumer 擁有移動／建立參考等語意、持久化及錯誤回報。

### 命令

`KlpExplorerCommand(id, label, inputLabel?, initialValue?, confirmation?, shortcut?)` 只有不可變呈現資料。使用者確認後，Explorer 透過 `KlpExplorerCommandRequested` 回報 itemId、commandId 與 input；取消不發 intent，過期影格與已卸載宿主不發送殘留提交。執行、非同步、錯誤與產品資料更新都由 consumer 的 intent handler 擁有。

## 維護與驗收

- [型別／捕捉與 adapter](../../lib/src/features/workspace/explorer/klp_explorer.dart)：資料宣告進入唯一結構樹；internal entry 不公開。
- [語意用途](../../lib/src/features/workspace/explorer/internal/klp_explorer_adapter.dart)：nodeExtent、categoryExtent、iconExtent、categoryFontSize、disclosureIconExtent、indent、inset、gap、disclosureExtent、actionExtent 分開維護。人類改一個用途不須改 consumer。
- [Explorer renderer](../../lib/src/rendering/flutter/internal/klp_flutter_explorer.dart) 與 [共用命令 renderer](../../lib/src/rendering/flutter/internal/klp_flutter_commands.dart)：不維護第二份 theme 或預設樣式。
- [真實 Catalog](explorer-catalog.md)：先比較候選外觀，再接受語意值。資料／互動測試通過不等於外觀接受。
- [模組配對](../architecture/explorer-v1-plan/README.md)：開發與跨 agent 交接入口。

新增產品節點類型：在 consumer 實作 interface／method，使用現有能力。需要新能力或新視覺部件：先提出資料、事件與組裝需求，由 KLP 更新契約與 Catalog；其他 agent 不得另建 renderer 或變體。

交接名稱使用 **Workspace.Explorer / EXP-V1-r3**，附本頁與 consumer 自有 compose method。清楚列出採用的能力、selection scope、事件提交者及使用者決定的產品組裝順序。
