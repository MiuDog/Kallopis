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
					const matches = entries.filter(entry => `${entry.title} ${entry.category} ${entry.href}`.toLowerCase().includes(query));
					status.textContent = `${matches.length} 筆結果${matches.length > 100 ? '，先顯示 100 筆，請增加關鍵字縮小範圍' : ''}`;
					for (const entry of matches.slice(0, 100)) appendLink(navigation, `${root}${entry.href}`, `${entry.title} · ${entry.category}`);
					return;
				}
				status.textContent = '搜尋全部指南、元件、規格與 API';
				for (const [href, label] of [['docs/index.html', '文件中心'], ['docs/get-started.html', '開始使用'], ['docs/guides/ai/style-v1.html', '風格 v1.0.0'], ['docs/components/index.html', '全部元件'], ['docs/api/index.html', '架構與 API']]) appendLink(navigation, `${root}${href}`, label);
				const groups = new Map();
				for (const entry of entries) {
					const category = entry.category === 'API' ? 'API' : entry.category === 'Guide' ? '指南' : entry.category === 'Spec' ? '規格與決策' : entry.category === 'Project' ? '專案' : '元件';
					if (!groups.has(category)) groups.set(category, []);
					groups.get(category).push(entry);
				}
				for (const [category, items] of groups) {
					const group = appendDetails(navigation, `${category} · ${items.length}`);
					const areas = new Map();
					for (const entry of items) {
						const area = entry.apiArea || entry.guideArea || entry.category;
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
