const assert = require('node:assert/strict');
const fs = require('node:fs');
const http = require('node:http');
const path = require('node:path');
const crypto = require('node:crypto');
const { chromium } = require(process.argv[2] || 'playwright');
const root = path.resolve(process.argv[4] || path.join(__dirname, '../assets/blocknote_editor'));
const fixtureHash = '2BA48C2821FFC6597F81A27B815E35675AEE91ECEF05F586CE02F80F12E53F42';

// 共用 fixture 由 Krepis Test Author 凍結；先驗位元組再使用其正式持久 schema。
const fixtureBytes = fs.readFileSync(path.join(__dirname, 'fixtures/blocknote_flow_protocol.json'));
assert.equal(crypto.createHash('sha256').update(fixtureBytes).digest('hex').toUpperCase(), fixtureHash);
const fixture = JSON.parse(fixtureBytes);
assert.equal(fixture.contractRevision, 'KBF-WIRE-r2a');
const sample = fixture.documentCases.find((entry) => entry.name === 'nested-table-and-page-identities').document;
const flatten = (blocks) => blocks.flatMap((block) => [block, ...flatten(block.children || [])]);
const block = (document, id) => flatten(document.blocks).find((entry) => entry.id === id);
const rows = (document, id) => JSON.parse(block(document, id).props.rowsJson);
const version = (message) => ({ epoch: message.epoch, revision: message.revision });

async function createHarness() {

	// 步驟 1：只服務指定正式 build；不存在的 bundle 是環境缺口而非行為 Red。
	assert.ok(fs.existsSync(path.join(root, 'index.html')), `HARNESS BLOCKED: bundle index missing: ${root}`);
	const server = http.createServer((request, response) => {
		const filename = path.resolve(root, '.' + decodeURIComponent(new URL(request.url, 'http://localhost').pathname));
		const target = filename === root ? path.join(root, 'index.html') : filename;
		if (!target.startsWith(root + path.sep) || !fs.existsSync(target) || !fs.statSync(target).isFile()) return response.writeHead(404).end();

		response.setHeader('Content-Type', ({ '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.png': 'image/png', '.woff2': 'font/woff2', '.ttf': 'font/ttf' })[path.extname(target)] || 'application/octet-stream');
		fs.createReadStream(target).pipe(response);
	});
	await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
	const origin = `http://127.0.0.1:${server.address().port}`;
	const browser = await chromium.launch({ headless: true, ...(process.argv[3] ? { executablePath: process.argv[3] } : {}) });
	const context = await browser.newContext();
	const remote = [];
	const errors = [];
	await context.route('**/*', (route) => {
		if (route.request().url().startsWith(origin + '/')) return route.continue();

		remote.push(route.request().url());
		return route.abort();
	});

	// 步驟 2：模擬同步 typed receipt；故障只注入 transport，不注入 editor 私有狀態。
	await context.addInitScript(() => {
		window.flowTest = { attempts: [], accepted: [], faults: {}, pending: {}, assets: [], holdAssets: false };
		window.flutter_inappwebview = { callHandler: async (name, message) => {
			const test = window.flowTest;
			if (name === 'KallopisBlockNoteAsset') {
				test.assets.push(message);
				if (test.holdAssets) await new Promise((resolve) => { test.releaseAsset = resolve; });

				return { mediaType: 'image/png', base64: 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aFe8AAAAASUVORK5CYII=' };
			}
			if (!message || typeof message !== 'object' || typeof message.type !== 'string') throw new Error(`Unexpected host call: ${name}`);

			test.attempts.push(JSON.parse(JSON.stringify(message)));
			const receipt = { received: true, lane: message.lane, hostInstanceId: message.hostInstanceId, messageType: message.type };
			if (message.lane === 'ordinary') receipt.deliverySeq = message.deliverySeq;
			else {
				receipt.requestId = message.requestId;
				if (message.recoveryId !== undefined) receipt.recoveryId = message.recoveryId;
			}
			const fault = test.faults[message.type];
			if (fault === 'hold') await new Promise((resolve) => { test.pending[message.type] = resolve; });
			if (fault === 'reject') throw new Error('Injected typed delivery failure');
			if (fault === 'mismatch') return { ...receipt, hostInstanceId: 'wrong-host' };
			if (fault === 'false') return { ...receipt, received: false };
			if (fault === 'undefined') return undefined;

			test.accepted.push(JSON.parse(JSON.stringify(message)));
			return receipt;
		} };
	});

	async function newUnnegotiatedSession() {
		const page = await context.newPage();
		page.setDefaultTimeout(5000);
		page.on('pageerror', (error) => errors.push(String(error)));
		await page.goto(origin);
		await page.waitForFunction(() => typeof window.kallopisBlockNote?.receive === 'function');
		return { page, documentId: 'document', sessionId: 'session', requestId: 10, hostInstanceId: undefined, epoch: 0, revision: 0 };
	}

	async function newSession() {
		const state = await newUnnegotiatedSession();
		const command = await send(state, 'flow.capabilities.request');
		const response = await waitMessage(state, 'flow.capabilities.response', command.requestId);
		assert.equal(response.lane, 'control');
		assert.equal(response.deliverySeq, undefined);
		assert.equal(response.lastDeliverySeq, 0);
		assert.equal(response.lastEventSeq, undefined);
		assert.deepEqual([response.epoch, response.revision, response.eventSeq], [0, 0, 0]);
		assert.deepEqual(response.capabilities, { pageLinksV1: true, databaseTableV1: true, operationGateV1: true }, 'RED: official host must negotiate Flow before open');
		state.hostInstanceId = response.hostInstanceId;
		validateEnvelope(state, response);
		return state;
	}

	async function close() {
		await browser.close();
		await new Promise((resolve) => server.close(resolve));
	}

	return { newSession, newUnnegotiatedSession, close, remote, errors };
}

function validateEnvelope(state, message) {
	for (const key of ['protocolVersion', 'flowProtocolVersion']) assert.equal(message[key], 1, key);
	for (const key of ['documentId', 'sessionId', 'hostInstanceId']) assert.equal(message[key], state[key], key);
	for (const key of ['epoch', 'revision', 'eventSeq']) assert.ok(Number.isSafeInteger(message[key]) && message[key] >= 0, key);
	assert.ok(Number.isSafeInteger(message.requestId) && message.requestId > 0);
	assert.equal(message.payload, undefined, 'r2a forbids payload wrapping');
	if (message.lane === 'ordinary') assert.ok(Number.isSafeInteger(message.deliverySeq) && message.deliverySeq > 0);
	else assert.equal(message.deliverySeq, undefined);
}

async function send(state, type, fields = {}) {
	const command = { protocolVersion: 1, flowProtocolVersion: 1, documentId: state.documentId, sessionId: state.sessionId, requestId: state.requestId++, epoch: state.epoch, revision: state.revision, type, ...fields };
	if (state.hostInstanceId) command.hostInstanceId = state.hostInstanceId;

	// receive 的 Promise 不等於 protocol ack；另外等精確 requestId 的公開訊息。
	await state.page.evaluate((value) => {
		window.flowTest.commandErrors ||= {};
		try {
			Promise.resolve(window.kallopisBlockNote.receive(value)).catch((error) => { window.flowTest.commandErrors[value.requestId] = String(error); });
		}
		catch (error) {
			window.flowTest.commandErrors[value.requestId] = String(error);
		}
	}, command);
	return command;
}

async function waitMessage(state, type, requestId) {
	try {
		await state.page.waitForFunction(({ type, requestId }) => window.flowTest.attempts.some((entry) => entry.type === type && entry.requestId === requestId), { type, requestId });
	}
	catch (error) {
		const diagnostic = await state.page.evaluate((id) => ({ commandError: window.flowTest.commandErrors?.[id], messages: window.flowTest.attempts }), requestId);
		throw new Error(`Missing ${type} for request ${requestId}: ${JSON.stringify(diagnostic)}`, { cause: error });
	}
	const message = await state.page.evaluate(({ type, requestId }) => window.flowTest.attempts.find((entry) => entry.type === type && entry.requestId === requestId), { type, requestId });
	if (state.hostInstanceId) validateEnvelope(state, message);
	return message;
}

async function settle(state) {
	await state.page.evaluate(() => new Promise((resolve) => requestAnimationFrame(() => requestAnimationFrame(resolve))));
}

async function snapshot(state) {
	await settle(state);
	const command = await send(state, 'snapshot.request');
	const result = await waitMessage(state, 'snapshot.response', command.requestId);
	state.epoch = result.epoch;
	state.revision = result.revision;
	return result;
}

async function open(state, document) {
	const command = await send(state, 'open', { document, messageIdStart: 5000 });
	await waitMessage(state, 'ready', command.requestId);
	return snapshot(state);
}

async function edit(state, type, fields = {}) {
	const before = await snapshot(state);
	const command = await send(state, type, { expectedVersion: version(before), ...fields });
	const result = await waitMessage(state, 'command.result', command.requestId);
	assert.equal(result.commandType, type);
	assert.equal(result.result, undefined);
	assert.equal(result.version, undefined);
	const after = await snapshot(state);
	const changes = await state.page.evaluate((seq) => window.flowTest.attempts.filter((entry) => entry.type === 'changed' && entry.deliverySeq > seq), before.deliverySeq);
	if (result.status === 'applied') {
		assert.equal(changes.length, 1, `${type}: one changed per transaction`);
		assert.equal(after.revision, before.revision + 1);
		assert.equal(after.eventSeq, before.eventSeq + 1);
		assert.deepEqual(version(changes[0]), version(result));
		assert.equal(changes[0].eventSeq, result.eventSeq);
		assert.deepEqual(changes[0].outline, result.outline);
	}
	else {
		assert.deepEqual(after.document, before.document, `${type}: rejected/unchanged must preserve all content`);
		assert.deepEqual(version(after), version(before));
		assert.equal(after.eventSeq, before.eventSeq);
		assert.equal(changes.length, 0);
		assert.equal(result.outline, undefined);
	}
	return { before, after, result };
}

async function undoRedo(state, before, after) {
	// 真實快捷鍵驗證 upstream history，不呼叫自製 undo 端點。
	await state.page.keyboard.press('Escape');
	await state.page.locator('[data-id="parent"] p').click();
	await state.page.keyboard.press('Control+z');
	assert.deepEqual((await snapshot(state)).document, before.document, 'One undo must restore exactly the pre-command document');
	await state.page.keyboard.press('Control+Shift+z');
	assert.deepEqual((await snapshot(state)).document, after.document, 'One redo must restore exactly the command result');
}

async function main() {
	const harness = await createHarness();
	try {
		const state = await harness.newSession();
		const initial = await open(state, sample);
		assert.equal(initial.document.blockNoteVersion, '0.54.2');
		for (const input of flatten(sample.blocks).filter((entry) => entry.type.startsWith('krepis'))) {
			const actual = block(initial.document, input.id);
			assert.equal(actual.type, input.type);
			assert.deepEqual(actual.props, input.props, 'Custom schema must roundtrip without persistent projection fields');
			assert.deepEqual(actual.children, []);
		}
		assert.equal(initial.document.blocks.length, sample.blocks.length, 'Flow open must not append an automatic trailing block');

		// 投影以完整身分區分同名 document；HTML 字串只能呈現為文字。
		const pageA = { projectId: 'project-A', documentId: 'shared' };
		const pageB = { projectId: 'project-B', documentId: 'shared' };
		const unsafe = '<img src=x onerror="window.projectionExecuted=true">最新標題';
		let outcome = await edit(state, 'page.configure', { projections: [{ page: pageA, title: unsafe, availability: 'available' }, { page: pageB, title: '另一專案', availability: 'available' }] });
		assert.equal(outcome.result.status, 'unchanged');
		await state.page.waitForFunction((title) => document.querySelector('[data-id="link-A"]')?.textContent.includes(title), unsafe);
		assert.equal(await state.page.evaluate(() => window.projectionExecuted), undefined);
		assert.equal(await state.page.locator('[data-id="link-A"] img').count(), 0);
		assert.ok((await state.page.locator('[data-node-type="blockContainer"][data-id="db-A"]').innerText()).includes('另一專案'));
		outcome = await edit(state, 'page.configure', { projections: [{ page: pageA, title: '更名後', availability: 'unavailable' }, { page: pageB, title: '另一專案更新', availability: 'unknown' }] });
		assert.equal(outcome.result.status, 'unchanged');
		await state.page.waitForFunction(() => document.querySelector('[data-id="link-A"]')?.textContent.includes('更名後'));
		outcome = await edit(state, 'page.configure', { projections: [{ page: pageA, title: 'A', availability: 'available' }, { page: pageA, title: 'B', availability: 'available' }] });
		assert.equal(outcome.result.status, 'rejected');
		assert.equal(outcome.result.failure.code, 'invalidArgument');

		// 一個連續情境覆蓋 identity、索引、真正單步 history 與拒絕零修改。
		outcome = await edit(state, 'database.insert', { afterBlockId: 'parent' });
		assert.equal(outcome.result.status, 'applied');
		const created = outcome.result.databaseId;
		assert.ok(created && created !== 'db-A' && created !== 'db-B');
		assert.equal(outcome.result.viewId, 'table');
		assert.equal(outcome.after.document.blocks[2].id, created);
		assert.deepEqual(rows(outcome.after.document, created), []);
		await undoRedo(state, outcome.before, outcome.after);
		outcome = await edit(state, 'database.reference.insert', { databaseId: 'db-A', viewId: 'table', rowIndex: 1, page: pageB });
		assert.equal(outcome.result.status, 'applied');
		const inserted = outcome.result.referenceId;
		assert.ok(inserted && !['row-1', 'row-2', 'row-3'].includes(inserted));
		assert.deepEqual(rows(outcome.after.document, 'db-A')[1], { referenceId: inserted, ...pageB });
		assert.equal(outcome.result.rowIndex, 1);
		await undoRedo(state, outcome.before, outcome.after);
		outcome = await edit(state, 'database.reference.move', { databaseId: 'db-A', viewId: 'table', referenceId: inserted, rowIndex: 3 });
		assert.equal(outcome.result.status, 'applied');
		assert.deepEqual(rows(outcome.after.document, 'db-A').map((row) => row.referenceId), ['row-1', 'row-2', 'row-3', inserted]);
		await undoRedo(state, outcome.before, outcome.after);
		outcome = await edit(state, 'database.reference.move', { databaseId: 'db-A', viewId: 'table', referenceId: inserted, rowIndex: 3 });
		assert.equal(outcome.result.status, 'unchanged');
		for (const [fields, code] of [[{ viewId: 'missing' }, 'invalidTarget'], [{ databaseId: 'missing' }, 'invalidTarget'], [{ referenceId: 'missing' }, 'invalidTarget'], [{ rowIndex: 4 }, 'invalidPosition'], [{ rowIndex: -1 }, 'invalidArgument'], [{ expectedVersion: { epoch: 0, revision: 0 }, revision: 0 }, 'staleVersion']]) {
			outcome = await edit(state, 'database.reference.move', { databaseId: 'db-A', viewId: 'table', referenceId: inserted, rowIndex: 0, ...fields });
			assert.equal(outcome.result.status, 'rejected');
			assert.equal(outcome.result.failure.code, code);
			for (const key of ['databaseId', 'viewId', 'referenceId', 'rowIndex']) assert.equal(outcome.result[key], undefined);
		}
		outcome = await edit(state, 'database.reference.remove', { databaseId: 'db-A', viewId: 'table', referenceId: inserted });
		assert.equal(outcome.result.status, 'applied');
		assert.equal(outcome.result.referenceId, inserted);
		assert.equal(outcome.result.rowIndex, undefined);
		assert.deepEqual(rows(outcome.after.document, 'db-A'), rows(initial.document, 'db-A'));
		await undoRedo(state, outcome.before, outcome.after);
		outcome = await edit(state, 'database.remove', { databaseId: created });
		assert.equal(outcome.result.status, 'applied');
		assert.equal(outcome.result.viewId, undefined);
		assert.equal(block(outcome.after.document, created), undefined);
		await undoRedo(state, outcome.before, outcome.after);
		const reopened = await harness.newSession();
		assert.deepEqual((await open(reopened, outcome.after.document)).document, outcome.after.document);
		assert.deepEqual(harness.errors, []);
		assert.deepEqual(harness.remote, []);
		console.log('PASS: official 0.54.2 custom roundtrip, safe projections without content versions, exact database commands, rejected zero changes, single undo/redo and reopen. Visual/native WebView acceptance remains human-pending.');
	}
	finally {
		await harness.close();
	}
}

module.exports = { createHarness, send, waitMessage, settle, snapshot, open, edit, sample, block, rows, version, validateEnvelope };
if (require.main === module) main().catch((error) => { console.error(error); process.exitCode = 1; });
