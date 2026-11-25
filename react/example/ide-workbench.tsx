import { useEffect, useMemo, useRef, useState } from 'react';
import {
	KlpBadge,
	KlpButton,
	KlpCommandKeymap,
	KlpCommandRegistry,
	KlpCommandShortcutHost,
	KlpFileExplorer,
	KlpIconButton,
	KlpRegisteredCommandPalette,
	KlpStatusBar,
	KlpSurface,
	KlpText,
	KlpTextField,
	KlpThemeProvider,
	useKlp,
	type KlpCommandExecutionResult,
	type KlpMode,
	type KlpShortcutFocus,
} from '@kallopis/react';
import { themeMetadata, themePacks } from './theme-presets.mjs';
import { useLiveStyleBridge } from './live-style-bridge.js';

interface DocFile {
	id: string;
	folder: string;
	title: string;
	breadcrumb: string;
	calloutTitle: string;
	calloutBody: string;
	body: string;
	code: string;
}

const initialDocs: readonly DocFile[] = [
	{
		id: 'README',
		folder: 'current',
		title: 'Unico 專案主索引',
		breadcrumb: '專案 / Unico個人Agent團隊工作介面 / README',
		calloutTitle: '開發 Agent 交接入口',
		calloutBody: '依開發交付定案實作與驗收。該文件已裁定技術版本、介面樣式、執行順序與整合範圍。',
		body: '一句話定位：讓個人工作室負責人管理交付、制定開發流程並親自把關實作的 AI 團隊工作台。布局結構、視覺風格與明暗模式各自獨立。',
		code: `Unico個人Agent團隊工作介面/\n├── README.md                  # 本文件 (根目錄主索引)\n├── 01_核心規格/               # 產品單一真相來源 (SSOT)\n│   └── 主藍圖總綱.md          # 5層架構、7階段流程\n├── 02_系統設計/               # 核心機制與介面契約\n└── 03_外部工具與整合/         # 擴充介面與對接文件`,
	},
	{
		id: '01_核心規格',
		folder: 'current',
		title: '01 核心規格與設計系統',
		breadcrumb: '專案 / Unico個人Agent團隊工作介面 / 01_核心規格',
		calloutTitle: '風格與布局分離契約',
		calloutBody: '風格設定集中於根目錄 styles/themes/，Flutter 與 React 只維護元件與自動生成的語意對應。',
		body: '其他專案不需匯入完整元件庫即可查詢並複製 tokens（--klp-*）、範例圖片與獨立 HTML/CSS 組合。切換風格時保留所有展開、分頁與編輯草稿。',
		code: `/* 複製 styles/themes/modern-minimal-v1.css 或 micro-elevation-v1.css */\n:root {\n\t--klp-colors-app: var(--klp-colors-app);\n\t--klp-colors-stageSurface: var(--klp-colors-stageSurface);\n\t--klp-colors-accent: var(--klp-colors-accent);\n}`,
	},
	{
		id: '02_系統設計',
		folder: 'current',
		title: '02 系統設計與元件清冊',
		breadcrumb: '專案 / Unico個人Agent團隊工作介面 / 02_系統設計',
		calloutTitle: '元件與跨框架對應',
		calloutBody: '每個語意 token 名稱自動對應 React CSS 變數與 Flutter 主題欄位，確保跨端一致性。',
		body: '工作台左側為活動列與可折疊檔案樹，中央為可切換編輯／預覽的多分頁舞台，右側為即時大綱面板，底部為統計狀態列。',
		code: `<KlpThemeProvider mode={mode} stylePack={themePacks[themeId]}>\n\t<KlpFileExplorer sections={sections} ... />\n\t<KlpStatusBar>2,029 個詞 · 4,431 個字元</KlpStatusBar>\n</KlpThemeProvider>`,
	},
	{
		id: '03_外部工具與整合',
		folder: 'current',
		title: '03 外部工具與複製路徑',
		breadcrumb: '專案 / Unico個人Agent團隊工作介面 / 03_外部工具與整合',
		calloutTitle: '開箱即用的風格包',
		calloutBody: '支援四種標準模式（light / dark / ultraDark / transparent），並可匯出純 CSS Variables 給任意前端技術棧。',
		body: '現代簡約風取材自 open-tag 的 Quietly Editorial 設計語彙（#F5F5F5 畫布、#292524 暖墨黑與 1px 細線）；微立體採用炭灰多層抬升卡片與琥珀金點綴。',
		code: `node styles/scripts/generate-themes.mjs\nnode styles/scripts/generate-curated.mjs`,
	},
	{
		id: 'bootstrap',
		folder: 'paths',
		title: 'bootstrap 工作環境設定',
		breadcrumb: '路徑 / 專案 / bootstrap',
		calloutTitle: '快捷鍵與命令面板',
		calloutBody: '按 Ctrl+Shift+P（或點擊命令面板）可開啟全域命令面板，切換側欄與複製風格。',
		body: '此檔案保留於分頁列，驗證在切換不同風格主題與深淺模式時，未儲存的草稿文字與樹狀展開狀態不會重置。',
		code: `export const workspace = {\n\ttheme: 'micro-elevation-v1',\n\tmode: 'light',\n\tpanels: { left: true, right: true, bottom: false }\n};`,
	},
];

const modes: readonly KlpMode[] = ['light', 'dark', 'ultraDark', 'transparent'];

interface IdeContext {
	toggleLeft: () => string;
	toggleRight: () => string;
	toggleBottom: () => string;
	cycleTheme: () => string;
}

function IdeCssCopier({ themeId, onStatus }: { themeId: string; onStatus: (text: string) => void }) {
	const { tokens, mode } = useKlp();
	async function copyCss() {
		const lines = Object.entries(tokens)
			.filter(([id]) => id.startsWith('theme.colors.') || id.startsWith('theme.shape.'))
			.map(([id, value]) => {
				const name = `--klp-${id.slice(6).replaceAll('.', '-')}`;
				const formatted = typeof value === 'number' && id.startsWith('theme.shape.') && id !== 'theme.shape.dashedOpacity' ? `${value}px` : String(value);
				return `\t${name}: ${formatted};`;
			})
			.join('\n');
		const css = `/* ${themeId} (${mode}) */\n:root {\n${lines}\n}`;
		try {
			await navigator.clipboard.writeText(css);
			onStatus(`已複製 ${themeId} (${mode}) CSS Tokens`);
		} catch {
			onStatus('無法存取剪貼簿，請從風格示範底部下載 CSS 檔');
		}
	}
	return <KlpButton size="sm" onClick={copyCss}>複製 CSS Tokens</KlpButton>;
}

/** 可切換風格的互動 IDE 範例工作台；設定列與工作台本體嚴格分離，風格與模式獨立切換。 */
export function IdeWorkbench() {
	const { themeId, mode, customVars, setThemeId, setMode } = useLiveStyleBridge('micro-elevation-v1', 'light');
	const embedded = typeof window !== 'undefined' && new URLSearchParams(window.location.search).get('embed') === '1';
	const [leftOpen, setLeftOpen] = useState(true);
	const [rightOpen, setRightOpen] = useState(true);
	const [bottomOpen, setBottomOpen] = useState(false);
	const [previewMode, setPreviewMode] = useState(true);
	const [openTabs, setOpenTabs] = useState<string[]>(['README', '01_核心規格', '02_系統設計', 'bootstrap']);
	const [activeId, setActiveId] = useState('README');
	const [expandedIds, setExpandedIds] = useState<string[]>(['paths', 'current']);
	const [drafts, setDrafts] = useState<Record<string, string>>(() => Object.fromEntries(initialDocs.map(doc => [doc.id, `${doc.calloutTitle}\n${doc.calloutBody}\n\n${doc.body}`])));
	const [searchQuery, setSearchQuery] = useState('');
	const [paletteOpen, setPaletteOpen] = useState(false);
	const [status, setStatus] = useState('就緒 · 可獨立切換風格、模式與工作台區域');
	const [owners, setOwners] = useState<{ registry: KlpCommandRegistry<IdeContext>; keymap: KlpCommandKeymap<IdeContext> } | null>(null);
	const contextRef = useRef<IdeContext>(null!);
	const focusIds = useRef(new WeakMap<EventTarget, string>());
	const focusCounter = useRef(0);

	const activeMeta = themeMetadata.find(item => item.id === themeId) ?? themeMetadata[0];
	const activeDoc = initialDocs.find(doc => doc.id === activeId) ?? initialDocs[0];
	const currentDraft = drafts[activeDoc.id] ?? '';
	const lines = currentDraft.split(/\r?\n/);
	const charCount = currentDraft.length;
	const wordCount = currentDraft.trim() ? currentDraft.trim().split(/\s+/).length : 0;

	const sections = useMemo(() => {
		const filter = searchQuery.trim().toLowerCase();
		const match = (doc: DocFile) => !filter || doc.id.toLowerCase().includes(filter) || doc.title.toLowerCase().includes(filter);
		return [
			{ id: 'paths', label: '路徑', items: initialDocs.filter(doc => doc.folder === 'paths' && match(doc)).map(doc => ({ id: doc.id, label: doc.id })) },
			{ id: 'current', label: '當前目錄', items: initialDocs.filter(doc => doc.folder === 'current' && match(doc)).map(doc => ({ id: doc.id, label: doc.id })) },
		];
	}, [searchQuery]);

	const outlineHeadings = useMemo(() => {
		const custom = lines.filter(line => line.trim().length > 0).slice(0, 5).map((line, index) => `${index + 1}. ${line.slice(0, 22)}${line.length > 22 ? '…' : ''}`);
		return [activeDoc.title, ...custom];
	}, [activeDoc.title, lines]);

	contextRef.current = {
		toggleLeft: () => { setLeftOpen(value => !value); return '已切換左側檔案樹'; },
		toggleRight: () => { setRightOpen(value => !value); return '已切換右側大綱面板'; },
		toggleBottom: () => { setBottomOpen(value => !value); return '已切換底部輸出面板'; },
		cycleTheme: () => {
			const order = themeMetadata.map(item => item.id);
			const next = order[(order.indexOf(themeId) + 1) % order.length];
			const nextMeta = themeMetadata.find(item => item.id === next);
			setThemeId(next);
			return `已切換風格：${nextMeta?.name ?? next}`;
		},
	};

	useEffect(() => {
		const registry = new KlpCommandRegistry<IdeContext>();
		registry.register({ id: 'view.left', label: '切換左側欄', category: '檢視', handler: context => context.toggleLeft() });
		registry.register({ id: 'view.right', label: '切換右側大綱', category: '檢視', handler: context => context.toggleRight() });
		registry.register({ id: 'view.bottom', label: '切換底部終端', category: '檢視', handler: context => context.toggleBottom() });
		registry.register({ id: 'theme.next', label: '切換下一個風格主題', category: '風格', handler: context => context.cycleTheme() });
		const platform = navigator.platform.toLowerCase().includes('mac') ? 'mac' : 'other';
		const keymap = new KlpCommandKeymap(registry, { platform });
		keymap.register({ id: 'palette.open', commandId: 'theme.next', sequence: [{ key: 'k', primary: true, shift: true }], scope: 'app', allowInEditable: true });
		setOwners({ registry, keymap });
		return () => { keymap.dispose(); registry.dispose(); };
	}, []);

	function openFile(id: string) {
		setActiveId(id);
		setOpenTabs(tabs => tabs.includes(id) ? tabs : [...tabs, id]);
	}

	function closeTab(id: string) {
		setOpenTabs(tabs => {
			if (tabs.length <= 1) return tabs;
			const next = tabs.filter(item => item !== id);
			if (activeId === id) setActiveId(next[next.length - 1]);
			return next;
		});
	}

	function getFocus(target: EventTarget | null): KlpShortcutFocus {
		if (target && !focusIds.current.has(target)) focusIds.current.set(target, `ide-focus-${++focusCounter.current}`);
		const element = target instanceof Element ? target : null;
		return { focusId: target ? focusIds.current.get(target)! : 'ide-root', pageId: 'ide', editable: !!element?.closest('input,textarea,[contenteditable="true"]') };
	}

	function handleCommand(result: KlpCommandExecutionResult) {
		if (result.status === 'executed') setStatus(String(result.value ?? '命令已執行'));
	}

	const stylePack = themePacks[themeId];
	const shell = (
		<div className="ide-outer-layout" data-klp-visual-style={activeMeta.family} data-klp-theme-id={activeMeta.id} data-klp-theme-version={activeMeta.version} data-klp-visual-mode={mode}>
			{/* 控制設定區與實際 IDE 工作台範例本體嚴格分離 */}
			<section className="example-controls-bar" aria-label="範例設定">
				{!embedded && (
					<>
						<div className="ide-control-group" role="group" aria-label="切換風格主題">
							<KlpText role="label">風格</KlpText>
							{themeMetadata.map(theme => (
								<KlpButton key={theme.id} size="sm" tone={themeId === theme.id ? 'primary' : 'secondary'} selected={themeId === theme.id} onClick={() => setThemeId(theme.id)}>
									{theme.name}
								</KlpButton>
							))}
						</div>
						<div className="ide-control-group" role="group" aria-label="切換模式">
							<KlpText role="label">模式</KlpText>
							{modes.map(value => (
								<KlpButton key={value} size="sm" selected={mode === value} onClick={() => setMode(value)}>
									{value}
								</KlpButton>
							))}
						</div>
					</>
				)}
				<div className="ide-control-group" role="group" aria-label="工作台面板控制">
					<KlpText role="label">面板</KlpText>
					<KlpButton size="sm" selected={leftOpen} onClick={() => setLeftOpen(value => !value)}>側欄</KlpButton>
					<KlpButton size="sm" selected={rightOpen} onClick={() => setRightOpen(value => !value)}>大綱</KlpButton>
					<KlpButton size="sm" selected={bottomOpen} onClick={() => setBottomOpen(value => !value)}>終端</KlpButton>
					<KlpButton size="sm" onClick={() => setPaletteOpen(true)}>命令面板</KlpButton>
					<IdeCssCopier themeId={themeId} onStatus={setStatus} />
				</div>
			</section>

			<div className="ide-workbench-frame">
				<div className="ide-grid" data-left={leftOpen} data-right={rightOpen}>
					<nav className="ide-activity-rail" aria-label="活動列">
						<KlpIconButton label="切換檔案總管" selected={leftOpen} onClick={() => setLeftOpen(value => !value)}>☰</KlpIconButton>
						<KlpIconButton label="切換編輯或預覽" selected={!previewMode} onClick={() => setPreviewMode(value => !value)}>✎</KlpIconButton>
						<KlpIconButton label="切換大綱面板" selected={rightOpen} onClick={() => setRightOpen(value => !value)}>≡</KlpIconButton>
						<KlpIconButton label="切換終端機" selected={bottomOpen} onClick={() => setBottomOpen(value => !value)}>›_</KlpIconButton>
					</nav>

					{leftOpen && (
						<aside className="ide-panel ide-sidebar" aria-label="檔案總管">
							<div className="ide-panel-header">
								<KlpText role="label">EXPLORER</KlpText>
								<KlpBadge>{activeMeta.name}</KlpBadge>
							</div>
							<div className="ide-sidebar-search">
								<KlpTextField label="篩選檔案" placeholder="搜尋…" value={searchQuery} onChange={event => setSearchQuery(event.target.value)} />
							</div>
							<div className="ide-sidebar-tree">
								<KlpFileExplorer
									label="工作區檔案"
									sections={sections}
									expandedIds={expandedIds}
									selectedId={activeId}
									onSelect={openFile}
									onToggle={id => setExpandedIds(items => items.includes(id) ? items.filter(item => item !== id) : [...items, id])}
								/>
							</div>
						</aside>
					)}

					<section className="ide-panel ide-stage" aria-label="編輯舞台">
						<div className="ide-tabbar" role="tablist" aria-label="開啟的文件">
							{openTabs.map(tabId => (
								<div key={tabId} className="ide-tab" data-active={activeId === tabId}>
									<button type="button" role="tab" aria-selected={activeId === tabId} className="ide-tab-trigger" onClick={() => setActiveId(tabId)}>
										{tabId}
									</button>
									{openTabs.length > 1 && (
										<button type="button" className="ide-tab-close" aria-label={`關閉 ${tabId}`} onClick={() => closeTab(tabId)}>×</button>
									)}
								</div>
							))}
							<div className="ide-tabbar-end">
								<KlpButton size="sm" selected={!previewMode} onClick={() => setPreviewMode(value => !value)}>
									{previewMode ? '編輯原始內容' : '預覽排版'}
								</KlpButton>
							</div>
						</div>

						<div className="ide-breadcrumb">
							<KlpText role="caption" tone="muted">{activeDoc.breadcrumb}</KlpText>
							<KlpBadge tone="info">{activeMeta.surfaceStyle}</KlpBadge>
						</div>

						<div className="ide-editor-scroll">
							{previewMode ? (
								<div className="ide-document-view">
									<h2 className="ide-doc-h1">{activeDoc.title}</h2>
									<div className="ide-doc-callout">
										<span className="ide-callout-accent">{activeDoc.calloutTitle}</span>
										<span> {activeDoc.calloutBody}</span>
									</div>
									<div className="ide-numbered-lines">
										{lines.map((line, index) => (
											<div key={index} className="ide-line-row">
												<span className="ide-line-no" aria-hidden="true">{index + 1}</span>
												<span className="ide-line-text">{line || ' '}</span>
											</div>
										))}
									</div>
									<h3 className="ide-doc-h2">結構與設定摘要</h3>
									<KlpSurface tone="inset" className="ide-code-card">
										<div className="ide-code-head">
											<KlpText role="caption" tone="muted">{activeDoc.id}</KlpText>
											<KlpButton size="sm" onClick={async () => {
												try { await navigator.clipboard.writeText(activeDoc.code); setStatus(`已複製 ${activeDoc.id} 程式片段`); }
												catch { setStatus('請手動選取程式區塊複製'); }
											}}>複製片段</KlpButton>
										</div>
										<pre className="ide-pre"><code>{activeDoc.code}</code></pre>
									</KlpSurface>
								</div>
							) : (
								<div className="ide-raw-editor">
									<label className="ide-raw-label" htmlFor="ide-raw-textarea">編輯 {activeDoc.id} 草稿（切換風格時自動保留）</label>
									<textarea
										id="ide-raw-textarea"
										className="ide-textarea"
										value={currentDraft}
										onChange={event => setDrafts(prev => ({ ...prev, [activeDoc.id]: event.target.value }))}
									/>
								</div>
							)}
						</div>
					</section>

					{rightOpen && (
						<aside className="ide-panel ide-outline" aria-label="文件大綱">
							<div className="ide-panel-header">
								<KlpText role="label">文件大綱</KlpText>
							</div>
							<div className="ide-outline-list">
								{outlineHeadings.map((heading, index) => (
									<button key={index} type="button" className="ide-outline-item" data-primary={index === 0} onClick={() => setStatus(`定位段落：${heading}`)}>
										{heading}
									</button>
								))}
							</div>
						</aside>
					)}
				</div>

				{bottomOpen && (
					<section className="ide-panel ide-bottom-panel" aria-label="終端與輸出">
						<div className="ide-panel-header">
							<KlpText role="label">OUTPUT · {activeMeta.name} ({mode})</KlpText>
							<KlpText role="caption" tone="muted">{activeMeta.typography}</KlpText>
						</div>
						<pre className="ide-pre ide-terminal-log">{`[kallopis] theme=${themeId} mode=${mode} surface=${activeMeta.surfaceStyle}\n[kallopis] ${status}`}</pre>
					</section>
				)}

				<KlpStatusBar className="ide-statusbar">
					<span>{status}</span>
					<span>{wordCount} 個詞 · {charCount} 個字元 · {activeMeta.name} ({activeMeta.id} · v{activeMeta.version}) · {mode}</span>
				</KlpStatusBar>
			</div>

			{owners && (
				<KlpRegisteredCommandPalette
					registry={owners.registry}
					getContext={() => contextRef.current}
					open={paletteOpen}
					label="IDE 命令面板"
					searchLabel="搜尋工作台命令"
					emptyLabel="沒有符合的命令"
					onResult={handleCommand}
					onDismiss={() => setPaletteOpen(false)}
				/>
			)}
		</div>
	);

	return (
		<KlpThemeProvider mode={mode} stylePack={stylePack} style={customVars} className="ide-theme-root">
			{owners ? (
				<KlpCommandShortcutHost
					keymap={owners.keymap}
					getContext={() => contextRef.current}
					getFocus={getFocus}
					onHandling={value => {
						if (value.bindingId) setStatus(`快捷鍵：${value.state} · ${value.bindingId}`);
					}}
					onResult={handleCommand}
				>
					{shell}
				</KlpCommandShortcutHost>
			) : shell}
		</KlpThemeProvider>
	);
}
