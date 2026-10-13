import { useState } from 'react';
import { KlpThemeProvider, KlpButton, KlpText, KlpTextField, createKlpStylePack, applyKlpStyleOverrides, type KlpMode, type KlpStyleOverrides } from '@kallopis/react';
import { ModernProductivityStarter } from './modern-productivity-starter.js';

/* fields：調整入口的名稱與 canonical ID；預設數值由正式 pack 擁有。 */
const fields = [
	['theme.spacing.chromeHeader', 'Header 最小高度'],
	['theme.spacing.space2', '外距與欄間距'],
	['theme.spacing.actionGap', '按鈕列間距'],
	['theme.shape.panel', '側欄圓角'],
	['theme.geometry.control.buttonHeight', '切換按鈕高度'],
] as const;
const modes: KlpMode[] = ['light', 'dark', 'ultraDark', 'transparent'];

/** 真實模板預覽；局部設定與 consumer 草稿分離。 */
export function ModernProductivityPreview({ id }: { id: string }) {
	const [base] = useState(() => createKlpStylePack());
	const [pack, setPack] = useState(base);
	const [mode, setMode] = useState<KlpMode>('light');
	const [overrides, setOverrides] = useState<KlpStyleOverrides>({});
	const [widthText, setWidthText] = useState('');
	const [sidebarWidth, setSidebarWidth] = useState<number>();
	const [feedback, setFeedback] = useState('');
	const primitives = Object.entries(base.primitives).filter((entry): entry is [string, number] => typeof entry[1] === 'number' && Number.isFinite(entry[1]) && entry[1] >= 0).sort((a, b) => a[1] - b[1]);
	function changeWidth(value: string) {
		setWidthText(value);
		const width = Number(value);
		if (value && (!Number.isFinite(width) || width <= 0)) { setFeedback('側欄寬度必須是有限正數；保留上一份設定。'); return; }
		setSidebarWidth(value ? width : undefined);
		setFeedback('');
	}
	function changeSemantic(id: string, expression: string) {
		const semantics = { ...overrides.semantics };
		const values = { ...semantics[id] };
		if (expression) values[mode] = expression;
		else delete values[mode];
		if (Object.keys(values).length) semantics[id] = values;
		else delete semantics[id];
		const next: KlpStyleOverrides = { semantics };
		try { const nextPack = applyKlpStyleOverrides(base, next); setPack(nextPack); setOverrides(next); setFeedback(''); }
		catch (error) { setFeedback(`設定無效，保留上一份設定：${error instanceof Error ? error.message : String(error)}`); }
	}
	function reset() { setPack(base); setOverrides({}); setSidebarWidth(undefined); setWidthText(''); setFeedback('設定已還原；功能選取與草稿保持。'); }
	const snippet = `// modern-productivity-layout v1 · @kallopis/react 0.1.0\nimport { KlpThemeProvider, createKlpStylePack, applyKlpStyleOverrides } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\nconst pack = applyKlpStyleOverrides(createKlpStylePack(), ${JSON.stringify(overrides, null, '\t')});\n// 從公開起始範例匯入 ModernProductivityStarter：\n<KlpThemeProvider mode="${mode}" stylePack={pack}>\n\t<ModernProductivityStarter sidebarWidth={${sidebarWidth ?? 'undefined'}} />\n</KlpThemeProvider>;`;
	async function copy() {
		try { await navigator.clipboard.writeText(snippet); setFeedback('設定已複製。'); }
		catch { setFeedback('無法自動複製，請手動選取下方文字。'); }
	}
	if (id !== 'modern-productivity-layout') return <KlpThemeProvider><KlpText>未知或歧義的模板路由。</KlpText></KlpThemeProvider>;
	return <KlpThemeProvider mode={mode} stylePack={pack} style={{ height: '100dvh', display: 'flex', flexDirection: 'column' }}>
		<section aria-label="模板設定" style={{ flex: '0 0 35%', minHeight: 0, overflow: 'auto', padding: 'var(--klp-theme-spacing-content-inset)', boxSizing: 'border-box' }}>
			<KlpText as="h1" role="h3">現代風生產力佈局 · 即時調整</KlpText>
			<div style={{ display: 'flex', flexWrap: 'wrap', gap: 'var(--klp-theme-spacing-action-gap)' }}>{modes.map(value => <KlpButton key={value} selected={mode === value} onClick={() => setMode(value)}>{value}</KlpButton>)}<KlpButton onClick={reset}>還原設定</KlpButton><KlpButton onClick={copy}>複製設定</KlpButton></div>
			<div style={{ display: 'flex', flexWrap: 'wrap', gap: 'var(--klp-theme-spacing-action-gap)' }}>
				<KlpTextField label="側欄寬度（空白使用預設）" type="number" value={widthText} onChange={event => changeWidth(event.target.value)} />
				{fields.map(([key, label]) => <label key={key}>{label}<select aria-label={label} value={String(overrides.semantics?.[key]?.[mode] ?? '')} onChange={event => changeSemantic(key, event.target.value)}><option value="">預設</option>{primitives.map(([name, value]) => <option key={name} value={`p(${name})`}>{value} · {name}</option>)}</select></label>)}
			</div>
			<p role="status">{feedback}</p>
			<pre aria-label="接入設定" style={{ whiteSpace: 'pre-wrap' }}>{snippet}</pre>
		</section>
		<main style={{ flex: 1, minWidth: 0, minHeight: 0 }}><ModernProductivityStarter sidebarWidth={sidebarWidth} /></main>
	</KlpThemeProvider>;
}
