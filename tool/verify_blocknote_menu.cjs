const assert = require('node:assert/strict');
const fs = require('node:fs');
const http = require('node:http');
const { chromium } = require('C:/Users/ASUS_TUF/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
(async () => {
	const server = http.createServer((req, res) => { res.setHeader('Content-Type', 'text/html'); res.end(fs.readFileSync('D:/Projects/Kallopis/assets/blocknote_editor/index.html')); });
	await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
	const browser = await chromium.launch({headless: true, executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
	try {
		const page = await browser.newPage();
		const errors = [];
		page.on('pageerror', error => errors.push(String(error)));
		await page.addInitScript(() => {
			window.messages = [];
			window.menuCalls = [];
			window.flutter_inappwebview = {callHandler: async (name, data) => {
				if (name === 'KallopisMenu') {
					window.menuCalls.push(data);
					document.activeElement?.blur();
					await new Promise(resolve => setTimeout(resolve, 100));
					const target = window.menuCalls.length === 1 ? 'Heading 2' : window.menuCalls.length === 2 ? 'Colors' : 'Text · Red';
				return data.items.findIndex(item => item.title === target);
				}
				window.messages.push(data);
			}};
		});
		await page.goto(`http://127.0.0.1:${server.address().port}`);
		await page.waitForFunction(() => !!window.kallopisBlockNote);
		await page.evaluate(() => window.kallopisBlockNote.receive({protocolVersion: 1, type: 'open', sessionId: 'test', requestId: 1, revision: 0, document: {format: 'kallopis.blocknote', schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: [{id:'body',type:'paragraph',content:''}]}}));
		const editor = page.locator('[contenteditable=true]').first();
		await editor.click();
		await page.keyboard.type('/');
		await page.waitForFunction(() => window.menuCalls.length === 1);
		await page.waitForFunction(() => !!document.querySelector('[data-content-type=heading][data-level="2"]'));
		await page.evaluate(() => window.kallopisBlockNote.receive({protocolVersion:1,type:'snapshot.request',sessionId:'test',requestId:9,revision:0}));
		const snapshot = await page.evaluate(() => window.messages.find(message => message.requestId === 9));
		const blockItems = await page.evaluate(() => window.menuCalls[0].items);
		assert.equal(blockItems[0].group, 'Headings');
		assert.equal(blockItems[0].description, 'Top-level heading');
		assert.match(blockItems[0].iconSvg, /<svg/);
		require('node:fs').mkdirSync('build/menu-review', {recursive: true});
		require('node:fs').writeFileSync('build/menu-review/block-items.json', JSON.stringify(blockItems));
		assert.equal(snapshot.document.blocks[0].type, 'heading');
		assert.equal(snapshot.document.blocks[0].props.level, 2);
		assert.equal(snapshot.document.blocks[0].content.length, 0);
		await page.locator('[data-id=body]').first().hover();
		await page.waitForTimeout(300);
		await page.getByRole('button', {name:'Open block menu', exact:true}).click();
		await page.waitForFunction(() => window.menuCalls.length === 3);
		console.log(await page.evaluate(() => window.menuCalls.map(call => call.items.map(item => item.title))));
		await page.waitForFunction(() => !!document.querySelector('[data-content-type=heading][data-text-color=red]'));
		assert.deepEqual(errors, []);
		console.log('PASS: slash menu routed to host, selection after blur creates H2 and removes trigger; no page errors');
	} finally { await browser.close(); server.close(); }
})().catch(error => { console.error(error); process.exitCode = 1; });