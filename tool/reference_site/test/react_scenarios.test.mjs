import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import test from 'node:test';
import { validateReactScenarios, renderReactScenario } from '../react-scenarios.mjs';

function registry() {
	return {
		'zulu-7': { title: 'Zulu 工作區', reference: 'https://official.test/zulu?mode=wide&lang=zh' },
		alpha: { title: 'Alpha 工作區', reference: 'https://official.test/alpha' },
		'paper-plane': { title: 'Paper 工作區', reference: 'https://official.test/paper#layout' },
		beta: { title: 'Beta 工作區', reference: 'https://official.test/beta' },
	};
}

function expectedScenes(input) {
	return Object.entries(input).sort(([left], [right]) => left.localeCompare(right)).map(([id, entry]) => ({
		id, ...entry, href: `docs/react/scenarios/${id}.html`,
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

test('任意非空 own 場景清單排序並保留公開 DTO，驗證不改寫來源', () => {
	const input = Object.assign(Object.create({ ghost: { title: 'Ghost', reference: 'https://official.test/ghost' } }), registry());
	const before = JSON.stringify(input);
	assert.deepEqual(validateReactScenarios(input), expectedScenes(input));
	assert.equal(JSON.stringify(input), before);
});

test('拒絕空清單、非法 route、title、reference 與重複 title', () => {
	const entry = { title: '唯一場景', reference: 'https://official.test/layout' };
	const invalid = [null, [], 'scene', {}, Object.create({ ghost: entry })];
	for (const id of ['', 'Alpha', '7alpha', '../alpha', 'alpha/beta', 'alpha_beta', 'alpha?x', '場景']) {
		invalid.push({ [id]: entry });
	}
	for (const title of ['', '   ', null, 42]) invalid.push({ alpha: { ...entry, title } });
	for (const reference of ['', 'not-a-url', 'http://official.test/layout', 'javascript:alert(1)', '/layout', null, 42]) {
		invalid.push({ alpha: { ...entry, reference } });
	}
	invalid.push({ alpha: null }, { alpha: 'scene' }, { alpha: {} });
	invalid.push({ alpha: entry, beta: { ...entry, reference: 'https://official.test/other' } });
	for (const input of invalid) {
		assert.throws(() => validateReactScenarios(input), `非法場景清單必須被拒絕：${JSON.stringify(input)}`);
	}
});

test('render 安全呈現 title/reference，提供具名 iframe、相同 query、loading 與官方安全連結', () => {
	const scene = {
		id: 'alpha', title: '場景 " & <script>bad()</script>',
		reference: 'https://official.test/layout?label=%22%3Cbad%3E&lang=zh',
		href: 'docs/react/scenarios/alpha.html',
	};
	const bundleUrl = '../../../examples/react/index.html?scenario=alpha&mode="wide"';
	const html = renderReactScenario(scene, bundleUrl);
	assert.equal(typeof html, 'string');
	assert.ok(decodeHtml(html).includes(scene.title));
	assert.doesNotMatch(html, /<script>bad\(\)<\/script>/i, 'title 不可成為可執行 HTML');
	const frames = html.match(/<iframe\b[^>]*>/gi) ?? [];
	assert.equal(frames.length, 1);
	assert.ok(attribute(frames[0], 'title').includes(scene.title));
	assert.equal(attribute(frames[0], 'src'), bundleUrl);
	assert.match(html, /\bdata-component-specimen(?:\s|=|>)/i);
	assert.match(html, /\bdata-specimen-state\s*=\s*(["'])loading\1/i);
	const links = html.match(/<a\b[^>]*>/gi) ?? [];
	assert.ok(links.some((tag) => attribute(tag, 'href') === bundleUrl), '提供相同 query 的獨立入口');
	const official = links.find((tag) => attribute(tag, 'href') === scene.reference);
	assert.ok(official, '保留官方 reference URL');
	assert.ok(attribute(official, 'rel').split(/\s+/).includes('noopener'));
});

function cliSandbox(t) {
	// 僅複製公開輸入及工具相依；不檢視產品內部，暫存清單與產物由本測試持有。
	const root = path.resolve(
		import.meta.dirname, '..',
		'..', '..',
	);
	const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'kallopis-react-scenes-contract-'));
	assert.ok(directory.startsWith(path.join(path.resolve(os.tmpdir()), 'kallopis-react-scenes-contract-')));
	t.after(() => fs.rmSync(directory, { recursive: true, force: true }));
	for (const entry of ['docs', 'spec', 'tool/reference_site', 'README.md', 'CHANGELOG.md']) {
		fs.cpSync(path.join(root, entry), path.join(directory, entry), { recursive: true });
	}
	const write = (relative, contents) => {
		const target = path.join(directory, relative);
		fs.mkdirSync(path.dirname(target), { recursive: true });
		fs.writeFileSync(target, contents);
	};
	write('build/reference-api.json', fs.readFileSync(path.join(import.meta.dirname, 'fixtures/reference-api.json')));
	write('react/build/reference-components.json', JSON.stringify({
		schemaVersion: 1, framework: 'react', entrypoint: '@kallopis/react',
		components: [{
			id: '@kallopis/react#Alpha', name: 'Alpha', source: 'public/example.d.ts',
			signature: 'declare function Alpha(props: ExampleProps): React.JSX.Element;', propsType: 'ExampleProps',
		}],
	}));
	write('react/example/specimen-registry.mjs', 'export const reactSpecimenRegistry = { Alpha: "basic" };\n');
	const input = registry();
	const writeRegistry = (value) => write('react/example/scenario-registry.mjs', `export const reactScenarioRegistry = ${JSON.stringify(value)};\n`);
	writeRegistry(input);
	write('react/example/dist/index.html', '<!doctype html><html><head><link rel="stylesheet" href="./assets/example.css"></head><body><div id="root">Scenario fixture</div><script type="module" src="./assets/example.js"></script></body></html>');
	write('react/example/dist/assets/example.css', 'body { margin: 0; }');
	write('react/example/dist/assets/example.js', 'document.body.dataset.ready = "true";');
	return {
		directory, input, write, writeRegistry,
		site: path.join(directory, 'build/reference-site'),
		run(script, flags = ['--react', '--react-scenes']) {
			return spawnSync(process.execPath, [`tool/reference_site/${script}.mjs`, ...flags], { cwd: directory, encoding: 'utf8' });
		},
	};
}

function cliSucceeds(result) {
	assert.equal(result.status, 0, result.stderr || result.stdout);
}

function cliFails(result, message) {
	assert.notEqual(result.status, 0, `${message}\n${result.stdout}\n${result.stderr}`);
}

function outputHashes(directory, relative = '') {
	return fs.readdirSync(path.join(directory, relative), { withFileTypes: true }).flatMap((entry) => {
		const target = path.join(relative, entry.name);
		if (entry.isDirectory()) return outputHashes(directory, target);
		return [[target, createHash('sha256').update(fs.readFileSync(path.join(directory, target))).digest('hex')]];
	}).sort(([left], [right]) => left < right ? -1 : left > right ? 1 : 0);
}

test('--react --react-scenes CLI 交付完整任意清單、入口、搜尋、manifest 與同 bundle', (t) => {
	const env = cliSandbox(t);
	cliSucceeds(env.run('generate'));
	cliSucceeds(env.run('verify'));
	const scenes = expectedScenes(env.input);
	const manifest = JSON.parse(fs.readFileSync(path.join(env.site, 'site-manifest.json'), 'utf8'));
	assert.deepEqual(manifest.reactScenarios, scenes, '正式 manifest 必須雙向對應來源 DTO');
	const search = JSON.parse(fs.readFileSync(path.join(env.site, 'search-index.json'), 'utf8'));
	const results = search.filter((entry) => entry.category === 'React Scenario');
	assert.equal(results.length, scenes.length);
	const index = fs.readFileSync(path.join(env.site, 'docs/react/scenarios/index.html'), 'utf8');
	const center = fs.readFileSync(path.join(env.site, 'docs/index.html'), 'utf8');
	assert.ok((center.match(/<a\b[^>]*>/gi) ?? []).some((tag) => {
		return new URL(attribute(tag, 'href'), 'https://example.test/Kallopis/docs/index.html').pathname === '/Kallopis/docs/react/scenarios/index.html';
	}), '文件中心必須連到場景索引');
	for (const scene of scenes) {
		const result = results.find((entry) => entry.apiId === scene.id);
		assert.ok(result, `${scene.id} 必須可搜尋`);
		assert.equal(result.href, scene.href);
		assert.equal(result.title, scene.title);
		assert.ok((index.match(/<a\b[^>]*>/gi) ?? []).some((tag) => {
			return new URL(attribute(tag, 'href'), 'https://example.test/Kallopis/docs/react/scenarios/index.html').pathname === `/Kallopis/${scene.href}`;
		}), `${scene.id} 必須存在索引入口`);
		const html = fs.readFileSync(path.join(env.site, scene.href), 'utf8');
		const frames = html.match(/<iframe\b[^>]*>/gi) ?? [];
		assert.equal(frames.length, 1);
		assert.ok(attribute(frames[0], 'title').includes(scene.title));
		assert.match(html, /\bdata-specimen-state\s*=\s*(["'])loading\1/i);
		const source = new URL(attribute(frames[0], 'src'), `https://example.test/Kallopis/${scene.href}`);
		assert.equal(source.pathname, '/Kallopis/examples/react/index.html');
		assert.equal(source.searchParams.get('scenario'), scene.id);
		const links = html.match(/<a\b[^>]*>/gi) ?? [];
		assert.ok(links.some((tag) => attribute(tag, 'href') === attribute(frames[0], 'src')));
		assert.ok(links.some((tag) => attribute(tag, 'href') === scene.reference));
	}
	for (const file of ['index.html', 'assets/example.css', 'assets/example.js']) {
		assert.equal(
			fs.readFileSync(path.join(env.site, 'examples/react', file), 'utf8'),
			fs.readFileSync(path.join(env.directory, 'react/example/dist', file), 'utf8'),
		);
	}
});

test('verifier 重讀正式 registry 並拒絕 query 篡改與多餘頁面', (t) => {
	const env = cliSandbox(t);
	cliSucceeds(env.run('generate'));
	const page = path.join(env.site, 'docs/react/scenarios/alpha.html');
	const html = fs.readFileSync(page, 'utf8');
	assert.ok(html.includes('scenario=alpha'));
	fs.writeFileSync(page, html.replaceAll('scenario=alpha', 'scenario=ghost'));
	cliFails(env.run('verify'), 'query 篡改必須被拒絕');
	fs.writeFileSync(page, html);
	cliSucceeds(env.run('verify'));
	env.writeRegistry({ ...env.input, alpha: { ...env.input.alpha, title: '來源已改名' } });
	cliFails(env.run('verify'), '合法來源修改後不能信任舊 manifest');
	env.writeRegistry(env.input);
	cliSucceeds(env.run('verify'));
	fs.writeFileSync(path.join(env.site, 'docs/react/scenarios/ghost.html'), html);
	cliFails(env.run('verify'), '拒絕不在來源的多餘場景頁');
});

test('generator 前置檢查非法清單與缺失 bundle，失敗保留完整既有網站', (t) => {
	const env = cliSandbox(t);
	cliSucceeds(env.run('generate'));
	const mutations = [
		['空清單', () => env.writeRegistry({})],
		['非法 route', () => env.writeRegistry({ '../escape': env.input.alpha })],
		['不安全 reference', () => env.writeRegistry({ alpha: { ...env.input.alpha, reference: 'http://official.test/alpha' } })],
		['重複 title', () => env.writeRegistry({ alpha: env.input.alpha, beta: env.input.alpha })],
		['缺失 registry', () => fs.rmSync(path.join(env.directory, 'react/example/scenario-registry.mjs'))],
		['缺失 bundle', () => fs.rmSync(path.join(env.directory, 'react/example/dist/index.html'))],
	];
	for (const [label, mutate] of mutations) {
		env.writeRegistry(env.input);
		mutate();
		const before = outputHashes(env.site);
		cliFails(env.run('generate'), `${label} 不可生成假完整產物`);
		assert.deepEqual(outputHashes(env.site), before, `${label} 不得破壞先前完整產物`);
	}
});

test('--react-scenes 必須同時指定 --react', (t) => {
	const env = cliSandbox(t);
	for (const script of ['generate', 'verify']) {
		cliFails(env.run(script, ['--react-scenes']), `${script} 必須拒絕孤立場景旗標`);
	}
});
