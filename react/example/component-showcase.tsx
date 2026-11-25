import { useEffect, useMemo, useState } from 'react';
import {
	KlpBadge,
	KlpButton,
	KlpCard,
	KlpSurface,
	KlpText,
	KlpTextField,
	KlpThemeProvider,
	type KlpMode,
} from '@kallopis/react';
import { desktopCatalog } from './desktop-catalog-data.mjs';
import { catalogProps } from './catalog-props.mjs';
import { CatalogSpecimen } from './specimens.js';
import { ModernProductivityStarter } from './modern-productivity-starter.js';
import { themeMetadata, themePacks } from './theme-presets.mjs';
import { curatedComponents, type CuratedComponentEntry } from './curated-registry.js';
import { useLiveStyleBridge } from './live-style-bridge.js';

const modes: readonly KlpMode[] = ['light', 'dark', 'ultraDark', 'transparent'];
const allComponentNames = Object.keys(catalogProps).sort();
const languages = [
	{ id: 'react', label: 'React (TSX)' },
	{ id: 'flutter', label: 'Flutter (Dart)' },
	{ id: 'html', label: 'HTML / CSS' },
] as const;
type LanguageId = (typeof languages)[number]['id'];

const deferredComponents = new Set(['KlpCommandShortcutHost', 'KlpRegisteredCommandPalette', 'KlpDockLayout']);

function CuratedSplitCard({
	entry,
	themeId,
	mode,
	globalLanguage,
	onApplyTheme,
}: {
	entry: CuratedComponentEntry;
	themeId: string;
	mode: KlpMode;
	globalLanguage: LanguageId;
	onApplyTheme: (recommendedTheme: string) => void;
}) {
	const [language, setLanguage] = useState<LanguageId>(globalLanguage);
	const [copied, setCopied] = useState(false);

	useEffect(() => {
		setLanguage(globalLanguage);
	}, [globalLanguage]);

	const code = entry.snippets[language];
	const PreviewComponent = entry.Component;

	async function copyCode() {
		try {
			await navigator.clipboard.writeText(code);
			setCopied(true);
			setTimeout(() => setCopied(false), 1800);
		} catch {
			setCopied(false);
		}
	}

	return (
		<article className="showcase-split-card" id={`curated-${entry.id}`}>
			<header className="showcase-split-head">
				<div className="demo-row">
					<KlpText as="h2" role="h3">{entry.meta.name}</KlpText>
					<KlpBadge tone="info">精選設計元件</KlpBadge>
					<KlpBadge>{entry.meta.recommendedTheme}</KlpBadge>
				</div>
				<div className="demo-row">
					<a className="showcase-card-link" href={entry.meta.inspiration.url} target="_blank" rel="noopener">參考：{entry.meta.inspiration.site} ↗</a>
					<KlpButton size="sm" onClick={() => onApplyTheme(entry.meta.recommendedTheme)}>套用推薦風格</KlpButton>
				</div>
			</header>

			<div className="showcase-split-grid">
				<div className="showcase-preview-col">
					<KlpText role="label" tone="muted">精選互動預覽 · {themeId} ({mode})</KlpText>
					<KlpText role="caption" tone="muted">{entry.meta.summary}</KlpText>
					<KlpSurface tone="inset" className="showcase-preview-box">
						<PreviewComponent />
					</KlpSurface>
				</div>

				<div className="showcase-code-col">
					<div className="showcase-code-bar">
						<div className="showcase-lang-tabs" role="tablist" aria-label={`${entry.meta.name} 使用語言範例`}>
							{languages.map(item => (
								<KlpButton
									key={item.id}
									size="sm"
									tone={language === item.id ? 'primary' : 'secondary'}
									selected={language === item.id}
									onClick={() => setLanguage(item.id)}
								>
									{item.label}
								</KlpButton>
							))}
						</div>
						<KlpButton size="sm" onClick={copyCode}>{copied ? '已複製 ✓' : '複製程式碼'}</KlpButton>
					</div>

					<pre className="showcase-code-block"><code>{code}</code></pre>

					<details className="showcase-details">
						<summary>設計特徵（{entry.meta.inspiration.traits.length}）與使用 Tokens（{entry.meta.tokensUsed.length}）</summary>
						<div className="demo-stack demo-mt-8">
							<KlpText role="caption">設計特徵：{entry.meta.inspiration.traits.join(' · ')}</KlpText>
							<div className="catalog-token-list">
								{entry.meta.tokensUsed.map(tokenId => (
									<div key={tokenId} className="catalog-token-chip">
										<code>--klp-{tokenId.replace(/^theme\./, '').replaceAll('.', '-')}</code>
										<span>{tokenId}</span>
									</div>
								))}
							</div>
						</div>
					</details>
				</div>
			</div>
		</article>
	);
}

function ComponentSplitCard({
	name,
	themeId,
	mode,
	globalLanguage,
}: {
	name: string;
	themeId: string;
	mode: KlpMode;
	globalLanguage: LanguageId;
}) {
	const [language, setLanguage] = useState<LanguageId>(globalLanguage);
	const [copied, setCopied] = useState(false);
	const [mountedHeavy, setMountedHeavy] = useState(!deferredComponents.has(name));
	const meta = catalogProps[name];

	useEffect(() => {
		setLanguage(globalLanguage);
	}, [globalLanguage]);

	if (!meta) return null;
	const code = meta.snippets[language];

	async function copyCode() {
		try {
			await navigator.clipboard.writeText(code);
			setCopied(true);
			setTimeout(() => setCopied(false), 1800);
		} catch {
			setCopied(false);
		}
	}

	let preview;
	if (name === 'KlpModernProductivityLayout') {
		preview = (
			<div className="showcase-bounded-preview">
				<ModernProductivityStarter />
			</div>
		);
	} else if (!mountedHeavy) {
		preview = (
			<div className="demo-stack">
				<KlpText role="caption" tone="muted">此元件含全域快捷鍵或複雜停靠面板，點選下方按鈕於此卡片內啟動互動展示。</KlpText>
				<div><KlpButton tone="primary" onClick={() => setMountedHeavy(true)}>啟動 {name} 互動展示</KlpButton></div>
			</div>
		);
	} else {
		preview = <CatalogSpecimen key={`${name}-${themeId}`} name={name} />;
	}

	return (
		<article className="showcase-split-card" id={`component-${name}`}>
			<header className="showcase-split-head">
				<div className="demo-row">
					<KlpText as="h2" role="h3">{name}</KlpText>
					<KlpBadge>{meta.props.length} props</KlpBadge>
				</div>
				<div className="demo-row">
					<KlpText role="caption" tone="muted">{meta.source}</KlpText>
					<a className="showcase-card-link" href={`?specimen=${encodeURIComponent(name)}`} target="_blank" rel="noopener">獨立開啟 ↗</a>
				</div>
			</header>

			<div className="showcase-split-grid">
				<div className="showcase-preview-col">
					<KlpText role="label" tone="muted">互動預覽 · {themeId} ({mode})</KlpText>
					<KlpSurface tone="inset" className="showcase-preview-box">
						{preview}
					</KlpSurface>
				</div>

				<div className="showcase-code-col">
					<div className="showcase-code-bar">
						<div className="showcase-lang-tabs" role="tablist" aria-label={`${name} 使用語言範例`}>
							{languages.map(item => (
								<KlpButton
									key={item.id}
									size="sm"
									tone={language === item.id ? 'primary' : 'secondary'}
									selected={language === item.id}
									onClick={() => setLanguage(item.id)}
								>
									{item.label}
								</KlpButton>
							))}
						</div>
						<KlpButton size="sm" onClick={copyCode}>{copied ? '已複製 ✓' : '複製程式碼'}</KlpButton>
					</div>

					<pre className="showcase-code-block"><code>{code}</code></pre>

					<details className="showcase-details">
						<summary>Props 屬性（{meta.props.length}）與對應 Tokens（{meta.tokens.length}）</summary>
						<div className="demo-stack demo-mt-8">
							{meta.props.length ? (
								<div className="catalog-table-wrap">
									<table className="catalog-props-table">
										<thead><tr><th>Prop</th><th>型別</th><th>必要</th><th>預設值</th></tr></thead>
										<tbody>
											{meta.props.map(prop => (
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
							) : (
								<KlpText role="caption" tone="muted">此元件直接接受標準 children 與容器屬性。</KlpText>
							)}
							<div className="catalog-token-list">
								{meta.tokens.map(token => (
									<div key={token.id} className="catalog-token-chip">
										<code>{token.css}</code>
										<span>{token.id} · Flutter: {token.flutter}</span>
									</div>
								))}
							</div>
						</div>
					</details>
				</div>
			</div>
		</article>
	);
}

/** 風格示範專用的全元件互動總覽：支援核心公開元件與精選風格擴充元件，並列多語言使用範例。 */
export function ComponentShowcase() {
	const { themeId, mode, customVars, setThemeId: selectTheme, setMode: selectMode } = useLiveStyleBridge('micro-elevation-v1', 'light');
	const [category, setCategory] = useState('curated');
	const [query, setQuery] = useState('');
	const [globalLanguage, setGlobalLanguage] = useState<LanguageId>('react');
	const [showAll, setShowAll] = useState(false);

	const activeTheme = themeMetadata.find(item => item.id === themeId) ?? themeMetadata[0];
	const filter = query.trim().toLowerCase();

	const visibleCurated = useMemo(() => {
		if (!showAll && category !== 'curated' && category !== 'all' && !filter) return [];
		return curatedComponents.filter(item =>
			!filter ||
			item.id.toLowerCase().includes(filter) ||
			item.meta.name.toLowerCase().includes(filter) ||
			item.meta.englishName.toLowerCase().includes(filter),
		);
	}, [category, filter, showAll]);

	const visibleCoreNames = useMemo(() => {
		if (!showAll && category === 'curated' && !filter) return [];
		const base = (showAll || category === 'all' || filter)
			? allComponentNames
			: (desktopCatalog.find(item => item.id === category)?.components ?? allComponentNames);
		return base.filter(item => Object.hasOwn(catalogProps, item) && (!filter || item.toLowerCase().includes(filter)));
	}, [category, filter, showAll]);

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
				<KlpCard
					header={
						<div className="demo-row demo-between">
							<div className="demo-stack">
								<KlpText role="label" tone="muted">ALL INTERACTIVE COMPONENTS · {allComponentNames.length} 核心元件 + {curatedComponents.length} 精選設計元件</KlpText>
								<KlpText as="h1" role="h2">全部互動元件與多語言範例</KlpText>
							</div>
							<KlpBadge>{activeTheme.name} ({activeTheme.id}) · {mode}</KlpBadge>
						</div>
					}
				>
					<div className="demo-stack">
						<div className="demo-row" role="group" aria-label="切換風格主題">
							<KlpText role="label">風格</KlpText>
							{themeMetadata.map(theme => (
								<KlpButton key={theme.id} size="sm" tone={themeId === theme.id ? 'primary' : 'secondary'} selected={themeId === theme.id} onClick={() => selectTheme(theme.id)}>
									{theme.name} ({theme.id})
								</KlpButton>
							))}
						</div>
						<div className="demo-row" role="group" aria-label="切換色彩模式">
							<KlpText role="label">模式</KlpText>
							{modes.map(value => (
								<KlpButton key={value} size="sm" selected={mode === value} onClick={() => selectMode(value)}>
									{value}
								</KlpButton>
							))}
							<KlpText role="label" className="demo-ml-8">預設範例語言</KlpText>
							{languages.map(lang => (
								<KlpButton key={lang.id} size="sm" selected={globalLanguage === lang.id} onClick={() => setGlobalLanguage(lang.id)}>
									{lang.label}
								</KlpButton>
							))}
						</div>
						<div className="showcase-chips" role="group" aria-label="元件分類篩選">
							<KlpButton size="sm" tone={!showAll && category === 'curated' ? 'primary' : 'secondary'} selected={!showAll && category === 'curated'} onClick={() => { setCategory('curated'); setShowAll(false); }}>
								精選設計元件 ({curatedComponents.length})
							</KlpButton>
							<KlpButton size="sm" selected={showAll || category === 'all'} onClick={() => { setCategory('all'); setShowAll(true); }}>
								全部顯示 ({allComponentNames.length + curatedComponents.length})
							</KlpButton>
							{desktopCatalog.map(group => (
								<KlpButton key={group.id} size="sm" selected={!showAll && category === group.id} onClick={() => { setCategory(group.id); setShowAll(false); }}>
									{group.title}
								</KlpButton>
							))}
						</div>
						<KlpTextField label="搜尋元件名稱" placeholder="例如 micro-elevated、editorial、KlpButton、KlpTabs…" value={query} onChange={event => setQuery(event.target.value)} />
					</div>
				</KlpCard>

				<div className="showcase-list">
					{visibleCurated.map(entry => (
						<CuratedSplitCard key={entry.id} entry={entry} themeId={themeId} mode={mode} globalLanguage={globalLanguage} onApplyTheme={selectTheme} />
					))}
					{visibleCoreNames.map(name => (
						<ComponentSplitCard key={name} name={name} themeId={themeId} mode={mode} globalLanguage={globalLanguage} />
					))}
				</div>
			</div>
		</KlpThemeProvider>
	);
}
