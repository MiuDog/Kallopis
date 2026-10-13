import fs from 'node:fs';
import path from 'node:path';

function escapeHtml(value) {
	return String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&#39;');
}

export function validateFlutterScenarios(registry) {
	// 正式 example JSON 擁有場景；網站只驗證跨語言 metadata 邊界。
	if (!registry || typeof registry !== 'object' || Array.isArray(registry) || !Object.keys(registry).length) throw new Error('Invalid Flutter scenario registry');
	const titles = new Set();
	return Object.entries(registry).map(([id, scene]) => {
		if (!/^[a-z][a-z0-9-]*$/.test(id) || typeof scene?.title !== 'string' || !scene.title.trim() || titles.has(scene.title)) throw new Error(`Invalid Flutter scenario: ${id}`);
		if (typeof scene.reference !== 'string' || !/^https:\/\/[^/\\?#\s]/i.test(scene.reference)) throw new Error(`Invalid Flutter scenario reference: ${id}`);
		const reference = new URL(scene.reference);
		if (reference.protocol !== 'https:' || !reference.host) throw new Error(`Invalid Flutter scenario reference: ${id}`);
		titles.add(scene.title);
		return { id, title: scene.title, reference: scene.reference, href: `docs/flutter/scenarios/${id}.html` };
	}).sort((a, b) => a.id < b.id ? -1 : Number(a.id > b.id));
}

export function renderFlutterScenario(scene, bundleUrl) {
	const title = escapeHtml(scene.title);
	const url = escapeHtml(bundleUrl);
	return `<h2 id="interactive">互動場景</h2><section class="component-specimen"><p role="status" data-specimen-state="loading">展示載入中…</p><iframe title="${title} Flutter 互動展示" src="${url}" data-component-specimen data-specimen-framework="flutter"></iframe><p><a href="${url}" target="_blank" rel="noopener">獨立開啟 ${title} 展示 ↗</a></p></section><h2 id="composition">公開元件組裝</h2><p>使用公開 Dock、Explorer、Frame 與命令元件；布局與場景資料由 example 擁有。3D、正文及終端執行核心由產品接入，展示清楚標示示意。</p><p><a href="${escapeHtml(scene.reference)}" target="_blank" rel="noopener">官方布局參考 ↗</a></p>`;
}

export function validateFlutterBundle(directory, registry) {
	// 清理網站前確認執行入口、package 資產與同一份場景權威都存在。
	const root = path.resolve(directory);
	function read(asset) {
		if (typeof asset !== 'string' || !asset || path.isAbsolute(asset)) throw new Error('Invalid Flutter bundle asset');
		const target = path.resolve(root, asset);
		const relative = path.relative(root, target);
		if (!relative || relative.startsWith('..') || path.isAbsolute(relative)) throw new Error(`Invalid Flutter bundle asset: ${asset}`);
		return fs.readFileSync(target);
	}
	const html = read('index.html').toString('utf8');
	if (!/<base\s+href=["']\/Kallopis\/examples\/flutter\/["']\s*\/?\s*>/.test(html)) throw new Error('Invalid Flutter bundle base href');
	read('flutter_bootstrap.js');
	read('main.dart.js');
	const fonts = JSON.parse(read('assets/FontManifest.json'));
	if (!Array.isArray(fonts) || !fonts.length) throw new Error('Invalid Flutter font manifest');
	for (const font of fonts) {
		if (!Array.isArray(font?.fonts) || !font.fonts.length) throw new Error('Invalid Flutter font entry');
		for (const entry of font.fonts) read(`assets/${entry.asset}`);
	}
	const metadata = JSON.parse(read('assets/assets/gui-scenarios.json'));
	if (JSON.stringify(validateFlutterScenarios(metadata)) !== JSON.stringify(validateFlutterScenarios(registry))) throw new Error('Flutter bundle scenario metadata mismatch');
}
