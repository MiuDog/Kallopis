import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..', '..');
const output = path.join(root, 'build', 'reference-site');
const examples = readJson('tool/reference_site/assembly_examples.json');
const architectureRoot = 'docs/architecture/src';

function readText(relativePath) {
	return fs.readFileSync(path.join(root, relativePath), 'utf8');
}

function readJson(relativePath) {
	return JSON.parse(readText(relativePath));
}

function files(relativePath, predicate) {
	const absolute = path.join(root, relativePath);
	const entries = fs.readdirSync(absolute, { withFileTypes: true });
	return entries.flatMap((entry) => {
		const nested = path.join(relativePath, entry.name);
		if (entry.isDirectory()) return files(nested, predicate);
		return predicate(nested) ? [nested.replaceAll('\\', '/')] : [];
	});
}

function slug(value) {
	return value.replace(/([a-z0-9])([A-Z])/g, '$1-$2').replaceAll('_', '-').toLowerCase();
}

function escapeHtml(value) {
	return value.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');
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

function markdownToHtml(markdown) {
	const lines = markdown.replaceAll('\r\n', '\n').split('\n');
	const html = [];
	let fence = false;
	let list = false;
	for (const line of lines) {
		if (line.startsWith('```')) {
			if (!fence) {
				fence = true;
				html.push(`<pre><code class="language-${escapeHtml(line.slice(3) || 'text')}">`);
			}
			else {
				fence = false;
				html.push('</code></pre>');
			}
			continue;
		}
		if (fence) {
			html.push(`${escapeHtml(line)}\n`);
			continue;
		}
		const heading = line.match(/^(#{1,4}) (.+)$/);
		if (heading) {
			if (list) {
				html.push('</ul>');
				list = false;
			}
			const level = heading[1].length;
			html.push(`<h${level}>${inlineMarkdown(heading[2])}</h${level}>`);
			continue;
		}
		if (line.startsWith('- ')) {
			if (!list) {
				html.push('<ul>');
				list = true;
			}
			html.push(`<li>${inlineMarkdown(line.slice(2))}</li>`);
			continue;
		}
		if (list) {
			html.push('</ul>');
			list = false;
		}
		if (line.trim().length > 0 && !line.startsWith('|')) html.push(`<p>${inlineMarkdown(line)}</p>`);
	}
	if (list) html.push('</ul>');
	return html.join('\n');
}

function inlineMarkdown(value) {
	return escapeHtml(value)
		.replace(/`([^`]+)`/g, '<code>$1</code>')
		.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');
}

function shell({ title, content, active = '' }) {
	const prefix = '../'.repeat(active.split('/').filter(Boolean).length);
	return `<!doctype html>
<html lang="zh-Hant">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>${escapeHtml(title)} · Kallopis</title>
	<link rel="stylesheet" href="${prefix}assets/site.css">
</head>
<body data-root="${prefix}">
	<header class="topbar"><a href="${prefix}index.html">Kallopis</a><a href="${prefix}get-started.html">Get Started</a><a href="${prefix}components/index.html">Components</a><a href="${prefix}api/index.html">API</a></header>
	<div class="site-shell">
		<aside class="navigator"><label for="search">Search</label><input id="search" type="search" placeholder="KlpText, router…"><nav id="navigation"></nav></aside>
		<main>${content}</main>
	</div>
	<script src="${prefix}assets/site.js"></script>
</body>
</html>`;
}

function pageLinkForDoc(relativePath) {
	return `api/${relativePath.slice(architectureRoot.length + 1).replace(/\.md$/, '.html')}`;
}

function pageLinkForGuide(relativePath) {
	return `guides/${relativePath.slice('docs/'.length).replace(/\.md$/, '.html')}`;
}

function componentPage(component) {
	const example = examples[component.name];
	const exampleHtml = example
		? `<section><h2>組裝範例</h2><p>以公開入口匯入：</p><pre><code>${escapeHtml(`import '${example.import}';\n\n${example.code}`)}</code></pre></section>`
		: '<section><h2>組裝範例</h2><p>此型別為葉節點，沒有子元件組裝範例。</p></section>';
	return shell({
		title: component.name,
		active: 'components/',
		content: `<p class="eyebrow">${escapeHtml(component.domain)}</p><h1>${escapeHtml(component.name)}</h1><p>${component.container ? `組成：${inlineMarkdown(component.composition)}` : '葉節點元件。'}</p>${exampleHtml}<p><a href="../api/index.html">查看完整 API reference</a></p>`,
	});
}

function main() {
	fs.rmSync(output, { recursive: true, force: true });
	fs.mkdirSync(output, { recursive: true });
	for (const asset of files('tool/reference_site/static', (item) => item.endsWith('.css') || item.endsWith('.js'))) {
		write(`assets/${path.basename(asset)}`, readText(asset));
	}
	const components = inventoryComponents();
	const apiDocuments = files(architectureRoot, (item) => item.endsWith('.md'));
	const guides = [
		...files('docs/ai', (item) => item.endsWith('.md')),
		...files('docs/architecture', (item) => item.endsWith('.md') && !item.includes('/src/') && !item.includes('/components/')),
	];
	const search = [];
	for (const component of components) {
		const relative = `components/${slug(component.name)}.html`;
		write(relative, componentPage(component));
		search.push({ title: component.name, category: component.domain, href: relative });
	}
	for (const document of apiDocuments) {
		const relative = pageLinkForDoc(document);
		const title = readText(document).match(/^#\s+(.+)$/m)?.[1] ?? path.basename(document, '.md');
		write(relative, shell({ title, active: path.posix.dirname(relative), content: markdownToHtml(readText(document)) }));
		const area = document.slice(architectureRoot.length + 1).split('/')[0] || 'root';
		search.push({ title, category: 'API', apiArea: area, href: relative });
	}
	for (const guide of guides) {
		const relative = pageLinkForGuide(guide);
		const title = readText(guide).match(/^#\s+(.+)$/m)?.[1] ?? path.basename(guide, '.md');
		write(relative, shell({ title, active: path.posix.dirname(relative), content: markdownToHtml(readText(guide)) }));
		search.push({ title, category: 'Guide', href: relative });
	}
	write('components/index.html', shell({ title: 'Components', active: 'components', content: `<h1>Components</h1><p>${components.length} 個 public component pages。使用左側搜尋或依分類瀏覽。</p><ul>${components.map((item) => `<li><a href="${slug(item.name)}.html">${item.name}</a> <small>${item.domain}</small></li>`).join('')}</ul>` }));
	const apiGroups = new Map();
	for (const document of apiDocuments) {
		const area = document.slice(architectureRoot.length + 1).split('/')[0] || 'root';
		const entries = apiGroups.get(area) ?? [];
		entries.push(document);
		apiGroups.set(area, entries);
	}
	const apiIndex = [...apiGroups.entries()]
		.sort(([left], [right]) => left.localeCompare(right))
		.map(([area, documents]) => `<section id="${slug(area)}"><h2>${escapeHtml(area)}</h2><ul>${documents.map((item) => `<li><a href="${pageLinkForDoc(item).replace(/^api\//, '')}">${escapeHtml(item)}</a></li>`).join('')}</ul></section>`)
		.join('');
	write('api/index.html', shell({ title: 'API Reference', active: 'api', content: `<h1>API Reference</h1><p>${apiDocuments.length} 個由 architecture-atlas 產生的來源頁。</p>${apiIndex}` }));
	write('get-started.html', shell({ title: 'Get Started', content: markdownToHtml(readText('docs/ai/README.md')) }));
	write('index.html', shell({ title: 'Reference', content: '<p class="eyebrow">Kallopis reference</p><h1>建構受控的 Flutter 視覺層</h1><p>從 Get Started 開始，或用分類與 API navigator 尋找元件。</p><p><a class="button" href="get-started.html">Get Started</a> <a class="button secondary" href="components/index.html">Browse components</a></p>' }));
	write('search-index.json', JSON.stringify(search));
	write('site-manifest.json', JSON.stringify({ components: components.map((item) => item.name), apiDocuments, guides }, null, '\t'));
	console.log(`Generated ${components.length} component pages, ${apiDocuments.length} API pages, and ${guides.length} guide pages.`);
}

main();
