import fs from 'node:fs';
import path from 'node:path';
import { shell, homePage } from './layout.mjs';
import { escapeHtml, createMarkdownRenderer } from './markdown.mjs';

const root = path.resolve(import.meta.dirname, '..', '..');
const output = path.join(root, 'build', 'reference-site');
const architectureRoot = 'docs/architecture/src';
const examples = JSON.parse(readText('tool/reference_site/assembly_examples.json'));
const declarativeApi = JSON.parse(readText('build/reference-api.json'));

const moduleDescriptions = {
	application: '應用程式組合根、畫面路由與 host 注入的產品環境。Consumer 從這裡建立完整應用。',
	capabilities: '產品資料、狀態、動作與導覽的非視覺契約，供 feature 接收 consumer 控制。',
	composition: 'Kallopis 節點、受限插槽與合法組裝資格；不接受原生 Widget。',
	features: '生產力功能的語意節點入口；依 workspace、editing、overlays 等 family 瀏覽。',
	foundation: '跨 module 的平台與排版值；只公開組裝確實需要的基礎語意。',
	kernel: '公開識別值與契約錯誤，是其他宣告式 module 的最小核心。',
	rendering: '由 Kallopis 擁有的 Flutter 呈現層；consumer 不直接使用，公開 API 為 0。',
	runtime: '由 Kallopis 擁有的解析與安裝層；consumer 不直接使用，公開 API 為 0。',
	styling: '由 Kallopis 完整掌管的語意視覺層；consumer 不注入 style，公開 API 為 0。',
};

function readText(relativePath) {
	return fs.readFileSync(path.join(root, relativePath), 'utf8');
}

function files(relativePath, predicate) {
	return fs.readdirSync(path.join(root, relativePath), { withFileTypes: true }).flatMap((entry) => {
		const nested = path.posix.join(relativePath, entry.name);
		if (entry.isDirectory()) return files(nested, predicate);
		return predicate(nested) ? [nested] : [];
	}).sort();
}

function slug(value) {
	return value.replace(/([a-z0-9])([A-Z])/g, '$1-$2').replaceAll('_', '-').toLowerCase();
}

function moduleRoute(name) {
	return `docs/api/${name.replaceAll('.', '/')}`;
}

function validateDeclarativeApi() {
	if (declarativeApi.schemaVersion !== 1 || !Array.isArray(declarativeApi.modules)) {
		throw new Error('Unsupported or incomplete declarative API manifest');
	}
	const names = new Set();
	for (const module of declarativeApi.modules) {
		if (!module.name || !Array.isArray(module.declarations)) throw new Error('Invalid API module');
		for (const declaration of module.declarations) {
			if (declaration.module !== module.name) throw new Error(`Declaration module mismatch: ${declaration.name}`);
			if (!declaration.name || !declaration.slug || !declaration.signature || !declaration.sourceUri) throw new Error(`Incomplete API declaration: ${declaration.name || '<unknown>'}`);
			if (names.has(declaration.name)) throw new Error(`Duplicate API declaration: ${declaration.name}`);
			names.add(declaration.name);
		}
	}
}

function write(relativePath, content) {
	const target = path.join(output, relativePath);
	fs.mkdirSync(path.dirname(target), { recursive: true });
	fs.writeFileSync(target, content);
}

function inventoryComponents() {
	const lines = readText('spec/component-inventory.md').split(/\r?\n/);
	let active = false;
	let domain = 'foundation';
	const components = [];
	for (const line of lines) {
		if (line === '## 各領域的元件樹') active = true;
		if (line === '## 葉節點') break;
		if (!active) continue;
		const heading = line.match(/^### ([a-z_]+) —/);
		if (heading) domain = heading[1];
		const row = line.match(/^\| `(?<name>Klp[A-Za-z0-9_]+)` \| (?<lines>\d+) \| (?<composition>.*) \|$/);
		if (!row) continue;
		components.push({
			name: row.groups.name,
			domain,
			composition: row.groups.composition,
			container: row.groups.composition !== '（葉節點）',
		});
	}
	for (const name of ['KlpApplication', 'KlpScreen', 'KlpAdaptive', 'KlpAppLayout']) {
		if (!components.some((item) => item.name === name)) {
			components.push({ name, domain: 'declarative', composition: '受控子節點', container: true });
		}
	}
	return components.sort((left, right) => left.name.localeCompare(right.name));
}


function main() {
	// 先建立完整路由，使跨文件連結不依賴產生順序。
	validateDeclarativeApi();
	const components = inventoryComponents();
	const internalDocuments = files(architectureRoot, (item) => item.endsWith('.md'));
	const guides = files('docs', (item) => item.endsWith('.md') && !item.startsWith(`${architectureRoot}/`));
	const specs = files('spec', (item) => item.endsWith('.md'));
	const projectDocuments = ['README.md', 'CHANGELOG.md'];
	const routeMap = {};
	for (const item of internalDocuments) routeMap[item] = `docs/internals/${item.slice(architectureRoot.length + 1).replace(/\.md$/, '.html')}`;
	for (const item of guides) routeMap[item] = `docs/guides/${item.slice(5).replace(/\.md$/, '.html')}`;
	for (const item of specs) routeMap[item] = `docs/spec/${item.slice(5).replace(/\.md$/, '.html')}`;
	for (const item of projectDocuments) routeMap[item] = `docs/project/${item.replace(/\.md$/, '.html')}`;
	const sourceLinks = [];
	const redirects = {};
	const render = createMarkdownRenderer({ root, output, routeMap, sourceLinks });
	const search = [];

	// 輸出目錄固定在本專案 build 之下，不刪除任何文件來源。
	if (output !== path.join(root, 'build', 'reference-site')) throw new Error('Unsafe output directory');
	fs.rmSync(output, { recursive: true, force: true });
	fs.mkdirSync(path.join(output, 'assets'), { recursive: true });
	for (const asset of files('tool/reference_site/static', () => true)) {
		const target = path.join(output, 'assets', path.basename(asset));
		fs.copyFileSync(asset, target);
	}
	function page(relative, title, content, sourcePath = '') {
		write(relative, shell({ title, content, active: path.posix.dirname(relative), sourcePath }));
	}
	function redirect(from, to) {
		const relative = path.posix.relative(path.posix.dirname(from), to);
		redirects[from] = to;
		write(from, `<!doctype html><html lang="zh-Hant"><meta charset="utf-8"><title>文件已搬移 · Kallopis</title><meta http-equiv="refresh" content="0;url=${escapeHtml(relative)}"><link rel="canonical" href="${escapeHtml(relative)}"><p>文件已搬移至 <a href="${escapeHtml(relative)}">新版文件</a>。</p><script>location.replace(${JSON.stringify(relative)} + location.search + location.hash);</script></html>`);
	}
	for (const [source, relative] of Object.entries(routeMap)) {
		const markdown = readText(source);
		const title = markdown.match(/^#\s+(.+)$/m)?.[1] ?? path.basename(source, '.md');
		page(relative, title, render(markdown, source, relative), source);
		let category = 'Guide';
		if (internalDocuments.includes(source)) category = 'Internal';
		if (specs.includes(source)) category = 'Spec';
		const entry = { title, category, href: relative, sourcePath: source };
		if (category === 'Internal') entry.guideArea = '內部架構';
		if (category === 'Guide') entry.guideArea = source.split('/')[1] || 'project';
		search.push(entry);
		if (relative.startsWith('docs/internals/')) {
			const suffix = relative.slice('docs/internals/'.length);
			redirect(`docs/api/${suffix}`, relative);
			redirect(`api/${suffix}`, relative);
		} else if (relative.startsWith('docs/guides/')) {
			redirect(relative.slice(5), relative);
		}
	}
	const apiModules = declarativeApi.modules.map((module) => ({
		name: module.name,
		href: `${moduleRoute(module.name)}/index.html`,
		declarationCount: module.declarations.length,
	}));
	const apiDeclarations = [];
	for (const module of declarativeApi.modules) {
		const moduleBase = moduleRoute(module.name);
		for (const declaration of module.declarations) {
			const relative = `${moduleBase}/${declaration.slug}.html`;
			apiDeclarations.push({
				name: declaration.name,
				kind: declaration.kind,
				module: module.name,
				href: relative,
				sourceUri: declaration.sourceUri,
			});
			const relationships = [
				declaration.typeRelationships.extends ? `<li><strong>extends</strong> <code>${escapeHtml(declaration.typeRelationships.extends)}</code></li>` : '',
				...(declaration.typeRelationships.mixins || []).map((item) => `<li><strong>with / on</strong> <code>${escapeHtml(item)}</code></li>`),
				...(declaration.typeRelationships.implements || []).map((item) => `<li><strong>implements</strong> <code>${escapeHtml(item)}</code></li>`),
			].filter(Boolean).join('');
			const members = declaration.members.length
				? declaration.members.map((member) => `<section><h3 id="${escapeHtml(slug(`${member.kind}-${member.name}`))}">${escapeHtml(member.name || member.kind)}</h3><p class="eyebrow">${escapeHtml(member.kind)}</p><pre><code class="language-dart">${escapeHtml(member.signature)}</code></pre>${member.documentation ? `<p>${escapeHtml(member.documentation).replaceAll('\n', '<br>')}</p>` : ''}</section>`).join('')
				: '<p>此宣告沒有自行定義的 public member。</p>';
			page(
				relative,
				declaration.name,
				`<p class="eyebrow">${escapeHtml(module.name)} · ${escapeHtml(declaration.kind)}</p><h1>${escapeHtml(declaration.name)}</h1>${declaration.documentation ? `<p>${escapeHtml(declaration.documentation).replaceAll('\n', '<br>')}</p>` : '<p>目前原始碼尚未提供 declaration documentation。</p>'}<h2 id="signature">公開簽名</h2><pre><code class="language-dart">${escapeHtml(declaration.signature)}</code></pre><h2 id="source">來源</h2><p><code>${escapeHtml(declaration.sourceUri)}</code></p>${relationships ? `<h2 id="type-relationships">型別關係</h2><ul>${relationships}</ul>` : ''}<h2 id="members">Public members</h2>${members}`,
			);
			search.push({ title: declaration.name, category: 'API', href: relative, apiArea: module.name, kind: declaration.kind });
		}
	}
	for (const module of declarativeApi.modules) {
		const relative = `${moduleRoute(module.name)}/index.html`;
		const submodules = declarativeApi.modules.filter((candidate) => candidate.name.startsWith(`${module.name}.`) && !candidate.name.slice(module.name.length + 1).includes('.'));
		const grouped = new Map();
		for (const declaration of module.declarations) {
			if (!grouped.has(declaration.kind)) grouped.set(declaration.kind, []);
			grouped.get(declaration.kind).push(declaration);
		}
		const submoduleHtml = submodules.length ? `<h2 id="submodules">子 module</h2><ul>${submodules.map((item) => `<li><a href="${escapeHtml(path.posix.relative(path.posix.dirname(relative), `${moduleRoute(item.name)}/index.html`))}"><code>${escapeHtml(item.name)}</code></a> — ${item.declarations.length} 個公開 API</li>`).join('')}</ul>` : '';
		const declarationsHtml = grouped.size ? [...grouped.entries()].map(([kind, declarations]) => `<section><h2 id="${escapeHtml(slug(kind))}">${escapeHtml(kind)}</h2><ul>${declarations.map((declaration) => `<li><a href="${escapeHtml(declaration.slug)}.html"><code>${escapeHtml(declaration.name)}</code></a></li>`).join('')}</ul></section>`).join('') : '<h2 id="public-api">Public API</h2><p>此 module 不向 consumer 暴露宣告；能力由 Kallopis 內部擁有。</p>';
		page(relative, module.name, `<p class="eyebrow">MODULE</p><h1><code>${escapeHtml(module.name)}</code></h1><p>${escapeHtml(moduleDescriptions[module.name] || `${module.name} 功能 family 的宣告式公開契約。`)}</p><p><strong>${module.declarations.length}</strong> 個公開宣告。</p>${submoduleHtml}${declarationsHtml}`);
	}
	for (const component of components) {
		const relative = `docs/components/${slug(component.name)}.html`;
		const example = examples[component.name];
		const exampleHtml = example ? `<h2>組裝範例</h2><pre><code class="language-dart">${escapeHtml(`import '${example.import}';\n\n${example.code}`)}</code></pre>` : '<h2>組裝範例</h2><p>此頁尚未收錄組裝範例，請參閱 API 與來源契約。</p>';
		page(relative, component.name, `<p class="eyebrow">${escapeHtml(component.domain)}</p><h1>${escapeHtml(component.name)}</h1>${render(component.composition, 'spec/component-inventory.md', relative)}${exampleHtml}<p><a href="../api/index.html">查看完整 API reference</a></p>`, 'spec/component-inventory.md');
		search.push({ title: component.name, category: component.domain, href: relative });
		redirect(relative.slice(5), relative);
	}
	function index(relative, title, entries, introduction) {
		const groups = new Map();
		for (const entry of entries) {
			const group = entry.apiArea || entry.guideArea || entry.category;
			if (!groups.has(group)) groups.set(group, []);
			groups.get(group).push(entry);
		}
		const content = [...groups.entries()].map(([group, items]) => `<section><h2>${escapeHtml(group)}</h2><ul>${items.map((item) => `<li><a href="${escapeHtml(path.posix.relative(path.posix.dirname(relative), item.href))}">${escapeHtml(item.title)}</a></li>`).join('')}</ul></section>`).join('');
		page(relative, title, `<h1>${title}</h1><p>${introduction}</p>${content}`);
	}
	index('docs/components/index.html', '元件目錄', search.filter((item) => item.href.startsWith('docs/components/')), `${components.length} 個元件，依領域瀏覽。`);
	const topModules = declarativeApi.modules.filter((module) => !module.name.includes('.'));
	const moduleCards = topModules.map((module) => `<section><h2><a href="${escapeHtml(path.posix.relative('docs/api', `${moduleRoute(module.name)}/index.html`))}"><code>${escapeHtml(module.name)}</code></a></h2><p>${escapeHtml(moduleDescriptions[module.name])}</p><p>${module.declarations.length} 個直接公開宣告</p></section>`).join('');
	page('docs/api/index.html', 'API Reference', `<h1>API Reference</h1><p>以下清冊只來自 <code>kallopis_declarative.dart</code> 的實際 export closure。先依前端責任選 module，再進入一個公開宣告一頁的 reference。</p>${moduleCards}`);
	index('docs/guides/index.html', '使用指南', search.filter((item) => item.category === 'Guide'), '教學、架構、工作流程與專案文件。');
	index('docs/spec/index.html', '設計契約', search.filter((item) => item.category === 'Spec'), '目前契約與歷史決策保留原始狀態，請先閱讀文件標示。');
	page('docs/index.html', '文件', '<p class="eyebrow">Kallopis documentation</p><h1>從意圖到介面</h1><p>從宣告式組裝入門，查閱元件、API 與設計契約。文件直接由儲存庫 Markdown 產生。</p><div class="doc-entry-grid"><a class="card" href="get-started.html">開始使用</a><a class="card" href="components/index.html">元件目錄</a><a class="card" href="api/index.html">API Reference</a><a class="card" href="guides/index.html">使用指南</a><a class="card" href="spec/index.html">設計契約</a><a class="card" href="project/CHANGELOG.html">更新紀錄</a></div>');
	page('docs/get-started.html', '開始使用', render(readText('docs/ai/README.md'), 'docs/ai/README.md', 'docs/get-started.html'), 'docs/ai/README.md');
	for (const legacy of ['get-started.html', 'components/index.html', 'api/index.html', 'guides/index.html']) redirect(legacy, `docs/${legacy}`);
	write('index.html', homePage({ components, apiDocuments: apiDeclarations, guides }));
	write('search-index.json', JSON.stringify(search));
	write('site-manifest.json', JSON.stringify({ components: components.map((item) => item.name), apiDocuments: internalDocuments, apiModules, apiDeclarations, guides, specs, projectDocuments, routeMap, redirects, sourceLinks }, null, '\t'));
	console.log(`Generated ${components.length} components, ${apiDeclarations.length} declarative API pages, ${internalDocuments.length} internal documents, ${guides.length} guides, ${specs.length} specifications, ${projectDocuments.length} project documents.`);
}

main();
