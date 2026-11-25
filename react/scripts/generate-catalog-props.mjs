import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { extractReactApi } from '../../tool/reference_site/extract-react-api.mjs';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const checkOnly = process.argv.includes('--check');
const declarations = await extractReactApi(root);
const bindings = JSON.parse(readFileSync(resolve(root, 'styles/component-bindings.json'), 'utf8')).bindings;
const apiManifest = JSON.parse(readFileSync(resolve(root, 'tool/reference_site/reference-api.json'), 'utf8'));
const flutterNames = new Set(apiManifest.modules.flatMap(module => module.declarations.map(item => item.name)));

// React 公開元件對應 Flutter 公開型別名稱（若同名則直接使用）。
const flutterAliases = {
	KlpFrame: 'KlpPanelFrame',
	KlpSwitch: 'KlpCompactSwitch',
	KlpThemeProvider: 'KlpTheme',
	KlpWorkspace: 'KlpTwoPaneWorkspace',
	KlpSeparator: 'KlpDivider',
	KlpLayoutRow: 'Row',
	KlpLayoutColumn: 'Column',
	KlpLayoutSpacer: 'Spacer',
	KlpAlert: 'KlpSurface',
	KlpLink: 'KlpButton',
	KlpList: 'KlpFileExplorer',
	KlpTable: 'KlpTree',
	KlpDataGrid: 'KlpTree',
	KlpComboBox: 'KlpTextField',
	KlpMultiSelect: 'KlpFilterChip',
	KlpSkeleton: 'KlpSurface',
	KlpSpinner: 'KlpProgressBar',
	KlpToastRegion: 'KlpSurface',
};

// 依據元件來源檔與 CSS 類別關聯收集對應的 semantic token 與 CSS 變數。
function tokensForComponent(component) {
	const direct = [];
	for (const binding of bindings) {
		const hit = binding.references.some(reference => reference.path === component.source);
		if (hit) direct.push({ id: binding.id, css: binding.css, flutter: binding.flutter });
	}
	if (direct.length) return direct.slice(0, 16);
	return bindings
		.filter(binding => ['theme.colors.app', 'theme.colors.surface', 'theme.colors.component', 'theme.colors.text', 'theme.colors.border', 'theme.colors.brand', 'theme.shape.control', 'theme.shape.card'].includes(binding.id))
		.map(binding => ({ id: binding.id, css: binding.css, flutter: binding.flutter }));
}

function buildReactSnippet(name, props) {
	const sampleProps = [];
	for (const prop of props.slice(0, 4)) {
		if (prop.name === 'children' || prop.name === 'className' || prop.name === 'style') continue;
		if (prop.name === 'label') sampleProps.push('label="工作區項目"');
		else if (prop.name === 'title') sampleProps.push('title="系統標題"');
		else if (prop.name === 'value') sampleProps.push('value={value}');
		else if (prop.name === 'checked') sampleProps.push('checked={checked}');
		else if (prop.name === 'selected') sampleProps.push('selected={selected}');
		else if (prop.name === 'open') sampleProps.push('open={open}');
		else if (prop.name === 'tone') sampleProps.push('tone="primary"');
		else if (prop.name === 'size') sampleProps.push('size="md"');
		else if (prop.name === 'onClick') sampleProps.push('onClick={() => handleAction()}');
		else if (prop.name === 'onChange') sampleProps.push('onChange={event => setValue(event.target.value)}');
		else if (prop.required && prop.type.includes('string')) sampleProps.push(`${prop.name}="範例"`);
	}
	const attrText = sampleProps.length ? ` ${sampleProps.join(' ')}` : '';
	const hasChildren = props.some(prop => prop.name === 'children') || ['KlpButton', 'KlpText', 'KlpCard', 'KlpSurface', 'KlpBadge', 'KlpFrame', 'KlpWorkspace', 'KlpThemeProvider', 'KlpStatusBar', 'KlpLink'].includes(name);
	const jsx = hasChildren ? `<${name}${attrText}>範例內容</${name}>` : `<${name}${attrText} />`;
	return `import { KlpThemeProvider, ${name} } from '@kallopis/react';\nimport '@kallopis/react/styles.css';\n\nexport function Example() {\n\treturn (\n\t\t<KlpThemeProvider mode="dark">\n\t\t\t${jsx}\n\t\t</KlpThemeProvider>\n\t);\n}`;
}

function buildFlutterSnippet(name) {
	const flutterSymbol = flutterNames.has(name) ? name : (flutterAliases[name] ?? name);
	const note = flutterNames.has(name)
		? `// 使用 Kallopis Flutter 公開元件 ${flutterSymbol}`
		: flutterAliases[name]
			? `// Flutter 端對應 ${flutterSymbol}（或以 KlpTheme.of(context) 組合）`
			: `// 透過 KlpTheme.of(context) 讀取共用 semantic tokens`;
	if (flutterSymbol === 'KlpTheme') {
		return `import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n${note}\nKlpTheme(\n\tdata: KlpThemeData.dark(),\n\tchild: Builder(\n\t\tbuilder: (context) {\n\t\t\tfinal klp = context.klp;\n\t\t\treturn ColoredBox(color: klp.colors.app);\n\t\t},\n\t),\n)`;
	}
	return `import 'package:flutter/widgets.dart';\nimport 'package:kallopis/kallopis_foundation.dart';\nimport 'package:kallopis/kallopis_theme.dart';\n\n${note}\nclass Example extends StatelessWidget {\n\tconst Example({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn ${flutterSymbol}(\n\t\t\t// 樣式由 context.klp 自動解析\n\t\t);\n\t}\n}`;
}

function buildHtmlSnippet(name, tokens) {
	const bg = tokens.find(t => t.id.includes('component') || t.id.includes('surface'))?.css ?? '--klp-colors-component';
	const fg = tokens.find(t => t.id.includes('text'))?.css ?? '--klp-colors-text';
	const border = tokens.find(t => t.id.includes('border'))?.css ?? '--klp-colors-border';
	const radius = tokens.find(t => t.id.includes('shape') || t.id.includes('Radius'))?.css ?? '--klp-shape-control';
	return `<!-- 直接引入 styles/themes/micro-elevation-v1.css（免匯入元件庫） -->\n<link rel="stylesheet" href="./styles/themes/micro-elevation-v1.css">\n\n<div class="my-${name.toLowerCase()}" style="\n\tbackground: var(${bg});\n\tcolor: var(${fg});\n\tborder: 1px solid var(${border});\n\tborder-radius: var(${radius});\n\tpadding: var(--klp-spacing-contentInset);\n">\n\t${name} 範例內容\n</div>`;
}

const entries = {};
for (const declaration of declarations) {
	if (!declaration.renderable) continue;
	const props = declaration.parameters.map(parameter => ({
		name: parameter.name,
		type: parameter.type,
		required: parameter.required,
		defaultValue: parameter.defaultValue,
		documentation: parameter.documentation,
	}));
	const tokens = tokensForComponent(declaration);
	entries[declaration.name] = {
		name: declaration.name,
		id: declaration.id,
		source: declaration.source,
		signature: declaration.signature,
		documentation: declaration.documentation,
		props,
		tokens,
		snippets: {
			react: buildReactSnippet(declaration.name, props),
			flutter: buildFlutterSnippet(declaration.name),
			html: buildHtmlSnippet(declaration.name, tokens),
		},
	};
}

const moduleContent = `// 由 react/scripts/generate-catalog-props.mjs 自動產生，禁止手改。\nexport const catalogProps = Object.freeze(${JSON.stringify(entries, null, '\t')});\n`;
const declarationContent = `export interface CatalogPropEntry {\n\treadonly name: string;\n\treadonly type: string;\n\treadonly required: boolean;\n\treadonly defaultValue: string | null;\n\treadonly documentation: string;\n}\nexport interface CatalogTokenBinding {\n\treadonly id: string;\n\treadonly css: string;\n\treadonly flutter: string;\n}\nexport interface CatalogSnippets {\n\treadonly react: string;\n\treadonly flutter: string;\n\treadonly html: string;\n}\nexport interface CatalogComponentMeta {\n\treadonly name: string;\n\treadonly id: string;\n\treadonly source: string;\n\treadonly signature: string;\n\treadonly documentation: string;\n\treadonly props: readonly CatalogPropEntry[];\n\treadonly tokens: readonly CatalogTokenBinding[];\n\treadonly snippets: CatalogSnippets;\n}\nexport declare const catalogProps: Readonly<Record<string, CatalogComponentMeta>>;\n`;

for (const [relativePath, content] of [
	['react/example/catalog-props.mjs', moduleContent],
	['react/example/catalog-props.d.mts', declarationContent],
]) {
	const target = resolve(root, relativePath);
	if (checkOnly) {
		if (readFileSync(target, 'utf8') !== content) throw new Error(`Generated catalog props stale: ${relativePath}`);
	} else {
		mkdirSync(dirname(target), { recursive: true });
		writeFileSync(target, content);
	}
}
console.log(`Catalog props ${checkOnly ? 'verified' : 'generated'}: ${Object.keys(entries).length} components`);
