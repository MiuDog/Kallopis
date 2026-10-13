import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { renderToString } from 'react-dom/server';
import { JSDOM } from 'jsdom';
import { fileURLToPath } from 'node:url';
import { mkdtempSync, writeFileSync, symlinkSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import * as klp from '../dist/index.js';

const h = React.createElement;
const clone = value => structuredClone(value);
const provider = (child, stylePack) => h(klp.KlpThemeProvider, { stylePack }, child);
const policy = panels => panels.map(({ id, allowSide, allowBottom }) => ({ id, ...(allowSide === undefined ? {} : { allowSide }), ...(allowBottom === undefined ? {} : { allowBottom }) }));
const deferred = () => {
	let resolve, reject;
	const promise = new Promise((yes, no) => { resolve = yes; reject = no; });
	return { promise, resolve, reject };
};
function layout() {
	return {
		left: { axis: 'vertical', isVisible: true, extent: 160, groups: [{ id: 'left-group', panelIds: ['a', 'b'], activePanelId: 'a', mainAxisExtent: 100 }] },
		right: { axis: 'horizontal', isVisible: true, extent: 120, groups: [{ id: 'right-group', panelIds: ['c'], activePanelId: 'c', mainAxisExtent: 120 }] },
		bottom: { axis: 'horizontal', isVisible: false, extent: 80, groups: [] },
	};
}
function panels(extra = {}) {
	return ['a', 'b', 'c'].map(id => ({ id, label: id.toUpperCase(), content: h('input', { id: `input-${id}`, defaultValue: `正文-${id}` }), ...extra[id] }));
}
function dock(props, pack) {
	assert.ok(klp.KlpDockLayout, 'KlpDockLayout 必須由公開 dist 匯出；缺 export 是 compile Yellow');
	return provider(h(klp.KlpDockLayout, {
		layout: layout(), panels: panels(), stage: h('input', { id: 'stage-input', defaultValue: '舞台' }),
		contentHeader: h('span', { id: 'header-content' }, '頂列'),
		leftConstraints: { minExtent: 80 }, rightConstraints: { minExtent: 80 }, bottomConstraints: { minExtent: 32 },
		onLayoutChanged: () => {}, id: 'dock', style: { width: '100%', height: '100%' }, ...props,
	}), pack);
}
function tab(mount, id) {
	const result = [...mount.querySelectorAll('[role="tab"]')].find(node => {
		const walker = node.ownerDocument.createTreeWalker(node, 4);
		while (walker.nextNode()) if (walker.currentNode.nodeValue.trim() === id.toUpperCase()) return true;
		return node.getAttribute('aria-label') === id.toUpperCase();
	});
	assert.ok(result, `${id} 必須有公開 tab`);
	return result;
}
function closeButton(mount, id) {
	const result = mount.querySelector(`button[aria-label="Close ${id.toUpperCase()}"]`);
	assert.ok(result, `${id} 必須有獨立 close button`);
	return result;
}
function panel(mount, id) {
	const control = tab(mount, id).getAttribute('aria-controls');
	assert.ok(control, 'tab 必須透過 aria-controls 連接正文');
	const result = mount.ownerDocument.getElementById(control);
	assert.equal(result?.getAttribute('role'), 'tabpanel');
	assert.ok(result.contains(mount.querySelector(`#input-${id}`)), 'tabpanel 必須持有對應產品正文');
	return result;
}
function hidden(node) {
	return Boolean(node.closest('[hidden]'));
}
function immutable(result, source, before) {
	assert.deepEqual(source, before, '事件不得修改 caller snapshot');
	assert.notEqual(result, source, '提交必須使用分離 snapshot');
	for (const area of Object.values(result)) {
		assert.ok(Object.isFrozen(area));
		assert.ok(Object.isFrozen(area.groups));
		for (const group of area.groups) assert.ok(Object.isFrozen(group) && Object.isFrozen(group.panelIds));
	}
	assert.ok(Object.isFrozen(result));
}

// jsdom 沒有排版引擎；此 seam 只供尺寸／observer 生命週期，不代表原生瀏覽器證據。
async function fixture(t, { width = 600, height = 300, serverHtml = null } = {}) {
	const dom = new JSDOM('<!doctype html><div id="mount"></div>', { url: 'http://localhost' });
	const win = dom.window;
	const mount = win.document.querySelector('#mount');
	if (serverHtml !== null) mount.innerHTML = serverHtml;
	const previous = new Map(), observers = new Set(), box = { width, height };
	class ResizeObserver {
		constructor(callback) { this.callback = callback; this.targets = new Set(); observers.add(this); }
		observe(target) { this.targets.add(target); }
		unobserve(target) { this.targets.delete(target); }
		disconnect() { this.targets.clear(); }
	}
	const globals = { window: win, document: win.document, navigator: win.navigator, HTMLElement: win.HTMLElement, Element: win.Element, Node: win.Node, MutationObserver: win.MutationObserver, getComputedStyle: win.getComputedStyle.bind(win), ResizeObserver, IS_REACT_ACT_ENVIRONMENT: true };
	win.ResizeObserver = ResizeObserver;
	for (const [name, value] of Object.entries(globals)) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	function size(node, axis, depth = 0) {
		if (!node || depth > 40) return 0;
		if (node === mount) return box[axis];
		const css = win.getComputedStyle(node), specified = css[axis];
		if (/^[\d.e+-]+px$/i.test(specified)) return Number.parseFloat(specified);
		const parent = node.parentElement;
		const padding = axis === 'width' ? ['paddingLeft', 'paddingRight'] : ['paddingTop', 'paddingBottom'];
		const available = Math.max(0, size(parent, axis, depth + 1) - (parent ? padding.reduce((sum, key) => sum + (Number.parseFloat(win.getComputedStyle(parent)[key]) || 0), 0) : 0));
		return specified.endsWith('%') ? available * Number.parseFloat(specified) / 100 : available;
	}
	win.HTMLElement.prototype.getBoundingClientRect = function () {
		const width = size(this, 'width'), height = size(this, 'height');
		return { x: 0, y: 0, left: 0, top: 0, right: width, bottom: height, width, height, toJSON() { return this; } };
	};
	for (const [name, axis] of [['clientWidth', 'width'], ['clientHeight', 'height'], ['offsetWidth', 'width'], ['offsetHeight', 'height']]) Object.defineProperty(win.HTMLElement.prototype, name, { configurable: true, get() { return size(this, axis); } });
	const { createRoot, hydrateRoot } = await import('react-dom/client');
	let root = serverHtml === null ? createRoot(mount) : null, unmounted = false;
	const hydrationErrors = [];
	async function unmount() {
		if (!unmounted) { if (root) await act(() => root.unmount()); unmounted = true; }
	}
	t.after(async () => {
		await unmount();
		win.close();
		for (const [name, descriptor] of previous) {
			if (descriptor) Object.defineProperty(globalThis, name, descriptor);
			else delete globalThis[name];
		}
	});
	return {
		mount, win, observers, unmount, hydrationErrors,
		render: view => act(() => root.render(view)),
		hydrate: view => act(() => { root = hydrateRoot(mount, view, { onRecoverableError: error => hydrationErrors.push(error) }); }),
		click: node => act(() => node.click()),
		key: (node, key) => act(() => { node.focus(); node.dispatchEvent(new win.KeyboardEvent('keydown', { key, bubbles: true, cancelable: true })); }),
		settle: callback => act(async () => { callback(); await Promise.resolve(); }),
		async resize(width, height) {
			box.width = width; box.height = height;
			await act(() => {
				for (const observer of observers) if (observer.targets.size) observer.callback([...observer.targets].map(target => ({ target, contentRect: target.getBoundingClientRect() })), observer);
				win.dispatchEvent(new win.Event('resize'));
			});
		},
	};
}

test('公開 SSR、tab 可及連接、metadata 與完整非法輸入拒絕', () => {
	const registry = panels({ a: { isPinned: true, isDirty: true, icon: h('span', { 'aria-label': '產品圖示' }, '*') }, b: { onCloseRequested: () => true }, c: { onCloseRequested: () => true } });
	const source = layout(), before = clone(source), frozenContent = Object.isFrozen(registry[0].content);
	const html = renderToString(dock({ layout: source, panels: registry }));
	assert.doesNotMatch(html, /NaN|Infinity/);
	const dom = new JSDOM(html), mount = dom.window.document.body;
	assert.ok(mount.querySelector('#stage-input') && mount.querySelector('#header-content'));
	for (const id of ['a', 'b', 'c']) {
		const node = tab(mount, id);
		assert.equal(node.tagName, 'BUTTON');
		assert.equal(node.getAttribute('aria-selected'), String(id !== 'b'));
		assert.equal(node.tabIndex, id === 'b' ? -1 : 0);
		panel(mount, id);
		assert.equal(node.querySelector('button'), null, 'close 不得巢狀於 tab button');
	}
	assert.ok(hidden(panel(mount, 'b')), '非 active 正文以 hidden 保留');
	assert.ok(!hidden(panel(mount, 'a')));
	assert.ok([...mount.querySelectorAll('[role="tablist"]')].some(node => /Left/.test(node.getAttribute('aria-label')) && /left-group/.test(node.getAttribute('aria-label'))));
	assert.ok([...mount.querySelectorAll('[title]')].filter(node => node.getAttribute('title')?.trim()).length >= 2, 'pinned／dirty 必須有非空可及 title');
	assert.equal(mount.querySelector('button[aria-label="Close A"]'), null, '沒有批准 callback 就沒有 close 入口');
	closeButton(mount, 'b'); closeButton(mount, 'c');
	assert.equal(mount.querySelector('button[aria-label="Bottom"]'), null, '空區域不得提供無效 reopen');
	assert.deepEqual(source, before);
	assert.equal(Object.isFrozen(registry[0].content), frozenContent, '不得額外 freeze 產品 ReactNode');
	assert.equal(Object.isFrozen(registry), false, '不得 freeze caller registry');
	dom.window.close();
	const invalidLayouts = [clone(source), clone(source)];
	invalidLayouts[0].left.groups[0].panelIds.push('missing');
	invalidLayouts[1].right.groups[0].panelIds.push('a');
	for (const candidate of invalidLayouts) assert.throws(() => renderToString(dock({ layout: candidate })), TypeError);
	for (const extra of [{ a: { allowSide: false } }, { a: { label: ' ' } }, { a: { onCloseRequested: 3 } }, { a: { closeLabel: '' } }, { a: { isDirty: 'yes' } }]) assert.throws(() => renderToString(dock({ panels: panels(extra) })), TypeError);
	assert.throws(() => renderToString(dock({ panels: [...panels(), panels()[0]] })), TypeError);
});

test('公開 declarations 可供受控原生 React consumer 使用', () => {
	// consumer 位於系統暫存目錄；不寫工作樹、package 或設定，finally 清理自有 fixture。
	const directory = mkdtempSync(join(tmpdir(), 'klp-dock-consumer-'));
	const filename = join(directory, 'consumer.mts');
	const publicEntry = fileURLToPath(new URL('../dist/index.js', import.meta.url)).replaceAll('\\', '/');
	const source = `import React from 'react';
import { KlpDockLayout, KlpThemeProvider, type KlpDockPanel, type KlpDockLayoutProps, type KlpDockLayoutData } from '${publicEntry}';
const panel: KlpDockPanel = { id: 'a', label: 'A', content: React.createElement('input'), icon: React.createElement('span'), draggable: false, isPinned: true, isDirty: true, allowSide: true, allowBottom: false, closeLabel: 'Close A', onCloseRequested: async () => true };
const area = { axis: 'vertical' as const, isVisible: false, extent: 80, groups: [] };
const layout: KlpDockLayoutData = { left: area, right: area, bottom: area };
const props: KlpDockLayoutProps = { layout, panels: [panel], stage: React.createElement('input'), contentHeader: 'header', leftConstraints: { minExtent: 0, maxExtent: Infinity }, rightConstraints: { minExtent: 0 }, onLayoutChanged: next => { const saved: KlpDockLayoutData = next; void saved; }, onCloseError: (error, panelId) => { const id: string = panelId; const reason: unknown = error; void id; void reason; }, areaLabels: { left: 'Tools' }, label: 'Workbench', id: 'consumer', style: { height: 300 } };
React.createElement(KlpThemeProvider, null, React.createElement(KlpDockLayout, { ...props, ref: React.createRef<HTMLDivElement>() }));`;
	try {
		writeFileSync(filename, source);
		symlinkSync(fileURLToPath(new URL('../node_modules', import.meta.url)), join(directory, 'node_modules'), process.platform === 'win32' ? 'junction' : 'dir');
		const result = spawnSync(process.execPath, [fileURLToPath(new URL('../node_modules/typescript/bin/tsc', import.meta.url)), '--ignoreConfig', '--strict', '--skipLibCheck', '--target', 'ES2022', '--module', 'NodeNext', '--moduleResolution', 'NodeNext', '--noEmit', filename], { encoding: 'utf8' });
		assert.equal(result.error, undefined, '公開 consumer 編譯器必須可啟動');
		assert.equal(result.status, 0, `缺公開元件／型別是 compile Yellow，非 behavior Red\n${result.stdout}\n${result.stderr}`);
	} finally {
		rmSync(directory, { recursive: true, force: true });
	}
});

test('受控 select、循環鍵盤 focus、visibility、no-op 與一次 immutable 通知', async t => {
	const f = await fixture(t), registry = panels(), submitted = [];
	let current = layout();
	const draw = () => f.render(dock({ layout: current, panels: registry, onLayoutChanged: next => submitted.push(next), areaLabels: { left: '工具' } }));
	await draw();
	const input = f.mount.querySelector('#input-b'); input.value = '未保存';
	await f.click(tab(f.mount, 'a'));
	assert.equal(submitted.length, 0, 'active click 是 no-op');
	const original = current, before = clone(current);
	await f.click(tab(f.mount, 'b'));
	assert.equal(submitted.length, 1);
	assert.deepEqual(submitted[0], klp.applyKlpDockAction(current, policy(registry), { type: 'select', panelId: 'b' }).layout);
	immutable(submitted[0], original, before);
	assert.equal(tab(f.mount, 'a').getAttribute('aria-selected'), 'true', '通知不自行替 caller 採用 layout');
	current = submitted.pop(); await draw();
	assert.equal(f.mount.querySelector('#input-b'), input); assert.equal(input.value, '未保存');
	for (const [from, key, expected] of [['b', 'ArrowRight', 'a'], ['a', 'ArrowLeft', 'b'], ['b', 'Home', 'a'], ['a', 'End', 'b']]) {
		await f.key(tab(f.mount, from), key);
		assert.equal(submitted.length, 1, `${key} 只通知一次`);
		assert.equal(f.win.document.activeElement, tab(f.mount, expected), `${key} 聚焦目標 tab`);
		assert.equal(submitted[0].left.groups[0].activePanelId, expected);
		current = submitted.pop(); await draw();
	}
	await f.key(tab(f.mount, 'b'), 'End');
	assert.equal(submitted.length, 0, '鍵盤選取相同 active 不通知');
	const edge = f.mount.querySelector('button[aria-label="工具"]');
	assert.ok(edge); assert.equal(edge.getAttribute('aria-expanded'), 'true');
	await f.click(edge);
	assert.equal(submitted.length, 1);
	assert.deepEqual(submitted[0], klp.applyKlpDockAction(current, policy(registry), { type: 'visibility', area: 'left', isVisible: false }).layout);
	current = submitted.pop(); await draw();
	assert.equal(f.mount.querySelector('button[aria-label="工具"]').getAttribute('aria-expanded'), 'false');
	assert.ok(hidden(f.mount.querySelector('#input-b')));
	await f.click(f.mount.querySelector('button[aria-label="工具"]'));
	assert.equal(submitted.length, 1); current = submitted.pop(); await draw();
	assert.equal(f.mount.querySelector('#input-b'), input); assert.equal(input.value, '未保存');
});

test('inactive／single 同步 close、deny、pinned metadata 不阻擋批准', async t => {
	const f = await fixture(t), submitted = [];
	let requested = 0, approved = false, current = layout();
	const registry = panels({ b: { isPinned: true, isDirty: true, onCloseRequested: () => { requested += 1; return approved; } }, c: { onCloseRequested: () => true, closeLabel: '關閉唯一面板' } });
	const draw = () => f.render(dock({ layout: current, panels: registry, onLayoutChanged: next => submitted.push(next) }));
	await draw(); await f.click(closeButton(f.mount, 'b'));
	assert.equal(requested, 1); assert.equal(submitted.length, 0);
	assert.equal(closeButton(f.mount, 'b').disabled, false);
	approved = true; const before = clone(current); await f.click(closeButton(f.mount, 'b'));
	assert.equal(requested, 2); assert.equal(submitted.length, 1);
	assert.deepEqual(submitted[0], klp.applyKlpDockAction(current, policy(registry), { type: 'close', panelId: 'b', approved: true }).layout);
	immutable(submitted[0], current, before);
	current = submitted.pop(); await draw();
	const single = f.mount.querySelector('button[aria-label="關閉唯一面板"]'); assert.ok(single); await f.click(single);
	assert.equal(submitted.length, 1); assert.deepEqual(submitted[0].right.groups, []);
	assert.equal(registry.length, 3, 'close 不刪產品 registry');
});

test('Promise pending 不重入，其他操作仍可用，批准從 latest moved snapshot 提交', async t => {
	const f = await fixture(t), request = deferred(), submitted = [];
	let calls = 0, current = layout();
	const registry = panels({ b: { onCloseRequested: () => { calls += 1; return request.promise; } }, c: { onCloseRequested: () => false } });
	const draw = () => f.render(dock({ layout: current, panels: registry, onLayoutChanged: next => submitted.push(next) }));
	await draw(); await f.click(closeButton(f.mount, 'b')); await f.click(closeButton(f.mount, 'b'));
	assert.equal(calls, 1); assert.equal(closeButton(f.mount, 'b').disabled, true);
	assert.equal(closeButton(f.mount, 'c').disabled, false); await f.click(closeButton(f.mount, 'c'));
	await f.click(tab(f.mount, 'b')); assert.equal(submitted.length, 1);
	current = submitted.pop(); await draw();
	current = klp.applyKlpDockAction(current, policy(registry), { type: 'move', panelId: 'b', destination: { kind: 'tab', area: 'right', groupId: 'right-group', index: 1 } }).layout;
	await draw(); const before = clone(current);
	await f.settle(() => request.resolve(true));
	assert.equal(submitted.length, 1);
	assert.deepEqual(submitted[0], klp.applyKlpDockAction(current, policy(registry), { type: 'close', panelId: 'b', approved: true }).layout);
	immutable(submitted[0], current, before);
	assert.deepEqual(submitted[0].right.groups[0].panelIds, ['c']);
});

test('離開再開、registry 移除、callback 替換與 unmount 都使舊批准失效', async t => {
	const f = await fixture(t);
	for (const kind of ['removed-reopened', 'registry-removed', 'callback-replaced', 'unmount']) {
		const request = deferred(), submitted = [];
		let calls = 0, current = layout(), registry = panels({ b: { onCloseRequested: () => { calls += 1; return request.promise; } } });
		const originalRegistry = registry;
		const draw = () => f.render(dock({ layout: current, panels: registry, onLayoutChanged: next => submitted.push(next) }));
		await draw(); await f.click(closeButton(f.mount, 'b'));
		if (kind === 'callback-replaced') {
			registry = panels({ b: { onCloseRequested: () => false } }); await draw();
		} else if (kind === 'unmount') {
			await f.unmount();
		} else {
			current = klp.applyKlpDockAction(current, policy(registry), { type: 'close', panelId: 'b', approved: true }).layout;
			if (kind === 'registry-removed') registry = registry.filter(item => item.id !== 'b');
			await draw();
			registry = originalRegistry;
			current = klp.applyKlpDockAction(current, policy(registry), { type: 'open', panelId: 'b', destination: { kind: 'tab', area: 'left', groupId: 'left-group', index: 1 } }).layout;
			await draw();
		}
		await f.settle(() => request.resolve(true));
		assert.equal(calls, 1); assert.equal(submitted.length, 0, `${kind} 不得讓舊批准關閉新面板或復活 layout`);
		if (kind !== 'unmount') {
			assert.ok(f.mount.querySelector('#input-b'));
			assert.equal(closeButton(f.mount, 'b').disabled, false, `${kind} 解除失效 pending`);
		}
	}
});

test('throw／rejection／非 boolean 保留 layout、解除 pending、回報原始 error；host fallback', async t => {
	const f = await fixture(t), submitted = [], errors = [], source = layout(), before = clone(source);
	const thrown = new Error('同步拒絕'), rejected = new Error('非同步拒絕');
	for (const [callback, expected] of [[() => { throw thrown; }, thrown], [() => Promise.reject(rejected), rejected], [() => 'yes', null], [() => Promise.resolve(undefined), null]]) {
		await f.render(dock({ layout: source, panels: panels({ b: { onCloseRequested: callback } }), onLayoutChanged: next => submitted.push(next), onCloseError: (error, id) => errors.push({ error, id }) }));
		await f.click(closeButton(f.mount, 'b'));
		assert.equal(errors.length, 1); assert.equal(errors[0].id, 'b');
		if (expected) assert.equal(errors[0].error, expected); else assert.ok(errors[0].error instanceof Error, '非 boolean 必須回報錯誤');
		assert.equal(submitted.length, 0); assert.deepEqual(source, before);
		assert.equal(closeButton(f.mount, 'b').disabled, false); errors.length = 0;
	}
	const hostErrors = [], previous = Object.getOwnPropertyDescriptor(globalThis, 'reportError');
	const report = error => hostErrors.push(error);
	Object.defineProperty(globalThis, 'reportError', { configurable: true, writable: true, value: report }); f.win.reportError = report;
	try {
		await f.render(dock({ panels: panels({ b: { onCloseRequested: () => { throw thrown; } } }), onLayoutChanged: next => submitted.push(next) }));
		await f.click(closeButton(f.mount, 'b'));
		assert.deepEqual(hostErrors, [thrown]); assert.equal(submitted.length, 0);
	} finally {
		if (previous) Object.defineProperty(globalThis, 'reportError', previous); else delete globalThis.reportError;
	}
});

test('SSR hydration、resize／theme／collapse 保留所有 input 與有限非負尺寸，不通知保存', async t => {
	const source = layout(), before = clone(source), registry = panels(), submitted = [], ref = React.createRef();
	const view = pack => dock({ layout: source, panels: registry, ref, onLayoutChanged: next => submitted.push(next) }, pack);
	const f = await fixture(t, { serverHtml: renderToString(view()) });
	const inputs = [...f.mount.querySelectorAll('input')];
	for (const input of inputs) input.value = `已編輯-${input.id}`;
	await f.hydrate(view());
	assert.deepEqual(f.hydrationErrors, []); assert.equal(ref.current, f.mount.querySelector('#dock'));
	assert.ok([...f.observers].some(observer => observer.targets.size), 'client 必須觀察宿主尺寸');
	const base = klp.createKlpStylePack(), semantics = {};
	for (const id of ['theme.spacing.dockMargin', 'theme.spacing.chromeTab', 'theme.shape.stroke']) semantics[id] = { light: 'p(radiusFull)' };
	const extreme = klp.applyKlpStyleOverrides(base, { semantics });
	for (const [width, height, pack] of [[96, 48, base], [0, 0, base], [600, 300, extreme], [600, 300, base]]) {
		await f.resize(width, height); await f.render(view(pack));
		assert.doesNotMatch(f.mount.innerHTML, /NaN|Infinity/);
		for (const node of f.mount.querySelectorAll('[style]')) for (const property of ['width', 'height', 'minWidth', 'minHeight', 'paddingTop', 'paddingBottom', 'paddingLeft', 'paddingRight', 'borderRadius']) {
			const value = node.style[property];
			if (/^[\d.e+-]+px$/i.test(value)) assert.ok(Number.isFinite(Number.parseFloat(value)) && Number.parseFloat(value) >= 0, `${property} 必須有限非負`);
		}
		for (const input of inputs) { assert.equal(f.mount.querySelector(`#${input.id}`), input); assert.equal(input.value, `已編輯-${input.id}`); }
	}
	assert.equal(submitted.length, 0); assert.deepEqual(source, before);
	const collapsed = clone(source); collapsed.left.isVisible = false;
	await f.render(dock({ layout: collapsed, panels: registry }));
	for (const input of inputs) assert.equal(f.mount.querySelector(`#${input.id}`), input);
	await f.render(view());
	for (const input of inputs) assert.equal(f.mount.querySelector(`#${input.id}`), input);
	await f.unmount(); assert.ok([...f.observers].every(observer => observer.targets.size === 0));
	await f.resize(100, 50); assert.equal(f.mount.children.length, 0);
});

test('StrictMode setup／cleanup 後仍可 close，兩個 instance pending 互不干擾', async t => {
	const f = await fixture(t), first = deferred(), second = deferred(), submitted = [[], []];
	const registry = index => panels({ b: { onCloseRequested: () => [first, second][index].promise } });
	await f.render(h(React.StrictMode, null, h('main', null, ...[0, 1].map(index => h('section', { key: index, id: `instance-${index}` }, dock({ id: `dock-${index}`, panels: registry(index), onLayoutChanged: next => submitted[index].push(next) }))))));
	const instances = [0, 1].map(index => f.mount.querySelector(`#instance-${index}`));
	await f.click(closeButton(instances[0], 'b'));
	assert.equal(closeButton(instances[0], 'b').disabled, true); assert.equal(closeButton(instances[1], 'b').disabled, false);
	await f.click(closeButton(instances[1], 'b')); await f.settle(() => first.resolve(true));
	assert.equal(submitted[0].length, 1); assert.equal(submitted[1].length, 0);
	await f.settle(() => second.resolve(false));
	assert.equal(submitted[1].length, 0); assert.equal(closeButton(instances[1], 'b').disabled, false);
	await f.unmount(); assert.ok([...f.observers].every(observer => observer.targets.size === 0));
});
