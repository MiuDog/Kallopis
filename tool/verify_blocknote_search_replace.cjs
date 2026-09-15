const assert = require('node:assert/strict');
const fs = require('node:fs');
const http = require('node:http');
const path = require('node:path');
const { chromium } = require(process.argv[2] || 'playwright');

const root = path.resolve(__dirname, '../assets/blocknote_editor');
const output = path.resolve(__dirname, '../build/blocknote-search-replace');
const mime = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.png': 'image/png', '.woff': 'font/woff', '.woff2': 'font/woff2', '.ttf': 'font/ttf' };
const fixture = {
	format: 'kallopis.blocknote', schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: [
		{ id: 'paragraph', type: 'paragraph', content: [{ type: 'text', text: '目標與目標', styles: { bold: true } }] },
		{ id: 'second', type: 'paragraph', content: '第二段目標與不可變文字' },
		{ id: 'image', type: 'image', props: { url: './sample-image.png', caption: '本地圖片' } },
	],
};

async function main() {
	// 只提供正式打包資產；獨立瀏覽器 context 不讀取任何使用者瀏覽資料。
	fs.mkdirSync(output, { recursive: true });
	const server = http.createServer((request, response) => {
		const filename = path.resolve(root, '.' + decodeURIComponent(new URL(request.url, 'http://localhost').pathname));
		const target = filename === root ? path.join(root, 'index.html') : filename;
		if (!target.startsWith(root + path.sep) || !fs.existsSync(target) || !fs.statSync(target).isFile()) {
			response.writeHead(404).end();
			return;
		}
		response.setHeader('Content-Type', mime[path.extname(target)] || 'application/octet-stream');
		fs.createReadStream(target).pipe(response);
	});
	await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
	const origin = `http://127.0.0.1:${server.address().port}`;
	let browser;
	const errors = [];
	const remoteRequests = [];
	try {
		browser = await chromium.launch({ headless: true, ...(process.argv[3] ? { executablePath: process.argv[3] } : {}) });
		const context = await browser.newContext();
		await context.route('**/*', (route) => {
			if (!route.request().url().startsWith(origin + '/')) {
				remoteRequests.push(route.request().url());
				return route.abort();
			}
			return route.continue();
		});
		await context.addInitScript(() => {
			window.hostMessages = [];
			window.flutter_inappwebview = { callHandler: async (name, message) => {
				window.hostMessages.push({ name, ...message });
			} };
		});
		async function open(document, sessionId, messageIdStart) {
			const page = await context.newPage();
			page.on('pageerror', (error) => errors.push(String(error)));
			await page.goto(origin + '/');
			await page.waitForFunction(() => typeof window.kallopisBlockNote?.receive === 'function');
			await page.evaluate((command) => window.kallopisBlockNote.receive(command), { protocolVersion: 1, type: 'open', sessionId, requestId: 1, revision: 0, messageIdStart, document });
			await page.waitForFunction((session) => window.hostMessages.some((message) => message.type === 'ready' && message.sessionId === session && message.requestId === 1), sessionId);
			assert.ok(await page.locator('[contenteditable=true]').first().isVisible(), 'Packaged editor must render');
			await page.evaluate(() => document.fonts.ready);
			await page.waitForFunction(() => [...document.images].some((image) => image.src.endsWith('/sample-image.png') && image.complete && image.naturalWidth > 0));
			return page;
		}
		async function snapshot(page, sessionId, requestId) {
			await settleEditing(page);
			await page.evaluate((command) => window.kallopisBlockNote.receive(command), { protocolVersion: 1, type: 'snapshot.request', sessionId, requestId, revision: 0 });
			await page.waitForFunction((id) => window.hostMessages.some((message) => message.type === 'snapshot.response' && message.requestId === id), requestId);
			return page.evaluate((id) => window.hostMessages.find((message) => message.type === 'snapshot.response' && message.requestId === id), requestId);
		}
		async function settleEditing(page) {
			await page.evaluate(() => new Promise((resolve) => requestAnimationFrame(() => requestAnimationFrame(resolve))));
		}
		let page = await open(fixture, 'search-one', 5000);
		const original = (await snapshot(page, 'search-one', 20)).document;
		async function replace(type, requestId) {
			await page.evaluate((command) => window.kallopisBlockNote.receive(command), { protocolVersion: 1, type, sessionId: 'search-one', requestId, revision: 0, query: '目標', replacement: '替換', matchBlockId: 'paragraph' });
			return (await snapshot(page, 'search-one', requestId + 100)).document;
		}
		const text = (document) => document.blocks.map((block) => JSON.stringify(block.content || [])).join('');
		const one = await replace('replace.one', 21);
		assert.equal(text(one).split('替換').length - 1, 1, 'Replace one must replace exactly one occurrence');
		assert.equal(text(one).split('目標').length - 1, 2);
		assert.equal(one.blocks.find((block) => block.id === 'paragraph').content[0].styles.bold, true);
		await page.keyboard.press('Escape');
		await page.locator('[data-id="paragraph"] p').click({ position: { x: 2, y: 2 } });
		await page.keyboard.press('Control+z');
		assert.deepEqual((await snapshot(page, 'search-one', 22)).document, original, 'One replace must be one upstream undo transaction');
		await page.keyboard.press('Control+Shift+z');
		assert.deepEqual((await snapshot(page, 'search-one', 23)).document, one);
		const all = await replace('replace.all', 24);
		assert.equal(text(all).split('替換').length - 1, 3);
		assert.ok(!text(all).includes('目標'));
		assert.ok(text(all).includes('不可變文字'));
		await page.keyboard.press('Escape');
		await page.locator('[data-id="paragraph"] p').click({ position: { x: 2, y: 2 } });
		await page.keyboard.press('Control+z');
		assert.deepEqual((await snapshot(page, 'search-one', 25)).document, one, 'Replace all across blocks must undo atomically');
		await page.keyboard.press('Control+Shift+z');
		assert.deepEqual((await snapshot(page, 'search-one', 26)).document, all);
		fs.writeFileSync(path.join(output, 'replaced.json'), JSON.stringify(all, null, '\t'));
		await page.close();
		page = await open(JSON.parse(fs.readFileSync(path.join(output, 'replaced.json'), 'utf8')), 'search-reopen', 6000);
		assert.deepEqual((await snapshot(page, 'search-reopen', 27)).document, all);
		// 唯讀投影由host身份配置；不得把來源文字寫入consumer快照。
		async function reference(text, available = true) {
			await page.evaluate((projection) => window.kallopisBlockNote.receive({ protocolVersion: 1, type: 'reference.configure', sessionId: 'search-reopen', requestId: 40, revision: 0, references: [projection] }), { referenceId: 'reference-a', hostBlockId: 'paragraph', sourceDocumentId: 'source-doc', sourceBlockId: 'source-block', title: '來源', text, available });
		}
		await page.evaluate(() => { window.referenceMutations = []; new MutationObserver((events) => { for (const event of events) for (const kind of ['addedNodes', 'removedNodes']) for (const node of event[kind]) if (node.outerHTML?.includes('kallopis-reference')) window.referenceMutations.push({ kind, html: node.outerHTML }); }).observe(document.body, { childList: true, subtree: true }); });
		await reference('唯讀來源第一版');
		const projection = page.locator('[data-reference-id="reference-a"]');
		await projection.waitFor({ state: 'visible', timeout: 5000 }).catch(async (error) => { fs.writeFileSync(path.join(output, 'reference-mutations.json'), JSON.stringify(await page.evaluate(() => window.referenceMutations), null, '\t')); throw error; });
		assert.equal(await projection.evaluate((element) => element.isContentEditable), false, 'Reference projection must not inherit editable content');
		assert.ok((await projection.innerText()).includes('唯讀來源第一版'));
		assert.deepEqual((await snapshot(page, 'search-reopen', 41)).document, all, 'Projection must not contaminate consumer persisted blocks');
		await reference('唯讀來源第二版😀');
		await page.waitForFunction(() => document.querySelector('[data-reference-id="reference-a"]')?.textContent.includes('唯讀來源第二版😀'));
		await projection.click();
		const navigation = await page.evaluate(() => window.hostMessages.find((message) => message.name === 'KallopisBlockNoteOpenReference'));
		assert.equal(navigation.referenceId, 'reference-a');
		assert.equal(navigation.sourceDocumentId, 'source-doc');
		assert.equal(navigation.sourceBlockId, 'source-block');
		await reference('不可外露舊正文', false);
		assert.equal(await projection.isDisabled(), true);
		assert.ok(!(await projection.innerText()).includes('不可外露舊正文'));
		assert.deepEqual((await snapshot(page, 'search-reopen', 42)).document, all);
		assert.deepEqual(errors, []);
		assert.deepEqual(remoteRequests, []);
		await page.screenshot({ path: path.join(output, 'reopened.png') });
		console.log('PASS: replace one/all through real BlockNote transactions, format/identity preservation, atomic undo/redo and reopen');
	} finally {
		await browser?.close();
		await new Promise((resolve) => server.close(resolve));
	}
}
main().catch((error) => { console.error(error); process.exitCode = 1; });



