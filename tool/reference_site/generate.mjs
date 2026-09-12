import fs from 'node:fs';
import path from 'node:path';
import { shell, homePage } from './layout.mjs';
import { escapeHtml, createMarkdownRenderer } from './markdown.mjs';

const root = path.resolve(import.meta.dirname, '..', '..');
const output = path.join(root, 'build', 'reference-site');
const architectureRoot = 'docs/architecture/src';
const examples = JSON.parse(readText('tool/reference_site/assembly_examples.json'));

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
	const components = inventoryComponents();
	const apiDocuments = files(architectureRoot, (item) => item.endsWith('.md'));
	const guides = files('docs', (item) => item.endsWith('.md') && !item.startsWith(`${architectureRoot}/`));
	const specs = files('spec', (item) => item.endsWith('.md'));
	const projectDocuments = ['README.md', 'CHANGELOG.md'];
	const routeMap = {};
	for (const item of apiDocuments) routeMap[item] = `docs/api/${item.slice(architectureRoot.length + 1).replace(/\.md$/, '.html')}`;
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
		if (apiDocuments.includes(source)) category = 'API';
		if (specs.includes(source)) category = 'Spec';
		const entry = { title, category, href: relative, sourcePath: source };
		if (category === 'API') entry.apiArea = source.slice(architectureRoot.length + 1).split('/')[0];
		if (category === 'Guide') entry.guideArea = source.split('/')[1] || 'project';
		search.push(entry);
		if (relative.startsWith('docs/api/') || relative.startsWith('docs/guides/')) redirect(relative.slice(5), relative);
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
	index('docs/api/index.html', 'API Reference', search.filter((item) => item.category === 'API'), '從架構圖集產生的實作參照，保留每一份來源文件。');
	index('docs/guides/index.html', '使用指南', search.filter((item) => item.category === 'Guide'), '教學、架構、工作流程與專案文件。');
	index('docs/spec/index.html', '設計契約', search.filter((item) => item.category === 'Spec'), '目前契約與歷史決策保留原始狀態，請先閱讀文件標示。');
	page('docs/index.html', '文件', '<p class="eyebrow">Kallopis documentation</p><h1>從意圖到介面</h1><p>從宣告式組裝入門，查閱元件、API 與設計契約。文件直接由儲存庫 Markdown 產生。</p><div class="doc-entry-grid"><a class="card" href="get-started.html">開始使用</a><a class="card" href="components/index.html">元件目錄</a><a class="card" href="api/index.html">API Reference</a><a class="card" href="guides/index.html">使用指南</a><a class="card" href="spec/index.html">設計契約</a><a class="card" href="project/CHANGELOG.html">更新紀錄</a></div>');
	page('docs/get-started.html', '開始使用', render(readText('docs/ai/README.md'), 'docs/ai/README.md', 'docs/get-started.html'), 'docs/ai/README.md');
	for (const legacy of ['get-started.html', 'components/index.html', 'api/index.html', 'guides/index.html']) redirect(legacy, `docs/${legacy}`);
	write('index.html', homePage({ components, apiDocuments, guides }));
	write('search-index.json', JSON.stringify(search));
	write('site-manifest.json', JSON.stringify({ components: components.map((item) => item.name), apiDocuments, guides, specs, projectDocuments, routeMap, redirects, sourceLinks }, null, '\t'));
	console.log(`Generated ${components.length} components, ${apiDocuments.length} API pages, ${guides.length} guides, ${specs.length} specifications, ${projectDocuments.length} project documents.`);
}

main();
