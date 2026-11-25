import { useState } from 'react';
import { KlpThemeProvider, KlpWorkspace, KlpFrame, KlpFileExplorer, KlpText, KlpTextField, KlpButton, KlpList, KlpAlert, KlpLink, KlpBadge, KlpSurface, type KlpMode } from '@kallopis/react';
import { desktopCatalog } from './desktop-catalog-data.mjs';
import { CatalogSpecimen } from './specimens.js';
import { catalogProps } from './catalog-props.mjs';
import { themeMetadata, themePacks } from './theme-presets.mjs';

const modes: readonly KlpMode[] = ['light', 'dark', 'ultraDark', 'transparent'];
const allComponentNames = Object.keys(catalogProps).sort();

/** 完整元件 Catalog：提供分類檢索、風格切換、互動預覽、Props 屬性表與對應 Token 查詢。 */
export function DesktopCatalog() {
	const [themeId, setThemeId] = useState('micro-elevation-v1');
	const [mode, setMode] = useState<KlpMode>('dark');
	const [category, setCategory] = useState('all');
	const [name, setName] = useState('KlpButton');
	const [query, setQuery] = useState('');
	const [expanded, setExpanded] = useState(['desktop']);
	const [copyFeedback, setCopyFeedback] = useState('');

	const activeTheme = themeMetadata.find(item => item.id === themeId) ?? themeMetadata[0];
	const currentCategory = desktopCatalog.find(item => item.id === category);
	const baseNames = category === 'all' ? allComponentNames : (currentCategory?.components ?? allComponentNames);
	const names = baseNames.filter(item => item.toLowerCase().includes(query.toLowerCase()));
	const meta = catalogProps[name];

	function selectCategory(id: string) {
		setCategory(id);
		setQuery('');
		if (id === 'all') return;
		const first = desktopCatalog.find(item => item.id === id)?.components[0];
		if (first) setName(first);
	}

	function selectTheme(id: string) {
		setThemeId(id);
		const found = themeMetadata.find(item => item.id === id);
		if (found) setMode(found.defaultMode);
	}

	async function copyText(text: string, label: string) {
		try {
			await navigator.clipboard.writeText(text);
			setCopyFeedback(`已複製${label}`);
		} catch {
			setCopyFeedback(`請手動選取複製${label}`);
		}
	}

	const categoryItems = [
		{ id: 'all', label: `全部元件 (${allComponentNames.length})` },
		...desktopCatalog.map(item => ({ id: item.id, label: item.title })),
	];

	return (
		<KlpThemeProvider mode={mode} stylePack={themePacks[themeId]} className="demo-app" data-klp-visual-style={activeTheme.family} data-klp-theme-id={activeTheme.id} data-klp-theme-version={activeTheme.version}>
			<header className="demo-header">
				<div className="demo-stack">
					<KlpText role="caption" tone="muted">KALLOPIS / COMPONENT CATALOG &amp; PROPS</KlpText>
					<KlpText as="h1" role="h2">元件 Catalog 與屬性一覽</KlpText>
					<KlpText tone="muted">即時切換風格主題，檢視 {allComponentNames.length} 個公開元件的互動效果、Props 型別與自動對應 Style Tokens。</KlpText>
				</div>
				<div className="demo-stack">
					<div className="demo-row" role="group" aria-label="風格主題">
						{themeMetadata.map(theme => (
							<KlpButton key={theme.id} size="sm" tone={themeId === theme.id ? 'primary' : 'secondary'} selected={themeId === theme.id} onClick={() => selectTheme(theme.id)}>
								{theme.name}
							</KlpButton>
						))}
					</div>
					<div className="demo-row" role="group" aria-label="色彩模式">
						{modes.map(value => (
							<KlpButton key={value} size="sm" selected={mode === value} onClick={() => setMode(value)}>
								{value}
							</KlpButton>
						))}
					</div>
				</div>
			</header>

			<KlpWorkspace>
				<KlpFrame surface="raised" role="sidebar" header={<KlpText role="body-strong">元件分類</KlpText>}>
					<KlpFileExplorer
						sections={[{ id: 'desktop', label: 'Kallopis 元件', items: categoryItems }]}
						expandedIds={expanded}
						selectedId={category}
						onSelect={selectCategory}
						onToggle={() => setExpanded(values => values.length ? [] : ['desktop'])}
					/>
				</KlpFrame>

				<KlpFrame surface="raised" header={<div className="demo-row demo-between"><KlpText role="body-strong">{currentCategory?.title ?? '全部公開元件'}</KlpText><KlpBadge>{activeTheme.name} ({activeTheme.id} · v{activeTheme.version}) · {mode}</KlpBadge></div>}>
					<div className="demo-main">
						{currentCategory && (
							<>
								<KlpText>{currentCategory.types}</KlpText>
								<KlpAlert title="使用邊界">{currentCategory.boundary}</KlpAlert>
							</>
						)}

						<KlpTextField label="搜尋公開元件" placeholder="輸入 KlpButton、KlpDockLayout…" value={query} onChange={event => setQuery(event.target.value)} />

						<KlpList
							label="元件清單"
							items={names.map(item => ({
								id: item,
								title: item,
								description: catalogProps[item] ? `${catalogProps[item].props.length} props · ${catalogProps[item].source}` : '公開元件',
							}))}
							selectedId={name}
							onSelect={setName}
						/>

						{name && (
							<KlpFrame surface="raised" header={<div className="demo-row demo-between"><KlpText role="body-strong">{name}</KlpText><div className="demo-row"><KlpButton size="sm" onClick={() => copyText(`import { ${name} } from '@kallopis/react';`, `${name} import`)}>複製 Import</KlpButton><KlpLink href={`?specimen=${encodeURIComponent(name)}`}>獨立頁面 ↗</KlpLink></div></div>}>
								<div className="demo-main">
									{copyFeedback && <KlpText role="caption" aria-live="polite">{copyFeedback}</KlpText>}

									<div className="demo-stack">
										<KlpText role="label">互動展示（{activeTheme.name} / {mode}）</KlpText>
										<CatalogSpecimen key={`${name}-${themeId}`} name={name} />
									</div>

									{meta && (
										<>
											<div className="demo-stack">
												<KlpText role="label">公開簽名與來源</KlpText>
												<KlpSurface tone="inset" className="demo-surface">
													<KlpText as="code" role="code">{meta.signature}</KlpText>
													<KlpText role="caption" tone="muted">來源：{meta.source}</KlpText>
												</KlpSurface>
											</div>

											<div className="demo-stack">
												<KlpText role="label">屬性列表（Props · {meta.props.length}）</KlpText>
												{meta.props.length ? (
													<div className="catalog-table-wrap">
														<table className="catalog-props-table">
															<thead>
																<tr><th>Prop</th><th>型別</th><th>必要</th><th>預設值</th></tr>
															</thead>
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
													<KlpText role="caption" tone="muted">此元件主要透過標準 HTML / children 屬性組合。</KlpText>
												)}
											</div>

											<div className="demo-stack">
												<div className="demo-row demo-between">
													<KlpText role="label">自動對應 Style Tokens（{meta.tokens.length}）</KlpText>
													<KlpButton size="sm" onClick={() => copyText(meta.tokens.map(token => `var(${token.css})`).join('\n'), '對應 CSS 變數')}>複製 Token 列表</KlpButton>
												</div>
												<div className="catalog-token-list">
													{meta.tokens.map(token => (
														<div key={token.id} className="catalog-token-chip">
															<code>{token.css}</code>
															<span>{token.id} · Flutter: {token.flutter}</span>
														</div>
													))}
												</div>
											</div>
										</>
									)}
								</div>
							</KlpFrame>
						)}
					</div>
				</KlpFrame>
			</KlpWorkspace>
		</KlpThemeProvider>
	);
}
