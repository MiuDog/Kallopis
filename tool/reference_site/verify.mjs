import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..', '..');
const output = path.join(root, 'build', 'reference-site');
const api = JSON.parse(fs.readFileSync(path.join(root, 'build', 'reference-api.json'), 'utf8'));
const site = JSON.parse(fs.readFileSync(path.join(output, 'site-manifest.json'), 'utf8'));
const search = JSON.parse(fs.readFileSync(path.join(output, 'search-index.json'), 'utf8'));
const failures = [];

function files(directory) {
	return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
		const target = path.join(directory, entry.name);
		return entry.isDirectory() ? files(target) : [target];
	});
}

function modulePage(name) {
	return `docs/api/${name.replaceAll('.', '/')}/index.html`;
}

function declarationPage(declaration) {
	return `docs/api/${declaration.module.replaceAll('.', '/')}/${declaration.slug}.html`;
}

const surfaceNames = api.surfaces.map((surface) => surface.name);
if (api.schemaVersion !== 1 || surfaceNames.join(',') !== 'theme,foundation,experimental') failures.push('Manifest surfaces must be theme, foundation, experimental only');
if (JSON.stringify(api).toLowerCase().includes('declarative')) failures.push('Manifest contains forbidden declarative surface');
const surfaceByName = new Map(api.surfaces.map((surface) => [surface.name, surface]));
const declarations = api.modules.flatMap((module) => module.declarations);
const expectedModules = new Set(api.modules.map((module) => modulePage(module.name)));
const expectedDeclarations = new Map(declarations.map((declaration) => [declaration.id, declarationPage(declaration)]));
const actualHtml = new Set(files(output).filter((file) => file.endsWith('.html')).map((file) => path.relative(output, file).replaceAll('\\', '/')));

// 步驟 1：雙向驗證 module 與 canonical declaration 頁面。
for (const modulePath of expectedModules) {
	if (!actualHtml.has(modulePath)) failures.push(`Missing API module page: ${modulePath}`);
}
for (const declaration of declarations) {
	const href = declarationPage(declaration);
	const absolute = path.join(output, href);
	if (!fs.existsSync(absolute)) {
		failures.push(`Missing API declaration page: ${declaration.id}`);
		continue;
	}
	const html = fs.readFileSync(absolute, 'utf8');
	if (!html.includes(declaration.sourceUri)) failures.push(`Missing source URI: ${declaration.id}`);
	if (!html.includes(declaration.signature.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;'))) failures.push(`Missing signature: ${declaration.id}`);
	for (const surfaceName of declaration.surfaces) {
		const entrypoint = surfaceByName.get(surfaceName)?.entrypoint;
		if (!entrypoint || !html.includes(entrypoint)) failures.push(`Missing ${surfaceName} surface import: ${declaration.id}`);
	}
	const moduleHtml = fs.readFileSync(path.join(output, modulePage(declaration.module)), 'utf8');
	if (!moduleHtml.includes(`${declaration.slug}.html`)) failures.push(`Declaration absent from module: ${declaration.id}`);
}
const allowedApi = new Set(['docs/api/index.html', ...expectedModules, ...expectedDeclarations.values()]);
for (const page of actualHtml) {
	if (page.startsWith('docs/api/') && !allowedApi.has(page)) failures.push(`Unexpected formal API page: ${page}`);
}

// 步驟 2：雙向驗證 site manifest 與 search identity。
const siteModules = new Map((site.apiModules || []).map((module) => [module.name, module.href]));
for (const module of api.modules) {
	if (siteModules.get(module.name) !== modulePage(module.name)) failures.push(`Site manifest module mismatch: ${module.name}`);
}
if (siteModules.size !== api.modules.length) failures.push('Site manifest has extra or missing modules');
const siteDeclarations = new Map((site.apiDeclarations || []).map((item) => [item.id, item.href]));
for (const [id, href] of expectedDeclarations) {
	if (siteDeclarations.get(id) !== href) failures.push(`Site manifest declaration mismatch: ${id}`);
}
if (siteDeclarations.size !== expectedDeclarations.size) failures.push('Site manifest has extra or missing declarations');
const apiSearch = search.filter((entry) => entry.category === 'API');
const searchById = new Map(apiSearch.map((entry) => [entry.apiId, entry.href]));
for (const [id, href] of expectedDeclarations) {
	if (searchById.get(id) !== href) failures.push(`Search declaration mismatch: ${id}`);
}
if (searchById.size !== expectedDeclarations.size || apiSearch.length !== expectedDeclarations.size) failures.push('Search has duplicate, extra or missing declarations');

// 步驟 3：固定網站入口與產物報告。
for (const required of ['index.html', 'docs/index.html', 'docs/api/index.html', 'docs/components/index.html']) {
	if (!actualHtml.has(required)) failures.push(`Missing site entry: ${required}`);
}
const report = { surfaces: surfaceNames, modules: api.modules.length, declarations: declarations.length, generatedPages: actualHtml.size, failures };
fs.writeFileSync(path.join(output, 'verification.json'), `${JSON.stringify(report, null, '\t')}\n`);
if (failures.length) {
	console.error(failures.join('\n'));
	process.exit(1);
}
console.log(`Verified ${declarations.length} canonical API pages across ${api.modules.length} modules and three public surfaces.`);
