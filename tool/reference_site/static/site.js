const root = document.body.dataset.root ?? '';
fetch(`${root}search-index.json`)
	.then((response) => response.ok ? response.json() : [])
	.then((entries) => {
		const navigation = document.querySelector('#navigation');
		const search = document.querySelector('#search');
		const groups = new Map();
		const apiGroups = new Map();
		const guideGroups = new Map();
		for (const entry of entries) {
			if (entry.category === 'API') {
				const area = entry.apiArea || 'root';
				apiGroups.set(area, (apiGroups.get(area) || 0) + 1);
				continue;
			}
			if (entry.category === 'Guide') {
				const area = entry.guideArea || 'root';
				const guides = guideGroups.get(area) ?? [];
				guides.push(entry);
				guideGroups.set(area, guides);
				continue;
			}
			const group = groups.get(entry.category) ?? [];
			group.push(entry);
			groups.set(entry.category, group);
		}
		function render(filter = '') {
			const normalized = filter.trim().toLowerCase();
			const apiNavigation = [...apiGroups.entries()].sort(([left], [right]) => left.localeCompare(right)).map(([area, count]) => `<a href="${root}api/index.html#${slug(area)}">${escapeHtml(area)} <small>${count}</small></a>`).join('');
			const guideNavigation = [...guideGroups.entries()].sort(([left], [right]) => left.localeCompare(right)).map(([area, guides]) => {
				const visible = guides.filter((guide) => guide.title.toLowerCase().includes(normalized));
				if (visible.length === 0) return '';
				return `<details><summary>${escapeHtml(area)} docs</summary>${visible.map((guide) => `<a href="${root}${guide.href}">${escapeHtml(guide.title)}</a>`).join('')}</details>`;
			}).join('');
			const componentNavigation = [...groups.entries()].map(([group, items]) => {
				const visible = items.filter((item) => item.title.toLowerCase().includes(normalized));
				if (visible.length === 0) return '';
				return `<details open><summary>${group}</summary>${visible.map((item) => `<a href="${root}${item.href}">${item.title}</a>`).join('')}</details>`;
			}).join('');
			navigation.innerHTML = `<a href="${root}index.html">Overview</a><a href="${root}get-started.html">Get started</a><details><summary>API Reference</summary><a href="${root}api/index.html">All API</a>${apiNavigation}</details><details><summary>Documentation</summary>${guideNavigation}</details>${componentNavigation || '<p>No matching component.</p>'}`;
		}
		search.addEventListener('input', (event) => render(event.target.value));
		render();
	});

function slug(value) {
	return value.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}

function escapeHtml(value) {
	return value.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');
}
