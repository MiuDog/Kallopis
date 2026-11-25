import { existsSync, mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const checkOnly = process.argv.includes('--check');
const curatedDir = resolve(root, 'styles/curated');
const targetCuratedDir = resolve(root, 'react/example/curated');
const allowedStatus = new Set(['draft', 'review', 'approved']);

function pascalCase(id) {
	return id.split('-').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join('');
}

function writeOrCheck(relativePath, content) {
	const target = resolve(root, relativePath);
	if (checkOnly) {
		if (!existsSync(target) || readFileSync(target, 'utf8') !== content) {
			throw new Error(`Generated curated output stale: ${relativePath}`);
		}
		return;
	}
	mkdirSync(dirname(target), { recursive: true });
	writeFileSync(target, content);
}

const folders = existsSync(curatedDir)
	? readdirSync(curatedDir, { withFileTypes: true }).filter(entry => entry.isDirectory()).map(entry => entry.name).sort()
	: [];

const approved = [];
for (const folder of folders) {
	const base = resolve(curatedDir, folder);
	const metaPath = resolve(base, 'meta.json');
	if (!existsSync(metaPath)) throw new Error(`Missing meta.json in styles/curated/${folder}`);
	const meta = JSON.parse(readFileSync(metaPath, 'utf8'));
	if (meta.schemaVersion !== 1) throw new Error(`Unsupported curated schemaVersion in ${folder}`);
	if (meta.id !== folder || !/^[a-z0-9-]+$/.test(meta.id)) throw new Error(`Curated id must match kebab-case folder name: ${folder}`);
	if (!allowedStatus.has(meta.status)) throw new Error(`Invalid curated status "${meta.status}" in ${folder}`);
	if (typeof meta.name !== 'string' || !meta.name.trim()) throw new Error(`Missing curated name in ${folder}`);
	if (typeof meta.englishName !== 'string' || !meta.englishName.trim()) throw new Error(`Missing curated englishName in ${folder}`);
	if (typeof meta.recommendedTheme !== 'string' || !meta.recommendedTheme.trim()) throw new Error(`Missing recommendedTheme in ${folder}`);
	if (!meta.inspiration || typeof meta.inspiration.site !== 'string' || typeof meta.inspiration.url !== 'string' || !meta.inspiration.url.startsWith('https://')) {
		throw new Error(`Curated inspiration must include site and https:// url in ${folder}`);
	}
	if (!Array.isArray(meta.tokensUsed) || !meta.tokensUsed.length) throw new Error(`Curated tokensUsed must be non-empty in ${folder}`);

	for (const required of ['component.tsx', 'styles.css', 'snippets/react.tsx', 'snippets/flutter.dart', 'snippets/html.html']) {
		if (!existsSync(resolve(base, required))) throw new Error(`Missing ${required} in styles/curated/${folder}`);
	}
	if (meta.status !== 'approved') continue;

	const componentCode = readFileSync(resolve(base, 'component.tsx'), 'utf8');
	const cssCode = readFileSync(resolve(base, 'styles.css'), 'utf8');
	const snippets = {
		react: readFileSync(resolve(base, 'snippets/react.tsx'), 'utf8'),
		flutter: readFileSync(resolve(base, 'snippets/flutter.dart'), 'utf8'),
		html: readFileSync(resolve(base, 'snippets/html.html'), 'utf8'),
	};
	approved.push({ meta, componentCode, cssCode, snippets });
}

if (!checkOnly) {
	if (existsSync(targetCuratedDir)) {
		for (const existing of readdirSync(targetCuratedDir, { withFileTypes: true })) {
			if (existing.isDirectory() && !approved.some(item => item.meta.id === existing.name)) {
				rmSync(resolve(targetCuratedDir, existing.name), { recursive: true, force: true });
			}
		}
	}
} else if (existsSync(targetCuratedDir)) {
	for (const existing of readdirSync(targetCuratedDir, { withFileTypes: true })) {
		if (existing.isDirectory() && !approved.some(item => item.meta.id === existing.name)) {
			throw new Error(`Orphan curated directory in react/example/curated: ${existing.name}`);
		}
	}
}

for (const item of approved) {
	writeOrCheck(`react/example/curated/${item.meta.id}/component.tsx`, item.componentCode);
	writeOrCheck(`react/example/curated/${item.meta.id}/styles.css`, item.cssCode);
}

const indexOutput = `${JSON.stringify({ schemaVersion: 1, components: approved.map(item => item.meta) }, null, '\t')}\n`;
writeOrCheck('styles/curated/index.json', indexOutput);

const imports = approved.map(item => {
	const symbol = pascalCase(item.meta.id);
	return `import ${symbol} from './curated/${item.meta.id}/component.js';\nimport './curated/${item.meta.id}/styles.css';`;
}).join('\n');

const entries = approved.map(item => {
	const symbol = pascalCase(item.meta.id);
	return `\t{\n\t\tid: ${JSON.stringify(item.meta.id)},\n\t\tmeta: ${JSON.stringify(item.meta)},\n\t\tComponent: ${symbol},\n\t\tsnippets: ${JSON.stringify(item.snippets)},\n\t}`;
}).join(',\n');

const registryTsx = `// 由 styles/scripts/generate-curated.mjs 自動產生，禁止手改。\nimport type { ComponentType } from 'react';\n${imports}\n\nexport interface CuratedComponentEntry {\n\treadonly id: string;\n\treadonly meta: {\n\t\treadonly schemaVersion: number;\n\t\treadonly id: string;\n\t\treadonly name: string;\n\t\treadonly englishName: string;\n\t\treadonly status: string;\n\t\treadonly recommendedTheme: string;\n\t\treadonly summary: string;\n\t\treadonly inspiration: { readonly site: string; readonly url: string; readonly traits: readonly string[] };\n\t\treadonly tokensUsed: readonly string[];\n\t\treadonly props: readonly { readonly name: string; readonly type: string; readonly required: boolean; readonly defaultValue: string | null; readonly description: string }[];\n\t};\n\treadonly Component: ComponentType;\n\treadonly snippets: { readonly react: string; readonly flutter: string; readonly html: string };\n}\n\nexport const curatedComponents: readonly CuratedComponentEntry[] = [\n${entries}\n];\n`;
writeOrCheck('react/example/curated-registry.tsx', registryTsx);

console.log(`Curated components ${checkOnly ? 'verified' : 'generated'}: ${approved.length} approved (${folders.length} total folders)`);
