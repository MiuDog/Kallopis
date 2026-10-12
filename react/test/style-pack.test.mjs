import assert from 'node:assert/strict';
import test from 'node:test';
import { mkdtempSync, mkdirSync, rmSync, symlinkSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import React, { act } from 'react';
import { JSDOM } from 'jsdom';
import * as klp from '../dist/index.js';
import { expectedPrimitives, expectedRecipes, expectedTheme, modes, repository, semanticExpressions } from './source-contract.mjs';

const h = React.createElement;
const colorId = 'theme.colors.app';
const spacingId = 'theme.spacing.contentInlineGap';
const copy = value => structuredClone(value);

function frozen(value, path = 'pack') {
	if (!value || typeof value !== 'object') return;
	assert.ok(Object.isFrozen(value), `${path} 必須不可變`);
	for (const [key, child] of Object.entries(value)) frozen(child, `${path}.${key}`);
}

function diagnostic(operation, id) {
	assert.throws(operation, error => {
		assert.ok(error instanceof Error, '非法風格必須提供 Error');
		assert.ok(error.message.includes(id), `診斷必須定位 ${id}：${error.message}`);
		assert.ok(error.message.length > id.length, '診斷必須包含原因');
		return true;
	});
}

function alternate(pack, expression = 'p(ink50)') {
	return klp.applyKlpStyleOverrides(pack, { semantics: { [colorId]: { light: expression }, [spacingId]: { light: 'p(space300)' } } });
}

test('公開 style pack 入口、JSON 匯入、canonical 資料及深度隔離', () => {
	for (const name of ['createKlpStylePack', 'applyKlpStyleOverrides']) assert.equal(typeof klp[name], 'function', `${name} 必須公開`);
	const pack = klp.createKlpStylePack();
	assert.equal(pack.schemaVersion, 1);
	assert.deepEqual(pack.primitives, expectedPrimitives);
	assert.deepEqual(pack.recipes, expectedRecipes);
	assert.deepEqual(Object.keys(pack.semantics).sort(), Object.keys(semanticExpressions).sort());
	for (const [id, expressions] of Object.entries(semanticExpressions)) assert.deepEqual(pack.semantics[id], Object.fromEntries(modes.map((mode, index) => [mode, expressions[index]])), id);
	const input = copy(pack);
	const imported = klp.createKlpStylePack(input);
	const fromJson = klp.createKlpStylePack(JSON.stringify(input));
	assert.deepEqual(imported, pack);
	assert.deepEqual(fromJson, pack);
	assert.notEqual(imported.primitives, input.primitives);
	input.primitives.ink50 = '#FF123456';
	assert.equal(imported.primitives.ink50, '#FFFFFFFF', 'consumer 輸入變更不得污染有效 pack');
	frozen(pack);
	frozen(imported);
	frozen(fromJson);
	assert.deepEqual(klp.klpStyleParameters && Object.keys(klp.klpStyleParameters).sort(), Object.keys(semanticExpressions).sort());
	frozen(klp.klpStyleParameters, 'parameters');
});

test('四模式保留預設 theme 與既有單參數入口值', () => {
	const pack = klp.createKlpStylePack();
	for (const mode of modes) {
		assert.deepEqual(klp.createKlpTheme(mode), expectedTheme(mode), mode);
		assert.deepEqual(klp.createKlpTheme(mode, pack), expectedTheme(mode), `${mode} 顯式 default pack`);
	}
	assert.deepEqual(klp.createKlpTheme(), expectedTheme('light'));
});

test('未知版本、缺 canonical ID、缺模式、壞引用、循環及非法參數拒絕', () => {
	const pack = klp.createKlpStylePack();
	const invalid = [
		['schemaVersion', value => value.schemaVersion = 2],
		['ink50', value => delete value.primitives.ink50],
		[colorId, value => delete value.semantics[colorId]],
		['button-base', value => delete value.recipes['button-base']],
		[colorId, value => delete value.semantics[colorId].dark],
		[colorId, value => value.semantics[colorId].light = 'p(missing-contract-primitive)'],
		[colorId, value => value.semantics[colorId].light = `s(${colorId})`],
		['theme.spacing.space2', value => value.primitives.space200 = -1],
		[colorId, value => value.primitives.parchment150 = '#123'],
	];
	for (const [id, change] of invalid) {
		const input = copy(pack);
		change(input);
		diagnostic(() => klp.createKlpStylePack(input), id);
	}
	assert.throws(() => klp.createKlpStylePack('{bad json'), /JSON|json|parse|解析|格式/i);
	assert.deepEqual(klp.createKlpTheme('light', pack), expectedTheme('light'), '拒絕後原有效 pack 仍完整可用');
});

test('override 原子提交、caller 隔離、部分 mode 與固定 metadata 驗證', () => {
	const pack = klp.createKlpStylePack();
	const baseline = copy(pack);
	const overrides = { semantics: { [colorId]: { light: 'p(ink50)' }, [spacingId]: { light: 'p(space300)' } } };
	const changed = klp.applyKlpStyleOverrides(pack, overrides);
	assert.notEqual(changed, pack);
	frozen(changed);
	assert.equal(klp.createKlpTheme('light', changed)[colorId], '#FFFFFFFF');
	assert.equal(klp.createKlpTheme('light', changed)[spacingId], 12);
	for (const mode of modes.slice(1)) assert.deepEqual(klp.createKlpTheme(mode, changed), expectedTheme(mode));
	overrides.semantics[colorId].light = 'p(ink1000)';
	assert.equal(klp.createKlpTheme('light', changed)[colorId], '#FFFFFFFF');
	diagnostic(() => klp.applyKlpStyleOverrides(pack, { semantics: { [colorId]: { light: 'p(ink50)' }, [spacingId]: { dark: 'p(ink50)' } } }), spacingId);
	diagnostic(() => klp.applyKlpStyleOverrides(pack, { primitives: { 'missing-contract-id': 7 } }), 'missing-contract-id');
	diagnostic(() => klp.applyKlpStyleOverrides(pack, { semantics: { 'theme.missing.contract': { light: 'p(ink50)' } } }), 'theme.missing.contract');
	assert.throws(() => klp.applyKlpStyleOverrides(pack, { catalog: { parameters: {} } }), /catalog|override|root|key|欄位/i);
	assert.deepEqual(pack, baseline, '任一覆寫失敗不得部分修改來源');
	assert.equal(klp.klpStyleParameters[spacingId].min, 0, 'consumer 不得降低固定長度限制');
});

// 觀察公開 Provider DOM 與 hook，不查閱 resolver 私有實作。
test('provider pack 與 mode 更新；巢狀及兄弟 CSS／hook 全量隔離並可恢復', async t => {
	const pack = klp.createKlpStylePack();
	const first = alternate(pack);
	const second = alternate(pack, 'p(ink1000)');
	const dom = new JSDOM('<!doctype html><div id="root"></div>', { url: 'http://localhost' });
	const previous = new Map();
	for (const [name, value] of Object.entries({ window: dom.window, document: dom.window.document, navigator: dom.window.navigator, HTMLElement: dom.window.HTMLElement, Node: dom.window.Node, IS_REACT_ACT_ENVIRONMENT: true })) {
		previous.set(name, Object.getOwnPropertyDescriptor(globalThis, name));
		Object.defineProperty(globalThis, name, { configurable: true, writable: true, value });
	}
	const { createRoot } = await import('react-dom/client');
	const root = createRoot(dom.window.document.querySelector('#root'));
	t.after(async () => {
		await act(() => root.unmount());
		dom.window.close();
		for (const [name, descriptor] of previous) {
			if (descriptor) Object.defineProperty(globalThis, name, descriptor);
			else delete globalThis[name];
		}
	});
	const observations = new Map();
	function Probe({ name, mode, stylePack }) {
		const scope = klp.useKlp();
		assert.deepEqual(scope.tokens, klp.createKlpTheme(mode, stylePack), `${name} hook 必須取得所屬 pack`);
		assert.equal(scope.semantic(colorId), scope.tokens[colorId]);
		observations.set(name, copy(scope.tokens));
		return h('output', { 'data-probe': name, style: { color: 'red' } }, scope.semantic(colorId));
	}
	function view(outerPack, mode) {
		return h('main', null,
			h(klp.KlpThemeProvider, { mode, stylePack: outerPack },
				h(Probe, { name: 'before', mode, stylePack: outerPack }),
				h(klp.KlpThemeProvider, { stylePack: second }, h(Probe, { name: 'inner', mode: 'light', stylePack: second })),
				h(Probe, { name: 'after', mode, stylePack: outerPack })),
			h(klp.KlpThemeProvider, { stylePack: pack }, h(Probe, { name: 'sibling', mode: 'light', stylePack: pack })));
	}
	function check() {
		for (const name of ['before', 'inner', 'after', 'sibling']) {
			const output = dom.window.document.querySelector(`[data-probe="${name}"]`);
			const scope = output.closest('[data-klp-mode]');
			assert.ok(scope, `${name} 必須有 DOM scope`);
			assert.equal(output.style.color, 'red', 'consumer 原生 style 不得被 pack 覆寫');
			for (const [id, value] of Object.entries(observations.get(name))) {
				const variable = `--klp-${id.replace(/^theme\./, '').replaceAll('.', '-')}`;
				assert.notEqual(scope.style.getPropertyValue(variable), '', `${name} 必須局部輸出 ${id}`);
				if (id === colorId) assert.equal(scope.style.getPropertyValue(variable), value);
				if (id === spacingId) assert.equal(scope.style.getPropertyValue(variable), `${value}px`);
				if (id === 'theme.typography.body' || id === 'theme.motion.stateTransition' || id === 'theme.typography.bodyLeading') assert.equal(scope.style.getPropertyValue(variable), String(value), `${id} 不得添加 px／ms`);
				if (id === 'theme.motion.standard') assert.match(scope.style.getPropertyValue(variable), /^cubic-bezier\(/);
				if (id === 'theme.typography.sansFallback') assert.ok(scope.style.getPropertyValue(variable).includes('"Noto Sans TC"'));
			}
		}
		assert.equal(dom.window.document.documentElement.getAttribute('style'), null, 'provider 不得污染 root');
	}
	await act(() => root.render(view(first, 'light')));
	check();
	assert.equal(observations.get('before')[colorId], '#FFFFFFFF');
	assert.equal(observations.get('inner')[colorId], '#000000FF');
	await act(() => root.render(view(second, 'light')));
	check();
	assert.equal(observations.get('after')[colorId], '#000000FF');
	await act(() => root.render(view(first, 'dark')));
	check();
	assert.deepEqual(observations.get('before'), expectedTheme('dark'));
	await act(() => root.render(view(pack, 'light')));
	check();
	assert.deepEqual(observations.get('after'), expectedTheme('light'));
	assert.deepEqual(observations.get('sibling'), expectedTheme('light'));
});

test('npm tarball 在獨立 consumer 內擁有可用 style runtime', t => {
	const directory = mkdtempSync(join(tmpdir(), 'kallopis-react-pack-'));
	t.after(() => rmSync(directory, { recursive: true, force: true }));
	const project = join(repository, 'react');
	const result = spawnSync(process.platform === 'win32' ? 'npm.cmd' : 'npm', ['pack', '--ignore-scripts', '--json', '--pack-destination', directory], { cwd: project, encoding: 'utf8', shell: process.platform === 'win32' });
	assert.equal(result.status, 0, result.stderr + result.stdout);
	const archive = join(directory, JSON.parse(result.stdout)[0].filename);
	const destination = join(directory, 'node_modules', '@kallopis', 'react');
	mkdirSync(destination, { recursive: true });
	const extracted = spawnSync('tar', ['-xf', archive, '-C', destination, '--strip-components=1'], { encoding: 'utf8' });
	assert.equal(extracted.status, 0, extracted.stderr + extracted.stdout);
	for (const peer of ['react', 'react-dom']) symlinkSync(join(project, 'node_modules', peer), join(directory, 'node_modules', peer), process.platform === 'win32' ? 'junction' : 'dir');
	const script = `import * as api from '@kallopis/react'; const pack = api.createKlpStylePack(); const next = api.applyKlpStyleOverrides(pack, {semantics:{'theme.colors.app':{light:'p(ink50)'}}}); console.log(JSON.stringify({modes:['light','dark','ultraDark','transparent'].map(mode=>api.createKlpTheme(mode,pack)), color:api.createKlpTheme('light',next)['theme.colors.app']}));`;
	const consumer = spawnSync(process.execPath, ['--input-type=module', '-e', script], { cwd: directory, encoding: 'utf8' });
	assert.equal(consumer.status, 0, `套件不得依賴 checkout 的 styles/：${consumer.stderr}${consumer.stdout}`);
	const observed = JSON.parse(consumer.stdout);
	assert.deepEqual(observed.modes, modes.map(expectedTheme));
	assert.equal(observed.color, '#FFFFFFFF');
});
