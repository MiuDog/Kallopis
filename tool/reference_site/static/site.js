const root = document.body.dataset.root ?? '';

fetch(`${root}search-index.json`)
	.then((response) => response.ok ? response.json() : [])
	.then((entries) => {
		const navigation = document.querySelector('#navigation');
		const search = document.querySelector('#search');
		const components = groupEntries(entries, 'API', 'category');
		const apiGroups = groupEntries(entries, 'API', 'apiArea');
		const guideGroups = groupEntries(entries, 'Guide', 'guideArea');

		function render(filter = '') {
			const normalized = filter.trim().toLowerCase();
			navigation.replaceChildren();
			appendLink(navigation, `${root}index.html`, 'Overview');
			appendLink(navigation, `${root}get-started.html`, 'Get started');
			appendApiNavigation(navigation, apiGroups);
			appendGuideNavigation(navigation, guideGroups, normalized);
			appendComponentNavigation(navigation, components, normalized);
		}

		search.addEventListener('input', (event) => render(event.target.value));
		render();
	});

function groupEntries(entries, excludedCategory, key) {
	const groups = new Map();
	for (const entry of entries) {
		if (key === 'category' && (entry.category === 'API' || entry.category === 'Guide')) continue;
		if (key !== 'category' && entry.category !== excludedCategory) continue;
		const group = entry[key] || 'root';
		groups.set(group, [...(groups.get(group) ?? []), entry]);
	}
	return groups;
}

function appendApiNavigation(navigation, groups) {
	const details = appendDetails(navigation, 'API Reference');
	appendLink(details, `${root}api/index.html`, 'All API');
	for (const [area, entries] of [...groups.entries()].sort(([left], [right]) => left.localeCompare(right))) {
		appendLink(details, `${root}api/index.html#${slug(area)}`, `${area} ${entries.length}`);
	}
}

function appendGuideNavigation(navigation, groups, filter) {
	const details = appendDetails(navigation, 'Documentation');
	for (const [area, entries] of [...groups.entries()].sort(([left], [right]) => left.localeCompare(right))) {
		const visible = entries.filter((entry) => entry.title.toLowerCase().includes(filter));
		if (visible.length === 0) continue;
		const group = appendDetails(details, `${area} docs`);
		for (const entry of visible) appendLink(group, `${root}${entry.href}`, entry.title);
	}
}

function appendComponentNavigation(navigation, groups, filter) {
	let found = false;
	for (const [category, entries] of groups) {
		const visible = entries.filter((entry) => entry.title.toLowerCase().includes(filter));
		if (visible.length === 0) continue;
		found = true;
		const details = appendDetails(navigation, category, true);
		for (const entry of visible) appendLink(details, `${root}${entry.href}`, entry.title);
	}
	if (!found) {
		const message = document.createElement('p');
		message.textContent = 'No matching component.';
		navigation.append(message);
	}
}

function appendDetails(parent, label, open = false) {
	const details = document.createElement('details');
	details.open = open;
	const summary = document.createElement('summary');
	summary.textContent = label;
	details.append(summary);
	parent.append(details);
	return details;
}

function appendLink(parent, href, label) {
	const link = document.createElement('a');
	link.href = href;
	link.textContent = label;
	parent.append(link);
}

function slug(value) {
	return value.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}
