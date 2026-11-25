import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';

const h = React.createElement;

// 僅觀察公開輸入與可及性契約，不替原生浮層安裝成功替身。
async function mount(t) {
	const dom = new JSDOM('<!doctype html><div id="root"></div>', { url: 'http://localhost' });
	const globals = { window: dom.window, document: dom.window.document, navigator: dom.window.navigator, HTMLElement: dom.window.HTMLElement, Node: dom.window.Node, IS_REACT_ACT_ENVIRONMENT: true };
	const previous = new Map();
	for (const [name, value] of Object.entries(globals)) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	const { createRoot } = await import('react-dom/client');
	const root = createRoot(dom.window.document.querySelector('#root'));
	t.after(async () => {
		await act(() => root.unmount());
		dom.window.close();
		for (const [name, descriptor] of previous) {
			if (descriptor) Object.defineProperty(globalThis, name, descriptor);
			else delete globalThis[name];
		}
	});
	return {
		window: dom.window,
		document: dom.window.document,
		render: child => act(() => root.render(h(klp.KlpThemeProvider, null, child))),
		key: (node, key, init = {}) => act(() => node.dispatchEvent(new dom.window.KeyboardEvent('keydown', { key, bubbles: true, ...init }))),
		input: (node, value) => act(() => {
			Object.getOwnPropertyDescriptor(dom.window.HTMLInputElement.prototype, 'value').set.call(node, value);
			node.dispatchEvent(new dom.window.Event('input', { bubbles: true }));
		}),
	};
}

test('ComboBox 自由文字使用原生 onChange，受控值由 consumer 持有', async t => {
	const { document, render, input } = await mount(t);
	const changes = [];
	const view = value => h(klp.KlpComboBox, { label: '名稱', name: 'name', options: ['Alpha', 'Beta'], value, onChange: event => changes.push([event.target.value, event.target.name, event.nativeEvent.type]) });
	await render(view(''));
	const control = document.querySelector('input[role="combobox"]');
	assert.ok(control);
	assert.ok([...control.labels].some(label => label.textContent.includes('名稱')));
	await input(control, '不在建議中的自由文字');
	assert.deepEqual(changes, [['不在建議中的自由文字', 'name', 'input']]);
	assert.equal(control.value, '', 'callback 不得覆寫 consumer value');
	await render(view('不在建議中的自由文字'));
	assert.equal(control.value, '不在建議中的自由文字');
});

test('ComboBox 方向鍵更新有效 active descendant，Enter 選取並發送原生輸入，Escape 關閉', async t => {
	const { document, render, key } = await mount(t);
	const changes = [];
	await render(h(klp.KlpComboBox, { label: '建議', options: ['Alpha', 'Beta', 'Gamma'], value: '', onChange: event => changes.push([event.target.value, event.nativeEvent.type]) }));
	const control = document.querySelector('[role="combobox"]');
	await act(() => control.focus());
	await key(control, 'ArrowDown');
	assert.equal(control.getAttribute('aria-expanded'), 'true');
	const list = document.getElementById(control.getAttribute('aria-controls'));
	assert.equal(list?.getAttribute('role'), 'listbox');
	const active = () => document.getElementById(control.getAttribute('aria-activedescendant'));
	const first = active();
	assert.equal(first?.getAttribute('role'), 'option');
	assert.ok(list.contains(first));
	await key(control, 'ArrowDown');
	assert.notEqual(active(), first, '方向鍵應改變作用建議');
	await key(control, 'ArrowUp');
	assert.equal(active(), first);
	const selected = active().textContent;
	await key(control, 'Enter');
	assert.deepEqual(changes, [[selected, 'input']]);
	assert.equal(control.value, '', '建議選取仍須等待 consumer 更新');
	assert.equal(control.getAttribute('aria-expanded'), 'false');
	await key(control, 'ArrowDown');
	await key(control, 'Escape');
	assert.equal(control.getAttribute('aria-expanded'), 'false');
	assert.equal(document.activeElement, control);
	assert.equal(changes.length, 1, 'Escape 不提交新值');
});

test('ComboBox disabled 與 readOnly 不開啟建議，IME Enter 不誤選', async t => {
	const { window, document, render, key } = await mount(t);
	const changes = [];
	const view = props => h(klp.KlpComboBox, { label: '輸入', options: ['甲', '乙'], value: '', onChange: event => changes.push(event.target.value), ...props });
	for (const props of [{ disabled: true }, { readOnly: true }]) {
		await render(view(props));
		const control = document.querySelector('[role="combobox"]');
		await act(() => { control.focus(); control.click(); });
		await key(control, 'ArrowDown');
		assert.notEqual(control.getAttribute('aria-expanded'), 'true');
		await key(control, 'Enter');
		assert.deepEqual(changes, []);
	}
	await render(view({}));
	const control = document.querySelector('[role="combobox"]');
	await key(control, 'ArrowDown');
	assert.equal(control.getAttribute('aria-expanded'), 'true');
	await act(() => control.dispatchEvent(new window.CompositionEvent('compositionstart', { bubbles: true })));
	await key(control, 'Enter', { isComposing: true, keyCode: 229 });
	assert.deepEqual(changes, [], '輸入法確認字詞不得提交建議');
	await act(() => control.dispatchEvent(new window.CompositionEvent('compositionend', { bubbles: true })));
});

test('相鄰 ComboBox 的 label、listbox 與 option ID 保持實例隔離', async t => {
	const { document, render, key } = await mount(t);
	await render(h('main', null, ...['第一個', '第二個'].map(label => h(klp.KlpComboBox, { key: label, label, options: ['Alpha', 'Beta'], value: '', onChange: () => {} }))));
	const controls = [...document.querySelectorAll('[role="combobox"]')];
	assert.equal(controls.length, 2);
	for (const control of controls) await key(control, 'ArrowDown');
	const ids = [...document.querySelectorAll('[id]')].map(node => node.id);
	assert.equal(new Set(ids).size, ids.length, '兩實例不得共用 DOM ID');
	const listIds = controls.map(control => control.getAttribute('aria-controls'));
	assert.equal(new Set(listIds).size, 2);
	for (const [index, control] of controls.entries()) {
		assert.ok([...control.labels].some(label => label.textContent.includes(index === 0 ? '第一個' : '第二個')));
		const list = document.getElementById(listIds[index]);
		assert.equal(list?.getAttribute('role'), 'listbox');
		const active = document.getElementById(control.getAttribute('aria-activedescendant'));
		assert.equal(active?.getAttribute('role'), 'option');
		assert.ok(list.contains(active), '作用建議只能屬於自己的 listbox');
	}
});
