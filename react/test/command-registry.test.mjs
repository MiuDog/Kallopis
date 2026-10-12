import assert from 'node:assert/strict';
import test from 'node:test';
import { KlpCommandRegistry } from '../dist/index.js';

// 只經公開入口觀察；延後完成的 Promise 由產品 fixture 擁有。
const definition = (id, extra = {}) => ({ id, label: `Label ${id}`, handler: () => id, ...extra });
function deferred() {
	let resolve;
	let reject;
	const promise = new Promise((yes, no) => { resolve = yes; reject = no; });
	return { promise, resolve, reject };
}
function stateFlags(state, expected) {
	assert.ok(state);
	assert.deepEqual([state.visible, state.enabled, state.checked, state.running], expected);
}
function outcome(result, status, id) {
	assert.equal(result.status, status);
	assert.equal(result.commandId, id);
}

// 驗證失敗不能留下部分註冊、通知或修改 caller。
test('metadata／id 原子驗證，duplicate 不取代現有 owner', async () => {
	const registry = new KlpCommandRegistry();
	let notifications = 0;
	registry.subscribe(() => notifications++);
	const invalid = [null, {}, definition(''), definition(7), definition('x', { label: '' }), definition('x', { label: 4 }), definition('x', { handler: null }), definition('x', { description: '' }), definition('x', { category: 7 }), definition('x', { keywords: 'tag' }), definition('x', { keywords: [''] }), definition('x', { keywords: [false] }), definition('x', { isVisible: true }), definition('x', { isEnabled: 0 }), definition('x', { isChecked: 'yes' })];
	for (const candidate of invalid) {
		assert.throws(() => registry.register(candidate), TypeError);
		assert.equal(registry.version, 0);
		assert.equal(notifications, 0);
		assert.deepEqual(registry.list({}), []);
	}
	registry.register(definition(' x ', { description: 'Desc', category: 'Category', keywords: ['tag'] }));
	assert.throws(() => registry.register(definition(' x ', { handler: () => 'replacement' })), TypeError);
	assert.equal(registry.version, 1);
	assert.equal(notifications, 1);
	assert.equal((await registry.execute(' x ', {})).value, ' x ');
	assert.equal(registry.getState('x', {}), null);
	for (const id of ['', null, 4]) {
		assert.throws(() => registry.getState(id, {}), TypeError);
		await assert.rejects(async () => registry.execute(id, {}), TypeError);
	}
	registry.dispose();
});

test('metadata 隔離與 UTF-16 id 排序，僅凍結 snapshot／keywords／list', async () => {
	const registry = new KlpCommandRegistry();
	const icon = { type: 'product-icon', props: { mutable: true } };
	const value = { product: true };
	const context = { mutable: true };
	const keywords = ['original'];
	const source = definition('z', { description: 'Original description', category: 'Original category', keywords, icon, handler: (input) => { assert.strictEqual(input, context); return value; } });
	registry.register(source);
	source.id = 'changed'; source.label = 'Changed'; source.description = 'Changed'; source.category = 'Changed'; keywords.push('later'); source.keywords = ['replaced'];
	registry.register(definition('a', { isVisible: () => false }));
	registry.register(definition('A'));
	registry.register(definition('😀'));
	const snapshots = registry.list(context);
	assert.deepEqual(snapshots.map((item) => item.id), ['A', 'a', 'z', '😀']);
	assert.ok(Object.isFrozen(snapshots));
	for (const snapshot of snapshots) assert.ok(Object.isFrozen(snapshot));
	const state = registry.getState('z', context);
	assert.equal(state.label, 'Label z');
	assert.equal(state.description, 'Original description');
	assert.equal(state.category, 'Original category');
	assert.deepEqual(state.keywords, ['original']);
	assert.ok(Object.isFrozen(state.keywords));
	assert.strictEqual(state.icon, icon);
	stateFlags(state, [true, true, false, false]);
	assert.equal(state.conditionError, null);
	assert.throws(() => { state.label = 'write'; }, TypeError);
	assert.throws(() => state.keywords.push('write'), TypeError);
	assert.strictEqual((await registry.execute('z', context)).value, value);
	for (const caller of [source, keywords, context, icon, icon.props, value]) assert.equal(Object.isFrozen(caller), false);
	registry.dispose();
});

test('舊 register disposer 只解除自己，重用相同 id 不受舊 token 影響', async () => {
	const registry = new KlpCommandRegistry();
	const oldOff = registry.register(definition('same'));
	oldOff();
	assert.equal(registry.version, 2);
	oldOff();
	assert.equal(registry.version, 2);
	const newOff = registry.register(definition('same', { handler: () => 'new owner' }));
	oldOff();
	assert.equal(registry.version, 3);
	assert.equal((await registry.execute('same', {})).value, 'new owner');
	newOff();
	assert.equal(registry.getState('same', {}), null);
	const version = registry.version;
	newOff();
	assert.equal(registry.version, version);
	registry.dispose();
});

test('每次使用最新 context 的三條件，missing／hidden／disabled 都不啟動 handler', async () => {
	const registry = new KlpCommandRegistry();
	const received = [];
	registry.register(definition('gate', { isVisible: (context) => context.visible, isEnabled: (context) => context.enabled, isChecked: (context) => context.checked, handler: (context) => { received.push(context); return context; } }));
	const context = { visible: true, enabled: true, checked: false };
	stateFlags(registry.getState('gate', context), [true, true, false, false]);
	context.checked = true;
	stateFlags(registry.getState('gate', context), [true, true, true, false]);
	context.visible = false;
	outcome(await registry.execute('gate', context), 'hidden', 'gate');
	context.visible = true; context.enabled = false;
	outcome(await registry.execute('gate', context), 'disabled', 'gate');
	outcome(await registry.execute('absent', context), 'missing', 'absent');
	assert.equal(registry.getState('absent', context), null);
	assert.deepEqual(received, []);
	assert.equal(registry.version, 1, '無效執行不能通知或遞增 version');
	context.enabled = true;
	const result = await registry.execute('gate', context);
	outcome(result, 'executed', 'gate');
	assert.strictEqual(result.value, context);
	assert.deepEqual(received, [context]);
	registry.dispose();
});

test('condition throw 保留原 error（含 undefined），非 boolean 亦為 condition error', async () => {
	const registry = new KlpCommandRegistry();
	let calls = 0;
	for (const predicate of ['isVisible', 'isEnabled', 'isChecked']) {
		for (const error of [undefined, { original: predicate }]) {
			const id = `${predicate}-${error === undefined ? 'undefined' : 'object'}`;
			registry.register(definition(id, { [predicate]: () => { throw error; }, handler: () => calls++ }));
			const state = registry.getState(id, {});
			stateFlags(state, [false, false, false, false]);
			assert.ok(state.conditionError !== null);
			assert.ok(Object.hasOwn(state.conditionError, 'error'));
			assert.strictEqual(state.conditionError.error, error);
			const result = await registry.execute(id, {});
			outcome(result, 'error', id);
			assert.equal(result.phase, 'condition');
			assert.ok(Object.hasOwn(result, 'error'));
			assert.strictEqual(result.error, error);
		}
		const id = `${predicate}-invalid`;
		registry.register(definition(id, { [predicate]: () => 1, handler: () => calls++ }));
		const state = registry.getState(id, {});
		stateFlags(state, [false, false, false, false]);
		assert.ok(state.conditionError.error instanceof TypeError);
		const result = await registry.execute(id, {});
		outcome(result, 'error', id);
		assert.equal(result.phase, 'condition');
		assert.ok(result.error instanceof TypeError);
	}
	assert.equal(calls, 0);
	assert.equal(registry.list({}).length, 9, '診斷清冊包含所有 condition error');
	registry.dispose();
});

test('sync／PromiseLike 成功與 handler 原 error 不混入 observer 通道', async () => {
	const observerErrors = [];
	const registry = new KlpCommandRegistry((error) => observerErrors.push(error));
	const productValue = { mutable: true };
	registry.register(definition('sync', { handler: () => productValue }));
	registry.register(definition('thenable', { handler: () => ({ then: (resolve) => resolve(productValue) }) }));
	for (const id of ['sync', 'thenable']) {
		const result = await registry.execute(id, {});
		outcome(result, 'executed', id);
		assert.strictEqual(result.value, productValue);
		assert.equal(Object.isFrozen(productValue), false);
		assert.equal(registry.getState(id, {}).running, false);
	}
	for (const [id, error, asyncFailure] of [['throw-undefined', undefined, false], ['throw-object', productValue, false], ['reject-undefined', undefined, true], ['reject-object', productValue, true]]) {
		registry.register(definition(id, { handler: () => { if (asyncFailure) return Promise.reject(error); throw error; } }));
		const result = await registry.execute(id, {});
		outcome(result, 'error', id);
		assert.equal(result.phase, 'handler');
		assert.ok(Object.hasOwn(result, 'error'));
		assert.strictEqual(result.error, error);
		assert.equal(registry.getState(id, {}).running, false);
	}
	assert.deepEqual(observerErrors, []);
	registry.dispose();
});

test('per-command busy 與不同 id 並行；執行 gates 先於 busy 且 completion 各一次通知', async () => {
	const registry = new KlpCommandRegistry();
	const first = deferred();
	const second = deferred();
	let firstCalls = 0;
	let secondCalls = 0;
	const context = { visible: true, enabled: true, checked: true, conditionFailure: false };
	const conditionError = { pendingCondition: true };
	registry.register(definition('first', { isVisible: (input) => input.visible, isEnabled: (input) => input.enabled, isChecked: (input) => { if (input.conditionFailure) throw conditionError; return input.checked; }, handler: () => { firstCalls++; assert.equal(registry.getState('first', context).running, true); return first.promise; } }));
	registry.register(definition('second', { handler: () => { secondCalls++; return second.promise; } }));
	const versions = [];
	registry.subscribe(() => versions.push(registry.version));
	const firstRun = registry.execute('first', context);
	const secondRun = registry.execute('second', context);
	stateFlags(registry.getState('first', context), [true, true, true, true]);
	assert.equal(registry.getState('second', context).running, true);
	assert.deepEqual(versions, [3, 4]);
	outcome(await registry.execute('first', context), 'busy', 'first');
	context.visible = false;
	outcome(await registry.execute('first', context), 'hidden', 'first');
	context.visible = true; context.enabled = false;
	outcome(await registry.execute('first', context), 'disabled', 'first');
	context.conditionFailure = true;
	const diagnostic = registry.getState('first', context);
	stateFlags(diagnostic, [false, false, false, true]);
	assert.strictEqual(diagnostic.conditionError.error, conditionError);
	const conditionResult = await registry.execute('first', context);
	outcome(conditionResult, 'error', 'first');
	assert.equal(conditionResult.phase, 'condition');
	assert.strictEqual(conditionResult.error, conditionError);
	context.conditionFailure = false;
	assert.deepEqual([firstCalls, secondCalls], [1, 1]);
	assert.deepEqual(versions, [3, 4]);
	first.resolve('first done');
	assert.equal((await firstRun).value, 'first done');
	assert.equal(registry.getState('first', context).running, false);
	assert.equal(registry.getState('second', context).running, true);
	second.resolve('second done');
	assert.equal((await secondRun).value, 'second done');
	assert.deepEqual(versions, [3, 4, 5, 6]);
	registry.dispose();
});

test('pending 解除及相同 id 重註冊，stale completion 不清新 owner 或通知', async () => {
	const registry = new KlpCommandRegistry();
	const old = deferred();
	const current = deferred();
	const oldOff = registry.register(definition('same', { handler: () => old.promise }));
	const oldRun = registry.execute('same', {});
	oldOff();
	assert.equal(registry.getState('same', {}), null);
	registry.register(definition('same', { handler: () => current.promise }));
	const currentRun = registry.execute('same', {});
	oldOff();
	const version = registry.version;
	old.resolve('old result');
	const oldResult = await oldRun;
	outcome(oldResult, 'executed', 'same');
	assert.equal(oldResult.value, 'old result');
	assert.equal(registry.version, version);
	assert.equal(registry.getState('same', {}).running, true);
	current.resolve('new result');
	assert.equal((await currentRun).value, 'new result');
	assert.equal(registry.getState('same', {}).running, false);
	assert.equal(registry.version, version + 1);
	const removed = deferred();
	const remove = registry.register(definition('removed', { handler: () => removed.promise }));
	const removedRun = registry.execute('removed', {});
	remove();
	const removedVersion = registry.version;
	const originalError = { stale: true };
	removed.reject(originalError);
	const result = await removedRun;
	outcome(result, 'error', 'removed');
	assert.equal(result.phase, 'handler');
	assert.strictEqual(result.error, originalError);
	assert.equal(registry.version, removedVersion);
	registry.dispose();
});

test('observer token 獨立，錯誤隔離、refresh/version 與 idempotent unsubscribe', async () => {
	const errors = [];
	const registry = new KlpCommandRegistry((error) => errors.push(error));
	let calls = 0;
	const listener = () => calls++;
	const firstOff = registry.subscribe(listener);
	const secondOff = registry.subscribe(listener);
	assert.equal(registry.version, 0);
	registry.refresh();
	assert.equal(registry.version, 1);
	assert.equal(calls, 2);
	firstOff(); firstOff();
	registry.refresh();
	assert.equal(calls, 3);
	assert.equal(registry.version, 2);
	secondOff();
	const originalError = { observer: true };
	registry.subscribe(() => { throw originalError; });
	registry.subscribe(() => { throw undefined; });
	const versions = [];
	registry.subscribe(() => versions.push(registry.version));
	const waiting = deferred();
	registry.register(definition('work', { handler: () => waiting.promise }));
	const running = registry.execute('work', {});
	assert.equal(registry.getState('work', {}).running, true);
	waiting.resolve('done');
	assert.equal((await running).value, 'done');
	assert.equal(registry.getState('work', {}).running, false);
	registry.refresh();
	assert.deepEqual(versions, [3, 4, 5, 6]);
	assert.deepEqual(errors, [originalError, undefined, originalError, undefined, originalError, undefined, originalError, undefined]);
	registry.dispose();
});

test('開始通知解除／替換／dispose token 時不得啟動過期 handler', async () => {
	for (const change of ['remove', 'replace', 'dispose']) {
		const registry = new KlpCommandRegistry();
		let oldCalls = 0;
		let newCalls = 0;
		const off = registry.register(definition('work', { handler: () => oldCalls++ }));
		const unsubscribe = registry.subscribe(() => {
			if (!registry.getState('work', {})?.running) return;
			unsubscribe();
			if (change === 'dispose') registry.dispose();
			else {
				off();
				if (change === 'replace') registry.register(definition('work', { handler: () => newCalls++ }));
			}
		});
		const result = await registry.execute('work', {});
		assert.notEqual(result.status, 'executed');
		assert.equal(result.commandId, 'work');
		assert.equal(oldCalls, 0);
		assert.equal(newCalls, 0);
		if (change === 'dispose') outcome(result, 'disposed', 'work');
		if (change === 'replace') {
			assert.equal(registry.getState('work', {}).running, false);
			outcome(await registry.execute('work', {}), 'executed', 'work');
			assert.equal(newCalls, 1);
		}
		registry.dispose();
	}
});

test('dispose 最後通知後清訂閱，pending 結果正常完成且沒有 stale 通知', async () => {
	const registry = new KlpCommandRegistry();
	const waiting = deferred();
	const off = registry.register(definition('pending', { handler: () => waiting.promise }));
	const versions = [];
	registry.subscribe(() => versions.push([registry.version, registry.isDisposed]));
	const running = registry.execute('pending', {});
	registry.dispose();
	assert.deepEqual(versions, [[2, false], [3, true]]);
	assert.equal(registry.version, 3);
	assert.equal(registry.isDisposed, true);
	assert.equal(registry.getState('pending', {}), null);
	assert.deepEqual(registry.list({}), []);
	outcome(await registry.execute('pending', {}), 'disposed', 'pending');
	outcome(await registry.execute('absent', {}), 'disposed', 'absent');
	assert.throws(() => registry.register(definition('new')), Error);
	assert.throws(() => registry.subscribe(() => {}), Error);
	assert.throws(() => registry.refresh(), Error);
	registry.dispose(); off(); off();
	waiting.resolve('product completes');
	const result = await running;
	outcome(result, 'executed', 'pending');
	assert.equal(result.value, 'product completes');
	assert.equal(registry.version, 3);
	assert.deepEqual(versions, [[2, false], [3, true]]);
});
