import { useState } from 'react';
import { createRoot } from 'react-dom/client';
import { KlpThemeProvider, KlpText, KlpButton, createKlpStylePack, applyKlpStyleOverrides, type KlpMode } from '@kallopis/react';
import '@kallopis/react/styles.css';
import { ResearchLibrary, type ResearchRecord } from './library.js';

/* 示範資料與畫面分離；所有內容皆為情境撰寫，非外部研究引文。 */
const records: ResearchRecord[] = [
	{ id: 'calm', title: '讓介面留出思考的空間', category: '介面設計', source: '設計觀察 · 01', summary: '資訊不必同時爭取注意力。讓內容、工具與背景各自扮演清楚的角色。', body: ['一個研究工作區需要容納兩種節奏：快速尋找，以及停下來閱讀。清單幫助辨認差異，閱讀區則應保留連續的文字節奏。', '將常駐工具放在穩定的位置，讓文章標題、摘要與正文形成清楚的閱讀順序。次要資訊仍然可讀，但不需要與主內容競爭。', '接下來可以觀察：切換淺色與深色時，表面層次是否仍然清楚？資訊變密集後，選取中的資料是否容易辨認？'] },
	{ id: 'systems', title: '從元件一致走向語意一致', category: '介面設計', source: '設計觀察 · 02', summary: '同一個視覺角色，在不同畫面中應傳達相同的用途。', body: ['元件外觀相似只是起點。更重要的是，表面、文字與互動狀態是否具有穩定的意義。', '產品可自由組合布局，並由共用語意維持風格；不必為每個情境重新建立一套樣式。'] },
	{ id: 'reading', title: '閱讀不是資訊的堆疊', category: '知識管理', source: '工作方法 · 03', summary: '將收集、理解與自己的觀點分開，讓筆記成為思考的一部分。', body: ['摘要讓人快速判斷一份資料是否相關，正文提供完整脈絡，而自己的備註記錄當下的理解。', '當這三種內容擁有清楚的位置，重新回到資料時，也更容易接續先前的思考。'] },
	{ id: 'context', title: 'Context matters：跨場景的設計驗證', category: '工作方法', source: '驗證紀錄 · 04', summary: '使用真實長度的標題與混合語言，檢查布局的適應能力。', body: ['展示畫面應包含長短不同的內容、沒有結果的搜尋與可編輯欄位。這些狀態能暴露單一靜態畫面看不出的問題。', '評估時固定資料與布局，再切換風格，才能辨認差異來自哪一組視覺參數。'] },
];

/** 預覽擁有主題及示範狀態，消費端只需採用 ResearchLibrary。 */
function Preview() {

	const [mode, setMode] = useState<KlpMode>('light');
	const [density, setDensity] = useState('基準');
	const [notes, setNotes] = useState<Record<string, string>>({});
	const [base] = useState(() => createKlpStylePack());
	const inset = density === '舒展' ? 'p(space400)' : 'p(space300)';
	const gap = density === '緊湊' ? 'p(space100)' : 'p(space200)';
	const pack = applyKlpStyleOverrides(base, { semantics: {
		'theme.spacing.contentInset': { light: inset, dark: inset, ultraDark: inset, transparent: inset },
		'theme.spacing.contentInlineGap': { light: gap, dark: gap, ultraDark: gap, transparent: gap },
	} });

	return <KlpThemeProvider mode={mode} stylePack={pack} className="research-preview">
		<div className="research-controls" aria-label="畫面評估設定">
			<KlpText role="caption" tone="muted">KALLOPIS / EXAMPLE 01</KlpText>
			<div className="research-row" aria-label="明暗模式"><KlpButton size="sm" selected={mode === 'light'} onClick={() => setMode('light')}>淺色</KlpButton><KlpButton size="sm" selected={mode === 'dark'} onClick={() => setMode('dark')}>深色</KlpButton></div>
			<div className="research-row" aria-label="間距風格">{['基準', '緊湊', '舒展'].map(value => <KlpButton key={value} size="sm" selected={density === value} onClick={() => setDensity(value)}>{value}</KlpButton>)}</div>
			<KlpText role="caption" tone="muted">微立體 · 輸入高度 30 · {density}間距</KlpText>
		</div>
		<ResearchLibrary records={records} notes={notes} onNoteChange={(id, value) => setNotes(current => ({ ...current, [id]: value }))} />
	</KlpThemeProvider>;
}

/* 掛載本機展示，沿用 package 擁有的字型與正式元件樣式。 */
document.body.style.margin = '0';
createRoot(document.getElementById('root')!).render(<Preview />);
