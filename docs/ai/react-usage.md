# Kallopis React

通用尺寸算法從套件公開入口使用 `resolveKlpLinearLayout({extent,gutter,gutterCount,items})`。Item 的 minimum／maximum／preferred／flex 決定有限主軸上的尺寸分配，結果是 frozen 的 extents／gutter／unused／compressed；gutter 由目前 scope 的語意取得，產品提供可用尺寸與內容限制。

先扣間距、再保 minimum 與 preferred、最後按 flex 分配；空間不足時比例退化，maximum 限制後保留留白。兩框架共用 [尺寸契約](../architecture/workbench-linear-contract.md)。此公開 utility 已可使用，Row／Column／Pane 的 DOM 接入仍待下一 slice，不能視為完整布局 UI 已交付。

`@kallopis/react` v0.1 提供通用視覺語意與可使用的 React 19 核心元件。正式來源為 [通用規範](../design-tokens/KALLOPIS-DESIGN-MAP.md)；React 只維護平台接入及公開 API。

## 本機執行

在 `react/` 執行：

```sh
npm ci
npm run build
npm test
npm run check:tokens
npm run dev
```

展示預設為 `http://127.0.0.1:5173`。`npm run build:example` 產生展示靜態頁；`npm pack` 建立可供其他產品本機安裝的套件，尚未發布 npm。開發庫後需重新 `npm run build`，展示只使用 dist 公開入口。

## 第一個組合

安裝本庫產生的套件檔後，接入樣式與 Provider：

```tsx
import { KlpThemeProvider, KlpFrame, KlpButton } from '@kallopis/react';
import '@kallopis/react/styles.css';

export function ProductPanel() {
	return <KlpThemeProvider mode="light">
		<KlpFrame header="內容">
			<KlpButton tone="primary" onClick={() => {}}>主要動作</KlpButton>
		</KlpFrame>
	</KlpThemeProvider>;
}
```

產品自行提供事件處理、路由與資料；共用元件內部樣式由本庫負責。產品專用元件可用 `useKlp().semantic('theme.colors.surface')` 取得語意，不複製共同預設值。`getKlpRecipe(id)` 取得原始配方及繼承關係，供查表；它不建立任意 DOM 的 renderer。

## 語意與 API 對應

| 通用配方 | React API | 合法用途與限制 |
| --- | --- | --- |
| text-body／caption／label／lead／h1～h4／code | `KlpText role`，`tone` | `as` 選擇原生文字標籤；角色決定字級、字型及字重 |
| surface／card | `KlpSurface tone`、`KlpCard header/footer` | header → content → footer 的次序由元件維護；產品決定內容 |
| badge-base／neutral／status | `KlpBadge tone` | neutral／success／warning／danger／info；標記不當作操作按鈕 |
| button-base／primary／secondary／ghost／size-* | `KlpButton tone/size/selected` | 使用原生 button；disabled 不發送點擊，產品持有選取狀態 |
| icon-button／inline／window | `KlpIconButton label/tone` | label 必填；內容由產品提供圖示，視窗行為由宿主提供 |
| field-base／error／disabled | `KlpTextField label/error` | label 必填；`value/onChange` 為產品控制的原生 input 契約 |
| frame／sidebar／auxiliary | `KlpFrame role/header/footer` | 固定 header → body → footer；角色限定表面，產品決定版面 |
| workspace-layout | `KlpWorkspace` | 提供共同 frame 間距；以公開 Frame 或原生 React 布局組合 |
| 一般布局 | `KlpAppLayout`、`KlpLayoutRow`、`KlpLayoutColumn`、`KlpLayoutPane`、`KlpLayoutSpacer`、`KlpLayoutDivider` | 有限尺寸、bounds、scoped gutter 與內容裁切；與 Dock 分離 |
| explorer-folder-row／row／hover／selected | `KlpFileExplorer` | 唯一且非空的 section/item ID；平坦投影，產品持有 expandedIds／selectedId 與 callbacks；hover／selected 同色 |

核心元件皆需 Provider。主題為 `light`、`dark`、`ultraDark`、`transparent`，缺失 Provider 或未知主題／語意／配方明確失敗。巢狀 Provider 具有獨立 scope。透明模式依宿主背景呈現，瀏覽器不提供原生視窗透明能力。

## 維護

350 個語意 × 4 主題、269 個 primitive、118 個配方由正式 Markdown 產生。修改正式規範後執行 `npm run build`，`npm run check:tokens` 檢查來源與產物內容及 SHA256。禁止人工修改 `src/generated.ts`、`src/tokens.css`、`src/source-manifest.json`。

色碼由規範 `#AARRGGBB` 轉為 Web `#RRGGBBAA`；數值單位在 CSS 接入，primitive 原始值保留。字型 family 移除 Flutter package 前綴；字型與授權打包於本庫 `dist/fonts`，產品需允許這些資產載入。

118 項配方完整可查詢；Menu、Dialog 等尚未列為此版公開 React 元件。新增組合依正式語意及跨產品使用需求另行規劃。

## 可替換風格

以 `createKlpStylePack(jsonOrObject)` 匯入完整 style pack，省略參數採用 Kallopis 預設。schema／canonical ID／四模式參數都驗證成功才接受；回傳深度不可變且與來源隔離的 pack。`klpStyleParameters` 提供 350 項語意的型別、單位、限制、用途及直接引用配方。

```tsx
import { createKlpStylePack, applyKlpStyleOverrides, KlpThemeProvider } from '@kallopis/react';

const initial = createKlpStylePack();
const roomier = applyKlpStyleOverrides(initial, {
	semantics: {
		'theme.spacing.contentInlineGap': { light: 'p(space300)' },
	},
});

export function StyledProduct() {
	return <KlpThemeProvider mode="light" stylePack={roomier}>產品內容</KlpThemeProvider>;
}
```

`applyKlpStyleOverrides` 只覆寫已有 primitive 或 partial mode semantic；成功回傳新 pack，失敗不修改原值。Provider 對全部 CSS variables 與 hook 同步採用 scoped 風格；巢狀 Provider 可獨立切換。example 提供檔案／完整 JSON 貼上匯入、錯誤保留及預設還原。

產物另包含 common runtime／default pack／catalog 的來源雜湊，`check:tokens` 檢查新鮮度。生成的 `src/style-pack-data.ts`、`src/style-runtime/`、manifest 不手改；打包後不依賴 checkout 的 styles/。目前接入 typed semantic；recipe 原文仍供查詢，不能宣稱所有 recipe 參數已影響元件或任意風格下布局已驗收。

## 一般布局與尺寸限制

Row／Column／Pane 接受 `flex`（預設 1）及 `bounds: {minimum?, maximum?, preferred?}`；Spacer 的 flex 必須大於零。合法直接 child 為這些布局元件及 Divider，可用 Fragment／null 做條件組合；Pane 內可放任意產品 React 內容。Root 接受單一 Row／Column／Pane。

```tsx
import { KlpThemeProvider, KlpAppLayout, KlpLayoutRow, KlpLayoutPane, KlpLayoutDivider } from '@kallopis/react';

export function ProductLayout() {
	return <KlpThemeProvider>
		<div style={{ width: '100%', height: 280 }}>
			<KlpAppLayout>
				<KlpLayoutRow>
					<KlpLayoutPane flex={0} bounds={{ minimum: 80, preferred: 120, maximum: 160 }}>側欄內容</KlpLayoutPane>
					<KlpLayoutDivider />
					<KlpLayoutPane bounds={{ minimum: 80 }}>產品內容</KlpLayoutPane>
				</KlpLayoutRow>
			</KlpAppLayout>
		</div>
	</KlpThemeProvider>;
}
```

`spacing="none"` 取消普通相鄰 gap，顯式 Divider 仍有語意尺寸；`alignment="end"` 把 maximum 產生的留白放在開頭。Root `inset="none"` 可取消外距。所有間距讀取 scope 的 `theme.spacing.space2`，不足空間與極大值會依 [共通契約](../architecture/workbench-linear-contract.md) 壓縮，內容每槽裁切。

預設 `sizing="fill"` 使用 enclosing CSS 容器尺寸，產品需提供希望填滿軸的明確尺寸。`sizing="content"` 使用有限自然／preferred 主軸總和，flex 不延伸填滿；Web 沒有 Flutter 的 Infinity constraint 訊號。不要藉內部 grid／gap 樣式繞過尺寸算法，使用 bounds 或產品外部容器調整。

元素 ResizeObserver、scope 更新與內容變更會重新量測；沒有 ResizeObserver 時保留首次量測與 resize fallback。SSR 先呈現可及 DOM，client 掛載後才完成量測。example 提供窄容器、end alignment、極大語意 gap、還原與原生輸入保留展示。

## Dock 布局資料保存

公開 encodeKlpDockLayout／restoreKlpDockLayout 使用與 Flutter 相同的 [schemaVersion1 JSON](../architecture/workbench-dock-contract.md)。KlpDockLayoutData 是 readonly left／right／bottom；每個 area 有 axis、isVisible、extent、groups，每個 group 有 id、panelIds、activePanelId、mainAxisExtent。Stage／產品內容、風格與業務狀態不包含在保存資料。

```ts
import { encodeKlpDockLayout, restoreKlpDockLayout, type KlpDockPanelPolicy } from '@kallopis/react';

const saved = encodeKlpDockLayout(layout);
const policies: readonly KlpDockPanelPolicy[] = panels.map(panel => ({
	id: panel.id,
	allowSide: panel.allowSide,
	allowBottom: panel.allowBottom,
}));
try {
	const result = restoreKlpDockLayout(saved, policies);
	// 產品自行呈現 missingPanelIds／availablePanelIds 並決定採用。
	setLayout(result.layout);
} catch (error) {
	if (error instanceof TypeError) setLoadError(error.message);
	else throw error;
}
```

載入先完整驗證，再對 registry；缺少面板按保存順序移除並回報、空 group 刪除，active 消失則取第一個。availablePanelIds 按 registry 順序列出新增及原本未放置面板，庫不自動填入布局。未提供 allowSide／allowBottom 表示允許；未知欄位、重複 identity、非法 active／數值及已存在面板 capability 衝突都以 TypeError 整份拒絕，原資料與 caller 清冊不改。

結果所有物件及列表深層 frozen；encode 驗證並複製 caller，不凍結或修改原資料。庫不執行 storage；產品決定保存位置及以預設 layout reset。這組純資料 API 完成保存邊界，React Dock 呈現、分頁及拖放元件仍由 Workbench stage 接續。

## Dock 受控操作

公開 applyKlpDockAction(layout, policies, action) 回傳不可變 layout／changed。KlpDockAction 提供 select、move、open、merge、close、visibility、resizeArea、resizeGroup；move 使用 tab destination 重排／移入既有群組，使用 group destination 分割成新群組。open 使用相同 destination，但要求面板尚未放置。index 是移除來源之後的最終插入位置，非法值不 clamp。

```ts
import { applyKlpDockAction, type KlpDockAction } from '@kallopis/react';

const action: KlpDockAction = {
	type: 'move',
	panelId: 'inspector',
	destination: { kind: 'group', area: 'right', groupId: 'inspector-group', index: 0, extent: 240 },
};
const result = applyKlpDockAction(layout, policies, action);
if (result.changed) setLayout(result.layout);
```

新 groupId 必須不與操作前的任何群組重複。移動／合併保留分頁順序並驗證 area 能力；來源空群組刪除，原 active 移走則取第一個剩餘項目。目標 area 展開，但 select 只改 active。close 的 approved boolean 必由產品關閉 callback 決定；false 是不改資料的合法 no-op，true 只移除布局，不刪 registry，仍可 open。dirty／pinned metadata 不放入保存資料。

visibility 保存收合／展開；resizeArea／resizeGroup 只更新有限偏好尺寸，實際 viewport 與 handle 配額由 Dock UI 解算後提交。取消拖曳不提交操作，hover 不改布局。非法目前布局、缺清冊、停靠能力或 action 以 TypeError 整份拒絕，原 state 不改；詳見 [操作契約](../architecture/workbench-dock-contract.md#受控操作-wb-dock-ops-r1)。純資料入口不代表 Dock UI 已完成。

## Dock 有限尺寸

`resolveKlpDockGeometry` 接受目前容器的有限 `width`／`height`、保存 `layout`、左右 `minExtent`／可選 `maxExtent`、可選 Bottom 限制，以及語意投影的 `handleExtent`／可選 `headerExtent`。回傳不可變的 Stage、各區、header、handle 矩形與 `maximumLeft`／`maximumRight`／`maximumBottom`；呈現及 pointer 使用相同座標。

空間不足會同比例壓縮 minimum；保存偏好保持原值。正 Infinity maximum 表示無邏輯上限，其他尺寸須有限非負；縮放提交需再把實際 maximum 與產品邏輯 min/max 求交集，不足 minimum 時不回寫縮放。省略 header 與零高 header 槽不同；省略 Bottom 限制只允許 Bottom 隱藏且無群組。非法輸入以 TypeError 拒絕，caller 不修改。這是純尺寸入口，React 可拖放 Dock 元件仍在接續實作。

## React Dock 元件

`KlpDockLayout` 由公開套件入口提供，必須位於 `KlpThemeProvider` 內。產品持有唯一 `layout`，在 `onLayoutChanged` 中決定採用新值；元件不自行保存副本。`panels` 是完整清冊，每項提供 `id`、非空 `label`、React `content`，可選 `icon`、能力限制、`isPinned`／`isDirty`、`onCloseRequested` 與 `closeLabel`。Stage／頂列是產品內容，原生宿主 `style` 供外部寬高，有限配額及內部style由本庫負責。

```tsx
import { KlpDockLayout } from '@kallopis/react';

<KlpDockLayout
	layout={layout}
	panels={panels}
	stage={productStage}
	leftConstraints={{ minExtent: 80 }}
	rightConstraints={{ minExtent: 80 }}
	bottomConstraints={{ minExtent: 32 }}
	onLayoutChanged={setLayout}
	onCloseError={(error, panelId) => showCloseError(error, panelId)}
	areaLabels={{ left: '工具', right: '屬性', bottom: '輸出' }}
	style={{ width: '100%', height: 400 }}
/>
```

分頁 click、左右方向键、Home／End 會循環選取並聚焦；目前 active 的重複選取不通知。邊緣入口切換收合，非active／收合正文保留DOM，因此同位置的原生輸入不因尺寸、風格或重新呈現而丟值。`ref` 指向布局宿主；SSR先輸出零尺寸槽，client量測後配置。

`onCloseRequested` 回傳同步 boolean 或 Promise<boolean>；false保留布局，true才從最新布局移出，不刪清冊或產品正文。pending只停用該close；面板曾移除再開、批准callback替換或元件卸載後，舊批准無效。callback需保持identity；錯誤或非boolean回傳交`onCloseError`，未提供則宿主reportError／console.error。產品以`closeLabel`本地化關閉名稱；metadata不改關閉權限或保存格式。

拖曳分頁可在其他分頁前半／後半插入，標頭空白合併進群組；放在正文可分割，空間不足兩個邏輯minimum時拒絕。空停靠區可在Stage邊界帶建立；Stage中央與禁止能力的位置不接drop。隱藏非空區在外邊緣hover暫時展開，取消/未命中不保存，成功才提交且保留原extent。不同layout instance取消正在進行的操作；同layout的風格/尺寸重建保持preview。

拖動區域及群組把手會先呈現縮放提示，放開才一次通知；pointer cancel/Escape/卸載不提交。相鄰群組尺寸守恆，不足minimum不寫入退化render尺寸。`collapseThresholds`可選各區有限非負門檻（缺省0），低於門檻只收合，保留偏好extent；拖後同一次pointer click不再toggle，keyboard click保持可用。

分頁拖放採瀏覽器[原生HTML drag事件](https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API)，縮放採[Pointer Events](https://developer.mozilla.org/en-US/docs/Web/API/Pointer_events)及capture/cancel生命周期；分頁的觸控拖放能力依宿主瀏覽器，沒有新增touch polyfill或跨instance/跨視窗移動。CSS transform不改保存及pointer的布局座標。

18項公開input與DOM/SSR checks通過。[公開Dock互動範例](../../react/example/dock-demo.tsx)已接入React展示頁，可操作保存、還原、重設、重開、合併與批准方式。保存及pureoperations的清冊只包含id/allowSide/allowBottom，不能直接傳入有content/callback的完整panel物件；範例示範明確投影。

nativebrowser已確認選取、收合、區域及群組resize、close拒絕/批准/延遲、JSON錯誤保留、分頁重排/跨區域合併/正文分割，以及尺寸/主題更新輸入保留。hover preview的browser證據仍待確認；synthetic checks不代替browser或感官接受。全部元件互動頁面及三種雙框架GUI仍待网站展示stage整合。

## React 命令核心

`KlpCommandRegistry<C>` 從公開套件匯入；產品擁有registry生命週期及context，每次query/execute傳最新context。`register`回傳只解除該註冊者的函式；ID重用不受舊disposer影響。metadata字串須含非空白內容，原值保留；沒有全域registry或預設業務命令。

```ts
import { KlpCommandRegistry, type KlpCommandDefinition } from '@kallopis/react';

type Context = { canSave: boolean };
const commands = new KlpCommandRegistry<Context>();
const definition: KlpCommandDefinition<Context> = {
	id: 'document.save',
	label: '儲存',
	isEnabled: (context) => context.canSave,
	handler: () => productSave(),
};
const unregister = commands.register(definition);
const result = await commands.execute('document.save', latestContext);
if (result.status === 'error') showProductError(result.error);
// 產品卸載時解除註冊，並銷毀自己擁有的 registry。
unregister();
commands.dispose();
```

`getState`及`list`提供visible/enabled/checked/running與conditionError；呈現入口檢查visible與enabled為true、running為false，執行仍經registry重新驗證。相同註冊者pending時回busy，不同命令可並行；產品Promise開始後不會被解除註冊取消，舊結果不能清新owner的running。`subscribe`／`version`供宿主更新；外部closure變動用`refresh()`通知，不儲存第二份context。

11項公共生命週期檢查、使用端型別及建置通過；完整條件與結果見[共同契約](../architecture/workbench-command-contract.md)。

## React 命令工具列與選單

`KlpRegisteredCommandToolbar<C>`與`KlpRegisteredCommandMenu<C>`直接讀同一個registry；產品提供items的commandId/kind與排列，不複製label、handler或enabled。條件closure變動呼叫registry.refresh()；每次查詢及啟動都讀getContext最新資料。

```tsx
<KlpRegisteredCommandToolbar
	registry={commands}
	getContext={() => latestContext}
	items={[{ commandId: 'document.save' }, { commandId: 'view.grid', kind: 'toggle' }]}
	label="文件工具"
	onResult={handleProductResult}
/>
<KlpRegisteredCommandMenu
	registry={commands}
	getContext={() => latestContext}
	items={[{ commandId: 'document.save' }]}
	label="文件命令"
	emptyLabel="沒有可用命令"
	onResult={handleProductResult}
	onDismiss={closeProductPopup}
/>
```

toolbar左右、menu上下循環移動可用項；Home/End跳首尾、Enter/Space啟動一次。Menu Escape呼叫onDismiss；autoFocus預設false，明確true才取得首個可用項或空menu宿主焦點。缺失/隱藏/條件錯誤項不呈現；停用/執行中項仍呈現但不進可用索引。toggle映射checked，普通action沒有toggle語意。

非同步執行完成交最新onResult；入口卸載或更換registry後不再把舊結果交新宿主，同registry的原結果仍保留。onResult自身例外交原生error通道。style/className/id供外部有限宿主，內部呈現讀semantic；menu本身是原生平面入口，錨定／context選單使用下方registered popup。

12項public SSR/DOM/lifecycle/typedconsumer checks與build通過，測試存在React act時機警告；browser與感官證據待展示stage。[入口共同契約](../architecture/workbench-command-entry-contract.md)定義雙框架一致邊界。

## React 命令面板

`KlpRegisteredCommandPalette<C>`查詢同registry全部可見命令；產品持有open與getContext，onDismiss更新open。搜尋包含label/id/description/category/各keyword，支援空白分詞、子字串與依序字元；disabled/running保留顯示但不能啟動。

```tsx
<KlpRegisteredCommandPalette
	registry={commands}
	getContext={() => latestContext}
	open={paletteOpen}
	label="命令面板"
	searchLabel="搜尋命令"
	emptyLabel="沒有符合的命令"
	onResult={handleProductResult}
	onDismiss={reason => setPaletteOpen(false)}
/>
```

上下選取、Enter執行、Escape與背景點擊提出關閉；成功執行後也提出關閉，錯誤保留面板供產品處理。搜尋input保留原生文字游標／composition；SSR待client mount才開啟modal。原生dialog由同Provider tokens及CSS投影取得風格，開關不改背景產品輸入。原生範例包含儲存pending、格線checked、可見及可用條件與失敗結果；[CommandsDemo](../../react/example/commands-demo.tsx)全部使用公開library入口。

11項protected UI/SSR/hydration/type檢查與build通過；consumer型別/prod build及兩path scope通過。native browser已觀察搜尋、方向Enter、Tab、Escape/outside、成功返回開啟按鈕焦點、停用/失敗/pending、dark與320×180、草稿保留；IME及完整極端style矩陣仍待實際操作，感官human-pending。共同詳細契約見[命令面板](../architecture/workbench-command-palette-contract.md)。

## React 錨定與右鍵命令選單

`KlpRegisteredCommandPopup<C>`直接組合相同registry與公開menu。產品提供受控open、readonly anchor `{ x, y, width, height }`，其餘registry／getContext／items／label／emptyLabel／onResult沿menu；onDismiss接收escape／outside／executed並由產品更新open。沒有style覆寫定位入口。按鈕使用原生getBoundingClientRect，右鍵事件由產品preventDefault並提供clientX/Y的零尺寸point。

```tsx
<KlpRegisteredCommandPopup
	registry={commands}
	getContext={() => latestContext}
	items={[{ commandId: 'document.save' }]}
	open={popupOpen}
	anchor={popupAnchor}
	label="文件命令"
	emptyLabel="沒有可用命令"
	onResult={handleProductResult}
	onDismiss={reason => setPopupOpen(false)}
/>
```

同Provider DOM原生dialog取得modal，背景草稿不卸載；有限client viewport與目前風格決定邊距、寬度及下方／上方／較大側。相同session各關閉意圖最多一次；error保持，callback原錯誤沿宿主通道，close／reopen／replacement隔離舊結果。12項protected公開檢查含型別、原12入口checks、build與scope3通過；[CommandsDemo](../../react/example/commands-demo.tsx)已實際觀察button／右鍵、原生`:modal`、Escape／outside／格線一次／原focus／draft以及同Provider dark色。窄viewport完整browser矩陣與感官仍pending；[共同popup契約](../architecture/workbench-command-popup-contract.md)定義完整邊界。
## Registered 快捷鍵純核心

`KlpCommandKeymap<C>`借用同`KlpCommandRegistry<C>`，產品註冊command ID及預設組合。primary在mac對應meta，其餘對應ctrl；作用域固定component／region／page／app，再比priority及UTF-16 ID。產品提供當次context與原生focus鏈；沒有把handler或焦點複製到keymap。

```ts
const keymap = new KlpCommandKeymap(commands, { platform: 'other' });
const unregister = keymap.register({
	id: 'save.primary',
	commandId: 'document.save',
	sequence: [{ key: 's', primary: true }],
	scope: 'app',
});
const outcome = keymap.handle({ key: 's', ctrl: true }, { focusId: 'workspace' }, currentContext);
if (outcome.execution) await outcome.execution;
keymap.setOverride('save.primary', [{ key: 'k', primary: true }, { key: 's' }]);
const saved = JSON.stringify(keymap.exportOverrides());
keymap.importOverrides(JSON.parse(saved));
unregister();
keymap.dispose();
```

只在outcome.handled為true才由native宿主攔截事件。editable預設不接管、composing不執行、repeat需明示allowRepeat；chord每步逾時或焦點鏈改變取消。beginRecording／finishRecording取得最多四鍵而不dispatch，由產品決定套給哪個binding；importOverrides完整驗證後原子替換，錯誤保留舊設定及prefix。9項公開purecore checks與build通過。上述是canonical資料示例；原生keyboard／composition／focus轉換與互動重綁UI尚待獨立交付，完整邊界見[共同契約](../architecture/workbench-shortcut-core-contract.md)。
