import { spawn } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, statSync, writeFileSync } from 'node:fs';
import { createServer } from 'node:http';
import { tmpdir } from 'node:os';
import { dirname, extname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const args = process.argv.slice(2);

function option(flag, fallback = '') {
	const index = args.indexOf(flag);
	if (index === -1 || index + 1 >= args.length) return fallback;
	return args[index + 1];
}

const requestedTheme = option('--theme');
const requestedMode = option('--mode', 'dual');
const width = Number.parseInt(option('--width', '1280'), 10);
const height = Number.parseInt(option('--height', '800'), 10);

if (!Number.isFinite(width) || !Number.isFinite(height) || width < 320 || height < 240) {
	console.error(`Invalid viewport dimensions: ${width}x${height}`);
	process.exit(1);
}

const distDir = resolve(root, 'react/example/dist');
if (!existsSync(resolve(distDir, 'index.html'))) {
	console.error('Missing react/example/dist/index.html. Run: npm run build:example --prefix react');
	process.exit(1);
}

const registry = JSON.parse(readFileSync(resolve(root, 'styles/themes/index.json'), 'utf8'));
const targets = requestedTheme
	? registry.themes.filter(theme => theme.id === requestedTheme)
	: registry.themes;

if (targets.length === 0) {
	console.error(`Unknown theme ID: ${requestedTheme}`);
	process.exit(1);
}

function findBrowserExecutable() {
	const candidates = [
		process.env.CHROME_PATH,
		'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
		'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',
		'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe',
		'C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe',
		'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
		'/usr/bin/google-chrome',
		'/usr/bin/chromium',
		'/usr/bin/chromium-browser',
	].filter(Boolean);
	return candidates.find(candidate => existsSync(candidate)) || '';
}

const browserPath = findBrowserExecutable();
if (!browserPath) {
	console.error('Could not find Chrome/Edge/Chromium executable. Set CHROME_PATH environment variable.');
	process.exit(1);
}

const mimeTypes = {
	'.html': 'text/html; charset=utf-8',
	'.js': 'application/javascript; charset=utf-8',
	'.css': 'text/css; charset=utf-8',
	'.json': 'application/json; charset=utf-8',
	'.ttf': 'font/ttf',
	'.woff2': 'font/woff2',
	'.svg': 'image/svg+xml',
	'.png': 'image/png',
};

const previewDir = resolve(root, 'styles/images/previews');
mkdirSync(previewDir, { recursive: true });

// 啟動本機靜態伺服器提供 react/example/dist，確保離線環境下所有打包資源與字型可即時載入。
const server = createServer((req, res) => {
	const reqPath = decodeURIComponent((req.url || '/').split('?')[0]);
	const safePath = resolve(distDir, reqPath === '/' ? 'index.html' : reqPath.replace(/^\/+/, ''));
	if (!safePath.startsWith(distDir) || !existsSync(safePath) || statSync(safePath).isDirectory()) {
		res.writeHead(404);
		res.end('Not found');
		return;
	}
	res.writeHead(200, { 'Content-Type': mimeTypes[extname(safePath)] || 'application/octet-stream' });
	res.end(readFileSync(safePath));
});

await new Promise(resolveListen => server.listen(0, '127.0.0.1', resolveListen));
const address = server.address();
const port = typeof address === 'object' && address ? address.port : 0;

// 以 Chrome DevTools Protocol 驅動無頭瀏覽器截圖，等待字型與 React 畫面穩定後再擷取，避免 --virtual-time-budget 掛起。
const userDataDir = mkdtempSync(resolve(tmpdir(), 'klp-preview-'));
const browserArgs = [
	'--headless=new',
	'--disable-gpu',
	'--hide-scrollbars',
	'--remote-debugging-port=0',
	`--user-data-dir=${userDataDir}`,
	`--window-size=${width},${height}`,
	...(process.platform === 'win32' ? [] : ['--no-sandbox', '--disable-dev-shm-usage']),
	'about:blank',
];

const browser = spawn(browserPath, browserArgs, { stdio: ['ignore', 'ignore', 'pipe'] });

function waitForDebugPort(proc, timeoutMs = 15000) {
	return new Promise((resolvePort, rejectPort) => {
		let stderr = '';
		const timer = setTimeout(() => rejectPort(new Error(`Timed out waiting for DevTools port. stderr: ${stderr}`)), timeoutMs);
		proc.stderr.on('data', chunk => {
			stderr += chunk.toString('utf8');
			const match = stderr.match(/DevTools listening on ws:\/\/127\.0\.0\.1:(\d+)\//);
			if (match) {
				clearTimeout(timer);
				resolvePort(Number.parseInt(match[1], 10));
			}
		});
		proc.once('exit', code => {
			clearTimeout(timer);
			rejectPort(new Error(`Browser exited early (${code}). stderr: ${stderr}`));
		});
	});
}

function connectCdp(wsUrl) {
	return new Promise((resolveClient, rejectClient) => {
		const ws = new WebSocket(wsUrl);
		let nextId = 1;
		const pending = new Map();
		const listeners = new Map();

		ws.addEventListener('open', () => {
			resolveClient({
				send(method, params = {}, timeoutMs = 20000) {
					const id = nextId++;
					return new Promise((res, rej) => {
						const timer = setTimeout(() => {
							pending.delete(id);
							rej(new Error(`CDP timeout on ${method}`));
						}, timeoutMs);
						pending.set(id, { res, rej, timer });
						ws.send(JSON.stringify({ id, method, params }));
					});
				},
				onceEvent(name, timeoutMs = 20000) {
					return new Promise((res, rej) => {
						const timer = setTimeout(() => rej(new Error(`CDP event timeout on ${name}`)), timeoutMs);
						const list = listeners.get(name) ?? [];
						list.push(payload => {
							clearTimeout(timer);
							res(payload);
						});
						listeners.set(name, list);
					});
				},
				close() {
					ws.close();
				},
			});
		});
		ws.addEventListener('error', err => rejectClient(err));
		ws.addEventListener('message', event => {
			const message = JSON.parse(String(event.data));
			if (message.id && pending.has(message.id)) {
				const entry = pending.get(message.id);
				pending.delete(message.id);
				clearTimeout(entry.timer);
				if (message.error) entry.rej(new Error(message.error.message || JSON.stringify(message.error)));
				else entry.res(message.result);
				return;
			}
			if (message.method && listeners.has(message.method)) {
				const callbacks = listeners.get(message.method);
				listeners.delete(message.method);
				for (const cb of callbacks) cb(message.params);
			}
		});
	});
}

let cdp;
try {
	const debugPort = await waitForDebugPort(browser);
	const targetsRes = await fetch(`http://127.0.0.1:${debugPort}/json/list`);
	const pageTargets = await targetsRes.json();
	const pageTarget = pageTargets.find(item => item.type === 'page' && item.webSocketDebuggerUrl);
	if (!pageTarget) throw new Error('No debuggable page target returned by DevTools');

	cdp = await connectCdp(pageTarget.webSocketDebuggerUrl);
	await cdp.send('Page.enable');
	await cdp.send('Runtime.enable');
	await cdp.send('Emulation.setDeviceMetricsOverride', {
		width,
		height,
		deviceScaleFactor: 2,
		mobile: false,
	});

	for (const theme of targets) {
		const outPath = resolve(previewDir, `${theme.id}.png`);
		const url = `http://127.0.0.1:${port}/index.html?showcase=theme-preview&theme=${encodeURIComponent(theme.id)}&mode=${encodeURIComponent(requestedMode)}`;
		const loaded = cdp.onceEvent('Page.loadEventFired');
		await cdp.send('Page.navigate', { url });
		await loaded;
		await cdp.send('Runtime.evaluate', {
			expression: `(async () => {
				for (let i = 0; i < 60; i++) {
					const root = document.getElementById('root');
					if (root && root.childElementCount > 0) break;
					await new Promise(r => setTimeout(r, 50));
				}
				if (document.fonts && document.fonts.ready) await document.fonts.ready;
				await new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)));
				return true;
			})()`,
			awaitPromise: true,
		});
		const shot = await cdp.send('Page.captureScreenshot', { format: 'png' });
		writeFileSync(outPath, Buffer.from(shot.data, 'base64'));
		const bytes = statSync(outPath).size;
		if (bytes < 10 * 1024) {
			throw new Error(`Screenshot output unexpectedly small: ${outPath} (${bytes} bytes)`);
		}
		console.log(`Captured ${theme.id} preview: styles/images/previews/${theme.id}.png (${bytes} bytes)`);
	}
} finally {
	try {
		await cdp?.send('Browser.close', {}, 3000);
	} catch {}
	cdp?.close();
	try {
		if (browser.exitCode === null) browser.kill('SIGKILL');
	} catch {}
	await new Promise(resolveExit => {
		if (browser.exitCode !== null) return resolveExit();
		const timer = setTimeout(resolveExit, 2000);
		browser.once('exit', () => { clearTimeout(timer); resolveExit(); });
	});
	await new Promise(resolveClose => server.close(resolveClose));
	try {
		rmSync(userDataDir, { recursive: true, force: true, maxRetries: 5, retryDelay: 100 });
	} catch {}
}
