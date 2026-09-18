const assert = require('node:assert/strict');
const fs = require('node:fs');
const http = require('node:http');
const path = require('node:path');
const { chromium } = require(process.argv[2] || 'playwright');

const root = path.resolve(__dirname, '../assets/blocknote_editor');
const output = path.resolve(__dirname, '../build/blocknote-headless');
const mime = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.png': 'image/png', '.woff': 'font/woff', '.woff2': 'font/woff2', '.ttf': 'font/ttf' };
const fixture = {
	format: 'kallopis.blocknote', schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: [
		{ id: 'paragraph', type: 'paragraph', content: '原始中文' },
		{ id: 'list', type: 'bulletListItem', content: '清單', children: [{ id: 'nested', type: 'bulletListItem', content: '子項' }] },
		{ id: 'table', type: 'table', content: { type: 'tableContent', rows: [{ cells: ['欄位', '說明'] }, { cells: ['中文', '表格內容'] }] } },
		{ id: 'image', type: 'image', props: { url: './sample-image.png', caption: '本地圖片' } },
		{ id: 'keyboard-parent', type: 'bulletListItem', content: '鍵盤父項' },
		{ id: 'keyboard-item', type: 'bulletListItem', content: '鍵盤第二項' },
		{ id: 'paste-target', type: 'paragraph', content: '' },
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
		let page = await open(fixture, 'headless-one', 5000);
		await page.locator('[data-id="paragraph"] [contenteditable=true], [data-id="paragraph"] p').first().click();
		await settleEditing(page);
		await page.keyboard.press('End');
		await page.keyboard.insertText('，沙盒新增中文');
		await page.waitForFunction(() => window.hostMessages.some((message) => message.type === 'changed' && message.revision > 0));
		assert.equal(await page.evaluate(() => window.hostMessages.find((message) => message.type === 'changed').requestId), 5000, 'New editor must use the host-provided message sequence seed');
		// 走真正的鍵盤事件驗清單分項、縮排與上游 history，不直接改文件模型。
		await page.locator('[data-id="keyboard-item"] p').first().click();
		await page.keyboard.press('End');
		// 點擊後讓瀏覽器 selectionchange 與上游選取狀態完成同步再送結構命令。
		await settleEditing(page);
		await page.keyboard.press('Enter');
		await page.keyboard.insertText('鍵盤新增項');
		const flatten = (blocks) => blocks.flatMap((block) => [block, ...flatten(block.children || [])]);
		const containsText = (block, text) => JSON.stringify(block.content || []).includes(text);
		const entered = (await snapshot(page, 'headless-one', 10)).document;
		assert.equal(flatten(entered.blocks).find((block) => containsText(block, '鍵盤新增項')).type, 'bulletListItem');
		await page.keyboard.press('Tab');
		const indented = (await snapshot(page, 'headless-one', 11)).document;
		assert.ok(flatten(indented.blocks).find((block) => block.id === 'keyboard-item').children.some((block) => containsText(block, '鍵盤新增項')), 'Tab must indent the new item under its predecessor');
		await page.keyboard.press('Control+z');
		const undone = (await snapshot(page, 'headless-one', 12)).document;
		assert.ok(undone.blocks.some((block) => containsText(block, '鍵盤新增項')), 'Undo must restore the item to root depth');
		await page.keyboard.press('Control+Shift+z');
		const redone = (await snapshot(page, 'headless-one', 13)).document;
		assert.deepEqual(redone, indented, 'Redo must restore list nesting and text');

		// 以 clipboard event 進入上游貼上管線；此處不聲稱驗證 OS 剪貼簿。
		await page.locator('[data-id="paste-target"] p').first().click();
		await settleEditing(page);
		await page.evaluate(() => {
			const clipboardData = new DataTransfer();
			clipboardData.setData('text/plain', '跨區塊第一段\n跨區塊第二段');
			clipboardData.setData('text/html', '<p>跨區塊第一段</p><p>跨區塊第二段</p>');
			document.activeElement.dispatchEvent(new ClipboardEvent('paste', { bubbles: true, cancelable: true, clipboardData }));
		});
		const saved = await snapshot(page, 'headless-one', 20);
		const pasted = saved.document.blocks.filter((block) => block.type === 'paragraph');
		assert.ok(pasted.some((block) => containsText(block, '跨區塊第一段') && !containsText(block, '跨區塊第二段')), 'Paste must preserve the first separate paragraph');
		assert.ok(pasted.some((block) => containsText(block, '跨區塊第二段') && !containsText(block, '跨區塊第一段')), 'Paste must preserve the second separate paragraph');
		assert.equal(saved.document.format, fixture.format);
		assert.equal(saved.document.schemaVersion, 1);
		assert.equal(saved.document.blockNoteVersion, '0.54.2');
		assert.ok(saved.revision > 0);
		const blocks = saved.document.blocks;
		assert.match(JSON.stringify(blocks.find((block) => block.id === 'paragraph')), /沙盒新增中文/);
		assert.equal(blocks.find((block) => block.id === 'list').children[0].type, 'bulletListItem');
		assert.match(JSON.stringify(blocks.find((block) => block.id === 'table')), /表格內容/);
		assert.equal(blocks.find((block) => block.id === 'image').props.url, './sample-image.png');
		await page.waitForFunction(() => [...document.images].some((image) => image.src.endsWith('/sample-image.png') && image.complete && image.naturalWidth > 0));
		// 自動保存由宿主協調，正文不得保留手動儲存按鈕。
		assert.equal(await page.getByRole('button', { name: '儲存', exact: true }).count(), 0, 'Packaged editor must not expose a manual save button');

		// 以實際橋接快照重開新頁面，核對清單、表格、圖片與文字沒有流失。
		fs.writeFileSync(path.join(output, 'snapshot.json'), JSON.stringify(saved.document, null, '\t'));
		await page.close();
		page = await open(JSON.parse(fs.readFileSync(path.join(output, 'snapshot.json'), 'utf8')), 'headless-two', 9000);
		const reopened = await snapshot(page, 'headless-two', 2);
		assert.deepEqual(reopened.document, saved.document);
		await page.locator('[data-id="paragraph"] p').first().click();
		await settleEditing(page);
		await page.keyboard.press('End');
		await page.keyboard.insertText('，重開後可繼續');
		await page.waitForFunction(() => window.hostMessages.some((message) => message.type === 'changed'));
		assert.equal(await page.evaluate(() => window.hostMessages.find((message) => message.type === 'changed').requestId), 9000, 'Reopened editor must not reset change sequence to 1000');
		const editedAgain = await snapshot(page, 'headless-two', 3);
		assert.match(JSON.stringify(editedAgain.document.blocks), /重開後可繼續/);
		assert.deepEqual(remoteRequests, [], 'Packaged editor must not fetch remote dependencies');
		assert.deepEqual(errors, [], 'Packaged editor must not raise browser exceptions');
		await page.screenshot({ path: path.join(output, 'reopened.png'), fullPage: true });
		// 在獨立頁面輸入 Markdown 快捷鍵，不改動既有保存與清單 fixture。
		const shortcutPage = await open(fixture, 'headless-shortcut', 12000);
		await shortcutPage.locator('[data-id="paste-target"] p').first().click();
		await settleEditing(shortcutPage);
		await shortcutPage.keyboard.type('# ');
		await shortcutPage.keyboard.insertText('快捷標題');
		const shortcut = await snapshot(shortcutPage, 'headless-shortcut', 2);
		assert.equal(shortcut.document.blocks.find((block) => containsText(block, '快捷標題')).type, 'heading', 'Markdown heading shortcut must transform the paragraph');
		await shortcutPage.close();
		console.log('PASS: packaged assets, bridge, Chinese insertion, Markdown shortcut, list Enter/Tab/undo/redo, cross-block paste, table/local image snapshot, no manual save button and new-page reopen');
		console.log('LIMIT: headless Chromium host simulation; no native WebView, OS IME or durable host adapter claim');
	} finally {
		fs.writeFileSync(path.join(output, 'diagnostics.json'), JSON.stringify({ errors, remoteRequests }, null, '\t'));
		if (browser) await browser.close();
		await new Promise((resolve) => server.close(resolve));
	}
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
