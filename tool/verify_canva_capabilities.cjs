const assert = require('node:assert/strict');
const fs = require('node:fs');
const http = require('node:http');
const path = require('node:path');
const { chromium } = require(process.argv[2] || 'playwright');

const root = path.resolve(__dirname, '../assets/canva_editor');
const output = path.resolve(__dirname, '../build/canva-capabilities');
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
			await page.evaluate((command) => window.kallopisCanva.receive(command), { protocolVersion: 1, type: 'open', projectId: 'capability-project', sessionId, requestId: 1, revision: 0, document });
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
		const page = await open(empty, 'capabilities');
		await page.keyboard.press('r');
		await drag(page, [400, 300], [550, 400]);
		await page.keyboard.press('r');
		await drag(page, [750, 450], [900, 550]);
		await page.keyboard.press('v');
		await page.keyboard.press('Control+a');
		await page.keyboard.press('Control+g');
		const grouped = await snapshot(page, 'capabilities');
		const rectangles = grouped.elements.filter((element) => element.type === 'rectangle' && !element.isDeleted);
		assert.equal(rectangles.length, 2);
		assert.equal(rectangles[0].groupIds.length, 1);
		assert.deepEqual(rectangles[0].groupIds, rectangles[1].groupIds);
		await page.keyboard.press('Control+Shift+g');
		const ungrouped = await snapshot(page, 'capabilities');
		assert.ok(ungrouped.elements.every((element) => element.groupIds.length === 0));
		await page.keyboard.press('Escape');
		await page.keyboard.press('t');
		await page.mouse.click(650, 650);
		await page.keyboard.insertText('可編輯中文');
		await page.keyboard.press('Escape');
		const text = await snapshot(page, 'capabilities');
		assert.ok(text.elements.some((element) => element.type === 'text' && element.text === '可編輯中文'));
		await page.keyboard.press('v');
		await page.mouse.click(450, 300, { button: 'right' });
		await page.getByText('Bring to front', { exact: true }).click();
		const layered = await snapshot(page, 'capabilities');
		assert.equal(layered.elements.at(-1).id, rectangles[0].id);
		// 真選取控制點調整尺寸，不直接寫入場景模型。
		await drag(page, [398, 298], [350, 250]);
		const resized = await snapshot(page, 'capabilities');
		let resizedShape = resized.elements.find((element) => element.id === rectangles[0].id);
		assert.ok(resizedShape.width > rectangles[0].width && resizedShape.height > rectangles[0].height);
		await page.screenshot({ path: path.join(output, 'rotate-before.png') });
		await drag(page, [451, 232], [560, 326]);
		const rotated = await snapshot(page, 'capabilities');
		assert.notEqual(rotated.elements.find((element) => element.id === rectangles[0].id).angle, 0);
		resizedShape = rotated.elements.find((element) => element.id === rectangles[0].id);
		await page.keyboard.press('Control+Shift+l');
		const locked = await snapshot(page, 'capabilities');
		assert.equal(locked.elements.find((element) => element.id === rectangles[0].id).locked, true);
		await page.keyboard.press('Escape');
		await page.mouse.click(1100, 750);
		await drag(page, [450, 252], [450, 202]);
		const afterDrag = await snapshot(page, 'capabilities');
		const fixed = afterDrag.elements.find((element) => element.id === rectangles[0].id);
		assert.deepEqual([fixed.x, fixed.y, fixed.width, fixed.height], [resizedShape.x, resizedShape.y, resizedShape.width, resizedShape.height]);
		fs.writeFileSync(path.join(output, 'snapshot.json'), JSON.stringify(afterDrag, null, '\t'));
		await page.close();
		const reopened = await open(afterDrag, 'capabilities-reopen');
		const restored = await snapshot(reopened, 'capabilities-reopen');
		const durableFields = (elements) => elements.map(({ id, type, x, y, width, height, angle, text, groupIds, locked, isDeleted }) => ({ id, type, x, y, width, height, angle, text, groupIds, locked, isDeleted }));
		assert.deepEqual(durableFields(restored.elements), durableFields(afterDrag.elements));

		await reopened.screenshot({ path: path.join(output, 'capabilities.png') });
		const arrangement = await open(empty, 'arrangement');
		for (const [from, to] of [[[350, 300], [450, 380]], [[600, 440], [700, 520]], [[1000, 350], [1100, 430]]]) {
			await arrangement.keyboard.press('r');
			await drag(arrangement, from, to);
		}
		await arrangement.keyboard.press('v');
		await arrangement.keyboard.press('Control+a');
		await arrangement.getByRole('button', { name: 'Align top', exact: true }).click();
		await arrangement.getByRole('button', { name: 'Distribute horizontally', exact: true }).click();
		const arranged = await snapshot(arrangement, 'arrangement');
		const shapes = arranged.elements.filter((element) => element.type === 'rectangle').sort((a, b) => a.x - b.x);
		assert.equal(new Set(shapes.map((element) => element.y)).size, 1);
		assert.ok(Math.abs((shapes[1].x - shapes[0].x - shapes[0].width) - (shapes[2].x - shapes[1].x - shapes[1].width)) < 0.01);
		await arrangement.mouse.click(400, 300, { button: 'right' });
		await arrangement.getByText('Wrap selection in frame', { exact: true }).click();
		const framed = await snapshot(arrangement, 'arrangement');
		const frame = framed.elements.find((element) => element.type === 'frame');
		assert.ok(frame);
		assert.ok(framed.elements.filter((element) => element.type === 'rectangle').every((element) => element.frameId === frame.id));
		await arrangement.getByText('Frame', { exact: true }).dblclick();
		await arrangement.locator('input[value="Frame"]').fill('命名區塊');
		await arrangement.keyboard.press('Enter');
		const named = await snapshot(arrangement, 'arrangement');
		assert.equal(named.elements.find((element) => element.id === frame.id).name, '命名區塊');
		await arrangement.keyboard.press('Escape');
		await arrangement.screenshot({ path: path.join(output, 'image-picker.png') });
		// 進入正式clipboard貼上管線；不冒稱驗證OS檔案選擇器。
		await arrangement.mouse.click(750, 650);
		await arrangement.evaluate((base64) => {
			const bytes = Uint8Array.from(atob(base64), (value) => value.charCodeAt(0));
			const transfer = new DataTransfer();
			transfer.items.add(new File([bytes], '圖片.png', { type: 'image/png' }));
			document.activeElement.dispatchEvent(new ClipboardEvent('paste', { clipboardData: transfer, bubbles: true, cancelable: true }));
		}, fs.readFileSync(path.resolve(__dirname, '../assets/blocknote_editor/sample-image.png')).toString('base64'));
		await arrangement.waitForTimeout(400);
		const withImage = await snapshot(arrangement, 'arrangement');
		const insertedImage = withImage.elements.find((element) => element.type === 'image' && !element.isDeleted);
		assert.ok(insertedImage?.fileId && withImage.files[insertedImage.fileId]);
		fs.writeFileSync(path.join(output, 'arrangement.json'), JSON.stringify(withImage, null, '\t'));
		const arrangementReopen = await open(withImage, 'arrangement-reopen');
		const recovered = await snapshot(arrangementReopen, 'arrangement-reopen');
		assert.equal(recovered.elements.find((element) => element.id === frame.id).name, '命名區塊');
		assert.deepEqual(recovered.files, withImage.files);
		assert.equal(recovered.elements.find((element) => element.id === insertedImage.id).fileId, insertedImage.fileId);
		await arrangement.screenshot({ path: path.join(output, 'frame.png') });
		const connections = await open(empty, 'connections');
		await connections.keyboard.press('r');
		await drag(connections, [400, 300], [550, 400]);
		await connections.keyboard.press('r');
		await drag(connections, [750, 300], [900, 400]);
		await connections.keyboard.press('a');
		await drag(connections, [550, 350], [750, 350]);
		await connections.keyboard.press('v');
		await connections.mouse.dblclick(650, 350);
		await connections.keyboard.insertText('連線文字');
		await connections.keyboard.press('Escape');
		const labeled = await snapshot(connections, 'connections');
		const arrow = labeled.elements.find((element) => element.type === 'arrow' && !element.isDeleted);
		const label = labeled.elements.find((element) => element.type === 'text' && element.text === '連線文字');
		assert.equal(label?.containerId, arrow.id);
		assert.ok(arrow.startBinding && arrow.endBinding);
		await connections.keyboard.press('v');
		await drag(connections, [475, 300], [475, 450]);
		const followed = await snapshot(connections, 'connections');
		const movedArrow = followed.elements.find((element) => element.id === arrow.id);
		assert.deepEqual(movedArrow.startBinding, arrow.startBinding);
		assert.deepEqual(movedArrow.endBinding, arrow.endBinding);
		assert.notDeepEqual([movedArrow.x, movedArrow.y, movedArrow.points], [arrow.x, arrow.y, arrow.points]);
		assert.equal(followed.elements.find((element) => element.id === label.id).containerId, arrow.id);
		fs.writeFileSync(path.join(output, 'connections.json'), JSON.stringify(followed, null, '\t'));
		await connections.screenshot({ path: path.join(output, 'connections.png') });
		// 真MainMenu到host請求；只有host committed才可移除來源。
		await connections.evaluate(() => window.kallopisCanva.receive({ protocolVersion: 1, type: 'transfer.targets', sessionId: 'connections', requestId: 901, revision: 0, transferTargets: [{ documentId: 'target-page', name: '目標頁' }] }));
		await connections.keyboard.press('Escape');
		await connections.keyboard.press('Control+a');
		await snapshot(connections, 'connections');
		await connections.getByTestId('main-menu-trigger').click();
		await connections.getByText('移動到「目標頁」', { exact: true }).click();
		await connections.waitForFunction(() => window.hostMessages.some((message) => message.type === 'transfer.request'), null, { timeout: 5000 });
		const request = await connections.evaluate(() => window.hostMessages.find((message) => message.type === 'transfer.request'));
		assert.equal(request.targetDocumentId, 'target-page');
		assert.equal(request.mode, 'move');
		assert.ok(request.sourceElementIds.includes(arrow.id) && request.sourceElementIds.includes(label.id));
		assert.deepEqual((await snapshot(connections, 'connections')).elements, followed.elements, 'Request alone must never delete source');
		await connections.evaluate((request) => window.kallopisCanva.receive({ protocolVersion: 1, type: 'transfer.failed', sessionId: 'connections', requestId: 902, revision: 0, operationId: request.operationId }), request);
		assert.deepEqual((await snapshot(connections, 'connections')).elements, followed.elements, 'Failed target must leave source unchanged');
		await connections.evaluate((request) => window.kallopisCanva.receive({ protocolVersion: 1, type: 'transfer.committed', sessionId: 'connections', requestId: 903, revision: 0, operationId: request.operationId, mode: 'move', sourceElementIds: request.sourceElementIds }), request);
		const committed = await snapshot(connections, 'connections');
		assert.ok(committed.elements.every((element) => !request.sourceElementIds.includes(element.id)), 'Committed move must remove source IDs including tombstones');
		assert.deepEqual(errors, []);
		assert.deepEqual(remote, []);
		console.log('PASS: real selection grouping/ungrouping Chinese text input, layer order, resize/rotate, locked movement rejection, align/distribute, named frame, image paste, bound connection label/follow reopen and MainMenu transfer failure/commit');
	} finally {
		if (browser) await browser.close();
		await new Promise((resolve) => server.close(resolve));
	}
}
main().catch((error) => { console.error(error); process.exitCode = 1; });










