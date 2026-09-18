const assert = require('node:assert/strict');
const fs = require('node:fs');
const http = require('node:http');
const path = require('node:path');
const { chromium } = require(process.argv[2] || 'playwright');

const root = path.resolve(__dirname, '../assets/blocknote_editor');
const output = path.resolve(__dirname, '../build/blocknote-template');
const mime = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.png': 'image/png', '.woff': 'font/woff', '.woff2': 'font/woff2', '.ttf': 'font/ttf' };
const fixture = {
	format: 'kallopis.blocknote', schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: [
		{ id: 'anchor', type: 'paragraph', content: '既有正文' },
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
		let page = await open(fixture, 'template-one', 5000);
		const original = (await snapshot(page, 'template-one', 20)).document;
		const inserted = [{ id: 'inserted-parent', type: 'bulletListItem', content: [{ type: 'text', text: '範本初版', styles: { bold: true } }], children: [{ id: 'inserted-child', type: 'paragraph', content: '巢狀內容' }] }];
		async function insert(afterBlockId) {
			await page.evaluate((command) => window.kallopisBlockNote.receive(command), { protocolVersion: 1, type: 'template.insert', sessionId: 'template-one', requestId: 21, revision: 0, afterBlockId, blocks: inserted });
		}
		await insert('anchor');
		const applied = (await snapshot(page, 'template-one', 22)).document;
		assert.equal(applied.blocks.length, original.blocks.length + 1, 'Template command must insert one root subtree');
		assert.equal(applied.blocks[0].id, 'anchor');
		assert.equal(applied.blocks[1].content[0].text, '範本初版');
		assert.equal(applied.blocks[1].content[0].styles.bold, true);
		assert.equal(applied.blocks[1].children[0].content[0].text, '巢狀內容');
		const flatten = (blocks) => blocks.flatMap((block) => [block, ...flatten(block.children || [])]);
		assert.equal(new Set(flatten(applied.blocks).map((block) => block.id)).size, flatten(applied.blocks).length);
		await page.keyboard.press('Escape');
		await page.locator('[data-id="anchor"] p').click({ position: { x: 2, y: 2 } });
		await page.keyboard.press('Control+z');
		assert.deepEqual((await snapshot(page, 'template-one', 23)).document, original, 'Insert subtree must be one upstream undo transaction');
		await page.keyboard.press('Control+Shift+z');
		assert.deepEqual((await snapshot(page, 'template-one', 24)).document, applied);
		await assert.rejects(insert('missing-anchor'), 'Invalid insertion anchor must reject instead of inserting elsewhere');
		assert.deepEqual((await snapshot(page, 'template-one', 25)).document, applied);
		assert.equal(await page.getByRole('button', { name: '儲存', exact: true }).count(), 0);
		fs.writeFileSync(path.join(output, 'applied.json'), JSON.stringify(applied, null, '\t'));
		await page.close();
		page = await open(JSON.parse(fs.readFileSync(path.join(output, 'applied.json'), 'utf8')), 'template-reopen', 6000);
		assert.deepEqual((await snapshot(page, 'template-reopen', 26)).document, applied);
		assert.deepEqual(errors, []);
		assert.deepEqual(remoteRequests, []);
		await page.screenshot({ path: path.join(output, 'reopened.png') });
		console.log('PASS: real template subtree insertion, position/style/identity, atomic undo/redo, rejected invalid anchor, reopen and no manual save');
	} finally {
		await browser?.close();
		await new Promise((resolve) => server.close(resolve));
	}
}
main().catch((error) => { console.error(error); process.exitCode = 1; });
