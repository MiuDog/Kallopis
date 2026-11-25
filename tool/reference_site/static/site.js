const root = document.body.dataset.root ?? '';
const defaults = {theme: 'light', tone: 'warm', lift: 'on'};
const allowed = {theme: ['light', 'dark'], tone: ['warm', 'neutral'], lift: ['on', 'off']};
let preferences = {...defaults};
try {
	const saved = JSON.parse(localStorage.getItem('kallopis-site-style') ?? '{}');
	for (const key of Object.keys(defaults)) if (allowed[key].includes(saved[key])) preferences[key] = saved[key];
} catch { /* 儲存空間不可用時沿用預設。 */ }
function applyPreferences() {
	for (const [key, value] of Object.entries(preferences)) document.documentElement.dataset[key] = value;
}
applyPreferences();
for (const control of document.querySelectorAll('[data-preference]')) {
	const key = control.dataset.preference;
	if (control.type === 'checkbox') control.checked = preferences[key] === 'on';
	else control.value = preferences[key];
	control.addEventListener('change', () => {
		preferences[key] = control.type === 'checkbox' ? (control.checked ? 'on' : 'off') : control.value;
		applyPreferences();
		try { localStorage.setItem('kallopis-site-style', JSON.stringify(preferences)); } catch { /* 本次頁面仍套用選項。 */ }
	});
}
const appearance = document.querySelector('.appearance');
document.addEventListener('click', event => {
	if (appearance && !appearance.contains(event.target)) appearance.open = false;
});
document.addEventListener('keydown', event => {
	if (event.key === 'Escape' && appearance?.open) {
		appearance.open = false;
		appearance.querySelector('summary').focus();
	}
});

function appendLink(parent, href, label) {
	const link = document.createElement('a');
	link.href = href;
	link.textContent = label;
	if (new URL(href, location.href).pathname === location.pathname) link.setAttribute('aria-current', 'page');
	parent.append(link);
	return link;
}
function appendDetails(parent, label) {
	const details = document.createElement('details');
	const summary = document.createElement('summary');
	summary.textContent = label;
	details.append(summary);
	parent.append(details);
	return details;
}
const navigation = document.querySelector('#navigation');
if (navigation) {
	const search = document.querySelector('#search');
	const status = document.querySelector('#search-status');
	if (matchMedia('(max-width: 760px)').matches) document.querySelector('.doc-navigation').open = false;
	fetch(`${root}search-index.json`)
		.then(response => {
			if (!response.ok) throw new Error('搜尋索引無法載入');
			return response.json();
		})
		.then(entries => {
			function render() {
				const query = search.value.trim().toLowerCase();
				navigation.replaceChildren();
				if (query) {
					const matches = entries.filter(entry => `${entry.title} ${entry.category} ${entry.href} ${entry.body || ''}`.toLowerCase().includes(query));
					status.textContent = `${matches.length} 筆結果${matches.length > 100 ? '，先顯示 100 筆，請增加關鍵字縮小範圍' : ''}`;
					for (const entry of matches.slice(0, 100)) appendLink(navigation, `${root}${entry.href}`, `${entry.title} · ${entry.category}`);
					return;
				}
				status.textContent = '搜尋全部指南、元件、規格與 API';
				for (const [href, label] of [['docs/index.html', '文件中心'], ['docs/design-system/index.html', '通用視覺規範'], ['docs/guides/docs-ai-product-usage.html', 'Flutter 產品使用'], ['docs/components/index.html', 'Flutter 公開型別'], ['docs/api/index.html', 'Flutter API Reference']]) appendLink(navigation, `${root}${href}`, label);
				const groups = new Map();
				for (const entry of entries) {
					const category = ({ API: 'Flutter API', Design: '通用視覺規範', Snapshot: '匯出快照', Guide: '指南', Spec: '規格與決策', Project: '專案' })[entry.category] || '元件';
					if (!groups.has(category)) groups.set(category, []);
					groups.get(category).push(entry);
				}
				for (const [category, items] of groups) {
					const group = appendDetails(navigation, `${category} · ${items.length}`);
					const areas = new Map();
					for (const entry of items) {
						const area = entry.module || entry.apiArea || entry.guideArea || entry.category;
						if (!areas.has(area)) areas.set(area, appendDetails(group, area));
						const container = areas.get(area);
						const link = appendLink(container, `${root}${entry.href}`, entry.title);
						if (link.hasAttribute('aria-current')) { container.open = true; group.open = true; }
					}
				}
			}
			search.addEventListener('input', render);
			render();
		})
		.catch(() => { status.textContent = '搜尋暫時無法載入，仍可使用下方文件入口。'; });
}
const toc = document.querySelector('#page-toc');
if (toc) {
	for (const heading of document.querySelectorAll('.prose h2[id], .prose h3[id]')) {
		const link = appendLink(toc, `#${encodeURIComponent(heading.id)}`, heading.textContent);
		link.dataset.depth = heading.tagName.slice(1);
		link.removeAttribute('aria-current');
	}
	if (!toc.childElementCount) toc.parentElement.hidden = true;
}

// 圖表失敗時保留可閱讀的原始定義，不讓整篇文件失效。
const diagrams = [...document.querySelectorAll('pre.mermaid')];
if (diagrams.length) {
	import('https://cdn.jsdelivr.net/npm/mermaid@11.4.1/dist/mermaid.esm.min.mjs')
		.then(async ({default: mermaid}) => {
			mermaid.initialize({startOnLoad: false, securityLevel: 'strict', theme: 'neutral', suppressErrorRendering: true});
			for (const [index, diagram] of diagrams.entries()) {
				try {
					const {svg} = await mermaid.render(`diagram-${index}`, diagram.textContent);
					const container = document.createElement('div');
					container.className = 'mermaid';
					container.innerHTML = svg;
					diagram.replaceWith(container);
				} catch { diagram.setAttribute('aria-label', 'Mermaid 圖表原始定義'); }
			}
		})
		.catch(() => { for (const diagram of diagrams) diagram.setAttribute('aria-label', 'Mermaid 圖表原始定義（離線備援）'); });
}

// 展示載入狀態以同源app實際標題為準，HTTP錯頁不能冒充成功。
for (const frame of document.querySelectorAll('iframe[data-component-specimen]')) {
	const status = frame.parentElement.querySelector('[data-specimen-state]');
	const isFlutter = frame.dataset.specimenFramework === 'flutter';
	const name = frame.title.replace(/ React 互動展示$/, '');
	let finished = false;
	function finish(state, message) {
		if (finished) return;
		finished = true;
		clearInterval(poll);
		clearTimeout(timeout);
		status.dataset.specimenState = state;
		status.textContent = message;
	}
	function inspect() {
		try {
			if (isFlutter) {
				const title = frame.contentDocument?.title;
				if (!title?.endsWith(' Flutter 互動展示')) return;
				if (title === frame.title) finish('loaded', '展示已載入，可直接操作或獨立開啟。');
				else finish('error', '展示載入失敗，請使用獨立開啟入口重新嘗試。');
				return;
			}
			const heading = frame.contentDocument?.querySelector('h1');
			if (!heading) return;
			if (heading.textContent.trim() === name) finish('loaded', '展示已載入，可直接操作或獨立開啟。');
			else finish('error', '展示載入失敗，請使用獨立開啟入口重新嘗試。');
		} catch { finish('error', '無法讀取展示，請使用獨立開啟入口。'); }
	}
	const poll = setInterval(inspect, 150);
	const timeout = setTimeout(() => finish('error', '展示尚未載入，請使用獨立開啟入口重新嘗試。'), 15000);
	frame.addEventListener('load', inspect);
	frame.addEventListener('error', () => finish('error', '展示載入失敗，請使用獨立開啟入口。'));
	inspect();
}

// 複製按鈕：支援卡片與檔案區的 CSS / JS / JSON 複製。
const themeStatus = document.querySelector('#theme-copy-status');
async function copyPathToClipboard(path, label) {
	try {
		const response = await fetch(`${root}${path}`);
		if (!response.ok) throw new Error('無法讀取風格檔');
		const text = await response.text();
		await navigator.clipboard.writeText(text);
		if (themeStatus) themeStatus.textContent = `已複製「${label}」（${path}），可直接貼入專案。`;
	} catch {
		if (themeStatus) themeStatus.textContent = `無法自動寫入剪貼簿，請下載 ${path} 使用。`;
	}
}
for (const button of document.querySelectorAll('[data-copy-file]')) {
	button.addEventListener('click', () => copyPathToClipboard(button.dataset.copyFile, button.dataset.themeName || button.dataset.copyFile));
}

// 風格示範頁：獨立切換風格與模式、群組相鄰色票（Hover 屬性 / 點擊複製 HEX）、即時 CSS 編輯套用。
const showcaseToolbar = document.querySelector('#showcase-toolbar');
if (showcaseToolbar) {
	let activeThemeId = 'micro-elevation-v1';
	let activeMode = 'light';
	let activeFormat = 'css';
	let themesIndex = [];
	let swatchesData = null;
	let originalCssText = '';
	let editedCssText = '';
	let activeFileText = '';
	let cssTimer = null;
	const ideFrame = document.querySelector('#showcase-ide-frame');
	const matrixFrame = document.querySelector('#showcase-matrix-frame');
	const syncStatus = document.querySelector('#showcase-sync-status');
	const swatchWall = document.querySelector('#swatch-wall');
	const cssEditor = document.querySelector('#theme-css-editor');
	const filePreview = document.querySelector('#theme-file-preview');
	const filePreviewCode = document.querySelector('#theme-file-preview code');
	const copyFileButton = document.querySelector('#copy-active-file');
	const resetCssButton = document.querySelector('#reset-css-editor');
	const downloadCss = document.querySelector('#download-css');
	const downloadJs = document.querySelector('#download-js');
	const downloadJson = document.querySelector('#download-json');

	function postStyleToFrames() {
		const payload = { type: 'klp-style-change', themeId: activeThemeId, mode: activeMode };
		ideFrame?.contentWindow?.postMessage(payload, '*');
		matrixFrame?.contentWindow?.postMessage(payload, '*');
	}

	function postCustomCssToFrames() {
		const payload = { type: 'klp-custom-css', css: editedCssText };
		ideFrame?.contentWindow?.postMessage(payload, '*');
		matrixFrame?.contentWindow?.postMessage(payload, '*');
	}

	function updateButtons() {
		for (const button of document.querySelectorAll('[data-showcase-theme]')) {
			const selected = button.dataset.showcaseTheme === activeThemeId;
			button.setAttribute('aria-pressed', String(selected));
			button.classList.toggle('primary', selected);
			button.classList.toggle('secondary', !selected);
		}
		for (const button of document.querySelectorAll('[data-showcase-mode]')) {
			const selected = button.dataset.showcaseMode === activeMode;
			button.setAttribute('aria-pressed', String(selected));
			button.classList.toggle('primary', selected);
			button.classList.toggle('secondary', !selected);
		}
		for (const button of document.querySelectorAll('[data-file-format]')) {
			const selected = button.dataset.fileFormat === activeFormat;
			button.setAttribute('aria-selected', String(selected));
			button.classList.toggle('primary', selected);
			button.classList.toggle('secondary', !selected);
		}
		const meta = themesIndex.find(item => item.id === activeThemeId);
		if (syncStatus) syncStatus.textContent = `風格：${meta?.name ?? activeThemeId} (${activeThemeId}) · 模式：${activeMode}`;
		if (meta) {
			if (downloadCss) downloadCss.href = `${root}${meta.cssPath}`;
			if (downloadJs) downloadJs.href = `${root}${meta.jsPath}`;
			if (downloadJson) downloadJson.href = `${root}${meta.packPath}`;
		}
	}

	function renderSwatches() {
		if (!swatchWall || !swatchesData) return;
		const themeSwatches = swatchesData.themes?.[activeThemeId];
		if (!themeSwatches) return;
		const semanticGroups = themeSwatches.semanticGroups?.[activeMode] ?? [];
		const primitiveGroups = themeSwatches.primitiveGroups ?? [];
		swatchWall.replaceChildren();

		function appendCategorySection(headingText, groups, isSemantic) {
			const section = document.createElement('section');
			section.className = 'swatch-section';
			const heading = document.createElement('h3');
			heading.textContent = headingText;
			section.append(heading);

			for (const group of groups) {
				const groupBox = document.createElement('div');
				groupBox.className = 'swatch-group-row';
				const label = document.createElement('span');
				label.className = 'swatch-group-label';
				label.textContent = `${group.title} (${group.items.length})`;
				const strip = document.createElement('div');
				strip.className = 'swatch-strip';

				for (const item of group.items) {
					const tile = document.createElement('button');
					tile.type = 'button';
					tile.className = 'swatch-block';
					tile.style.background = item.hex;
					tile.setAttribute('aria-label', `${isSemantic ? item.label : item.id} ${item.hex}`);

					const popover = document.createElement('span');
					popover.className = 'swatch-popover';
					const titleEl = document.createElement('strong');
					titleEl.textContent = isSemantic ? item.label : item.id;
					const hexEl = document.createElement('code');
					hexEl.textContent = item.hex;
					const metaEl = document.createElement('small');
					metaEl.textContent = isSemantic ? `${item.cssVar}${item.description ? ` · ${item.description}` : ''}` : (item.description || item.id);
					popover.append(titleEl, hexEl, metaEl);
					tile.append(popover);

					tile.addEventListener('click', async () => {
						try {
							await navigator.clipboard.writeText(item.hex);
							if (themeStatus) themeStatus.textContent = `已複製 HEX 色碼：${item.hex}（${isSemantic ? item.cssVar : item.id}）`;
						} catch {
							if (themeStatus) themeStatus.textContent = `色票 HEX：${item.hex}（${isSemantic ? item.cssVar : item.id}）`;
						}
					});
					strip.append(tile);
				}
				groupBox.append(label, strip);
				section.append(groupBox);
			}
			swatchWall.append(section);
		}

		appendCategorySection(`語意色票 · ${themeSwatches.name} (${activeMode})`, semanticGroups, true);
		appendCategorySection('基礎色票（Primitive Colors）', primitiveGroups, false);
	}

	async function loadThemeCssForEditor() {
		const meta = themesIndex.find(item => item.id === activeThemeId);
		if (!meta) return;
		try {
			const response = await fetch(`${root}${meta.cssPath}`);
			if (!response.ok) throw new Error('讀取失敗');
			originalCssText = await response.text();
			editedCssText = originalCssText;
			if (cssEditor) cssEditor.value = editedCssText;
			postCustomCssToFrames();
		} catch {
			if (cssEditor) cssEditor.value = `/* 無法讀取 ${meta.cssPath} */`;
		}
	}

	async function renderActiveFilePane() {
		const meta = themesIndex.find(item => item.id === activeThemeId);
		if (!meta || !cssEditor || !filePreview || !filePreviewCode) return;
		if (activeFormat === 'css') {
			cssEditor.hidden = false;
			filePreview.hidden = true;
			return;
		}
		cssEditor.hidden = true;
		filePreview.hidden = false;
		const path = activeFormat === 'js' ? meta.jsPath : meta.packPath;
		try {
			const response = await fetch(`${root}${path}`);
			if (!response.ok) throw new Error('讀取失敗');
			activeFileText = await response.text();
			const lines = activeFileText.split(/\r?\n/);
			filePreviewCode.textContent = lines.length > 200 ? `${lines.slice(0, 200).join('\n')}\n/* ... 共 ${lines.length} 行，複製或下載可取得完整檔案 */` : activeFileText;
		} catch {
			filePreviewCode.textContent = `無法預覽 ${path}`;
		}
	}

	// 風格與明暗模式嚴格維持獨立狀態，切換任一方不得自動改動另一方。
	for (const button of document.querySelectorAll('[data-showcase-theme]')) {
		button.addEventListener('click', () => {
			activeThemeId = button.dataset.showcaseTheme;
			updateButtons();
			postStyleToFrames();
			renderSwatches();
			loadThemeCssForEditor();
			renderActiveFilePane();
		});
	}
	for (const button of document.querySelectorAll('[data-showcase-mode]')) {
		button.addEventListener('click', () => {
			activeMode = button.dataset.showcaseMode;
			updateButtons();
			postStyleToFrames();
			renderSwatches();
		});
	}
	for (const button of document.querySelectorAll('[data-file-format]')) {
		button.addEventListener('click', () => {
			activeFormat = button.dataset.fileFormat;
			updateButtons();
			renderActiveFilePane();
		});
	}
	if (cssEditor) {
		cssEditor.addEventListener('input', () => {
			editedCssText = cssEditor.value;
			clearTimeout(cssTimer);
			cssTimer = setTimeout(() => {
				postCustomCssToFrames();
				if (themeStatus) themeStatus.textContent = '已即時套用自訂 CSS 至上方組合與元件展示。';
			}, 80);
		});
	}
	if (resetCssButton) {
		resetCssButton.addEventListener('click', () => {
			editedCssText = originalCssText;
			if (cssEditor) cssEditor.value = originalCssText;
			postCustomCssToFrames();
			if (themeStatus) themeStatus.textContent = '已重設為原始版本 CSS。';
		});
	}
	if (copyFileButton) {
		copyFileButton.addEventListener('click', async () => {
			const payload = activeFormat === 'css' ? editedCssText : activeFileText;
			if (!payload) return;
			try {
				await navigator.clipboard.writeText(payload);
				if (themeStatus) themeStatus.textContent = `已複製目前 ${activeThemeId}.${activeFormat} 檔案內容。`;
			} catch {
				if (themeStatus) themeStatus.textContent = '無法自動寫入剪貼簿，請直接點擊下載按鈕。';
			}
		});
	}

	ideFrame?.addEventListener('load', () => { postStyleToFrames(); postCustomCssToFrames(); });
	matrixFrame?.addEventListener('load', () => { postStyleToFrames(); postCustomCssToFrames(); });
	window.addEventListener('message', event => {
		const data = event.data;
		if (!data || data.type !== 'klp-style-change') return;
		if (typeof data.themeId === 'string') {
			activeThemeId = data.themeId;
			loadThemeCssForEditor();
		}
		if (typeof data.mode === 'string') activeMode = data.mode;
		updateButtons();
		postStyleToFrames();
		renderSwatches();
		renderActiveFilePane();
	});

	Promise.all([
		fetch(`${root}styles/themes/index.json`).then(r => r.json()),
		fetch(`${root}styles/themes/swatches.json`).then(r => r.json()),
	]).then(([indexData, swatches]) => {
		themesIndex = indexData.themes ?? [];
		swatchesData = swatches;
		updateButtons();
		renderSwatches();
		loadThemeCssForEditor();
		renderActiveFilePane();
	}).catch(() => {
		if (themeStatus) themeStatus.textContent = '無法載入色票資料，請從下載按鈕取得風格檔。';
	});
}

// 獨立元件表頁（components.html）：左側分類 Navigator + 獨立控制列 + 單一元件舞台。
const componentNav = document.querySelector('#component-nav');
const componentStageFrame = document.querySelector('#component-stage-frame');
if (componentNav && componentStageFrame) {
	let compThemeId = 'micro-elevation-v1';
	let compMode = 'light';
	let compLang = 'react';
	const searchInput = document.querySelector('#component-search');
	const searchStatus = document.querySelector('#component-search-status');
	const activeLabel = document.querySelector('#active-component-label');
	const standaloneLink = document.querySelector('#open-component-standalone');
	const navLinks = [...componentNav.querySelectorAll('[data-component-id]')];
	const navGroups = [...componentNav.querySelectorAll('details')];
	let activeComponentId = decodeURIComponent(location.hash.replace(/^#/, '')) || navLinks[0]?.dataset.componentId || 'KlpButton';

	function syncComponentFrame() {
		componentStageFrame.contentWindow?.postMessage({ type: 'klp-select-component', id: activeComponentId }, '*');
		componentStageFrame.contentWindow?.postMessage({ type: 'klp-style-change', themeId: compThemeId, mode: compMode }, '*');
		componentStageFrame.contentWindow?.postMessage({ type: 'klp-language-change', language: compLang }, '*');
	}

	function selectComponent(id, updateHash = true) {
		if (!navLinks.some(link => link.dataset.componentId === id)) return;
		activeComponentId = id;
		if (updateHash) history.replaceState(null, '', `#${encodeURIComponent(id)}`);
		for (const link of navLinks) {
			const match = link.dataset.componentId === id;
			if (match) {
				link.setAttribute('aria-current', 'true');
				const parentGroup = link.closest('details');
				if (parentGroup) parentGroup.open = true;
			} else {
				link.removeAttribute('aria-current');
			}
		}
		if (activeLabel) activeLabel.textContent = id;
		if (standaloneLink) standaloneLink.href = `${root}examples/react/index.html?showcase=single&component=${encodeURIComponent(id)}`;
		syncComponentFrame();
	}

	function updateComponentToolbar() {
		for (const button of document.querySelectorAll('[data-comp-theme]')) {
			const selected = button.dataset.compTheme === compThemeId;
			button.setAttribute('aria-pressed', String(selected));
			button.classList.toggle('primary', selected);
			button.classList.toggle('secondary', !selected);
		}
		for (const button of document.querySelectorAll('[data-comp-mode]')) {
			const selected = button.dataset.compMode === compMode;
			button.setAttribute('aria-pressed', String(selected));
			button.classList.toggle('primary', selected);
			button.classList.toggle('secondary', !selected);
		}
		for (const button of document.querySelectorAll('[data-comp-lang]')) {
			const selected = button.dataset.compLang === compLang;
			button.setAttribute('aria-pressed', String(selected));
			button.classList.toggle('primary', selected);
			button.classList.toggle('secondary', !selected);
		}
	}

	for (const link of navLinks) {
		link.addEventListener('click', event => {
			event.preventDefault();
			selectComponent(link.dataset.componentId);
		});
	}
	for (const button of document.querySelectorAll('[data-comp-theme]')) {
		button.addEventListener('click', () => {
			compThemeId = button.dataset.compTheme;
			updateComponentToolbar();
			syncComponentFrame();
		});
	}
	for (const button of document.querySelectorAll('[data-comp-mode]')) {
		button.addEventListener('click', () => {
			compMode = button.dataset.compMode;
			updateComponentToolbar();
			syncComponentFrame();
		});
	}
	for (const button of document.querySelectorAll('[data-comp-lang]')) {
		button.addEventListener('click', () => {
			compLang = button.dataset.compLang;
			updateComponentToolbar();
			syncComponentFrame();
		});
	}
	if (searchInput) {
		searchInput.addEventListener('input', () => {
			const query = searchInput.value.trim().toLowerCase();
			let matches = 0;
			for (const group of navGroups) {
				let groupMatches = 0;
				for (const link of group.querySelectorAll('[data-component-id]')) {
					const visible = !query || link.textContent.toLowerCase().includes(query) || link.dataset.componentId.toLowerCase().includes(query);
					link.hidden = !visible;
					if (visible) { groupMatches++; matches++; }
				}
				group.hidden = groupMatches === 0;
				if (query && groupMatches > 0) group.open = true;
			}
			if (searchStatus) searchStatus.textContent = query ? `符合 ${matches} 個元件` : `共 ${navLinks.length} 個元件`;
		});
	}

	window.addEventListener('hashchange', () => {
		const target = decodeURIComponent(location.hash.replace(/^#/, ''));
		if (target) selectComponent(target, false);
	});
	componentStageFrame.addEventListener('load', syncComponentFrame);
	selectComponent(activeComponentId, false);
	updateComponentToolbar();
}
