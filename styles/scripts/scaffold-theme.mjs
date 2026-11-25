import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const args = process.argv.slice(2);

function option(flag, fallback = '') {
	const index = args.indexOf(flag);
	if (index === -1 || index + 1 >= args.length) return fallback;
	return args[index + 1];
}

const family = option('--family');
const major = option('--version', '1');
const name = option('--name');
const englishName = option('--english', family);
const defaultMode = option('--mode', 'light');
const sourceReference = option('--source', 'https://example.com');
const description = option('--description', `${name || family} 風格主題，支援四種標準模式。`);

if (!family || !/^[a-z0-9-]+$/.test(family)) {
	console.error('Usage: node styles/scripts/scaffold-theme.mjs --family <kebab-slug> --name "<中文名稱>" [--english "<English>"] [--version 1] [--mode light|dark] [--source "<https://...>"] [--description "<描述>"]');
	process.exit(1);
}
if (!/^\d+$/.test(major) || Number(major) < 1) {
	console.error(`Invalid major version: ${major}`);
	process.exit(1);
}
if (!name) {
	console.error('Missing required --name "<中文名稱>"');
	process.exit(1);
}
if (!['light', 'dark', 'ultraDark', 'transparent'].includes(defaultMode)) {
	console.error(`Unsupported default mode: ${defaultMode}`);
	process.exit(1);
}

const id = `${family}-v${major}`;
const version = `${major}.0.0`;
const indexPath = resolve(root, 'styles/themes/index.json');
const index = JSON.parse(readFileSync(indexPath, 'utf8'));
if (index.themes.some(theme => theme.id === id)) {
	console.error(`Theme already exists: ${id}`);
	process.exit(1);
}

const packPath = `styles/themes/${id}.json`;
const cssPath = `styles/themes/${id}.css`;
const jsPath = `styles/themes/${id}.js`;
const surfaceCssPath = `styles/themes/${id}.surface.css`;
if (existsSync(resolve(root, packPath))) {
	console.error(`Theme pack file already exists: ${packPath}`);
	process.exit(1);
}

// 由正式基準 pack 建立新版本草稿，確保 350 semantic 與 270 primitive 完整無缺。
const basePack = JSON.parse(readFileSync(resolve(root, 'styles/kallopis-v1.json'), 'utf8'));
basePack.id = id;
basePack.version = version;
writeFileSync(resolve(root, packPath), `${JSON.stringify(basePack, null, '\t')}\n`);

const surfaceTemplate = `/* ${name} (${id}) 專屬表面層次與排版規則（請只使用 --klp-* 語意變數）。 */\n[data-klp-visual-style='${family}'] .ide-panel,\n[data-klp-visual-style='${family}'] .showcase-split-card {\n\tborder-color: var(--klp-colors-border);\n}\n`;
writeFileSync(resolve(root, surfaceCssPath), surfaceTemplate);

index.themes.push({
	id,
	family,
	version,
	name,
	englishName,
	defaultMode,
	description,
	packPath,
	cssPath,
	jsPath,
	surfaceCssPath,
	previewImage: 'styles/images/showcase-home.png',
	sourceReference,
	surfaceStyle: `${family}-surface`,
	elevationStyle: 'custom',
	typography: 'Noto Sans TC · IBM Plex Mono',
	palettePreview: {
		light: ['#E7E4DD', '#EFEDE7', '#F8F6F1', '#21201B', '#D3CFC4'],
		dark: ['#201F1C', '#292724', '#35322D', '#F0EDE6', '#514B40'],
	},
});
writeFileSync(indexPath, `${JSON.stringify(index, null, '\t')}\n`);

console.log(`Scaffolded theme ${id} (v${version}):\n- ${packPath}\n- ${surfaceCssPath}\nNext: edit colors/primitives/surface CSS, then run: node styles/scripts/generate-themes.mjs`);
