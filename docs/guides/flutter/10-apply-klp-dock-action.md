# Dock 受控操作

foundation 公開 applyKlpDockAction，接收 layout／panels／action，回傳 KlpDockActionResult 的不可變 layout／changed。KlpDockAction 的 select、move、open、merge、close、visibility、resizeArea、resizeGroup 與 React 使用同一[操作契約](../../architecture/workbench-dock-contract.md#受控操作-wb-dock-ops-r1)。KlpDockDestination.tab 重排或移入既有群組；.group 建立新群組，可用於分割或重新開啟。

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

[Catalog Docking 頁](../../../flutter/example/lib/catalog/docking_layout_page.dart)使用穩定foundation入口，示範保存／還原schema1 JSON、能力清冊投影、產品批准／拒絕／延遲關閉、pinned／dirty、重開與同區合併。Stage輸入與JSON controller由產品持有並釋放；320／760／1040寬及180／480高只控制宿主，實際寬度不超出Catalog可用空間。無效JSON保留目前布局；清空Bottom是展示產品明確的布局移除動作，正文registry仍保留。

KlpDockHeader另有120／220寬度控制，有限宿主用Align提供loose限制，避免Column的stretch覆蓋指定寬度。更多選單中的動作顯示產品回饋。Catalog的Material透明祖先提供正常DefaultTextStyle，不建立第二份theme。

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

## API 查表

- [KlpCommandDefinition](../../reference/flutter/types/klp-command-definition.md)
- [KlpCommandExecutionStatus](../../reference/flutter/types/klp-command-execution-status.md)
- [KlpCommandRegistry](../../reference/flutter/controllers/klp-command-registry.md)
- [KlpDockAction](../../reference/flutter/types/klp-dock-action.md)
- [KlpDockActionResult](../../reference/flutter/types/klp-dock-action-result.md)
- [KlpDockArea](../../reference/flutter/types/klp-dock-area.md)
- [KlpDockDestination](../../reference/flutter/types/klp-dock-destination.md)
- [KlpDockLayout](../../reference/flutter/components/workspace/klp-dock-layout.md)
- [KlpDockPanel](../../reference/flutter/types/klp-dock-panel.md)
- [KlpPanelFrame](../../reference/flutter/components/layout/klp-panel-frame.md)
- [applyKlpDockAction](../../reference/flutter/utilities/apply-klp-dock-action.md)
- [KlpText](../../reference/flutter/components/content/klp-text.md)
