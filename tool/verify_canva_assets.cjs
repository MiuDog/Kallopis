const assert = require('node:assert/strict');
const fs = require('node:fs');
const http = require('node:http');
const path = require('node:path');
const { chromium } = require(process.argv[2] || 'playwright');

const root = path.resolve(__dirname, '../assets/canva_editor');
const output = path.resolve(__dirname, '../build/canva-headless');
const empty = { format: 'krepis.canva.excalidraw', schemaVersion: 1, elements: [], appState: {}, files: {} };

async function main() {
	// 隔離瀏覽器僅提供目前正式打包資產，不讀取使用者瀏覽資料。
	fs.mkdirSync(output, { recursive: true });
	const server = http.createServer((request, response) => {
		const target = path.resolve(root, '.' + new URL(request.url, 'http://localhost').pathname.replace(/\/$/, '/index.html'));
		if (!target.startsWith(root + path.sep) || !fs.existsSync(target)) {
			response.writeHead(404).end();
			return;
		}
		const mime = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.woff2': 'font/woff2' };
		response.setHeader('Content-Type', mime[path.extname(target)] || 'application/octet-stream');
		fs.createReadStream(target).pipe(response);
	});
	await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
	const origin = `http://127.0.0.1:${server.address().port}`;
	const errors = [];
	const remote = [];
	let browser;
	try {
		browser = await chromium.launch({ headless: true, ...(process.argv[3] ? { executablePath: process.argv[3] } : {}) });
		const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
		await context.addInitScript(() => {
			window.hostMessages = [];
			window.flutter_inappwebview = { callHandler: async (_, message) => window.hostMessages.push(message) };
		});
		context.on('request', (request) => {
			if (/^https?:/.test(request.url()) && !request.url().startsWith(origin)) remote.push(request.url());
		});
		async function open(document, sessionId) {
			const page = await context.newPage();
			page.on('pageerror', (error) => errors.push(String(error)));
			await page.goto(origin);
			await page.waitForFunction(() => typeof window.kallopisCanva?.receive === 'function');
			await page.evaluate((command) => window.kallopisCanva.receive(command), { protocolVersion: 1, type: 'open', sessionId, requestId: 1, revision: 0, document });
			await page.waitForFunction((sessionId) => window.hostMessages.some((message) => message.type === 'ready' && message.sessionId === sessionId), sessionId);
			await page.locator('canvas').first().waitFor({ state: 'visible' });
			await page.waitForTimeout(250);
			return page;
		}
		let requestId = 10;
		async function snapshot(page, sessionId) {
			await page.waitForTimeout(150);
			const id = ++requestId;
			await page.evaluate((command) => window.kallopisCanva.receive(command), { protocolVersion: 1, type: 'snapshot.request', sessionId, requestId: id, revision: 0 });
			await page.waitForFunction((id) => window.hostMessages.some((message) => message.type === 'snapshot.response' && message.requestId === id), id);
			return page.evaluate((id) => window.hostMessages.find((message) => message.type === 'snapshot.response' && message.requestId === id).document, id);
		}
		async function drag(page, from, to) {
			await page.mouse.move(...from);
			await page.mouse.down();
			await page.mouse.move(...to, { steps: 10 });
			await page.mouse.up();
		}
		const page = await open(empty, 'canva-one');
		await page.keyboard.press('r');
		await drag(page, [400, 300], [550, 400]);
		fs.writeFileSync(path.join(output, 'first.json'), JSON.stringify(await snapshot(page, 'canva-one'), null, '\t'));
		await page.keyboard.press('r');
		await drag(page, [750, 300], [900, 400]);
		const created = await snapshot(page, 'canva-one');
		fs.writeFileSync(path.join(output, 'created.json'), JSON.stringify(created, null, '\t'));
		await page.screenshot({ path: path.join(output, 'created.png') });
		assert.equal(created.elements.filter((element) => !element.isDeleted && element.type === 'rectangle').length, 2, 'Real pointer input must create two shapes');
		const first = created.elements.find((element) => element.type === 'rectangle');

		// 經滑鼠選取移動及連線，不透過引擎私有 API 修改場景。
		await page.keyboard.press('v');
		await drag(page, [475, 300], [475, 450]);
		const moved = await snapshot(page, 'canva-one');
		assert.ok(moved.elements.find((element) => element.id === first.id).y > first.y + 100, 'Pointer move must change the selected shape geometry');
		await page.keyboard.press('a');
		await drag(page, [550, 500], [750, 350]);
		const connected = await snapshot(page, 'canva-one');
		const arrow = connected.elements.find((element) => element.type === 'arrow' && !element.isDeleted);
		assert.ok(arrow?.startBinding && arrow?.endBinding, 'Arrow endpoints must bind to the two shapes');
		await page.keyboard.press('Control+z');
		const undone = await snapshot(page, 'canva-one');
		assert.ok(!undone.elements.some((element) => element.id === arrow.id && !element.isDeleted), 'Undo must remove the latest connection');
		await page.keyboard.press('Control+Shift+z');
		const redone = await snapshot(page, 'canva-one');
		assert.ok(redone.elements.some((element) => element.id === arrow.id && !element.isDeleted), 'Redo must restore the connection');
		assert.equal(await page.getByRole('button', { name: '儲存', exact: true }).count(), 0);

		// 真快照寫檔後以全新頁面重開，核對形狀位置與連線身分。
		fs.writeFileSync(path.join(output, 'snapshot.json'), JSON.stringify(redone, null, '\t'));
		await page.screenshot({ path: path.join(output, 'edited.png') });
		await page.close();
		const reopened = await open(JSON.parse(fs.readFileSync(path.join(output, 'snapshot.json'), 'utf8')), 'canva-two');
		const restored = await snapshot(reopened, 'canva-two');
		const geometry = (document) => document.elements.filter((element) => !element.isDeleted).map(({ id, type, x, y, width, height, startBinding, endBinding }) => ({ id, type, x, y, width, height, startBinding, endBinding }));
		assert.deepEqual(geometry(restored), geometry(redone), 'Reopen must preserve geometry and connection bindings');

		// 從產品選單新增便利貼，隱藏後必須保留可重開／恢復的完整場景資料。
		async function menu(page, label) {
			await page.getByTestId('main-menu-trigger').click();
			await page.getByText(label, { exact: true }).click();
		}
		await menu(reopened, '新增便利貼');
		const sticky = await snapshot(reopened, 'canva-two');
		const stickyText = sticky.elements.find((element) => element.type === 'text' && element.text === '便利貼' && !element.isDeleted);
		assert.ok(stickyText?.containerId, 'Sticky note must contain editable text bound to its shape');
		assert.ok(sticky.elements.some((element) => element.id === stickyText.containerId && element.backgroundColor !== 'transparent'), 'Sticky note must retain its filled container');
		await reopened.mouse.click(320, 270);
		await reopened.keyboard.press('Escape');
		await reopened.keyboard.press('Control+a');
		await menu(reopened, '隱藏選取物件');
		const hidden = await snapshot(reopened, 'canva-two');
		fs.writeFileSync(path.join(output, 'hidden-attempt.json'), JSON.stringify(hidden, null, '\t'));
		const hiddenIds = hidden.elements.filter((element) => element.customData?.planistHidden).map((element) => element.id);
		assert.ok(hiddenIds.includes(stickyText.id) && hiddenIds.includes(stickyText.containerId), 'Hide must retain the sticky text and container identities');
		assert.ok(hidden.elements.filter((element) => hiddenIds.includes(element.id)).every((element) => element.isDeleted), 'Hidden elements must not remain visible');
		fs.writeFileSync(path.join(output, 'hidden.json'), JSON.stringify(hidden, null, '\t'));
		await reopened.close();
		const hiddenPage = await open(JSON.parse(fs.readFileSync(path.join(output, 'hidden.json'), 'utf8')), 'canva-hidden');
		const hiddenReopen = await snapshot(hiddenPage, 'canva-hidden');
		assert.deepEqual(hiddenReopen.elements.filter((element) => element.customData?.planistHidden).map((element) => element.id).sort(), [...hiddenIds].sort(), 'Reopen must preserve hidden elements instead of permanently deleting them');
		await menu(hiddenPage, '顯示隱藏物件');
		const shown = await snapshot(hiddenPage, 'canva-hidden');
		assert.ok(hiddenIds.every((id) => shown.elements.some((element) => element.id === id && !element.isDeleted && !element.customData?.planistHidden)), 'Show must restore every hidden element with its original identity');
		assert.equal(shown.elements.find((element) => element.id === stickyText.id).text, '便利貼');
		assert.deepEqual(errors, [], 'Packaged Canva must not throw browser errors');
		assert.deepEqual(remote, [], 'Packaged Canva must remain offline');
		await hiddenPage.screenshot({ path: path.join(output, 'reopened.png') });
		console.log('PASS: packaged Excalidraw shape creation, move, bound connection, undo/redo, sticky note, hide/show and snapshot new-page reopen');
		console.log('LIMIT: headless browser host simulation, not Planist native WebView or production repository');
	}
	finally {
		fs.writeFileSync(path.join(output, 'diagnostics.json'), JSON.stringify({ errors, remote }, null, '\t'));
		if (browser) await browser.close();
		await new Promise((resolve) => server.close(resolve));
	}
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
