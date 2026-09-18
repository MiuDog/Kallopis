const assert = require('node:assert/strict');
const fs = require('node:fs');
const http = require('node:http');
const path = require('node:path');
const { chromium } = require(process.argv[2] || 'playwright');
const root = path.resolve(__dirname, '../assets/blocknote_editor');
const output = path.resolve(__dirname, '../build/blocknote-asset-resolution');
const fixture = { format: 'kallopis.blocknote', schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: [{ id: 'start', type: 'paragraph', content: '資產驗收' }] };
async function main() {
	fs.mkdirSync(output, { recursive: true });
	const server = http.createServer((request, response) => {
		const filename = path.resolve(root, '.' + new URL(request.url, 'http://localhost').pathname);
		const target = filename === root ? path.join(root, 'index.html') : filename;
		if (!target.startsWith(root + path.sep) || !fs.existsSync(target)) return response.writeHead(404).end();
		response.setHeader('Content-Type', ({ '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css' })[path.extname(target)] || 'application/octet-stream');
		fs.createReadStream(target).pipe(response);
	});
	await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
	const origin = `http://127.0.0.1:${server.address().port}`;
	let browser;
	try {
		browser = await chromium.launch({ headless: true, executablePath: process.argv[3] });
		const context = await browser.newContext();
		const remote = [];
		await context.route('**/*', (route) => {
			if (route.request().url().startsWith(origin + '/')) return route.continue();
			remote.push(route.request().url());
			return route.abort();
		});
		await context.addInitScript((base64) => {
			window.hostMessages = [];
			window.resolvedAssets = [];
			window.openedAssets = [];
			window.flutter_inappwebview = { callHandler: async (name, message) => {
				if (name === 'KallopisBlockNoteOpenAsset') { window.openedAssets.push(message); return; }
				if (name === 'KallopisBlockNoteAsset') {
					window.resolvedAssets.push(message);
					if (message === 'asset-failure') throw new Error('Injected resolver failure');
					return { mediaType: 'image/png', base64 };
				}
				window.hostMessages.push(message);
			} };
		}, fs.readFileSync(path.join(root, 'sample-image.png')).toString('base64'));
		async function command(page, type, fields = {}) {
			return page.evaluate((value) => window.kallopisBlockNote.receive(value), { protocolVersion: 1, sessionId: 'asset-session', requestId: 1, revision: 0, type, ...fields });
		}
		async function open(document) {
			const page = await context.newPage();
			await page.goto(origin);
			await page.waitForFunction(() => window.kallopisBlockNote?.receive);
			await command(page, 'open', { document });
			await page.waitForFunction(() => window.hostMessages.some((entry) => entry.type === 'ready'));
			return page;
		}
		let requestId = 20;
		async function snapshot(page) {
			const id = requestId++;
			await command(page, 'snapshot.request', { requestId: id });
			return page.evaluate((id) => window.hostMessages.find((entry) => entry.type === 'snapshot.response' && entry.requestId === id).document, id);
		}
		let page = await open(fixture);
		await command(page, 'asset.insert', { assetId: 'asset-image', name: '圖片.png', mediaType: 'image/png' });
		await page.waitForFunction(() => [...document.images].some((image) => image.complete && image.naturalWidth > 0));
		const saved = await snapshot(page);
		assert.equal(saved.blocks.filter((block) => block.type === 'image').length, 1);
		assert.equal(saved.blocks.find((block) => block.type === 'image').props.url, 'asset://asset-image');
		assert.doesNotMatch(JSON.stringify(saved), /data:image|base64/);
		fs.writeFileSync(path.join(output, 'snapshot.json'), JSON.stringify(saved, null, 2));
		await page.screenshot({ path: path.join(output, 'inserted.png') });
		await page.close();
		page = await open(JSON.parse(fs.readFileSync(path.join(output, 'snapshot.json'), 'utf8')));
		await page.waitForFunction(() => [...document.images].some((image) => image.complete && image.naturalWidth > 0));
		assert.deepEqual(await page.evaluate(() => window.resolvedAssets), ['asset-image']);
		assert.deepEqual(await snapshot(page), saved);
		await assert.rejects(command(page, 'asset.insert', { assetId: 'asset-failure', name: '失敗.png', mediaType: 'image/png' }), /Injected resolver failure/);
		assert.deepEqual(await snapshot(page), saved, 'Resolver failure must leave saved document intact');
		await command(page, 'asset.insert', { assetId: 'asset-attachment', name: '附件.pdf', mediaType: 'application/pdf' });
		fs.writeFileSync(path.join(output, 'attachment.json'), JSON.stringify(await snapshot(page), null, 2));
		fs.writeFileSync(path.join(output, 'attachment.html'), await page.content());
		await page.locator('[data-content-type=file][data-url="asset://asset-attachment"]').click();
		assert.deepEqual(await page.evaluate(() => window.openedAssets), ['asset-attachment']);
		assert.equal(page.url(), origin + '/');
		assert.equal((await snapshot(page)).blocks.find((block) => block.type === 'file').props.url, 'asset://asset-attachment');
		assert.doesNotMatch(JSON.stringify(await snapshot(page)), /data:image|base64/);
		assert.deepEqual(remote, []);
		await page.screenshot({ path: path.join(output, 'reopened.png') });
		console.log('PASS: real image block, rendered bytes, asset-only snapshot, offline new-page reopen, resolver failure unchanged, controlled attachment host call. Host resolver is a fixture; native callback and Krepis bytes are separate evidence.');
	} finally {
		await browser?.close();
		await new Promise((resolve) => server.close(resolve));
	}
}
main().catch((error) => { console.error(error); process.exitCode = 1; });



