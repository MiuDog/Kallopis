import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';

const h = React.createElement;

// 僅透過公開元件與真實 DOM 事件驗證受控契約。
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
	return { window: dom.window, document: dom.window.document, render: child => act(() => root.render(child)) };
}

test('Tabs 鍵盤跳過 disabled、保留受控選取，並隔離兩個實例的 panel 關聯', async t => {
	const { window, document, render } = await mount(t);
	const changes = [];
	const tabs = [
		{ id: 'before', label: '停用首項', content: '不可選', disabled: true },
		{ id: 'first', label: '第一頁', content: '第一頁內容' },
		{ id: 'middle', label: '停用中項', content: '不可選', disabled: true },
		{ id: 'last', label: '末頁', content: '末頁內容' },
		{ id: 'after', label: '停用尾項', content: '不可選', disabled: true },
	];
	const view = value => h('main', null,
		h(klp.KlpThemeProvider, null, h(klp.KlpTabs, { label: '主要頁籤', tabs, value, onValueChange: id => changes.push(id) })),
		h(klp.KlpThemeProvider, null, h(klp.KlpTabs, { label: '相鄰頁籤', tabs, value: 'first', onValueChange: () => assert.fail('不得呼叫另一實例') })));
	await render(view('first'));
	const lists = () => [...document.querySelectorAll('[role="tablist"]')];
	const tab = label => [...lists()[0].querySelectorAll('[role="tab"]')].find(node => node.textContent === label);
	const selected = list => list.querySelector('[role="tab"][aria-selected="true"]');
	for (const [start, key, expected] of [
		['第一頁', 'ArrowRight', 'last'],
		['末頁', 'ArrowLeft', 'first'],
		['第一頁', 'End', 'last'],
		['末頁', 'Home', 'first'],
	]) {
		await act(() => {
			tab(start).focus();
			tab(start).dispatchEvent(new window.KeyboardEvent('keydown', { key, bubbles: true }));
		});
		assert.equal(changes.at(-1), expected, `${key} 應略過停用項目`);
		assert.equal(selected(lists()[0]).textContent, '第一頁', 'callback 不得覆寫 consumer value');
	}
	assert.deepEqual(changes, ['last', 'first', 'last', 'first']);
	await act(() => tab('停用中項').click());
	assert.equal(changes.length, 4, 'disabled tab 不得回呼');
	await render(view('last'));
	assert.equal(selected(lists()[0]).textContent, '末頁');
	assert.equal(selected(lists()[1]).textContent, '第一頁', '相鄰 Provider 的選取應維持原值');
	const ids = [...document.querySelectorAll('[id]')].map(node => node.id);
	assert.equal(new Set(ids).size, ids.length, '相同資料 ID 的兩個實例不得產生重複 DOM ID');
	for (const list of lists()) {
		const active = selected(list);
		const panel = document.getElementById(active.getAttribute('aria-controls'));
		assert.equal(panel?.getAttribute('role'), 'tabpanel', '選取頁籤必須指向有效 panel');
		assert.equal(panel.getAttribute('aria-labelledby'), active.id);
		assert.equal(panel.textContent, active.textContent === '末頁' ? '末頁內容' : '第一頁內容');
	}
});

test('List 選取由 consumer 持有，disabled 項目不回呼', async t => {
	const { document, render } = await mount(t);
	const changes = [];
	const items = [{ id: 'one', title: '第一筆' }, { id: 'two', title: '第二筆' }, { id: 'disabled', title: '停用項目', disabled: true }];
	const view = selectedId => h(klp.KlpThemeProvider, null, h(klp.KlpList, { label: '資料', items, selectedId, onSelect: id => changes.push(id) }));
	const button = title => [...document.querySelectorAll('button')].find(node => node.textContent.trim() === title);
	const isSelected = node => node.getAttribute('aria-selected') ?? node.getAttribute('aria-pressed');
	await render(view('one'));
	await act(() => {
		button('停用項目').click();
		button('第二筆').click();
	});
	assert.deepEqual(changes, ['two']);
	assert.equal(isSelected(button('第一筆')), 'true', 'callback 不得自行覆寫 selectedId');
	await render(view('two'));
	assert.equal(isSelected(button('第二筆')), 'true');
	assert.notEqual(isSelected(button('第一筆')), 'true');
});

test('表單 label 關聯與 Select、TextArea、Checkbox、Switch 受控值', async t => {
	const { window, document, render } = await mount(t);
	const changes = [];
	const view = updated => h(klp.KlpThemeProvider, null,
		h(klp.KlpSelect, { label: '類別', value: updated ? 'b' : 'a', options: [{ value: 'a', label: '甲' }, { value: 'b', label: '乙' }], onChange: event => changes.push(['select', event.target.value]) }),
		h(klp.KlpTextArea, { label: '描述', value: updated ? '更新' : '原文', onChange: event => changes.push(['textarea', event.target.value]) }),
		h(klp.KlpCheckbox, { label: '同意', checked: updated, onChange: event => changes.push(['checkbox', event.target.checked]) }),
		h(klp.KlpSwitch, { label: '啟用', checked: updated, onChange: event => changes.push(['switch', event.target.checked]) }));
	await render(view(false));
	const controls = [...document.querySelectorAll('select, textarea, input')];
	assert.equal(controls.length, 4);
	for (const [index, label] of ['類別', '描述', '同意', '啟用'].entries()) {
		assert.ok([...controls[index].labels].some(node => node.textContent.trim() === label), `${label} 必須關聯到原生控制`);
	}
	const [select, textarea, checkbox, toggle] = controls;
	assert.equal(toggle.getAttribute('role'), 'switch');
	await act(() => {
		select.value = 'b';
		select.dispatchEvent(new window.Event('change', { bubbles: true }));
		Object.getOwnPropertyDescriptor(window.HTMLTextAreaElement.prototype, 'value').set.call(textarea, '輸入');
		textarea.dispatchEvent(new window.Event('input', { bubbles: true }));
		checkbox.click();
		toggle.click();
	});
	assert.deepEqual(changes, [['select', 'b'], ['textarea', '輸入'], ['checkbox', true], ['switch', true]]);
	assert.equal(select.value, 'a');
	assert.equal(textarea.value, '原文');
	assert.equal(checkbox.checked, false);
	assert.equal(toggle.checked, false);
	await render(view(true));
	assert.equal(select.value, 'b');
	assert.equal(textarea.value, '更新');
	assert.equal(checkbox.checked, true);
	assert.equal(toggle.checked, true);
});
