import fs from 'node:fs';
import path from 'node:path';
import { parse } from 'parse5';
import { Marked } from 'marked';
import GithubSlugger from 'github-slugger';

const root = path.resolve(import.meta.dirname, '..', '..');
const output = path.join(root, 'build', 'reference-site');
const manifest = JSON.parse(fs.readFileSync(path.join(output, 'site-manifest.json'), 'utf8'));
const examples = JSON.parse(fs.readFileSync(path.join(root, 'tool/reference_site/assembly_examples.json'), 'utf8'));
const pages = new Map();
const failures = [];
const sourceIssues = [];
const sourceAnchors = new Map();

function files(directory) {
	return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
		const target = path.join(directory, entry.name);
		return entry.isDirectory() ? files(target) : [target];
	});
}

function decode(value) {
	try { return decodeURIComponent(value); }
	catch { return value; }
}

function inspect(node, result) {
	const attrs = Object.fromEntries((node.attrs || []).map(({ name, value }) => [name, value]));
	if (attrs.id) result.ids.add(attrs.id);
	if (node.tagName === 'a' && attrs.name) result.ids.add(attrs.name);
	if (node.tagName === 'table') result.tables++;
	for (const attribute of ['href', 'src']) {
		if (attrs[attribute]) result.links.push(attrs[attribute]);
	}
	for (const child of node.childNodes || []) inspect(child, result);
}

// 步驟 1：解析所有輸出，建立可驗證的實際錨點與資源清單。
for (const file of files(output).filter((item) => item.endsWith('.html'))) {
	const relative = path.relative(output, file).replaceAll('\\', '/');
	const result = { ids: new Set(), links: [], tables: 0 };
	inspect(parse(fs.readFileSync(file, 'utf8')), result);
	pages.set(relative, result);
}
for (const source of [...manifest.apiDocuments, ...manifest.guides, ...manifest.specs, ...manifest.projectDocuments]) {
	const target = manifest.routeMap[source];
	if (!target || !pages.has(target)) failures.push(`Missing source page: ${source}`);
	const markdown = fs.readFileSync(path.join(root, source), 'utf8');
	const parser = new Marked();
	const slugger = new GithubSlugger();
	const anchors = new Set();
	let tableCount = 0;
	parser.walkTokens(parser.lexer(markdown), (token) => {
		if (token.type === 'table') tableCount++;
		if (token.type === 'heading') {
			const plain = parser.parseInline(token.text).replace(/<[^>]*>/g, '').replaceAll('&amp;', '&').replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"');
			anchors.add(slugger.slug(plain));
		}
		if (token.type === 'html') {
			for (const match of token.text.matchAll(/<a\s+(?:id|name)=["']([^"']+)["']/gi)) anchors.add(match[1]);
		}
	});
	sourceAnchors.set(source, anchors);
	for (const anchor of anchors) {
		if (!pages.get(target)?.ids.has(anchor)) failures.push(`Dropped source anchor: ${source}#${anchor}`);
	}
	if (tableCount && pages.get(target)?.tables < tableCount) failures.push(`Dropped Markdown table: ${source}`);
}
const expectedSources = [...files(path.join(root, 'docs')), ...files(path.join(root, 'spec'))].filter((item) => item.endsWith('.md')).map((item) => path.relative(root, item).replaceAll('\\', '/'));
for (const source of expectedSources) {
	if (!manifest.routeMap[source]) failures.push(`Source omitted from route map: ${source}`);
}
for (const name of manifest.components) {
	const slug = name.replace(/([a-z0-9])([A-Z])/g, '$1-$2').replaceAll('_', '-').toLowerCase();
	if (!pages.has(`docs/components/${slug}.html`)) failures.push(`Missing component page: ${name}`);
}
for (const [name, example] of Object.entries(examples)) {
	if (!manifest.components.includes(name)) failures.push(`Example targets unknown component: ${name}`);
	if (!example.import.startsWith('package:kallopis/') || example.import.includes('/src/')) failures.push(`Example uses private import: ${name}`);
	if (!example.code.includes(name)) failures.push(`Example does not assemble component: ${name}`);
}

// 步驟 2：來源既有壞鏈獨立列出，網站新產生的斷鏈仍必須失敗。
for (const link of manifest.sourceLinks) {
	let reason = '';
	if (!link.exists) reason = 'Source target does not exist or is outside repository';
	if (link.mapped && link.fragment && !sourceAnchors.get(link.target)?.has(decode(link.fragment))) reason = 'Source fragment does not exist';
	if (reason) sourceIssues.push({ ...link, reason });
}
for (const [page, result] of pages) {
	for (const href of result.links) {
		if (/^[a-z][a-z\d+.-]*:/i.test(href) || href.startsWith('//')) continue;
		const [rawPath, fragment] = href.split('#', 2);
		const cleanPath = decode(rawPath.split('?')[0]);
		const target = cleanPath ? path.posix.normalize(path.posix.join(path.posix.dirname(page), cleanPath)) : page;
		const absolute = path.resolve(output, target);
		if (!absolute.startsWith(`${output}${path.sep}`) || !fs.existsSync(absolute)) {
			failures.push(`Broken generated link: ${page} → ${href}`);
			continue;
		}
		if (fragment && pages.has(target) && !pages.get(target).ids.has(decode(fragment))) {
			const inherited = sourceIssues.some((issue) => issue.outputPage === page && manifest.routeMap[issue.target] === target && issue.fragment === fragment);
			if (!inherited) failures.push(`Broken generated anchor: ${page} → ${href}`);
		}
	}
}
for (const [legacy, current] of Object.entries(manifest.redirects)) {
	if (!pages.has(legacy) || !pages.has(current)) failures.push(`Missing redirect: ${legacy} → ${current}`);
}
for (const entry of JSON.parse(fs.readFileSync(path.join(output, 'search-index.json'), 'utf8'))) {
	if (!pages.has(entry.href)) failures.push(`Broken search entry: ${entry.href}`);
}
for (const required of ['index.html', 'docs/index.html', 'docs/get-started.html', 'docs/components/index.html', 'docs/api/index.html', 'docs/guides/index.html', 'docs/spec/index.html']) {
	if (!pages.has(required)) failures.push(`Missing site entry: ${required}`);
}

// 步驟 3：保留完整來源診斷，清楚區分內容問題與網站遷移回歸。
const report = { generatedPages: pages.size, checkedSources: expectedSources.length + 2, sourceIssues, failures };
fs.writeFileSync(path.join(output, 'link-report.json'), JSON.stringify(report, null, '\t'));
if (sourceIssues.length) console.warn(`Source document link warnings: ${sourceIssues.length}; see build/reference-site/link-report.json (not silently ignored).`);
if (failures.length) {
	console.error(failures.join('\n'));
	process.exit(1);
}
console.log(`Reference site verified: ${manifest.components.length} components, ${manifest.apiDocuments.length} API pages, ${pages.size} HTML pages; source coverage, tables, internal links and anchors checked.`);
