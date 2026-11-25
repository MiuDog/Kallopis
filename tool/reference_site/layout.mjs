import { readFileSync } from 'node:fs';
import { join } from 'node:path';

const publicSiteBody = readFileSync(join(import.meta.dirname, 'static/public-site-body.html'), 'utf8');

const escapeHtml = value => String(value)
	.replaceAll('&', '&amp;')
	.replaceAll('<', '&lt;')
	.replaceAll('>', '&gt;')
	.replaceAll('"', '&quot;');

function head(title, prefix) {
	return `<!doctype html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="description" content="Kallopis 跨框架設計系統：一套語意風格驅動多種視覺氣質，兼顧長時閱讀舒適度與工作台互動秩序。"><title>${escapeHtml(title)} · Kallopis</title><link rel="stylesheet" href="${prefix}assets/site.css?v=showcase-4"></head>`;
}

function header(prefix, section = 'docs') {
	const nav = [
		`<a href="${prefix}index.html" ${section === 'home' ? 'aria-current="page"' : ''}>主頁</a>`,
		`<a href="${prefix}showcase.html" ${section === 'showcase' ? 'aria-current="page"' : ''}>風格示範</a>`,
		`<a href="${prefix}components.html" ${section === 'components' ? 'aria-current="page"' : ''}>元件表</a>`,
		`<a href="${prefix}docs/index.html" ${section === 'docs' ? 'aria-current="page"' : ''}>文件參考</a>`,
	].join('');
	return `<a class="skip-link" href="#main-content">跳至主要內容</a><header class="topbar"><a class="brand" href="${prefix}index.html"><span class="brand-mark" aria-hidden="true">K</span>Kallopis</a><nav aria-label="主要導覽">${nav}</nav><div class="header-actions"><details class="appearance"><summary aria-label="風格設定">風格</summary><div class="appearance-menu"><label>明暗模式<select data-preference="theme"><option value="light">淺色</option><option value="dark">深色</option></select></label><label>框架色調<select data-preference="tone"><option value="warm">暖灰</option><option value="neutral">中性灰</option></select></label><label class="check-label">內容微浮陰影<input type="checkbox" data-preference="lift" checked></label><small>風格 v1.0.0</small></div></details><a class="button primary header-cta" href="${prefix}showcase.html">風格示範 <span aria-hidden="true">↗</span></a></div></header>`;
}

function footer(prefix) {
	return `<footer class="footer"><a class="brand" href="${prefix}index.html">Kallopis</a><span>-ist family · design system</span><a href="https://github.com/MiuDog/Kallopis">GitHub ↗</a><span>Style 1.0.0</span></footer>`;
}

function scripts(prefix) {
	return `<script src="${prefix}assets/site.js" defer></script></body></html>`;
}

export function shell({title, content, active = '', sourcePath = ''}) {
	const prefix = '../'.repeat(active.split('/').filter(Boolean).length);
	const source = sourcePath
		? `<a class="source-link" href="https://github.com/MiuDog/Kallopis/blob/main/${escapeHtml(sourcePath)}">查看 Markdown 原文 ↗</a>`
		: '';
	return `${head(title, prefix)}<body data-root="${prefix}" data-page="docs">${header(prefix, 'docs')}<div class="docs-workspace"><aside class="navigator"><details class="doc-navigation" open><summary>文件導覽</summary><div class="nav-content"><label class="search-label" for="search">搜尋文件</label><input id="search" type="search" placeholder="token、配方、元件、API…" autocomplete="off"><p id="search-status" role="status" aria-live="polite"></p><nav id="navigation" aria-label="文件目錄"><a href="${prefix}docs/index.html">文件中心</a><a href="${prefix}docs/design-system/index.html">通用視覺規範</a><a href="${prefix}docs/reference/flutter/index.html">Flutter Reference</a><a href="${prefix}docs/reference/react/index.html">React Reference</a><a href="${prefix}docs/examples/index.html">畫面範例</a></nav></div></details></aside><main id="main-content" class="document-frame"><div class="document-bar"><a href="${prefix}docs/index.html">文件</a><span aria-hidden="true">/</span><span>${escapeHtml(title)}</span>${source}</div><article class="prose">${content}</article><div class="document-end"><span>由目前公開 API 與文件來源產生</span><a href="#main-content">回到頁首 ↑</a></div></main><aside class="toc"><span class="eyebrow">本頁內容</span><nav id="page-toc" aria-label="本頁段落"></nav></aside></div>${footer(prefix)}${scripts(prefix)}`;
}

// 正式公開站台入口（全外部樣式表、零內嵌 style、嵌入正式框架元件 bundle）
function renderPublicSitePage({title, initialRoute}) {
	return `<!doctype html>
<html lang="en" data-klp-theme="kallopis-v1" data-klp-mode="light" data-klp-lang="en" data-klp-initial-route="${escapeHtml(initialRoute)}">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="Kallopis cross-framework design system: governed style constraints, cross-framework components, versioned style packs, and AI Skills.">
	<title>${escapeHtml(title)}</title>
	<link rel="icon" href="styles/images/kallopis-logo.svg" type="image/svg+xml">
	<link rel="stylesheet" href="styles/themes/kallopis-v1.css">
	<link rel="stylesheet" href="assets/klp-styles.css">
	<link rel="stylesheet" href="assets/theme-surfaces.css">
	<link rel="stylesheet" href="assets/public-site.css">
</head>
<body>
${publicSiteBody}
	<script src="assets/public-site.js" defer></script>
</body>
</html>`;
}

export function homePage() {
	return renderPublicSitePage({title: 'Kallopis · Universal UI Styling Foundation', initialRoute: 'home'});
}

export function showcasePage() {
	return renderPublicSitePage({title: 'Component Preview · Kallopis', initialRoute: 'style-preview'});
}

export function componentsPage() {
	return renderPublicSitePage({title: 'References · Kallopis', initialRoute: 'docs'});
}
