import { useEffect, useState } from 'react';
import {
	KlpAlert,
	KlpAvatar,
	KlpBadge,
	KlpBreadcrumb,
	KlpButton,
	KlpCard,
	KlpCheckbox,
	KlpFileExplorer,
	KlpIconButton,
	KlpProgress,
	KlpRadioGroup,
	KlpSelect,
	KlpSlider,
	KlpSurface,
	KlpSwitch,
	KlpTabs,
	KlpText,
	KlpTextField,
	KlpThemeProvider,
	type KlpMode,
} from '@kallopis/react';
import { catalogProps } from './catalog-props.mjs';
import { curatedComponents } from './curated-registry.js';
import { CatalogSpecimen } from './specimens.js';
import { ModernProductivityStarter } from './modern-productivity-starter.js';
import { themeMetadata, themePacks } from './theme-presets.mjs';
import { useLiveStyleBridge } from './live-style-bridge.js';

const languages = [
	{ id: 'react', label: 'React (TSX)' },
	{ id: 'flutter', label: 'Flutter (Dart)' },
	{ id: 'html', label: 'HTML / CSS' },
] as const;
type LanguageId = (typeof languages)[number]['id'];

/** 風格示範頁使用的代表性元件矩陣：純粹呈現元件效果與即時 CSS 變動，控制項與範例完全分離。 */
export function StyleMatrixPreview() {
	const { themeId, mode, customVars } = useLiveStyleBridge('micro-elevation-v1', 'light');
	const activeTheme = themeMetadata.find(item => item.id === themeId) ?? themeMetadata[0];
	const [selectedButton, setSelectedButton] = useState(true);
	const [textValue, setTextValue] = useState('即時預覽輸入文字');
	const [checked, setChecked] = useState(true);
	const [switched, setSwitched] = useState(true);
	const [radioValue, setRadioValue] = useState('a');
	const [sliderValue, setSliderValue] = useState(64);
	const [tabValue, setTabValue] = useState('overview');
	const [selectedFile, setSelectedFile] = useState('theme.css');
	const [expanded, setExpanded] = useState(['styles']);

	return (
		<KlpThemeProvider
			mode={mode}
			stylePack={themePacks[themeId]}
			style={customVars}
			className="demo-app showcase-root"
			data-klp-visual-style={activeTheme.family}
			data-klp-theme-id={activeTheme.id}
			data-klp-theme-version={activeTheme.version}
		>
			<div className="showcase-container">
				<div className="matrix-grid">
					<KlpCard header={<KlpText role="body-strong">動作與按鈕（Actions）</KlpText>}>
						<div className="demo-stack">
							<div className="demo-row">
								<KlpButton tone="primary">主要動作</KlpButton>
								<KlpButton selected={selectedButton} onClick={() => setSelectedButton(v => !v)}>選取態</KlpButton>
								<KlpButton tone="ghost">幽靈按鈕</KlpButton>
								<KlpButton disabled>停用</KlpButton>
								<KlpIconButton label="新增">+</KlpIconButton>
							</div>
							<div className="demo-row">
								<KlpBadge>Neutral</KlpBadge>
								<KlpBadge tone="success">Success</KlpBadge>
								<KlpBadge tone="warning">Warning</KlpBadge>
								<KlpBadge tone="danger">Danger</KlpBadge>
								<KlpBadge tone="info">Info</KlpBadge>
							</div>
						</div>
					</KlpCard>

					<KlpCard header={<KlpText role="body-strong">輸入與選取（Inputs &amp; Selection）</KlpText>}>
						<div className="demo-stack">
							<KlpTextField label="主題變數預覽" value={textValue} onChange={e => setTextValue(e.target.value)} />
							<div className="demo-row">
								<KlpCheckbox label="套用圓角" checked={checked} onChange={e => setChecked(e.target.checked)} />
								<KlpSwitch label="即時預覽" checked={switched} onChange={e => setSwitched(e.target.checked)} />
							</div>
							<KlpRadioGroup label="表面對齊" options={[{ value: 'a', label: '緊湊' }, { value: 'b', label: '標準' }]} value={radioValue} onValueChange={setRadioValue} />
							<KlpSelect label="檢視比例" options={[{ value: '100', label: '100%' }, { value: '125', label: '125%' }]} defaultValue="100" />
							<KlpSlider label="透明與間距" min={0} max={100} value={sliderValue} onChange={e => setSliderValue(Number(e.target.value))} />
						</div>
					</KlpCard>

					<KlpCard header={<KlpText role="body-strong">導覽、回饋與分層表面</KlpText>}>
						<div className="demo-stack">
							<KlpBreadcrumb label="位置" items={[{ label: 'Kallopis', href: '#top' }, { label: activeTheme.name, href: '#style' }]} />
							<KlpTabs
								label="檢視切換"
								value={tabValue}
								onValueChange={setTabValue}
								tabs={[
									{ id: 'overview', label: '總覽', content: <KlpAlert title="風格已套用" tone="info">{activeTheme.name}（{activeTheme.id}）· {mode}</KlpAlert> },
									{ id: 'progress', label: '進度', content: <KlpProgress label="載入" value={sliderValue} /> },
								]}
							/>
							<div className="demo-row">
								<KlpAvatar label="Kallopis" />
								<KlpSurface tone="raised" className="demo-surface"><KlpText role="caption">Raised Surface</KlpText></KlpSurface>
								<KlpSurface tone="inset" className="demo-surface"><KlpText role="caption">Inset Surface</KlpText></KlpSurface>
							</div>
						</div>
					</KlpCard>

					<KlpCard header={<KlpText role="body-strong">檔案樹與精選風格元件</KlpText>}>
						<div className="demo-stack">
							<KlpFileExplorer
								label="風格目錄"
								sections={[{ id: 'styles', label: 'styles/themes', items: [{ id: 'theme.css', label: `${activeTheme.id}.css` }, { id: 'theme.js', label: `${activeTheme.id}.js` }] }]}
								expandedIds={expanded}
								selectedId={selectedFile}
								onSelect={setSelectedFile}
								onToggle={id => setExpanded(prev => prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id])}
							/>
							{curatedComponents.map(entry => {
								const Curated = entry.Component;
								return (
									<div key={entry.id} className="demo-stack">
										<KlpText role="label" tone="muted">{entry.meta.name}</KlpText>
										<Curated />
									</div>
								);
							})}
						</div>
					</KlpCard>
				</div>
			</div>
		</KlpThemeProvider>
	);
}

/** 獨立元件表頁（components.html）的單一元件聚焦舞台：控制列與範例分離，並列三語言範例。 */
export function SingleComponentStage() {
	const initialQuery = typeof window !== 'undefined' ? new URLSearchParams(window.location.search) : null;
	const [componentId, setComponentId] = useState(initialQuery?.get('component') || 'KlpButton');
	const [language, setLanguage] = useState<LanguageId>('react');
	const [copied, setCopied] = useState(false);
	const { themeId, mode, customVars } = useLiveStyleBridge('micro-elevation-v1', 'light');
	const activeTheme = themeMetadata.find(item => item.id === themeId) ?? themeMetadata[0];

	useEffect(() => {
		function onMessage(event: MessageEvent) {
			const data = event.data;
			if (!data || typeof data !== 'object') return;
			if (data.type === 'klp-select-component' && typeof data.id === 'string') setComponentId(data.id);
			if (data.type === 'klp-language-change' && languages.some(item => item.id === data.language)) setLanguage(data.language);
		}
		window.addEventListener('message', onMessage);
		return () => window.removeEventListener('message', onMessage);
	}, []);

	const curated = curatedComponents.find(item => item.id === componentId);
	const core = catalogProps[componentId];
	const code = curated ? curated.snippets[language] : core?.snippets[language] ?? '';

	async function copyCode() {
		if (!code) return;
		try {
			await navigator.clipboard.writeText(code);
			setCopied(true);
			setTimeout(() => setCopied(false), 1800);
		} catch {
			setCopied(false);
		}
	}

	let previewNode = <KlpText>找不到元件：{componentId}</KlpText>;
	if (curated) {
		const Curated = curated.Component;
		previewNode = <Curated />;
	} else if (core) {
		previewNode = componentId === 'KlpModernProductivityLayout'
			? <div className="showcase-bounded-preview"><ModernProductivityStarter /></div>
			: <CatalogSpecimen key={`${componentId}-${themeId}`} name={componentId} />;
	}

	return (
		<KlpThemeProvider
			mode={mode}
			stylePack={themePacks[themeId]}
			style={customVars}
			className="demo-app showcase-root"
			data-klp-visual-style={activeTheme.family}
			data-klp-theme-id={activeTheme.id}
			data-klp-theme-version={activeTheme.version}
		>
			<div className="showcase-container">
				<article className="showcase-split-card">
					<header className="showcase-split-head">
						<div className="demo-row">
							<KlpText as="h1" role="h2">{curated ? curated.meta.name : componentId}</KlpText>
							<KlpBadge>{curated ? '精選設計元件' : `${core?.props.length ?? 0} props`}</KlpBadge>
							<KlpBadge tone="info">{activeTheme.name} · {mode}</KlpBadge>
						</div>
						<div className="demo-row">
							<KlpText role="caption" tone="muted">{curated ? curated.meta.inspiration.site : core?.source}</KlpText>
							{!curated && core && (
								<a className="showcase-card-link" href={`?specimen=${encodeURIComponent(componentId)}`} target="_blank" rel="noopener">獨立頁面 ↗</a>
							)}
						</div>
					</header>

					<div className="showcase-split-grid">
						<div className="showcase-preview-col">
							<KlpText role="label" tone="muted">元件互動預覽</KlpText>
							{curated && <KlpText role="caption" tone="muted">{curated.meta.summary}</KlpText>}
							<div className="specimen-stage">{previewNode}</div>
						</div>

						<div className="showcase-code-col">
							<div className="showcase-code-bar">
								<div className="showcase-lang-tabs" role="tablist" aria-label="使用語言範例">
									{languages.map(item => (
										<KlpButton key={item.id} size="sm" tone={language === item.id ? 'primary' : 'secondary'} selected={language === item.id} onClick={() => setLanguage(item.id)}>
											{item.label}
										</KlpButton>
									))}
								</div>
								<KlpButton size="sm" onClick={copyCode}>{copied ? '已複製 ✓' : '複製程式碼'}</KlpButton>
							</div>
							<pre className="showcase-code-block"><code>{code}</code></pre>
						</div>
					</div>
				</article>

				{core && (
					<KlpCard header={<KlpText role="body-strong">Props 屬性與自動對應 Tokens</KlpText>}>
						<div className="demo-stack">
							{core.props.length ? (
								<div className="catalog-table-wrap">
									<table className="catalog-props-table">
										<thead><tr><th>Prop</th><th>型別</th><th>必要</th><th>預設值</th></tr></thead>
										<tbody>
											{core.props.map(prop => (
												<tr key={prop.name}>
													<td><code>{prop.name}</code></td>
													<td><code>{prop.type}</code></td>
													<td>{prop.required ? '是' : '選填'}</td>
													<td><code>{prop.defaultValue ?? '—'}</code></td>
												</tr>
											))}
										</tbody>
									</table>
								</div>
							) : <KlpText role="caption" tone="muted">此元件主要接受標準 children 與容器屬性。</KlpText>}
							<div className="catalog-token-list">
								{core.tokens.map(token => (
									<div key={token.id} className="catalog-token-chip">
										<code>{token.css}</code>
										<span>{token.id} · Flutter: {token.flutter}</span>
									</div>
								))}
							</div>
						</div>
					</KlpCard>
				)}

				{curated && (
					<KlpCard header={<KlpText role="body-strong">精選元件設計特徵與使用 Tokens</KlpText>}>
						<div className="demo-stack">
							<KlpText role="caption">設計特徵：{curated.meta.inspiration.traits.join(' · ')}</KlpText>
							<div className="catalog-token-list">
								{curated.meta.tokensUsed.map(tokenId => (
									<div key={tokenId} className="catalog-token-chip">
										<code>--klp-{tokenId.replace(/^theme\./, '').replaceAll('.', '-')}</code>
										<span>{tokenId}</span>
									</div>
								))}
							</div>
						</div>
					</KlpCard>
				)}
			</div>
		</KlpThemeProvider>
	);
}
