import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { renderToString } from 'react-dom/server';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';

const h = React.createElement;
const names = ['KlpAppLayout', 'KlpLayoutRow', 'KlpLayoutColumn', 'KlpLayoutPane', 'KlpLayoutSpacer', 'KlpLayoutDivider'];
const gapId = 'theme.spacing.space2';
const gap = klp.createKlpTheme('light')[gapId];
const provider = (child, stylePack) => h(klp.KlpThemeProvider, { stylePack }, child);
const pane = (id, props = {}, content = id) => h(klp.KlpLayoutPane, { key: id, id, ...props }, content);
const row = (props, ...children) => h(klp.KlpLayoutRow, props, ...children);
const close = (actual, expected, message) => assert.ok(Number.isFinite(actual) && Math.abs(actual - expected) < 1e-6 * Math.max(1, expected), `${message}: ${actual} != ${expected}`);

function diagnostic(child, field) {
	assert.throws(() => renderToString(provider(child)), error => {
		assert.ok(error instanceof Error);
		assert.match(error.message, field, '診斷必須辨識違反契約的欄位或直接 child');
		return true;
	});
}

// 此 seam 只補 jsdom 缺少的 CSS 尺寸；預期數值由共通契約手算，不呼叫 solver。
async function fixture(t, { width = 600, height = 300, observer = true, serverHtml = null } = {}) {
	const dom = new JSDOM('<!doctype html><div id="mount"></div>', { url: 'http://localhost' });
	const win = dom.window;
	const previous = new Map();
	const observers = new Set();
	class ResizeObserver {
		constructor(callback) { this.callback = callback; this.targets = new Set(); observers.add(this); }
		observe(target) { this.targets.add(target); }
		unobserve(target) { this.targets.delete(target); }
		disconnect() { this.targets.clear(); }
	}
	const mount = win.document.querySelector('#mount');
	if (serverHtml !== null) mount.innerHTML = serverHtml;
	const box = { width, height };
	mount.style.width = `${width}px`;
	mount.style.height = `${height}px`;
	const globals = { window: win, document: win.document, navigator: win.navigator, HTMLElement: win.HTMLElement, Element: win.Element, Node: win.Node, MutationObserver: win.MutationObserver, getComputedStyle: win.getComputedStyle.bind(win), ResizeObserver: observer ? ResizeObserver : undefined, IS_REACT_ACT_ENVIRONMENT: true };
	win.ResizeObserver = globals.ResizeObserver;
	for (const [name, value] of Object.entries(globals)) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	function natural(element, axis) {
		const explicit = element.getAttribute(`data-natural-${axis}`);
		if (explicit !== null) return Number(explicit);
		const children = [...element.children];
		return Math.max(0, ...children.map(child => natural(child, axis)));
	}
	function size(element, axis, depth = 0) {
		if (!element || depth > 30) return 0;
		if (element === mount) return box[axis];
		if (element.hasAttribute(`data-natural-${axis}`)) return natural(element, axis);
		const css = win.getComputedStyle(element);
		const specified = css[axis];
		if (/max-content|min-content/.test(specified)) return natural(element, axis);
		if (/^[\d.e+-]+px$/i.test(specified)) return Number.parseFloat(specified);
		const parent = element.parentElement;
		if (parent) {
			const parentCss = win.getComputedStyle(parent);
			const padding = axis === 'width' ? ['paddingLeft', 'paddingRight'] : ['paddingTop', 'paddingBottom'];
			const available = Math.max(0, size(parent, axis, depth + 1) - padding.reduce((sum, key) => sum + (Number.parseFloat(parentCss[key]) || 0), 0));
			if (specified.endsWith('%')) return available * Number.parseFloat(specified) / 100;
			if (css.position === 'absolute' || css.display === 'inline-block') return natural(element, axis);
			return available;
		}
		return natural(element, axis);
	}
	win.HTMLElement.prototype.getBoundingClientRect = function () {
		const width = size(this, 'width');
		const height = size(this, 'height');
		return { x: 0, y: 0, top: 0, left: 0, right: width, bottom: height, width, height, toJSON() { return this; } };
	};
	for (const [name, axis] of [['clientWidth', 'width'], ['clientHeight', 'height'], ['offsetWidth', 'width'], ['offsetHeight', 'height'], ['scrollWidth', 'width'], ['scrollHeight', 'height']]) {
		Object.defineProperty(win.HTMLElement.prototype, name, { configurable: true, get() { return name.startsWith('scroll') ? natural(this, axis) : size(this, axis); } });
	}
	const { createRoot, hydrateRoot } = await import('react-dom/client');
	let root = serverHtml === null ? createRoot(mount) : null;
	const hydrationErrors = [];
	let unmounted = false;
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
		win, mount, observers, unmount, hydrationErrors,
		render: child => act(() => root.render(child)),
		hydrate: child => act(() => { root = hydrateRoot(mount, child, { onRecoverableError: error => hydrationErrors.push(error) }); }),
		async resize(width, height) {
			box.width = width; box.height = height;
			mount.style.width = `${width}px`; mount.style.height = `${height}px`;
			await act(() => {
				for (const entry of observers) if (entry.targets.size) entry.callback([...entry.targets].map(target => ({ target, contentRect: target.getBoundingClientRect() })), entry);
				win.dispatchEvent(new win.Event('resize'));
			});
		},
		slot(id) {
			const element = mount.querySelector(`#${id}`);
			assert.ok(element, `${id} 必須保留原生 DOM id`);
			const slot = element.closest('[data-klp-layout-slot="content"]');
			assert.ok(slot, `${id} 必須位於公開 content slot`);
			return slot;
		},
		extent(id, axis = 'width') {
			const value = this.slot(id).style[axis];
			assert.match(value, /^[\d.e+-]+px$/i, `${id} slot ${axis} 必須輸出有限 px`);
			return Number.parseFloat(value);
		},
	};
}

test('六個公開元件、SSR DOM、原生內容及 Fragment/null 直接組合', () => {
	for (const name of names) assert.ok(klp[name], `${name} 必須由 dist 公開匯出`);
	const html = renderToString(provider(h(klp.KlpAppLayout, { 'aria-label': '工作區' }, row({ id: 'row' }, h(React.Fragment, null, pane('a', {}, h('section', null, h('input', { defaultValue: '產品正文' }))), null, h(klp.KlpLayoutDivider), h(klp.KlpLayoutSpacer))))));
	const dom = new JSDOM(html);
	for (const role of ['root', 'row', 'pane', 'divider', 'spacer']) assert.ok(dom.window.document.querySelector(`[data-klp-layout="${role}"]`));
	assert.equal(dom.window.document.querySelector('[aria-label="工作區"]').getAttribute('data-klp-layout'), 'root');
	assert.equal(dom.window.document.querySelector('input').value, '產品正文');
	assert.doesNotMatch(html, /NaN|Infinity/);
	dom.window.close();
});

test('SSR hydration 保留原生 input 身分與已編輯值，client 完成有限 slot 配置', async t => {
	const view = provider(h(klp.KlpAppLayout, { inset: 'none', 'aria-label': 'SSR 工作區' }, row(null,
		pane('hydrated-pane', {}, h('input', { id: 'hydrated-input', defaultValue: '伺服器正文', 'aria-label': '正文' })))));
	const f = await fixture(t, { serverHtml: renderToString(view) });
	const input = f.mount.querySelector('#hydrated-input');
	assert.ok(input, 'SSR 必須輸出原生 input');
	// 模擬 hydration 前使用者已輸入內容；量測不能重建節點或覆寫值。
	input.value = '掛載前已編輯';
	await f.hydrate(view);
	assert.deepEqual(f.hydrationErrors, [], '相同公開 tree hydration 不得有 recoverable error');
	assert.equal(f.mount.querySelector('#hydrated-input'), input, 'hydration 保留 SSR input 節點');
	assert.equal(input.value, '掛載前已編輯');
	assert.equal(input.getAttribute('aria-label'), '正文');
	close(f.extent('hydrated-pane'), 600, 'hydration 後寬度配置');
	close(f.extent('hydrated-pane', 'height'), 300, 'hydration 後高度配置');
});

test('非法 bounds/flex 與直接 child 同步拒絕；caller 不變', () => {
	const bounds = Object.freeze({ minimum: 12, maximum: 8 });
	for (const [props, field] of [[{ bounds }, /maximum/i], [{ bounds: { minimum: -1 } }, /minimum/i], [{ bounds: { preferred: NaN } }, /preferred/i], [{ bounds: { maximum: Infinity } }, /maximum/i], [{ flex: -0.5 }, /flex/i], [{ flex: Infinity }, /flex/i]]) diagnostic(row(null, pane('invalid', props)), field);
	diagnostic(row(null, h(klp.KlpLayoutSpacer, { flex: 0 })), /flex/i);
	diagnostic(row(null, h('div', null, '非法 slot')), /child|slot|layout|子|節點/i);
	diagnostic(row(null, null), /child|slot|layout|子|至少/i);
	diagnostic(h(klp.KlpAppLayout, null, pane('a'), pane('b')), /child|single|one|子|單一/i);
	diagnostic(h(klp.KlpAppLayout, null, h(klp.KlpLayoutSpacer)), /child|layout|子|spacer/i);
	assert.deepEqual(bounds, { minimum: 12, maximum: 8 });
});

test('fractional flex、nested 分配與原生 ref/slot 裁切；consumer style 不破壞 tracks', async t => {
	const f = await fixture(t);
	const ref = React.createRef();
	await f.render(provider(row({ id: 'outer', style: { display: 'block', gap: 999, gridTemplateColumns: '1px', boxSizing: 'content-box' } },
		pane('a', { flex: 0.5, bounds: { minimum: 20 }, ref }),
		h(klp.KlpLayoutColumn, { id: 'nested', flex: 1.5 }, pane('b'), pane('c')))));
	// 內容預算 600-gap，minimum20 先保留，餘額以 1:3 分配。
	close(f.extent('a'), 20 + (580 - gap) / 4, 'fractional flex');
	close(f.extent('nested'), (580 - gap) * 3 / 4, 'nested 寬度');
	close(f.extent('b', 'height'), (300 - gap) / 2, '巢狀僅扣本層 gap');
	assert.equal(ref.current, f.mount.querySelector('#a'));
	for (const id of ['a', 'nested', 'b', 'c']) {
		const css = f.win.getComputedStyle(f.slot(id));
		assert.equal(css.overflow, 'hidden');
		assert.equal(Number.parseFloat(css.minWidth), 0);
		assert.equal(Number.parseFloat(css.minHeight), 0);
	}
});

test('divider 抑制相鄰 gap，連續 divider 與 spacing none 保留顯式間距', async t => {
	const f = await fixture(t);
	const view = spacing => provider(row({ id: 'row', spacing }, pane('a'), h(klp.KlpLayoutDivider, { key: 'd1', 'aria-label': '分隔一' }), h(klp.KlpLayoutDivider, { key: 'd2' }), pane('b'), pane('c')));
	await f.render(view('standard'));
	for (const id of ['a', 'b', 'c']) close(f.extent(id), (600 - 3 * gap) / 3, '兩個 divider 與一個普通 gap');
	assert.equal(f.mount.querySelectorAll('[data-klp-layout="divider"]').length, 2);
	assert.equal(f.mount.querySelector('[aria-label="分隔一"]').getAttribute('data-klp-layout'), 'divider');
	await f.render(view('none'));
	for (const id of ['a', 'b', 'c']) close(f.extent(id), (600 - 2 * gap) / 3, 'none 僅取消普通 gap');
});

test('minimum 不足按比例退化，極大 scope gap 與 root inset 不溢出', async t => {
	const f = await fixture(t, { width: 100, height: 60 });
	await f.render(provider(row({ spacing: 'none' }, pane('a', { bounds: { minimum: 80 } }), pane('b', { bounds: { minimum: 120 } }))));
	close(f.extent('a'), 40, 'minimum 80:120 比例壓縮');
	close(f.extent('b'), 60, 'minimum 80:120 比例壓縮');
	await f.render(provider(h(klp.KlpAppLayout, null, row(null, pane('a')))));
	close(f.extent('a'), 100 - 2 * gap, 'root 只扣一次標準 inset');
	close(f.extent('a', 'height'), 60 - 2 * gap, 'root 垂直 inset');
	const pack = klp.applyKlpStyleOverrides(klp.createKlpStylePack(), { primitives: { space200: 1000 } });
	await f.render(provider(row(null, pane('a'), pane('b')), pack));
	close(f.extent('a'), 0, '極大 gap 占滿 budget');
	close(f.extent('b'), 0, '極大 gap 占滿 budget');
	await f.render(provider(h(klp.KlpAppLayout, null, row({ id: 'inner' }, pane('a'))), pack));
	close(f.extent('a'), 0, 'root inset 每側不超過半寬');
	close(f.extent('a', 'height'), 0, 'root inset 每側不超過半高');
	await f.render(provider(h(klp.KlpAppLayout, { inset: 'none' }, row(null, pane('a'))), pack));
	close(f.extent('a'), 100, 'none root inset');
});

test('content sizing 與零 flex 自然尺寸不重掛產品 state', async t => {
	const f = await fixture(t);
	let mounts = 0;
	function Product() {
		React.useEffect(() => { mounts += 1; }, []);
		return h('input', { id: 'product', defaultValue: '初值', 'data-natural-width': 70, 'data-natural-height': 18 });
	}
	const content = h(Product);
	const view = sizing => provider(row({ sizing }, pane('a', { flex: 0 }, content), pane('b', { bounds: { preferred: 30, maximum: 40 } }, h('span', { 'data-natural-width': 120 }, '正文'))));
	await f.render(view('fill'));
	close(f.extent('a'), 70, '零 flex 使用自然寬度');
	close(f.extent('b'), 40, 'maximum 限制增長');
	const input = f.mount.querySelector('#product');
	input.value = '產品未保存 state';
	await f.render(view('content'));
	close(f.extent('a'), 70, 'content 自然寬度');
	close(f.extent('b'), 30, 'content preferred 不增長');
	await f.resize(900, 400);
	assert.equal(f.mount.querySelector('#product'), input);
	assert.equal(input.value, '產品未保存 state');
	assert.equal(mounts, 1, '量測不得 duplicate 或 remount 產品');
});

test('容器 ResizeObserver 與 theme 更新各自 scoped，StrictMode/unmount 完整清理', async t => {
	const f = await fixture(t);
	const base = klp.createKlpStylePack();
	const alternate = klp.applyKlpStyleOverrides(base, { primitives: { space200: 20 } });
	const view = pack => h(React.StrictMode, null, h('main', null,
		provider(row({ id: 'first' }, pane('a'), pane('b')), pack),
		provider(row({ id: 'second' }, pane('c'), pane('d')), base)));
	await f.render(view(base));
	assert.ok([...f.observers].some(entry => entry.targets.size), '必須觀察元素尺寸');
	await f.resize(800, 400);
	close(f.extent('a'), (800 - gap) / 2, 'resize 更新');
	await f.render(view(alternate));
	close(f.extent('a'), 390, '新 scope gap20');
	close(f.extent('c'), (800 - gap) / 2, '兄弟 scope 不受影響');
	await f.unmount();
	assert.ok([...f.observers].every(entry => entry.targets.size === 0), 'StrictMode 舊 observer 與 current observer 均需清理');
	await f.resize(700, 200);
	assert.equal(f.mount.children.length, 0);
});

test('沒有 ResizeObserver 仍有首次量測與 resize fallback；content load/mutation 重量測', async t => {
	const f = await fixture(t, { observer: false });
	await f.render(provider(row(null, pane('a', { flex: 0 }, h('span', { id: 'natural', 'data-natural-width': 40 }, '正文')), pane('b'))));
	close(f.extent('a'), 40, '首次量測');
	await f.resize(800, 300);
	close(f.extent('b'), 760 - gap, 'resize fallback');
	const natural = f.mount.querySelector('#natural');
	await act(async () => {
		natural.setAttribute('data-natural-width', '90');
		natural.dispatchEvent(new f.win.Event('load', { bubbles: true }));
		await new Promise(resolve => f.win.setTimeout(resolve, 20));
	});
	close(f.extent('a'), 90, 'load 觸發自然量測');
	await act(async () => {
		natural.setAttribute('data-natural-width', '120');
		natural.firstChild.nodeValue = '修改後的正文';
		await new Promise(resolve => f.win.setTimeout(resolve, 20));
	});
	close(f.extent('a'), 120, 'characterData 變更觸發自然量測');
	await f.unmount();
	await f.resize(900, 300);
	assert.equal(f.mount.children.length, 0);
});
