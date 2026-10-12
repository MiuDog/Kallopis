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
