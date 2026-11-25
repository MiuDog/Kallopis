import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const args = process.argv.slice(2);

function option(flag, fallback = '') {
	const index = args.indexOf(flag);
	if (index === -1 || index + 1 >= args.length) return fallback;
	return args[index + 1];
}

const id = option('--id');
const name = option('--name');
const englishName = option('--english', id);
const recommendedTheme = option('--theme', 'micro-elevation-v1');
const site = option('--site', 'External Design Case');
const url = option('--url', 'https://example.com');
const summary = option('--summary', `${name || id} 精選互動元件，所有視覺參數均讀取 --klp-* 語意。`);

if (!id || !/^[a-z0-9-]+$/.test(id) || !name || !url.startsWith('https://')) {
	console.error('Usage: node styles/scripts/scaffold-curated.mjs --id <kebab-slug> --name "<中文名稱>" [--english "<English>"] [--theme micro-elevation-v1] --site "<參考網站名稱>" --url "<https://...>"');
	process.exit(1);
}

const dir = resolve(root, 'styles/curated', id);
if (existsSync(dir)) {
	console.error(`Curated component directory already exists: styles/curated/${id}`);
	process.exit(1);
}

const symbol = id.split('-').map(part => part.charAt(0).toUpperCase() + part.slice(1)).join('');

const files = {
	'meta.json': `${JSON.stringify({
		schemaVersion: 1,
		id,
		name,
		englishName,
		status: 'draft',
		recommendedTheme,
		summary,
		inspiration: { site, url, traits: ['待補充視覺特徵'] },
		tokensUsed: ['theme.colors.component', 'theme.colors.border', 'theme.colors.text', 'theme.shape.card'],
		props: [],
	}, null, '\t')}\n`,
	'component.tsx': `import { useState } from 'react';\nimport { KlpButton, KlpSurface, KlpText } from '@kallopis/react';\n\n/** ${name}：人為核准後再將 meta.json status 改為 approved 並執行 generate-curated.mjs。 */\nexport default function ${symbol}() {\n\tconst [active, setActive] = useState(false);\n\treturn (\n\t\t<KlpSurface tone="component" className="klp-curated-${id}">\n\t\t\t<KlpText role="body-strong">${name}</KlpText>\n\t\t\t<KlpButton size="sm" selected={active} onClick={() => setActive(value => !value)}>\n\t\t\t\t{active ? '已啟用' : '切換狀態'}\n\t\t\t</KlpButton>\n\t\t</KlpSurface>\n\t);\n}\n`,
	'styles.css': `.klp-curated-${id} {\n\tdisplay: grid;\n\tgap: var(--klp-spacing-tight);\n\tpadding: var(--klp-spacing-contentInset);\n\tborder: 1px solid var(--klp-colors-border);\n\tborder-radius: var(--klp-shape-card);\n}\n`,
	'snippets/react.tsx': `import { KlpThemeProvider } from '@kallopis/react';\nimport ${symbol} from './component';\nimport '@kallopis/react/styles.css';\nimport './styles.css';\n\nexport function Example() {\n\treturn <KlpThemeProvider mode="dark"><${symbol} /></KlpThemeProvider>;\n}\n`,
	'snippets/flutter.dart': `import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n// 依 ${recommendedTheme} 語意實作 ${symbol}\nclass ${symbol} extends StatelessWidget {\n\tconst ${symbol}({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\tfinal klp = context.klp;\n\t\treturn Container(\n\t\t\tpadding: EdgeInsets.all(klp.spacing.contentInset),\n\t\t\tdecoration: BoxDecoration(\n\t\t\t\tcolor: klp.colors.component,\n\t\t\t\tborderRadius: BorderRadius.circular(klp.shape.card),\n\t\t\t\tborder: Border.all(color: klp.colors.border),\n\t\t\t),\n\t\t\tchild: Text('${name}', style: TextStyle(color: klp.colors.text)),\n\t\t);\n\t}\n}\n`,
	'snippets/html.html': `<link rel="stylesheet" href="./styles/themes/${recommendedTheme}.css">\n<div style="padding:12px;background:var(--klp-colors-component);border:1px solid var(--klp-colors-border);border-radius:var(--klp-shape-card);color:var(--klp-colors-text)">\n\t${name}\n</div>\n`,
};

for (const [rel, content] of Object.entries(files)) {
	const target = resolve(dir, rel);
	mkdirSync(dirname(target), { recursive: true });
	writeFileSync(target, content);
}
console.log(`Scaffolded draft curated component at styles/curated/${id}/\nStatus is "draft". After human review & approval, set status to "approved" and run: node styles/scripts/generate-curated.mjs`);
