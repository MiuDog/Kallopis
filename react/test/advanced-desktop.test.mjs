import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';

const h = React.createElement;

// 僅使用公開元件、受控參數與 DOM 事件，不模擬瀏覽器原生浮層成功。
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
		key: (node, key) => act(() => node.dispatchEvent(new dom.window.KeyboardEvent('keydown', { key, bubbles: true }))),
	};
}

test('Tree 展開與選取受控，方向鍵可進入子項且 disabled 不回呼', async t => {
	const { document, render, key } = await mount(t);
	const selected = [];
	const toggled = [];
	const items = [
		{ id: 'parent', label: '父項', children: [{ id: 'child', label: '子項' }] },
		{ id: 'disabled', label: '停用', disabled: true, children: [{ id: 'hidden', label: '隱藏' }] },
	];
	const view = expandedIds => h(klp.KlpTree, { label: '樹', items, expandedIds, selectedId: 'parent', onSelect: id => selected.push(id), onToggle: id => toggled.push(id) });
	const item = label => [...document.querySelectorAll('[role="treeitem"]')].find(node => node.textContent.includes(label));
	await render(view([]));
	assert.equal(item('子項'), undefined);
	await act(() => item('父項').focus());
	await key(item('父項'), 'ArrowRight');
	assert.deepEqual(toggled, ['parent']);
	assert.equal(item('父項').getAttribute('aria-expanded'), 'false', '展開 callback 不得覆寫 consumer 狀態');
	await render(view(['parent']));
	assert.equal(item('父項').getAttribute('aria-expanded'), 'true');
	await key(item('父項'), 'ArrowRight');
	assert.equal(document.activeElement, item('子項'), '向右應進入已展開的子項');
	await key(item('子項'), 'Enter');
	assert.deepEqual(selected, ['child']);
	assert.equal(item('父項').getAttribute('aria-selected'), 'true');
	await key(item('子項'), 'ArrowLeft');
	assert.equal(document.activeElement, item('父項'), '向左應回到父項');
	await act(() => item('停用').click());
	await key(item('停用'), 'Enter');
	await key(item('停用'), 'ArrowRight');
	assert.deepEqual(selected, ['child']);
	assert.deepEqual(toggled, ['parent']);
});

test('VirtualList 不全量呈現，End / Enter 能選取末項，disabled 不選取', async t => {
	const { document, render, key } = await mount(t);
	const changes = [];
	const items = Array.from({ length: 1000 }, (_, index) => ({ id: String(index), label: `資料 ${index}`, disabled: index === 0 }));
	await render(h(klp.KlpVirtualList, { label: '大量資料', items, height: 160, rowHeight: 32, selectedId: '1', onSelect: id => changes.push(id) }));
	const list = document.querySelector('[role="listbox"]');
	assert.ok(list, '清單需提供可及性操作入口');
	const options = () => [...document.querySelectorAll('[role="option"]')];
	assert.ok(options().length > 0 && options().length < 1000, '固定高度視窗不得掛載全部千筆');
	const disabled = options().find(node => node.textContent === '資料 0');
	assert.ok(disabled);
	await act(() => disabled.click());
	assert.deepEqual(changes, []);
	await act(() => list.focus());
	await key(list, 'End');
	await key(list, 'Enter');
	assert.deepEqual(changes, ['999'], '未在初始視窗的末項仍須可鍵盤選取');
	assert.ok(options().length < 1000);
	await key(list, 'Home');
	await key(list, 'Enter');
	assert.ok(changes.every(id => id !== '0'), 'Home 後不得選取 disabled 首項');
});

test('MultiSelect 受控增加移除，選項及整組 disabled 不變更值', async t => {
	const { document, render } = await mount(t);
	const changes = [];
	const options = [{ value: 'a', label: '甲' }, { value: 'b', label: '乙' }, { value: 'c', label: '丙', disabled: true }];
	const view = (value, disabled = false) => h(klp.KlpMultiSelect, { label: '多選', options, value, disabled, onValueChange: values => changes.push(values) });
	const checks = () => [...document.querySelectorAll('input[type="checkbox"]')];
	await render(view(['a']));
	assert.equal(checks().length, 3);
	await act(() => checks()[1].click());
	assert.deepEqual(changes, [['a', 'b']]);
	assert.equal(checks()[1].checked, false, 'consumer 未更新前不得自行選取');
	await render(view(['a', 'b']));
	await act(() => checks()[0].click());
	assert.deepEqual(changes.at(-1), ['b']);
	assert.equal(checks()[0].checked, true, 'consumer 未更新前不得自行移除');
	await act(() => checks()[2].click());
	assert.equal(changes.length, 2);
	await render(view(['b'], true));
	for (const checkbox of checks()) await act(() => checkbox.click());
	assert.equal(changes.length, 2);
});

test('DataGrid 編輯回報 row / column / value，disabled 列不可編輯', async t => {
	const { window, document, render } = await mount(t);
	const changes = [];
	const columns = [{ key: 'name', label: '名稱', editable: true }, { key: 'kind', label: '種類' }];
	const rows = [{ id: 'one', values: { name: '原值', kind: '唯讀' } }, { id: 'locked', values: { name: '停用值', kind: '唯讀' }, disabled: true }];
	await render(h(klp.KlpDataGrid, { label: '資料表', columns, rows, onCellChange: (...args) => changes.push(args) }));
	const inputs = [...document.querySelectorAll('input')];
	const editable = inputs.find(node => node.value === '原值');
	assert.ok(editable, '可編輯儲存格應有輸入入口');
	await act(() => {
		Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set.call(editable, '新值');
		editable.dispatchEvent(new window.Event('input', { bubbles: true }));
	});
	assert.deepEqual(changes, [['one', 'name', '新值']]);
	const locked = inputs.find(node => node.value === '停用值');
	assert.ok(!locked || locked.disabled || locked.readOnly, '停用列不得提供可編輯控制');
	assert.ok(!inputs.some(node => node.value === '唯讀' && !node.disabled && !node.readOnly), '未標示 editable 的欄位不得可編輯');
});

test('SystemAction 明確觸發、pending 防重入、失敗後可重試且缺 callback 停用', async t => {
	const { document, render } = await mount(t);
	let calls = 0;
	let reject;
	const action = () => {
		calls++;
		return calls === 1 ? new Promise((resolve, fail) => { reject = fail; }) : Promise.resolve();
	};
	await render(h(klp.KlpSystemAction, { label: '宿主操作', onAction: action }));
	assert.equal(calls, 0, '掛載時不得呼叫宿主');
	const button = () => document.querySelector('button');
	await act(() => {
		button().click();
		button().click();
	});
	assert.equal(calls, 1, '同一次事件批次也不得重入');
	assert.equal(button().disabled, true);
	await act(async () => reject(new Error('宿主失敗')));
	assert.match(document.body.textContent, /宿主失敗/, '失敗必須對使用者可見');
	assert.equal(button().disabled, false, '失敗後應可重試');
	await act(async () => button().click());
	assert.equal(calls, 2);
	assert.doesNotMatch(document.body.textContent, /宿主失敗/, '成功重試應清除舊錯誤');
	await render(h(klp.KlpSystemAction, { label: '未連接宿主' }));
	assert.equal(button().disabled, true);
	await act(() => button().click());
	assert.equal(calls, 2);
});

test('TreeGrid 展開與選取受控、方向鍵移列，disabled 不選取或展開', async t => {
	const { document, render, key } = await mount(t);
	const selected = [];
	const toggled = [];
	const rows = [
		{ id: 'parent', label: '父列', cells: ['群組'], children: [{ id: 'child', label: '子列', cells: ['資料'] }] },
		{ id: 'disabled', label: '停用列', cells: ['停用'], disabled: true, children: [{ id: 'hidden', label: '隱藏列', cells: ['資料'] }] },
		{ id: 'last', label: '末列', cells: ['資料'] },
	];
	const view = (expandedIds, selectedId = 'parent') => h(klp.KlpTreeGrid, { label: '階層資料', columns: ['名稱', '類型'], rows, expandedIds, selectedId, onSelect: id => selected.push(id), onToggle: id => toggled.push(id) });
	const row = label => [...document.querySelectorAll('[role="row"], tr')].find(node => node.textContent.includes(label));
	await render(view([]));
	assert.ok(document.querySelector('[role="treegrid"]'));
	assert.equal(row('子列'), undefined);
	await act(() => row('父列').focus());
	await key(row('父列'), 'ArrowRight');
	assert.deepEqual(toggled, ['parent']);
	assert.equal(row('父列').getAttribute('aria-expanded'), 'false');
	assert.equal(row('子列'), undefined, 'consumer 更新前不得自行展開');
	await render(view(['parent']));
	assert.equal(row('父列').getAttribute('aria-expanded'), 'true');
	await key(row('父列'), 'ArrowRight');
	assert.equal(document.activeElement, row('子列'));
	await key(row('子列'), 'Enter');
	assert.deepEqual(selected, ['child']);
	assert.equal(row('父列').getAttribute('aria-selected'), 'true', 'consumer 更新前不得自行選取');
	await key(row('子列'), 'ArrowLeft');
	assert.equal(document.activeElement, row('父列'));
	await key(row('父列'), 'ArrowLeft');
	assert.deepEqual(toggled, ['parent', 'parent']);
	assert.equal(row('父列').getAttribute('aria-expanded'), 'true', 'consumer 更新前不得自行收合');
	await render(view(['parent'], 'child'));
	assert.equal(row('子列').getAttribute('aria-selected'), 'true');
	for (const [start, pressed, expected] of [
		['父列', 'ArrowDown', '子列'],
		['子列', 'ArrowUp', '父列'],
		['父列', 'End', '末列'],
		['末列', 'Home', '父列'],
	]) {
		await act(() => row(start).focus());
		await key(row(start), pressed);
		assert.equal(document.activeElement, row(expected), `${pressed} 應移到指定資料列`);
	}
	await key(row('末列'), ' ');
	assert.deepEqual(selected, ['child', 'last']);
	await act(() => row('停用列').click());
	await key(row('停用列'), 'Enter');
	await key(row('停用列'), ' ');
	await key(row('停用列'), 'ArrowRight');
	assert.deepEqual(selected, ['child', 'last']);
	assert.deepEqual(toggled, ['parent', 'parent']);
});
