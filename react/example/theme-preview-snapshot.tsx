import { useState } from 'react';
import {
	KlpAvatar,
	KlpBadge,
	KlpBreadcrumb,
	KlpButton,
	KlpCard,
	KlpCheckbox,
	KlpFileExplorer,
	KlpProgress,
	KlpStatusBar,
	KlpSurface,
	KlpSwitch,
	KlpText,
	KlpTextField,
	KlpThemeProvider,
	type KlpMode,
} from '@kallopis/react';
import { themeMetadata, themePacks, type ThemeMetadataEntry } from './theme-presets.mjs';

const validModes: readonly KlpMode[] = ['light', 'dark', 'ultraDark', 'transparent'];
const modeDisplayLabels: Record<KlpMode, string> = {
	light: 'Light',
	dark: 'Dark',
	ultraDark: 'Ultra Dark',
	transparent: 'Transparent',
};

const explorerSections = [
	{
		id: 'tokens',
		label: 'STYLE PACK',
		items: [
			{ id: 'tokens.css', label: 'tokens.css' },
			{ id: 'surface.css', label: 'surface.css' },
			{ id: 'typography.md', label: 'typography.md' },
		],
	},
	{
		id: 'workspace',
		label: 'WORKSPACE',
		items: [
			{ id: 'workspace.tsx', label: 'workspace.tsx' },
			{ id: 'components.tsx', label: 'components.tsx' },
		],
	},
];

const colorChips = [
	{ label: 'app', varName: '--klp-colors-app' },
	{ label: 'surface', varName: '--klp-colors-surface' },
	{ label: 'component', varName: '--klp-colors-component' },
	{ label: 'accent', varName: '--klp-colors-accent' },
	{ label: 'brand', varName: '--klp-colors-brand' },
] as const;

/** 單一模式下的標準風格預覽畫布：故意沿用 .ide-topbar / .ide-panel / .showcase-split-card 等語意類別以自動呈現各主題 .surface.css。 */
function PreviewCanvas({ theme, mode, compact }: { theme: ThemeMetadataEntry; mode: KlpMode; compact: boolean }) {
	const [expandedIds] = useState(['tokens', 'workspace']);
	const [selectedId] = useState('workspace.tsx');

	return (
		<KlpThemeProvider
			mode={mode}
			stylePack={themePacks[theme.id]}
			className={compact ? 'theme-snapshot-pane theme-snapshot-pane-compact' : 'theme-snapshot-pane'}
			data-klp-visual-style={theme.family}
			data-klp-visual-mode={mode}
			data-klp-theme-id={theme.id}
			data-klp-theme-version={theme.version}
		>
			<header className="ide-topbar theme-snapshot-topbar">
				<div className="demo-row">
					<KlpBadge tone="info">{theme.id}</KlpBadge>
					{!compact && <KlpBreadcrumb label="工作台路徑" items={[{ label: 'Kallopis', href: '#top' }, { label: '風格工作台', href: '#stage' }, { label: theme.name, href: '#theme' }]} />}
				</div>
				<div className="demo-row">
					{!compact && <KlpButton size="sm" tone="ghost">彙整</KlpButton>}
					<KlpButton size="sm" tone="primary">{compact ? '套用' : '套用主題'}</KlpButton>
					<KlpAvatar label={theme.name} />
				</div>
			</header>

			<div className={compact ? 'theme-snapshot-body theme-snapshot-body-compact' : 'theme-snapshot-body'}>
				{!compact && (
					<aside className="ide-panel theme-snapshot-sidebar">
						<KlpText role="label" tone="muted">EXPLORER</KlpText>
						<KlpFileExplorer
							label="主題工作目錄"
							sections={explorerSections}
							expandedIds={expandedIds}
							selectedId={selectedId}
							onSelect={() => {}}
							onToggle={() => {}}
						/>
					</aside>
				)}

				<main className="ide-panel theme-snapshot-main">
					<div className="theme-snapshot-header">
						<div>
							<h1 className="ide-doc-h1 theme-snapshot-title">{theme.name} · {theme.englishName}</h1>
							<KlpText role="caption" tone="muted">字型：{theme.typography} · 表面：{theme.surfaceStyle}</KlpText>
						</div>
						<div className="demo-row">
							<KlpBadge>Neutral</KlpBadge>
							<KlpBadge tone="success">Success</KlpBadge>
							<KlpBadge tone="warning">Warning</KlpBadge>
							<KlpBadge tone="danger">Danger</KlpBadge>
							<KlpBadge tone="info">Info</KlpBadge>
						</div>
					</div>

					<div className="ide-doc-callout theme-snapshot-callout">
						<KlpText role="body-strong">風格語彙摘要</KlpText>
						<KlpText role="caption" tone="muted">{theme.description}</KlpText>
					</div>

					<div className="theme-snapshot-cards">
						<KlpCard className="showcase-split-card" header={<KlpText role="body-strong">互動控制與狀態</KlpText>}>
							<div className="demo-stack">
								<div className="demo-row">
									<KlpButton tone="primary" size="sm">主要動作</KlpButton>
									<KlpButton selected size="sm">選取態</KlpButton>
									<KlpButton tone="ghost" size="sm">透明</KlpButton>
								</div>
								<div className="demo-row">
									<KlpSwitch label="即時預覽" checked onChange={() => {}} />
									<KlpCheckbox label="鎖定比例" checked onChange={() => {}} />
								</div>
								<KlpProgress label="載入進度" value={68} />
							</div>
						</KlpCard>

						<KlpCard className="showcase-split-card" header={<KlpText role="body-strong">表單輸入與層次色票</KlpText>}>
							<div className="demo-stack">
								<KlpTextField label="變數" value="--klp-colors-accent" readOnly />
								<div className="demo-row">
									<KlpSurface tone="raised" className="theme-snapshot-mini-surface"><KlpText role="caption">Raised</KlpText></KlpSurface>
									<KlpSurface tone="inset" className="theme-snapshot-mini-surface"><KlpText role="caption">Inset</KlpText></KlpSurface>
								</div>
								<div className="theme-snapshot-chips" aria-label="核心色票">
									{colorChips.map(chip => (
										<span key={chip.label} className="theme-snapshot-chip">
											<span className="theme-snapshot-chip-dot" style={{ background: `var(${chip.varName})` }} />
											<KlpText role="caption">{chip.label}</KlpText>
										</span>
									))}
								</div>
							</div>
						</KlpCard>
					</div>
				</main>
			</div>

			<KlpStatusBar className="theme-snapshot-statusbar">
				<span>{theme.id} · v{theme.version}</span>
				<span>{modeDisplayLabels[mode]}</span>
			</KlpStatusBar>
		</KlpThemeProvider>
	);
}

/** 固定構圖的風格截圖範例頁面（?showcase=theme-preview&theme=<id>&mode=dual|light|dark|...），不內含任何切換控制項。 */
export function ThemePreviewSnapshot() {
	const query = typeof window !== 'undefined' ? new URLSearchParams(window.location.search) : null;
	const requestedThemeId = query?.get('theme') ?? 'micro-elevation-v1';
	const theme = themeMetadata.find(entry => entry.id === requestedThemeId) ?? themeMetadata[0];
	const requestedMode = query?.get('mode') ?? 'dual';

	if (requestedMode !== 'dual' && validModes.includes(requestedMode as KlpMode)) {
		return (
			<div className="theme-snapshot-viewport">
				<PreviewCanvas theme={theme} mode={requestedMode as KlpMode} compact={false} />
			</div>
		);
	}

	return (
		<div className="theme-snapshot-viewport theme-snapshot-dual">
			<PreviewCanvas theme={theme} mode="light" compact={false} />
			<PreviewCanvas theme={theme} mode="dark" compact />
		</div>
	);
}
