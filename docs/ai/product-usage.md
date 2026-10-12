# Kallopis Flutter 產品使用指南

Kallopis 的 Flutter 庫是 Flutter design system，不是 application framework。產品擁有 app root、導航、畫面結構、狀態與業務流程；Kallopis 擁有 semantic theme、公開共用元件，以及元件內部的視覺、互動、無障礙與平台適應。

## 匯入共通風格檔

`kallopis_theme.dart` 公開 `KlpStylePack` 及 `klpStyleParameters`。風格檔內容由產品讀取；`parse` 接受 JSON 字串或 object，檢查所有 canonical ID、四模式、引用、350 項型別及 catalog 尺寸限制。非法值會拒絕整包，不改目前 Theme。

```dart
final pack = KlpStylePack.parse(styleFileContent);
final theme = buildKlpThemeVariant(
	KlpThemeVariant.light,
	stylePack: pack,
);
```

把 `theme` 提供給 MaterialApp 或局部 `Theme`，公開元件仍讀 `context.klp`。不同 Theme 子樹可用不同 pack；`KlpStylePack.defaults()` 還原預設，`applyOverrides` 對既有 primitive／semantic ID 原子覆寫並回新 pack；`data`／`resolve`／參數 metadata 深度不可變。

`stylePack` 與既有 `style` 不可同時提供，顯式 `accent` 仍可覆寫。pack 擁有透明模式完整色彩，不再套用舊 `transparencyEnabled` 色彩轉換；產品擁有視窗透明設定。字型保持套件前綴，不自動下载外部資產；原生 duration 必須能無損轉微秒，否則以 semantic ID 診斷。350 項 native 欄位已映射；配方展開、全部元件視覺對齊及更完整布局保護仍在後續階段，並未因風格 parser 完成而宣稱完成。

## 1. 建立產品根節點

產品直接使用 `MaterialApp`，並安裝 Kallopis theme 與語系 delegate：

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

void main() {
	runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
	const ProductApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: buildKlpTheme(Brightness.light),
			darkTheme: buildKlpTheme(Brightness.dark),
			localizationsDelegates: const [KlpLocalizationsDelegate()],
			home: const ProductWorkspace(),
		);
	}
}
```

## 2. 組合產品畫面

產品使用 Flutter 的 `Row`、`Column`、`Stack`、`Expanded` 與自己的 Widget 組合畫面；共用視覺與互動使用 `kallopis_foundation.dart` 公開元件：

```dart
class ProductWorkspace extends StatelessWidget {
	const ProductWorkspace({super.key});

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		return KlpSurface(
			tone: KlpSurfaceTone.app,
			child: Padding(
				padding: EdgeInsets.all(space.base),
				child: Row(
					children: [
						const SizedBox(width: 280, child: ProductSidebar()),
						SizedBox(width: space.base),
						const Expanded(
							child: KlpStageFrame(
								content: Center(child: KlpText('Product content')),
							),
						),
					],
				),
			),
		);
	}
}
```

產品專用寬度、順序與流程留在產品；顏色、字級、間距、圓角與動效從 `context.klp` 取得，不建立第二份共用 theme，也不引用 `package:kallopis/src/...`。

## 3. 投影狀態與回傳事件

### Panel 的可選微立體

`KlpPanelFrame(elevation: KlpPanelElevation.raised, content: content)` 啟用原微立體效果；預設 `KlpPanelElevation.flat`。右下陰影與左上亮邊由共用配方及目前 semantic theme 決定，深色沿用低對比亮邊，不改變布局或內容裁切。此選項只適用 `KlpPanelFrame`，其他 frame 不會自動改變。Catalog 提供 flat／raised 展示；`example/lib/panel_relief_main.dart` 提供淺深色並排比較。

產品 controller 是唯一資料權威。Widget 接收目前值，使用 callback 把使用者操作送回 controller：

```dart
KlpFileExplorer(
	sections: controller.sections,
	selectedId: controller.selectedId,
	expandedSectionIds: controller.expandedSectionIds,
	expandedItemIds: controller.expandedItemIds,
	onItemSelected: controller.selectItem,
	onSectionToggle: controller.toggleSection,
	onItemToggle: controller.toggleItem,
)
```

Kallopis 元件可以持有 hover、focus、pressed 等內部暫態，但不接管產品資料、導航或保存流程。

## 4. 使用高階實驗元件

尚未穩定、但已證明跨產品重用的直接 Flutter 元件可從 `kallopis_experimental.dart` 匯入。產品專用 editor host、WebView bridge、packaged asset 與 session 接線不屬於 Kallopis；它們留在產品自己的 capability module，並可在內部使用 Kallopis theme 與公開共用元件。

例如 Planist 的 BlockNote 與 Canva host 分別由 Flow／Canva presentation 擁有，Workspace 只取得既有 session 並組裝 editor。正文、selection、undo 與 persistence 仍由 Krepis／provider 掌管。

## 5. 元件缺口處理

Kallopis 沒有某個產品畫面時，產品直接建立 Flutter Widget，並沿用 Kallopis semantic theme。只有同一能力已證明跨產品重用，才提升為 Kallopis 公開元件。

禁止建立 declarative node、application host、adapter／bound model、私有 renderer、相容 shim、feature flag 或第二條產品接入路徑。
# Flutter 套件位置

Kallopis repository 根目錄維護共通規範；Flutter package 位於 `flutter/`。Consumer 的 path dependency 需由 `Kallopis` 改指向 `Kallopis/flutter`；package 名稱、公開 imports 與字型 package ownership 不變。以下指南仍適用於公開 Flutter API，Flutter 指令請從 `flutter/` 執行。

## 通用有限尺寸計算

從 foundation 使用 KlpLinearItem／resolveKlpLinearLayout，給有限主軸尺寸、scope 的 semantic gutter、間距數量及 minimum／maximum／preferred／flex，結果提供不可變 extents、實際 gutter、unused 與 compressed。庫不儲存產品內容或布局。

先扣間距；空間不足時按 minimum 比例退化，極大間距最多占滿主軸；有空間時按 flex 分配並遵守 maximum，無可增長項目時保留 unused。完整規則見 [共通尺寸契約](../architecture/workbench-linear-contract.md)。Flutter 一般 Row／Column 已使用此算法；Dock 與其他元件的完整風格保護仍依各自契約接入。

## 一般布局 bounds 與 divider

LayoutRow／LayoutColumn／LayoutSpacer／KlpLayoutPane／KlpAppFrame 接受 KlpLayoutBounds(minimum、maximum、preferred)，Column 可選 start／end alignment。正 flex 未指定 preferred 時保留 Expanded 語意；零 flex 量測自然尺寸。主軸無上限時依有限自然尺寸回退，內容需可量測出有限值。

KlpLayoutDivider 是沒有手勢的顯式 semantic gutter，前後不另加自動 gap；LayoutResizeHandle 仍保留既有 onResize 全域位置回呼。產品自行決定尺寸變更與保存。Root inset 每軸最多可用尺寸的一半；間距不足由 solver 限縮，內容每槽裁切，布局不改 caller 順序或內容身分。

## Dock 布局保存與載入

從 foundation 使用 KlpDockLayoutCodec.encode(layout) 取得版本化 JSON。產品擁有保存位置及何時採用布局，codec 不寫檔案、storage 或產品內容。載入成功的 layout／groups／panelIds 及診斷列表均不可變。

```dart
final saved = KlpDockLayoutCodec.encode(layout);
try {
	final restored = KlpDockLayoutCodec.restore(
		saved,
		panels: [
			for (final panel in panels)
				KlpDockPanelPolicy(
					id: panel.id,
					allowSide: panel.allowSide,
					allowBottom: panel.allowBottom,
				),
		],
	);
	// 產品自行顯示 missingPanelIds／availablePanelIds 後決定採用。
	setState(() => layout = restored.layout);
} on FormatException catch (error) {
	// 產品呈現 error；原本 layout 保持不變。
	showLoadError(error.message);
}
```

缺少面板按保存順序移除並回報；空群組刪除，選取項目消失則選剩下的第一個；未放置面板依清冊順序回報，庫不自動新增布局。版本、未知欄位、重複 id、非法 active／數值及停靠能力衝突會整份拒絕。完整 wire 與還原規則見 [Dock 保存契約](../architecture/workbench-dock-contract.md)。reset 由產品提供預設 layout。現有受控 KlpDockLayout API 保留；本 codec 不代表 Dock 其餘 UI 補齊已完成。

## Dock 受控操作

foundation 公開 applyKlpDockAction，接收 layout／panels／action，回傳 KlpDockActionResult 的不可變 layout／changed。KlpDockAction 的 select、move、open、merge、close、visibility、resizeArea、resizeGroup 與 React 使用同一[操作契約](../architecture/workbench-dock-contract.md#受控操作-wb-dock-ops-r1)。KlpDockDestination.tab 重排或移入既有群組；.group 建立新群組，可用於分割或重新開啟。

```dart
final result = applyKlpDockAction(
	layout: layout,
	panels: policies,
	action: const KlpDockAction.move(
		panelId: 'inspector',
		destination: KlpDockDestination.group(
			area: KlpDockArea.right,
			groupId: 'inspector-group',
			index: 0,
			extent: 240,
		),
	),
);
if (result.changed) setState(() => layout = result.layout);
```

index 是移除來源後的最終位置，不 clamp；new groupId 不可與操作前任何群組重複。來源空群組刪除，active 移走取剩餘第一個；目標區域展開，select 只更新 active。close 的 approved 必由產品關閉 callback 決定；false 保留全部資料，true 只移除布局，不刪 registry，面板仍可 open。dirty／pinned 不寫入布局資料。

resize 只更新有限偏好尺寸，由 UI 依 constraints／viewport 解算後提交；hover／取消拖曳不提交操作。非法目前布局、缺清冊、能力衝突、identity／index／extent 都以 FormatException 整份拒絕，原 caller 不改。既有 KlpDockLayout API 保持，Widget 已接入pure操作及有限配額；完整風格配方參數化仍在接續 Workbench stage。

### Panel 有限尺寸

KlpPanelFrame 仍由產品提供有限高度；header/footer 高度讀 semantic theme，正常空間保留原尺寸，不足時依通用 linear 演算法比例縮配，正文可為零且保持原 State。外距与內距限制至可用空間；PanelFooter 保留 custom/directional padding。產品內容負責自己的內部排版。這不代表 Dock 的保存偏好尺寸、drag/resize 已全部接入有限幾何。

### Dock 有限尺寸

KlpDockLayout 的父容器需提供有限寬高；保存 extent 是偏好，實際side與Bottom尺寸受area constraints及viewport控制。空間不足按通用演算法縮配minima，不回寫保存資料；群組與把手用同一有效gutter。contentHeader保留跨中央/右區而左區全高，Bottom只在Stage下方。resize callback提交值也扣除其餘區與把手；無法容納logical minimum時不提交尺寸，仍可collapse。內容State在合法theme與viewport更新保持。zero/巨大style不代表產品內容自身排版或操作感官已接受。

現有example使用動態IconData，release web需 `flutter build web --release --no-tree-shake-icons` 保留完整套件圖示字型；默认tree-shake-icons會因非const圖示失败，不能靜默換圖示或字型資產。

Dock 拖曳滑過隱藏非空區時只暫時展開，不發 `onLayoutChanged`；取消／未命中放下會收回。成功放入該區才一次通知且保留原保存寬高。拖曳中提供不同 layout instance 會清預覽，以新產品布局為準；同 layout 的主題／尺寸重建保留預覽。

### 停靠面板狀態與關閉批准

`KlpDockPanel` 可選 `isPinned`、`isDirty`（皆預設 false）、`onCloseRequested` 與 `closeLabel`。釘選與修改提示由產品投影，只影響呈現；不改分頁排序、停靠能力、保存 JSON 或正文資料。未提供批准 callback 就維持既有外觀，不顯示關閉入口。

```dart
KlpDockPanel(
	id: 'inspector',
	header: const KlpText('Inspector'),
	content: inspectorContent,
	isDirty: documentHasChanges,
	isPinned: inspectorPinned,
	onCloseRequested: () async {
		return await productApproveClose();
	},
)
```

callback 可直接回傳 bool 或 Future<bool>；false 不提交，true 才移出布局並一次發出 `onLayoutChanged`。庫不移除 registry、不刪資料；產品可用 `KlpDockAction.open` 再開啟。等待時只禁用該面板關閉入口；完成從最新布局關閉，若面板曾被移除／重開、callback 替換或 Dock dispose，舊結果忽略。錯誤透過標準 FlutterError 通道，保存資料保持且 pending 解除。消費端保持穩定 callback instance，避免每次 rebuild 產生新的閉包而使等待中的批准過期。

分頁、拖放、分割與尺寸操作由已公開 pure actions 統一規則；no-op 不通知。成功批次只一次通知，產品採用回傳的 immutable layout。tab 前後半部分別插入前後；新 split 的把手配額也計入總尺寸。Flutter原生resize沿既有continuous pan逐次通知，每次area/group批次仍只有一個結果；不能把它描述為整個gesture只提交一次。

### 公開 Dock 互動範例

[Catalog Docking 頁](../../flutter/example/lib/catalog/docking_layout_page.dart)使用穩定foundation入口，示範保存／還原schema1 JSON、能力清冊投影、產品批准／拒絕／延遲關閉、pinned／dirty、重開與同區合併。Stage輸入與JSON controller由產品持有並釋放；320／760／1040寬及180／480高只控制宿主，實際寬度不超出Catalog可用空間。無效JSON保留目前布局；清空Bottom是展示產品明確的布局移除動作，正文registry仍保留。

KlpDockHeader另有120／220寬度控制，有限宿主用Align提供loose限制，避免Column的stretch覆蓋指定寬度。更多選單中的動作顯示產品回饋。Catalog的Material透明祖先提供正常DefaultTextStyle，不建立第二份theme。

新版releaseweb已在瀏覽器確認選取、收合、保存還原／錯誤保留、拒絕／批准／延遲完成、重開／合併、跨區拖放／分割及area resize；窄header更多選單可執行設定。Hover preview/cancel完整browser矩陣、三種雙框架GUI與全部元件網頁展示仍待接續，感官品質由人類接受。

### Flutter 命令核心

`KlpCommandRegistry<C>`、definition/state/result/status/error phase從stable foundation使用。產品持有registry與最新context；註冊時複製metadata及keywords，不複製產品值、icon或context。字串須有非空白內容，但不改原值。所有呈現入口使用同一registry查詢，業務執行以ID呼叫。

```dart
final commands = KlpCommandRegistry<ProductContext>();
final definition = KlpCommandDefinition<ProductContext>(
	id: 'document.save',
	label: '儲存',
	isEnabled: (context) => context.canSave,
	handler: (context) => productSave(),
);
final unregister = commands.register(definition);
final result = await commands.execute('document.save', latestContext);
if (result.status == KlpCommandExecutionStatus.error) showProductError(result.error);
// 產品卸載時解除註冊，並銷毀自己擁有的 registry。
unregister();
commands.dispose();
```

`getState`／`list`提供visible/enabled/checked/running及conditionError；執行需visible與enabled為true、running為false。registry重新檢查條件，同命令pending回busy，不同命令可並行。解除或同ID重新註冊不取消已啟動的產品Future；舊結果不清新owner狀態。

`subscribe`回自己的disposer，也可沿原生Listenable的addListener/removeListener；即使callback相同，原生removeListener不解除subscribe。外部closure條件改變用refresh通知，version反映每次註冊/解除/開始/完成/refresh/dispose。通知中dispose合法，立即關閉並最後一次通知；disposed查詢仍合法，mutation拋StateError。observer錯誤沿FlutterError，handler及condition原錯誤只由typed結果交產品。

24項公共命令檢查及局部靜態分析通過，包含原生通知中銷毀與混合訂閱順序。完整規則見[共同命令契約](../architecture/workbench-command-contract.md)；選單、命令面板與快捷鍵仍待統一接入。

## Registered 命令工具列與選單

`KlpRegisteredCommandToolbar<C>`／`KlpRegisteredCommandMenu<C>`從stablefoundation使用。產品提供同registry、最新getContext、ID/order/kind及onResult；label、description、icon、enabled、checked、running都從registry投影，不複製第二份handler/state。

```dart
KlpRegisteredCommandToolbar<ProductContext>(
	registry: commands,
	getContext: () => currentContext,
	items: const [
		KlpCommandReference(commandId: 'document.save'),
		KlpCommandReference(commandId: 'view.grid', kind: KlpCommandKind.toggle),
	],
	label: '文件工具',
	onResult: handleProductResult,
)
KlpRegisteredCommandMenu<ProductContext>(
	registry: commands,
	getContext: () => currentContext,
	items: const [KlpCommandReference(commandId: 'document.save')],
	label: '文件命令',
	emptyLabel: '沒有可用命令',
	onResult: handleProductResult,
	onDismiss: closeProductPopup,
)
```

外部closure變動呼叫commands.refresh()。缺失/隱藏/條件錯誤項不呈現；停用/執行中項保持呈現但不進可用索引。toolbar左右、menu上下循環，Home/End跳首尾，Enter/Space只KeyDown啟動一次，repeat不啟動；menu Escape呼叫onDismiss。autoFocus預設false，true才在掛載後取得首可用項或空root焦點。

UI不取消已開始產品Future；samehost/sameregistry完成交最新onResult，卸載或更換registry後隔離舊結果，解除命令註冊仍保留原結果。onResult自身錯誤交FlutterError，不能偽裝成handler結果。風格讀context.klp，menu scroll/toolbar wrap保護有限宿主；popup使用下方公開入口，shortcut待接續。

23項公開Widget/lifecycle checks、public analyze及兩path scope通過；browser和感官品質尚待展示stage。[雙框架入口契約](../architecture/workbench-command-entry-contract.md)為共同邊界。

## Registered 命令面板

`KlpRegisteredCommandPalette<C>`從stable foundation使用，產品控制open；全部候選、條件與執行仍讀同registry。三個label由產品本地化且不得空白。mount於現有Overlay／semantic theme宿主下，浮層會隨caller重建刷新同主題、方向與locale。

```dart
KlpRegisteredCommandPalette<ProductContext>(
	registry: commands,
	getContext: () => currentContext,
	open: commandPaletteOpen,
	label: '全部命令',
	searchLabel: '搜尋命令',
	emptyLabel: '沒有符合的命令',
	onResult: handleProductResult,
	onDismiss: (reason) => setState(() => commandPaletteOpen = false),
)
```

搜尋支援多詞與跨metadata field、完整／前綴／包含／子序列固定score，最後依UTF-16 ID排序。停用或執行中候選仍呈現但不可選。上下循環、Enter一次執行、Tab保留輸入、Escape／outside只提出關閉意圖；Home／End／左右及composition保留原生文字編輯。成功結果提出executed關閉，錯誤保留面板由產品呈現；關閉／重開／替換registry隔離舊Future UI結果。

原焦點只在面板仍擁有焦點時還原，產品callback已轉移外部焦點不搶回。query不進registry，關閉後再開重設；同次open的主題／尺寸／registry更新保留query。有限overlay／row幾何限制可替換風格的padding／icon／gap，不改命令權限與排序。21項公開檢查及局部analyze通過；[共同面板契約](../architecture/workbench-command-palette-contract.md)與[Flutter實作責任](../../flutter/lib/src/features/actions/command_palette/architecture.md)提供完整邊界。公開[Catalog Commands頁](../../flutter/example/lib/catalog/registered_commands_page.dart)可實際操作同registry工具列／選單／palette：產品草稿、儲存條件、800ms pending、grid與顯式failure；source只用stablefoundation。nativebrowser已確認搜尋／pending／error／Tab／Escape／executed／outside／原生Dismiss與實際320×180有限尺寸，草稿保留。感官與完整style／IME／theme browser矩陣仍待接受。

## Registered 錨定與右鍵命令選單

stable foundation 的 `KlpRegisteredCommandPopup<C>`沿用同registry／getContext／items／label／emptyLabel／onResult，另必填受控open、原生Rect anchor及onDismiss。anchor為同視窗邏輯viewport座標；按鈕以原生RenderBox bounds，context pointer用globalPosition與Size.zero。有限位置依當前context.klp決定偏好下方、翻上方或較大側，保留同公開menu的scroll及鍵盤行為。

```dart
KlpRegisteredCommandPopup<ProductContext>(
	registry: commands,
	getContext: () => currentContext,
	items: const [KlpCommandReference(commandId: 'document.save')],
	open: popupOpen,
	anchor: popupAnchor,
	label: '文件命令',
	emptyLabel: '没有可用命令',
	onResult: handleProductResult,
	onDismiss: (reason) => setState(() => popupOpen = false),
)
```

onDismiss僅交escape／outside／executed意圖，由產品採用；同session各意圖最多一次，handler error保持，callback原錯誤不自動關閉。modal背景pointer／可操作語意暫停、產品State/controller不卸載，條件回焦。16項protected公開Widget checks、原23入口checks、analyze與scope2通過；Catalog Commands頁button／右鍵point／Escape／outside無click-through／儲存及格線一次／原focus／草稿保留已nativebrowser觀察。右鍵原生瀏覽器選單開關只由example宿主管理，library不接管全產品事件。完整style／窄native矩陣與感官另pending，詳見[共同popup契約](../architecture/workbench-command-popup-contract.md)。
