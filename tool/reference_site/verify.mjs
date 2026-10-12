import { validateReactScenarios, renderReactScenario } from './react-scenarios.mjs';
import { validateReactSpecimens } from './react-specimens.mjs';
import fs from 'node:fs';
import path from 'node:path';
import { documents, documentRoutes } from './documents.mjs';
import { renderMarkdown } from './markdown.mjs';

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

// 步驟 3：規範來源、章節頁、全文搜尋與本地連結雙向對照。
const expectedDocumentRoutes = new Set(documents.map(({href}) => href));
const siteDocuments = site.documents || [];
if (siteDocuments.length !== documents.length) failures.push('Document manifest count mismatch');
for (const document of documents) {
	const {source, href} = document;
	if (siteDocuments.filter((item) => item.source === source && item.href === href).length !== 1) failures.push(`Document manifest mismatch: ${source}`);
	const sourcePath = path.join(root, source);
	if (!fs.existsSync(sourcePath)) {
		failures.push(`Missing required document source: ${source}`);
		continue;
	}
	if (!actualHtml.has(href)) {
		failures.push(`Missing document page: ${href}`);
		continue;
	}
	const expected = renderMarkdown(fs.readFileSync(sourcePath, 'utf8'), { ...document, routes: documentRoutes });
	const html = fs.readFileSync(path.join(output, href), 'utf8');
	if (!html.includes(expected.html)) failures.push(`Document content mismatch: ${source}`);
	const entries = search.filter((item) => item.href === href);
	if (entries.length !== 1 || entries[0].body !== expected.body || entries[0].category !== document.category) failures.push(`Document search mismatch: ${source}`);
	for (const match of html.matchAll(/href="([^"]+)"/g)) {
		const link = match[1].replaceAll('&amp;', '&');
		if (/^(?:[a-z][a-z\d+.-]*:|\/\/)/i.test(link)) continue;
		const [relativeTarget, fragment] = link.split('#');
		const target = path.posix.normalize(path.posix.join(path.posix.dirname(href), decodeURIComponent(relativeTarget || path.posix.basename(href))));
		if (target.startsWith('../') || !fs.existsSync(path.join(output, target))) {
			failures.push(`Broken local document link: ${href} -> ${link}`);
			continue;
		}
		if (fragment) {
			const targetHtml = fs.readFileSync(path.join(output, target), 'utf8');
			const ids = [...targetHtml.matchAll(/id="([^"]+)"/g)].map(([, id]) => id.replaceAll('&amp;', '&').replaceAll('&quot;', '"').replaceAll('&#39;', "'"));
			if (!ids.includes(decodeURIComponent(fragment))) failures.push(`Broken document anchor: ${href} -> ${link}`);
		}
	}
}
for (const href of actualHtml) {
	if (href.startsWith('docs/design-system/') && !expectedDocumentRoutes.has(href)) failures.push(`Unexpected design document page: ${href}`);
}
for (const entry of search) {
	if (entry.href?.startsWith('docs/design-system/') && !expectedDocumentRoutes.has(entry.href)) failures.push(`Unexpected design search page: ${entry.href}`);
}

// React清單重新對正式輸入驗證；不能相信生成manifest聲稱的完整性。
const args = process.argv.slice(2);
if (new Set(args).size !== args.length || args.some(arg => !['--react', '--react-scenes', '--flutter-scenes'].includes(arg)) || (args.includes('--react-scenes') && !args.includes('--react'))) failures.push('Usage: verify.mjs [--react [--react-scenes]] [--flutter-scenes]');
if (args.includes('--react') && !site.reactComponents) failures.push('Missing React component manifest');
if (site.reactComponents) {
	try {
		const { reactSpecimenRegistry } = await import('../../react/example/specimen-registry.mjs');
		const expected = validateReactSpecimens(JSON.parse(fs.readFileSync(path.join(root, 'react/build/reference-components.json'), 'utf8')), reactSpecimenRegistry);
		if (JSON.stringify(site.reactComponents) !== JSON.stringify(expected)) failures.push('React component manifest mismatch');
		const entries = search.filter(entry => entry.category === 'React Component');
		if (entries.length !== expected.length) failures.push('React component search count mismatch');
		const routes = new Set(['docs/react/components/index.html']);
		for (const component of expected) {
			routes.add(component.href);
			const html = fs.readFileSync(path.join(output, component.href), 'utf8');
			const bundleUrl = `${path.posix.relative(path.posix.dirname(component.href), 'examples/react/index.html')}?specimen=${encodeURIComponent(component.name)}`;
			if (!html.includes(`src="${bundleUrl}"`) || !html.includes(`title="${component.name} React 互動展示"`) || !html.includes(`href="${bundleUrl}"`) || !html.includes('data-specimen-state="loading"')) failures.push(`Invalid React specimen embed: ${component.name}`);
			if (entries.filter(entry => entry.apiId === component.id && entry.href === component.href).length !== 1) failures.push(`React search identity mismatch: ${component.name}`);
		}
		for (const href of actualHtml) if (href.startsWith('docs/react/components/') && !routes.has(href)) failures.push(`Unexpected React page: ${href}`);
		const bundle = path.join(output, 'examples/react/index.html');
		const html = fs.readFileSync(bundle, 'utf8');
		const assets = [...html.matchAll(/(?:src|href)="(\.\/assets\/[^"?#]+)"/g)];
		if (!assets.length) failures.push('React bundle has no assets');
		for (const [, asset] of assets) if (!fs.existsSync(path.resolve(path.dirname(bundle), asset))) failures.push(`Missing React bundle asset: ${asset}`);
	} catch (error) { failures.push(`React verification failed: ${error.message}`); }
}

// 場景重新讀取 example 權威，不相信產物自述或重複名稱表。
if (args.includes('--react-scenes') && !site.reactScenarios) failures.push('Missing React scenario manifest');
const scenarioRoutes = new Set();
if (site.reactScenarios) {
	try {
		const { reactScenarioRegistry } = await import('../../react/example/scenario-registry.mjs');
		const expected = validateReactScenarios(reactScenarioRegistry);
		if (JSON.stringify(site.reactScenarios) !== JSON.stringify(expected)) failures.push('React scenario manifest mismatch');
		if (!site.reactComponents) failures.push('React scenarios require component bundle gate');
		const entries = search.filter(entry => entry.category === 'React Scenario');
		if (entries.length !== expected.length) failures.push('React scenario search count mismatch');
		const index = fs.readFileSync(path.join(output, 'docs/react/scenarios/index.html'), 'utf8');
		const docsIndex = fs.readFileSync(path.join(output, 'docs/index.html'), 'utf8');
		if (!docsIndex.includes('href="react/scenarios/index.html"')) failures.push('Missing React scenario documentation entry');
		scenarioRoutes.add('docs/react/scenarios/index.html');
		for (const scene of expected) {
			scenarioRoutes.add(scene.href);
			const html = fs.readFileSync(path.join(output, scene.href), 'utf8');
			const bundleUrl = `${path.posix.relative(path.posix.dirname(scene.href), 'examples/react/index.html')}?scenario=${encodeURIComponent(scene.id)}`;
			if (!html.includes(renderReactScenario(scene, bundleUrl))) failures.push(`Invalid React scenario embed: ${scene.id}`);
			if (!index.includes(`href="${scene.id}.html"`)) failures.push(`Missing React scenario index link: ${scene.id}`);
			if (entries.filter(entry => entry.apiId === scene.id && entry.href === scene.href && entry.title === scene.title).length !== 1) failures.push(`React scenario search mismatch: ${scene.id}`);
		}
	} catch (error) { failures.push(`React scenario verification failed: ${error.message}`); }
}
for (const href of actualHtml) if (href.startsWith('docs/react/scenarios/') && !scenarioRoutes.has(href)) failures.push(`Unexpected React scenario page: ${href}`);
if (!site.reactScenarios && search.some(entry => entry.category === 'React Scenario')) failures.push('Unexpected React scenario search entries');

// Flutter以正式JSON及完整source bundle驗證，不信任生成清單自述。
if (args.includes('--flutter-scenes') && !site.flutterScenarios) failures.push('Missing Flutter scenario manifest');
const flutterRoutes = new Set();
if (site.flutterScenarios) {
	try {
		const { validateFlutterScenarios, renderFlutterScenario, validateFlutterBundle } = await import('./flutter-scenarios.mjs');
		const registry = JSON.parse(fs.readFileSync(path.join(root, 'flutter/example/assets/gui-scenarios.json'), 'utf8'));
		const expected = validateFlutterScenarios(registry);
		if (JSON.stringify(site.flutterScenarios) !== JSON.stringify(expected)) failures.push('Flutter scenario manifest mismatch');
		const entries = search.filter(entry => entry.category === 'Flutter Scenario');
		if (entries.length !== expected.length) failures.push('Flutter scenario search count mismatch');
		const index = fs.readFileSync(path.join(output, 'docs/flutter/scenarios/index.html'), 'utf8');
		const docsIndex = fs.readFileSync(path.join(output, 'docs/index.html'), 'utf8');
		if (!docsIndex.includes('href="flutter/scenarios/index.html"')) failures.push('Missing Flutter scenario documentation entry');
		flutterRoutes.add('docs/flutter/scenarios/index.html');
		for (const scene of expected) {
			flutterRoutes.add(scene.href);
			const html = fs.readFileSync(path.join(output, scene.href), 'utf8');
			const bundleUrl = `${path.posix.relative(path.posix.dirname(scene.href), 'examples/flutter/index.html')}?scenario=${encodeURIComponent(scene.id)}`;
			if (!html.includes(renderFlutterScenario(scene, bundleUrl))) failures.push(`Invalid Flutter scenario embed: ${scene.id}`);
			if (!index.includes(`href="${scene.id}.html"`)) failures.push(`Missing Flutter scenario index link: ${scene.id}`);
			if (entries.filter(entry => entry.apiId === scene.id && entry.href === scene.href && entry.title === scene.title).length !== 1) failures.push(`Flutter scenario search mismatch: ${scene.id}`);
		}
		const sourceBundle = path.join(root, 'flutter/example/build/web');
		const copiedBundle = path.join(output, 'examples/flutter');
		validateFlutterBundle(sourceBundle, registry);
		validateFlutterBundle(copiedBundle, registry);
		for (const source of files(sourceBundle)) {
			const target = path.join(copiedBundle, path.relative(sourceBundle, source));
			if (!fs.existsSync(target) || !fs.readFileSync(source).equals(fs.readFileSync(target))) failures.push(`Flutter bundle asset mismatch: ${path.relative(sourceBundle, source)}`);
		}
	} catch (error) { failures.push(`Flutter scenario verification failed: ${error.message}`); }
}
for (const href of actualHtml) if (href.startsWith('docs/flutter/scenarios/') && !flutterRoutes.has(href)) failures.push(`Unexpected Flutter scenario page: ${href}`);
if (!site.flutterScenarios && search.some(entry => entry.category === 'Flutter Scenario')) failures.push('Unexpected Flutter scenario search entries');

// 步驟 4：固定網站入口與產物報告。
for (const required of ['index.html', 'docs/index.html', 'docs/api/index.html', 'docs/components/index.html']) {
	if (!actualHtml.has(required)) failures.push(`Missing site entry: ${required}`);
}
const report = { surfaces: surfaceNames, modules: api.modules.length, declarations: declarations.length, documents: documents.length, generatedPages: actualHtml.size, failures };
fs.writeFileSync(path.join(output, 'verification.json'), `${JSON.stringify(report, null, '\t')}\n`);
if (failures.length) {
	console.error(failures.join('\n'));
	process.exit(1);
}
console.log(`Verified ${declarations.length} canonical API pages across ${api.modules.length} modules and three public surfaces.`);
