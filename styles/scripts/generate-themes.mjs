import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { basename, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { resolveStylePack } from '../src/index.mjs';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const checkOnly = process.argv.includes('--check');
const modes = ['light', 'dark', 'ultraDark', 'transparent'];
const catalog = JSON.parse(readFileSync(resolve(root, 'styles/catalog.json'), 'utf8'));
const registry = JSON.parse(readFileSync(resolve(root, 'styles/themes/index.json'), 'utf8'));

// 轉換 common ARGB 與 package 字型名稱為跨瀏覽器 CSS 表示法。
function browserValue(value) {
	if (Array.isArray(value)) return value.map(browserValue);
	if (typeof value !== 'string') return value;
	if (/^#[\dA-Fa-f]{8}$/.test(value)) return `#${value.slice(3)}${value.slice(1, 3)}`.toUpperCase();
	return value.replace(/^packages\/kallopis\//, '');
}

function cssVariable(id) {
	return `--klp-${id.replace(/^theme\./, '').replaceAll('.', '-')}`;
}

function cssValue(id, value) {
	const converted = browserValue(value);
	if (Array.isArray(converted)) {
		return converted.map(entry => typeof entry === 'string' && !['serif', 'sans-serif', 'monospace'].includes(entry) ? JSON.stringify(entry) : entry).join(', ');
	}
	if (typeof converted === 'number' && /(?:spacing|shape|geometry|components)\./.test(id) && !/(?:Opacity|Factor|Lines|Ratio|BaselineOffsetY)/.test(id)) {
		return `${converted}px`;
	}
	return String(converted);
}

function semanticCategory(label) {
	if (['app', 'surface', 'surfaceInset', 'surfaceMuted', 'component', 'stageSurface', 'overlay', 'surfaceRaised', 'modalScrim', 'transparent'].includes(label)) {
		return 'surfaces';
	}
	if (['text', 'textMuted', 'textFaint', 'onStatus', 'onLightBackground', 'onDarkBackground', 'mutedOnLightBackground', 'mutedOnDarkBackground', 'faintOnBackground'].includes(label)) {
		return 'text';
	}
	if (['guide', 'divider', 'pagePattern', 'border', 'borderStrong'].includes(label)) {
		return 'borders';
	}
	if (['brand', 'accent', 'accentSoft', 'interaction', 'interactionSoft'].includes(label)) {
		return 'brand';
	}
	return 'status';
}

const semanticGroupDefs = [
	['surfaces', '表面與背景（Surfaces）'],
	['text', '文字與反白（Text）'],
	['borders', '邊框與分隔（Borders）'],
	['brand', '品牌與互動（Brand & Interaction）'],
	['status', '狀態語意（Status）'],
];

function primitiveCategory(id) {
	if (id.startsWith('parchment')) return 'parchment';
	if (id.startsWith('ink') || id === 'transparent' || id === 'scrim' || id === 'line') return 'ink';
	if (id.startsWith('warmNeutral')) return 'warmNeutral';
	if (/^(sand|gold|ochre|terracotta|clay|umber)/.test(id)) return 'warmEarth';
	if (/^(green|red|amber|blue)/.test(id)) return 'status';
	if (/^(meDark|meLight|meTrans|mmLight|mmDark|mmTrans|mmSuccess|mmWarning|mmDanger|mmInfo)/.test(id)) return 'themeCustom';
	return 'other';
}

const primitiveGroupDefs = [
	['parchment', '暖紙階調（Parchment）'],
	['ink', '墨色與遮罩（Ink & Scrim）'],
	['warmNeutral', '暖中性灰（Warm Neutral）'],
	['warmEarth', '大地暖色系（Sand / Gold / Ochre / Clay）'],
	['status', '標準狀態色（Status）'],
	['themeCustom', '風格專用色票（Theme Custom）'],
	['other', '其他色票（Other）'],
];

function writeOrCheck(relativePath, content) {
	const target = resolve(root, relativePath);
	if (checkOnly) {
		const existing = readFileSync(target, 'utf8');
		if (existing !== content) throw new Error(`Generated theme output stale: ${relativePath}`);
		return;
	}
	mkdirSync(dirname(target), { recursive: true });
	writeFileSync(target, content);
}

const presetPacks = {};
const themeCssBlocks = [];
const surfaceCssParts = ['/* 由 styles/scripts/generate-themes.mjs 自動聚合所有主題表面樣式，禁止手改。 */\n'];
const swatchesByTheme = {};

for (const theme of registry.themes) {
	// 強制檢查每個 style 都採用版本化命名（<family>-v<N>），並與主檔及產物檔名一致。
	if (!/^[a-z0-9-]+-v\d+$/.test(theme.id)) throw new Error(`Theme ID must be versioned (<family>-v<N>): ${theme.id}`);
	if (typeof theme.family !== 'string' || !theme.family) throw new Error(`Theme missing family: ${theme.id}`);
	if (typeof theme.version !== 'string' || !theme.version) throw new Error(`Theme missing version: ${theme.id}`);
	if (basename(theme.packPath) !== `${theme.id}.json`) throw new Error(`Theme packPath must match versioned ID ${theme.id}: ${theme.packPath}`);
	if (basename(theme.cssPath) !== `${theme.id}.css`) throw new Error(`Theme cssPath must match versioned ID ${theme.id}: ${theme.cssPath}`);
	if (typeof theme.jsPath !== 'string' || basename(theme.jsPath) !== `${theme.id}.js`) throw new Error(`Theme jsPath must match versioned ID ${theme.id}: ${theme.jsPath}`);
	if (typeof theme.surfaceCssPath !== 'string' || basename(theme.surfaceCssPath) !== `${theme.id}.surface.css`) throw new Error(`Theme surfaceCssPath must match versioned ID ${theme.id}: ${theme.surfaceCssPath}`);
	if (!existsSync(resolve(root, theme.surfaceCssPath))) throw new Error(`Missing surface CSS file: ${theme.surfaceCssPath}`);

	const pack = JSON.parse(readFileSync(resolve(root, theme.packPath), 'utf8'));
	if (pack.id !== theme.id) throw new Error(`Pack id mismatch for ${theme.packPath}: expected ${theme.id}, got ${pack.id}`);
	if (pack.version !== theme.version) throw new Error(`Pack version mismatch for ${theme.packPath}: expected ${theme.version}, got ${pack.version}`);

	const surfaceCss = readFileSync(resolve(root, theme.surfaceCssPath), 'utf8').trim();
	surfaceCssParts.push(`${surfaceCss}\n`);

	presetPacks[theme.id] = pack;
	const resolvedByMode = {};
	const cssVarsByMode = {};
	const semanticSwatchesByMode = {};
	const semanticGroupsByMode = {};
	const modeCss = modes.map(mode => {
		const { tokens } = resolveStylePack(pack, mode, catalog);
		resolvedByMode[mode] = Object.fromEntries(Object.entries(tokens).map(([id, value]) => [id, browserValue(value)]));
		cssVarsByMode[mode] = Object.fromEntries(Object.entries(tokens).map(([id, value]) => [cssVariable(id), cssValue(id, value)]));
		const entries = Object.entries(tokens)
			.filter(([id]) => id.startsWith('theme.colors.'))
			.map(([id, value]) => ({
				id,
				label: id.slice('theme.colors.'.length),
				cssVar: cssVariable(id),
				hex: browserValue(value),
				description: pack.semanticDescriptions?.[id]?.replace(/<br>/g, ' · ') ?? '',
			}));
		semanticSwatchesByMode[mode] = entries;
		semanticGroupsByMode[mode] = semanticGroupDefs.map(([groupId, title]) => ({
			id: groupId,
			title,
			items: entries.filter(item => semanticCategory(item.label) === groupId),
		})).filter(group => group.items.length);

		const lines = Object.entries(tokens).map(([id, value]) => `\t${cssVariable(id)}: ${cssValue(id, value)};`).join('\n');
		return `[data-klp-theme="${theme.id}"][data-klp-mode="${mode}"] {\n${lines}\n}`;
	}).join('\n');

	const primitiveColors = Object.entries(pack.primitives)
		.filter(([, value]) => typeof value === 'string' && /^#[\dA-Fa-f]{6,8}$/.test(value))
		.map(([id, value]) => ({
			id,
			hex: browserValue(value),
			description: pack.primitiveDescriptions?.[id] ?? '',
		}));
	const primitiveGroups = primitiveGroupDefs.map(([groupId, title]) => ({
		id: groupId,
		title,
		items: primitiveColors.filter(item => primitiveCategory(item.id) === groupId),
	})).filter(group => group.items.length);

	swatchesByTheme[theme.id] = {
		id: theme.id,
		family: theme.family,
		version: theme.version,
		name: theme.name,
		semanticColors: semanticSwatchesByMode,
		semanticGroups: semanticGroupsByMode,
		primitiveColors,
		primitiveGroups,
	};

	// 以 light 作為中性 :root 基準，不將任何風格綁死為預設深色。
	const baseLightTokens = resolveStylePack(pack, 'light', catalog).tokens;
	const standaloneCss = `/* Kallopis Theme: ${theme.name} (${theme.id} · v${theme.version}) · 可直接複製並即時調整 */\n/* 來源權威：${theme.packPath} 與 ${theme.surfaceCssPath} */\n:root,\n[data-klp-mode="light"] {\n${Object.entries(baseLightTokens).map(([id, value]) => `\t${cssVariable(id)}: ${cssValue(id, value)};`).join('\n')}\n}\n${modes.map(mode => {
		const { tokens } = resolveStylePack(pack, mode, catalog);
		return `[data-klp-mode="${mode}"] {\n${Object.entries(tokens).map(([id, value]) => `\t${cssVariable(id)}: ${cssValue(id, value)};`).join('\n')}\n}`;
	}).join('\n')}\n\n${surfaceCss}\n`;
	writeOrCheck(theme.cssPath, standaloneCss);

	const standaloneJs = `// Kallopis Theme Module: ${theme.name} (${theme.id} · v${theme.version})\n// 來源權威：${theme.packPath} · 風格與明暗模式為獨立狀態。\nexport const themeMeta = Object.freeze(${JSON.stringify({ id: theme.id, family: theme.family, version: theme.version, name: theme.name, englishName: theme.englishName })});\nexport const primitives = Object.freeze(${JSON.stringify(Object.fromEntries(Object.entries(pack.primitives).map(([k, v]) => [k, browserValue(v)])), null, '\t')});\nexport const tokens = Object.freeze(${JSON.stringify(resolvedByMode, null, '\t')});\nexport const cssVariables = Object.freeze(${JSON.stringify(cssVarsByMode, null, '\t')});\nexport function applyKlpTheme(mode = 'light', target = typeof document !== 'undefined' ? document.documentElement : null) {\n\tconst vars = cssVariables[mode];\n\tif (!vars) throw new Error(\`Unknown Kallopis mode: \${mode}\`);\n\tif (target?.style) {\n\t\tfor (const [name, value] of Object.entries(vars)) target.style.setProperty(name, value);\n\t\tif (target.dataset) { target.dataset.klpTheme = themeMeta.id; target.dataset.klpVisualStyle = themeMeta.family; target.dataset.klpMode = mode; }\n\t}\n\treturn vars;\n}\n`;
	writeOrCheck(theme.jsPath, standaloneJs);

	themeCssBlocks.push(modeCss);
}

writeOrCheck('styles/themes/swatches.json', `${JSON.stringify({ schemaVersion: 1, themes: swatchesByTheme }, null, '\t')}\n`);
writeOrCheck('react/example/theme-surfaces.css', surfaceCssParts.join('\n'));

// 生成 React 範例共用的風格套件資料，確保元件展示與風格檔同源。
const presetsModule = `// 由 styles/scripts/generate-themes.mjs 自動產生，禁止手改。\nexport const themeMetadata = Object.freeze(${JSON.stringify(registry.themes, null, '\t')});\nexport const themePacks = Object.freeze(${JSON.stringify(presetPacks, null, '\t')});\n`;
const presetsDeclaration = `import type { KlpMode, KlpStylePack } from '@kallopis/react';\nexport interface ThemeMetadataEntry {\n\treadonly id: string;\n\treadonly family: string;\n\treadonly version: string;\n\treadonly name: string;\n\treadonly englishName: string;\n\treadonly defaultMode: KlpMode;\n\treadonly description: string;\n\treadonly packPath: string;\n\treadonly cssPath: string;\n\treadonly jsPath: string;\n\treadonly surfaceCssPath: string;\n\treadonly previewImage: string;\n\treadonly sourceReference: string;\n\treadonly surfaceStyle: string;\n\treadonly elevationStyle: string;\n\treadonly typography: string;\n\treadonly orbs?: readonly string[];\n\treadonly palettePreview: Readonly<Record<'light' | 'dark', readonly string[]>>;\n}\nexport declare const themeMetadata: readonly ThemeMetadataEntry[];\nexport declare const themePacks: Readonly<Record<string, KlpStylePack>>;\n`;
writeOrCheck('react/example/theme-presets.mjs', presetsModule);
writeOrCheck('react/example/theme-presets.d.mts', presetsDeclaration);

// 生成無相依性的可複製互動 IDE 工作台範例：控制設定列與範例本體明確分離，風格與模式為獨立狀態。
const defaultThemeId = registry.themes[0].id;
const ideHtml = `<!doctype html>
<html lang="zh-Hant" data-klp-theme="${defaultThemeId}" data-klp-mode="light">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Kallopis 互動 IDE 工作台 · 獨立可複製範例</title>
<style>
${themeCssBlocks.join('\n')}
* { box-sizing: border-box; }
body {
	margin: 0;
	min-height: 100vh;
	padding: 12px;
	display: grid;
	grid-template-rows: auto 1fr;
	gap: 12px;
	background: var(--klp-colors-app);
	color: var(--klp-colors-text);
	font-family: var(--klp-typography-uiFamily), var(--klp-typography-sansFallback);
	font-size: 14px;
	line-height: 1.6;
}
.ide-controls-bar {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	justify-content: space-between;
	gap: 8px;
	padding: 10px 14px;
	background: var(--klp-colors-surfaceRaised);
	border: 1px dashed var(--klp-colors-borderStrong);
	border-radius: var(--klp-shape-panel);
}
.ide-group { display: flex; flex-wrap: wrap; align-items: center; gap: 6px; }
.ide-btn {
	padding: 5px 10px;
	border: 1px solid var(--klp-colors-border);
	border-radius: var(--klp-shape-control);
	background: var(--klp-colors-component);
	color: var(--klp-colors-text);
	font: inherit;
	font-size: 13px;
	cursor: pointer;
}
.ide-btn:hover { background: var(--klp-colors-interactionSoft); }
.ide-btn[aria-pressed="true"] {
	background: var(--klp-colors-brand);
	color: var(--klp-colors-text);
	border-color: var(--klp-colors-borderStrong);
	font-weight: 600;
}
[data-klp-theme^="modern-minimal-v"] .ide-btn[aria-pressed="true"] {
	color: var(--klp-colors-onDarkBackground);
}
[data-klp-theme^="modern-minimal-v"][data-klp-mode="dark"] .ide-btn[aria-pressed="true"] {
	color: var(--klp-colors-onLightBackground);
}
.ide-shell {
	display: grid;
	grid-template-rows: 1fr auto;
	min-height: 0;
	gap: 8px;
}
.ide-body {
	display: grid;
	grid-template-columns: 240px minmax(0, 1fr) 220px;
	gap: 8px;
	min-height: 0;
}
.ide-panel {
	display: flex;
	flex-direction: column;
	background: var(--klp-colors-surface);
	border: 1px solid var(--klp-colors-border);
	border-radius: var(--klp-shape-panel);
	overflow: hidden;
	min-height: 0;
}
.ide-stage { background: var(--klp-colors-stageSurface); }
[data-klp-theme^="micro-elevation-v"] .ide-panel {
	box-shadow: 0 4px 14px rgba(0, 0, 0, 0.24), inset 0 1px 0 rgba(255, 255, 255, 0.05);
}
[data-klp-theme^="micro-elevation-v"][data-klp-mode="light"] .ide-panel {
	box-shadow: 0 3px 10px rgba(0, 0, 0, 0.06), inset 0 1px 0 rgba(255, 255, 255, 0.8);
}
.ide-panel-head {
	padding: 10px 14px;
	border-bottom: 1px solid var(--klp-colors-border);
	font-size: 12px;
	font-weight: 600;
	color: var(--klp-colors-textMuted);
}
.ide-tree { padding: 8px; overflow: auto; display: grid; gap: 2px; }
.ide-tree button {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	text-align: left;
	padding: 6px 10px;
	border: 0;
	border-radius: var(--klp-shape-control);
	background: transparent;
	color: var(--klp-colors-textMuted);
	font: inherit;
	font-size: 13px;
	cursor: pointer;
}
.ide-tree button:hover, .ide-tree button[aria-current="page"] {
	background: var(--klp-colors-interactionSoft);
	color: var(--klp-colors-text);
}
.ide-tabs {
	display: flex;
	gap: 4px;
	padding: 6px 8px;
	border-bottom: 1px solid var(--klp-colors-border);
	background: var(--klp-colors-surface);
}
.ide-editor { flex: 1; padding: 20px 28px; overflow: auto; }
.ide-editor h1 { margin: 0 0 16px; font-size: 28px; line-height: 1.3; }
[data-klp-theme^="modern-minimal-v"] .ide-editor h1 {
	font-family: "EB Garamond", Georgia, serif;
	font-weight: 400;
	font-size: 34px;
}
.ide-callout {
	margin: 12px 0;
	padding: 10px 14px;
	border-radius: var(--klp-shape-control);
	background: var(--klp-colors-accentSoft);
	border-left: 3px solid var(--klp-colors-accent);
}
.ide-code {
	margin-top: 16px;
	padding: 14px;
	border-radius: var(--klp-shape-card);
	background: var(--klp-colors-surfaceInset);
	border: 1px solid var(--klp-colors-border);
	font-family: var(--klp-typography-codeFamily), var(--klp-typography-monoFallback);
	font-size: 12.5px;
	white-space: pre-wrap;
}
.ide-status {
	display: flex;
	justify-content: space-between;
	padding: 6px 12px;
	background: var(--klp-colors-surface);
	border: 1px solid var(--klp-colors-border);
	border-radius: var(--klp-shape-control);
	font-size: 12px;
	color: var(--klp-colors-textMuted);
}
@media (max-width: 820px) { .ide-body { grid-template-columns: 1fr; } }
</style>
</head>
<body>
<section class="ide-controls-bar" aria-label="獨立展示設定（與範例本體分離）">
	<div class="ide-group" role="group" aria-label="風格主題">
		${registry.themes.map(theme => `<button class="ide-btn" data-set-theme="${theme.id}" aria-pressed="${theme.id === defaultThemeId}">${theme.name} (${theme.id})</button>`).join('')}
	</div>
	<div class="ide-group" role="group" aria-label="明暗模式">
		${modes.map(mode => `<button class="ide-btn" data-set-mode="${mode}" aria-pressed="${mode === 'light'}">${mode}</button>`).join('')}
	</div>
</section>
<div class="ide-shell">
	<div class="ide-body">
		<aside class="ide-panel" aria-label="檔案總管">
			<div class="ide-panel-head">當前目錄</div>
			<div class="ide-tree" id="files"></div>
		</aside>
		<main class="ide-panel ide-stage" aria-label="編輯區">
			<div class="ide-tabs" id="tabs"></div>
			<div class="ide-editor">
				<h1 id="doc-title">README</h1>
				<div class="ide-callout"><strong id="doc-highlight">開發 Agent 交接入口</strong> · 布局與風格分離，所有顏色與圓角來自 <code>--klp-*</code> tokens。</div>
				<p id="doc-body"></p>
				<pre class="ide-code" id="doc-code"></pre>
			</div>
		</main>
		<aside class="ide-panel" aria-label="文件大綱">
			<div class="ide-panel-head">文件大綱</div>
			<div class="ide-tree" id="outline"></div>
		</aside>
	</div>
	<footer class="ide-status">
		<span id="status-left">主題：${defaultThemeId} · 模式：light</span>
		<span>Kallopis Portable IDE Sample</span>
	</footer>
</div>
<script>
const files = [
	{ id: 'README', title: 'Kallopis 專案主索引', highlight: '開發 Agent 交接入口', body: '只需從 styles/themes/ 複製對應版本的 CSS token 檔案，即可在任何框架重現一致的微立體或現代簡約風視覺。', code: ':root {\\n\\t--klp-colors-app: var(--klp-colors-app);\\n\\t--klp-colors-stageSurface: var(--klp-colors-stageSurface);\\n}', outline: ['專案主索引', '風格與布局分離', 'Token 複製流程'] },
	{ id: 'theme', title: '風格主題與語意對照', highlight: '單一權威風格來源', body: '微立體採用溫潤炭灰多層抬升與琥珀金點綴；現代簡約風採用 #F5F5F5 畫布與 #292524 暖炭墨黑細線。', code: '<html data-klp-theme="modern-minimal-v1" data-klp-mode="light">', outline: ['微立體', '現代簡約風', '四種模式解析'] }
];
let active = 'README';
function render() {
	const item = files.find(entry => entry.id === active);
	document.getElementById('files').innerHTML = files.map(entry => '<button data-file="' + entry.id + '" aria-current="' + (entry.id === active ? 'page' : 'false') + '">' + entry.id + '</button>').join('');
	document.getElementById('tabs').innerHTML = files.map(entry => '<button class="ide-btn" data-file="' + entry.id + '" aria-pressed="' + (entry.id === active) + '">' + entry.id + '</button>').join('');
	document.getElementById('doc-title').textContent = item.title;
	document.getElementById('doc-highlight').textContent = item.highlight;
	document.getElementById('doc-body').textContent = item.body;
	document.getElementById('doc-code').textContent = item.code;
	document.getElementById('outline').innerHTML = item.outline.map(heading => '<button type="button">' + heading + '</button>').join('');
	document.getElementById('status-left').textContent = '主題：' + document.documentElement.dataset.klpTheme + ' · 模式：' + document.documentElement.dataset.klpMode;
	for (const button of document.querySelectorAll('[data-file]')) button.onclick = () => { active = button.dataset.file; render(); };
}
for (const button of document.querySelectorAll('[data-set-theme]')) {
	button.onclick = () => {
		document.documentElement.dataset.klpTheme = button.dataset.setTheme;
		for (const item of document.querySelectorAll('[data-set-theme]')) item.setAttribute('aria-pressed', String(item === button));
		render();
	};
}
for (const button of document.querySelectorAll('[data-set-mode]')) {
	button.onclick = () => {
		document.documentElement.dataset.klpMode = button.dataset.setMode;
		for (const item of document.querySelectorAll('[data-set-mode]')) item.setAttribute('aria-pressed', String(item === button));
		render();
	};
}
render();
</script>
</body>
</html>
`;
writeOrCheck('styles/examples/ide-workbench/index.html', ideHtml);

console.log(`Themes ${checkOnly ? 'verified' : 'generated'}: ${registry.themes.map(theme => `${theme.id}@${theme.version}`).join(', ')}`);
