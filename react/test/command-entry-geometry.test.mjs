import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { JSDOM } from 'jsdom';
import { readFileSync } from 'node:fs';
import * as klp from '../dist/index.js';

const h = React.createElement;
const kinds = ['toolbar', 'menu'];
const css = readFileSync(new URL('../dist/styles.css', import.meta.url), 'utf8');

function extremePack() {
	const semantics = {};
	for (const name of [
		'theme.geometry.layout.commandMenuWidth', 'theme.spacing.tight',
		'theme.components.menuPadding', 'theme.components.buttonPaddingX',
		'theme.components.buttonPaddingY', 'theme.spacing.iconSmall',
		'theme.spacing.overlayItemGap',
	]) {
		semantics[name] = Object.fromEntries(['light', 'dark', 'ultraDark', 'transparent'].map(mode => [mode, 'p(length-520)']));
	}
	return klp.applyKlpStyleOverrides(klp.createKlpStylePack(), {
		primitives: { 'length-520': 1000000 },
		semantics,
	});
}

// 此測試只讀公開 DOM 的 CSS；通用數值解析接受 var／calc／min／max／clamp，不要求私有變數名稱。
function split(value, separator) {
	let depth = 0, start = 0;
	const result = [];
	for (let i = 0; i < value.length; i++) {
		if (value[i] === '(') depth++;
		if (value[i] === ')') depth--;
		if (depth === 0 && separator.test(value[i])) {
			if (value.slice(start, i).trim()) result.push(value.slice(start, i).trim());
			start = i + 1;
		}
	}
	if (value.slice(start).trim()) result.push(value.slice(start).trim());
	return result;
}

function resolve(node, raw) {
	let value = raw;
	for (let round = 0; value.includes('var(') && round < 40; round++) {
		const start = value.indexOf('var(');
		let end = start + 4, depth = 1;
		while (end < value.length && depth) {
			if (value[end] === '(') depth++;
			if (value[end] === ')') depth--;
			end++;
		}
		const [name, fallback = ''] = split(value.slice(start + 4, end - 1), /,/);
		let current = node, replacement = '';
		while (current && !replacement) {
			replacement = current.ownerDocument.defaultView.getComputedStyle(current).getPropertyValue(name).trim();
			current = current.parentElement;
		}
		assert.ok(replacement || fallback, `公開 CSS 變數 ${name} 必須可解析`);
		value = value.slice(0, start) + (replacement || fallback) + value.slice(end);
	}
	assert.equal(value.includes('var('), false, '公開 CSS 變數不可循環');
	return value;
}

function length(raw, basis) {
	const tokens = raw.match(/(?:\d+(?:\.\d*)?|\.\d+)(?:px|%)?|[a-z]+|[()+*/,\-]/g) ?? [];
	let index = 0;
	function atom() {
		const token = tokens[index++];
		if (token === '-') return -atom();
		if (token === '(') {
			const value = sum();
			assert.equal(tokens[index++], ')');
			return value;
		}
		if (['calc', 'min', 'max', 'clamp'].includes(token)) {
			assert.equal(tokens[index++], '(');
			const values = [sum()];
			while (tokens[index] === ',') { index++; values.push(sum()); }
			assert.equal(tokens[index++], ')');
			if (token === 'min') return Math.min(...values);
			if (token === 'max') return Math.max(...values);
			if (token === 'clamp') return Math.max(values[0], Math.min(values[1], values[2]));
			return values[0];
		}
		assert.match(token ?? '', /^\d*\.?\d+(?:px|%)?$/, `無 layout fixture 無法解析公開 CSS 長度 ${raw}；需 browser 驗證`);
		return Number.parseFloat(token) * (token.endsWith('%') ? basis / 100 : 1);
	}
	function product() {
		let value = atom();
		while (['*', '/'].includes(tokens[index])) {
			const operator = tokens[index++], next = atom();
			value = operator === '*' ? value * next : value / next;
		}
		return value;
	}
	function sum() {
		let value = product();
		while (['+', '-'].includes(tokens[index])) {
			const operator = tokens[index++], next = product();
			value = operator === '+' ? value + next : value - next;
		}
		return value;
	}
	const result = sum();
	assert.equal(index, tokens.length, `完整解析 ${raw}`);
	assert.ok(Number.isFinite(result) && result >= 0, `${raw} 必須為有限非負幾何`);
	return result;
}

function property(node, name) {
	return node.ownerDocument.defaultView.getComputedStyle(node).getPropertyValue(name).trim();
}

function pixels(node, name, basis) {
	return length(resolve(node, property(node, name)), basis);
}

function padding(node, basis) {
	const shorthand = split(resolve(node, property(node, 'padding') || '0px'), /\s/);
	const values = shorthand.map(value => length(value, basis));
	const top = values[0], right = values[1] ?? top;
	const bottom = values[2] ?? top, left = values[3] ?? right;
	const sides = { top, right, bottom, left };
	for (const side of Object.keys(sides)) {
		const direct = property(node, `padding-${side}`);
		if (direct) sides[side] = length(resolve(node, direct), basis);
	}
	for (const [axis, start, end] of [['inline', 'left', 'right'], ['block', 'top', 'bottom']]) {
		const raw = property(node, `padding-${axis}`);
		if (raw) {
			const pair = split(resolve(node, raw), /\s/).map(value => length(value, basis));
			sides[start] = pair[0];
			sides[end] = pair[1] ?? pair[0];
		}
		for (const [edge, side] of [['start', start], ['end', end]]) {
			const direct = property(node, `padding-${axis}-${edge}`);
			if (direct) sides[side] = length(resolve(node, direct), basis);
		}
	}
	return sides;
}

function ProductHost({ children, size }) {
	const [draft, setDraft] = React.useState('');
	function editDraft(event) { setDraft(event.currentTarget.value); }
	const input = h('input', { id: 'draft', value: draft, onInput: editDraft, readOnly: false });
	const entry = h('section', { style: size ? { width: size.width, height: size.height } : undefined }, children);
	return h('main', null, input, entry);
}

function commandRegistry() {
	const registry = new klp.KlpCommandRegistry();
	registry.register({ id: 'icon', label: '有圖示', icon: h('span', { 'data-product-icon': true }, '*'), handler: () => 'icon' });
	registry.register({ id: 'plain', label: '無圖示', handler: () => 'plain' });
	return registry;
}

async function fixture(t, size = { width: 120, height: 8 }) {
	const dom = new JSDOM('<!doctype html><div id="mount"></div>', { pretendToBeVisual: true });
	const win = dom.window, mount = win.document.querySelector('#mount');
	const sheet = win.document.createElement('style');
	sheet.textContent = css;
	win.document.head.append(sheet);
	let measured = size;
	const previous = new Map(), observers = new Set();
	// JSDOM 沒有布局：明確供應 host／row 的 client 槽，rect 故意放大以保護 client 優先。
	if (measured) Object.defineProperties(win.HTMLElement.prototype, {
		clientWidth: { configurable: true, get: () => measured.width },
		clientHeight: { configurable: true, get: () => measured.height },
		offsetWidth: { configurable: true, get: () => measured.width },
		offsetHeight: { configurable: true, get: () => measured.height },
	});
	if (measured) {
		win.HTMLElement.prototype.getBoundingClientRect = function measuredRect() {
			return { x: 0, y: 0, top: 0, left: 0, right: measured.width * 10, bottom: measured.height * 10, width: measured.width * 10, height: measured.height * 10 };
		};
	}
	class ResizeObserver {
		constructor(callback) { this.callback = callback; this.targets = new Set(); observers.add(this); }
		observe(target) { this.targets.add(target); }
		unobserve(target) { this.targets.delete(target); }
		disconnect() { this.targets.clear(); observers.delete(this); }
	}
	win.ResizeObserver = ResizeObserver;
	for (const [name, value] of Object.entries({
		window: win, document: win.document, navigator: win.navigator,
		HTMLElement: win.HTMLElement, Element: win.Element, Node: win.Node,
		MutationObserver: win.MutationObserver, ResizeObserver,
		getComputedStyle: win.getComputedStyle.bind(win), IS_REACT_ACT_ENVIRONMENT: true,
	})) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	const client = await import('react-dom/client');
	const root = client.createRoot(mount);
	async function settle(callback) {
		await act(async () => { callback(); await Promise.resolve(); });
	}
	function notify() {
		for (const observer of [...observers]) {
			const entries = [...observer.targets].map(target => ({ target, contentRect: { width: measured.width, height: measured.height } }));
			if (entries.length) observer.callback(entries, observer);
		}
	}
	t.after(async function dispose() {
		await settle(() => root.unmount());
		assert.equal([...observers].some(observer => observer.targets.size), false, '卸載後不留 native resize 訂閱');
		win.close();
		for (const [name, descriptor] of previous) {
			if (descriptor) Object.defineProperty(globalThis, name, descriptor);
			else delete globalThis[name];
		}
	});
	return {
		win, mount, settle,
		host: kind => mount.querySelector(`[role="${kind}"]`),
		render: async function render(kind, options = {}) {
			const Component = kind === 'toolbar' ? klp.KlpRegisteredCommandToolbar : klp.KlpRegisteredCommandMenu;
			const props = { registry: options.registry, items: [{ commandId: 'icon' }, { commandId: 'plain' }], label: '命令', emptyLabel: '無命令', getContext: () => ({}), onResult: () => {}, ...options.props };
			const entry = h(Component, props);
			const host = h(ProductHost, { size: measured }, entry);
			await settle(() => root.render(h(klp.KlpThemeProvider, { stylePack: options.pack }, host)));
		},
		resize: async function resize(next) { measured = next; await settle(notify); },
	};
}

function bounded(f, kind, size) {
	const host = f.host(kind);
	assert.ok(host);
	for (const node of host.querySelectorAll('[style]')) assert.equal(/NaN|Infinity/.test(node.getAttribute('style')), false);
	if (kind === 'menu') {
		const width = pixels(host, 'inline-size', size.width), outer = padding(host, size.width);
		assert.ok(width <= size.width, `menu 寬 ${width} 不可超出有限宿主 ${size.width}`);
		assert.ok(outer.left + outer.right <= width, 'menu 外水平 padding 不可撐出有限寬');
		assert.ok(outer.top + outer.bottom <= size.height, 'menu 外垂直 padding 不可撐出有限高');
		assert.ok(['auto', 'scroll', 'hidden', 'clip'].includes(property(host, 'overflow')), '有限 menu 必須 clip／scroll');
	}
	for (const row of host.querySelectorAll('button')) {
		const inset = padding(row, size.width);
		assert.ok(inset.left + inset.right <= size.width, `row ${row.dataset.klpCommandId} padding 不可超出 ${size.width}`);
		const remaining = size.width - inset.left - inset.right;
		const productIcon = row.querySelector('[data-product-icon]');
		const gap = pixels(row, 'gap', size.width);
		if (productIcon) {
			const icon = productIcon.parentElement;
			const iconWidth = pixels(icon, 'inline-size', size.width);
			assert.ok(iconWidth <= remaining / 2, `圖示 ${iconWidth} 不可超出剩餘槽的一半 ${remaining / 2}`);
			assert.ok(gap <= remaining - iconWidth, '圖示 gap 不可超出剩餘槽');
		} else {
			assert.ok(gap === 0 || row.children.length === 1, '沒有圖示不可預留空槽或實際 child gap');
			assert.equal(row.querySelector('[aria-hidden="true"]'), null, '沒有圖示不可新增裝飾空槽');
		}
		const text = [...row.querySelectorAll('span')].find(node => !node.closest('[aria-hidden="true"]') && property(node, 'white-space') === 'nowrap');
		assert.ok(text, '文字槽保留 nowrap');
		assert.ok(['hidden', 'clip'].includes(property(row, 'overflow')), '有限 row 必須裁切內容');
	}
}

for (const kind of kinds) {
	test(`${kind} 零／極窄 client 槽與巨大合法風格保持局部有限幾何`, async function finiteGeometry(t) {
		const f = await fixture(t), registry = commandRegistry(), pack = extremePack();
		const original = JSON.stringify(pack);
		await f.render(kind, { registry, pack });
		for (const size of [{ width: 120, height: 8 }, { width: 3, height: 1 }, { width: 0, height: 0 }]) {
			await t.test(`${size.width}×${size.height}`, async function sizeGeometry() {
				await f.resize(size);
				bounded(f, kind, size);
				assert.deepEqual([...f.host(kind).querySelectorAll('button')].map(row => row.dataset.klpCommandId), ['icon', 'plain']);
			});
		}
		assert.equal(JSON.stringify(pack), original, '局部幾何不可寫回原 style pack');
	});
}

test('無 layout 的自然宿主保留 semantic 自然 fallback，不將所有 row 幾何硬改零', async function naturalGeometry(t) {
	const f = await fixture(t, null), registry = commandRegistry();
	const tokens = klp.createKlpTheme();
	for (const kind of kinds) {
		await f.render(kind, { registry });
		const host = f.host(kind), row = host.querySelector('[data-klp-command-id="icon"]');
		assert.equal(host.clientWidth, 0, '本 fixture 確實沒有 native layout');
		const icon = row.querySelector('[data-product-icon]').parentElement;
		assert.equal(pixels(icon, 'inline-size', 640), tokens['theme.spacing.iconSmall']);
		assert.equal(pixels(row, 'gap', 640), tokens['theme.spacing.overlayItemGap']);
		const semantic = kind === 'menu' ? 'theme.components.menuPadding' : 'theme.components.buttonPaddingX';
		assert.equal(padding(row, 640).left, tokens[semantic]);
		for (const node of [host, ...host.querySelectorAll('[style]')]) {
			assert.equal(/NaN|Infinity/.test(node.getAttribute('style') ?? ''), false, '自然 fallback 不得將 Infinity 當像素');
		}
	}
});

test('足量標準 host 保留原 semantic padding／icon／gap／menu width，無圖示不留槽', async function standardGeometry(t) {
	const f = await fixture(t, { width: 640, height: 480 });
	const registry = commandRegistry(), tokens = klp.createKlpTheme();
	for (const kind of kinds) {
		await f.render(kind, { registry });
		const host = f.host(kind), row = host.querySelector('[data-klp-command-id="icon"]');
		const icon = row.querySelector('[data-product-icon]').parentElement;
		assert.equal(pixels(icon, 'inline-size', 640), tokens['theme.spacing.iconSmall']);
		assert.equal(pixels(row, 'gap', 640), tokens['theme.spacing.overlayItemGap']);
		const semantic = kind === 'menu' ? 'theme.components.menuPadding' : 'theme.components.buttonPaddingX';
		assert.equal(padding(row, 640).left, tokens[semantic]);
		assert.equal(padding(row, 640).right, tokens[semantic]);
		if (kind === 'menu') {
			assert.equal(pixels(host, 'inline-size', 640), tokens['theme.geometry.layout.commandMenuWidth']);
			assert.equal(padding(host, 640).left, tokens['theme.spacing.tight']);
		}
		bounded(f, kind, { width: 640, height: 480 });
	}
});

test('同產品 State／draft／focus ID／order／checked／gates／pending 跨 size 與 style 保留', async function stateGeometry(t) {
	const f = await fixture(t, { width: 640, height: 480 });
	for (const kind of kinds) {
		let finish;
		const pending = new Promise(resolve => { finish = resolve; });
		const registry = new klp.KlpCommandRegistry(), results = [];
		let context = { enabled: true, checked: true }, calls = 0;
		registry.register({ id: 'icon', label: '切換', icon: h('span', { 'data-product-icon': true }, '*'), isChecked: () => context.checked, handler: () => { calls++; return pending; } });
		registry.register({ id: 'plain', label: '保留焦點', isEnabled: () => context.enabled, handler: value => value });
		registry.register({ id: 'blocked', label: '權限禁止', isEnabled: () => false, handler: () => assert.fail('不可繞過 gate') });
		const props = { items: [{ commandId: 'icon', kind: 'toggle' }, { commandId: 'plain' }, { commandId: 'blocked' }], getContext: () => context, onResult: result => results.push(result) };
		await f.resize({ width: 640, height: 480 });
		await f.render(kind, { registry, props });
		const host = f.host(kind), originalRows = [...host.querySelectorAll('button')];
		const draft = f.win.document.querySelector('#draft');
		await f.settle(function editProductDraft() {
			draft.value = '產品未保存內容';
			draft.dispatchEvent(new f.win.Event('input', { bubbles: true }));
		});
		await f.settle(() => originalRows[0].click());
		await f.settle(() => originalRows[1].focus());
		context = { enabled: true, checked: true, version: 2 };
		await f.resize({ width: 3, height: 1 });
		await f.render(kind, { registry, props, pack: extremePack() });
		assert.equal(f.host(kind), host, 'same entry host 保留');
		const currentRows = [...host.querySelectorAll('button')];
		assert.deepEqual(currentRows, originalRows, '相同命令 ID 保留 DOM focus owner 與順序');
		assert.equal(f.win.document.activeElement, originalRows[1]);
		assert.equal(draft.value, '產品未保存內容');
		assert.equal(originalRows[0].getAttribute(kind === 'menu' ? 'aria-checked' : 'aria-pressed'), 'true');
		assert.equal(originalRows[0].disabled, true, '同 registry pending 保留');
		assert.equal(originalRows[2].disabled, true, '權限 gate 保留');
		await f.settle(() => originalRows[0].click());
		await f.settle(() => originalRows[2].click());
		assert.equal(calls, 1);
		await f.settle(() => originalRows[1].click());
		assert.equal(results[0].value, context, 'resize/style 後仍使用最新產品 context');
		const value = { original: true };
		await f.settle(() => finish(value));
		assert.equal(results[1].value, value, '原 pending 結果只交同宿主一次');
		assert.equal(originalRows[0].disabled, false);
	}
});
