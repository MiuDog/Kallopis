import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { extractReactApi } from '../../tool/reference_site/extract-react-api.mjs';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const checkOnly = process.argv.includes('--check');
const declarations = await extractReactApi(root);
const bindings = JSON.parse(readFileSync(resolve(root, 'styles/component-bindings.json'), 'utf8')).bindings;

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

const entries = {};
for (const declaration of declarations) {
	if (!declaration.renderable) continue;
	entries[declaration.name] = {
		name: declaration.name,
		id: declaration.id,
		source: declaration.source,
		signature: declaration.signature,
		documentation: declaration.documentation,
		props: declaration.parameters.map(parameter => ({
			name: parameter.name,
			type: parameter.type,
			required: parameter.required,
			defaultValue: parameter.defaultValue,
			documentation: parameter.documentation,
		})),
		tokens: tokensForComponent(declaration),
	};
}

const moduleContent = `// 由 react/scripts/generate-catalog-props.mjs 自動產生，禁止手改。\nexport const catalogProps = Object.freeze(${JSON.stringify(entries, null, '\t')});\n`;
const declarationContent = `export interface CatalogPropEntry {\n\treadonly name: string;\n\treadonly type: string;\n\treadonly required: boolean;\n\treadonly defaultValue: string | null;\n\treadonly documentation: string;\n}\nexport interface CatalogTokenBinding {\n\treadonly id: string;\n\treadonly css: string;\n\treadonly flutter: string;\n}\nexport interface CatalogComponentMeta {\n\treadonly name: string;\n\treadonly id: string;\n\treadonly source: string;\n\treadonly signature: string;\n\treadonly documentation: string;\n\treadonly props: readonly CatalogPropEntry[];\n\treadonly tokens: readonly CatalogTokenBinding[];\n}\nexport declare const catalogProps: Readonly<Record<string, CatalogComponentMeta>>;\n`;

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
