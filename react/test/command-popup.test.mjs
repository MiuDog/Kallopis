import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act, useState } from 'react';
import { flushSync } from 'react-dom';
import { renderToString } from 'react-dom/server';
import { JSDOM } from 'jsdom';
import { fileURLToPath } from 'node:url';
import { mkdirSync, writeFileSync, unlinkSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import * as klp from '../dist/index.js';

const h = React.createElement;
const point = Object.freeze({ x: 40, y: 60, width: 0, height: 0 });
const noop = () => {};
const context = () => ({});

function popup(props) {

	assert.equal(typeof klp.KlpRegisteredCommandPopup, 'function', '缺 public popup API 為 Yellow，不能宣稱 behavior Red');
	const defaults = { open: true, anchor: point, label: '產品命令', emptyLabel: '沒有命令', getContext: context, onResult: noop, onDismiss: noop };
	return h(klp.KlpRegisteredCommandPopup, { ...defaults, ...props });
}

function deferred() {

	let resolve;
	const promise = new Promise(yes => { resolve = yes; });
	return { promise, resolve };
}

function registryWithAction(handler = () => 'value') {

	const registry = new klp.KlpCommandRegistry();
	registry.register({ id: 'run', label: '執行', handler });
	return registry;
}

function menu(f) {

	const node = f.win.document.querySelector('[role="menu"]');
	assert.ok(node, 'open popup 必須包含公開 registered menu');
	return node;
}

function row(f, label = '執行') {

	const node = [...menu(f).querySelectorAll('button')].find(button => button.textContent.includes(label));
	assert.ok(node, `公開 menu 缺 ${label}`);
	return node;
}

function panel(f) {

	let node = menu(f);
	while (node && node.tagName !== 'DIALOG') {
		const style = f.win.getComputedStyle(node);
		if (['absolute', 'fixed'].includes(style.position) && style.left.endsWith('px') && style.top.endsWith('px')) return node;

		node = node.parentElement;
	}
	assert.fail('有限錨定容器必須輸出可觀察的原生位置');
}

function bounds(f) {

	const node = panel(f);
	const rect = node.getBoundingClientRect();
	for (const field of ['left', 'top', 'width', 'height', 'right', 'bottom']) assert.ok(Number.isFinite(rect[field]), `${field} 必須有限`);
	assert.ok(rect.width >= 0 && rect.height >= 0, 'scrollport 尺寸不得為負');
	return rect;
}

function pack(inset = 8, width = 300) {

	const semantics = {};
	const definitions = { 'theme.geometry.layout.overlayViewportInset': 'p(length-7)', 'theme.geometry.layout.commandMenuWidth': 'p(length-520)' };
	for (const [name, value] of Object.entries(definitions)) semantics[name] = Object.fromEntries(['light', 'dark', 'ultraDark', 'transparent'].map(mode => [mode, value]));
	return klp.applyKlpStyleOverrides(klp.createKlpStylePack(), { primitives: { 'length-7': inset, 'length-520': width }, semantics });
}

async function fixture(t) {

	// JSDOM 沒有 layout／top layer：只提供 client、自然 scrollHeight 與原生 modal 生命週期；不模擬定位算法或 inert 品質。
	const dom = new JSDOM('<!doctype html><button id="owner">開啟</button><input id="other"><div id="mount"></div>', { url: 'http://localhost', pretendToBeVisual: true });
	const win = dom.window;
	const mount = win.document.querySelector('#mount');
	const previous = new Map();
	const observers = new Set();
	const modal = new Set();
	const resizeListeners = new Set();
	const errors = [];
	const lifecycle = { opened: 0, closed: 0 };
	let viewport = { width: 640, height: 480 };
	let naturalHeight = 100;
	let root;

	class ResizeObserver {

		constructor(callback) { this.callback = callback; this.targets = new Set(); observers.add(this); }
		observe(target) { this.targets.add(target); }
		unobserve(target) { this.targets.delete(target); }
		disconnect() { this.targets.clear(); observers.delete(this); }
	}

	function showModal() {

		assert.equal(this.isConnected, true, 'showModal 必須在同 document 內');
		assert.equal(this.open, false, '同 owner 不重複 showModal');
		this.returnOwner = win.document.activeElement;
		this.open = true;
		modal.add(this);
		lifecycle.opened++;
	}

	function close() {

		if (!this.open) return;

		this.open = false;
		modal.delete(this);
		lifecycle.closed++;
		// 模擬 native dialog 自動回焦；產品已移焦時 popup 必須保留外部 owner。
		this.returnOwner?.focus();
		this.dispatchEvent(new win.Event('close'));
	}

	function nativeRect() {

		const style = win.getComputedStyle(this);
		const number = value => Number.parseFloat(value) || 0;
		const left = number(style.left);
		const top = number(style.top);
		const width = number(style.width);
		const explicitHeight = Number.parseFloat(style.height);
		const maximumHeight = Number.parseFloat(style.maxHeight);
		const height = Math.min(Number.isNaN(explicitHeight) ? naturalHeight : explicitHeight, Number.isNaN(maximumHeight) ? naturalHeight : maximumHeight);
		return { x: left, y: top, left, top, width, height, right: left + width, bottom: top + height, toJSON: noop };
	}

	Object.defineProperties(win.document.documentElement, { clientWidth: { configurable: true, get: () => viewport.width }, clientHeight: { configurable: true, get: () => viewport.height } });
	Object.defineProperties(win, { innerWidth: { configurable: true, get: () => viewport.width === 0 ? 0 : viewport.width + 15 }, innerHeight: { configurable: true, get: () => viewport.height === 0 ? 0 : viewport.height + 15 } });
	Object.defineProperties(win.HTMLElement.prototype, { scrollHeight: { configurable: true, get: () => naturalHeight }, getBoundingClientRect: { configurable: true, value: nativeRect } });
	win.HTMLDialogElement.prototype.showModal = showModal;
	win.HTMLDialogElement.prototype.close = close;
	win.ResizeObserver = ResizeObserver;
	win.reportError = error => errors.push(error);
	const addListener = win.addEventListener.bind(win);
	const removeListener = win.removeEventListener.bind(win);
	win.addEventListener = (type, listener, options) => { if (type === 'resize') resizeListeners.add(listener); addListener(type, listener, options); };
	win.removeEventListener = (type, listener, options) => { if (type === 'resize') resizeListeners.delete(listener); removeListener(type, listener, options); };
	const globals = { window: win, document: win.document, navigator: win.navigator, HTMLElement: win.HTMLElement, HTMLDialogElement: win.HTMLDialogElement, Element: win.Element, Node: win.Node, MutationObserver: win.MutationObserver, ResizeObserver, getComputedStyle: win.getComputedStyle.bind(win), reportError: win.reportError, IS_REACT_ACT_ENVIRONMENT: true };
	for (const [name, value] of Object.entries(globals)) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	const client = await import('react-dom/client');

	async function settle(callback = noop) {

		async function flush() { callback(); await Promise.resolve(); }
		await act(flush);
	}

	async function unmount() {

		if (!root) return;

		await act(() => root.unmount());
		root = null;
	}

	async function cleanup() {

		await unmount();
		win.close();
		for (const [name, descriptor] of previous) {
			if (descriptor) Object.defineProperty(globalThis, name, descriptor);
			else delete globalThis[name];
		}
	}
	t.after(cleanup);

	async function render(child, theme = {}) {

		function update() { root ??= client.createRoot(mount); root.render(h(klp.KlpThemeProvider, theme, child)); }
		await settle(update);
	}

	function renderNow(child) {

		flushSync(() => root.render(h(klp.KlpThemeProvider, null, child)));
	}

	async function key(node, value, init = {}) {

		const event = new win.KeyboardEvent('keydown', { key: value, bubbles: true, cancelable: true, ...init });
		await settle(() => node.dispatchEvent(event));
		return event;
	}

	async function resize(size, height = naturalHeight) {

		function notify() {

			viewport = size;
			naturalHeight = height;
			win.dispatchEvent(new win.Event('resize'));
			for (const observer of [...observers]) observer.callback([...observer.targets].map(target => ({ target, contentRect: target.getBoundingClientRect() })), observer);
		}
		await settle(notify);
	}
	return { win, mount, render, renderNow, settle, unmount, key, resize, observers, modal, lifecycle, errors, resizeListeners, click: node => settle(() => node.click()), pointer: node => settle(() => node.dispatchEvent(new win.MouseEvent('pointerdown', { bubbles: true, cancelable: true, clientX: 1, clientY: 1 }))) };
}

function publicBoundary() {

	const registry = registryWithAction();
	const props = { registry, items: [{ commandId: 'run' }], open: false };
	let queries = 0;
	let subscriptions = 0;
	const original = registry.subscribe.bind(registry);
	registry.subscribe = listener => { subscriptions++; return original(listener); };
	props.getContext = () => { queries++; return {}; };
	const markup = renderToString(h(klp.KlpThemeProvider, null, popup(props)));
	assert.equal(markup.includes('role="menu"'), false);
	assert.equal(markup.includes('<dialog'), false);
	assert.equal(queries, 0, '閉合 SSR 不讀業務 context');
	assert.equal(subscriptions, 0, '閉合 SSR 不訂閱清冊');
	for (const anchor of [{ ...point, x: NaN }, { ...point, y: Infinity }, { ...point, width: -1 }, { ...point, height: Infinity }]) {
		const invalid = { ...props, open: true, anchor };
		assert.throws(() => renderToString(h(klp.KlpThemeProvider, null, popup(invalid))), TypeError);
	}
}
test('公開 SSR 閉合零 query／subscription，非法 anchor 拒絕', publicBoundary);

async function closedClient(t) {

	const f = await fixture(t);
	const registry = registryWithAction();
	for (const method of ['getState', 'list', 'subscribe']) registry[method] = () => assert.fail(`closed client 不得 ${method}`);
	const props = { registry, items: [{ commandId: 'run' }], open: false, getContext: () => assert.fail('closed client 不讀 context') };
	await f.render(popup(props));
	assert.equal(f.win.document.querySelector('[role="menu"]'), null);
	assert.equal(f.lifecycle.opened, 0, 'closed client 不開 native modal');
}
test('閉合 client 不 query／subscribe／showModal', closedClient);

async function geometry(t) {

	const f = await fixture(t);
	const registry = registryWithAction();
	const props = { registry, items: [{ commandId: 'run' }] };
	await f.render(popup(props), { stylePack: pack() });
	assert.equal(bounds(f).left, 40, 'point LTR 對齊左緣');
	assert.equal(bounds(f).top, 60, '足夠空間優先下方');
	assert.equal(bounds(f).width, 300, '偏好寬讀目前 commandMenuWidth');
	await f.render(popup({ ...props, anchor: { x: 80, y: 70, width: 50, height: 20 } }), { stylePack: pack() });
	assert.equal(bounds(f).top, 90, '矩形錨定使用下緣');
	await f.render(popup({ ...props, anchor: { x: 80, y: 440, width: 50, height: 20 } }), { stylePack: pack() });
	assert.equal(bounds(f).bottom, 440, '下方不足且上方可容納時翻轉');
	for (const anchor of [{ x: -100, y: -100, width: 0, height: 0 }, { x: 900, y: -100, width: 0, height: 0 }, { x: -100, y: 900, width: 0, height: 0 }, { x: 900, y: 900, width: 0, height: 0 }, { x: Number.MAX_VALUE, y: Number.MAX_VALUE, width: Number.MAX_VALUE, height: Number.MAX_VALUE }]) {
		await f.render(popup({ ...props, anchor }), { stylePack: pack() });
		const rect = bounds(f);
		assert.ok(rect.left >= 8 && rect.top >= 8 && rect.right <= 632 && rect.bottom <= 472, '四邊／巨大合法 anchor 仍在有效 viewport');
	}
	await f.render(popup({ ...props, anchor: { x: 400, y: 40, width: 20, height: 10 } }), { stylePack: pack(), dir: 'rtl' });
	assert.equal(bounds(f).right, 420, 'RTL 對齊 anchor 右緣');
	await f.resize({ width: 160, height: 100 }, 200);
	await f.render(popup({ ...props, anchor: { x: 40, y: 50, width: 0, height: 0 } }), { stylePack: pack() });
	assert.equal(bounds(f).top, 50, '兩邊不足同量偏好下方');
	assert.ok(bounds(f).height <= 42, '不足內容由可用側限制 scrollport');
	await f.render(popup(props), { stylePack: pack(1000000, 1000000) });
	assert.ok(bounds(f).width <= 60 && bounds(f).height <= 0, '極大合法 inset 夾入 viewport 短邊一半');
	await f.resize({ width: 0, height: 0 });
	assert.equal(bounds(f).width, 0, '原生零 viewport 不回退成非零視窗');
	assert.equal(bounds(f).height, 0);
	await f.resize({ width: Infinity, height: NaN });
	assert.equal(bounds(f).width, 0, '非有限原生 viewport 安全退化');
	assert.equal(bounds(f).height, 0);
}
test('公開有限 geometry：point／rect／四邊／翻轉／RTL／零 viewport／極大 style', geometry);

async function registeredMenu(t) {

	const f = await fixture(t);
	const registry = new klp.KlpCommandRegistry();
	const value = { original: [] };
	const error = { product: 'failure' };
	const results = [];
	const intents = [];
	const order = [];
	let state = { enabled: false, visible: false, checked: true };
	registry.register({ id: 'run', label: '執行', description: '產品說明', icon: h('span', { 'data-product-icon': true }, '*'), handler: () => value, isChecked: current => current.checked });
	registry.register({ id: 'gate', label: '限制', handler: () => assert.fail('disabled 不執行'), isEnabled: current => current.enabled });
	registry.register({ id: 'hide', label: '隱藏', handler: noop, isVisible: current => current.visible });
	registry.register({ id: 'fail', label: '失敗', handler: () => { throw error; } });
	function onResult(result) { results.push(result); order.push('result'); }
	function onDismiss(reason) { intents.push(reason); order.push(reason); }
	const items = [{ commandId: 'gate' }, { commandId: 'missing' }, { commandId: 'run', kind: 'toggle' }, { commandId: 'hide' }, { commandId: 'fail' }];
	const props = { registry, items, getContext: () => state, onResult, onDismiss };
	await f.render(popup(props));
	assert.deepEqual([...menu(f).querySelectorAll('button')].map(button => button.textContent.includes('產品說明') ? '執行' : button.textContent), ['限制', '執行', '失敗']);
	assert.equal(row(f).getAttribute('role'), 'menuitemcheckbox');
	assert.equal(row(f).getAttribute('aria-checked'), 'true');
	assert.ok(row(f).querySelector('[data-product-icon]'));
	assert.ok(row(f).textContent.includes('產品說明'));
	assert.equal(row(f, '限制').disabled, true);
	await f.click(row(f, '限制'));
	assert.equal(results.length, 0);
	await f.click(row(f, '失敗'));
	assert.equal(results[0].error, error);
	assert.equal(results[0].status, 'error');
	assert.deepEqual(intents, []);
	await f.click(row(f));
	assert.equal(results[1].value, value);
	assert.deepEqual(order.slice(-2), ['result', 'executed']);
	assert.ok(menu(f), '產品忽略 executed 意圖仍保持 open 可操作');
	await f.click(row(f));
	assert.equal(results.length, 3);
	assert.deepEqual(intents, ['executed'], '同 session 同意圖最多一次');
	state = { ...state, checked: false };
	await f.settle(() => registry.refresh());
	assert.equal(row(f).getAttribute('aria-checked'), 'false');
}
test('同公開 menu 的順序／metadata／checked／gates／原值 error，成功先 result 後 executed', registeredMenu);

async function controlledDismiss(t) {

	const f = await fixture(t);
	const intents = [];
	const registry = registryWithAction();
	const props = { registry, items: [{ commandId: 'run' }], onDismiss: reason => intents.push(reason) };
	await f.render(popup(props));
	const dialog = menu(f).closest('dialog');
	assert.ok(dialog && dialog.open && f.modal.has(dialog), '原生 showModal 擁有背景 inert／top layer');
	assert.ok(f.mount.contains(dialog), '同 Provider DOM 保留 style scope');
	await f.key(row(f), 'Escape');
	await f.key(row(f), 'Escape');
	assert.deepEqual(intents, ['escape']);
	await f.pointer(dialog);
	await f.pointer(dialog);
	assert.deepEqual(intents, ['escape', 'outside']);
	assert.ok(menu(f), 'dismiss 不自行修改受控 open');
	const named = [...dialog.querySelectorAll('button')].find(button => !menu(f).contains(button) && (button.getAttribute('aria-label') || button.textContent.trim()));
	assert.ok(named, '外側 dismiss 有可命名的原生操作入口');
	assert.equal(named.tabIndex, -1, 'dismiss 不成為 menu 外額外 Tabstop');
	await f.click(named);
	assert.deepEqual(intents, ['escape', 'outside']);
	await f.render(popup({ ...props, open: false }));
	assert.equal(f.modal.size, 0);
	await f.render(popup(props));
	await f.key(row(f), 'Escape');
	assert.deepEqual(intents, ['escape', 'outside', 'escape'], '重開是新 session');
	await f.unmount();
	assert.equal(f.modal.size, 0);
	assert.equal(registry.isDisposed, false, 'popup 不 dispose 產品清冊');
}
test('原生 modal／命名 outside／Escape controlled once／重開／cleanup', controlledDismiss);

async function staleResults(t) {

	for (const change of ['reopen', 'replacement', 'unmount']) {
		async function check(sub) {

			const f = await fixture(sub);
			const pending = deferred();
			const registry = registryWithAction(() => pending.promise);
			const results = [];
			const intents = [];
			const props = { registry, items: [{ commandId: 'run' }], onResult: result => results.push(result), onDismiss: reason => intents.push(reason) };
			await f.render(popup(props));
			await f.click(row(f));
			assert.equal(row(f).disabled, true, 'pending 仍由 registry gate 擁有');
			if (change === 'unmount') await f.unmount();
			else if (change === 'replacement') await f.render(popup({ ...props, registry: registryWithAction() }));
			else {
				await f.render(popup({ ...props, open: false }));
				await f.render(popup(props));
			}
			await f.settle(() => pending.resolve('stale'));
			assert.deepEqual(results, [], '過期結果不可交到新宿主');
			assert.deepEqual(intents, [], '過期成功不可 dismiss 新 session');
		}
		await t.test(change, check);
	}
}
test('close/reopen／registry replacement／unmount 隔離非同步 stale 結果', staleResults);

async function callbackLifetime(t) {

	const f = await fixture(t);
	const pending = deferred();
	const registry = registryWithAction(() => pending.promise);
	const old = [];
	const latest = [];
	const intents = [];
	const props = { registry, items: [{ commandId: 'run' }], onResult: result => old.push(result), onDismiss: reason => intents.push(reason) };
	await f.render(popup(props));
	await f.click(row(f));
	await f.render(popup({ ...props, onResult: result => latest.push(result) }));
	await f.settle(() => pending.resolve('current'));
	assert.deepEqual(old, []);
	assert.equal(latest[0].value, 'current');
	assert.deepEqual(intents, ['executed']);
	await f.render(popup({ ...props, open: false }));
	const error = { callback: 'failure' };
	function brokenResult() { throw error; }
	await f.render(popup({ ...props, registry: registryWithAction(), onResult: brokenResult }));
	await f.click(row(f));
	assert.equal(f.errors.pop(), error, 'callback 原錯誤交宿主 error 通道');
	assert.deepEqual(intents, ['executed'], 'callback 拋錯不得 executed dismiss');
	assert.ok(menu(f));
	await f.render(popup({ ...props, open: false }));
	function closeOnResult() { f.renderNow(popup({ ...props, open: false })); }
	await f.render(popup({ ...props, registry: registryWithAction(), onResult: closeOnResult }));
	await f.click(row(f));
	assert.deepEqual(intents, ['executed'], 'onResult 關閉後不可輸出 executed');
}
test('最新 callback／callback 原錯誤／onResult 關閉後不再 dismiss', callbackLifetime);

async function focusAndProductState(t) {

	const f = await fixture(t);
	const registry = registryWithAction();
	const props = { registry, items: [{ commandId: 'run' }] };
	let mounts = 0;
	let changeDraft;
	function Product({ open, anchor }) {

		const [draft, setDraft] = useState(() => { mounts++; return '產品草稿'; });
		changeDraft = setDraft;
		const input = h('input', { 'aria-label': '產品草稿', value: draft, onChange: event => setDraft(event.target.value) });
		return h('main', null, input, popup({ ...props, open, anchor }));
	}
	const owner = f.win.document.querySelector('#owner');
	const other = f.win.document.querySelector('#other');
	owner.focus();
	await f.render(h(Product, { open: true, anchor: point }));
	assert.equal(f.win.document.activeElement, row(f), 'popup 自動聚焦第一可用 menu 入口');
	const draft = f.mount.querySelector('[aria-label="產品草稿"]');
	await f.settle(() => changeDraft('已修改的產品草稿'));
	const first = row(f);
	await f.key(first, 'Tab');
	assert.ok(menu(f).contains(f.win.document.activeElement), 'Tab 留在可用 menu 入口');
	await f.resize({ width: 320, height: 240 });
	await f.render(h(Product, { open: true, anchor: { ...point, x: 80 } }), { mode: 'dark', stylePack: pack(8, 150) });
	assert.equal(row(f), first, 'style／viewport／anchor 變化保留同 ID 原生焦點節點');
	assert.equal(f.mount.querySelector('[aria-label="產品草稿"]'), draft);
	assert.equal(draft.value, '已修改的產品草稿');
	assert.equal(mounts, 1, 'background 產品 State 不卸載');
	await f.render(h(Product, { open: false, anchor: point }));
	assert.equal(f.win.document.activeElement, owner, '焦點仍屬 popup 時回到開啟 owner');
	owner.focus();
	await f.render(h(Product, { open: true, anchor: point }));
	other.focus();
	await f.render(h(Product, { open: false, anchor: point }));
	assert.equal(f.win.document.activeElement, other, '產品已移焦時保留外部 owner');
	await f.render(popup({ ...props, items: [{ commandId: 'missing' }] }));
	assert.equal(f.win.document.activeElement, menu(f), '無可用項時 focus root');
	await f.key(menu(f), 'Tab');
	assert.equal(f.win.document.activeElement, menu(f));
	await f.unmount();
	assert.equal([...f.observers].flatMap(observer => [...observer.targets]).length, 0, '解除所有 observer target');
	assert.equal(f.resizeListeners.size, 0, '解除此 owner 的原生 resize listener');
	assert.equal(f.modal.size, 0);
	await f.resize({ width: 900, height: 700 });
	assert.equal(f.errors.length, 0, 'cleanup 後尺寸通知不觸及舊 owner');
}
test('條件回焦／Tab 閉合／同產品 State draft／同 ID focus／observer cleanup', focusAndProductState);

function typedConsumer() {

	// TS7 僅提供原生 CLI；packet 授權此 ignored 執行期 fixture，finally 刪除避免留下額外來源。
	const directory = fileURLToPath(new URL('../build/consumers/', import.meta.url));
	const filename = fileURLToPath(new URL('../build/consumers/command-popup.mts', import.meta.url));
	const source = `import React from 'react';
import { KlpCommandRegistry, KlpRegisteredCommandPopup, type KlpRegisteredCommandPopupProps, type KlpCommandPopupAnchor, type KlpCommandPopupDismissReason, type KlpCommandExecutionResult } from '../../dist/index.js';
type Context = { selection: string };
const registry = new KlpCommandRegistry<Context>();
const anchor: KlpCommandPopupAnchor = { x: 1, y: 2, width: 0, height: 0 };
const props: KlpRegisteredCommandPopupProps<Context> = { registry, getContext: () => ({ selection: 'current' }), items: [], label: 'Commands', emptyLabel: 'Empty', onResult: result => { const typed: KlpCommandExecutionResult = result; void typed; }, open: true, anchor, onDismiss: reason => { const typed: KlpCommandPopupDismissReason = reason; void typed; }, className: 'product', id: 'popup' };
type RequiredKeys<T> = { [K in keyof T]-?: {} extends Pick<T, K> ? never : K }[keyof T];
type Equal<A, B> = [A] extends [B] ? ([B] extends [A] ? true : false) : false;
type Assert<T extends true> = T;
type RequiredContract = Assert<Equal<RequiredKeys<KlpRegisteredCommandPopupProps<Context>>, 'registry' | 'getContext' | 'items' | 'label' | 'emptyLabel' | 'onResult' | 'open' | 'anchor' | 'onDismiss'>>;
type AnchorContract = Assert<Equal<RequiredKeys<KlpCommandPopupAnchor>, 'x' | 'y' | 'width' | 'height'>>;
React.createElement(KlpRegisteredCommandPopup<Context>, props);
// @ts-expect-error anchor 是 readonly。
anchor.x = 2;
// @ts-expect-error 不允許 consumer 覆蓋內部 geometry。
const styled: KlpRegisteredCommandPopupProps<Context> = { ...props, style: { left: 1 } };
// @ts-expect-error 必填受控 open。
const missing: KlpRegisteredCommandPopupProps<Context> = { registry, getContext: () => ({ selection: '' }), items: [], label: 'Commands', emptyLabel: 'Empty', onResult: () => {}, anchor, onDismiss: () => {} };
// @ts-expect-error dismiss union 限定三種意圖。
const reason: KlpCommandPopupDismissReason = 'cancel';
void styled; void missing; void reason;
`;
	mkdirSync(directory, { recursive: true });
	writeFileSync(filename, source);
	try {
		const executable = fileURLToPath(new URL('../node_modules/typescript/bin/tsc', import.meta.url));
		const argumentsList = [executable, '--ignoreConfig', '--strict', '--skipLibCheck', '--target', 'ES2022', '--module', 'NodeNext', '--moduleResolution', 'NodeNext', '--noEmit', filename];
		const result = spawnSync(process.execPath, argumentsList, { encoding: 'utf8' });
		assert.equal(result.error, undefined);
		assert.equal(result.status, 0, `public typed consumer 不成立屬 Yellow\n${result.stdout}\n${result.stderr}`);
	}
	finally {
		unlinkSync(filename);
	}
}
test('公開 generic props／readonly anchor／required controlled props／禁止 style／dismiss union typedconsumer', typedConsumer);
