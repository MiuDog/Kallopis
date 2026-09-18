# 從產品階段開始使用 Kallopis

這是 consumer 的第一個入口。你不需要先學 `kernel`、`runtime`、`rendering`、`foundation` 或 `styling`，也不需要先記住所有 class。先判斷產品目前在哪個開發階段，再依使用者意圖選能力。

Kallopis 擁有畫面的合法結構、視覺規範、renderer 與互動機制；consumer 擁有產品資料、功能選用、排列順序、導航目的與商業流程。找不到能力時，回報缺口，不以 Flutter Widget、builder、painter 或局部 style 補洞。

## 四個開發階段

| 階段 | 此刻回答的問題 | 輸入 | 產出 | 完成條件 | 此時不要做 |
| --- | --- | --- | --- | --- | --- |
| S1 視覺組成 | 畫面有哪些區域與空容器？ | 產品資訊架構、公開 Klp 能力 | 合法 Screen、layout、frame、group 與空資料 | 不接產品資料也能看見正確結構 | 不設計 persistence、callback、動畫或局部樣式 |
| S2 產品資料模型 | 產品真正保存什麼？ | S1 區域、產品領域規則 | 獨立於 Klp renderer 的產品模型與狀態權威 | 每份資料只有一個產品 owner，可投影成元件資料 | 不把 Klp view state 當產品資料庫 |
| S3 資料／互動接線 | 使用者操作後誰更新什麼？ | S1 結構、S2 模型、元件事件契約 | 資料投影、action／callback、重新提交宣告 | 事件回到產品 owner，畫面由新宣告更新 | 不直接控制 renderer、Flutter state 或第二份狀態 |
| S4 動畫／體驗優化 | 如何改善回饋、平台與可及性？ | 已可完成的 S1–S3 流程 | Kallopis 受控的 adaptive、feedback、focus、animation 能力 | 體驗改善不改變資料權威或破壞語意風格 | 不傳 color、padding、duration、curve、Widget 或平台 session |

每次只完成目前階段。若 S1 尚未形成合法畫面，不要先進入 S2；若能力清冊顯示 `partial`、`legacy` 或 `unsupported`，先走[能力缺口流程](external-components.md)，不要自行降回 Flutter 原生元件。

## 現在只做 S1：建立一個空資料工作區

前置條件：consumer 已依[應用與組裝模板](composition-templates.md)建立 `KlpApplication`、router 與唯一 application source。外觀由 Kallopis 宿主依平台環境決定。這一步只替換一個 route 的 `screen` 結果，不處理產品資料或事件。

```dart
import 'package:kallopis/kallopis_declarative.dart';

KlpScreen composeEmptyLibraryScreen() {
	final scope = KlpId.root('library');
	final treeId = scope / 'tree';
	final data = KlpExplorerData(
		trees: [
			KlpExplorerTreeData(
				id: treeId,
				items: [
					KlpExplorerCategoryModel(
						id: scope / 'empty-category',
						row: KlpExplorerRowData(title: '資料庫'),
						children: const [],
					),
				],
				expandedIds: const {},
			),
		],
		selectionScopes: [
			KlpExplorerSelectionScope(
				id: scope / 'selection',
				treeIds: [treeId],
				mode: KlpExplorerSelectionMode.none,
				selectedIds: const {},
			),
		],
	);

	return KlpScreen(
		id: scope / 'screen',
		accessibilityLabel: '資料庫',
		child: KlpAppLayout(
			id: scope / 'layout',
			child: KlpAppFrame(
				id: scope / 'frame',
				child: KlpFrameGroups(
					id: scope / 'groups',
					groups: [
						KlpFrameGroup(
							id: scope / 'group',
							content: [KlpExplorer(id: treeId, data: data)],
						),
					],
				),
			),
		),
	);
}
```

把 route 的 `screen` 指向 `composeEmptyLibraryScreen()`。此時應只看到由 Kallopis 控制的 layout、frame、group 與空 Explorer 分類；沒有產品記錄、選取 callback、導覽行為或自訂視覺值。

S1 完成檢查：

- 唯一 import 是 `package:kallopis/kallopis_declarative.dart`。
- `KlpScreen → KlpAppLayout → KlpAppFrame → KlpFrameGroups → KlpExplorer` 的合法結構可以建立。
- 空資料由明確的 category、tree 與 selection scope 表示，不用假資料掩飾尚未建立的產品模型。
- consumer 沒有提供 Widget、`BuildContext`、renderer、painter、color、padding、duration 或 curve。

完成這一步後先停止。確認區域與資訊架構符合產品需求，再進入 S2。

## S2 目錄：建立產品資料模型

進入條件：S1 的畫面區域與所需能力已確認。

1. 列出產品實體、識別、關係與生命週期。
2. 指定資料、選取、展開、草稿與保存狀態的唯一 owner。
3. 對照[完整能力清冊](productivity-capabilities.md)確認元件需要哪些輸入資料。
4. 需要 Explorer 時閱讀其[資料與狀態契約](explorer-model.md)，但產品模型不繼承 renderer 或 view class。

產出是產品模型與投影邊界，不是更多畫面程式碼。

## S3 目錄：接上資料與互動

進入條件：每份產品資料已有唯一 owner，且能投影成目前元件接受的不可變資料。

1. 將產品模型投影成 Klp 元件資料。
2. 將 `KlpAction` 或語意 callback 接回產品 owner。
3. 更新產品資料後，建立並提交新的 application 宣告。
4. 依使用能力閱讀詳細契約，例如 [Explorer](explorer-model.md)、[Menu](menu-model.md)與[應用更新](composition-templates.md)。
5. 以[驗證指南](verification.md)檢查公開入口與責任邊界。

產出是完整資料流與事件回路；Kallopis 不擁有產品 persistence 或商業決策。

## S4 目錄：動畫與體驗優化

進入條件：S1–S3 已能完成真實使用流程。

1. 檢查 loading、empty、error、permission 與操作回饋。
2. 檢查 keyboard、focus、semantics、IME、pointer 與 drag/drop。
3. 依[平台策略](adaptive-platform-strategies.md)選擇由 Kallopis 控制的窄寬及平台組合。
4. 從[能力清冊](productivity-capabilities.md)確認 animation、transition 或其他體驗能力是否已交付。
5. 尚未交付時提出產品無關需求，不在 consumer 傳入 animation controller、duration 或 curve。

產出是受控體驗能力的採用清單與人類驗收項目；視覺手感仍由人類接受。

## 看到原始 module 時怎麼判斷

| 原始 module | 與 consumer「前端」的關係 | 初學者需要做什麼 |
| --- | --- | --- |
| `application` | 組裝 application、screen 與 navigation session | 只使用公開的 app／screen／router 入口 |
| `capabilities` | 定義資料、狀態、action 與 navigation 契約 | 只在 S2、S3 使用已公開資料型別 |
| `composition` | 驗證節點樹、插槽與合法父子關係 | 依元件文件組裝，不自行實作 composition 類別 |
| `features` | 提供 Explorer、Menu、editing 等可見能力 | 依使用者意圖挑選；這是最常查的區域 |
| `foundation`、`kernel` | 提供識別、平台與底層共同契約 | 維護者查證用，不是 consumer 學習順序 |
| `rendering`、`runtime` | 將宣告準備、安裝並呈現為 Flutter | 完全由 Kallopis 擁有，consumer 不呼叫 |
| `styling` | 將 semantic style 解析成一致視覺 | consumer 不傳局部樣式；只採用公開受控能力 |

若只想知道「現在能不能做某件事」，直接查[完整能力清冊](productivity-capabilities.md)。若要追查舊 Catalog 某個名稱的去向，查[固定 254 項逐項轉接](catalog-capability-map.md)。只有維護 Kallopis 實作時，才從[架構圖集](../architecture/README.md)進入內部 module。
