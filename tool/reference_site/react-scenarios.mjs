function escapeHtml(value) {
	return String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&#39;');
}

export function validateReactScenarios(registry) {
	// 場景 identity 由公開 example registry 擁有；路由與文字在網站邊界驗證。
	if (!registry || typeof registry !== 'object' || Array.isArray(registry) || !Object.keys(registry).length) throw new Error('Invalid React scenario registry');
	const titles = new Set();
	return Object.entries(registry).map(([id, scene]) => {
		if (!/^[a-z][a-z0-9-]*$/.test(id) || typeof scene?.title !== 'string' || !scene.title.trim() || titles.has(scene.title)) throw new Error(`Invalid React scenario: ${id}`);
		if (typeof scene.reference !== 'string' || new URL(scene.reference).protocol !== 'https:') throw new Error(`Invalid React scenario reference: ${id}`);
		titles.add(scene.title);
		return { id, title: scene.title, reference: scene.reference, href: `docs/react/scenarios/${id}.html` };
	}).sort((a, b) => a.id < b.id ? -1 : Number(a.id > b.id));
}

export function renderReactScenario(scene, bundleUrl) {
	const title = escapeHtml(scene.title);
	const url = escapeHtml(bundleUrl);
	return `<h2 id="interactive">互動場景</h2><section class="component-specimen"><p role="status" data-specimen-state="loading">展示載入中…</p><iframe title="${title} React 互動展示" src="${url}" data-component-specimen></iframe><p><a href="${url}" target="_blank" rel="noopener">獨立開啟 ${title} 展示 ↗</a></p></section><h2 id="composition">公開元件組裝</h2><p>使用公開 Dock、Explorer、Frame 與命令元件；布局與場景資料由 example 擁有。3D、正文及終端執行核心由產品接入，展示清楚標示示意。</p><p><a href="${escapeHtml(scene.reference)}" target="_blank" rel="noopener">官方布局參考 ↗</a></p>`;
}
