const kinds = new Set(['basic', 'layout', 'command', 'dock', 'theme']);

function escapeHtml(value) {
	return String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&#39;');
}

export function validateReactSpecimens(inventory, registry) {
	// 正式清單與example的實際factory資料必須雙向相等，不能由產物自述coverage。
	if (inventory?.schemaVersion !== 1 || inventory.framework !== 'react' || inventory.entrypoint !== '@kallopis/react' || !Array.isArray(inventory.components)) throw new Error('Invalid React component inventory');
	if (!registry || typeof registry !== 'object' || Array.isArray(registry)) throw new Error('Invalid specimen registry');
	const names = new Set();
	const components = [];
	for (const component of inventory.components) {
		const name = component?.name;
		if (typeof name !== 'string' || !name || names.has(name) || component.id !== `@kallopis/react#${name}`) throw new Error(`Invalid or duplicate React identity: ${name}`);
		if (typeof component.source !== 'string' || !component.source || typeof component.signature !== 'string' || !component.signature || typeof component.propsType !== 'string') throw new Error(`Incomplete React component: ${name}`);
		if (!Object.hasOwn(registry, name) || !kinds.has(registry[name])) throw new Error(`Missing or invalid specimen: ${name}`);
		names.add(name);
		components.push({ ...component, href: `docs/react/components/${encodeURIComponent(name)}.html` });
	}
	for (const name of Object.keys(registry)) if (!names.has(name)) throw new Error(`Ghost specimen: ${name}`);
	return components.sort((a, b) => a.name < b.name ? -1 : Number(a.name > b.name));
}

export function renderReactSpecimen(component, bundleUrl) {
	const name = escapeHtml(component.name);
	const url = escapeHtml(bundleUrl);
	return `<h2 id="interactive">互動展示</h2><section class="component-specimen"><p role="status" data-specimen-state="loading">展示載入中…</p><iframe title="${name} React 互動展示" src="${url}" data-component-specimen></iframe><p><a href="${url}" target="_blank" rel="noopener">獨立開啟 ${name} 展示 ↗</a></p></section><h2 id="usage">公開使用</h2><pre><code>${escapeHtml(`import { ${component.name} } from '@kallopis/react';`)}</code></pre><p>使用例與參數控制在展示中；輸入、選取與回呼由 example 擁有。</p><h2 id="signature">公開簽名</h2><pre><code>${escapeHtml(component.signature)}</code></pre><h2 id="source">來源</h2><p><code>${escapeHtml(component.source)}</code></p>`;
}
