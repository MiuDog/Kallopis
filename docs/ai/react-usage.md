# Kallopis React

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
| explorer-folder-row／row／hover／selected | `KlpFileExplorer` | 唯一且非空的 section/item ID；平坦投影，產品持有 expandedIds／selectedId 與 callbacks；hover／selected 同色 |

核心元件皆需 Provider。主題為 `light`、`dark`、`ultraDark`、`transparent`，缺失 Provider 或未知主題／語意／配方明確失敗。巢狀 Provider 具有獨立 scope。透明模式依宿主背景呈現，瀏覽器不提供原生視窗透明能力。

## 維護

350 個語意 × 4 主題、269 個 primitive、118 個配方由正式 Markdown 產生。修改正式規範後執行 `npm run build`，`npm run check:tokens` 檢查來源與產物內容及 SHA256。禁止人工修改 `src/generated.ts`、`src/tokens.css`、`src/source-manifest.json`。

色碼由規範 `#AARRGGBB` 轉為 Web `#RRGGBBAA`；數值單位在 CSS 接入，primitive 原始值保留。字型 family 移除 Flutter package 前綴；字型與授權打包於本庫 `dist/fonts`，產品需允許這些資產載入。

118 項配方完整可查詢；Menu、Dialog 等尚未列為此版公開 React 元件。新增組合依正式語意及跨產品使用需求另行規劃。
