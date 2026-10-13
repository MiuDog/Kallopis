import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';

const h = React.createElement;

function stylePack(inset = 8) {
	const semantics = {};
	for (const [name, value] of Object.entries({
		'theme.geometry.layout.dialogMaximumWidth': 'p(length-520)',
		'theme.components.menuPadding': 'p(length-520)',
		'theme.spacing.overlayItemGap': 'p(length-520)',
		'theme.spacing.iconSmall': 'p(length-520)',
		'theme.geometry.layout.overlayViewportInset': 'p(length-7)',
	})) {
		semantics[name] = Object.fromEntries(
			['light', 'dark', 'ultraDark', 'transparent'].map(mode => [mode, value]),
		);
	}
	return klp.applyKlpStyleOverrides(klp.createKlpStylePack(), {
		primitives: { 'length-520': 1000000, 'length-7': inset },
		semantics,
	});
}

async function fixture(t) {
	const dom = new JSDOM('<!doctype html><div id="mount"></div>', {
		url: 'http://localhost',
		pretendToBeVisual: true,
	});
	const win = dom.window;
	const previous = new Map();
	const observers = new Set();
	let viewport = { width: 1265, height: 705 };
	let root;
	// 此 harness 只提供原生觀察來源，不限制元件的訂閱數量或私有方法。
	class ResizeObserver {
		constructor(callback) {
			this.callback = callback;
			this.targets = new Set();
			observers.add(this);
		}
		observe(target) { this.targets.add(target); }
		unobserve(target) { this.targets.delete(target); }
		disconnect() { this.targets.clear(); observers.delete(this); }
	}
	win.ResizeObserver = ResizeObserver;
	Object.defineProperties(win.document.documentElement, {
		clientWidth: { configurable: true, get: () => viewport.width },
		clientHeight: { configurable: true, get: () => viewport.height },
	});
	Object.defineProperties(win, {
		innerWidth: { configurable: true, value: 1280, writable: true },
		innerHeight: { configurable: true, value: 720, writable: true },
	});
	for (const [name, value] of Object.entries({
		window: win,
		document: win.document,
		navigator: win.navigator,
		HTMLElement: win.HTMLElement,
		Element: win.Element,
		Node: win.Node,
		MutationObserver: win.MutationObserver,
		ResizeObserver,
		getComputedStyle: win.getComputedStyle.bind(win),
		IS_REACT_ACT_ENVIRONMENT: true,
	})) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	const client = await import('react-dom/client');
	t.after(async () => {
		if (root) await act(async () => root.unmount());
		win.close();
		for (const [name, descriptor] of previous) {
			if (descriptor) Object.defineProperty(globalThis, name, descriptor);
			else delete globalThis[name];
		}
	});
	const settle = callback => act(async () => {
		callback();
		await Promise.resolve();
	});
	return {
		win,
		settle,
		input: () => win.document.querySelector('[role="combobox"]'),
		dialog: () => win.document.querySelector('[role="dialog"]'),
		render: (props, pack = stylePack()) => act(async () => {
			root ??= client.createRoot(win.document.querySelector('#mount'));
			root.render(h(klp.KlpThemeProvider, { stylePack: pack },
				h(klp.KlpRegisteredCommandPalette, {
					open: true,
					label: '命令',
					searchLabel: '搜尋',
					emptyLabel: '無結果',
					getContext: () => ({}),
					onResult: () => {},
					onDismiss: () => {},
					...props,
				}),
			));
		}),
		resize: (size, source = 'window') => settle(() => {
			viewport = size;
			if (source === 'window') {
				win.innerWidth = size.width + 15;
				win.innerHeight = size.height + 15;
				win.dispatchEvent(new win.Event('resize'));
			} else {
				// 捲軸改變 client viewport 時，window inner 尺寸與 resize 事件可維持不變。
				for (const observer of observers) {
					const entries = [...observer.targets].map(target => ({
						target,
						contentRect: {
							x: 0, y: 0, top: 0, left: 0,
							width: size.width, height: size.height,
							right: size.width, bottom: size.height,
						},
					}));
					if (entries.length) observer.callback(entries, observer);
				}
			}
		}),
		query: value => settle(() => {
			const input = win.document.querySelector('[role="combobox"]');
			Object.getOwnPropertyDescriptor(win.HTMLInputElement.prototype, 'value').set.call(input, value);
			input.dispatchEvent(new win.Event('input', { bubbles: true }));
		}),
		key: key => settle(() => {
			win.document.querySelector('[role="combobox"]').dispatchEvent(
				new win.KeyboardEvent('keydown', { key, bubbles: true, cancelable: true }),
			);
		}),
	};
}

function registry() {
	const value = new klp.KlpCommandRegistry();
	for (const id of ['a', 'b']) value.register({
		id,
		label: `Keep ${id}`,
		icon: h('span', { 'aria-hidden': true }, '*'),
		handler: context => context,
	});
	return value;
}

function geometry(f) {
	const dialog = f.dialog();
	assert.ok(dialog, '開啟中的公開 dialog 必須存在');
	const values = {};
	for (const [dimension, variable, direct] of [
		['width', '--klp-palette-width', 'width'],
		['height', '--klp-palette-height', 'maxHeight'],
	]) {
		let node = dialog;
		let raw = '';
		while (node && !raw) {
			raw = node.style.getPropertyValue(variable);
			node = node.parentElement;
		}
		raw ||= dialog.style[direct];
		assert.match(raw, /^\d+(?:\.\d+)?px$/, `${dimension} 必須提供有限非負的公開 DOM 幾何值：${raw}`);
		values[dimension] = Number.parseFloat(raw);
	}
	return values;
}

function within(f, size, inset = 8) {
	const actual = geometry(f);
	const effectiveInset = Math.min(inset, size.width / 2, size.height / 2);
	assert.ok(actual.width <= size.width - 2 * effectiveInset,
		`panel 寬 ${actual.width} 必須扣除 document client viewport ${size.width} 的雙側 inset ${effectiveInset}`);
	assert.ok(actual.height <= size.height - 2 * effectiveInset,
		`panel 高 ${actual.height} 必須扣除 document client viewport ${size.height} 的雙側 inset ${effectiveInset}`);
	return actual;
}

function finiteStyles(f) {
	geometry(f);
	for (const node of f.win.document.body.querySelectorAll('[style]')) {
		assert.equal(/NaN|Infinity/.test(node.getAttribute('style')), false,
			'不合法 viewport 不得產生 NaN／Infinity style');
	}
}

test('含捲軸的 document client viewport 保留雙側 inset 與有限 panel 幾何', async t => {
	const f = await fixture(t);
	await f.render({ registry: registry() });
	within(f, { width: 1265, height: 705 });
	finiteStyles(f);
});

test('同 open session 原生 resize 更新窄小／增高 viewport，保留 query、active 與 latest context', async t => {
	const f = await fixture(t);
	let context = { version: 1 };
	const results = [];
	await f.render({
		registry: registry(),
		getContext: () => context,
		onResult: result => results.push(result),
	});
	await f.query('Keep');
	await f.key('ArrowDown');
	const active = f.input().getAttribute('aria-activedescendant');
	context = { version: 2 };
	await f.resize({ width: 120, height: 6 });
	const narrow = within(f, { width: 120, height: 6 });
	assert.equal(f.input().value, 'Keep');
	assert.equal(f.input().getAttribute('aria-activedescendant'), active);
	await f.resize({ width: 640, height: 900 });
	const larger = within(f, { width: 640, height: 900 });
	assert.ok(larger.width > narrow.width, 'viewport 增寬後 panel 幾何必須更新');
	assert.ok(larger.height > narrow.height, 'viewport 增高後 panel 可用高度必須更新');
	assert.equal(f.input().value, 'Keep');
	assert.equal(f.input().getAttribute('aria-activedescendant'), active);
	await f.key('Enter');
	assert.equal(results.length, 1);
	assert.equal(results[0].value, context, '尺寸更新後 activation 仍讀目前產品 context');
	finiteStyles(f);
});

test('client viewport 單獨改變可觀察更新，不依賴 window inner resize', async t => {
	const f = await fixture(t);
	await f.render({ registry: registry() });
	const before = geometry(f);
	await f.resize({ width: 600, height: 300 }, 'document');
	assert.equal(f.win.innerWidth, 1280);
	assert.equal(f.win.innerHeight, 720);
	const after = within(f, { width: 600, height: 300 });
	assert.ok(after.width < before.width, 'client viewport 變窄必須更新可觀察 panel 寬');
	assert.ok(after.height < before.height, 'client viewport 變矮必須更新可觀察 panel 高');
});

test('無 layout 或異常 viewport 的 fallback 保持有限非負幾何', async t => {
	const f = await fixture(t);
	await f.resize({ width: 0, height: 0 }, 'document');
	await f.render({ registry: registry() });
	finiteStyles(f);
	for (const value of [-1, Number.NaN, Number.POSITIVE_INFINITY]) {
		await f.resize({ width: value, height: value });
		finiteStyles(f);
	}
});
