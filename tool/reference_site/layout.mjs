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
	if (interactive) return `${head('跨框架設計系統', '')}<body data-root="" data-page="home">${header('', 'home')}<main id="main-content" class="showcase-home">
		<section id="framework" class="showcase-intro">
			<div>
				<p class="showcase-kicker">KALLOPIS DESIGN SYSTEM</p>
				<h1>一套設計語言，駕馭多種視覺氣質。</h1>
				<p class="showcase-description">從溫潤微立體工作台到現代編輯簡約美學，Kallopis 以統一語意 token 跨 React 與 Flutter 呈現一致手感，讓介面既有鮮明個性，也保有長時間專注的視覺秩序。</p>
			</div>
			<div class="showcase-actions">
				<a class="button primary" href="showcase.html">進入風格示範 ↗</a>
				<a class="button secondary" href="components.html">瀏覽元件表（${reactCount}）↗</a>
				<a class="button secondary" href="docs/index.html">文件參考 ↗</a>
			</div>
		</section>

		<section class="showcase-section" aria-label="精選視覺風格">
			<div class="showcase-section-head">
				<div><span class="eyebrow">01 / SIGNATURE THEMES</span><h2>精選視覺風格</h2></div>
				<a class="button secondary" href="showcase.html#swatches">探索完整色票與主題檔案 →</a>
			</div>
			<p id="theme-copy-status" class="showcase-status" role="status" aria-live="polite">每套風格皆支援四種色彩模式，開箱即用，無需綁定特定框架即可直接帶走。</p>
			<div class="theme-gallery">${themes.map(renderThemeCard).join('')}</div>
		</section>

		<section class="showcase-section" aria-label="互動工作台體驗">
			<div class="showcase-section-head">
				<div><span class="eyebrow">02 / WORKBENCH EXPERIENCE</span><h2>為長時間專注打造的互動工作台</h2></div>
				<div class="showcase-actions">
					<a class="button primary" href="showcase.html">前往風格示範 ↗</a>
					<a class="button secondary" href="components.html">開啟元件表 ↗</a>
				</div>
			</div>
			<div class="showcase-panel">
				<div class="showcase-panel-bar"><div><span class="showcase-dot" aria-hidden="true"></span><strong>互動 IDE 工作台</strong><span class="showcase-platform">多面板協作、分頁編輯與即時主題轉換</span></div><a href="showcase.html">前往風格示範頁 →</a></div>
				<iframe title="Kallopis 首頁互動工作台預覽" src="examples/react/index.html?scenario=ide" loading="lazy"></iframe>
			</div>
		</section>

		<nav class="showcase-resources" aria-label="常用入口">
			<a href="showcase.html#composition"><strong>風格工作台示範 ↗</strong><span>完整多面板互動體驗與純 HTML 輸出</span></a>
			<a href="components.html"><strong>跨框架元件表 ↗</strong><span>${reactCount} 款元件與 React、Flutter、HTML 對應</span></a>
			<a href="showcase.html#swatches"><strong>色票與即時調色 ↗</strong><span>完整色彩階調、即時 CSS 微調與一鍵匯出</span></a>
			<a href="docs/index.html"><strong>文件參考 ↗</strong><span>${moduleCount} 模組 · ${apiCount} 公開 API</span></a>
		</nav>
	</main>${footer('')}${scripts('')}`;
	return `${head('介面有秩序，產品有自由', '')}<body data-root="" data-page="home">${header('', 'home')}<main id="main-content" class="home-main">
		<section class="hero"><div class="eyebrow">THE DESIGN SYSTEM OF THE -IST FAMILY</div><h1>讓產品自由組合。<br><span>讓介面保持一致。</span></h1><p class="hero-copy">Kallopis 定義通用視覺語意、token 與元件組合；各框架庫實作一致的設計契約。<br class="desktop-break">產品保有畫面、導航與流程的完整所有權。</p><div class="hero-actions"><a class="button primary" href="showcase.html">風格示範 <span aria-hidden="true">↗</span></a><a class="button secondary" href="components.html">元件表</a></div><p class="release-line">風格 v1.0.0 <span>·</span> Cross-framework Design System</p>
			<div class="workspace-preview" aria-label="Kallopis 工作區視覺示意"><div class="preview-heading"><span>Kallopis / Workspace</span><span>FOUNDATION</span></div><div class="preview-grid"><aside class="preview-sidebar"><span class="eyebrow">PUBLIC SURFACES</span><div class="preview-folder">▾ Kallopis</div><a class="preview-item selected" href="docs/api/index.html">Foundation <span>01</span></a><a class="preview-item" href="docs/api/index.html">Theme <span>02</span></a><a class="preview-item" href="docs/api/index.html">Experimental <span>03</span></a><div class="preview-sidebar-end">${moduleCount} modules<br>${apiCount} canonical APIs。</div></aside><section class="preview-stage"><div class="preview-stage-heading"><span>產品組合</span><span>COMPONENTS / STYLE</span></div><div class="preview-content"><article class="paper preview-paper"><span class="paper-meta">PRODUCT WORKSPACE / 01</span><h2>有秩序，也有空間。</h2><p>產品安排畫面，設計系統維持共用視覺與互動品質。</p><div class="node-chain"><span>Theme</span><span aria-hidden="true">→</span><span>Components</span><span aria-hidden="true">→</span><span>Product UI</span></div></article><div class="preview-memos"><article class="paper memo yellow"><span class="paper-meta">COMPOSITION</span><p>產品擁有布局與流程。<br>Kallopis 提供可重用元件。</p></article><article class="paper memo sage"><span class="paper-meta">STYLE 1.0.0</span><p>平整的結構表面。<br>可選的紙片微浮。</p></article></div></div></section></div></div>
		</section>
		<section id="framework" class="feature-section"><div class="feature-copy"><span class="eyebrow">01 / COMPOSE</span><h2>共享元件品質，<br>保留產品組合權。</h2><p>產品直接使用 Flutter 組合 Kallopis 元件，自己掌管畫面結構、導航與業務狀態；元件內部的視覺、鍵盤、hover、focus 與 accessibility 由 Kallopis 維護。</p><a class="text-link" href="docs/guides/docs-ai-product-usage.html">閱讀產品使用指南 ↗</a></div><div class="code-paper paper"><div class="code-caption">PUBLIC ENTRY <span>DART</span></div><pre><code><span class="syntax-keyword">import</span> 'package:kallopis/kallopis_foundation.dart';</code></pre><ol class="flow-list"><li><span>01</span><div><strong>Kallopis theme</strong><small>共用 semantic style 來源</small></div></li><li><span>02</span><div><strong>Public Flutter components</strong><small>共用視覺與互動能力</small></div></li><li><span>03</span><div><strong>Product-owned Widget tree</strong><small>產品決定布局、導航與流程</small></div></li></ol></div></section>
		<section class="feature-section reverse"><div class="style-study"><div class="style-swatches" aria-label="風格表面"><span class="swatch app-swatch">App</span><span class="swatch side-swatch">Sidebar</span><span class="swatch main-swatch">Content</span></div><article class="paper style-note"><span class="paper-meta">MATERIAL / PAPER</span><h3>一套風格，<br>各自負責的表面。</h3><p>結構保持平整，獨立內容才決定是否浮起。</p></article><span class="style-caption">COLOR · PADDING · RADIUS · SHADOW</span></div><div class="feature-copy"><span class="eyebrow">02 / RESOLVE</span><h2>讓風格有來源，<br>讓改動能傳遞。</h2><p>字型、色彩、間距與 icon 經由 semantic theme 統一解析。暖灰是起點；明暗、色調與內容陰影各有自己的責任。</p><a class="text-link" href="docs/design-system/index.html">查看通用視覺規範 ↗</a></div></section>
		<section class="documentation-section"><div><span class="eyebrow">03 / UNDERSTAND</span><h2>文件就在下一頁。</h2><p>從產品組合方式，到每個公開 class 的 API。</p></div><div class="doc-doors"><a href="docs/index.html"><span class="door-number">01</span><h3>開始使用 <span>↗</span></h3><p>入口、責任與產品組合方式。</p></a><a href="docs/components/index.html"><span class="door-number">02</span><h3>公開型別 <span>↗</span></h3><p>依現行 public surface 產生。</p></a><a href="docs/api/index.html"><span class="door-number">03</span><h3>API Reference <span>↗</span></h3><p>${apiCount} 個 canonical 公開宣告。</p></a></div><a class="button primary" href="docs/index.html">進入文件參考 ↗</a></section>
	</main>${footer('')}${scripts('')}`;
}

export function showcasePage({interactive = false, themes = [], reactCount = 0} = {}) {
	if (!interactive) {
		return `${head('風格示範', '')}<body data-root="" data-page="showcase">${header('', 'showcase')}<main id="main-content" class="showcase-home"><section class="showcase-intro"><div><p class="showcase-kicker">STYLE SHOWCASE</p><h1>風格示範</h1><p class="showcase-description">探索多套視覺風格、完整工作台表現與色彩系統。</p></div><div class="showcase-actions"><a class="button primary" href="docs/index.html">前往文件參考 ↗</a></div></section></main>${footer('')}${scripts('')}`;
	}
	const defaultTheme = themes[0] ?? { id: 'micro-elevation-v1', name: '微立體', cssPath: 'styles/themes/micro-elevation-v1.css', jsPath: 'styles/themes/micro-elevation-v1.js', packPath: 'styles/themes/micro-elevation-v1.json' };
	const modes = ['light', 'dark', 'ultraDark', 'transparent'];
	return `${head('風格示範', '')}<body data-root="" data-page="showcase">${header('', 'showcase')}<main id="main-content" class="showcase-home">
		<section class="showcase-intro">
			<div>
				<p class="showcase-kicker">KALLOPIS STYLE SHOWCASE</p>
				<h1>風格示範</h1>
				<p class="showcase-description">在真實工作台與核心元件間自由切換風格與明暗氛圍，感受微立體層次、編輯細線與暖紙質感的細節差異，並直接微調專屬色彩與樣式。</p>
			</div>
			<div class="showcase-actions">
				<a class="button secondary" href="#composition">工作台實景 ↓</a>
				<a class="button secondary" href="#components-preview">互動元件組 ↓</a>
				<a class="button secondary" href="#swatches">色票與主題編輯 ↓</a>
				<a class="button primary" href="components.html">開啟完整元件表（${reactCount}）↗</a>
			</div>
		</section>

		<section id="showcase-toolbar" class="showcase-toolbar" aria-label="風格與色彩模式切換">
			<div class="showcase-toolbar-group" role="group" aria-label="選擇風格">
				<span class="eyebrow">風格 STYLE</span>
				${themes.map((theme, index) => `<button type="button" class="button ${index === 0 ? 'primary' : 'secondary'}" data-showcase-theme="${escapeHtml(theme.id)}" aria-pressed="${index === 0}">${escapeHtml(theme.name)} (${escapeHtml(theme.id)})</button>`).join('')}
			</div>
			<div class="showcase-toolbar-group" role="group" aria-label="選擇明暗模式">
				<span class="eyebrow">模式 MODE</span>
				${modes.map(mode => `<button type="button" class="button ${mode === 'light' ? 'primary' : 'secondary'}" data-showcase-mode="${mode}" aria-pressed="${mode === 'light'}">${mode}</button>`).join('')}
			</div>
			<p id="showcase-sync-status" class="showcase-status" role="status" aria-live="polite">風格：${escapeHtml(defaultTheme.name)} (${escapeHtml(defaultTheme.id)}) · 模式：light</p>
		</section>

		<section id="composition" class="showcase-section" aria-label="真實工作台畫面">
			<div class="showcase-section-head">
				<div><span class="eyebrow">01 / WORKBENCH COMPOSITION</span><h2>真實工作台畫面</h2></div>
				<div class="showcase-actions">
					<a class="button secondary" href="examples/react/index.html?scenario=ide" target="_blank" rel="noopener">獨立開啟 IDE 組合 ↗</a>
					<a class="button secondary" href="styles/examples/ide-workbench/index.html" target="_blank" rel="noopener">純 HTML 可複製版 ↗</a>
					<a class="button secondary" href="docs/flutter/scenarios/index.html">Flutter 組合展示 ↗</a>
				</div>
			</div>
			<div class="showcase-panel">
				<div class="showcase-panel-bar"><div><span class="showcase-dot" aria-hidden="true"></span><strong>互動 IDE 工作台</strong><span class="showcase-platform">側欄、分頁編輯、大綱與命令面板一體成型</span></div><a href="examples/react/index.html?scenario=ide" target="_blank" rel="noopener">獨立開啟 ↗</a></div>
				<iframe id="showcase-ide-frame" title="完整頁面組合範例" src="examples/react/index.html?scenario=ide&amp;embed=1" loading="lazy"></iframe>
			</div>
		</section>

		<section id="components-preview" class="showcase-section" aria-label="一致手感的互動元件組">
			<div class="showcase-section-head">
				<div><span class="eyebrow">02 / COMPONENT HARMONY</span><h2>一致手感的互動元件組</h2></div>
				<div class="showcase-actions">
					<a class="button primary" href="components.html">前往完整元件表與多語言程式碼 ↗</a>
				</div>
			</div>
			<div class="showcase-panel showcase-panel-matrix">
				<div class="showcase-panel-bar"><div><span class="showcase-dot" aria-hidden="true"></span><strong>核心與精選元件一覽</strong><span class="showcase-platform">按鈕、表單、導覽與品牌特色元件</span></div><a href="components.html">完整元件表 →</a></div>
				<iframe id="showcase-matrix-frame" title="互動元件風格群組預覽" src="examples/react/index.html?showcase=matrix" loading="lazy"></iframe>
			</div>
		</section>

		<section id="swatches" class="showcase-section" aria-label="色彩階調與即時樣式調整">
			<div class="showcase-section-head">
				<div><span class="eyebrow">03 / COLOR PALETTE</span><h2>色彩階調與語意色票</h2></div>
				<p id="theme-copy-status" class="showcase-status" role="status" aria-live="polite">完整涵蓋表面層次、文字對比、邊框與狀態語意色系。</p>
			</div>

			<div id="swatch-wall" class="swatch-wall" aria-live="polite"></div>

			<div class="showcase-section-head" style="margin-top: 32px;">
				<div><span class="eyebrow">04 / THEME STUDIO &amp; EXPORT</span><h2>即時樣式調整與多格式匯出</h2></div>
				<span class="showcase-status">支援 CSS、JS 與 JSON，零依賴融入任何前端專案。</span>
			</div>

			<div class="file-viewer">
				<div class="file-viewer-bar">
					<div class="showcase-toolbar-group" role="tablist" aria-label="預覽或編輯風格檔案格式">
						<button type="button" class="button primary" data-file-format="css" aria-selected="true">即時編輯 CSS (.css)</button>
						<button type="button" class="button secondary" data-file-format="js" aria-selected="false">檢視 JS (.js)</button>
						<button type="button" class="button secondary" data-file-format="json" aria-selected="false">檢視 JSON (.json)</button>
					</div>
					<div class="showcase-toolbar-group">
						<button type="button" class="button secondary" id="reset-css-editor">重設 CSS</button>
						<button type="button" class="button primary" id="copy-active-file">複製目前檔案</button>
						<a class="button secondary" id="download-css" href="${escapeHtml(defaultTheme.cssPath)}" download>下載 CSS ↓</a>
						<a class="button secondary" id="download-js" href="${escapeHtml(defaultTheme.jsPath)}" download>下載 JS ↓</a>
						<a class="button secondary" id="download-json" href="${escapeHtml(defaultTheme.packPath)}" download>下載 JSON ↓</a>
						<a class="button secondary" href="styles/component-bindings.json" download>Token 對應表 ↓</a>
					</div>
				</div>
				<textarea id="theme-css-editor" class="css-editor-textarea" aria-label="即時編輯風格 CSS" spellcheck="false"></textarea>
				<pre id="theme-file-preview" class="file-code-pre" hidden><code></code></pre>
			</div>
		</section>
	</main>${footer('')}${scripts('')}`;
}

export function componentsPage({interactive = false, themes = [], desktopCatalog = [], coreComponents = [], curatedComponents = []} = {}) {
	if (!interactive) {
		return `${head('元件表', '')}<body data-root="" data-page="components">${header('', 'components')}<main id="main-content" class="showcase-home"><section class="showcase-intro"><div><p class="showcase-kicker">COMPONENTS</p><h1>元件表</h1><p class="showcase-description">瀏覽跨框架公開元件、互動細節與多語言實作。</p></div><div class="showcase-actions"><a class="button primary" href="docs/components/index.html">前往公開型別 ↗</a></div></section></main>${footer('')}${scripts('')}`;
	}
	const modes = ['light', 'dark', 'ultraDark', 'transparent'];
	const languages = [['react', 'React (TSX)'], ['flutter', 'Flutter (Dart)'], ['html', 'HTML / CSS']];
	const coreSet = new Set(coreComponents.map(item => item.name));
	const initialId = curatedComponents[0]?.id ?? coreComponents[0]?.name ?? 'KlpButton';
	const navGroups = [
		...(curatedComponents.length ? [{
			id: 'curated',
			title: `精選設計元件（${curatedComponents.length}）`,
			items: curatedComponents.map(item => ({ id: item.id, label: `${item.name} (${item.id})` })),
		}] : []),
		...desktopCatalog.map(group => ({
			id: group.id,
			title: `${group.title}（${group.components.filter(name => coreSet.has(name)).length}）`,
			items: group.components.filter(name => coreSet.has(name)).map(name => ({ id: name, label: name })),
		})).filter(group => group.items.length),
	];

	return `${head('元件表', '')}<body data-root="" data-page="components">${header('', 'components')}<div class="components-workspace">
		<aside class="navigator" aria-label="元件表導覽">
			<details class="doc-navigation" open>
				<summary>元件 Navigator</summary>
				<div class="nav-content">
					<label class="search-label" for="component-search">搜尋元件</label>
					<input id="component-search" type="search" placeholder="輸入元件名稱或分類…" autocomplete="off">
					<p id="component-search-status" class="search-label" role="status" aria-live="polite">共 ${curatedComponents.length} 個精選 + ${coreComponents.length} 個核心元件</p>
					<nav id="component-nav" aria-label="元件目錄">
						${navGroups.map((group, groupIndex) => `<details ${groupIndex < 2 ? 'open' : ''}><summary>${escapeHtml(group.title)}</summary>${group.items.map(item => `<a class="component-nav-link" href="#${escapeHtml(item.id)}" data-component-id="${escapeHtml(item.id)}" ${item.id === initialId ? 'aria-current="true"' : ''}>${escapeHtml(item.label)}</a>`).join('')}</details>`).join('')}
					</nav>
				</div>
			</details>
		</aside>

		<main id="main-content" class="components-main">
			<!-- 設定控制區與單一元件展示舞台嚴格分離 -->
			<section id="component-toolbar" class="showcase-toolbar" aria-label="元件展示獨立設定列">
				<div class="showcase-toolbar-group" role="group" aria-label="切換風格">
					<span class="eyebrow">風格</span>
					${themes.map((theme, index) => `<button type="button" class="button ${index === 0 ? 'primary' : 'secondary'}" data-comp-theme="${escapeHtml(theme.id)}" aria-pressed="${index === 0}">${escapeHtml(theme.name)}</button>`).join('')}
				</div>
				<div class="showcase-toolbar-group" role="group" aria-label="切換明暗模式">
					<span class="eyebrow">模式</span>
					${modes.map(mode => `<button type="button" class="button ${mode === 'light' ? 'primary' : 'secondary'}" data-comp-mode="${mode}" aria-pressed="${mode === 'light'}">${mode}</button>`).join('')}
				</div>
				<div class="showcase-toolbar-group" role="group" aria-label="預設程式碼語言">
					<span class="eyebrow">語言</span>
					${languages.map(([langId, langLabel], index) => `<button type="button" class="button ${index === 0 ? 'primary' : 'secondary'}" data-comp-lang="${langId}" aria-pressed="${index === 0}">${langLabel}</button>`).join('')}
				</div>
			</section>

			<div class="showcase-panel showcase-panel-single">
				<div class="showcase-panel-bar">
					<div><span class="showcase-dot" aria-hidden="true"></span><strong id="active-component-label">${escapeHtml(initialId)}</strong><span class="showcase-platform">互動元件實景與跨框架程式碼</span></div>
					<a id="open-component-standalone" href="examples/react/index.html?showcase=single&amp;component=${encodeURIComponent(initialId)}" target="_blank" rel="noopener">獨立視窗開啟 ↗</a>
				</div>
				<iframe id="component-stage-frame" title="單一元件互動與程式碼展示" src="examples/react/index.html?showcase=single&amp;component=${encodeURIComponent(initialId)}" loading="lazy"></iframe>
			</div>
		</main>
	</div>${footer('')}${scripts('')}`;
}
