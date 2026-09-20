const escapeHtml = value => String(value)
	.replaceAll('&', '&amp;')
	.replaceAll('<', '&lt;')
	.replaceAll('>', '&gt;')
	.replaceAll('"', '&quot;');

function head(title, prefix) {
	return `<!doctype html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="description" content="Kallopis：-ist 產品家族共用的 Flutter design system。閱讀產品指南、公開元件與 API reference。"><title>${escapeHtml(title)} · Kallopis</title><link rel="stylesheet" href="${prefix}assets/site.css"></head>`;
}

function header(prefix, home) {
	return `<a class="skip-link" href="#main-content">跳至主要內容</a><header class="topbar"><a class="brand" href="${prefix}index.html"><span class="brand-mark" aria-hidden="true">K</span>Kallopis</a><nav aria-label="主要導覽"><a href="${prefix}index.html#framework">設計系統</a><a href="${prefix}docs/index.html" ${home ? '' : 'aria-current="page"'}>文件</a><a href="${prefix}docs/api/index.html">API</a></nav><div class="header-actions"><details class="appearance"><summary aria-label="風格設定">風格</summary><div class="appearance-menu"><label>明暗模式<select data-preference="theme"><option value="light">淺色</option><option value="dark">深色</option></select></label><label>框架色調<select data-preference="tone"><option value="warm">暖灰</option><option value="neutral">中性灰</option></select></label><label class="check-label">內容微浮陰影<input type="checkbox" data-preference="lift" checked></label><small>風格 v1.0.0</small></div></details><a class="button primary header-cta" href="${prefix}docs/index.html">開始使用 <span aria-hidden="true">↗</span></a></div></header>`;
}

function footer(prefix) {
	return `<footer class="footer"><a class="brand" href="${prefix}index.html">Kallopis</a><span>-ist family · Flutter design system</span><a href="https://github.com/MiuDog/Kallopis">GitHub ↗</a><span>Style 1.0.0</span></footer>`;
}

function scripts(prefix) {
	return `<script src="${prefix}assets/site.js" defer></script></body></html>`;
}

export function shell({title, content, active = '', sourcePath = ''}) {
	const prefix = '../'.repeat(active.split('/').filter(Boolean).length);
	const source = sourcePath
		? `<a class="source-link" href="https://github.com/MiuDog/Kallopis/blob/main/${escapeHtml(sourcePath)}">查看 Markdown 原文 ↗</a>`
		: '';
	return `${head(title, prefix)}<body data-root="${prefix}" data-page="docs">${header(prefix, false)}<div class="docs-workspace"><aside class="navigator"><details class="doc-navigation" open><summary>文件導覽</summary><div class="nav-content"><label class="search-label" for="search">搜尋文件</label><input id="search" type="search" placeholder="元件、module、API…" autocomplete="off"><p id="search-status" role="status" aria-live="polite"></p><nav id="navigation" aria-label="文件目錄"><a href="${prefix}docs/index.html">文件中心</a><a href="${prefix}docs/components/index.html">公開型別</a><a href="${prefix}docs/api/index.html">API</a></nav></div></details></aside><main id="main-content" class="document-frame"><div class="document-bar"><a href="${prefix}docs/index.html">文件</a><span aria-hidden="true">/</span><span>${escapeHtml(title)}</span>${source}</div><article class="prose">${content}</article><div class="document-end"><span>由目前公開 API 與文件來源產生</span><a href="#main-content">回到頁首 ↑</a></div></main><aside class="toc"><span class="eyebrow">本頁內容</span><nav id="page-toc" aria-label="本頁段落"></nav></aside></div>${footer(prefix)}${scripts(prefix)}`;
}

export function homePage({apiCount = 0, moduleCount = 0} = {}) {
	return `${head('介面有秩序，產品有自由', '')}<body data-root="" data-page="home">${header('', true)}<main id="main-content" class="home-main">
		<section class="hero"><div class="eyebrow">THE DESIGN SYSTEM OF THE -IST FAMILY</div><h1>讓產品自由組合。<br><span>讓介面保持一致。</span></h1><p class="hero-copy">Kallopis 為 Flutter 提供 semantic theme、共用元件與一致的互動品質。<br class="desktop-break">產品保有 Widget tree、導航與流程的完整所有權。</p><div class="hero-actions"><a class="button primary" href="docs/index.html">閱讀文件 <span aria-hidden="true">↗</span></a><a class="button secondary" href="docs/components/index.html">探索元件</a></div><p class="release-line">風格 v1.0.0 <span>·</span> Flutter Design System</p>
			<div class="workspace-preview" aria-label="Kallopis 工作區視覺示意"><div class="preview-heading"><span>Kallopis / Workspace</span><span>FOUNDATION</span></div><div class="preview-grid"><aside class="preview-sidebar"><span class="eyebrow">PUBLIC SURFACES</span><div class="preview-folder">▾ Kallopis</div><a class="preview-item selected" href="docs/api/index.html">Foundation <span>01</span></a><a class="preview-item" href="docs/api/index.html">Theme <span>02</span></a><a class="preview-item" href="docs/api/index.html">Experimental <span>03</span></a><div class="preview-sidebar-end">${moduleCount} modules<br>${apiCount} canonical APIs。</div></aside><section class="preview-stage"><div class="preview-stage-heading"><span>產品組合</span><span>COMPONENTS / STYLE</span></div><div class="preview-content"><article class="paper preview-paper"><span class="paper-meta">PRODUCT WORKSPACE / 01</span><h2>有秩序，也有空間。</h2><p>產品安排畫面，設計系統維持共用視覺與互動品質。</p><div class="node-chain"><span>Theme</span><span aria-hidden="true">→</span><span>Components</span><span aria-hidden="true">→</span><span>Product UI</span></div></article><div class="preview-memos"><article class="paper memo yellow"><span class="paper-meta">COMPOSITION</span><p>產品擁有布局與流程。<br>Kallopis 提供可重用元件。</p></article><article class="paper memo sage"><span class="paper-meta">STYLE 1.0.0</span><p>平整的結構表面。<br>可選的紙片微浮。</p></article></div></div></section></div></div>
		</section>
		<section id="framework" class="feature-section"><div class="feature-copy"><span class="eyebrow">01 / COMPOSE</span><h2>共享元件品質，<br>保留產品組合權。</h2><p>產品直接使用 Flutter 組合 Kallopis 元件，自己掌管畫面結構、導航與業務狀態；元件內部的視覺、鍵盤、hover、focus 與 accessibility 由 Kallopis 維護。</p><a class="text-link" href="docs/guides/docs-ai-product-usage.html">閱讀產品使用指南 ↗</a></div><div class="code-paper paper"><div class="code-caption">PUBLIC ENTRY <span>DART</span></div><pre><code><span class="syntax-keyword">import</span> 'package:kallopis/kallopis_foundation.dart';</code></pre><ol class="flow-list"><li><span>01</span><div><strong>Kallopis theme</strong><small>共用 semantic style 來源</small></div></li><li><span>02</span><div><strong>Public Flutter components</strong><small>共用視覺與互動能力</small></div></li><li><span>03</span><div><strong>Product-owned Widget tree</strong><small>產品決定布局、導航與流程</small></div></li></ol></div></section>
		<section class="feature-section reverse"><div class="style-study"><div class="style-swatches" aria-label="風格表面"><span class="swatch app-swatch">App</span><span class="swatch side-swatch">Sidebar</span><span class="swatch main-swatch">Content</span></div><article class="paper style-note"><span class="paper-meta">MATERIAL / PAPER</span><h3>一套風格，<br>各自負責的表面。</h3><p>結構保持平整，獨立內容才決定是否浮起。</p></article><span class="style-caption">COLOR · PADDING · RADIUS · SHADOW</span></div><div class="feature-copy"><span class="eyebrow">02 / RESOLVE</span><h2>讓風格有來源，<br>讓改動能傳遞。</h2><p>字型、色彩、間距與 icon 經由 semantic theme 統一解析。暖灰是起點；明暗、色調與內容陰影各有自己的責任。</p><a class="text-link" href="docs/guides/spec-style-v1.html">查看風格 v1.0.0 ↗</a></div></section>
		<section class="documentation-section"><div><span class="eyebrow">03 / UNDERSTAND</span><h2>文件就在下一頁。</h2><p>從產品組合方式，到每個公開 class 的 API。</p></div><div class="doc-doors"><a href="docs/index.html"><span class="door-number">01</span><h3>開始使用 <span>↗</span></h3><p>入口、責任與產品組合方式。</p></a><a href="docs/components/index.html"><span class="door-number">02</span><h3>公開型別 <span>↗</span></h3><p>依現行 public surface 產生。</p></a><a href="docs/api/index.html"><span class="door-number">03</span><h3>API Reference <span>↗</span></h3><p>${apiCount} 個 canonical 公開宣告。</p></a></div><a class="button primary" href="docs/index.html">進入文件中心 ↗</a></section>
	</main>${footer('')}${scripts('')}`;
}
