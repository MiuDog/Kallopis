# 研究資料庫

目前預覽採微立體 Frame，輸入框 24px。緊湊／基準的 panel 內距 12px，舒展 16px；內容不再疊加頂部內距。消費端要沿用此高度與間距時，將 preview.tsx 的公開 style pack 覆寫帶到自己的 provider。

在 `react/` 執行 `npm run dev`，開啟 `/research/index.html`。這是本機可迭代 example，尚未接入發布 bundle。

消費端複製 `library.tsx` 與 `research.css`，安裝本專案的 `@kallopis/react`，匯入 `@kallopis/react/styles.css`，保留套件字型資產；不需要複製 `preview.tsx` 或 `index.html`。

```tsx
import { KlpThemeProvider } from '@kallopis/react';
import '@kallopis/react/styles.css';
import { ResearchLibrary } from './library.js';

// records、notes 與 handleNoteChange 由產品提供，資料格式見 ResearchRecord。
<KlpThemeProvider mode="light">
	<ResearchLibrary records={records} notes={notes} onNoteChange={handleNoteChange} />
</KlpThemeProvider>;
```

`records` 提供唯一 id、title、category、source、summary、body。`notes` 是 id 到備註的對照，`onNoteChange(id, value)` 回報修改；產品自行決定持久化與失敗提示。預覽只保存記憶體狀態，重新整理即還原。

已確認：TypeScript example 檢查通過；瀏覽器完成淺深切換、舒展變體、備註保留與空搜尋顯示。已觀察桌面畫面；窄視窗及完整跨場景驗收尚未完成。圖片 preview.png 為本次基準畫面，視覺品質待使用者評估。
