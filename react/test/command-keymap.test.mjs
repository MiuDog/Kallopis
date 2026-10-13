import assert from 'node:assert/strict';
import test from 'node:test';
import { KlpCommandKeymap, KlpCommandRegistry } from '../dist/index.js';

function stroke(key, extra = {}) {

	return { /* key：canonical 邏輯鍵，避免依實體鍵盤；extra：此案例的公開 modifier。 */ key, ...extra };
}

function focus(extra = {}) {

	return { /* focusId：原生焦點 owner；pageId／regionId／componentId：有效 scope 鏈；extra：案例變更。 */ focusId: 'focus', pageId: 'page', regionId: 'region', componentId: 'component', ...extra };
}

function binding(id, sequence, extra = {}) {

	return { /* id：binding owner；commandId：共用 registry identity；sequence：合法組合；scope：預設 app；extra：案例限制。 */ id, commandId: id, sequence, scope: 'app', ...extra };
}

function command(registry, id, extra = {}) {

	// 使用公開 registry 保持 handler 與 gate 的唯一權威。
	return registry.register({ /* id／label：產品命令身分及文案；handler：保留原值；extra：產品 gate 或非同步行為。 */ id, label: id, handler: () => id, ...extra });
}

function ignored(result) {

	assert.equal(result.state, 'ignored');
	assert.equal(result.handled, false);
	assert.equal(result.execution, undefined);
}

async function executed(result, id) {

	assert.equal(result.state, 'executed');
	assert.equal(result.handled, true);
	assert.equal(result.bindingId, id);
	assert.equal(result.commandId, id);
	assert.ok(Object.isFrozen(result));
	const execution = await result.execution;
	assert.equal(execution.status, 'executed');
	assert.equal(execution.commandId, id);
	return execution;
}

function deferred() {

	let resolve;
	let reject;
	// 由產品控制完成時刻，以觀察同 registry 的 running gate。
	const promise = new Promise((yes, no) => { resolve = yes; reject = no; });
	return { /* promise：產品結果；resolve／reject：測試控制完成與原始失敗。 */ promise, resolve, reject };
}

async function platformModifiers() {

	for (const platform of ['mac', 'other']) {
		const registry = new KlpCommandRegistry();
		const keymap = new KlpCommandKeymap(registry, { /* platform：決定 primary 投影。 */ platform });
		command(registry, 'save');
		keymap.register(binding('save', [stroke('s', { /* primary：產品平台主 modifier。 */ primary: true })]));
		const modifier = platform === 'mac' ? 'meta' : 'ctrl';
		const other = platform === 'mac' ? 'ctrl' : 'meta';
		ignored(keymap.handle(stroke('s'), focus(), {}));
		ignored(keymap.handle(stroke('s', { /* 動態 modifier：非主平台鍵不可誤匹配。 */ [other]: true }), focus(), {}));
		ignored(keymap.handle(stroke('s', { /* 動態 modifier／alt：多餘 modifier 必須拒絕。 */ [modifier]: true, alt: true }), focus(), {}));
		await executed(keymap.handle(stroke('s', { /* 動態 modifier：native 已投影主鍵。 */ [modifier]: true }), focus(), {}), 'save');
		keymap.setOverride('save', [stroke('s', { /* primary／ctrl：OR 投影不能視為互斥。 */ primary: true, ctrl: true })]);
		await executed(keymap.handle(stroke('s', { /* meta：mac 主鍵；ctrl：explicit modifier；other 平台無須 meta。 */ meta: platform === 'mac', ctrl: true }), focus(), {}), 'save');
		assert.equal(keymap.platform, platform);
		keymap.dispose();
		registry.dispose();
	}
}

async function resolutionAndConflicts() {

	const registry = new KlpCommandRegistry();
	const keymap = new KlpCommandKeymap(registry);
	const removers = [];
	for (const scope of ['app', 'page', 'region', 'component']) {
		command(registry, scope);
		const extra = { /* scope：固定解析層級；priority：較廣 scope 不可靠 priority 搶先。 */ scope, priority: scope === 'app' ? 999 : 0 };
		if (scope !== 'app') extra.scopeId = scope;
		removers.push(keymap.register(binding(scope, [stroke('x')], extra)));
	}
	assert.deepEqual(keymap.conflicts(focus(), {}), []);
	for (const scope of ['component', 'region', 'page', 'app']) {
		await executed(keymap.handle(stroke('x'), focus(), {}), scope);
		removers.pop()();
	}
	for (const id of ['\uE000', '😀', 'z', 'a']) {
		command(registry, id);
		keymap.register(binding(id, [stroke('q')], { /* priority：先驗證高優先，再觀察 UTF-16 而非 scalar 排序。 */ priority: id === 'z' ? 1 : 0 }));
	}
	await executed(keymap.handle(stroke('q'), focus(), {}), 'z');
	keymap.setOverride('z', null);
	keymap.setOverride('a', null);
	await executed(keymap.handle(stroke('q'), focus(), {}), '😀');
	command(registry, 'long');
	keymap.register(binding('long', [stroke('q'), stroke('w')]));
	const conflicts = keymap.conflicts(focus(), {});
	assert.deepEqual(conflicts.map((item) => [item.kind, [...item.bindingIds], item.winnerId]), [['prefix', ['long', '😀'], 'long'], ['prefix', ['long', '\uE000'], 'long'], ['exact', ['😀', '\uE000'], '😀']]);
	assert.ok(Object.isFrozen(conflicts));
	for (const conflict of conflicts) {
		assert.ok(Object.isFrozen(conflict));
		assert.ok(Object.isFrozen(conflict.bindingIds));
	}
	// 高順位長序列不可先執行較低順位短命令。
	assert.equal(keymap.handle(stroke('q'), focus(), {}).state, 'prefix');
	await executed(keymap.handle(stroke('w'), focus(), {}), 'long');
	keymap.restore('z');
	await executed(keymap.handle(stroke('q'), focus(), {}), 'z');
	assert.deepEqual(keymap.pendingSequence, [], '較高順位完整短鍵應立即執行');
	keymap.dispose();
	registry.dispose();
}

async function chordLifecycle() {

	const registry = new KlpCommandRegistry();
	let time = 0;
	const keymap = new KlpCommandKeymap(registry, { /* now：monotonic 毫秒由測試控制；chordTimeoutMs：每步的期限。 */ now: () => time, chordTimeoutMs: 100 });
	command(registry, 'chord');
	command(registry, 'fresh');
	keymap.register(binding('chord', [stroke('k'), stroke('c'), stroke('d')]));
	keymap.register(binding('fresh', [stroke('x')]));
	const start = () => keymap.handle(stroke('k'), focus(), {});
	assert.equal(start().state, 'prefix');
	const snapshot = keymap.pendingSequence;
	assert.ok(Object.isFrozen(snapshot));
	assert.ok(Object.isFrozen(snapshot[0]));
	ignored(keymap.handle(stroke('Control'), focus(), {}));
	assert.equal(keymap.pendingSequence.length, 1);
	time = 99;
	assert.equal(keymap.expireChord(), false);
	assert.equal(keymap.handle(stroke('c'), focus(), {}).state, 'prefix');
	time = 100;
	assert.equal(keymap.expireChord(), false, '每個合法續鍵應重設計時');
	time = 199;
	assert.equal(keymap.expireChord(), true);
	assert.equal(keymap.expireChord(), false);
	assert.equal(snapshot.length, 1, '過去 snapshot 不隨狀態清除');
	start();
	await executed(keymap.handle(stroke('x'), focus(), {}), 'fresh');
	assert.deepEqual(keymap.pendingSequence, []);
	start();
	const escape = keymap.handle(stroke('escape'), focus(), {});
	assert.deepEqual([escape.state, escape.handled], ['cancelled', true]);
	assert.equal(keymap.cancelChord(), false);
	for (const changed of [focus({ focusId: 'next' }), focus({ pageId: 'next' }), focus({ regionId: 'next' }), focus({ componentId: 'next' }), focus({ editable: true })]) {
		start();
		ignored(keymap.handle(stroke('c'), changed, {}));
		assert.deepEqual(keymap.pendingSequence, []);
	}
	start();
	assert.equal(keymap.cancelChord(), true);
	assert.equal(keymap.cancelChord(), false);
	start();
	time += 100;
	await executed(keymap.handle(stroke('x'), focus(), {}), 'fresh');
	start();
	time = NaN;
	assert.throws(() => keymap.expireChord(), Error);
	assert.equal(keymap.pendingSequence.length, 1, '非法 clock 不可部分清除 chord');
	keymap.dispose();
	registry.dispose();
}

async function textSafety() {

	const registry = new KlpCommandRegistry();
	const keymap = new KlpCommandKeymap(registry);
	command(registry, 'plain');
	command(registry, 'allowed');
	command(registry, 'chord');
	keymap.register(binding('plain', [stroke('p')]));
	keymap.register(binding('allowed', [stroke('a')], { /* allowInEditable／allowRepeat：產品明示允許文字與重複 keydown。 */ allowInEditable: true, allowRepeat: true }));
	keymap.register(binding('chord', [stroke('k'), stroke('c')]));
	ignored(keymap.handle(stroke('p'), focus({ editable: true }), {}));
	ignored(keymap.handle(stroke('p', { repeat: true }), focus(), {}));
	await executed(keymap.handle(stroke('a', { repeat: true }), focus({ editable: true }), {}), 'allowed');
	keymap.handle(stroke('k'), focus(), {});
	ignored(keymap.handle(stroke('c', { composing: true }), focus(), {}));
	assert.deepEqual(keymap.pendingSequence, []);
	ignored(keymap.handle(stroke('a', { composing: true }), focus(), {}));
	for (const key of ['Dead', 'Process', 'Unidentified', 'Shift', 'UpperCase', ' ']) ignored(keymap.handle(stroke(key), focus(), {}));
	keymap.dispose();
	registry.dispose();
}

async function registryAuthority() {

	const registry = new KlpCommandRegistry();
	const keymap = new KlpCommandKeymap(registry);
	const waiting = deferred();
	const received = [];
	const off = command(registry, 'gate', { /* isVisible／isEnabled：由最新產品 context 決定；handler：保留原 context 與 async 結果。 */ isVisible: (context) => context.visible, isEnabled: (context) => context.enabled, handler: (context) => { received.push(context); return waiting.promise; } });
	keymap.register(binding('gate', [stroke('g')], { /* when：快捷鍵自己的產品條件，不建立第二 handler。 */ when: (context) => { if (context.fail) throw undefined; return context.when; } }));
	const context = { /* visible／enabled：registry gates；when／fail：快捷鍵 predicate；產品可就地改動。 */ visible: false, enabled: true, when: true, fail: false };
	ignored(keymap.handle(stroke('g'), focus(), context));
	context.visible = true;
	context.enabled = false;
	ignored(keymap.handle(stroke('g'), focus(), context));
	context.enabled = true;
	context.when = false;
	ignored(keymap.handle(stroke('g'), focus(), context));
	context.when = true;
	context.fail = true;
	ignored(keymap.handle(stroke('g'), focus(), context));
	context.fail = false;
	const running = keymap.handle(stroke('g'), focus(), context);
	assert.equal(running.state, 'executed');
	assert.equal(registry.getState('gate', context).running, true);
	ignored(keymap.handle(stroke('g'), focus(), context));
	assert.deepEqual(received, [context]);
	off();
	ignored(keymap.handle(stroke('g'), focus(), context));
	const value = { /* product：產品原值不能被 keymap clone 或 freeze。 */ product: true };
	waiting.resolve(value);
	assert.strictEqual((await running.execution).value, value);
	assert.equal(Object.isFrozen(value), false);
	const error = { /* product：保留 handler 的原錯誤 identity。 */ product: 'error' };
	command(registry, 'failure', { handler: () => Promise.reject(error) });
	keymap.register(binding('failure', [stroke('e')]));
	const failure = await keymap.handle(stroke('e'), focus(), context).execution;
	assert.equal(failure.status, 'error');
	assert.equal(failure.phase, 'handler');
	assert.strictEqual(failure.error, error);
	registry.dispose();
	ignored(keymap.handle(stroke('e'), focus(), context));
	keymap.dispose();
}

async function ownerAndDispose() {

	const registry = new KlpCommandRegistry();
	const keymap = new KlpCommandKeymap(registry);
	command(registry, 'same');
	const oldOff = keymap.register(binding('same', [stroke('k'), stroke('c')]));
	assert.throws(() => keymap.register(binding('same', [stroke('x')])), Error);
	keymap.setOverride('same', [stroke('q')]);
	oldOff();
	assert.deepEqual(keymap.exportOverrides().bindings, {});
	const newOff = keymap.register(binding('same', [stroke('x')]));
	oldOff();
	await executed(keymap.handle(stroke('x'), focus(), {}), 'same');
	newOff();
	newOff();
	ignored(keymap.handle(stroke('x'), focus(), {}));
	keymap.register(binding('same', [stroke('k'), stroke('c')]));
	keymap.handle(stroke('k'), focus(), {});
	keymap.beginRecording('focus');
	keymap.handle(stroke('x'), focus(), {});
	keymap.dispose();
	keymap.dispose();
	assert.equal(keymap.isDisposed, true);
	assert.equal(registry.isDisposed, false);
	assert.deepEqual(keymap.pendingSequence, []);
	assert.deepEqual(keymap.recordedSequence, []);
	assert.equal(keymap.isRecording, false);
	assert.equal(keymap.cancelChord(), false);
	assert.equal(keymap.expireChord(), false);
	assert.deepEqual(keymap.finishRecording(), []);
	keymap.cancelRecording();
	ignored(keymap.handle(stroke('x'), focus(), {}));
	assert.throws(() => keymap.register(binding('later', [stroke('z')])), Error);
	assert.throws(() => keymap.beginRecording('focus'), Error);
	assert.throws(() => keymap.setOverride('same', null), Error);
	assert.throws(() => keymap.restore('same'), Error);
	assert.throws(() => keymap.importOverrides({ schemaVersion: 1, bindings: {} }), Error);
	assert.equal((await registry.execute('same', {})).status, 'executed');
	registry.dispose();
}

async function overrides() {

	const registry = new KlpCommandRegistry();
	const keymap = new KlpCommandKeymap(registry);
	command(registry, 'one');
	command(registry, 'two');
	const source = binding('one', [stroke('k'), stroke('c')]);
	keymap.register(source);
	keymap.register(binding('two', [stroke('t')]));
	source.sequence[0].key = 'z';
	keymap.setOverride('two', null);
	const override = [stroke('o')];
	keymap.setOverride('one', override);
	override[0].key = 'z';
	await executed(keymap.handle(stroke('o'), focus(), {}), 'one');
	ignored(keymap.handle(stroke('t'), focus(), {}));
	const saved = keymap.exportOverrides();
	const wire = JSON.parse(JSON.stringify(saved));
	assert.deepEqual(Object.keys(wire).sort(), ['bindings', 'schemaVersion']);
	assert.equal(wire.schemaVersion, 1);
	assert.deepEqual(Object.keys(wire.bindings).sort(), ['one', 'two']);
	assert.equal(wire.bindings.two, null);
	assert.deepEqual(wire.bindings.one.map((item) => item.key), ['o']);
	for (const modifier of ['primary', 'ctrl', 'alt', 'shift', 'meta']) assert.equal(wire.bindings.one[0][modifier] ?? false, false);
	keymap.restore('one');
	keymap.handle(stroke('k'), focus(), {});
	const invalid = [null, { schemaVersion: 2, bindings: {} }, { schemaVersion: 1, bindings: {}, extra: true }, { schemaVersion: 1, bindings: { absent: null } }, { schemaVersion: 1, bindings: { one: [] } }, { schemaVersion: 1, bindings: { one: [stroke('A')] } }, { schemaVersion: 1, bindings: { one: [stroke('x', { ctrl: 1 })] } }, { schemaVersion: 1, bindings: { one: [stroke('x', { extra: true })] } }, { schemaVersion: 1, bindings: { one: Array(5).fill(stroke('x')) } }];
	const before = JSON.stringify(keymap.exportOverrides());
	for (const candidate of invalid) {
		assert.throws(() => keymap.importOverrides(candidate), TypeError);
		assert.equal(JSON.stringify(keymap.exportOverrides()), before);
		assert.equal(keymap.pendingSequence.length, 1);
	}
	assert.throws(() => keymap.setOverride('absent', null), Error);
	assert.throws(() => keymap.restore('absent'), Error);
	keymap.importOverrides(JSON.parse(JSON.stringify(saved)));
	assert.deepEqual(keymap.pendingSequence, []);
	assert.deepEqual(keymap.exportOverrides(), saved);
	const imported = { /* schemaVersion：唯一 wire 格式；bindings：只含使用者 override，不含產品 metadata。 */ schemaVersion: 1, bindings: { /* one：替換序列；two：停用。 */ one: [stroke('i')], two: null } };
	keymap.importOverrides(imported);
	imported.bindings.one[0].key = 'z';
	await executed(keymap.handle(stroke('i'), focus(), {}), 'one');
	const exported = keymap.exportOverrides();
	try { exported.bindings.one[0].key = 'z'; } catch (error) { assert.ok(error instanceof TypeError); }
	try { exported.bindings.one.push(stroke('z')); } catch (error) { assert.ok(error instanceof TypeError); }
	await executed(keymap.handle(stroke('i'), focus(), {}), 'one');
	keymap.importOverrides({ schemaVersion: 1, bindings: {} });
	await executed(keymap.handle(stroke('t'), focus(), {}), 'two');
	assert.equal(keymap.handle(stroke('k'), focus(), {}).state, 'prefix');
	keymap.restore('one');
	assert.deepEqual(keymap.pendingSequence, []);
	keymap.dispose();
	registry.dispose();
}

async function recording() {

	const registry = new KlpCommandRegistry();
	const keymap = new KlpCommandKeymap(registry);
	let calls = 0;
	command(registry, 'command', { handler: () => ++calls });
	keymap.register(binding('command', [stroke('x')]));
	keymap.beginRecording('focus');
	ignored(keymap.handle(stroke('x', { composing: true }), focus(), {}));
	assert.equal(keymap.isRecording, true);
	ignored(keymap.handle(stroke('x', { repeat: true }), focus(), {}));
	ignored(keymap.handle(stroke('Dead'), focus(), {}));
	for (const key of ['x', 'a', 'b', 'c']) {
		const result = keymap.handle(stroke(key, { ctrl: true }), focus({ editable: true }), {});
		assert.deepEqual([result.state, result.handled, result.execution], ['recording', true, undefined]);
	}
	ignored(keymap.handle(stroke('d'), focus({ editable: true }), {}));
	const snapshot = keymap.recordedSequence;
	assert.equal(snapshot.length, 4);
	assert.ok(Object.isFrozen(snapshot));
	for (const item of snapshot) {
		assert.ok(Object.isFrozen(item));
		assert.equal(item.primary, false);
		assert.equal(item.ctrl, true);
	}
	assert.equal(calls, 0);
	assert.deepEqual(keymap.finishRecording(), snapshot);
	assert.equal(keymap.isRecording, false);
	assert.deepEqual(keymap.recordedSequence, snapshot);
	keymap.beginRecording('focus');
	ignored(keymap.handle(stroke('x'), focus({ focusId: 'next' }), {}));
	assert.equal(keymap.isRecording, false);
	assert.deepEqual(keymap.recordedSequence, []);
	assert.equal(calls, 0);
	keymap.beginRecording('focus');
	assert.equal(keymap.handle(stroke('escape'), focus(), {}).state, 'cancelled');
	assert.equal(keymap.isRecording, false);
	keymap.beginRecording('focus');
	keymap.handle(stroke('x'), focus(), {});
	keymap.setOverride('command', null);
	assert.equal(keymap.isRecording, true, '重綁不能隱式取消錄製');
	keymap.cancelRecording();
	keymap.cancelRecording();
	assert.deepEqual(keymap.recordedSequence, []);
	assert.equal(snapshot.length, 4);
	keymap.dispose();
	registry.dispose();
}

function bindingValidation() {

	const registry = new KlpCommandRegistry();
	const keymap = new KlpCommandKeymap(registry);
	command(registry, 'valid');
	// sequence：拒絕非 canonical 或超過四鍵；scope／scopeId：限制有效層級身分；priority：只收有限整數。
	const invalid = [binding('', [stroke('x')]), binding('bad', []), binding('bad', Array(5).fill(stroke('x'))), binding('bad', [stroke('A')]), binding('bad', [stroke(' ')]), binding('bad', [stroke('f25')]), binding('bad', [stroke('x', { meta: 'yes' })]), binding('bad', [stroke('x')], { scope: 'page' }), binding('bad', [stroke('x')], { scopeId: 'forbidden' }), binding('bad', [stroke('x')], { priority: 0.5 })];
	for (const candidate of invalid) assert.throws(() => keymap.register(candidate), TypeError);
	keymap.register(binding('valid', [stroke('😀')]));
	assert.equal(keymap.handle(stroke('😀'), focus(), {}).state, 'executed');
	assert.throws(() => keymap.handle(stroke('x', { shift: 1 }), focus(), {}), TypeError);
	assert.throws(() => keymap.handle(stroke('x'), focus({ focusId: '' }), {}), TypeError);
	keymap.dispose();
	registry.dispose();
}

test('primary 平台投影及所有 modifier 精確比對', platformModifiers);
test('scope／priority／UTF-16 ID 固定解析與 same-scope exact／prefix 衝突', resolutionAndConflicts);
test('chord 時鐘、每步期限、focus 取消與 mismatch 新鍵解析', chordLifecycle);
test('editable／composition／repeat 保護原生文字輸入', textSafety);
test('同 registry 最新 gates、running、解除及原非同步 value／error', registryAuthority);
test('binding disposer 僅解除自己的 owner，dispose 不接管產品 registry', ownerAndDispose);
test('override 原子拒絕、roundtrip、default 還原與 caller mutation 隔離', overrides);
test('explicit 錄製不 dispatch，保護 focus／composition 與四鍵上限', recording);
test('canonical scalar、binding 原子驗證與 input／focus 拒絕', bindingValidation);
