import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { renderToString } from 'react-dom/server';
import { JSDOM } from 'jsdom';
import { mkdirSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import * as klp from '../dist/index.js';

const h = React.createElement;
const provider = (child, props = {}) => h(klp.KlpThemeProvider, props, child);
function palette(props) {
	assert.ok(klp.KlpRegisteredCommandPalette, '缺公開 palette export 是 compile Yellow，非 behavior Red');
	return h(klp.KlpRegisteredCommandPalette, { getContext: () => ({}), open: true, label: '命令', searchLabel: '搜尋', emptyLabel: '無結果', onResult: () => {}, onDismiss: () => {}, ...props });
}
function deferred() {
	let resolve, reject;
	const promise = new Promise((yes, no) => { resolve = yes; reject = no; });
	return { promise, resolve, reject };
}
async function fixture(t, html = '') {
	const dom = new JSDOM(`<!doctype html><input id="outside" value="產品文字"><input id="other"><div id="mount">${html}</div>`, { url: 'http://localhost', pretendToBeVisual: true });
	const win = dom.window, previous = new Map(), mount = win.document.querySelector('#mount');
	for (const [name, value] of Object.entries({ window: win, document: win.document, navigator: win.navigator, HTMLElement: win.HTMLElement, Element: win.Element, Node: win.Node, MutationObserver: win.MutationObserver, getComputedStyle: win.getComputedStyle.bind(win), IS_REACT_ACT_ENVIRONMENT: true })) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	const client = await import('react-dom/client');
	let root = null;
	const unmount = async () => { if (root) { await act(async () => root.unmount()); root = null; } };
	t.after(async () => {
		await unmount(); win.close();
		for (const [name, descriptor] of previous) {
			if (descriptor) Object.defineProperty(globalThis, name, descriptor);
			else delete globalThis[name];
		}
	});
	const settle = callback => act(async () => { callback(); await Promise.resolve(); });
	return {
		win, mount, unmount, settle,
		render: (child, theme) => act(async () => { root ??= client.createRoot(mount); root.render(provider(child, theme)); }),
		hydrate: (child, errors) => act(async () => { root = client.hydrateRoot(mount, provider(child), { onRecoverableError: error => errors.push(error) }); }),
		input: () => win.document.querySelector('[role="combobox"]'),
		options: () => [...win.document.querySelectorAll('[role="option"]')],
		click: node => settle(() => node.dispatchEvent(new win.MouseEvent('click', { bubbles: true, cancelable: true }))),
		key: async (key, init = {}) => {
			const event = new win.KeyboardEvent('keydown', { key, bubbles: true, cancelable: true, ...init });
			await settle(() => win.document.querySelector('[role="combobox"]').dispatchEvent(event));
			return event;
		},
		query: value => settle(() => {
			const input = win.document.querySelector('[role="combobox"]');
			Object.getOwnPropertyDescriptor(win.HTMLInputElement.prototype, 'value').set.call(input, value);
			input.dispatchEvent(new win.Event('input', { bubbles: true }));
		}),
	};
}
const labels = f => f.options().map(node => node.textContent);
function option(f, label) {
	const found = f.options().find(node => node.textContent.includes(label));
	assert.ok(found, `候選 ${label} 必須存在`);
	return found;
}
function active(f) {
	const id = f.input().getAttribute('aria-activedescendant');
	const node = id ? f.win.document.getElementById(id) : null;
	if (id) assert.ok(node, 'active descendant 只能指向存在候選');
	return node;
}

test('公開搜尋完整 fields、多詞 Unicode、score 及 UTF-16 ID 順序', async t => {
	const f = await fixture(t), registry = new klp.KlpCommandRegistry();
	for (const definition of [
		{ id: 'z', label: 'abacus Z' }, { id: 'a', label: 'abacus A' }, { id: 'exact', label: 'ab' },
		{ id: 'substring', label: 'cab' }, { id: 'sequence', label: 'a---b' },
		{ id: 'identifier', label: 'Only ID' }, { id: 'metadata', label: '中文名稱', category: 'tools', description: 'descriptionword', keywords: ['keywordword'], icon: h('span', { 'data-icon': true }, '*') },
		{ id: 'boundary', label: 'left', category: 'right' },
	]) registry.register({ ...definition, handler: () => {} });
	await f.render(palette({ registry }));
	assert.equal(f.win.document.querySelector('[role="dialog"]').getAttribute('aria-label'), '命令');
	assert.equal(f.win.document.querySelector('[role="dialog"]').getAttribute('aria-modal'), 'true');
	assert.equal(f.input().getAttribute('aria-label'), '搜尋');
	assert.equal(f.input().getAttribute('aria-expanded'), 'true');
	assert.equal(f.win.document.getElementById(f.input().getAttribute('aria-controls')).getAttribute('role'), 'listbox');
	const expectedOrder = ['abacus A', 'left', 'ab', 'Only ID', '中文名稱', 'a---b', 'cab', 'abacus Z'];
	for (const [index, label] of expectedOrder.entries()) assert.ok(f.options()[index].textContent.includes(label));
	assert.ok(option(f, '中文名稱').textContent.includes('descriptionword'));
	assert.ok(option(f, '中文名稱').textContent.includes('tools'));
	assert.ok(option(f, '中文名稱').querySelector('[data-icon]'));
	await f.query(' AB ');
	assert.deepEqual(labels(f), ['ab', 'abacus A', 'abacus Z', 'cab', 'a---b']);
	for (const query of ['identifier', '中文', 'descriptionword', 'tools', 'keywordword', '中文\u3000tools\tkeywordword']) {
		await f.query(query); assert.equal(f.options().length, 1);
	}
	await f.query('leftright'); assert.equal(f.options().length, 0); assert.ok(f.win.document.body.textContent.includes('無結果'));
	await f.query(''); assert.equal(f.options().length, 8);
});

test('latest context、refresh/register/unregister/dispose、disabled 與 pending 可見但不可啟動', async t => {
	const f = await fixture(t), registry = new klp.KlpCommandRegistry(), pending = deferred(), results = [];
	let context = { visible: true, enabled: true, value: 1 }, calls = 0;
	const remove = registry.register({ id: 'a', label: 'State', isVisible: c => c.visible, isEnabled: c => c.enabled, handler: c => { calls++; return c.value; } });
	registry.register({ id: 'b', label: 'Pending', handler: () => pending.promise });
	registry.register({ id: 'c', label: 'Other', handler: () => 'other' });
	const props = { registry, getContext: () => context, onResult: result => results.push(result) };
	await f.render(palette(props));
	context = { visible: true, enabled: false, value: 2 };
	await f.click(option(f, 'State')); assert.equal(calls, 0); assert.equal(results.at(-1).status, 'disabled');
	await f.settle(() => registry.refresh()); assert.equal(option(f, 'State').getAttribute('aria-disabled'), 'true');
	assert.equal(active(f), option(f, 'Pending'));
	context.enabled = true; await f.settle(() => registry.refresh());
	context.visible = false; await f.click(option(f, 'State')); assert.equal(calls, 0); assert.equal(results.at(-1).status, 'hidden');
	await f.settle(() => registry.refresh()); assert.equal(f.options().length, 2);
	context = { visible: true, enabled: true, value: 3 }; await f.query('State'); await f.click(option(f, 'State')); assert.equal(results.at(-1).value, 3);
	await f.query(''); await f.click(option(f, 'Pending')); assert.equal(option(f, 'Pending').getAttribute('aria-disabled'), 'true');
	const count = results.length; await f.click(option(f, 'Pending')); assert.equal(results.length, count);
	await f.click(option(f, 'Other')); assert.equal(results.at(-1).value, 'other');
	await f.settle(() => pending.resolve('original')); assert.equal(results.at(-1).value, 'original');
	await f.settle(remove); assert.equal(f.options().length, 2);
	await f.settle(() => registry.register({ id: 'a', label: 'New', handler: () => {} })); assert.ok(option(f, 'New'));
	await f.settle(() => registry.dispose()); assert.equal(f.options().length, 0); assert.equal(active(f), null);
	await f.render(palette(props)); assert.ok(f.win.document.body.textContent.includes('無結果'));
});

test('原生 input focus、方向循環、selection 保留、once Enter、IME、游標與全部 disabled', async t => {
	const f = await fixture(t), registry = new klp.KlpCommandRegistry(), results = [], dismiss = [];
	for (const id of ['A', 'B', 'C']) registry.register({ id, label: id, isEnabled: () => id !== 'B', handler: () => id });
	await f.render(palette({ registry, onResult: result => results.push(result), onDismiss: reason => dismiss.push(reason) }));
	assert.equal(f.win.document.activeElement, f.input()); assert.equal(active(f), option(f, 'A'));
	await f.key('ArrowDown'); assert.equal(active(f), option(f, 'C'));
	await f.key('ArrowDown'); assert.equal(active(f), option(f, 'A'));
	await f.key('ArrowUp'); assert.equal(active(f), option(f, 'C'));
	await f.settle(() => registry.refresh()); assert.equal(active(f), option(f, 'C'));
	assert.equal(option(f, 'C').getAttribute('aria-selected'), 'true');
	await f.key('Enter', { repeat: true }); assert.equal(results.length, 0);
	for (const key of ['Home', 'End', 'ArrowLeft', 'ArrowRight']) assert.equal((await f.key(key)).defaultPrevented, false);
	await f.settle(() => f.input().dispatchEvent(new f.win.CompositionEvent('compositionstart', { bubbles: true })));
	for (const key of ['ArrowDown', 'ArrowUp', 'Enter', 'Escape']) assert.equal((await f.key(key)).defaultPrevented, false);
	assert.equal(results.length, 0); assert.equal(dismiss.length, 0); assert.equal(active(f), option(f, 'C'));
	await f.settle(() => f.input().dispatchEvent(new f.win.CompositionEvent('compositionend', { bubbles: true })));
	await f.key('Enter', { isComposing: true }); assert.equal(results.length, 0);
	await f.key('Enter'); assert.equal(results.length, 1); assert.equal(results[0].value, 'C'); assert.deepEqual(dismiss, ['executed']);
	await f.click(option(f, 'A')); assert.equal(f.win.document.activeElement, f.input());
	assert.equal((await f.key('Tab')).defaultPrevented, true); assert.equal(f.win.document.activeElement, f.input());
	await f.query('B'); assert.equal(active(f), null); await f.key('Enter'); await f.click(option(f, 'B')); assert.equal(results.length, 2);
	await f.query('missing'); assert.equal(active(f), null); await f.key('ArrowDown'); await f.key('Enter'); assert.equal(results.length, 2);
});

test('受控 close/reset、escape/outside、theme 更新保留 query、還原原 focus 與原 selection', async t => {
	const f = await fixture(t), registry = new klp.KlpCommandRegistry(), dismiss = [], outside = f.win.document.querySelector('#outside');
	registry.register({ id: 'a', label: 'Alpha', handler: () => {} });
	const props = { registry, onDismiss: reason => dismiss.push(reason) };
	outside.focus(); outside.setSelectionRange(2, 4);
	await f.render(palette({ ...props, open: false, getContext: () => assert.fail('closed 不讀 context') }));
	assert.equal(f.input(), null); assert.equal(f.win.document.activeElement, outside);
	await f.render(palette(props)); await f.query('Alpha');
	await f.render(palette(props), { mode: 'dark' }); assert.equal(f.input().value, 'Alpha');
	await f.settle(() => {
		Object.defineProperty(f.win, 'innerWidth', { configurable: true, value: 1 });
		Object.defineProperty(f.win, 'innerHeight', { configurable: true, value: 1 });
		f.win.dispatchEvent(new f.win.Event('resize'));
	});
	assert.equal(f.input().value, 'Alpha');
	for (const node of f.win.document.body.querySelectorAll('[style]')) assert.equal(/NaN|Infinity/.test(node.getAttribute('style')), false);
	await f.key('Escape'); assert.deepEqual(dismiss, ['escape']); assert.ok(f.input(), '關閉由產品更新 open');
	await f.click(f.win.document.querySelector('[role="dialog"]')); assert.deepEqual(dismiss, ['escape']);
	// backdrop 是包含 panel 的 portal 宿主；不依類名或 private state。
	await f.click(f.win.document.querySelector('[role="dialog"]').parentElement); assert.deepEqual(dismiss, ['escape', 'outside']);
	await f.render(palette({ ...props, open: false })); assert.equal(f.win.document.activeElement, outside);
	assert.equal(outside.value, '產品文字'); assert.equal(outside.selectionStart, 2); assert.equal(outside.selectionEnd, 4);
	await f.render(palette(props)); assert.equal(f.input().value, '');
	const replacement = new klp.KlpCommandRegistry(); replacement.register({ id: 'b', label: 'Beta', handler: () => {} });
	await f.render(palette({ ...props, registry: replacement })); await f.unmount(); assert.equal(f.win.document.activeElement, outside);
});

test('原 async value/error、latest callback、callbackthrow 保持 open、產品外部 focus 不搶回', async t => {
	const f = await fixture(t), registry = new klp.KlpCommandRegistry(), pending = deferred(), value = {}, reason = {}, old = [], latest = [], dismiss = [], errors = [];
	registry.register({ id: 'a', label: 'Async', handler: () => pending.promise });
	registry.register({ id: 'b', label: 'Error', handler: () => Promise.reject(reason) });
	registry.register({ id: 'c', label: 'Sync', handler: () => value });
	const props = { registry, onResult: result => old.push(result), onDismiss: reason => dismiss.push(reason) };
	await f.render(palette(props)); await f.click(option(f, 'Async'));
	await f.render(palette({ ...props, onResult: result => latest.push(result) }));
	await f.settle(() => pending.resolve(value)); assert.equal(latest[0].value, value); assert.equal(old.length, 0); assert.deepEqual(dismiss, ['executed']);
	await f.click(option(f, 'Error')); assert.equal(latest[1].error, reason); assert.equal(latest[1].phase, 'handler'); assert.equal(dismiss.length, 1);
	const descriptor = Object.getOwnPropertyDescriptor(globalThis, 'reportError');
	Object.defineProperty(globalThis, 'reportError', { configurable: true, value: error => errors.push(error) }); f.win.reportError = error => errors.push(error);
	try {
		await f.render(palette({ ...props, onResult: () => { throw reason; } }));
		await f.click(option(f, 'Sync')); assert.equal(errors.at(-1), reason); assert.equal(dismiss.length, 1);
		await f.click(option(f, 'Sync')); assert.equal(errors.length, 2);
	} finally { if (descriptor) Object.defineProperty(globalThis, 'reportError', descriptor); else delete globalThis.reportError; }
	const other = f.win.document.querySelector('#other');
	await f.render(palette({ ...props, onResult: () => other.focus() })); await f.click(option(f, 'Sync'));
	await f.render(palette({ ...props, open: false })); assert.equal(f.win.document.activeElement, other);
});

test('close/reopen、unmount、registry replacement 隔離已開始 Promise，且不取消業務', async t => {
	for (const transition of ['close', 'unmount', 'registry']) await t.test(transition, async sub => {
		const f = await fixture(sub), registry = new klp.KlpCommandRegistry(), pending = deferred(), results = [], dismiss = [];
		registry.register({ id: 'a', label: 'Pending', handler: () => pending.promise });
		const props = { registry, onResult: result => results.push(result), onDismiss: reason => dismiss.push(reason) };
		await f.render(palette(props)); await f.click(option(f, 'Pending'));
		if (transition === 'unmount') await f.unmount();
		else if (transition === 'close') { await f.render(palette({ ...props, open: false })); await f.render(palette(props)); }
		else { const replacement = new klp.KlpCommandRegistry(); replacement.register({ id: 'b', label: 'New', handler: () => {} }); await f.render(palette({ ...props, registry: replacement })); }
		await f.settle(() => pending.resolve('stale')); assert.equal(results.length, 0); assert.equal(dismiss.length, 0);
		assert.equal(await pending.promise, 'stale');
	});
});

test('SSR 無 modal、hydration 一致，portal 保留目前 scoped style pack/mode', async t => {
	const registry = new klp.KlpCommandRegistry(); registry.register({ id: 'a', label: 'Alpha', handler: () => {} });
	const child = palette({ registry });
	const html = renderToString(provider(child)); assert.equal(html.includes('role="dialog"'), false);
	assert.equal(renderToString(provider(palette({ registry, open: false }))).includes('role="dialog"'), false);
	const f = await fixture(t, html), errors = [];
	await f.hydrate(child, errors); assert.equal(errors.length, 0); assert.ok(f.input()); assert.equal(f.mount.contains(f.input()), false);
	const pack = klp.applyKlpStyleOverrides(klp.createKlpStylePack(), { semantics: { 'theme.colors.app': { light: 'p(ink50)', dark: 'p(ink50)' } } });
	function Probe() { return null; }
	const content = h(
		React.Fragment,
		null,
		h(Probe),
		child,
	);
	await f.render(content, { mode: 'dark', stylePack: pack });
	const source = f.mount.querySelector('[style]');
	assert.ok(source, 'theme provider 提供 scoped semantic variables');
	const properties = Array.from({ length: source.style.length }, (_, index) => source.style.item(index)).filter(property => property.startsWith('--'));
	assert.ok(properties.length > 0);
	for (const property of properties) {
		const token = source.style.getPropertyValue(property);
		let node = f.input(), actual = '';
		while (node && !actual) { actual = node.style.getPropertyValue(property); node = node.parentElement; }
		assert.equal(actual, token, `portal 保留 ${property}`);
	}
	for (const node of f.win.document.body.querySelectorAll('[style]')) assert.equal(/NaN|Infinity/.test(node.getAttribute('style')), false);
});

test('公開 generic props／dismiss union 與必填 callback consumer 編譯', () => {
	const directory = fileURLToPath(new URL('../build/consumers/', import.meta.url)), filename = fileURLToPath(new URL('../build/consumers/command-palette.mts', import.meta.url));
	mkdirSync(directory, { recursive: true });
	writeFileSync(filename, `import React from 'react';
import { KlpCommandRegistry, KlpRegisteredCommandPalette, type KlpRegisteredCommandPaletteProps, type KlpCommandDismissReason, type KlpCommandExecutionResult } from '../../dist/index.js';
type Context = { value: string };
const registry = new KlpCommandRegistry<Context>();
const props: KlpRegisteredCommandPaletteProps<Context> = { registry, getContext: () => ({ value: 'current' }), open: true, label: 'Commands', searchLabel: 'Search', emptyLabel: 'Empty', onResult: result => { const typed: KlpCommandExecutionResult = result; void typed; }, onDismiss: reason => { const typed: KlpCommandDismissReason = reason; void typed; }, id: 'palette', className: 'product' };
React.createElement(KlpRegisteredCommandPalette<Context>, props);
type DefaultContext = KlpRegisteredCommandPaletteProps;
const reasons: readonly KlpCommandDismissReason[] = ['escape', 'outside', 'executed'];
// @ts-expect-error dismiss 不接受未知理由。
const wrong: KlpCommandDismissReason = 'cancel';
// @ts-expect-error open 為 required。
const missing: KlpRegisteredCommandPaletteProps<Context> = { registry, getContext: props.getContext, label: 'Commands', searchLabel: 'Search', emptyLabel: 'Empty', onResult: props.onResult, onDismiss: props.onDismiss };
void reasons; void wrong; void missing; let defaultProps: DefaultContext | undefined; void defaultProps;
`);
	const args = [fileURLToPath(new URL('../node_modules/typescript/bin/tsc', import.meta.url)), '--ignoreConfig', '--strict', '--skipLibCheck', '--target', 'ES2022', '--module', 'NodeNext', '--moduleResolution', 'NodeNext', '--noEmit', filename];
	const result = spawnSync(process.execPath, args, { encoding: 'utf8' });
	assert.equal(result.error, undefined); assert.equal(result.status, 0, `缺公開元件／型別是 compile Yellow，非 behavior Red\n${result.stdout}\n${result.stderr}`);
});
