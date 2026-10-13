import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { renderToString } from 'react-dom/server';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';

const panels = () => [
	{ id: 'a', label: '甲功能', content: h('input', { id: 'draft-a', 'aria-label': '甲草稿', defaultValue: '' }) },
	{ id: 'b', label: '乙功能', content: h('input', { id: 'draft-b', 'aria-label': '乙草稿', defaultValue: '' }) },
];
const layout = (props = {}) => h(klp.KlpModernProductivityLayout, {
	panels: panels(), selectedId: 'a', header: h('div', { id: 'header' }, '標題'), stage: h('div', { id: 'stage' }, '工作區'), ...props,
});
const button = (f, label) => [...f.mount.querySelectorAll('button')].find(element => element.textContent.trim() === label || element.getAttribute('aria-label') === label);
const hidden = element => Boolean(element.closest('[hidden]'));
const selected = element => ['aria-pressed', 'aria-selected'].some(name => element.getAttribute(name) === 'true') || ['true', 'page'].includes(element.getAttribute('aria-current'));

test('公開受控切換保留選取語意與 disabled；目前項不發事件', async t => {
	assert.equal(typeof klp.KlpModernProductivityLayout, 'function', '須由 package index 公開匯出');
	const f = await fixture(t);
	const events = [];
	await f.render(provider(layout({ onSelected: id => events.push(id) })));
	assert.equal(selected(button(f, '甲功能')), true);
	assert.equal(selected(button(f, '乙功能')), false);
	await act(() => button(f, '甲功能').click());
	assert.deepEqual(events, []);
	await act(() => button(f, '乙功能').click());
	assert.deepEqual(events, ['b']);
	assert.equal(hidden(f.mount.querySelector('#draft-a')), false, '未提交選取不得自行切換');
	assert.equal(hidden(f.mount.querySelector('#draft-b')), true);
	await f.render(provider(layout({ selectedId: 'b' })));
	for (const label of ['甲功能', '乙功能']) assert.equal(button(f, label).disabled, true);
	assert.equal(selected(button(f, '乙功能')), true);
	await act(() => button(f, '甲功能').click());
	assert.deepEqual(events, ['b']);
	assert.equal(hidden(f.mount.querySelector('#draft-b')), false);
});

test('stable id 保持所有面板 mounted；A-B-A／重排／theme/header 更新保留草稿', async t => {
	const f = await fixture(t);
	const mounts = new Map();
	function Draft({ id }) {
		React.useEffect(() => { mounts.set(id, (mounts.get(id) ?? 0) + 1); }, [id]);
		return h('input', { id: `draft-${id}`, 'aria-label': `${id}草稿`, defaultValue: '' });
	}
	const items = ['a', 'b'].map(id => Object.freeze({ id, label: `${id}功能`, content: h(Draft, { id }) }));
	const base = klp.createKlpStylePack();
	const changed = klp.applyKlpStyleOverrides(base, { semantics: { 'theme.spacing.space2': { light: 'p(space300)' } } });
	const view = (selectedId, order = items, pack = base, title = '標題') => provider(layout({ panels: order, selectedId, header: h('div', { id: 'header' }, title) }), pack);
	await f.render(view('a'));
	const a = f.mount.querySelector('#draft-a');
	const b = f.mount.querySelector('#draft-b');
	assert.ok(a && b, 'inactive content 仍須掛載');
	a.value = '未保存的甲草稿';
	assert.equal(hidden(b), true, 'inactive 必須以 hidden 排除可存取與一般鍵盤序列');
	await f.render(view('b'));
	assert.equal(hidden(a), true);
	assert.equal(hidden(b), false);
	b.value = '未保存的乙草稿';
	await f.render(view('a', [...items].reverse(), changed, '更新標題'));
	assert.equal(f.mount.querySelector('#draft-a'), a);
	assert.equal(f.mount.querySelector('#draft-b'), b);
	assert.equal(a.value, '未保存的甲草稿');
	assert.equal(b.value, '未保存的乙草稿');
	assert.deepEqual([...mounts], [['a', 1], ['b', 1]], '換選取／排序／theme／header 不得重掛面板');
	assert.equal(items[0].id, 'a', '不得改寫產品清單');
	await f.render(view('b', [items[1]], changed));
	assert.equal(f.mount.querySelector('#draft-a'), null, '移除 id 才釋放面板');
	assert.equal(f.mount.querySelector('#draft-b'), b);
});

test('空清單、重複／空 id、空 label、未知選取與非法宽度皆拒絕為 TypeError', () => {
	const items = panels();
	const events = [];
	const cases = [
		{ panels: [] }, { panels: [items[0], items[0]] },
		{ panels: [{ ...items[0], id: '' }] }, { panels: [{ ...items[0], label: '' }] },
		{ selectedId: 'missing' },
		...[0, -1, Infinity, NaN].map(sidebarWidth => ({ sidebarWidth })),
	];
	for (const props of cases) assert.throws(() => renderToString(provider(layout({ ...props, onSelected: id => events.push(id) }))), TypeError);
	assert.deepEqual(events, []);
});

test('有限／零／窄宿主更新保留角色與非作用面板，不輸出 NaN 或 Infinity', async t => {
	const f = await fixture(t, { width: 800, height: 400 });
	await f.render(provider(layout({ sidebarWidth: 180 })));
	const a = f.mount.querySelector('#draft-a');
	for (const [width, height] of [[800, 400], [80, 400], [0, 0], [800, 0]]) {
		await f.resize(width, height);
		assert.equal(f.mount.querySelector('#draft-a'), a);
		assert.ok(f.mount.querySelector('#header'));
		assert.ok(f.mount.querySelector('#stage'));
		assert.doesNotMatch(f.mount.innerHTML, /NaN|Infinity/);
		assert.equal(hidden(f.mount.querySelector('#draft-b')), true);
	}
});

const h = React.createElement;
const provider = (child, stylePack) => h(klp.KlpThemeProvider, { stylePack }, child);

// 沿用既有 jsdom 尺寸 seam；此環境不代表真實瀏覽器布局或鍵盤巡訪。
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
