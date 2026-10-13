import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { renderToString } from 'react-dom/server';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';

const h = React.createElement;
const clone = value => structuredClone(value);
const tokens = klp.createKlpTheme();
const handle = Number.parseFloat(tokens['theme.geometry.layout.resizeHandleExtent']);
const snapshots = new WeakMap();
const policy = registry => registry.map(({ id, allowSide, allowBottom }) => ({ id, ...(allowSide === undefined ? {} : { allowSide }), ...(allowBottom === undefined ? {} : { allowBottom }) }));
function layout() {
	return {
		left: { axis: 'vertical', isVisible: true, extent: 160, groups: [{ id: 'left-group', panelIds: ['a', 'b'], activePanelId: 'a', mainAxisExtent: 100 }] },
		right: { axis: 'vertical', isVisible: true, extent: 120, groups: [{ id: 'right-group', panelIds: ['c'], activePanelId: 'c', mainAxisExtent: 120 }] },
		bottom: { axis: 'horizontal', isVisible: false, extent: 0, groups: [] },
	};
}
function panels(extra = {}) {
	return ['a', 'b', 'c', 'd', 'e'].map(id => ({ id, label: id.toUpperCase(), content: h('input', { id: `input-${id}`, defaultValue: `正文-${id}` }), ...extra[id] }));
}
function dock(props, pack) {
	if (props?.layout && !snapshots.has(props.layout)) snapshots.set(props.layout, clone(props.layout));
	return h(klp.KlpThemeProvider, { stylePack: pack }, h(klp.KlpDockLayout, {
		layout: layout(), panels: panels(), stage: h('input', { id: 'stage-input', defaultValue: '舞台' }),
		leftConstraints: { minExtent: 80 }, rightConstraints: { minExtent: 80 }, bottomConstraints: { minExtent: 32 },
		onLayoutChanged: () => {}, id: 'dock', ...props,
	}));
}
function tab(mount, id) {
	const node = [...mount.querySelectorAll('[role="tab"]')].find(node => node.textContent.trim() === id.toUpperCase() || node.getAttribute('aria-label') === id.toUpperCase());
	assert.ok(node, `${id} 必須有公開 tab`);
	return node;
}
function body(mount, id) {
	const node = mount.ownerDocument.getElementById(tab(mount, id).getAttribute('aria-controls'));
	assert.equal(node?.getAttribute('role'), 'tabpanel');
	return node;
}
const area = (mount, label) => mount.querySelector(`section[aria-label="${label}"]`);
const edge = (mount, label) => mount.querySelector(`button[aria-label="${label}"][aria-expanded]`);
const hidden = node => Boolean(node.closest('[hidden]'));
function point(node, fraction = 0.5) {
	const r = node.getBoundingClientRect();
	return { clientX: r.left + r.width * fraction, clientY: r.top + r.height / 2 };
}
function immutable(next, source, before) {
	assert.deepEqual(source, before, '不得修改 caller 保存 snapshot');
	assert.notEqual(next, source);
	assert.ok(Object.isFrozen(next));
	for (const value of Object.values(next)) {
		assert.ok(Object.isFrozen(value) && Object.isFrozen(value.groups));
		for (const group of value.groups) assert.ok(Object.isFrozen(group) && Object.isFrozen(group.panelIds));
	}
}
function committed(submitted, source, registry, action) {
	assert.equal(submitted.length, 1, '完成操作只通知一次；hover 不通知');
	assert.deepEqual(submitted[0], klp.applyKlpDockAction(source, policy(registry), action).layout);
	immutable(submitted[0], source, snapshots.get(source) ?? clone(source));
	assert.deepEqual(klp.restoreKlpDockLayout(klp.encodeKlpDockLayout(submitted[0]), policy(registry)).layout, submitted[0], '交易結果仍符合公開保存契約');
	return submitted[0];
}

// jsdom 沒有排版／DataTransfer／PointerEvent；只替代宿主能力，不建立另一份 Dock 幾何或 input 狀態。
async function fixture(t, { width = 600, height = 400, scale = 1 } = {}) {
	const dom = new JSDOM('<!doctype html><div id="mount"></div>', { url: 'http://localhost' });
	const win = dom.window, mount = win.document.querySelector('#mount');
	const previous = new Map(), observers = new Set(), box = { width, height, scale };
	class ResizeObserver {
		constructor(callback) { this.callback = callback; this.targets = new Set(); observers.add(this); }
		observe(target) { this.targets.add(target); }
		unobserve(target) { this.targets.delete(target); }
		disconnect() { this.targets.clear(); }
	}
	class PointerEvent extends win.MouseEvent {
		constructor(type, init = {}) {
			super(type, init);
			Object.defineProperties(this, { pointerId: { value: init.pointerId ?? 7 }, isPrimary: { value: init.isPrimary ?? true }, pointerType: { value: init.pointerType ?? 'mouse' } });
		}
	}
	class DataTransfer {
		constructor() { this.data = new Map(); this.dropEffect = 'none'; this.effectAllowed = 'all'; }
		setData(type, value) { this.data.set(type, String(value)); }
		getData(type) { return this.data.get(type) ?? ''; }
		clearData() { this.data.clear(); }
		setDragImage() {}
		get types() { return [...this.data.keys()]; }
	}
	win.ResizeObserver = ResizeObserver; win.PointerEvent = PointerEvent;
	const globals = { window: win, document: win.document, navigator: win.navigator, HTMLElement: win.HTMLElement, Element: win.Element, Node: win.Node, MutationObserver: win.MutationObserver, getComputedStyle: win.getComputedStyle.bind(win), ResizeObserver, PointerEvent, IS_REACT_ACT_ENVIRONMENT: true };
	for (const [name, value] of Object.entries(globals)) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	function size(node, axis, depth = 0) {
		if (!node || depth > 40) return 0;
		if (node === mount) return box[axis];
		const value = win.getComputedStyle(node)[axis];
		if (/^[\d.e+-]+px$/i.test(value)) return Number.parseFloat(value);
		const parentSize = size(node.parentElement, axis, depth + 1);
		return value.endsWith('%') ? parentSize * Number.parseFloat(value) / 100 : parentSize;
	}
	function origin(node) {
		if (!node || node === mount) return { left: 50, top: 30 };
		const parent = origin(node.parentElement), css = win.getComputedStyle(node);
		return { left: parent.left + (Number.parseFloat(css.left) || 0) * box.scale, top: parent.top + (Number.parseFloat(css.top) || 0) * box.scale };
	}
	win.HTMLElement.prototype.getBoundingClientRect = function () {
		let { left, top } = origin(this), width = size(this, 'width') * box.scale, height = size(this, 'height') * box.scale;
		if (this.getAttribute('role') === 'tab') {
			// 原生 tab 的自然寬度由 fixture 明確指定，左右半部命中不依產品私有樣式。
			const list = this.closest('[role="tablist"]'), index = [...list.querySelectorAll('[role="tab"]')].indexOf(this), r = list.getBoundingClientRect();
			left = r.left + index * 40 * box.scale; top = r.top; width = 40 * box.scale; height = r.height;
		}
		return { x: left, y: top, left, top, right: left + width, bottom: top + height, width, height, toJSON() { return this; } };
	};
	for (const [name, axis] of [['clientWidth', 'width'], ['clientHeight', 'height'], ['offsetWidth', 'width'], ['offsetHeight', 'height']]) Object.defineProperty(win.HTMLElement.prototype, name, { configurable: true, get() { return size(this, axis); } });
	const captures = new Map();
	win.HTMLElement.prototype.setPointerCapture = function (id) { captures.set(id, this); };
	win.HTMLElement.prototype.releasePointerCapture = function (id) { if (captures.get(id) === this) captures.delete(id); };
	win.HTMLElement.prototype.hasPointerCapture = function (id) { return captures.get(id) === this; };
	const { createRoot } = await import('react-dom/client');
	const root = createRoot(mount); let unmounted = false;
	const settle = callback => act(async () => { await callback(); await Promise.resolve(); });
	const unmount = async () => { if (!unmounted) { await settle(() => root.unmount()); unmounted = true; } };
	const dispatch = (node, event) => settle(() => node.dispatchEvent(event));
	const drag = async (node, type, coordinates, transfer = new DataTransfer()) => {
		const event = new win.MouseEvent(type, { bubbles: true, cancelable: true, ...coordinates });
		Object.defineProperty(event, 'dataTransfer', { value: transfer });
		await dispatch(node, event); return { event, transfer };
	};
	t.after(async () => {
		await unmount(); win.close();
		for (const [name, descriptor] of previous) { if (descriptor) Object.defineProperty(globalThis, name, descriptor); else delete globalThis[name]; }
	});
	return {
		mount, win, box, observers, unmount, settle, drag,
		render: view => settle(() => root.render(view)),
		pointer: (node, type, coordinates = {}) => dispatch(node, new PointerEvent(type, { bubbles: true, cancelable: true, button: 0, buttons: type === 'pointerup' || type === 'pointercancel' ? 0 : 1, ...coordinates })),
		click: (node, detail = 1) => dispatch(node, new win.MouseEvent('click', { bubbles: true, cancelable: true, detail, button: 0 })),
		escape: () => dispatch(win.document, new win.KeyboardEvent('keydown', { key: 'Escape', bubbles: true })),
		async resize(width, height) {
			box.width = width; box.height = height;
			await settle(() => { for (const observer of observers) if (observer.targets.size) observer.callback([...observer.targets].map(target => ({ target, contentRect: target.getBoundingClientRect() })), observer); win.dispatchEvent(new win.Event('resize')); });
		},
	};
}
async function start(f, id) { return (await f.drag(tab(f.mount, id), 'dragstart', point(tab(f.mount, id)))).transfer; }
async function resizeGesture(f, node, from, to) {
	await f.pointer(node, 'pointerdown', from);
	await f.pointer(f.win.document, 'pointermove', to);
	await f.pointer(f.win.document, 'pointerup', to);
}
async function drop(f, target, coordinates, transfer) {
	const hover = await f.drag(target, 'dragover', coordinates, transfer);
	await f.drag(target, 'drop', coordinates, transfer);
	await f.drag(f.win.document, 'dragend', coordinates, transfer);
	return hover.event;
}

test('HTML tab before／after 最終 index、active fallback、self no-op 與跨區受控保存', async t => {
	const f = await fixture(t), registry = panels();
	for (const [sourceId, targetId, fraction, destination] of [
		['b', 'a', 0.25, { kind: 'tab', area: 'left', groupId: 'left-group', index: 0 }],
		['a', 'b', 0.75, { kind: 'tab', area: 'left', groupId: 'left-group', index: 1 }],
		['b', 'c', 0.25, { kind: 'tab', area: 'right', groupId: 'right-group', index: 0 }],
	]) {
		const source = layout(), before = clone(source), submitted = [];
		await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }));
		assert.equal(tab(f.mount, sourceId).draggable, true, '可拖 tab 必須啟用原生 HTML draggable');
		const transfer = await start(f, sourceId), target = tab(f.mount, targetId);
		await f.drag(target, 'dragover', point(target, fraction), transfer);
		assert.equal(submitted.length, 0, 'hover 不提交');
		const event = await drop(f, target, point(target, fraction), transfer);
		assert.equal(event.defaultPrevented, true, '合法 tab drop 必須接受 HTML dragover');
		committed(submitted, source, registry, { type: 'move', panelId: sourceId, destination });
		assert.deepEqual(source, before);
		assert.equal(tab(f.mount, 'a').getAttribute('aria-selected'), 'true', '未採用 callback 前仍以 caller 呈現');
	}
	const submitted = [], source = layout();
	await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }));
	const transfer = await start(f, 'a'); await drop(f, tab(f.mount, 'a'), point(tab(f.mount, 'a'), 0.25), transfer);
	assert.equal(submitted.length, 0, 'active tab 原位置是 no-op');
	const list = tab(f.mount, 'b').closest('[role="tablist"]'), r = list.getBoundingClientRect();
	await drop(f, list, { clientX: r.right - 2, clientY: r.top + r.height / 2 }, await start(f, 'a'));
	committed(submitted, source, registry, { type: 'move', panelId: 'a', destination: { kind: 'tab', area: 'left', groupId: 'left-group', index: 1 } });
});

test('正文 split 使用新增 gutter 配額、atomic 一次保存；single-source 與不足兩 minimum 拒絕', async t => {
	const f = await fixture(t), source = layout(), registry = panels(), submitted = [];
	await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }));
	await drop(f, body(f.mount, 'c'), point(body(f.mount, 'c')), await start(f, 'b'));
	assert.equal(submitted.length, 1, 'split local batch 只通知一次');
	const next = submitted[0], groups = next.right.groups, extent = (400 - handle) / 2;
	assert.equal(groups.length, 2); assert.deepEqual(groups[0].panelIds, ['c']); assert.deepEqual(groups[1].panelIds, ['b']);
	assert.equal(groups[0].mainAxisExtent, extent); assert.equal(groups[1].mainAxisExtent, extent);
	assert.notEqual(groups[1].id, 'left-group'); assert.notEqual(groups[1].id, 'right-group');
	let expected = klp.applyKlpDockAction(source, policy(registry), { type: 'move', panelId: 'b', destination: { kind: 'group', area: 'right', groupId: groups[1].id, index: 1, extent } }).layout;
	expected = klp.applyKlpDockAction(expected, policy(registry), { type: 'resizeGroup', groupId: 'right-group', extent }).layout;
	assert.deepEqual(next, expected); immutable(next, source, layout());
	for (const [id, target, height] of [['c', 'c', 400], ['b', 'c', 64 + handle - 1]]) {
		submitted.length = 0; await f.resize(600, height); await f.render(dock({ layout: clone(source), panels: registry, onLayoutChanged: next => submitted.push(next) }));
		const event = await drop(f, body(f.mount, target), point(body(f.mount, target)), await start(f, id));
		assert.equal(event.defaultPrevented, false, 'single source 或不足新增 pair minimum 不是合法 target'); assert.equal(submitted.length, 0);
	}
});

test('Stage 中央不接 drop、空 Bottom 零偏好 create 以正 group extent 保存', async t => {
	const f = await fixture(t), source = layout(), registry = panels(), submitted = [];
	await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }));
	const stage = f.mount.querySelector('#stage-input').parentElement, r = stage.getBoundingClientRect();
	let event = await drop(f, stage, point(stage), await start(f, 'b'));
	assert.equal(event.defaultPrevented, false); assert.equal(submitted.length, 0);
	event = await drop(f, stage, { clientX: r.left + r.width / 2, clientY: r.bottom - 1 }, await start(f, 'b'));
	assert.equal(event.defaultPrevented, true); assert.equal(submitted.length, 1, 'empty Stage create 一次通知');
	const next = submitted[0], group = next.bottom.groups[0];
	assert.equal(next.bottom.extent, 32); assert.equal(next.bottom.isVisible, true); assert.deepEqual(group.panelIds, ['b']); assert.equal(group.activePanelId, 'b'); assert.ok(group.mainAxisExtent >= 120);
	let expected = klp.applyKlpDockAction(source, policy(registry), { type: 'move', panelId: 'b', destination: { kind: 'group', area: 'bottom', groupId: group.id, index: 0, extent: group.mainAxisExtent } }).layout;
	expected = klp.applyKlpDockAction(expected, policy(registry), { type: 'resizeArea', area: 'bottom', extent: 32 }).layout;
	assert.deepEqual(next, expected); immutable(next, source, layout());
});

test('hidden preview 只是 presentation：cancel／miss、成功原 extent、theme／尺寸與 input identity', async t => {
	const f = await fixture(t), source = layout(), registry = panels(), submitted = [];
	source.right.isVisible = false; source.right.extent = 235;
	const before = clone(source), draw = pack => f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }, pack));
	await draw(); const input = f.mount.querySelector('#input-c'); input.value = '未保存的正文';
	for (const ending of ['escape', 'miss', 'end']) {
		const transfer = await start(f, 'b'), root = f.mount.querySelector('#dock'), r = root.getBoundingClientRect();
		await f.drag(root, 'dragover', { clientX: r.right - 1, clientY: r.top + r.height / 2 }, transfer);
		assert.equal(hidden(area(f.mount, 'Right')), false, 'hidden 非空合法 edge hover 必須暫時展開');
		assert.equal(area(f.mount, 'Right').getBoundingClientRect().width, 80, 'preview 只取產品 minimum');
		assert.equal(submitted.length, 0); assert.deepEqual(source, before);
		await f.drag(root, 'dragleave', { clientX: r.left - 1, clientY: r.top }, transfer);
		assert.equal(hidden(area(f.mount, 'Right')), false, 'dragleave 只清 hint，preview 維持本次 session');
		await draw(klp.createKlpStylePack()); await f.resize(640, 420);
		assert.equal(hidden(area(f.mount, 'Right')), false, '相同 layout theme／尺寸重建保留 preview');
		assert.equal(f.mount.querySelector('#input-c'), input); assert.equal(input.value, '未保存的正文');
		if (ending === 'escape') await f.escape();
		else if (ending === 'miss') await f.drag(root, 'drop', { clientX: r.left - 10, clientY: r.top - 10 }, transfer);
		else await f.drag(f.win.document, 'dragend', point(root), transfer);
		assert.equal(hidden(area(f.mount, 'Right')), true); assert.equal(submitted.length, 0); assert.deepEqual(source, before);
	}
	{
		const transfer = await start(f, 'b'), root = f.mount.querySelector('#dock'), r = root.getBoundingClientRect();
		await f.drag(root, 'dragover', { clientX: r.right - 1, clientY: r.top + r.height / 2 }, transfer);
		assert.equal(hidden(area(f.mount, 'Right')), false);
		await f.render(dock({ layout: clone(source), panels: registry, onLayoutChanged: next => submitted.push(next) }));
		assert.equal(hidden(area(f.mount, 'Right')), true, '不同 layout identity 立即清 preview');
		await drop(f, tab(f.mount, 'c'), point(tab(f.mount, 'c')), transfer);
		assert.equal(submitted.length, 0, 'caller identity 替換取消舊 drag source');
		await draw();
	}
	const transfer = await start(f, 'b'), root = f.mount.querySelector('#dock'), r = root.getBoundingClientRect();
	await f.drag(root, 'dragover', { clientX: r.right - 1, clientY: r.top + r.height / 2 }, transfer);
	await drop(f, tab(f.mount, 'c'), point(tab(f.mount, 'c'), 0.75), transfer);
	const next = committed(submitted, source, registry, { type: 'move', panelId: 'b', destination: { kind: 'tab', area: 'right', groupId: 'right-group', index: 1 } });
	assert.equal(next.right.extent, 235, '不得把 preview minimum 保存為 extent'); assert.equal(next.right.isVisible, true);
	assert.equal(hidden(area(f.mount, 'Right')), true, '尚未採用 callback 時 session 已清除');
	assert.equal(f.mount.querySelector('#input-c'), input); assert.equal(input.value, '未保存的正文');
});

test('capability／external transfer／non-draggable／正文事件拒絕，caller 與 registry 替換取消 source', async t => {
	const f = await fixture(t), submitted = [];
	for (const kind of ['capability', 'external', 'locked', 'content', 'layout-replaced', 'registry-removed']) {
		let source = layout(), registry = panels(kind === 'locked' ? { b: { draggable: false } } : kind === 'capability' ? { b: { allowBottom: false } } : {});
		source.bottom = { axis: 'horizontal', isVisible: false, extent: 100, groups: [{ id: 'bottom-group', panelIds: ['d'], activePanelId: 'd', mainAxisExtent: 120 }] };
		const draw = () => f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }));
		await draw(); submitted.length = 0;
		let transfer;
		if (kind === 'external') transfer = (await f.drag(f.mount, 'dragover', {})).transfer;
		else if (kind === 'content') transfer = (await f.drag(f.mount.querySelector('#input-b'), 'dragstart', point(body(f.mount, 'b')))).transfer;
		else transfer = await start(f, 'b');
		transfer.setData('text/plain', 'b');
		if (kind === 'layout-replaced') { source = clone(source); await draw(); }
		if (kind === 'registry-removed') { source = klp.applyKlpDockAction(source, policy(registry), { type: 'close', panelId: 'b', approved: true }).layout; registry = registry.filter(panel => panel.id !== 'b'); await draw(); }
		const root = f.mount.querySelector('#dock'), r = root.getBoundingClientRect();
		await f.drag(root, 'dragover', { clientX: r.left + r.width / 2, clientY: r.bottom - 1 }, transfer);
		assert.equal(hidden(area(f.mount, 'Bottom')), true, `${kind} 不能開 preview`);
		await drop(f, root, { clientX: r.left + r.width / 2, clientY: r.bottom - 1 }, transfer);
		assert.equal(submitted.length, 0, `${kind} 不得提交`);
	}
	const source = layout(), registry = panels({ b: { allowSide: false } });
	source.left.groups[0].panelIds = ['a'];
	source.bottom = { axis: 'horizontal', isVisible: true, extent: 120, groups: [{ id: 'bottom-source', panelIds: ['b'], activePanelId: 'b', mainAxisExtent: 120 }] };
	await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }));
	const event = await drop(f, tab(f.mount, 'c'), point(tab(f.mount, 'c')), await start(f, 'b'));
	assert.equal(event.defaultPrevented, false, 'allowSide=false 不得移入 side'); assert.equal(submitted.length, 0);
});

test('area Pointer Events 延遲提交、左右／底方向、viewport clamp 與原生 scale 座標', async t => {
	const f = await fixture(t, { scale: 2 }), registry = panels();
	for (const [name, delta, expected] of [['Left', { clientX: 50 }, 210], ['Right', { clientX: -50 }, 170], ['Bottom', { clientY: -50 }, 150]]) {
		const source = layout(), submitted = []; source.bottom = { axis: 'horizontal', isVisible: true, extent: 100, groups: [{ id: 'bottom-group', panelIds: ['d'], activePanelId: 'd', mainAxisExtent: 120 }] };
		await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }));
		const node = edge(f.mount, name), p = point(node), moved = { clientX: p.clientX + (delta.clientX ?? 0) * 2, clientY: p.clientY + (delta.clientY ?? 0) * 2 };
		await f.pointer(node, 'pointerdown', p); await f.pointer(f.win.document, 'pointermove', moved);
		assert.equal(submitted.length, 0, 'pointermove 只預覽，不保存');
		await f.pointer(f.win.document, 'pointerup', moved);
		committed(submitted, source, registry, { type: 'resizeArea', area: name.toLowerCase(), extent: expected });
	}
	const source = layout(), submitted = [];
	await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next), leftConstraints: { minExtent: 80, maxExtent: 200 } }));
	let node = edge(f.mount, 'Left'), p = point(node); await resizeGesture(f, node, p, { ...p, clientX: p.clientX + 2000 });
	committed(submitted, source, registry, { type: 'resizeArea', area: 'left', extent: 200 });
	submitted.length = 0; await f.render(dock({ layout: clone(source), panels: registry, onLayoutChanged: next => submitted.push(next) }));
	node = edge(f.mount, 'Left'); p = point(node); await resizeGesture(f, node, p, { ...p, clientX: p.clientX + 2000 });
	committed(submitted, source, registry, { type: 'resizeArea', area: 'left', extent: 600 - 120 - 2 * handle });
});

test('collapse threshold 只寫 visibility、拖後 click 抑制與 keyboard click 保留', async t => {
	const f = await fixture(t), source = layout(), registry = panels(), submitted = [];
	await f.render(dock({ layout: source, panels: registry, collapseThresholds: { left: 60 }, onLayoutChanged: next => submitted.push(next) }));
	const node = edge(f.mount, 'Left'), p = point(node), moved = { ...p, clientX: p.clientX - 120 };
	await f.pointer(node, 'pointerdown', p); await f.pointer(f.win.document, 'pointermove', moved); await f.pointer(f.win.document, 'pointerup', moved);
	const next = committed(submitted, source, registry, { type: 'visibility', area: 'left', isVisible: false });
	assert.equal(next.left.extent, 160, 'collapse 保留偏好');
	await f.click(node, 1); assert.equal(submitted.length, 1, '拖後 pointer click 不得再次 toggle');
	await f.click(node, 0); assert.equal(submitted.length, 2, 'keyboard click 仍可 toggle');
	for (const value of [-1, Infinity, NaN]) assert.throws(() => renderToString(dock({ collapseThresholds: { left: value } })), TypeError, 'threshold 必須有限非負');
});

test('group separator resize 相鄰守恆、logical minimum clamp、其他偏好保留及不足 pair no-op', async t => {
	const f = await fixture(t), source = layout(), registry = panels(), submitted = [];
	source.left.groups = [source.left.groups[0], { id: 'middle-group', panelIds: ['d'], activePanelId: 'd', mainAxisExtent: 110 }, { id: 'last-group', panelIds: ['e'], activePanelId: 'e', mainAxisExtent: 999 }];
	for (const [delta, first, second] of [[20, 120, 90], [1000, 178, 32]]) {
		await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) })); submitted.length = 0;
		const node = [...f.mount.querySelectorAll('[role="separator"]')].find(node => /left-group/.test(node.getAttribute('aria-label')) && /middle-group/.test(node.getAttribute('aria-label')));
		assert.ok(node, '相鄰 group gutter 必須有可辨識 separator'); assert.equal(node.getAttribute('aria-orientation'), 'horizontal');
		const p = point(node), moved = { ...p, clientY: p.clientY + delta };
		await f.pointer(node, 'pointerdown', p); await f.pointer(f.win.document, 'pointermove', moved); assert.equal(submitted.length, 0); await f.pointer(f.win.document, 'pointerup', moved);
		assert.equal(submitted.length, 1); const next = submitted[0];
		assert.equal(next.left.groups[0].mainAxisExtent, first); assert.equal(next.left.groups[1].mainAxisExtent, second); assert.equal(first + second, 210);
		assert.equal(next.left.groups[2].mainAxisExtent, 999); immutable(next, source, snapshots.get(source));
	}
	await f.resize(600, 40); await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) })); submitted.length = 0;
	const separator = [...f.mount.querySelectorAll('[role="separator"]')].find(node => /left-group/.test(node.getAttribute('aria-label')) && /middle-group/.test(node.getAttribute('aria-label'))), p = point(separator);
	await resizeGesture(f, separator, p, { ...p, clientY: p.clientY + 30 }); assert.equal(submitted.length, 0, '不足2 logical minima 不保存退化 render 尺寸');
});

test('pointer cancel／Escape／caller 替換／nonprimary／multibutton／unmount 不提交或留下全域 source', async t => {
	const f = await fixture(t), registry = panels();
	for (const kind of ['cancel', 'escape', 'replace', 'nonprimary', 'multibutton', 'shortage']) {
		let source = layout(); const submitted = [];
		if (kind === 'shortage') await f.resize(100, 40); else await f.resize(600, 400);
		const draw = () => f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }));
		await draw(); const input = f.mount.querySelector('#input-a'); input.value = '編輯保留';
		const node = edge(f.mount, 'Left'), p = point(node), moved = { ...p, clientX: p.clientX + 30 };
		await f.pointer(node, 'pointerdown', { ...p, ...(kind === 'nonprimary' ? { isPrimary: false } : {}), ...(kind === 'multibutton' ? { buttons: 3 } : {}) });
		await f.pointer(f.win.document, 'pointermove', moved);
		if (kind === 'cancel') await f.pointer(f.win.document, 'pointercancel', moved);
		if (kind === 'escape') await f.escape();
		if (kind === 'replace') { source = clone(source); source.left.extent = 145; await draw(); }
		await f.pointer(f.win.document, 'pointerup', moved);
		assert.equal(submitted.length, 0, `${kind} 不得提交`); assert.equal(f.mount.querySelector('#input-a'), input); assert.equal(input.value, '編輯保留');
	}
	const submitted = [], source = layout(); await f.resize(600, 400); await f.render(dock({ layout: source, panels: registry, onLayoutChanged: next => submitted.push(next) }));
	const node = edge(f.mount, 'Left'), p = point(node); await f.pointer(node, 'pointerdown', p); await f.pointer(f.win.document, 'pointermove', { ...p, clientX: p.clientX + 20 });
	await f.unmount(); await f.pointer(f.win.document, 'pointerup', { ...p, clientX: p.clientX + 20 }); await f.drag(f.win.document, 'dragend', p);
	assert.equal(submitted.length, 0); assert.ok([...f.observers].every(observer => observer.targets.size === 0));
});
