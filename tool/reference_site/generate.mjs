import fs from 'node:fs';
import path from 'node:path';
import { homePage, shell } from './layout.mjs';
import { documents, documentRoutes } from './documents.mjs';
import { renderMarkdown } from './markdown.mjs';

const root = path.resolve(import.meta.dirname, '..', '..');
const output = path.join(root, 'build', 'reference-site');
const api = JSON.parse(fs.readFileSync(path.join(root, 'build', 'reference-api.json'), 'utf8'));
const surfaceContracts = [
	['theme', 'package:kallopis/kallopis_theme.dart', 'Stable Theme'],
	['foundation', 'package:kallopis/kallopis_foundation.dart', 'Stable Components'],
	['experimental', 'package:kallopis/kallopis_experimental.dart', 'Experimental'],
];
const labels = Object.fromEntries(surfaceContracts.map(([name, , label]) => [name, label]));
function escapeHtml(value) {
	return String(value)
		.replaceAll('&', '&amp;')
		.replaceAll('<', '&lt;')
		.replaceAll('>', '&gt;')
		.replaceAll('"', '&quot;');
}

function slug(value) {
	return value.replace(/([a-z0-9])([A-Z])/g, '$1-$2').replaceAll('_', '-').toLowerCase();
}

function moduleRoute(name) {
	return `docs/api/${name.replaceAll('.', '/')}`;
}

function declarationRoute(declaration) {
	return `${moduleRoute(declaration.module)}/${declaration.slug}.html`;
}

function relative(from, to) {
	return path.posix.relative(path.posix.dirname(from), to) || path.posix.basename(to);
}

function validateManifest() {
	if (api.schemaVersion !== 1 || !Array.isArray(api.surfaces) || !Array.isArray(api.modules)) throw new Error('Unsupported API manifest');
	if (api.surfaces.length !== surfaceContracts.length) throw new Error('Manifest must contain exactly three current surfaces and no declarative surface');
	for (const [index, [name, entrypoint]] of surfaceContracts.entries()) {
		const surface = api.surfaces[index];
		if (surface?.name !== name || surface?.entrypoint !== entrypoint) throw new Error(`Invalid or declarative surface: ${surface?.name || '<missing>'}`);
	}
	const ids = new Set();
	const routes = new Set();
	for (const module of api.modules) {
		if (!module.name || !Array.isArray(module.declarations)) throw new Error('Invalid module');
		for (const declaration of module.declarations) {
			if (!declaration.id || ids.has(declaration.id)) throw new Error(`Duplicate declaration id: ${declaration.id}`);
			if (declaration.module !== module.name || !declaration.slug || !declaration.sourceUri || !declaration.signature) throw new Error(`Incomplete declaration: ${declaration.id}`);
			if (!Array.isArray(declaration.surfaces) || !declaration.surfaces.length) throw new Error(`Declaration has no surface: ${declaration.id}`);
			if (declaration.primarySurface !== declaration.surfaces[0]) throw new Error(`Invalid primary surface: ${declaration.id}`);
			if (declaration.surfaces.some((surface) => !labels[surface])) throw new Error(`Invalid or declarative declaration surface: ${declaration.id}`);
			ids.add(declaration.id);
			const route = declarationRoute(declaration);
			if (routes.has(route)) throw new Error(`Duplicate declaration route: ${route}`);
			routes.add(route);
		}
	}
}

function write(relativePath, content) {
	const target = path.join(output, relativePath);
	fs.mkdirSync(path.dirname(target), { recursive: true });
	fs.writeFileSync(target, content);
}

function page(relativePath, title, content, sourcePath = '') {
	write(relativePath, shell({
		title,
		content,
		active: path.posix.dirname(relativePath),
		sourcePath,
	}));
}

function main() {
	validateManifest();

	// 在清理舊產物前確認所有必要來源與文章可解析，避免發布不完整網站。
	const renderedDocuments = documents.map((document) => {
		const sourcePath = path.join(root, document.source);
		if (!fs.existsSync(sourcePath)) throw new Error(`Missing required document: ${document.source}`);
		const content = renderMarkdown(fs.readFileSync(sourcePath, 'utf8'), { ...document, routes: documentRoutes });
		return { ...document, ...content };
	});

	// 步驟 1：清理並建立可重建的網站輸出與靜態資產。
	if (output !== path.join(root, 'build', 'reference-site')) throw new Error('Unsafe output path');
	fs.rmSync(output, { recursive: true, force: true });
	fs.mkdirSync(path.join(output, 'assets'), { recursive: true });
	for (const asset of ['site.css', 'site.js']) fs.copyFileSync(path.join(root, 'tool', 'reference_site', 'static', asset), path.join(output, 'assets', asset));

	const search = [];
	const apiModules = api.modules.map((module) => ({
		name: module.name,
		href: `${moduleRoute(module.name)}/index.html`,
		declarationCount: module.declarations.length,
	}));
	const apiDeclarations = [];
	const surfaceByName = new Map(api.surfaces.map((surface) => [surface.name, surface]));

	// 步驟 2：依 module 產生 canonical declaration 與索引頁。
	for (const module of api.modules) {
		for (const declaration of module.declarations) {
			const href = declarationRoute(declaration);
			const surfaceList = declaration.surfaces.map((name) => {
				const surface = surfaceByName.get(name);
				return `<li><strong>${escapeHtml(labels[name])}</strong><br><code>${escapeHtml(surface.entrypoint)}</code></li>`;
			}).join('');
			const relationships = [
				declaration.typeRelationships?.extends ? `<li><strong>extends</strong> <code>${escapeHtml(declaration.typeRelationships.extends)}</code></li>` : '',
				...(declaration.typeRelationships?.mixins || []).map((item) => `<li><strong>with / on</strong> <code>${escapeHtml(item)}</code></li>`),
				...(declaration.typeRelationships?.implements || []).map((item) => `<li><strong>implements</strong> <code>${escapeHtml(item)}</code></li>`),
			].filter(Boolean).join('');
			const members = declaration.members.length
				? declaration.members.map((member) => `<section class="member"><h3 id="${escapeHtml(slug(`${member.kind}-${member.name}`))}">${escapeHtml(member.name || member.kind)}</h3><span class="badge">${escapeHtml(member.kind)}</span><pre><code>${escapeHtml(member.signature)}</code></pre>${member.documentation ? `<p>${escapeHtml(member.documentation)}</p>` : ''}</section>`).join('')
				: '<p>此宣告沒有自行定義的 public member。</p>';
			page(href, declaration.name, `<div class="eyebrow">${escapeHtml(module.name)} · ${escapeHtml(declaration.kind)} · ${escapeHtml(labels[declaration.primarySurface])}</div><h1>${escapeHtml(declaration.name)}</h1>${declaration.documentation ? `<p class="lead">${escapeHtml(declaration.documentation)}</p>` : ''}<h2 id="surfaces">公開入口</h2><ul>${surfaceList}</ul><h2 id="signature">公開簽名</h2><pre><code>${escapeHtml(declaration.signature)}</code></pre><h2 id="source">來源</h2><p><code>${escapeHtml(declaration.sourceUri)}</code></p>${relationships ? `<h2 id="relationships">型別關係</h2><ul>${relationships}</ul>` : ''}<h2 id="members">Public members</h2>${members}`);
			apiDeclarations.push({ id: declaration.id, name: declaration.name, module: declaration.module, kind: declaration.kind, href, surfaces: declaration.surfaces });
			search.push({ title: declaration.name, category: 'API', apiId: declaration.id, href, module: declaration.module, surfaces: declaration.surfaces });
		}
	}
	for (const module of api.modules) {
		const href = `${moduleRoute(module.name)}/index.html`;
		const items = module.declarations.length
			? module.declarations.map((declaration) => `<li><a href="${escapeHtml(declaration.slug)}.html"><code>${escapeHtml(declaration.name)}</code></a><span>${escapeHtml(declaration.kind)} · ${declaration.surfaces.map((surface) => escapeHtml(surface)).join(' · ')}</span></li>`).join('')
			: '<li><span>目前三個 public surfaces 沒有直接匯出。</span></li>';
		page(href, module.name, `<div class="eyebrow">MODULE</div><h1><code>${escapeHtml(module.name)}</code></h1><p class="lead">${module.declarations.length} 個 canonical 公開宣告。</p><ul class="api-list">${items}</ul>`);
	}

	// 步驟 3：產生 API 首頁、產品文件、搜尋與部署 manifest。
	const surfaceCards = api.surfaces.map((surface) => `<article class="card"><span class="badge">${escapeHtml(labels[surface.name])}</span><h2>${escapeHtml(surface.name)}</h2><code>${escapeHtml(surface.entrypoint)}</code></article>`).join('');
	const moduleCards = api.modules.map((module) => `<a class="card link-card" href="${escapeHtml(`${module.name.replaceAll('.', '/')}/index.html`)}"><span class="badge">${module.declarations.length} APIs</span><h2>${escapeHtml(module.name)}</h2></a>`).join('');
	page('docs/api/index.html', 'API Reference', `<div class="eyebrow">PUBLIC API</div><h1>Thin Design System Reference</h1><p class="lead">新產品從 foundation 與 theme 開始；experimental 明確分區。以下內容完全來自三個公開 Dart barrels，不包含 declarative 或 private runtime。</p><div class="grid">${surfaceCards}</div><h2 id="modules">Modules</h2><div class="grid">${moduleCards}</div>`);

	const guideLinks = [];
	for (const document of renderedDocuments) {
		const {source, href, title, category, html, body} = document;
		page(href, title, html, source);
		guideLinks.push(`<li><a href="${escapeHtml(relative('docs/index.html', href))}">${escapeHtml(title)}</a></li>`);
		search.push({ /* source／href 為唯一文件對照；title／category 是導覽，body 用於內容搜尋。 */ title, category, href, source, body });
	}
	const componentDeclarations = api.modules.flatMap((module) => module.declarations).filter((item) => ['class', 'abstractClass', 'baseClass', 'finalClass', 'interfaceClass', 'sealedClass', 'mixinClass'].includes(item.kind));
	page('docs/components/index.html', 'Components', `<div class="eyebrow">COMPONENTS</div><h1>公開型別</h1><p class="lead">依實際 public surface 產生；詳細 constructor 與 member 請進入 API 頁。</p><ul class="api-list">${componentDeclarations.map((item) => `<li><a href="${escapeHtml(relative('docs/components/index.html', declarationRoute(item)))}"><code>${escapeHtml(item.name)}</code></a><span>${escapeHtml(item.module)} · ${item.surfaces.map((surface) => escapeHtml(surface)).join(' · ')}</span></li>`).join('')}</ul>`);
	page('docs/index.html', 'Documentation', `<div class="eyebrow">DOCUMENTATION</div><h1>產品組合權，設計系統品質</h1><p class="lead">Kallopis 以通用視覺語意與 token 維持一致；各框架庫依規範實作，產品擁有畫面、導航與流程。</p><div class="actions"><a class="button primary" href="design-system/index.html">通用視覺規範</a><a class="button secondary" href="${escapeHtml(relative('docs/index.html', 'docs/api/index.html'))}">Flutter API</a><a class="button secondary" href="${escapeHtml(relative('docs/index.html', 'docs/components/index.html'))}">公開型別</a></div><h2>Current guides</h2><ul>${guideLinks.join('')}</ul>`);
	write('index.html', homePage({
		apiCount: apiDeclarations.length,
		moduleCount: api.modules.length,
	}));
	write('search-index.json', `${JSON.stringify(search, null, '\t')}\n`);
	write('site-manifest.json', `${JSON.stringify({ surfaces: api.surfaces, apiModules, apiDeclarations, guides: documents.map(({source}) => source), documents }, null, '\t')}\n`);
	console.log(`Generated ${apiDeclarations.length} canonical API pages across ${api.modules.length} modules.`);
}

main();
