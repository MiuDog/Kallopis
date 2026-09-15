import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import fs from 'node:fs';
import http from 'node:http';
import path from 'node:path';
import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';

const require = createRequire(import.meta.url);
const { chromium } = require(process.argv[2] || 'playwright');
const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(process.argv[4] || path.join(here, '../assets/blocknote_editor'));
const fixtureHash = '0D23F7412DF69F57D44000DDCC905E2F79B031551260238F26020A5F55CD9A4E';
const fixtureBytes = fs.readFileSync(path.join(here, 'fixtures/blocknote_flow_protocol.json'));
assert.equal(crypto.createHash('sha256').update(fixtureBytes).digest('hex').toUpperCase(), fixtureHash);
const fixture = JSON.parse(fixtureBytes);
assert.equal(fixture.contractRevision, 'KBF-WIRE-r2c');
const sample = fixture.documentCases.find((entry) => entry.name === 'nested-table-and-page-identities').document;

async function createHarness() {
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
	const errors = [];
	const remote = [];
	await context.route('**/*', (route) => {
		if (route.request().url().startsWith(origin + '/')) return route.continue();

		remote.push(route.request().url());
		return route.abort();
	});
	await context.addInitScript(() => {
		window.flowTest = { attempts: [], accepted: [], faults: {} };
		window.flutter_inappwebview = { callHandler: async (name, message) => {
			if (!message || typeof message !== 'object' || typeof message.type !== 'string') throw new Error(`Unexpected host call: ${name}`);

			const test = window.flowTest;
			test.attempts.push(JSON.parse(JSON.stringify(message)));
			const receipt = { received: true, lane: message.lane, hostInstanceId: message.hostInstanceId, messageType: message.type };
			if (message.lane === 'ordinary') receipt.deliverySeq = message.deliverySeq;
			else {
				receipt.requestId = message.requestId;
				if (message.recoveryId !== undefined) receipt.recoveryId = message.recoveryId;
			}
			if (test.faults[message.type] === 'reject') throw new Error('Injected typed delivery failure');

			test.accepted.push(JSON.parse(JSON.stringify(message)));
			return receipt;
		} };
	});

	async function newSession() {
		const page = await context.newPage();
		page.setDefaultTimeout(5000);
		page.on('pageerror', (error) => errors.push(String(error)));
		await page.goto(origin);
		await page.waitForFunction(() => typeof window.kallopisBlockNote?.receive === 'function');
		const state = { page, documentId: 'document', sessionId: 'session', requestId: 10, hostInstanceId: undefined, epoch: 0, revision: 0 };
		const command = await send(state, 'flow.capabilities.request');
		const response = await waitMessage(state, 'flow.capabilities.response', command.requestId);
		state.hostInstanceId = response.hostInstanceId;
		assert.deepEqual(response.capabilities, { pageLinksV1: true, databaseTableV1: true, operationGateV1: true });
		return state;
	}

	async function close() {
		await browser.close();
		await new Promise((resolve) => server.close(resolve));
	}

	return { newSession, close, errors, remote };
}

async function send(state, type, fields = {}) {
	const command = { protocolVersion: 1, flowProtocolVersion: 1, documentId: state.documentId, sessionId: state.sessionId, requestId: state.requestId++, hostInstanceId: state.hostInstanceId, epoch: state.epoch, revision: state.revision, type, ...fields };
	if (command.hostInstanceId === undefined) delete command.hostInstanceId;
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

async function waitMessage(state, type, requestId, offset = 0) {
	try {
		await state.page.waitForFunction(({ type, requestId, offset }) => window.flowTest.attempts.slice(offset).some((entry) => entry.type === type && entry.requestId === requestId), { type, requestId, offset });
	}
	catch (error) {
		const diagnostic = await state.page.evaluate((id) => ({ commandError: window.flowTest.commandErrors?.[id], attempts: window.flowTest.attempts }), requestId);
		throw new Error(`Missing ${type} for request ${requestId}: ${JSON.stringify(diagnostic)}`, { cause: error });
	}
	return state.page.evaluate(({ type, requestId, offset }) => window.flowTest.attempts.slice(offset).find((entry) => entry.type === type && entry.requestId === requestId), { type, requestId, offset });
}

async function settle(state) {
	await state.page.evaluate(() => new Promise((resolve) => requestAnimationFrame(() => requestAnimationFrame(resolve))));
}

async function snapshot(state) {
	const command = await send(state, 'snapshot.request');
	const response = await waitMessage(state, 'snapshot.response', command.requestId);
	state.epoch = response.epoch;
	state.revision = response.revision;
	return response;
}

async function open(state) {
	const command = await send(state, 'open', { document: sample, messageIdStart: 5000 });
	const ready = await waitMessage(state, 'ready', command.requestId);
	assert.deepEqual(ready.document, sample, 'Negotiated ready must read back the complete opened document');
	return snapshot(state);
}

async function lock(state, lockId) {
	const command = await send(state, 'operation.lock', { lockId });
	const response = await waitMessage(state, 'operation.locked', command.requestId);
	state.epoch = response.epoch;
	state.revision = response.revision;
	assert.equal(response.barrierEventSeq, response.eventSeq);
	return response;
}

async function retire(state, locked, retirementId) {
	const command = await send(state, 'operation.retire', { lockId: locked.lockId, retirementId, savedVersion: { epoch: locked.epoch, revision: locked.revision } });
	const response = await waitMessage(state, 'operation.retired', command.requestId);
	assert.equal(response.lane, 'ordinary');
	assert.equal(response.lockId, locked.lockId);
	assert.equal(response.retirementId, retirementId);
	assert.deepEqual({ epoch: response.epoch, revision: response.revision }, command.savedVersion);
	assert.equal(response.eventSeq, locked.eventSeq);
	assert.deepEqual(response.document, locked.document);
	return { command, response };
}

async function attemptPermanentGate(state, terminal) {
	const before = await state.page.locator('body').innerText();
	await state.page.keyboard.insertText('不得寫入');
	await send(state, 'operation.unlock', { lockId: terminal.lockId });
	await send(state, 'database.insert', { expectedVersion: { epoch: terminal.epoch, revision: terminal.revision }, afterBlockId: terminal.document.blocks[0].id });
	await send(state, 'open', { document: { ...sample, blocks: [] }, messageIdStart: 9000 });
	await settle(state);
	assert.equal(await state.page.locator('body').innerText(), before, 'Retired user and program paths must leave rendered content unchanged');
	const later = await state.page.evaluate((deliverySeq) => window.flowTest.attempts.filter((message) => message.deliverySeq > deliverySeq), terminal.deliverySeq);
	assert.equal(later.some((message) => message.type === 'changed' || message.status === 'applied' || message.type === 'operation.unlocked' || message.type === 'ready'), false, 'Retired host can never regain commit or unlock authority');
}

async function terminalReplayAndGate(harness) {
	const state = await harness.newSession();
	await open(state);
	const locked = await lock(state, 'terminal-lock');
	const terminal = await retire(state, locked, 'terminal-retirement');
	const offset = await state.page.evaluate(() => window.flowTest.attempts.length);
	await state.page.evaluate((command) => window.kallopisBlockNote.receive(command), terminal.command);
	const repeated = await waitMessage(state, 'operation.retired', terminal.command.requestId, offset);
	assert.deepEqual(repeated, terminal.response, 'Exact retire replay must return the frozen terminal response and delivery identity');
	const matching = await state.page.evaluate((requestId) => window.flowTest.attempts.filter((message) => message.type === 'operation.retired' && message.requestId === requestId), terminal.command.requestId);
	assert.equal(new Set(matching.map((message) => message.deliverySeq)).size, 1, 'Retire replay cannot allocate a second terminal transaction');
	await attemptPermanentGate(state, terminal.response);
}

async function lostAckReconcile(harness) {
	const state = await harness.newSession();
	await open(state);
	const locked = await lock(state, 'lost-lock');
	await state.page.evaluate(() => { window.flowTest.faults['operation.retired'] = 'reject'; });
	const retirementId = 'lost-retirement';
	const retireCommand = await send(state, 'operation.retire', { lockId: locked.lockId, retirementId, savedVersion: { epoch: locked.epoch, revision: locked.revision } });
	const lost = await waitMessage(state, 'operation.retired', retireCommand.requestId);
	await state.page.evaluate(() => { delete window.flowTest.faults['operation.retired']; });
	const reconcile = await send(state, 'operation.reconcile', { lockId: locked.lockId, recoveryId: 'retired-recovery', reloadId: null, nextEpoch: null, retirementId });
	const recovered = await waitMessage(state, 'operation.reconciled', reconcile.requestId);
	assert.equal(recovered.lane, 'control');
	assert.equal(recovered.deliverySeq, undefined);
	assert.equal(recovered.recoveryId, reconcile.recoveryId);
	assert.equal(recovered.hostLifecycle, 'retired');
	assert.equal(recovered.retirementId, retirementId);
	assert.equal(recovered.lockId, locked.lockId);
	assert.deepEqual(recovered.document, lost.document);
	assert.deepEqual({ epoch: recovered.epoch, revision: recovered.revision }, { epoch: lost.epoch, revision: lost.revision });
	await attemptPermanentGate(state, lost);
}

async function main() {
	const harness = await createHarness();
	try {
		await terminalReplayAndGate(harness);
		await lostAckReconcile(harness);
		assert.deepEqual(harness.errors, []);
		assert.deepEqual(harness.remote, []);
		console.log('PASS: official bundle terminal retirement, exact replay, permanent input/mutator gate and retired control reconciliation. Native WebView and visual acceptance remain human-pending.');
	}
	finally {
		await harness.close();
	}
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
