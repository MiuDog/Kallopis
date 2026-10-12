import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import test from 'node:test';
import { validateFlutterScenarios, renderFlutterScenario, validateFlutterBundle } from '../flutter-scenarios.mjs';

function registry() {
	return {
		'zulu-8': { title: 'Zulu 工作區', reference: 'https://official.test/zulu?view=wide&lang=zh' },
		alpha: { title: 'Alpha 工作區', reference: 'https://official.test/alpha' },
		'paper-plane': { title: 'Paper 工作區', reference: 'https://official.test/paper#layout' },
		beta: { title: 'Beta 工作區', reference: 'https://official.test/beta' },
	};
}

function expectedScenes(input) {
	return Object.entries(input).sort(([left], [right]) => left.localeCompare(right)).map(([id, entry]) => ({
		id, title: entry.title, reference: entry.reference, href: `docs/flutter/scenarios/${id}.html`,
	}));
}

function decodeHtml(value) {
	return value.replace(/&(#x[\da-f]+|#\d+|amp|lt|gt|quot|apos);/gi, (_, entity) => {
		if (entity.startsWith('#x')) return String.fromCodePoint(parseInt(entity.slice(2), 16));
		if (entity.startsWith('#')) return String.fromCodePoint(Number(entity.slice(1)));
		return { amp: '&', lt: '<', gt: '>', quot: '"', apos: "'" }[entity.toLowerCase()];
	});
}

function attribute(tag, name) {
	const match = tag.match(new RegExp(`\\b${name}\\s*=\\s*(["'])(.*?)\\1`, 'is'));
	assert.ok(match, `公開 HTML 必須提供 ${name} 屬性`);
	return decodeHtml(match[2]);
}

test('任意非空 own metadata 產生排序 DTO 並保留來源', () => {
	const input = Object.assign(Object.create({ ghost: registry().alpha }), registry());
	const before = JSON.stringify(input);
	assert.deepEqual(validateFlutterScenarios(input), expectedScenes(input));
	assert.equal(JSON.stringify(input), before);
	assert.deepEqual(validateFlutterScenarios({ solo: registry().alpha }), expectedScenes({ solo: registry().alpha }));
});

test('拒絕非法 metadata、route、title、HTTPS authority 及重複 title', () => {
	const entry = registry().alpha;
	const invalid = [null, [], 'scene', {}, Object.create({ ghost: entry })];
	for (const id of ['', 'Alpha', '7alpha', '../alpha', 'alpha/beta', 'alpha_beta', 'alpha?x', '場景']) invalid.push({ [id]: entry });
	for (const title of ['', '   ', null, 42]) invalid.push({ alpha: { ...entry, title } });
	for (const reference of ['', 'not-a-url', 'http://official.test/alpha', 'javascript:alert(1)', '/alpha', 'https:///alpha', 'https:', null, 42]) {
		invalid.push({ alpha: { ...entry, reference } });
	}
	invalid.push({ alpha: null }, { alpha: 'scene' }, { alpha: {} }, { alpha: entry, beta: { ...entry } });
	for (const input of invalid) assert.throws(() => validateFlutterScenarios(input), `非法輸入必須拒絕：${JSON.stringify(input)}`);
});

function assertSceneHtml(html, scene, bundleUrl) {
	assert.doesNotMatch(html, /<script>bad\(\)<\/script>/i);
	const frames = html.match(/<iframe\b[^>]*>/gi) ?? [];
	assert.equal(frames.length, 1);
	assert.equal(attribute(frames[0], 'title'), `${scene.title} Flutter 互動展示`);
	assert.equal(attribute(frames[0], 'src'), bundleUrl);
	assert.match(html, /\bdata-component-specimen(?:\s|=|>)/i);
	assert.match(html, /\bdata-specimen-framework\s*=\s*(["'])flutter\1/i);
	assert.match(html, /\bdata-specimen-state\s*=\s*(["'])loading\1/i);
	const links = html.match(/<a\b[^>]*>/gi) ?? [];
	assert.ok(links.some((tag) => attribute(tag, 'href') === bundleUrl), '保留同 query 獨立入口');
	const official = links.find((tag) => attribute(tag, 'href') === scene.reference);
	assert.ok(official, '保留官方 reference');
	assert.ok(attribute(official, 'rel').split(/\s+/).includes('noopener'));
}

test('render 安全 title、具名 iframe、Flutter marker、loading 與官方連結', () => {
	const scene = { id: 'alpha', title: '場景 " & <script>bad()</script>', reference: 'https://official.test/alpha?x=%22&lang=zh', href: 'docs/flutter/scenarios/alpha.html' };
	const bundleUrl = '../../../examples/flutter/index.html?scenario=alpha&mode="wide"';
	const html = renderFlutterScenario(scene, bundleUrl);
	assert.equal(typeof html, 'string');
	assert.ok(decodeHtml(html).includes(scene.title));
	assertSceneHtml(html, scene, bundleUrl);
});

function tempDirectory(t) {
	const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'kallopis-flutter-scenes-contract-'));
	assert.ok(directory.startsWith(path.join(path.resolve(os.tmpdir()), 'kallopis-flutter-scenes-contract-')));
	t.after(() => fs.rmSync(directory, { recursive: true, force: true }));
	return directory;
}

function writeFile(directory, relative, contents) {
	const target = path.join(directory, relative);
	fs.mkdirSync(path.dirname(target), { recursive: true });
	fs.writeFileSync(target, contents);
}

function writeBundle(directory, input) {
	const files = {
		'index.html': '<!doctype html><html><head><base href="/Kallopis/examples/flutter/"><title>初始 shell</title></head><body><script src="flutter_bootstrap.js" async></script></body></html>',
		'flutter_bootstrap.js': 'window.fixtureBootstrap = true;',
		'main.dart.js': 'window.fixtureMain = true;',
		'assets/FontManifest.json': JSON.stringify([{ family: 'packages/fixture/Typeface', fonts: [{ asset: 'packages/fixture/fonts/regular.otf' }, { asset: 'packages/fixture/fonts/bold.otf' }] }]),
		'assets/assets/gui-scenarios.json': JSON.stringify(input),
		'assets/packages/fixture/fonts/regular.otf': Buffer.from([0, 1, 255, 42]),
		'assets/packages/fixture/fonts/bold.otf': Buffer.from([0, 2, 254, 43]),
		'assets/other.bin': Buffer.from([17, 18, 19]),
	};
	for (const [relative, contents] of Object.entries(files)) writeFile(directory, relative, contents);
	return files;
}

test('公開 bundle validator 接受完整 prefix bundle 並驗證每筆 package font', (t) => {
	const directory = tempDirectory(t);
	const input = registry();
	writeBundle(directory, input);
	assert.doesNotThrow(() => validateFlutterBundle(directory, input));
	for (const relative of ['index.html', 'flutter_bootstrap.js', 'main.dart.js', 'assets/FontManifest.json', 'assets/assets/gui-scenarios.json', 'assets/packages/fixture/fonts/regular.otf', 'assets/packages/fixture/fonts/bold.otf']) {
		writeBundle(directory, input);
		fs.rmSync(path.join(directory, relative));
		assert.throws(() => validateFlutterBundle(directory, input), `${relative} 缺失必須拒絕`);
	}
});

test('公開 bundle validator 拒絕錯 prefix、metadata 差異及越界 font 路徑', (t) => {
	const directory = tempDirectory(t);
	const input = registry();
	const mutations = [
		['index.html', '<html><head><base href="/"></head></html>'],
		['index.html', '<html><head><title>缺少 base</title></head></html>'],
		['assets/assets/gui-scenarios.json', JSON.stringify({ ...input, alpha: { ...input.alpha, title: '另一來源' } })],
		['assets/FontManifest.json', '{'],
	];
	for (const asset of ['../outside.otf', '/outside.otf', 'C:/outside.otf', 'packages/fixture/../../../../outside.otf', '..\\outside.otf']) {
		mutations.push(['assets/FontManifest.json', JSON.stringify([{ family: '任意字型', fonts: [{ asset }] }])]);
	}
	for (const [relative, contents] of mutations) {
		writeBundle(directory, input);
		writeFile(directory, relative, contents);
		assert.throws(() => validateFlutterBundle(directory, input), `${relative} 不合法必須拒絕`);
	}
});

function cliSandbox(t) {
	// 公開工具與來源複製至測試持有的暫存目錄，不讀產品實作。
	const root = path.resolve(import.meta.dirname, '../../..');
	const directory = tempDirectory(t);
	for (const entry of ['docs', 'spec', 'tool/reference_site', 'README.md', 'CHANGELOG.md']) fs.cpSync(path.join(root, entry), path.join(directory, entry), { recursive: true });
	const write = (relative, contents) => writeFile(directory, relative, contents);
	write('build/reference-api.json', fs.readFileSync(path.join(import.meta.dirname, 'fixtures/reference-api.json')));
	const input = registry();
	const writeRegistry = (value) => write('flutter/example/assets/gui-scenarios.json', JSON.stringify(value));
	const bundle = path.join(directory, 'flutter/example/build/web');
	writeRegistry(input);
	const bundleFiles = writeBundle(bundle, input);
	write('react/build/reference-components.json', JSON.stringify({ schemaVersion: 1, framework: 'react', entrypoint: '@kallopis/react', components: [{ id: '@kallopis/react#Alpha', name: 'Alpha', source: 'public/example.d.ts', signature: 'declare function Alpha(): React.JSX.Element;', propsType: '' }] }));
	write('react/example/specimen-registry.mjs', 'export const reactSpecimenRegistry = { Alpha: "basic" };\n');
	write('react/example/scenario-registry.mjs', `export const reactScenarioRegistry = ${JSON.stringify(input)};\n`);
	write('react/example/dist/index.html', '<html><body><script src="./assets/example.js"></script></body></html>');
	write('react/example/dist/assets/example.js', 'window.fixtureReact = true;');
	return {
		directory, input, write, writeRegistry, bundle, bundleFiles, site: path.join(directory, 'build/reference-site'),
		run(script, flags = ['--flutter-scenes']) { return spawnSync(process.execPath, [`tool/reference_site/${script}.mjs`, ...flags], { cwd: directory, encoding: 'utf8' }); },
	};
}

function cliSucceeds(result) { assert.equal(result.status, 0, result.stderr || result.stdout); }
function cliFails(result, message) { assert.notEqual(result.status, 0, `${message}\n${result.stdout}\n${result.stderr}`); }

function outputHashes(directory, relative = '') {
	return fs.readdirSync(path.join(directory, relative), { withFileTypes: true }).flatMap((entry) => {
		const target = path.join(relative, entry.name);
		if (entry.isDirectory()) return outputHashes(directory, target);
		return [[target, createHash('sha256').update(fs.readFileSync(path.join(directory, target))).digest('hex')]];
	}).sort(([left], [right]) => left.localeCompare(right));
}

function linksTo(html, base, target) {
	return (html.match(/<a\b[^>]*>/gi) ?? []).some((tag) => new URL(attribute(tag, 'href'), base).pathname === target);
}

test('--flutter-scenes 單獨交付完整索引、docs、search、manifest 與每筆 bundle bytes', (t) => {
	const env = cliSandbox(t);
	cliSucceeds(env.run('generate'));
	cliSucceeds(env.run('verify'));
	const scenes = expectedScenes(env.input);
	const manifest = JSON.parse(fs.readFileSync(path.join(env.site, 'site-manifest.json'), 'utf8'));
	assert.deepEqual(manifest.flutterScenarios, scenes);
	const search = JSON.parse(fs.readFileSync(path.join(env.site, 'search-index.json'), 'utf8')).filter((entry) => entry.category === 'Flutter Scenario');
	assert.equal(search.length, scenes.length);
	const index = fs.readFileSync(path.join(env.site, 'docs/flutter/scenarios/index.html'), 'utf8');
	const docs = fs.readFileSync(path.join(env.site, 'docs/index.html'), 'utf8');
	assert.ok(linksTo(docs, 'https://example.test/Kallopis/docs/index.html', '/Kallopis/docs/flutter/scenarios/index.html'));
	for (const scene of scenes) {
		const result = search.find((entry) => entry.apiId === scene.id);
		assert.ok(result, `${scene.id} 可搜尋`);
		assert.equal(result.title, scene.title);
		assert.equal(result.href, scene.href);
		assert.ok(linksTo(index, 'https://example.test/Kallopis/docs/flutter/scenarios/index.html', `/Kallopis/${scene.href}`));
		const html = fs.readFileSync(path.join(env.site, scene.href), 'utf8');
		const frame = html.match(/<iframe\b[^>]*>/i)[0];
		const url = attribute(frame, 'src');
		assertSceneHtml(html, scene, url);
		const target = new URL(url, `https://example.test/Kallopis/${scene.href}`);
		assert.equal(target.pathname, '/Kallopis/examples/flutter/index.html');
		assert.equal(target.searchParams.get('scenario'), scene.id);
	}
	for (const relative of Object.keys(env.bundleFiles)) assert.deepEqual(fs.readFileSync(path.join(env.site, 'examples/flutter', relative)), fs.readFileSync(path.join(env.bundle, relative)), `${relative} 完整複製`);
});

test('verifier 重讀正式來源並拒絕頁、入口、search、manifest 與 source bundle bytes 篡改', (t) => {
	const env = cliSandbox(t);
	const sceneHref = 'docs/flutter/scenarios/alpha.html';
	const mutations = [
		['query', () => { const file = path.join(env.site, sceneHref); fs.writeFileSync(file, fs.readFileSync(file, 'utf8').replaceAll('scenario=alpha', 'scenario=ghost')); }],
		['iframe title', () => { const file = path.join(env.site, sceneHref); const html = fs.readFileSync(file, 'utf8'); const frame = html.match(/<iframe\b[^>]*>/i)[0]; fs.writeFileSync(file, html.replace(frame, frame.replace(/\btitle\s*=\s*(["'])(.*?)\1/i, 'title="另一場景 Flutter 互動展示"'))); }],
		['framework marker', () => { const file = path.join(env.site, sceneHref); const html = fs.readFileSync(file, 'utf8'); assert.match(html, /data-specimen-framework/); fs.writeFileSync(file, html.replace(/data-specimen-framework\s*=\s*(["'])flutter\1/gi, 'data-specimen-framework="react"')); }],
		['loading status', () => { const file = path.join(env.site, sceneHref); const html = fs.readFileSync(file, 'utf8'); assert.match(html, /data-specimen-state/); fs.writeFileSync(file, html.replace(/data-specimen-state\s*=\s*(["'])loading\1/gi, 'data-specimen-state="loaded"')); }],
		['official reference', () => { const file = path.join(env.site, sceneHref); const html = fs.readFileSync(file, 'utf8'); assert.ok(html.includes(env.input.alpha.reference)); fs.writeFileSync(file, html.replaceAll(env.input.alpha.reference, 'https://wrong.test/alpha')); }],
		['缺場景頁', () => fs.rmSync(path.join(env.site, sceneHref))],
		['extra 場景頁', () => fs.copyFileSync(path.join(env.site, sceneHref), path.join(env.site, 'docs/flutter/scenarios/ghost.html'))],
		['索引缺入口', () => fs.writeFileSync(path.join(env.site, 'docs/flutter/scenarios/index.html'), '<html>索引缺入口</html>')],
		['docs 缺入口', () => fs.writeFileSync(path.join(env.site, 'docs/index.html'), '<html>文件缺入口</html>')],
		['source title', () => env.writeRegistry({ ...env.input, alpha: { ...env.input.alpha, title: '正式來源改名' } })],
		['缺搜尋', () => { const file = path.join(env.site, 'search-index.json'); fs.writeFileSync(file, JSON.stringify(JSON.parse(fs.readFileSync(file, 'utf8')).filter((entry) => entry.category !== 'Flutter Scenario'))); }],
		['extra 搜尋', () => { const file = path.join(env.site, 'search-index.json'); const entries = JSON.parse(fs.readFileSync(file, 'utf8')); entries.push({ title: 'Ghost', category: 'Flutter Scenario', apiId: 'ghost', href: 'docs/flutter/scenarios/ghost.html' }); fs.writeFileSync(file, JSON.stringify(entries)); }],
		['manifest', () => { const file = path.join(env.site, 'site-manifest.json'); const value = JSON.parse(fs.readFileSync(file, 'utf8')); value.flutterScenarios = []; fs.writeFileSync(file, JSON.stringify(value)); }],
	];
	for (const relative of Object.keys(env.bundleFiles)) {
		mutations.push([`篡改 bundle ${relative}`, () => fs.appendFileSync(path.join(env.site, 'examples/flutter', relative), 'tamper')]);
	}
	mutations.push(['source bundle bytes', () => fs.appendFileSync(path.join(env.bundle, 'assets/other.bin'), 'changed')]);
	for (const [label, mutate] of mutations) {
		env.writeRegistry(env.input);
		writeBundle(env.bundle, env.input);
		cliSucceeds(env.run('generate'));
		cliSucceeds(env.run('verify'));
		mutate();
		cliFails(env.run('verify'), `${label} 必須拒絕`);
	}
});

test('generator 前置失敗保留既有網站全部 bytes', (t) => {
	const env = cliSandbox(t);
	cliSucceeds(env.run('generate'));
	const mutations = [
		['缺正式 metadata', () => fs.rmSync(path.join(env.directory, 'flutter/example/assets/gui-scenarios.json'))],
		['非法 metadata', () => env.writeRegistry({})],
		['bundle metadata 差異', () => writeFile(env.bundle, 'assets/assets/gui-scenarios.json', JSON.stringify({ solo: env.input.alpha }))],
		['錯 prefix', () => writeFile(env.bundle, 'index.html', '<html><head><base href="/"></head></html>')],
	];
	for (const relative of ['index.html', 'flutter_bootstrap.js', 'main.dart.js', 'assets/FontManifest.json', 'assets/assets/gui-scenarios.json', 'assets/packages/fixture/fonts/bold.otf']) {
		mutations.push([`缺 ${relative}`, () => fs.rmSync(path.join(env.bundle, relative))]);
	}
	for (const [label, mutate] of mutations) {
		env.writeRegistry(env.input);
		writeBundle(env.bundle, env.input);
		mutate();
		const before = outputHashes(env.site);
		cliFails(env.run('generate'), `${label} 不得生成假完整產物`);
		assert.deepEqual(outputHashes(env.site), before, `${label} 不得刪改既有產物`);
	}
});

test('Flutter flags 可與 React 合用並拒絕 unknown、重複與孤立 React-scenes', (t) => {
	const env = cliSandbox(t);
	for (const flags of [['--flutter-scenes', '--react'], ['--react', '--react-scenes', '--flutter-scenes']]) {
		cliSucceeds(env.run('generate', flags));
		cliSucceeds(env.run('verify', flags));
	}
	for (const script of ['generate', 'verify']) {
		for (const flags of [['--flutter-scenes', '--unknown'], ['--flutter-scenes', '--flutter-scenes'], ['--flutter-scenes', '--react-scenes']]) cliFails(env.run(script, flags), `${script} 非法 flags 必須拒絕`);
	}
	fs.rmSync(path.join(env.directory, 'flutter'), { recursive: true });
	cliSucceeds(env.run('generate', []));
	cliSucceeds(env.run('verify', []));
	cliSucceeds(env.run('generate', ['--react', '--react-scenes']));
	cliSucceeds(env.run('verify', ['--react', '--react-scenes']));
});
