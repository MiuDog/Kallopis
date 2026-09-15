const assert = require('node:assert/strict');
const { createHarness, send, waitMessage, settle, snapshot, open, edit, sample, version } = require('./verify_blocknote_flow_references.cjs');
const documentWithText = { ...sample, blocks: [{ id: 'parent', type: 'paragraph', content: '原始文字', children: [] }] };

async function operation(state, type, fields) {
	const command = await send(state, type, fields);
	const responseType = { 'operation.lock': 'operation.locked', 'operation.reload': 'operation.reloaded', 'operation.unlock': 'operation.unlocked', 'operation.reconcile': 'operation.reconciled' }[type];
	const response = await waitMessage(state, responseType, command.requestId);
	assert.equal(response.lockId, fields.lockId);
	if (fields.reloadId && type === 'operation.reload') assert.equal(response.reloadId, fields.reloadId);
	if (type === 'operation.reconcile') {
		assert.equal(response.lane, 'control');
		assert.equal(response.recoveryId, fields.recoveryId);
		assert.ok(Number.isSafeInteger(response.coveredDeliverySeq) && response.coveredDeliverySeq >= 0);
		assert.equal(response.deliverySeq, undefined);
	}
	else assert.equal(response.lane, 'ordinary');
	state.epoch = response.epoch;
	state.revision = response.revision;
	return response;
}

async function enterText(state, text) {
	await state.page.locator('[data-id="parent"] p').click();
	await state.page.keyboard.press('End');
	await state.page.keyboard.insertText(text);
	await settle(state);
}

async function inputAttempts(state) {
	// 實際鍵盤加 DOM paste/drop/beforeinput 路徑；這些不是原生 Windows IME 證據。
	await state.page.locator('[data-id="parent"] p').click();
	await state.page.keyboard.insertText('不得寫入');
	for (const key of ['Backspace', 'Delete', 'Enter', 'Control+b', 'Control+z', 'Control+Shift+z']) await state.page.keyboard.press(key);
	await state.page.locator('[data-id="parent"] p').evaluate((element) => {
		const paste = new DataTransfer();
		paste.setData('text/plain', '不得貼上');
		element.dispatchEvent(new ClipboardEvent('paste', { bubbles: true, cancelable: true, clipboardData: paste }));
		const drop = new DataTransfer();
		drop.setData('text/plain', '不得拖入');
		element.dispatchEvent(new DragEvent('drop', { bubbles: true, cancelable: true, dataTransfer: drop }));
		element.dispatchEvent(new InputEvent('beforeinput', { bubbles: true, cancelable: true, inputType: 'insertText', data: '不得輸入' }));
		document.execCommand('insertText', false, '不得繞過');
	});
}

async function assertLocked(state, barrier) {
	assert.equal(await state.page.locator('[contenteditable="true"]').count(), 0, 'Successful barrier must close editable DOM');
	await inputAttempts(state);
	const commands = [
		['template.insert', { afterBlockId: 'parent', blocks: [{ type: 'paragraph', content: '不得插入範本' }] }],
		['replace.one', { query: '原始', replacement: '不得替換', matchBlockId: 'parent' }],
		['replace.all', { query: '文字', replacement: '不得全部替換' }],
		['asset.insert', { assetId: 'locked-asset', name: 'locked.png', mediaType: 'image/png' }],
		['open', { document: { ...documentWithText, blocks: [{ id: 'parent', type: 'paragraph', content: '不得普通重開' }] } }],
	];
	for (const [type, fields] of commands) await send(state, type, fields);
	const outcome = await edit(state, 'database.insert', { afterBlockId: 'parent' });
	assert.equal(outcome.result.status, 'rejected');
	assert.ok(['busy', 'blocked', 'recoveryRequired'].includes(outcome.result.failure.code));
	const after = await snapshot(state);
	assert.deepEqual(after.document, barrier.document, 'Every locked user and program mutator must leave the barrier document intact');
	assert.deepEqual(version(after), version(barrier));
	assert.equal(after.eventSeq, barrier.eventSeq);
}

async function lockReloadHistory(harness) {
	const state = await harness.newSession();
	await open(state, documentWithText);
	await enterText(state, '鎖前編輯');
	const edited = await snapshot(state);
	assert.match(JSON.stringify(edited.document), /鎖前編輯/);
	const lockId = 'history-lock';
	const locked = await operation(state, 'operation.lock', { lockId, revision: 0 });
	assert.deepEqual(locked.document, edited.document, 'Lock must include accepted edits even when its observed revision is old');
	assert.equal(locked.barrierEventSeq, locked.eventSeq);
	await assertLocked(state, locked);
	const committed = { ...sample, blocks: [{ id: 'parent', type: 'paragraph', content: [{ type: 'text', text: '已提交版本', styles: {} }], props: { backgroundColor: 'default', textColor: 'default', textAlignment: 'left' }, children: [] }] };
	const reloadFields = { lockId, reloadId: 'history-reload', oldEpoch: 0, nextEpoch: 1, document: committed, epoch: 0 };
	const reloaded = await operation(state, 'operation.reload', reloadFields);
	assert.deepEqual(reloaded.document, committed, 'Reload must compare the complete persisted document before switching');
	assert.deepEqual([reloaded.epoch, reloaded.revision, reloaded.eventSeq], [1, 0, 0]);
	assert.equal(reloaded.hostInstanceId, locked.hostInstanceId);
	assert.equal(await state.page.locator('[contenteditable="true"]').count(), 0);
	const repeated = await operation(state, 'operation.reload', reloadFields);
	assert.deepEqual(repeated.document, committed);
	assert.deepEqual([repeated.epoch, repeated.revision, repeated.eventSeq], [1, 0, 0], 'Same reloadId retry cannot create another epoch');
	await operation(state, 'operation.unlock', { lockId });
	await state.page.locator('[contenteditable="true"]').first().waitFor();
	await state.page.locator('[data-id="parent"] p').click();
	await state.page.keyboard.press('Control+z');
	assert.deepEqual((await snapshot(state)).document, committed, 'Fresh editor history cannot undo into the previous epoch');
	await state.page.keyboard.press('Control+Shift+z');
	assert.deepEqual((await snapshot(state)).document, committed);
	await enterText(state, '新世代文字');
	const newEdit = await snapshot(state);
	assert.match(JSON.stringify(newEdit.document), /新世代文字/);
	await state.page.keyboard.press('Control+z');
	assert.deepEqual((await snapshot(state)).document, committed, 'New editor history must still undo its own edits');
	const messages = await state.page.evaluate(() => window.flowTest.attempts.filter((message) => message.lane === 'ordinary'));
	assert.deepEqual(messages.map((message) => message.deliverySeq), messages.map((_, index) => index + 1), 'Ordinary delivery sequence must remain contiguous across reload');
	return { state, lockId, reloaded };
}

async function pendingAssetAndComposition(harness) {
	const state = await harness.newSession();
	await open(state, documentWithText);
	await state.page.evaluate(() => { window.flowTest.holdAssets = true; });
	const assetCommand = await send(state, 'asset.insert', { assetId: 'pending-asset', name: 'pending.png', mediaType: 'image/png' });
	await state.page.waitForFunction(() => typeof window.flowTest.releaseAsset === 'function');
	const lockCommand = await send(state, 'operation.lock', { lockId: 'asset-lock' });
	await send(state, 'template.insert', { blocks: [{ type: 'paragraph', content: 'barrier後不得提交' }] });
	await state.page.evaluate(() => { window.flowTest.holdAssets = false; window.flowTest.releaseAsset(); });
	const locked = await waitMessage(state, 'operation.locked', lockCommand.requestId);
	await state.page.waitForFunction((id) => window.flowTest.commandErrors[id] !== undefined || window.flowTest.attempts.some((message) => message.type === 'changed' || (message.type === 'command.result' && message.requestId === id)), assetCommand.requestId);
	const after = await snapshot(state);
	assert.deepEqual(after.document, locked.document, 'Asset resolver completion cannot mutate after successful barrier');
	assert.doesNotMatch(JSON.stringify(after.document), /barrier後不得提交/);
	await operation(state, 'operation.unlock', { lockId: 'asset-lock' });

	// 合成 composition 只保護 DOM 事件 gate；不聲稱涵蓋原生輸入法組字。
	await state.page.locator('[data-id="parent"] p').click();
	await state.page.locator('[data-id="parent"] p').evaluate((element) => {
		window.flowTest.compositionTarget = element;
		element.dispatchEvent(new CompositionEvent('compositionstart', { bubbles: true, data: '' }));
	});
	const composingLock = await send(state, 'operation.lock', { lockId: 'composition-lock' });
	await settle(state);
	assert.equal(await state.page.evaluate((id) => window.flowTest.attempts.some((message) => message.type === 'operation.locked' && message.requestId === id), composingLock.requestId), false, 'Composition cannot acknowledge a successful barrier before compositionend');
	await state.page.evaluate(() => {
		window.flowTest.compositionTarget.dispatchEvent(new CompositionEvent('compositionend', { bubbles: true, data: '' }));
		window.flowTest.compositionTarget.dispatchEvent(new InputEvent('input', { bubbles: true, inputType: 'insertCompositionText', data: '' }));
	});
	const compositionBarrier = await waitMessage(state, 'operation.locked', composingLock.requestId);
	assert.deepEqual((await snapshot(state)).document, compositionBarrier.document);
}

async function typedOutboxRecovery(harness) {
	for (const receiptFault of ['undefined', 'mismatch']) {
		const state = await harness.newSession();
		await open(state, documentWithText);
		await state.page.evaluate((fault) => { window.flowTest.faults.changed = fault; }, receiptFault);
		await enterText(state, '交付尚未確認');
		await state.page.waitForFunction(() => window.flowTest.attempts.some((message) => message.type === 'changed'));
		await settle(state);
		await inputAttempts(state);
		const queued = await send(state, 'snapshot.request');
		await settle(state);
		assert.equal(await state.page.evaluate((id) => window.flowTest.attempts.some((message) => message.type === 'snapshot.response' && message.requestId === id), queued.requestId), false, 'Unmatched typed receipt must stop the ordinary outbox head');
		const recovered = await operation(state, 'operation.reconcile', { lockId: `recovery-${receiptFault}`, recoveryId: `attempt-${receiptFault}`, reloadId: null, nextEpoch: null });
		assert.match(JSON.stringify(recovered.document), /交付尚未確認/);
		assert.doesNotMatch(JSON.stringify(recovered.document), /不得寫入|不得貼上|不得拖入|不得繞過/);
		assert.equal(recovered.lastAppliedReloadId, null);
		assert.equal(recovered.lastReloadEpoch, null);
		assert.equal(await state.page.locator('[contenteditable="true"]').count(), 0, 'Control receipt must not unlock the editor');
		const attempts = await state.page.evaluate(() => window.flowTest.attempts);
		const failed = attempts.find((message) => message.type === 'changed');
		assert.ok(recovered.coveredDeliverySeq >= failed.deliverySeq);
		await state.page.evaluate(() => { delete window.flowTest.faults.changed; });
		await operation(state, 'operation.unlock', { lockId: recovered.lockId });
		const snapshotAfter = await snapshot(state);
		assert.deepEqual(snapshotAfter.document, recovered.document);
		assert.ok(snapshotAfter.deliverySeq > recovered.coveredDeliverySeq, 'Recovery must not renumber covered ordinary deliveries');
	}
}

async function unlockFailureAndHostLifetime(harness) {
	const state = await harness.newSession();
	await open(state, documentWithText);
	const locked = await operation(state, 'operation.lock', { lockId: 'unlock-lock' });
	await state.page.evaluate(() => {
		const original = window.flutter_inappwebview.callHandler;
		window.flutter_inappwebview.callHandler = async (name, message) => {
			const receipt = await original(name, message);
			if (message?.type === 'operation.unlocked') await new Promise((resolve, reject) => { window.flowTest.failUnlock = () => reject(new Error('Injected lost unlock receipt')); });

			return receipt;
		};
	});
	const unlock = await send(state, 'operation.unlock', { lockId: 'unlock-lock' });
	await waitMessage(state, 'operation.unlocked', unlock.requestId);
	await state.page.waitForFunction(() => typeof window.flowTest.failUnlock === 'function');
	await settle(state);
	const writableBeforeReceipt = await state.page.locator('[contenteditable="true"]').count() > 0;
	if (writableBeforeReceipt) {
		await enterText(state, '解鎖後必須保留');
		assert.equal(await state.page.evaluate((seq) => window.flowTest.attempts.some((message) => message.type === 'changed' && message.deliverySeq > seq), locked.deliverySeq), false, 'First new changed must queue behind the unconfirmed unlock receipt');
	}
	else await inputAttempts(state);

	await state.page.evaluate(() => window.flowTest.failUnlock());
	await settle(state);
	const recovered = await operation(state, 'operation.reconcile', { lockId: 'unlock-lock', recoveryId: 'unlock-recovery', reloadId: null, nextEpoch: null });
	assert.equal(recovered.hostInstanceId, locked.hostInstanceId);
	assert.equal(recovered.epoch, locked.epoch);
	if (writableBeforeReceipt) {
		assert.match(JSON.stringify(recovered.document), /解鎖後必須保留/, 'Reconcile must preserve edits accepted after unlock instead of replaying an older document');
		assert.ok(recovered.revision > locked.revision);
	}
	else {
		assert.deepEqual(recovered.document, locked.document);
		console.log('INFO: host waits for unlock receipt before making DOM editable; post-unlock/pre-receipt edit window is structurally unavailable.');
	}
	assert.equal(await state.page.locator('[contenteditable="true"]').count(), 0);

	// 新 JS 執行個體不得借用舊 lock；保留新 host 身分回 control recoveryRequired。
	const replacement = await harness.newSession();
	assert.notEqual(replacement.hostInstanceId, state.hostInstanceId);
	const oldHostState = { ...replacement, hostInstanceId: state.hostInstanceId };
	const reconcile = await send(oldHostState, 'operation.reconcile', { lockId: 'unlock-lock', recoveryId: 'replaced-recovery', reloadId: null, nextEpoch: null });
	const error = await waitMessage(replacement, 'operation.error', reconcile.requestId);
	assert.equal(error.lane, 'control');
	assert.equal(error.commandType, 'operation.reconcile');
	assert.equal(error.recoveryId, 'replaced-recovery');
	assert.equal(error.failure.code, 'recoveryRequired');
	assert.equal(error.failure.detail, 'hostReplaced');
	assert.equal(error.document, undefined);
}

async function replayControl(state, command, original) {
	const count = await state.page.evaluate(() => window.flowTest.attempts.length);
	await state.page.evaluate((value) => window.kallopisBlockNote.receive(value), command);
	await state.page.waitForFunction(({ count, requestId, type }) => window.flowTest.attempts.slice(count).some((message) => message.requestId === requestId && message.type === type), { count, requestId: command.requestId, type: original.type });
	const repeated = await state.page.evaluate(({ count, requestId, type }) => window.flowTest.attempts.slice(count).find((message) => message.requestId === requestId && message.type === type), { count, requestId: command.requestId, type: original.type });
	assert.deepEqual(repeated, original, 'A complete control request replay must return the frozen original response');
}

async function rejectConflictingControl(state, command, responseType) {
	const count = await state.page.evaluate(() => window.flowTest.attempts.length);
	const failure = await state.page.evaluate(async (value) => {
		try {
			await window.kallopisBlockNote.receive(value);
			return null;
		}
		catch (error) {
			return String(error);
		}
	}, command);
	await settle(state);
	const later = await state.page.evaluate((offset) => window.flowTest.attempts.slice(offset), count);
	assert.equal(later.some((message) => message.requestId === command.requestId && message.type === responseType), false, 'Conflicting request identity cannot produce a successful cached or replacement control response');
	assert.ok(failure || later.some((message) => message.requestId === command.requestId && ['protocolMismatch', 'invalidArgument'].includes(message.failure?.code)), 'Conflicting control payload must explicitly reject');
}

async function unnegotiatedReplacement(harness) {
	// 全新 JS 未收到 capability/open，仍須辨識舊 host 的 recovery 請求。
	const replacement = await harness.newUnnegotiatedSession();
	const command = await send({ ...replacement, hostInstanceId: 'destroyed-host' }, 'operation.reconcile', { lockId: 'old-lock', recoveryId: 'fresh-host-recovery', reloadId: null, nextEpoch: null });
	const error = await waitMessage(replacement, 'operation.error', command.requestId);
	assert.equal(error.lane, 'control');
	assert.equal(error.deliverySeq, undefined);
	assert.equal(error.commandType, 'operation.reconcile');
	assert.equal(error.recoveryId, 'fresh-host-recovery');
	assert.equal(error.lockId, 'old-lock');
	assert.equal(error.failure.code, 'recoveryRequired');
	assert.equal(error.failure.detail, 'hostReplaced');
	assert.ok(typeof error.hostInstanceId === 'string' && error.hostInstanceId.trim() && error.hostInstanceId !== 'destroyed-host');
	assert.equal(error.document, undefined);
	assert.equal(await replacement.page.evaluate(() => window.flowTest.attempts.some((message) => message.type === 'ready' || message.type === 'flow.capabilities.response')), false);
}

async function controlRequestReplay(harness) {
	// 控制重送使用完整原 request；正文已更新也不能重建另一份能力回覆。
	const state = await harness.newUnnegotiatedSession();
	const capabilityCommand = await send(state, 'flow.capabilities.request');
	const capability = await waitMessage(state, 'flow.capabilities.response', capabilityCommand.requestId);
	state.hostInstanceId = capability.hostInstanceId;
	await open(state, documentWithText);
	await enterText(state, '重送前新增');
	const original = await snapshot(state);
	await replayControl(state, capabilityCommand, capability);
	await rejectConflictingControl(state, { ...capabilityCommand, revision: 1 }, 'flow.capabilities.response');
	const afterConflict = await snapshot(state);
	assert.deepEqual(afterConflict.document, original.document);
	assert.deepEqual(version(afterConflict), version(original));
	assert.equal(afterConflict.eventSeq, original.eventSeq);

	const recoveryFields = { lockId: 'replay-lock', recoveryId: 'replay-recovery', reloadId: null, nextEpoch: null };
	const recoveryCommand = await send(state, 'operation.reconcile', recoveryFields);
	const recovered = await waitMessage(state, 'operation.reconciled', recoveryCommand.requestId);
	await replayControl(state, recoveryCommand, recovered);
	await rejectConflictingControl(state, { ...recoveryCommand, lockId: 'different-lock' }, 'operation.reconciled');
	await replayControl(state, recoveryCommand, recovered);
	const stable = await snapshot(state);
	assert.deepEqual(stable.document, recovered.document);
	assert.deepEqual(version(stable), version(recovered));
	assert.equal(stable.eventSeq, recovered.eventSeq);
	assert.equal(await state.page.locator('[contenteditable="true"]').count(), 0);
}

async function compositionDrainingRejectsNewMutators(harness) {
	const state = await harness.newSession();
	await open(state, documentWithText);
	await enterText(state, '可撤銷但不得於drain撤銷');
	const original = await snapshot(state);
	await state.page.locator('[data-id="parent"] p').evaluate((element) => {
		window.flowTest.drainingTarget = element;
		element.dispatchEvent(new CompositionEvent('compositionstart', { bubbles: true, data: '' }));
	});
	const lock = await send(state, 'operation.lock', { lockId: 'draining-lock' });
	await settle(state);
	assert.equal(await state.page.evaluate((id) => window.flowTest.attempts.some((message) => message.type === 'operation.locked' && message.requestId === id), lock.requestId), false);

	// 組字可以自然完成，但 paste/drop/history 與新程式命令不是該次組字交易。
	await state.page.evaluate(() => {
		const target = window.flowTest.drainingTarget;
		const clipboard = new DataTransfer();
		clipboard.setData('text/plain', 'drain期間不得貼上');
		target.dispatchEvent(new ClipboardEvent('paste', { bubbles: true, cancelable: true, clipboardData: clipboard }));
		const drag = new DataTransfer();
		drag.setData('text/plain', 'drain期間不得拖入');
		target.dispatchEvent(new DragEvent('drop', { bubbles: true, cancelable: true, dataTransfer: drag }));
	});
	await state.page.keyboard.press('Control+z');
	await send(state, 'template.insert', { afterBlockId: 'parent', blocks: [{ type: 'paragraph', content: 'drain期間不得插入' }] });
	await settle(state);
	assert.equal(await state.page.evaluate((seq) => window.flowTest.attempts.some((message) => message.type === 'changed' && message.deliverySeq > seq), original.deliverySeq), false, 'Draining composition must reject new paste/drop/undo/program transactions');
	await state.page.evaluate(() => {
		window.flowTest.drainingTarget.dispatchEvent(new CompositionEvent('compositionend', { bubbles: true, data: '' }));
		window.flowTest.drainingTarget.dispatchEvent(new InputEvent('input', { bubbles: true, inputType: 'insertCompositionText', data: '' }));
	});
	const locked = await waitMessage(state, 'operation.locked', lock.requestId);
	assert.deepEqual(locked.document, original.document);
	assert.deepEqual(version(locked), version(original));
	assert.equal(locked.eventSeq, original.eventSeq);
	assert.deepEqual((await snapshot(state)).document, original.document);
}

async function reconcileSupersedesWaitingReload(harness) {
	const state = await harness.newSession();
	await open(state, documentWithText);
	const original = await operation(state, 'operation.lock', { lockId: 'superseded-lock' });

	// 同一 JS turn 送出兩個合法控制請求；較新 recovery 必須取消尚未提交的 reload。
	const obsoleteDocument = JSON.parse(JSON.stringify(original.document));
	obsoleteDocument.blocks[0].content[0].text = '已被reconcile取代的reload不得出現';
	const envelope = { protocolVersion: 1, flowProtocolVersion: 1, documentId: state.documentId, sessionId: state.sessionId, hostInstanceId: state.hostInstanceId, epoch: state.epoch, revision: state.revision, lockId: 'superseded-lock' };
	const reload = { ...envelope, type: 'operation.reload', requestId: state.requestId++, reloadId: 'obsolete-reload', oldEpoch: 0, nextEpoch: 1, document: obsoleteDocument };
	const recovery = { ...envelope, type: 'operation.reconcile', requestId: state.requestId++, recoveryId: 'newer-reconcile', reloadId: 'obsolete-reload', nextEpoch: 1 };
	await state.page.evaluate((commands) => {
		window.flowTest.commandErrors ||= {};
		for (const command of commands) {
			try {
				Promise.resolve(window.kallopisBlockNote.receive(command)).catch((error) => { window.flowTest.commandErrors[command.requestId] = String(error); });
			}
			catch (error) {
				window.flowTest.commandErrors[command.requestId] = String(error);
			}
		}
	}, [reload, recovery]);
	const reconciled = await waitMessage(state, 'operation.reconciled', recovery.requestId);
	assert.deepEqual(reconciled.document, original.document, 'New reconcile must invalidate the older waiting reload before either can commit');
	assert.deepEqual(version(reconciled), version(original));
	assert.equal(reconciled.lastAppliedReloadId, null);
	assert.equal(reconciled.lastReloadEpoch, null);
	const finalSnapshot = await snapshot(state);
	assert.deepEqual(finalSnapshot.document, original.document, 'Obsolete reload completion cannot overwrite the reconciled body later');
	assert.deepEqual(version(finalSnapshot), version(original));
	assert.equal(await state.page.evaluate((id) => window.flowTest.attempts.some((message) => message.type === 'operation.reloaded' && message.requestId === id), reload.requestId), false);
}

async function main() {
	const harness = await createHarness();
	try {
		await unnegotiatedReplacement(harness);
		await controlRequestReplay(harness);
		await compositionDrainingRejectsNewMutators(harness);
		await reconcileSupersedesWaitingReload(harness);
		await lockReloadHistory(harness);
		await pendingAssetAndComposition(harness);
		await typedOutboxRecovery(harness);
		await unlockFailureAndHostLifetime(harness);
		assert.deepEqual(harness.errors, []);
		assert.deepEqual(harness.remote, []);
		console.log('PASS: official bundle input/program gate, pending async barrier, synthetic composition, fresh reload history, typed receipt outbox/control recovery, unlock failure and host lifecycle. Native IME/WebView/visual acceptance remains human-pending.');
	}
	finally {
		await harness.close();
	}
}

module.exports = { unnegotiatedReplacement, controlRequestReplay, compositionDrainingRejectsNewMutators, reconcileSupersedesWaitingReload };
if (require.main === module) main().catch((error) => { console.error(error); process.exitCode = 1; });
