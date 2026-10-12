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
const kinds = ['toolbar', 'menu'];
const deferred = () => {
	let resolve, reject;
	const promise = new Promise((yes, no) => { resolve = yes; reject = no; });
	return { promise, resolve, reject };
};
function entry(kind, props) {
	const Component = kind === 'toolbar' ? klp.KlpRegisteredCommandToolbar : klp.KlpRegisteredCommandMenu;
	assert.ok(Component, `${kind} 缺公開 export 是 compile Yellow，非 behavior Red`);
	return h(Component, { label: kind, ...(kind === 'menu' ? { emptyLabel: '無命令' } : {}), getContext: () => ({}), onResult: () => {}, ...props });
}
const view = child => h(klp.KlpThemeProvider, null, child);
const rows = root => [...root.querySelectorAll('button')];
function row(root, label) {
	const button = rows(root).find(node => node.textContent.includes(label) || node.getAttribute('aria-label') === label);
	assert.ok(button, `${label} 必須呈現原生 button`);
	return button;
}
async function fixture(t) {
	const dom = new JSDOM('<!doctype html><input id="outside"><div id="mount"></div>', { url: 'http://localhost' });
	const win = dom.window, mount = win.document.querySelector('#mount'), previous = new Map();
	for (const [name, value] of Object.entries({ window: win, document: win.document, navigator: win.navigator, HTMLElement: win.HTMLElement, Element: win.Element, Node: win.Node, MutationObserver: win.MutationObserver, getComputedStyle: win.getComputedStyle.bind(win), IS_REACT_ACT_ENVIRONMENT: true })) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	const { createRoot } = await import('react-dom/client');
	const root = createRoot(mount);
	let unmounted = false;
	const unmount = async () => { if (!unmounted) { await act(() => root.unmount()); unmounted = true; } };
	t.after(async () => {
		await unmount(); win.close();
		for (const [name, descriptor] of previous) {
			if (descriptor) Object.defineProperty(globalThis, name, descriptor);
			else delete globalThis[name];
		}
	});
	return {
		win, mount, unmount,
		render: child => act(() => root.render(view(child))),
		click: node => act(() => node.click()),
		key: async (node, key) => {
			const event = new win.KeyboardEvent('keydown', { key, bubbles: true, cancelable: true });
			await act(() => { node.focus(); node.dispatchEvent(event); });
			return event;
		},
		settle: callback => act(async () => { callback(); await Promise.resolve(); }),
	};
}

test('公開 SSR 保留產品順序／metadata／toggle 語意，拒絕非法 references 與必填字串', () => {
	const registry = new klp.KlpCommandRegistry();
	registry.register({ id: ' z ', label: 'Zulu', description: '產品說明', icon: h('span', { 'data-product-icon': true }, '*'), handler: () => {}, isChecked: () => true });
	registry.register({ id: 'a', label: 'Alpha', handler: () => {} });
	for (const kind of kinds) {
		const props = { registry, items: [{ commandId: ' z ', kind: 'toggle' }, { commandId: 'missing' }, { commandId: 'a' }], id: 'host', className: 'product-host', style: { maxWidth: 320 } };
		const dom = new JSDOM(renderToString(view(entry(kind, props))));
		const host = dom.window.document.querySelector('#host'), buttons = rows(host);
		assert.equal(host.getAttribute('role'), kind); assert.equal(host.getAttribute('aria-label'), kind);
		assert.ok(host.classList.contains('product-host')); assert.equal(host.style.maxWidth, '320px');
		assert.deepEqual(buttons.map(button => button.textContent.includes('Zulu') ? 'Zulu' : 'Alpha'), ['Zulu', 'Alpha']);
		assert.equal(buttons[0].getAttribute(kind === 'menu' ? 'aria-checked' : 'aria-pressed'), 'true');
		assert.equal(buttons[1].hasAttribute(kind === 'menu' ? 'aria-checked' : 'aria-pressed'), false);
		assert.ok(host.querySelector('[data-product-icon]'));
		if (kind === 'menu') { assert.equal(buttons[0].getAttribute('role'), 'menuitemcheckbox'); assert.equal(buttons[1].getAttribute('role'), 'menuitem'); assert.ok(host.textContent.includes('產品說明')); }
		dom.window.close();
		for (const items of [[{ commandId: ' ' }], [{ commandId: 'a', kind: 'other' }], [{ commandId: 'a' }, { commandId: 'a' }]]) assert.throws(() => renderToString(view(entry(kind, { ...props, items }))), TypeError);
		assert.throws(() => renderToString(view(entry(kind, { ...props, label: ' ' }))), TypeError);
		if (kind === 'menu') assert.throws(() => renderToString(view(entry(kind, { ...props, emptyLabel: ' ' }))), TypeError);
	}
});

test('兩入口同步 checked／visible／enabled／refresh／unregister／dispose，條件錯誤不呈現', async t => {
	const f = await fixture(t), registry = new klp.KlpCommandRegistry();
	let context = { visible: true, enabled: true, checked: false };
	const remove = registry.register({ id: 'state', label: 'State', handler: () => {}, isVisible: c => c.visible, isEnabled: c => c.enabled, isChecked: c => c.checked });
	registry.register({ id: 'invalid', label: 'Invalid', handler: () => assert.fail('條件錯誤不得執行'), isEnabled: () => { throw undefined; } });
	const items = [{ commandId: 'invalid' }, { commandId: 'missing' }, { commandId: 'state', kind: 'toggle' }];
	await f.render(h('main', null, ...kinds.map(kind => entry(kind, { key: kind, registry, items, getContext: () => context }))));
	const hosts = () => kinds.map(kind => f.mount.querySelector(`[role="${kind}"]`));
	for (const [index, host] of hosts().entries()) { assert.equal(rows(host).length, 1); assert.equal(row(host, 'State').getAttribute(index ? 'aria-checked' : 'aria-pressed'), 'false'); }
	context = { visible: true, enabled: false, checked: true }; await f.settle(() => registry.refresh());
	for (const [index, host] of hosts().entries()) { assert.equal(row(host, 'State').disabled, true); assert.equal(row(host, 'State').getAttribute(index ? 'aria-checked' : 'aria-pressed'), 'true'); }
	context.visible = false; await f.settle(() => registry.refresh());
	for (const host of hosts()) assert.equal(rows(host).length, 0);
	context.visible = true; context.enabled = true; await f.settle(() => registry.refresh());
	await f.settle(remove); for (const host of hosts()) assert.equal(rows(host).length, 0);
	await f.settle(() => registry.register({ id: 'state', label: 'New owner', handler: () => {} }));
	for (const host of hosts()) assert.ok(row(host, 'New owner'));
	await f.settle(() => registry.dispose()); for (const host of hosts()) assert.equal(rows(host).length, 0);
});

test('activation 使用最新 context 且不可繞過 gates，原 value／error 與最新 callback 保留', async t => {
	const f = await fixture(t);
	for (const kind of kinds) {
		const registry = new klp.KlpCommandRegistry(), pending = deferred(), original = [], latest = [], value = { product: [] }, reason = { error: '產品錯誤' };
		let context = { allowed: true, visible: true, value: 1 }, calls = [];
		registry.register({ id: 'run', label: 'Run', isVisible: c => c.visible, isEnabled: c => c.allowed, handler: c => { calls.push(c); return pending.promise; } });
		registry.register({ id: 'error', label: 'Error', handler: () => { throw reason; } });
		registry.register({ id: 'reject', label: 'Rejected', handler: () => Promise.reject(reason) });
		registry.register({ id: 'context', label: 'Context', handler: c => c });
		const props = { registry, items: [{ commandId: 'run' }, { commandId: 'error' }, { commandId: 'reject' }, { commandId: 'context' }], getContext: () => context, onResult: result => original.push(result) };
		await f.render(entry(kind, props));
		context = { allowed: false, visible: true, value: 2 }; await f.click(row(f.mount, 'Run')); assert.equal(calls.length, 0);
		context = { allowed: true, visible: true, value: 3 }; await f.render(entry(kind, props));
		context.visible = false; await f.click(row(f.mount, 'Run')); assert.equal(calls.length, 0);
		await f.render(entry(kind, props));
		assert.equal(rows(f.mount).some(button => button.textContent.includes('Run')), false);
		context = { allowed: true, visible: true, value: 4 }; await f.render(entry(kind, props));
		await f.click(row(f.mount, 'Run')); assert.equal(calls.length, 1); assert.equal(calls[0], context);
		await f.render(entry(kind, { ...props, getContext: () => ({ allowed: true, visible: true, value: 5 }), onResult: result => latest.push(result) }));
		await f.settle(() => pending.resolve(value));
		assert.equal(latest.length, 1); assert.equal(latest[0].status, 'executed'); assert.equal(latest[0].value, value); assert.equal(Object.isFrozen(value), false);
		await f.click(row(f.mount, 'Error')); assert.equal(latest.length, 2); assert.equal(latest[1].status, 'error'); assert.equal(latest[1].phase, 'handler'); assert.equal(latest[1].error, reason);
		await f.click(row(f.mount, 'Rejected')); assert.equal(latest[2].error, reason); assert.equal(latest[2].phase, 'handler');
		await f.click(row(f.mount, 'Context')); assert.equal(latest[3].value.value, 5, '替換後的 getContext 供下一次 activation 使用');
		assert.equal(original.some(result => result.status === 'executed'), false);
	}
});

test('pending 由共享 registry 擁有且同宿主其他命令可執行，解除 token 後原結果仍交宿主', async t => {
	const f = await fixture(t), registry = new klp.KlpCommandRegistry(), pending = deferred(), results = [[], []];
	let calls = 0, others = 0;
	const remove = registry.register({ id: 'run', label: 'Run', handler: () => { calls++; return pending.promise; } });
	registry.register({ id: 'other', label: 'Other', handler: () => { others++; return 'other'; } });
	const items = [{ commandId: 'run' }, { commandId: 'other' }];
	await f.render(h(React.StrictMode, null, h('main', null, ...kinds.map((kind, index) => entry(kind, { key: kind, registry, items, onResult: result => results[index].push(result) })))));
	const hosts = kinds.map(kind => f.mount.querySelector(`[role="${kind}"]`));
	await f.click(row(hosts[0], 'Run'));
	for (const host of hosts) { assert.equal(row(host, 'Run').disabled, true); assert.equal(row(host, 'Other').disabled, false); }
	await f.click(row(hosts[1], 'Run')); await f.key(row(hosts[0], 'Run'), 'Enter'); assert.equal(calls, 1);
	await f.click(row(hosts[0], 'Other')); assert.equal(others, 1); assert.equal(results[0][0].value, 'other');
	await f.click(row(hosts[1], 'Other')); assert.equal(others, 2); assert.equal(results[1][0].value, 'other');
	await f.settle(remove); await f.settle(() => registry.register({ id: 'run', label: 'Replacement', handler: () => 'new' }));
	for (const host of hosts) assert.equal(row(host, 'Replacement').disabled, false);
	await f.settle(() => pending.resolve('original'));
	assert.deepEqual(results[0].map(result => result.value), ['other', 'original']); assert.equal(results[1].length, 1);
	assert.equal(registry.getState('run', {}).running, false);
});

test('unmount 或 registry replacement 隔離舊結果，不回新 owner', async t => {
	for (const kind of kinds) for (const change of ['unmount', 'registry']) {
		await t.test(`${kind} ${change}`, async sub => {
		const f = await fixture(sub), registry = new klp.KlpCommandRegistry(), pending = deferred(), oldResults = [], newResults = [];
		registry.register({ id: 'run', label: 'Run', handler: () => pending.promise });
		const props = { registry, items: [{ commandId: 'run' }], onResult: result => oldResults.push(result) };
		await f.render(entry(kind, props)); await f.click(row(f.mount, 'Run'));
		if (change === 'unmount') await f.unmount();
		else {
			const replacement = new klp.KlpCommandRegistry(); replacement.register({ id: 'run', label: 'New', handler: () => 'new' });
			await f.render(entry(kind, { ...props, registry: replacement, onResult: result => newResults.push(result) }));
			await f.click(row(f.mount, 'New')); assert.equal(newResults.length, 1);
		}
		await f.settle(() => pending.resolve('stale'));
		assert.equal(oldResults.length, 0); assert.equal(newResults.some(result => result.value === 'stale'), false);
		});
	}
});

test('原生 roving enabled 索引／方向／Home／End／一次 Enter Space／Escape 及空 menu focus', async t => {
	const f = await fixture(t);
	for (const kind of kinds) {
		const registry = new klp.KlpCommandRegistry(), results = [];
		for (const id of ['A', 'Disabled', 'B']) registry.register({ id, label: id, handler: () => id, isEnabled: () => id !== 'Disabled' });
		let dismissed = 0;
		await f.render(entry(kind, { registry, items: ['A', 'Disabled', 'B'].map(commandId => ({ commandId })), onResult: result => results.push(result), onDismiss: () => dismissed++ }));
		assert.equal(row(f.mount, 'A').tabIndex, 0); assert.equal(row(f.mount, 'B').tabIndex, -1); assert.equal(row(f.mount, 'Disabled').disabled, true); assert.equal(row(f.mount, 'Disabled').tabIndex, -1);
		const forward = kind === 'toolbar' ? 'ArrowRight' : 'ArrowDown', back = kind === 'toolbar' ? 'ArrowLeft' : 'ArrowUp';
		for (const [from, key, target] of [['A', forward, 'B'], ['B', forward, 'A'], ['A', back, 'B'], ['B', 'Home', 'A'], ['A', 'End', 'B']]) {
			await f.key(row(f.mount, from), key); assert.equal(f.win.document.activeElement, row(f.mount, target));
			assert.equal(row(f.mount, target).tabIndex, 0); assert.equal(row(f.mount, target === 'A' ? 'B' : 'A').tabIndex, -1);
		}
		for (const key of ['Enter', ' ']) { const before = results.length; const event = await f.key(row(f.mount, 'B'), key); assert.equal(event.defaultPrevented, true, '防止 native default 重複激活'); assert.equal(results.length, before + 1, `${key} 只執行一次`); }
		await f.key(row(f.mount, 'B'), 'Escape'); assert.equal(dismissed, kind === 'menu' ? 1 : 0);
	}
	const registry = new klp.KlpCommandRegistry(); registry.register({ id: 'disabled', label: 'Disabled', handler: () => {}, isEnabled: () => false }); registry.register({ id: 'usable', label: 'Usable', handler: () => {} });
	await f.render(null); const outside = f.win.document.querySelector('#outside'); outside.focus();
	await f.render(entry('menu', { registry, items: [{ commandId: 'usable' }] })); assert.equal(f.win.document.activeElement, outside, 'autoFocus 缺省不偷焦點');
	await f.render(null); await f.render(entry('menu', { registry, items: [{ commandId: 'disabled' }, { commandId: 'usable' }], autoFocus: true })); assert.equal(f.win.document.activeElement, row(f.mount, 'Usable'));
	await f.render(null); await f.render(entry('menu', { registry, items: [{ commandId: 'missing' }], autoFocus: true }));
	const menu = f.mount.querySelector('[role="menu"]'); assert.equal(f.win.document.activeElement, menu); assert.ok(menu.textContent.includes('無命令')); assert.equal(rows(menu).length, 0);
	for (const key of ['ArrowDown', 'Home', 'End', 'Enter', ' ']) await f.key(menu, key);
	assert.equal(f.win.document.activeElement, menu);
});

test('onResult 自身錯誤交宿主 error 通道', async t => {
	const f = await fixture(t), errors = [], reason = { callback: 'error' }, previous = Object.getOwnPropertyDescriptor(globalThis, 'reportError');
	Object.defineProperty(globalThis, 'reportError', { configurable: true, writable: true, value: error => errors.push(error) }); f.win.reportError = error => errors.push(error);
	try {
		for (const kind of kinds) {
			const registry = new klp.KlpCommandRegistry(); registry.register({ id: 'a', label: 'Action', handler: () => 'value' });
			await f.render(entry(kind, { registry, items: [{ commandId: 'a' }], onResult: () => { throw reason; } })); await f.click(row(f.mount, 'Action'));
			assert.equal(errors.pop(), reason); assert.equal(row(f.mount, 'Action').disabled, false);
		}
		assert.equal(errors.length, 0);
	} finally { if (previous) Object.defineProperty(globalThis, 'reportError', previous); else delete globalThis.reportError; }
});

test('公開 generic props／references／原生宿主型別可由 consumer 編譯', () => {
	// ignored typed fixture 由 Test Author 擁有，不修改產品或編譯設定。
	const directory = fileURLToPath(new URL('../build/consumers/', import.meta.url)), filename = fileURLToPath(new URL('../build/consumers/command-entries.mts', import.meta.url));
	mkdirSync(directory, { recursive: true });
	writeFileSync(filename, `import React from 'react';
import { KlpCommandRegistry, KlpRegisteredCommandToolbar, KlpRegisteredCommandMenu, type KlpCommandReference, type KlpRegisteredCommandToolbarProps, type KlpRegisteredCommandMenuProps, type KlpCommandExecutionResult } from '../../dist/index.js';
type Context = { selection: string };
const registry = new KlpCommandRegistry<Context>();
registry.register({ id: 'save', label: 'Save', handler: context => context.selection });
const items: readonly KlpCommandReference[] = [{ commandId: 'save', kind: 'toggle' }];
const toolbar: KlpRegisteredCommandToolbarProps<Context> = { registry, items, label: 'Commands', getContext: () => ({ selection: 'current' }), onResult: result => { const typed: KlpCommandExecutionResult = result; void typed; }, id: 'toolbar', className: 'product', style: { maxWidth: 300 } };
const menu: KlpRegisteredCommandMenuProps<Context> = { ...toolbar, emptyLabel: 'Empty', autoFocus: true, onDismiss: () => {} };
React.createElement(KlpRegisteredCommandToolbar<Context>, toolbar);
React.createElement(KlpRegisteredCommandMenu<Context>, menu);
// @ts-expect-error reference kind 不可接受任意字串。
const invalid: KlpCommandReference = { commandId: 'save', kind: 'submenu' };
void invalid;
`);
	const result = spawnSync(process.execPath, [fileURLToPath(new URL('../node_modules/typescript/bin/tsc', import.meta.url)), '--ignoreConfig', '--strict', '--skipLibCheck', '--target', 'ES2022', '--module', 'NodeNext', '--moduleResolution', 'NodeNext', '--noEmit', filename], { encoding: 'utf8' });
	assert.equal(result.error, undefined); assert.equal(result.status, 0, `缺公開元件／型別是 compile Yellow，非 behavior Red\n${result.stdout}\n${result.stderr}`);
});
