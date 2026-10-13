import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import test from 'node:test';
import { validateReactSpecimens, renderReactSpecimen } from '../react-specimens.mjs';

function component(name = 'Alpha') {
	return {
		id: `@kallopis/react#${name}`,
		name,
		source: 'public/example.d.ts',
		signature: `declare function ${name}(props: ExampleProps): React.JSX.Element;`,
		propsType: 'ExampleProps',
	};
}

function inventory(components = [component()]) {
	return { schemaVersion: 1, framework: 'react', entrypoint: '@kallopis/react', components };
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

test('完整公開清單以名稱排序、保留宣告並接受五種實際 factory', () => {
	const names = ['Omega', 'Gamma', 'Alpha', 'Slash / &', 'Beta'];
	const kinds = ['basic', 'layout', 'command', 'dock', 'theme'];
	const entries = names.map((name) => component(name));
	entries[0].propsType = '';
	const registry = Object.assign(Object.create({ InheritedGhost: 'basic' }), Object.fromEntries(names.map((name, index) => [name, kinds[index]])));
	const input = inventory(entries);
	const before = structuredClone(input);
	const result = validateReactSpecimens(input, registry);
	assert.deepEqual(result.map((entry) => entry.name), [...names].sort());
	for (const entry of result) {
		assert.deepEqual(entry, { ...entries.find((candidate) => candidate.name === entry.name), href: `docs/react/components/${encodeURIComponent(entry.name)}.html` });
	}
	assert.deepEqual(input, before, '驗證不可改寫公開清單');
});

test('清單與 registry 必須雙向相等，重複 identity 與未知 factory 被拒絕', () => {
	const cases = [
		['缺少 factory', inventory(), {}],
		['幽靈 factory', inventory(), { Alpha: 'basic', Ghost: 'layout' }],
		['繼承 factory 不算 own key', inventory(), Object.create({ Alpha: 'basic' })],
		['未知 factory', inventory(), { Alpha: 'placeholder' }],
		['非字串 factory', inventory(), { Alpha: () => null }],
		['重複 name 與 id', inventory([component(), component()]), { Alpha: 'basic' }],
		['不同 name 共用 id', inventory([component(), { ...component('Beta'), id: '@kallopis/react#Alpha' }]), { Alpha: 'basic', Beta: 'layout' }],
	];
	for (const [label, input, registry] of cases) {
		assert.throws(() => validateReactSpecimens(input, registry), label);
	}
});

test('拒絕不合法 schema、框架、入口、canonical identity 及公開欄位型別', () => {
	const invalid = [
		['schema', { ...inventory(), schemaVersion: 2 }],
		['framework', { ...inventory(), framework: 'flutter' }],
		['entrypoint', { ...inventory(), entrypoint: '@other/react' }],
		['components 型別', { ...inventory(), components: {} }],
		['null 清單', null],
		['null 元件', inventory([null])],
	];
	for (const field of ['id', 'name', 'source', 'signature', 'propsType']) {
		invalid.push([`${field} 型別`, inventory([{ ...component(), [field]: 42 }])]);
		invalid.push([`${field} 缺失`, inventory([Object.fromEntries(Object.entries(component()).filter(([key]) => key !== field))])]);
		if (field !== 'propsType') invalid.push([`${field} 空值`, inventory([{ ...component(), [field]: '' }])]);
	}
	invalid.push(['錯誤 canonical id', inventory([{ ...component(), id: '@kallopis/react#Other' }])]);
	for (const [label, input] of invalid) {
		assert.throws(() => validateReactSpecimens(input, { Alpha: 'basic' }), label);
	}
	for (const registry of [null, [], 'Alpha']) {
		assert.throws(() => validateReactSpecimens(inventory(), registry), 'registry 必須是名稱對應 factory 的物件');
	}
});

test('render 以安全公開文字、具名 iframe、對應 query、獨立連結與 loading 狀態交付', () => {
	const name = 'Alias / & " <script>bad()</script>';
	const signature = 'declare function Alias(props: { label: "<img src=x onerror=bad()> & \'quoted\'" }): React.JSX.Element;';
	const entry = { ...component(name), signature, href: `docs/react/components/${encodeURIComponent(name)}.html` };
	const bundleUrl = `../../../examples/react/index.html?specimen=${encodeURIComponent(name)}&mode="wide"`;
	const html = renderReactSpecimen(entry, bundleUrl);
	assert.equal(typeof html, 'string');
	assert.ok(decodeHtml(html).includes(signature), '公開 callable signature 必須完整呈現');
	assert.ok(decodeHtml(html).includes('@kallopis/react'), '公開入口必須呈現');
	assert.doesNotMatch(html, /<script>bad\(\)<\/script>|<img src=x onerror=bad\(\)>/i, '公開文字不可成為可執行 HTML');
	const frames = html.match(/<iframe\b[^>]*>/gi) ?? [];
	assert.equal(frames.length, 1, '每個元件頁只嵌入對應 specimen');
	assert.ok(attribute(frames[0], 'title').includes(name), 'iframe title 必須識別當次元件');
	assert.equal(attribute(frames[0], 'src'), bundleUrl, '嵌入 URL 必須保留 generator 提供的 query 與相對路由');
	const links = html.match(/<a\b[^>]*>/gi) ?? [];
	assert.ok(links.some((tag) => attribute(tag, 'href') === bundleUrl), '必須提供對應 specimen 的獨立開啟連結');
	assert.match(html, /\bdata-specimen-state\s*=\s*(["'])loading\1/i, '初始 loading 狀態必須可識別');
});

function cliSandbox(t) {
	// 只複製既有公開網站輸入，不檢視 generator 實作；產物及清單均在隔離目錄。
	const root = path.resolve(import.meta.dirname, '..', '..', '..');
	const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'kallopis-react-docs-contract-'));
	assert.ok(directory.startsWith(path.join(path.resolve(os.tmpdir()), 'kallopis-react-docs-contract-')));
	t.after(() => fs.rmSync(directory, { recursive: true, force: true }));
	for (const entry of ['docs', 'spec', 'tool/reference_site', 'README.md', 'CHANGELOG.md']) {
		fs.cpSync(path.join(root, entry), path.join(directory, entry), { recursive: true });
	}
	const write = (relative, text) => {
		const target = path.join(directory, relative);
		fs.mkdirSync(path.dirname(target), { recursive: true });
		fs.writeFileSync(target, text);
	};
	write('build/reference-api.json', fs.readFileSync(path.join(import.meta.dirname, 'fixtures/reference-api.json')));
	const entries = ['Zulu', 'Alpha', 'Beta', 'Gamma', 'Delta'].map((name) => component(name));
	const input = inventory(entries);
	const registry = Object.fromEntries(entries.map((entry, index) => [entry.name, ['basic', 'layout', 'command', 'dock', 'theme'][index]]));
	const writeRegistry = (value) => write('react/example/specimen-registry.mjs', `export const reactSpecimenRegistry = ${JSON.stringify(value)};\n`);
	write('react/build/reference-components.json', JSON.stringify(input));
	writeRegistry(registry);
	write('react/example/dist/index.html', '<!doctype html><html><head><link rel="stylesheet" href="./assets/example.css"></head><body><div id="root">Specimen fixture</div><script type="module" src="./assets/example.js"></script></body></html>');
	write('react/example/dist/assets/example.css', 'body { margin: 0; }');
	write('react/example/dist/assets/example.js', 'document.body.dataset.ready = "true";');
	return {
		directory, input, registry, write, writeRegistry,
		site: path.join(directory, 'build/reference-site'),
		run(script) { return spawnSync(process.execPath, [`tool/reference_site/${script}.mjs`, '--react'], { cwd: directory, encoding: 'utf8' }); },
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

test('--react CLI 生成每筆專屬 iframe/query 與完整 bundle，verifier 拒絕頁面破壞', (t) => {
	const env = cliSandbox(t);
	cliSucceeds(env.run('generate'));
	cliSucceeds(env.run('verify'));
	for (const entry of env.input.components) {
		const href = `docs/react/components/${encodeURIComponent(entry.name)}.html`;
		const html = fs.readFileSync(path.join(env.site, href), 'utf8');
		const frames = html.match(/<iframe\b[^>]*>/gi) ?? [];
		assert.equal(frames.length, 1, `${entry.name} 必須有唯一 specimen iframe`);
		assert.ok(attribute(frames[0], 'title').includes(entry.name));
		const source = new URL(attribute(frames[0], 'src'), `https://example.test/Kallopis/${href}`);
		assert.equal(source.pathname, '/Kallopis/examples/react/index.html');
		assert.equal(source.searchParams.get('specimen'), entry.name);
	}
	for (const file of ['index.html', 'assets/example.css', 'assets/example.js']) {
		assert.equal(fs.readFileSync(path.join(env.site, 'examples/react', file), 'utf8'), fs.readFileSync(path.join(env.directory, 'react/example/dist', file), 'utf8'));
	}
	const page = path.join(env.site, 'docs/react/components/Alpha.html');
	const html = fs.readFileSync(page, 'utf8');
	assert.ok(html.includes('specimen=Alpha'), '先確認對應 query 存在再破壞');
	fs.writeFileSync(page, html.replaceAll('specimen=Alpha', 'specimen=Ghost'));
	cliFails(env.run('verify'), 'verifier 必須拒絕元件頁指向幽靈 specimen');
});

test('--react CLI 依權威輸入拒絕缺失／幽靈／非法 registry，失敗保留先前完整產物', (t) => {
	const env = cliSandbox(t);
	cliSucceeds(env.run('generate'));
	cliSucceeds(env.run('verify'));
	const mutations = [
		['缺失 registry 檔', () => fs.rmSync(path.join(env.directory, 'react/example/specimen-registry.mjs'))],
		['缺少 factory', () => env.writeRegistry({ ...env.registry, Alpha: undefined })],
		['幽靈 factory', () => env.writeRegistry({ ...env.registry, Ghost: 'basic' })],
		['非法 factory', () => env.writeRegistry({ ...env.registry, Alpha: 'placeholder' })],
		['非法公開 schema', () => env.write('react/build/reference-components.json', JSON.stringify({ ...env.input, schemaVersion: 2 }))],
	];
	for (const [label, mutate] of mutations) {
		env.writeRegistry(env.registry);
		env.write('react/build/reference-components.json', JSON.stringify(env.input));
		mutate();
		cliFails(env.run('verify'), `${label}：不能信任生成清單而忽略權威輸入`);
		// verifier 可以更新驗證報告；保護的交易邊界是 generator 開始之前的完整產物。
		const before = outputHashes(env.site);
		cliFails(env.run('generate'), `${label}：不能生成看似完整的網站`);
		assert.deepEqual(outputHashes(env.site), before, `${label}：前置驗證失敗不得刪除或改寫先前產物`);
	}
});
