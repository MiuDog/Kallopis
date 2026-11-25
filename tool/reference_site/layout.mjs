const escapeHtml = value => String(value)
	.replaceAll('&', '&amp;')
	.replaceAll('<', '&lt;')
	.replaceAll('>', '&gt;')
	.replaceAll('"', '&quot;');

function head(title, prefix) {
	return `<!doctype html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="description" content="Kallopis：-ist 產品家族共用的跨框架 design system。閱讀通用視覺規範與各框架文件。"><title>${escapeHtml(title)} · Kallopis</title><link rel="stylesheet" href="${prefix}assets/site.css?v=showcase-2"></head>`;
}

function header(prefix, home, interactive = false) {
	const nav = home && interactive
		? `<a href="#ide">互動 IDE</a><a href="#themes">風格主題</a><a href="#catalog">元件 Catalog</a><a href="${prefix}docs/index.html">文件</a><a href="${prefix}docs/api/index.html">API</a>`
		: `<a href="${prefix}index.html#framework">設計系統</a><a href="${prefix}docs/index.html" ${home ? '' : 'aria-current="page"'}>文件</a><a href="${prefix}docs/api/index.html">API</a>`;
	return `<a class="skip-link" href="#main-content">跳至主要內容</a><header class="topbar"><a class="brand" href="${prefix}index.html"><span class="brand-mark" aria-hidden="true">K</span>Kallopis</a><nav aria-label="主要導覽">${nav}</nav><div class="header-actions"><details class="appearance"><summary aria-label="風格設定">風格</summary><div class="appearance-menu"><label>明暗模式<select data-preference="theme"><option value="light">淺色</option><option value="dark">深色</option></select></label><label>框架色調<select data-preference="tone"><option value="warm">暖灰</option><option value="neutral">中性灰</option></select></label><label class="check-label">內容微浮陰影<input type="checkbox" data-preference="lift" checked></label><small>風格 v1.0.0</small></div></details><a class="button primary header-cta" href="${prefix}docs/index.html">開始使用 <span aria-hidden="true">↗</span></a></div></header>`;
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
	return `${head(title, prefix)}<body data-root="${prefix}" data-page="docs">${header(prefix, false)}<div class="docs-workspace"><aside class="navigator"><details class="doc-navigation" open><summary>文件導覽</summary><div class="nav-content"><label class="search-label" for="search">搜尋文件</label><input id="search" type="search" placeholder="token、配方、元件、API…" autocomplete="off"><p id="search-status" role="status" aria-live="polite"></p><nav id="navigation" aria-label="文件目錄"><a href="${prefix}docs/index.html">文件中心</a><a href="${prefix}docs/design-system/index.html">通用視覺規範</a><a href="${prefix}docs/reference/flutter/index.html">Flutter Reference</a><a href="${prefix}docs/reference/react/index.html">React Reference</a><a href="${prefix}docs/examples/index.html">畫面範例</a></nav></div></details></aside><main id="main-content" class="document-frame"><div class="document-bar"><a href="${prefix}docs/index.html">文件</a><span aria-hidden="true">/</span><span>${escapeHtml(title)}</span>${source}</div><article class="prose">${content}</article><div class="document-end"><span>由目前公開 API 與文件來源產生</span><a href="#main-content">回到頁首 ↑</a></div></main><aside class="toc"><span class="eyebrow">本頁內容</span><nav id="page-toc" aria-label="本頁段落"></nav></aside></div>${footer(prefix)}${scripts(prefix)}`;
}

function renderThemeCard(theme) {
	const lightDots = (theme.palettePreview?.light ?? []).map(color => `<span class="theme-swatch-dot" style="background:${escapeHtml(color)}" title="${escapeHtml(color)}"></span>`).join('');
	const darkDots = (theme.palettePreview?.dark ?? []).map(color => `<span class="theme-swatch-dot" style="background:${escapeHtml(color)}" title="${escapeHtml(color)}"></span>`).join('');
	const orbDots = (theme.orbs ?? []).map(color => `<span class="theme-swatch-dot" style="background:${escapeHtml(color)}" title="Orb ${escapeHtml(color)}"></span>`).join('');
	const sourceLink = theme.sourceReference?.startsWith('https://')
		? `<a class="text-link" href="${escapeHtml(theme.sourceReference)}" target="_blank" rel="noopener">設計來源 ↗</a>`
		: '';
	return `<article class="theme-card">
		<div class="theme-preview-wrap"><img class="theme-preview-img" src="${escapeHtml(theme.previewImage)}" alt="${escapeHtml(theme.name)} 風格預覽" loading="lazy"></div>
		<div class="theme-card-body">
			<div class="theme-card-head"><div><span class="eyebrow">${escapeHtml(theme.englishName)}</span><h3>${escapeHtml(theme.name)}</h3></div><span class="badge">${escapeHtml(theme.id)} · v${escapeHtml(theme.version)}</span></div>
			<p class="theme-card-desc">${escapeHtml(theme.description)}</p>
			<div class="theme-meta"><span>字型：${escapeHtml(theme.typography)}</span></div>
			<div class="theme-swatches"><div><small>Light</small><div class="theme-dot-row">${lightDots}</div></div><div><small>Dark</small><div class="theme-dot-row">${darkDots}</div></div>${orbDots ? `<div><small>Orbs</small><div class="theme-dot-row">${orbDots}</div></div>` : ''}</div>
			<div class="theme-card-actions">
				<button class="button primary" type="button" data-copy-css="${escapeHtml(theme.cssPath)}" data-theme-name="${escapeHtml(theme.name)}">複製 CSS Tokens</button>
				<a class="button secondary" href="${escapeHtml(theme.packPath)}" download>下載 JSON ↓</a>
				<a class="button secondary" href="${escapeHtml(theme.cssPath)}" target="_blank" rel="noopener">檢視 CSS ↗</a>
			</div>
			${sourceLink}
		</div>
	</article>`;
}

export function homePage({apiCount = 0, moduleCount = 0, interactive = false, themes = [], reactCount = 0} = {}) {
	if (interactive) return `${head('元件與風格互動展示', '')}<body data-root="" data-page="home">${header('', true, true)}<main id="main-content" class="showcase-home">
		<section id="framework" class="showcase-intro">
			<div>
				<p class="showcase-kicker">KALLOPIS DESIGN SYSTEM · CENTRALIZED STYLES &amp; LIVE COMPONENTS</p>
				<h1>實際操作元件，切換風格並直接複製使用。</h1>
				<p class="showcase-description">風格設定集中於根目錄 <code>styles/themes/</code>，布局與風格完全分離。直接在下方切換「微立體」、「現代簡約風」與「暖紙預設」，檢視所有元件屬性並複製 CSS tokens。</p>
			</div>
			<div class="showcase-actions">
				<a class="button primary" href="#ide">互動 IDE 工作台 ↓</a>
				<a class="button secondary" href="#catalog">元件 Catalog（${reactCount}）↓</a>
				<a class="button secondary" href="docs/flutter/scenarios/index.html">Flutter 展示 ↗</a>
				<a class="button secondary" href="docs/index.html">文件與 API ↗</a>
			</div>
		</section>

		<section id="ide" class="showcase-section" aria-label="互動 IDE 工作台">
			<div class="showcase-section-head">
				<div><span class="eyebrow">01 / INTERACTIVE IDE WORKBENCH</span><h2>可切換風格的互動 IDE 樣本</h2></div>
				<div class="showcase-actions">
					<a class="button secondary" href="examples/react/index.html?scenario=ide" target="_blank" rel="noopener">獨立視窗開啟 ↗</a>
					<a class="button secondary" href="styles/examples/ide-workbench/index.html" target="_blank" rel="noopener">純 HTML 可複製版 ↗</a>
				</div>
			</div>
			<div class="showcase-panel">
				<div class="showcase-panel-bar"><div><span class="showcase-dot" aria-hidden="true"></span><strong>互動 IDE 工作台</strong><span class="showcase-platform">React · 支援即時切換風格與面板</span></div><a href="examples/react/index.html?scenario=ide" target="_blank" rel="noopener">獨立開啟 ↗</a></div>
				<iframe title="Kallopis 互動 IDE 工作台展示" src="examples/react/index.html?scenario=ide" loading="lazy"></iframe>
			</div>
		</section>

		<section id="themes" class="showcase-section" aria-label="風格主題與查詢複製">
			<div class="showcase-section-head">
				<div><span class="eyebrow">02 / CENTRALIZED STYLE THEMES</span><h2>風格主題庫 · 查詢並複製 Token</h2></div>
				<p id="theme-copy-status" class="showcase-status" role="status" aria-live="polite">點選任一風格即可複製 <code>--klp-*</code> CSS 變數，無須匯入框架元件庫。</p>
			</div>
			<div class="theme-gallery">${themes.map(renderThemeCard).join('')}</div>
		</section>

		<section id="catalog" class="showcase-section" aria-label="所有元件 Catalog 與屬性">
			<div class="showcase-section-head">
				<div><span class="eyebrow">03 / COMPONENT CATALOG &amp; PROPS</span><h2>所有公開元件 Catalog 與屬性（${reactCount}）</h2></div>
				<div class="showcase-actions">
					<a class="button secondary" href="examples/react/index.html?catalog=desktop" target="_blank" rel="noopener">獨立開啟 Catalog ↗</a>
					<a class="button secondary" href="docs/react/components/index.html">逐頁檢視元件 ↗</a>
				</div>
			</div>
			<div class="showcase-panel">
				<div class="showcase-panel-bar"><div><span class="showcase-dot" aria-hidden="true"></span><strong>元件 Catalog 與 Props / Token 對應</strong><span class="showcase-platform">React · 即時風格切換</span></div><a href="examples/react/index.html?catalog=desktop" target="_blank" rel="noopener">獨立開啟 ↗</a></div>
				<iframe title="Kallopis 元件 Catalog 與屬性一覽" src="examples/react/index.html?catalog=desktop" loading="lazy"></iframe>
			</div>
		</section>

		<nav class="showcase-resources" aria-label="設計資源與文件">
			<a href="docs/react/scenarios/index.html"><strong>組合場景 ↗</strong><span>IDE、VS Code、Blockbench、Blender</span></a>
			<a href="docs/flutter/scenarios/index.html"><strong>Flutter 展示 ↗</strong><span>Flutter Web 真實工作台</span></a>
			<a href="styles/component-bindings.json"><strong>Token 自動對應 ↗</strong><span>Semantic ID · CSS · Flutter 對照</span></a>
			<a href="docs/api/index.html"><strong>Reference &amp; API ↗</strong><span>${moduleCount} modules · ${apiCount} canonical APIs</span></a>
		</nav>
	</main>${footer('')}${scripts('')}`;
	return `${head('介面有秩序，產品有自由', '')}<body data-root="" data-page="home">${header('', true)}<main id="main-content" class="home-main">
		<section class="hero"><div class="eyebrow">THE DESIGN SYSTEM OF THE -IST FAMILY</div><h1>讓產品自由組合。<br><span>讓介面保持一致。</span></h1><p class="hero-copy">Kallopis 定義通用視覺語意、token 與元件組合；各框架庫實作一致的設計契約。<br class="desktop-break">產品保有畫面、導航與流程的完整所有權。</p><div class="hero-actions"><a class="button primary" href="docs/index.html">閱讀文件 <span aria-hidden="true">↗</span></a><a class="button secondary" href="docs/components/index.html">探索元件</a></div><p class="release-line">風格 v1.0.0 <span>·</span> Cross-framework Design System</p>
			<div class="workspace-preview" aria-label="Kallopis 工作區視覺示意"><div class="preview-heading"><span>Kallopis / Workspace</span><span>FOUNDATION</span></div><div class="preview-grid"><aside class="preview-sidebar"><span class="eyebrow">PUBLIC SURFACES</span><div class="preview-folder">▾ Kallopis</div><a class="preview-item selected" href="docs/api/index.html">Foundation <span>01</span></a><a class="preview-item" href="docs/api/index.html">Theme <span>02</span></a><a class="preview-item" href="docs/api/index.html">Experimental <span>03</span></a><div class="preview-sidebar-end">${moduleCount} modules<br>${apiCount} canonical APIs。</div></aside><section class="preview-stage"><div class="preview-stage-heading"><span>產品組合</span><span>COMPONENTS / STYLE</span></div><div class="preview-content"><article class="paper preview-paper"><span class="paper-meta">PRODUCT WORKSPACE / 01</span><h2>有秩序，也有空間。</h2><p>產品安排畫面，設計系統維持共用視覺與互動品質。</p><div class="node-chain"><span>Theme</span><span aria-hidden="true">→</span><span>Components</span><span aria-hidden="true">→</span><span>Product UI</span></div></article><div class="preview-memos"><article class="paper memo yellow"><span class="paper-meta">COMPOSITION</span><p>產品擁有布局與流程。<br>Kallopis 提供可重用元件。</p></article><article class="paper memo sage"><span class="paper-meta">STYLE 1.0.0</span><p>平整的結構表面。<br>可選的紙片微浮。</p></article></div></div></section></div></div>
		</section>
		<section id="framework" class="feature-section"><div class="feature-copy"><span class="eyebrow">01 / COMPOSE</span><h2>共享元件品質，<br>保留產品組合權。</h2><p>產品直接使用 Flutter 組合 Kallopis 元件，自己掌管畫面結構、導航與業務狀態；元件內部的視覺、鍵盤、hover、focus 與 accessibility 由 Kallopis 維護。</p><a class="text-link" href="docs/guides/docs-ai-product-usage.html">閱讀產品使用指南 ↗</a></div><div class="code-paper paper"><div class="code-caption">PUBLIC ENTRY <span>DART</span></div><pre><code><span class="syntax-keyword">import</span> 'package:kallopis/kallopis_foundation.dart';</code></pre><ol class="flow-list"><li><span>01</span><div><strong>Kallopis theme</strong><small>共用 semantic style 來源</small></div></li><li><span>02</span><div><strong>Public Flutter components</strong><small>共用視覺與互動能力</small></div></li><li><span>03</span><div><strong>Product-owned Widget tree</strong><small>產品決定布局、導航與流程</small></div></li></ol></div></section>
		<section class="feature-section reverse"><div class="style-study"><div class="style-swatches" aria-label="風格表面"><span class="swatch app-swatch">App</span><span class="swatch side-swatch">Sidebar</span><span class="swatch main-swatch">Content</span></div><article class="paper style-note"><span class="paper-meta">MATERIAL / PAPER</span><h3>一套風格，<br>各自負責的表面。</h3><p>結構保持平整，獨立內容才決定是否浮起。</p></article><span class="style-caption">COLOR · PADDING · RADIUS · SHADOW</span></div><div class="feature-copy"><span class="eyebrow">02 / RESOLVE</span><h2>讓風格有來源，<br>讓改動能傳遞。</h2><p>字型、色彩、間距與 icon 經由 semantic theme 統一解析。暖灰是起點；明暗、色調與內容陰影各有自己的責任。</p><a class="text-link" href="docs/design-system/index.html">查看通用視覺規範 ↗</a></div></section>
		<section class="documentation-section"><div><span class="eyebrow">03 / UNDERSTAND</span><h2>文件就在下一頁。</h2><p>從產品組合方式，到每個公開 class 的 API。</p></div><div class="doc-doors"><a href="docs/index.html"><span class="door-number">01</span><h3>開始使用 <span>↗</span></h3><p>入口、責任與產品組合方式。</p></a><a href="docs/components/index.html"><span class="door-number">02</span><h3>公開型別 <span>↗</span></h3><p>依現行 public surface 產生。</p></a><a href="docs/api/index.html"><span class="door-number">03</span><h3>API Reference <span>↗</span></h3><p>${apiCount} 個 canonical 公開宣告。</p></a></div><a class="button primary" href="docs/index.html">進入文件中心 ↗</a></section>
	</main>${footer('')}${scripts('')}`;
}
