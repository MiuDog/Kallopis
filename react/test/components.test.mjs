import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';
import { expectedTheme } from './source-contract.mjs';

const h = React.createElement;
function Probe({ name }) {
	const { mode, tokens, semantic } = klp.useKlp();
	assert.deepEqual(tokens, expectedTheme(mode));
	return h('output', { 'data-probe': name }, `${mode}:${semantic('theme.colors.app')}`);
}

test('公開入口包含全部已接受核心元件', () => {
	for (const name of ['KlpThemeProvider', 'KlpText', 'KlpSurface', 'KlpCard', 'KlpBadge', 'KlpButton', 'KlpIconButton', 'KlpTextField', 'KlpFrame', 'KlpWorkspace', 'KlpFileExplorer']) assert.ok(klp[name], `${name} 必須由公開 ESM 可達`);
});

test('Provider 預設 light；巢狀 scope 及相鄰 scope 隔離', () => {
	const markup = renderToStaticMarkup(h('main', null,
		h(klp.KlpThemeProvider, null,
			h(Probe, { name: 'before' }),
			h(klp.KlpThemeProvider, { mode: 'dark' }, h(Probe, { name: 'inner' })),
			h(Probe, { name: 'after' })),
		h(klp.KlpThemeProvider, { mode: 'transparent' }, h(Probe, { name: 'sibling' }))));
	const document = new JSDOM(markup).window.document;
	for (const [name, mode] of [['before', 'light'], ['inner', 'dark'], ['after', 'light'], ['sibling', 'transparent']]) assert.equal(document.querySelector(`[data-probe="${name}"]`).textContent, `${mode}:${expectedTheme(mode)['theme.colors.app']}`);
});

test('缺失 Provider 與未知 semantic 明確失敗', () => {
	assert.throws(() => renderToStaticMarkup(h(Probe, { name: 'outside' })), /provider|KlpThemeProvider|主題/i);
	function Unknown() {
		klp.useKlp().semantic('theme.missing.contract');
		return null;
	}
	assert.throws(() => renderToStaticMarkup(h(klp.KlpThemeProvider, null, h(Unknown))), /semantic|unknown|missing|語意|不存在|未定義/i);
});

test('輸入標籤關聯、IconButton accessible name 與 error／disabled 狀態', () => {
	const markup = renderToStaticMarkup(h(klp.KlpThemeProvider, null,
		h(klp.KlpTextField, { label: '標題', value: '內容', error: true, disabled: true, onChange() {} }),
		h(klp.KlpIconButton, { label: '新增筆記', disabled: true }, '+')));
	const document = new JSDOM(markup).window.document;
	const input = document.querySelector('input');
	assert.ok(input.id, 'input 必須有可被 label 參考的 ID');
	assert.equal(document.querySelector(`label[for="${input.id}"]`)?.textContent, '標題');
	assert.equal(input.value, '內容');
	assert.equal(input.disabled, true);
	assert.equal(input.getAttribute('aria-invalid'), 'true');
	const button = document.querySelector('button');
	assert.equal(button.getAttribute('aria-label'), '新增筆記');
	assert.equal(button.disabled, true);
});

// 真實 React DOM 觀察產品控制的狀態，不讀元件內部實作。
test('主題更新、原生輸入、按鈕 disabled 與 Explorer callbacks 維持受控契約', async t => {
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
	const toggles = [];
	const selections = [];
	const changes = [];
	let clicks = 0;
	const sections = [{ id: 'notes', label: '筆記', items: [{ id: 'first', label: '第一筆' }, { id: 'second', label: '第二筆' }] }];
	function view(mode, expandedIds, selectedId) {
		return h(klp.KlpThemeProvider, { mode },
			h(Probe, { name: 'live' }),
			h(klp.KlpTextField, { label: '名稱', value: '原值', onChange: event => changes.push(event.target.value) }),
			h(klp.KlpButton, { onClick: () => clicks++ }, '執行'),
			h(klp.KlpButton, { disabled: true, onClick: () => clicks++ }, '停用'),
			h(klp.KlpFileExplorer, { sections, expandedIds, selectedId, onToggle: id => toggles.push(id), onSelect: id => selections.push(id) }));
	}
	const document = dom.window.document;
	const byText = text => [...document.querySelectorAll('button')].find(button => button.textContent.trim() === text);
	await act(() => root.render(view('light', [], 'first')));
	assert.equal(byText('筆記').getAttribute('aria-expanded'), 'false');
	await act(() => byText('筆記').click());
	assert.deepEqual(toggles, ['notes']);
	assert.equal(byText('筆記').getAttribute('aria-expanded'), 'false', 'callback 不得自行改變 consumer 的 expandedIds');
	await act(() => root.render(view('dark', ['notes'], 'first')));
	assert.equal(document.querySelector('[data-probe="live"]').textContent, `dark:${expectedTheme('dark')['theme.colors.app']}`);
	assert.equal(byText('筆記').getAttribute('aria-expanded'), 'true');
	assert.equal(byText('第一筆').getAttribute('aria-selected') ?? byText('第一筆').getAttribute('aria-pressed'), 'true');
	await act(() => byText('第二筆').click());
	assert.deepEqual(selections, ['second']);
	assert.equal(byText('第一筆').getAttribute('aria-selected') ?? byText('第一筆').getAttribute('aria-pressed'), 'true', '選取 callback 不得自行覆寫 selectedId');
	await act(() => root.render(view('ultraDark', ['notes'], 'second')));
	assert.equal(byText('第二筆').getAttribute('aria-selected') ?? byText('第二筆').getAttribute('aria-pressed'), 'true');
	await act(() => {
		byText('執行').click();
		byText('停用').click();
	});
	assert.equal(clicks, 1, 'disabled button 不得觸發 callback');
	const input = document.querySelector('input');
	await act(() => {
		Object.getOwnPropertyDescriptor(dom.window.HTMLInputElement.prototype, 'value').set.call(input, '新值');
		input.dispatchEvent(new dom.window.Event('input', { bubbles: true }));
	});
	assert.deepEqual(changes, ['新值'], 'onChange 必須交回原生 React input event');
	assert.equal(input.value, '原值', '受控 input 仍由 consumer value 決定');
});
