import { useState } from 'react';
import { createRoot } from 'react-dom/client';
import { KlpThemeProvider, KlpWorkspace, KlpFrame, KlpText, KlpButton, KlpIconButton, KlpCard, KlpBadge, KlpTextField, KlpSurface, KlpFileExplorer, useKlp, klpRecipes, type KlpMode } from '@kallopis/react';
import '@kallopis/react/styles.css';
import './style.css';

const modes: KlpMode[] = ['light', 'dark', 'ultraDark', 'transparent'];
const labels = { light: '淺色', dark: '深色', ultraDark: '極深色', transparent: '透明' };
const sections = [
	{ id: 'foundation', label: '核心元件', items: [{ id: 'overview', label: '總覽與組合' }, { id: 'controls', label: '控制與狀態' }, { id: 'tokens', label: '通用語意' }] },
	{ id: 'guides', label: '使用指南', items: [{ id: 'ownership', label: '產品責任' }, { id: 'recipes', label: '語意配方' }] },
];

function SemanticSample() {
	const { mode, tokens, semantic } = useKlp();
	return <KlpCard header={<KlpText role="body-strong">同一份規範，多個平台</KlpText>}>
		<div className="demo-stack">
			<KlpText as="p" tone="muted">{Object.keys(tokens).length} 項語意 · {Object.keys(klpRecipes).length} 項配方 · {labels[mode]}模式</KlpText>
			<div className="demo-swatches">{['app', 'surface', 'component', 'brand'].map(role => <div key={role}>
				<span className="demo-swatch" style={{ background: String(semantic(`theme.colors.${role}`)) }} />
				<KlpText role="caption">{role}</KlpText>
			</div>)}</div>
		</div>
	</KlpCard>;
}

function App() {
	const [mode, setMode] = useState<KlpMode>('light');
	const [expandedIds, setExpandedIds] = useState(['foundation', 'guides']);
	const [selectedId, setSelectedId] = useState('overview');
	const [name, setName] = useState('Kallopis');
	const [count, setCount] = useState(0);
	const [selected, setSelected] = useState(false);
	return <KlpThemeProvider mode={mode} className="demo-app">
		<header className="demo-header">
			<div className="demo-stack"><KlpText as="h1" role="h3">Kallopis</KlpText><KlpText role="caption" tone="muted">React 核心元件 · 通用視覺規範</KlpText></div>
			<div className="demo-row" aria-label="主題">{modes.map(value => <KlpButton key={value} size="sm" selected={mode === value} onClick={() => setMode(value)}>{labels[value]}</KlpButton>)}</div>
		</header>
		<KlpWorkspace className="demo-workspace">
			<KlpFrame role="sidebar" header={<KlpText role="label">EXPLORER</KlpText>} footer={<KlpText role="caption" tone="muted">狀態與資料由展示頁持有</KlpText>}>
				<KlpFileExplorer sections={sections} expandedIds={expandedIds} selectedId={selectedId} onToggle={id => setExpandedIds(ids => ids.includes(id) ? ids.filter(value => value !== id) : [...ids, id])} onSelect={setSelectedId} />
			</KlpFrame>
			<KlpFrame header={<div className="demo-row demo-between"><KlpText role="body-strong">核心元件展示</KlpText><KlpBadge>v0.1</KlpBadge></div>}>
				<main className="demo-main">
					<div className="demo-stack"><KlpText as="h2" role="h2">用語意組合畫面</KlpText><KlpText as="p" tone="muted">共用庫提供視覺、角色與控制元件。產品決定畫面、資料和業務流程。</KlpText></div>
					{mode === 'transparent' && <KlpText as="p" role="caption">透明模式呈現宿主底色；原生視窗透明效果由宿主提供。</KlpText>}
					<SemanticSample />
					<KlpCard header={<KlpText role="body-strong">按鈕與回呼</KlpText>}>
						<div className="demo-stack"><div className="demo-row">
							<KlpButton tone="primary" onClick={() => setCount(value => value + 1)}>主要動作</KlpButton>
							<KlpButton selected={selected} onClick={() => setSelected(value => !value)}>選取狀態</KlpButton>
							<KlpButton tone="ghost">透明按鈕</KlpButton>
							<KlpButton disabled onClick={() => setCount(value => value + 1)}>停用</KlpButton>
							<KlpIconButton label="增加計數" onClick={() => setCount(value => value + 1)}>+</KlpIconButton>
						</div><KlpText role="caption" aria-live="polite">已執行 {count} 次 · Explorer 選取：{selectedId}</KlpText></div>
					</KlpCard>
					<div className="demo-grid">
						<KlpCard header={<KlpText role="body-strong">文字輸入</KlpText>}><div className="demo-stack">
							<KlpTextField label="名稱" value={name} onChange={event => setName(event.target.value)} hint="由產品持有 value 與 onChange" />
							<KlpTextField label="錯誤範例" error defaultValue="需由產品確認" hint="錯誤狀態沿用共同語意" />
							<KlpTextField label="停用範例" disabled defaultValue="暫不可編輯" />
						</div></KlpCard>
						<KlpCard header={<KlpText role="body-strong">文字與表面</KlpText>}><div className="demo-stack">
							<KlpText role="lead">{name || 'Kallopis'}</KlpText><KlpText tone="muted">次要文字</KlpText><KlpText tone="faint">弱化文字</KlpText><KlpText as="code" role="code">theme.colors.surface</KlpText>
							<div className="demo-row"><KlpBadge tone="success">成功</KlpBadge><KlpBadge tone="warning">提醒</KlpBadge><KlpBadge tone="danger">錯誤</KlpBadge><KlpBadge tone="info">資訊</KlpBadge></div>
							<KlpSurface tone="muted" className="demo-surface"><KlpText role="caption">弱化表面</KlpText></KlpSurface>
						</div></KlpCard>
					</div>
				</main>
			</KlpFrame>
		</KlpWorkspace>
	</KlpThemeProvider>;
}
createRoot(document.getElementById('root')!).render(<App />);
