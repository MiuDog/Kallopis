import assert from 'node:assert/strict';
import test from 'node:test';
import React, { act } from 'react';
import { renderToString } from 'react-dom/server';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';

const h = React.createElement;
const noop = () => {};

function host(keymap, children, extra = {}) {

	assert.equal(typeof klp.KlpCommandShortcutHost, 'function', '缺 public native host API 屬 Yellow，不能宣稱 behavior Red');
	const props = { /* keymap：借用唯一解析權威；getContext：事件當次產品資料；getFocus：產品焦點身分；onHandling／onResult：產品觀察出口；extra：案例回呼更新。 */ keymap, getContext: () => null, getFocus: () => ({ /* focusId：同 session 的產品焦點。 */ focusId: 'focus' }), onHandling: noop, onResult: noop, ...extra };
	return h(klp.KlpCommandShortcutHost, props, children);
}

function setup(extra = {}) {

	const registry = new klp.KlpCommandRegistry();
	const calls = [];
	const keymap = new klp.KlpCommandKeymap(registry, extra);
	function bind(id, sequence, options = {}) {

		// 透過公開 registry 記錄真正 dispatch，不鏡像 host 或 core 私有邏輯。
		registry.register({ /* id／label：產品命令身分；handler：記錄傳入 context 並保留原值。 */ id, label: id, handler: context => { calls.push([id, context]); return context; } });
		keymap.register({ /* id／commandId：共用身分；sequence：公開邏輯鍵；scope：本案例 app；options：repeat／editable 限制。 */ id, commandId: id, sequence, scope: 'app', ...options });
	}
	return { /* registry／keymap：實際公開協作者；calls：dispatch 證據；bind：案例註冊入口。 */ registry, keymap, calls, bind };
}

function stroke(key, extra = {}) {

	return { /* key：canonical logical key；extra：公開 modifiers。 */ key, ...extra };
}

function deferred() {

	let resolve;
	let reject;
	const promise = new Promise((yes, no) => { resolve = yes; reject = no; });
	return { /* promise：原產品非同步結果；resolve／reject：精確控制完成時刻與原錯誤。 */ promise, resolve, reject };
}

async function fixture(t) {

	// JSDOM 只驗證原生 DOM event 與 React 生命周期；不宣稱原生瀏覽器或感官接受。
	const dom = new JSDOM('<!doctype html><button id="outside">outside</button><div id="mount"></div>', { /* url：提供完整 document；pretendToBeVisual：React DOM 宿主環境。 */ url: 'http://localhost', pretendToBeVisual: true });
	const win = dom.window;
	const mount = win.document.querySelector('#mount');
	const previous = new Map();
	const errors = [];
	const globals = { /* window／document／navigator：DOM 環境；HTMLElement／Element／Node：native target 判定；reportError：宿主診斷出口；IS_REACT_ACT_ENVIRONMENT：明確 flush 邊界。 */ window: win, document: win.document, navigator: win.navigator, HTMLElement: win.HTMLElement, Element: win.Element, Node: win.Node, reportError: error => errors.push(error), IS_REACT_ACT_ENVIRONMENT: true };
	win.reportError = globals.reportError;
	for (const [name, value] of Object.entries(globals)) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { /* configurable／writable：測試可還原；value：本 fixture 平台物件。 */ configurable: true, writable: true, value });
	}

	// 動態載入 client，讓 React 先看到此 DOM，避免非 DOM 初始化影響 focus 事件。
	const client = await import('react-dom/client');
	let root = client.createRoot(mount);
	async function settle(callback = noop) {

		await act(async () => { callback(); await Promise.resolve(); });
	}
	async function render(child) {

		await settle(() => root.render(child));
	}
	async function key(node, value, init = {}) {

		const event = new win.KeyboardEvent('keydown', { /* key：logical 而非 code；bubbles／cancelable：原生攔截可觀察；init：modifier／IME／repeat 案例。 */ key: value, bubbles: true, cancelable: true, ...init });
		await settle(() => node.dispatchEvent(event));
		return event;
	}
	async function unmount() {

		if (!root) return;

		await settle(() => root.unmount());
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
	return { /* win／mount：native event 入口；errors：診斷證據；render／settle／key／unmount：受控 lifecycle 操作。 */ win, mount, errors, render, settle, key, unmount };
}

function clockFixture(f, t) {

	let now = 0;
	let serial = 0;
	const jobs = new Map();
	const previous = [];
	const nativeSchedule = globalThis.setTimeout;
	const nativeCancel = globalThis.clearTimeout;
	function schedule(callback, delay) {

		// JSDOM focus 另排零延遲 selectionchange；保留原生排程，避免誤算 chord timer。公開 chordTimeoutMs 必須正整數，所有非零期限仍受控。
		if (Number(delay) === 0) return nativeSchedule(callback, delay);

		const id = ++serial;
		jobs.set(id, { /* callback：原生 timeout 工作；due：單次期限毫秒。 */ callback, due: now + Number(delay) });
		return id;
	}
	function cancel(id) {

		if (jobs.delete(id)) return;

		nativeCancel(id);
	}
	for (const target of [globalThis, f.win]) {
		previous.push([target, target.setTimeout, target.clearTimeout]);
		target.setTimeout = schedule;
		target.clearTimeout = cancel;
	}
	async function advance(amount) {

		now += amount;
		await f.settle(() => {
			for (const [id, job] of [...jobs]) {
				if (job.due > now) continue;

				jobs.delete(id);
				job.callback();
			}
		});
	}
	t.after(() => { for (const [target, scheduleBefore, cancelBefore] of previous) { target.setTimeout = scheduleBefore; target.clearTimeout = cancelBefore; } });
	return { /* now：供公開 core 注入相同時鐘；advance：確定性推進 timeout；jobs：觀察單一 timer 與 cleanup。 */ now: () => now, advance, jobs };
}

async function nativeBubble(t) {

	const f = await fixture(t);
	const s = setup({ /* platform：明示 primary 投影，不猜 OS。 */ platform: 'mac' });
	s.bind('save', [stroke('s', { /* primary：mac 的 meta。 */ primary: true })]);
	s.bind('space', [stroke('space')]);
	s.bind('repeat', [stroke('arrowdown')], { /* allowRepeat：可明確執行 repeat。 */ allowRepeat: true });
	const handling = [];
	let parentEvents = 0;
	let focusReads = 0;
	let currentNative;
	const extra = { /* getFocus：defaultPrevented 不可讀產品資料；getContext：dispatch 當次值；onHandling：在 native 決定後觀察。 */ getFocus: () => { focusReads++; return { /* focusId：固定產品 owner。 */ focusId: 'focus' }; }, getContext: () => 'current', onHandling: value => { assert.equal(currentNative.defaultPrevented, value.handled); handling.push(value); } };
	const child = h('button', { /* id：native target；onKeyDown：descendant 優先處理並暴露原事件攔截時點。 */ id: 'key', onKeyDown: event => { currentNative = event.nativeEvent; if (event.key === 'blocked') event.preventDefault(); } }, 'key');
	await f.render(h('div', { /* onKeyDown：驗證 handled 不再向父層冒泡。 */ onKeyDown: () => parentEvents++ }, host(s.keymap, child, extra)));
	const node = f.win.document.querySelector('#key');
	await f.key(node, 'blocked');
	assert.equal(focusReads, 0);
	assert.equal(handling.length, 0);
	assert.equal((await f.key(node, 'S', { /* code：故意不同實體鍵；metaKey：native 平台旗標。 */ code: 'KeyQ', metaKey: true })).defaultPrevented, true);
	assert.deepEqual(s.calls, [['save', 'current']]);
	assert.equal(parentEvents, 1);
	assert.equal((await f.key(node, 's', { /* metaKey／altKey：多餘旗標拒絕。 */ metaKey: true, altKey: true })).defaultPrevented, false);
	assert.equal((await f.key(node, 's', { /* metaKey／repeat：預設 repeat 禁止。 */ metaKey: true, repeat: true })).defaultPrevented, false);
	assert.equal((await f.key(node, ' ', { /* code：space 仍依 key。 */ code: 'KeyZ' })).defaultPrevented, true);
	assert.equal((await f.key(node, 'ArrowDown', { /* repeat：公開允許的重複鍵。 */ repeat: true })).defaultPrevented, true);
	assert.deepEqual(s.calls.map(entry => entry[0]), ['save', 'space', 'repeat']);
	assert.ok(Object.isFrozen(handling[0]));
	assert.equal(handling.at(-1).state, 'executed');
	assert.equal(f.errors.length, 0);
}
test('native bubble／defaultPrevented／logical key／exact modifiers／repeat', nativeBubble);

async function innerAndNeutral(t) {

	const f = await fixture(t);
	const outer = setup();
	const inner = setup();
	outer.bind('outer', [stroke('x')]);
	inner.bind('inner', [stroke('x')]);
	const markup = renderToString(host(outer.keymap, h('button', null, 'child')));
	assert.match(markup, /display:contents/);
	assert.doesNotMatch(markup, /tabindex=|role=/i);
	await f.render(host(outer.keymap, host(inner.keymap, h('button', { /* id：嵌套宿主內原生 target。 */ id: 'inner' }, 'inner'))));
	await f.key(f.win.document.querySelector('#inner'), 'x');
	assert.equal(inner.calls.length, 1);
	assert.equal(outer.calls.length, 0);
	await f.key(f.win.document.querySelector('#outside'), 'x');
	assert.equal(inner.calls.length, 1, '不得接 document global keyboard listener');
	assert.equal(outer.calls.length, 0);
}
test('neutral SSR／inner handled 唯一 dispatch／root 外事件', innerAndNeutral);

async function textAndComposition(t) {

	const f = await fixture(t);
	const s = setup();
	s.bind('plain', [stroke('x')]);
	s.bind('editor', [stroke('y')], { /* allowInEditable：產品明示允許 editor 命令。 */ allowInEditable: true });
	s.bind('chord', [stroke('k'), stroke('c')]);
	let productEditable = false;
	const children = h('div', null, h('input', { /* id：原生單行文字。 */ id: 'input' }), h('textarea', { /* id：原生多行文字。 */ id: 'textarea' }), h('div', { /* id／contentEditable：有效祖先文字區。 */ id: 'editor', contentEditable: true, suppressContentEditableWarning: true }, h('span', { /* id：繼承 editable。 */ id: 'text' }, 'text'), h('span', { /* id／contentEditable：明示非文字子區。 */ id: 'false', contentEditable: false }, 'false')), h('button', { /* id：一般非文字 target。 */ id: 'button' }, 'button'));
	await f.render(host(s.keymap, children, { /* getFocus：product editable 與 native 做 OR。 */ getFocus: () => ({ /* focusId：同錄製 owner；editable：產品額外文字狀態。 */ focusId: 'focus', editable: productEditable }) }));
	for (const id of ['input', 'textarea', 'text']) assert.equal((await f.key(f.win.document.querySelector(`#${id}`), 'x')).defaultPrevented, false);
	assert.equal((await f.key(f.win.document.querySelector('#input'), 'y')).defaultPrevented, true);
	assert.equal((await f.key(f.win.document.querySelector('#false'), 'x')).defaultPrevented, true);
	productEditable = true;
	assert.equal((await f.key(f.win.document.querySelector('#button'), 'x')).defaultPrevented, false);
	productEditable = false;
	const node = f.win.document.querySelector('#button');
	await f.key(node, 'k');
	assert.equal(s.keymap.pendingSequence.length, 1);
	await f.settle(() => node.dispatchEvent(new f.win.CompositionEvent('compositionstart', { /* bubbles：原生 composition 到宿主。 */ bubbles: true })));
	assert.equal(s.keymap.pendingSequence.length, 0, 'compositionstart 即取消 prefix');
	s.keymap.beginRecording('focus');
	assert.equal((await f.key(node, 'x')).defaultPrevented, false);
	assert.equal(s.keymap.isRecording, true);
	await f.settle(() => node.dispatchEvent(new f.win.CompositionEvent('compositionend', { /* bubbles：清除 host session 組字。 */ bubbles: true })));
	assert.equal((await f.key(node, 'x', { /* isComposing：event 原生組字旗標。 */ isComposing: true })).defaultPrevented, false);
	assert.equal((await f.key(node, 'x', { /* keyCode：legacy IME 保護。 */ keyCode: 229 })).defaultPrevented, false);
	assert.equal(s.keymap.recordedSequence.length, 0);
	const before = s.calls.length;
	assert.equal((await f.key(f.win.document.querySelector('#input'), 'x')).defaultPrevented, true);
	assert.equal(s.calls.length, before, 'explicit recording 不得 dispatch');
	assert.deepEqual(s.keymap.finishRecording(), [stroke('x', { /* primary／ctrl／alt／shift／meta：錄製 actual modifier，無平台推測。 */ primary: false, ctrl: false, alt: false, shift: false, meta: false })]);
}
test('native editable OR product／false 子區／composition session＋event＋229／record 不 dispatch', textAndComposition);

async function timerAndFocus(t) {

	const f = await fixture(t);
	const clock = clockFixture(f, t);
	const s = setup({ /* now：測試自有 native clock；chordTimeoutMs：每步固定期限。 */ now: clock.now, chordTimeoutMs: 100 });
	s.bind('long', [stroke('k'), stroke('c'), stroke('x')]);
	const handling = [];
	const children = h('div', null, h('button', { /* id：第一 descendant。 */ id: 'a' }, 'a'), h('button', { /* id：第二 descendant。 */ id: 'b' }, 'b'));
	await f.render(host(s.keymap, children, { /* onHandling：timeout 不可虛構 event 通知。 */ onHandling: value => handling.push(value) }));
	const a = f.win.document.querySelector('#a');
	const b = f.win.document.querySelector('#b');
	await f.settle(() => a.focus());
	await f.key(a, 'k');
	assert.equal(clock.jobs.size, 1);
	await clock.advance(60);
	await f.key(a, 'Shift', { /* shiftKey：ignored modifier 不能延長期限。 */ shiftKey: true });
	assert.equal(clock.jobs.size, 1);
	await clock.advance(40);
	assert.equal(s.keymap.pendingSequence.length, 0);
	assert.equal(handling.length, 2);
	await f.key(a, 'k');
	await clock.advance(60);
	await f.key(a, 'c');
	assert.equal(clock.jobs.size, 1);
	await clock.advance(40);
	assert.equal(s.keymap.pendingSequence.length, 2, '合法新步重設自己的期限');
	await clock.advance(60);
	assert.equal(s.keymap.pendingSequence.length, 0);
	await f.key(a, 'k');
	s.keymap.beginRecording('focus');
	await f.settle(() => b.focus());
	assert.equal(s.keymap.isRecording, true, 'host 內 transition 保留 explicit recording');
	s.keymap.cancelRecording();
	await f.key(b, 'k');
	await f.settle(() => a.focus());
	assert.equal(s.keymap.pendingSequence.length, 0);
	assert.equal(clock.jobs.size, 0);
	s.keymap.beginRecording('focus');
	await f.settle(() => f.win.document.querySelector('#outside').focus());
	assert.equal(s.keymap.isRecording, false, '離開 host 取消 recording');
	assert.equal(s.calls.length, 0);
}
test('single native timer／ignored modifier deadline／new step deadline／內移焦及離開 cleanup', timerAndFocus);

async function lifetime(t) {

	const f = await fixture(t);
	const clock = clockFixture(f, t);
	const registry = new klp.KlpCommandRegistry();
	const keymap = new klp.KlpCommandKeymap(registry, { /* now／chordTimeoutMs：同 native timer 時鐘。 */ now: clock.now, chordTimeoutMs: 100 });
	const pending = [];
	registry.register({ /* id／label：唯一命令；handler：每次保留獨立原 promise。 */ id: 'run', label: 'run', handler: () => { const d = deferred(); pending.push(d); return d.promise; } });
	keymap.register({ /* id／commandId：同 registry；sequence：即時命令；scope：app。 */ id: 'run', commandId: 'run', sequence: [stroke('x')], scope: 'app' });
	keymap.register({ /* id／commandId：prefix 綁同命令；sequence：兩步；scope：app。 */ id: 'chord', commandId: 'run', sequence: [stroke('k'), stroke('c')], scope: 'app' });
	const oldResults = [];
	const latestResults = [];
	const handlings = [];
	const child = h('button', { /* id：同 DOM target。 */ id: 'key' }, 'key');
	function view(map, callback) {

		return h(React.StrictMode, null, host(map, child, { /* onResult：同 session 更新；onHandling：原 execution 觀察。 */ onResult: callback, onHandling: value => handlings.push(value) }));
	}
	await f.render(view(keymap, value => oldResults.push(value)));
	const node = f.win.document.querySelector('#key');
	await f.key(node, 'k');
	await clock.advance(60);
	await f.render(view(keymap, value => latestResults.push(value)));
	assert.equal(clock.jobs.size, 1);
	await clock.advance(40);
	assert.equal(keymap.pendingSequence.length, 0, 'same keymap callback render 保留原 deadline');
	await f.key(node, 'x');
	await f.render(view(keymap, value => latestResults.push(value)));
	const value = { /* identity：產品原物件，不可 clone。 */ identity: 'original' };
	await f.settle(() => pending[0].resolve(value));
	assert.equal(oldResults.length, 0);
	assert.equal(latestResults[0], await handlings.at(-1).execution);
	assert.equal(latestResults[0].value, value);
	await f.key(node, 'x');
	const error = new Error('original handler failure');
	await f.settle(() => pending[1].reject(error));
	assert.equal(latestResults[1].status, 'error');
	assert.equal(latestResults[1].error, error);
	await f.key(node, 'x');
	keymap.beginRecording('focus');
	const replacement = setup();
	await f.render(view(replacement.keymap, value => latestResults.push(value)));
	assert.equal(keymap.isRecording, false, 'replacement 取消舊借用錄製 session');
	assert.equal(keymap.pendingSequence.length, 0);
	assert.equal(clock.jobs.size, 0);
	await f.settle(() => pending[2].resolve('stale'));
	assert.equal(latestResults.length, 2, 'replacement 拒絕舊 session 結果');
	assert.equal(keymap.isDisposed, false);
	assert.equal(registry.isDisposed, false);
	await f.render(view(keymap, value => latestResults.push(value)));
	await f.key(f.win.document.querySelector('#key'), 'x');
	keymap.beginRecording('focus');
	await f.unmount();
	await f.settle(() => pending[3].resolve('unmounted'));
	assert.equal(latestResults.length, 2);
	assert.equal(keymap.isRecording, false);
	assert.equal(clock.jobs.size, 0);
	assert.equal(keymap.isDisposed, false);
	assert.equal(registry.isDisposed, false);
	assert.equal(f.errors.length, 0);
}
test('StrictMode／same-session latest callback／原值錯誤／replacement＋unmount 借用 cleanup', lifetime);

async function diagnostics(t) {

	const f = await fixture(t);
	const s = setup();
	s.bind('run', [stroke('x')]);
	const handlingError = new Error('onHandling');
	const resultError = new Error('onResult');
	const child = h('button', { /* id：診斷事件 target。 */ id: 'key' }, 'key');
	await f.render(host(s.keymap, child, { /* onHandling／onResult：診斷不改命令結果或攔截。 */ onHandling: () => { throw handlingError; }, onResult: () => { throw resultError; } }));
	assert.equal((await f.key(f.win.document.querySelector('#key'), 'x')).defaultPrevented, true);
	assert.equal(s.calls.length, 1);
	assert.ok(f.errors.includes(handlingError));
	assert.ok(f.errors.includes(resultError));
	const focusError = new Error('getFocus');
	await f.render(host(s.keymap, child, { /* getFocus：產品投影失敗須 ignored 及 diagnostic。 */ getFocus: () => { throw focusError; } }));
	assert.equal((await f.key(f.win.document.querySelector('#key'), 'x')).defaultPrevented, false);
	assert.equal(s.calls.length, 1);
	assert.ok(f.errors.includes(focusError));
}
test('callback diagnostics 保留 handled／不重 dispatch／投影失敗 ignored', diagnostics);
