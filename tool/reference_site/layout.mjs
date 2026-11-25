const escapeHtml = value => String(value)
	.replaceAll('&', '&amp;')
	.replaceAll('<', '&lt;')
	.replaceAll('>', '&gt;')
	.replaceAll('"', '&quot;');

function head(title, prefix) {
	return `<!doctype html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="description" content="Kallopis：-ist 產品家族共用的跨框架 design system。閱讀通用視覺規範與各框架文件。"><title>${escapeHtml(title)} · Kallopis</title><link rel="stylesheet" href="${prefix}assets/site.css?v=showcase-3"></head>`;
}

function header(prefix, section = 'docs') {
	const nav = [
		`<a href="${prefix}index.html" ${section === 'home' ? 'aria-current="page"' : ''}>主頁</a>`,
		`<a href="${prefix}showcase.html" ${section === 'showcase' ? 'aria-current="page"' : ''}>風格示範</a>`,
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
				<button class="button primary" type="button" data-copy-file="${escapeHtml(theme.cssPath)}" data-theme-name="${escapeHtml(theme.name)} CSS">複製 CSS</button>
				<a class="button secondary" href="${escapeHtml(theme.cssPath)}" download>下載 CSS ↓</a>
				<a class="button secondary" href="${escapeHtml(theme.jsPath)}" download>下載 JS ↓</a>
				<a class="button secondary" href="${escapeHtml(theme.packPath)}" download>JSON ↓</a>
			</div>
			${sourceLink}
		</div>
	</article>`;
}

export function homePage({apiCount = 0, moduleCount = 0, interactive = false, themes = [], reactCount = 0} = {}) {
	if (interactive) return `${head('跨框架設計系統與互動展示', '')}<body data-root="" data-page="home">${header('', 'home')}<main id="main-content" class="showcase-home">
		<section id="framework" class="showcase-intro">
			<div>
				<p class="showcase-kicker">KALLOPIS DESIGN SYSTEM · CENTRALIZED STYLES &amp; CROSS-FRAMEWORK COMPONENTS</p>
				<h1>風格集中管理，跨框架即時示範。</h1>
				<p class="showcase-description">根目錄 <code>styles/themes/</code> 統一維護版本化色彩、圓角、字型與複製檔案；Flutter 與 React 負責元件實作與自動對應。前往「風格示範」親自切換風格、操作全部元件與取得 CSS / JS。</p>
			</div>
			<div class="showcase-actions">
				<a class="button primary" href="showcase.html">進入風格示範 ↗</a>
				<a class="button secondary" href="docs/index.html">文件參考 ↗</a>
				<a class="button secondary" href="docs/api/index.html">API 參考（${apiCount}）</a>
			</div>
		</section>

		<section class="showcase-section" aria-label="風格預覽總覽">
			<div class="showcase-section-head">
				<div><span class="eyebrow">01 / VERSIONED THEMES</span><h2>版本化風格主題（styles/themes/）</h2></div>
				<a class="button secondary" href="showcase.html#swatches">查看全部色票與下載檔案 →</a>
			</div>
			<p id="theme-copy-status" class="showcase-status" role="status" aria-live="polite">不需匯入元件庫，即可直接複製或下載任一風格的 CSS / JS / JSON。</p>
			<div class="theme-gallery">${themes.map(renderThemeCard).join('')}</div>
		</section>

		<section class="showcase-section" aria-label="雙框架工作台示意">
			<div class="showcase-section-head">
				<div><span class="eyebrow">02 / LIVE PREVIEW</span><h2>完整頁面組合搶先看</h2></div>
				<div class="showcase-actions">
					<a class="button primary" href="showcase.html">開啟完整風格示範（${reactCount} 個元件）↗</a>
					<a class="button secondary" href="docs/flutter/scenarios/index.html">Flutter 展示 ↗</a>
				</div>
			</div>
			<div class="showcase-panel">
				<div class="showcase-panel-bar"><div><span class="showcase-dot" aria-hidden="true"></span><strong>互動 IDE 工作台</strong><span class="showcase-platform">支援微立體 / 現代簡約風 / 暖紙預設即時切換</span></div><a href="showcase.html">前往風格示範頁 →</a></div>
				<iframe title="Kallopis 首頁互動工作台預覽" src="examples/react/index.html?scenario=ide" loading="lazy"></iframe>
			</div>
		</section>

		<nav class="showcase-resources" aria-label="常用入口">
			<a href="showcase.html#composition"><strong>頁面組合範例 ↗</strong><span>完整工作台與可複製純 HTML</span></a>
			<a href="showcase.html#components"><strong>互動元件示範 ↗</strong><span>${reactCount} 個元件並列多語言程式碼</span></a>
			<a href="showcase.html#swatches"><strong>色票與 CSS / JS 下載 ↗</strong><span>全語意／原料色票一鍵複製</span></a>
			<a href="docs/index.html"><strong>文件參考 ↗</strong><span>${moduleCount} modules · ${apiCount} canonical APIs</span></a>
		</nav>
	</main>${footer('')}${scripts('')}`;
	return `${head('介面有秩序，產品有自由', '')}<body data-root="" data-page="home">${header('', 'home')}<main id="main-content" class="home-main">
		<section class="hero"><div class="eyebrow">THE DESIGN SYSTEM OF THE -IST FAMILY</div><h1>讓產品自由組合。<br><span>讓介面保持一致。</span></h1><p class="hero-copy">Kallopis 定義通用視覺語意、token 與元件組合；各框架庫實作一致的設計契約。<br class="desktop-break">產品保有畫面、導航與流程的完整所有權。</p><div class="hero-actions"><a class="button primary" href="showcase.html">風格示範 <span aria-hidden="true">↗</span></a><a class="button secondary" href="docs/index.html">文件參考</a></div><p class="release-line">風格 v1.0.0 <span>·</span> Cross-framework Design System</p>
			<div class="workspace-preview" aria-label="Kallopis 工作區視覺示意"><div class="preview-heading"><span>Kallopis / Workspace</span><span>FOUNDATION</span></div><div class="preview-grid"><aside class="preview-sidebar"><span class="eyebrow">PUBLIC SURFACES</span><div class="preview-folder">▾ Kallopis</div><a class="preview-item selected" href="docs/api/index.html">Foundation <span>01</span></a><a class="preview-item" href="docs/api/index.html">Theme <span>02</span></a><a class="preview-item" href="docs/api/index.html">Experimental <span>03</span></a><div class="preview-sidebar-end">${moduleCount} modules<br>${apiCount} canonical APIs。</div></aside><section class="preview-stage"><div class="preview-stage-heading"><span>產品組合</span><span>COMPONENTS / STYLE</span></div><div class="preview-content"><article class="paper preview-paper"><span class="paper-meta">PRODUCT WORKSPACE / 01</span><h2>有秩序，也有空間。</h2><p>產品安排畫面，設計系統維持共用視覺與互動品質。</p><div class="node-chain"><span>Theme</span><span aria-hidden="true">→</span><span>Components</span><span aria-hidden="true">→</span><span>Product UI</span></div></article><div class="preview-memos"><article class="paper memo yellow"><span class="paper-meta">COMPOSITION</span><p>產品擁有布局與流程。<br>Kallopis 提供可重用元件。</p></article><article class="paper memo sage"><span class="paper-meta">STYLE 1.0.0</span><p>平整的結構表面。<br>可選的紙片微浮。</p></article></div></div></section></div></div>
		</section>
		<section id="framework" class="feature-section"><div class="feature-copy"><span class="eyebrow">01 / COMPOSE</span><h2>共享元件品質，<br>保留產品組合權。</h2><p>產品直接使用 Flutter 組合 Kallopis 元件，自己掌管畫面結構、導航與業務狀態；元件內部的視覺、鍵盤、hover、focus 與 accessibility 由 Kallopis 維護。</p><a class="text-link" href="docs/guides/docs-ai-product-usage.html">閱讀產品使用指南 ↗</a></div><div class="code-paper paper"><div class="code-caption">PUBLIC ENTRY <span>DART</span></div><pre><code><span class="syntax-keyword">import</span> 'package:kallopis/kallopis_foundation.dart';</code></pre><ol class="flow-list"><li><span>01</span><div><strong>Kallopis theme</strong><small>共用 semantic style 來源</small></div></li><li><span>02</span><div><strong>Public Flutter components</strong><small>共用視覺與互動能力</small></div></li><li><span>03</span><div><strong>Product-owned Widget tree</strong><small>產品決定布局、導航與流程</small></div></li></ol></div></section>
		<section class="feature-section reverse"><div class="style-study"><div class="style-swatches" aria-label="風格表面"><span class="swatch app-swatch">App</span><span class="swatch side-swatch">Sidebar</span><span class="swatch main-swatch">Content</span></div><article class="paper style-note"><span class="paper-meta">MATERIAL / PAPER</span><h3>一套風格，<br>各自負責的表面。</h3><p>結構保持平整，獨立內容才決定是否浮起。</p></article><span class="style-caption">COLOR · PADDING · RADIUS · SHADOW</span></div><div class="feature-copy"><span class="eyebrow">02 / RESOLVE</span><h2>讓風格有來源，<br>讓改動能傳遞。</h2><p>字型、色彩、間距與 icon 經由 semantic theme 統一解析。暖灰是起點；明暗、色調與內容陰影各有自己的責任。</p><a class="text-link" href="docs/design-system/index.html">查看通用視覺規範 ↗</a></div></section>
		<section class="documentation-section"><div><span class="eyebrow">03 / UNDERSTAND</span><h2>文件就在下一頁。</h2><p>從產品組合方式，到每個公開 class 的 API。</p></div><div class="doc-doors"><a href="docs/index.html"><span class="door-number">01</span><h3>開始使用 <span>↗</span></h3><p>入口、責任與產品組合方式。</p></a><a href="docs/components/index.html"><span class="door-number">02</span><h3>公開型別 <span>↗</span></h3><p>依現行 public surface 產生。</p></a><a href="docs/api/index.html"><span class="door-number">03</span><h3>API Reference <span>↗</span></h3><p>${apiCount} 個 canonical 公開宣告。</p></a></div><a class="button primary" href="docs/index.html">進入文件參考 ↗</a></section>
	</main>${footer('')}${scripts('')}`;
}

export function showcasePage({interactive = false, themes = [], reactCount = 0} = {}) {
	if (!interactive) {
		return `${head('風格示範', '')}<body data-root="" data-page="showcase">${header('', 'showcase')}<main id="main-content" class="showcase-home"><section class="showcase-intro"><div><p class="showcase-kicker">STYLE SHOWCASE</p><h1>風格示範</h1><p class="showcase-description">完整互動展示需配合 <code>--react --react-scenes --flutter-scenes</code> 建置。</p></div><div class="showcase-actions"><a class="button primary" href="docs/index.html">前往文件參考 ↗</a></div></section></main>${footer('')}${scripts('')}`;
	}
	const defaultTheme = themes[0] ?? { id: 'micro-elevation-v1', name: '微立體', defaultMode: 'dark', cssPath: 'styles/themes/micro-elevation-v1.css', jsPath: 'styles/themes/micro-elevation-v1.js', packPath: 'styles/themes/micro-elevation-v1.json' };
	const modes = ['light', 'dark', 'ultraDark', 'transparent'];
	return `${head('風格示範', '')}<body data-root="" data-page="showcase">${header('', 'showcase')}<main id="main-content" class="showcase-home">
		<section class="showcase-intro">
			<div>
				<p class="showcase-kicker">KALLOPIS STYLE SHOWCASE · COMPOSITION · COMPONENTS · TOKENS</p>
				<h1>風格示範</h1>
				<p class="showcase-description">頂部展示完整頁面組合，中段並列全部 ${reactCount} 個可互動元件與多語言程式碼範例，底部提供完整色票與可複製／下載的 CSS、JS 及 JSON 風格檔。</p>
			</div>
			<div class="showcase-actions">
				<a class="button secondary" href="#composition">頁面組合 ↓</a>
				<a class="button secondary" href="#components">互動元件 ↓</a>
				<a class="button primary" href="#swatches">色票與檔案 ↓</a>
			</div>
		</section>

		<div id="showcase-toolbar" class="showcase-toolbar" role="region" aria-label="全域風格與模式切換">
			<div class="showcase-toolbar-group" role="group" aria-label="切換風格">
				<span class="eyebrow">STYLE</span>
				${themes.map((theme, index) => `<button type="button" class="button ${index === 0 ? 'primary' : 'secondary'}" data-showcase-theme="${escapeHtml(theme.id)}" data-default-mode="${escapeHtml(theme.defaultMode)}" aria-pressed="${index === 0}">${escapeHtml(theme.name)} (${escapeHtml(theme.id)})</button>`).join('')}
			</div>
			<div class="showcase-toolbar-group" role="group" aria-label="切換模式">
				<span class="eyebrow">MODE</span>
				${modes.map(mode => `<button type="button" class="button ${mode === defaultTheme.defaultMode ? 'primary' : 'secondary'}" data-showcase-mode="${mode}" aria-pressed="${mode === defaultTheme.defaultMode}">${mode}</button>`).join('')}
			</div>
			<p id="showcase-sync-status" class="showcase-status" role="status" aria-live="polite">目前風格：${escapeHtml(defaultTheme.name)} (${escapeHtml(defaultTheme.id)}) · 模式：${escapeHtml(defaultTheme.defaultMode)}</p>
		</div>

		<section id="composition" class="showcase-section" aria-label="完整頁面組合範例">
			<div class="showcase-section-head">
				<div><span class="eyebrow">01 / FULL PAGE COMPOSITION</span><h2>完整頁面組合範例</h2></div>
				<div class="showcase-actions">
					<a class="button secondary" href="examples/react/index.html?scenario=ide" target="_blank" rel="noopener">獨立開啟 IDE 組合 ↗</a>
					<a class="button secondary" href="styles/examples/ide-workbench/index.html" target="_blank" rel="noopener">純 HTML 可複製版 ↗</a>
					<a class="button secondary" href="docs/flutter/scenarios/index.html">Flutter 組合展示 ↗</a>
				</div>
			</div>
			<div class="showcase-panel">
				<div class="showcase-panel-bar"><div><span class="showcase-dot" aria-hidden="true"></span><strong>互動 IDE 工作台組合</strong><span class="showcase-platform">上方風格切換會同步套用</span></div><a href="examples/react/index.html?scenario=ide" target="_blank" rel="noopener">獨立開啟 ↗</a></div>
				<iframe id="showcase-ide-frame" title="完整頁面組合範例" src="examples/react/index.html?scenario=ide" loading="lazy"></iframe>
			</div>
		</section>

		<section id="components" class="showcase-section" aria-label="所有可互動元件與多語言程式碼">
			<div class="showcase-section-head">
				<div><span class="eyebrow">02 / INTERACTIVE COMPONENTS &amp; CODE EXAMPLES</span><h2>全部可互動元件與多語言使用範例（${reactCount}）</h2></div>
				<div class="showcase-actions">
					<a class="button secondary" href="examples/react/index.html?showcase=components" target="_blank" rel="noopener">獨立視窗開啟全部元件 ↗</a>
					<a class="button secondary" href="docs/react/components/index.html">單一元件索引 ↗</a>
				</div>
			</div>
			<div class="showcase-panel showcase-panel-tall">
				<div class="showcase-panel-bar"><div><span class="showcase-dot" aria-hidden="true"></span><strong>可互動元件與並列程式碼（React / Flutter / HTML CSS）</strong><span class="showcase-platform">可依分類篩選或一次檢視全部</span></div><a href="examples/react/index.html?showcase=components" target="_blank" rel="noopener">獨立開啟 ↗</a></div>
				<iframe id="showcase-components-frame" title="全部可互動元件與多語言程式碼" src="examples/react/index.html?showcase=components" loading="lazy"></iframe>
			</div>
		</section>

		<section id="swatches" class="showcase-section" aria-label="所有色票與 CSS / JS 檔案下載複製">
			<div class="showcase-section-head">
				<div><span class="eyebrow">03 / ALL COLOR SWATCHES &amp; STYLE FILES</span><h2>所有色票與 CSS / JS / JSON 風格檔</h2></div>
				<p id="theme-copy-status" class="showcase-status" role="status" aria-live="polite">點選色票即可複製色碼；下方可直接複製或下載目前風格的 CSS、JavaScript 與 JSON 檔案。</p>
			</div>

			<div id="swatch-wall" class="swatch-wall" aria-live="polite"></div>

			<div class="file-viewer">
				<div class="file-viewer-bar">
					<div class="showcase-toolbar-group" role="tablist" aria-label="預覽風格檔案格式">
						<button type="button" class="button primary" data-file-format="css" aria-selected="true">CSS (.css)</button>
						<button type="button" class="button secondary" data-file-format="js" aria-selected="false">JavaScript (.js)</button>
						<button type="button" class="button secondary" data-file-format="json" aria-selected="false">JSON (.json)</button>
					</div>
					<div class="showcase-toolbar-group">
						<button type="button" class="button primary" id="copy-active-file">複製檔案內容</button>
						<a class="button secondary" id="download-css" href="${escapeHtml(defaultTheme.cssPath)}" download>下載 CSS ↓</a>
						<a class="button secondary" id="download-js" href="${escapeHtml(defaultTheme.jsPath)}" download>下載 JS ↓</a>
						<a class="button secondary" id="download-json" href="${escapeHtml(defaultTheme.packPath)}" download>下載 JSON ↓</a>
						<a class="button secondary" href="styles/component-bindings.json" download>Token 對應表 ↓</a>
					</div>
				</div>
				<pre id="theme-file-preview" class="file-code-pre"><code>載入風格檔案中…</code></pre>
			</div>

			<div class="theme-gallery" style="margin-top: 24px;">${themes.map(renderThemeCard).join('')}</div>
		</section>
	</main>${footer('')}${scripts('')}`;
}
