import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import * as runtime from '../src/index.mjs';

const modes = ['light', 'dark', 'ultraDark', 'transparent'];
const defaultPack = JSON.parse(await readFile(new URL('../kallopis-v1.json', import.meta.url), 'utf8'));
const defaultCatalog = JSON.parse(await readFile(new URL('../catalog.json', import.meta.url), 'utf8'));
const { resolveStylePack, applyStyleOverrides } = runtime;
const pending = typeof resolveStylePack !== 'function' || typeof applyStyleOverrides !== 'function';
const options = { skip: pending ? '公開 runtime 入口尚未提供；harness pending，非行為 Red' : false };

function allModes(expression) {
	return Object.fromEntries(modes.map((mode) => [mode, expression]));
}

// 明確的最小交換資料，與產品解析器實作無關。
function fixture() {
	const values = {
		color: '#80AABBCC', colors: ['#AABBCC', '#80AABBCC'],
		font: 'packages/kallopis/Noto Sans TC', fonts: ['packages/kallopis/Noto Sans TC', 'sans-serif'],
		length: 12, offset: -2, opacity: 0.5, duration: 100, weight: 400, count: 2, ratio: 1.25,
		curve: '[0.2, -0.5, 0.8, 1.5]', symbol: 'none',
	};
	const parameters = Object.fromEntries(Object.keys(values).map((id) => [id, {
		type: ({ colors: 'color-array', font: 'font-family', fonts: 'font-family-array', offset: 'length' })[id] ?? id,
		unit: 'fixture', purpose: '公開型別契約樣例', affectedRecipes: [],
	}]));
	Object.assign(parameters.length, { min: 0 });
	Object.assign(parameters.opacity, { min: 0, max: 1 });
	Object.assign(parameters.duration, { min: 0 });
	Object.assign(parameters.weight, { min: 1, max: 1000, integer: true });
	Object.assign(parameters.count, { min: 1, integer: true });
	Object.assign(parameters.ratio, { exclusiveMin: 0 });
	parameters.alias = { ...parameters.length };
	parameters.total = { ...parameters.length };
	const pack = {
		schemaVersion: 1, id: 'runtime-fixture', version: '1.0.0', primitives: values,
		semantics: Object.fromEntries(Object.keys(values).map((id) => [id, allModes(`p(${id})`)])),
		recipes: { sample: { aliases: '樣例', inherit: '—', parameters: 'color=p(color); font=p(font)' } },
	};
	pack.semantics.alias = allModes('s(length)');
	pack.semantics.total = allModes('add(s(alias), s(offset))');
	pack.primitiveDescriptions = Object.fromEntries(Object.keys(values).map((id) => [id, '測試原料']));
	pack.semanticDescriptions = Object.fromEntries(Object.keys(pack.semantics).map((id) => [id, '測試語意']));
	return { pack, catalog: { schemaVersion: 1, parameters, constraints: [] } };
}

function rejects(action, ids) {
	assert.throws(action, (error) => {
		assert.ok(error instanceof Error);
		assert.ok(ids.some((id) => error.message.includes(id)), `錯誤必須定位 ${ids.join(' 或 ')}：${error.message}`);
		assert.ok(error.message.trim().length > Math.min(...ids.map((id) => id.length)), '錯誤必須含原因');
		return true;
	});
}

function assertFrozen(value) {
	if (value && typeof value === 'object') {
		assert.ok(Object.isFrozen(value), '整個 snapshot 必須深度 frozen');
		Object.values(value).forEach(assertFrozen);
	}
}

test('最小 fixture 符合已公開的 pack 交換結構', () => {
	const { pack } = fixture();
	assert.deepEqual(runtime.validateStylePack(pack), pack);
});

test('預設 catalog 完整列出全部 350 semantic，四模式均完整解析並保留來源身份', options, () => {
	assert.equal(Object.keys(defaultCatalog.parameters).length, 350);
	assert.deepEqual(Object.keys(defaultCatalog.parameters).sort(), Object.keys(defaultPack.semantics).sort());
	const before = structuredClone(defaultPack);
	for (const mode of modes) {
		const resolved = resolveStylePack(defaultPack, mode, defaultCatalog);
		assert.deepEqual(Object.keys(resolved).sort(), ['id', 'version', 'mode', 'tokens', 'recipes'].sort());
		assert.equal(resolved.id, defaultPack.id);
		assert.equal(resolved.version, defaultPack.version);
		assert.equal(resolved.mode, mode);
		assert.deepEqual(Object.keys(resolved.tokens).sort(), Object.keys(defaultPack.semantics).sort());
		const appPrimitive = { light: 'parchment150', dark: 'parchment950', ultraDark: 'ink950', transparent: 'transparent' }[mode];
		assert.equal(resolved.tokens['theme.colors.app'], defaultPack.primitives[appPrimitive]);
		assert.equal(resolved.tokens['theme.typography.sansFamily'], 'packages/kallopis/Noto Sans TC');
		assert.deepEqual(resolved.tokens['theme.motion.standard'], [0.215, 0.61, 0.355, 1]);
		assert.equal(resolved.tokens['theme.components.badgePaddingX'], defaultPack.primitives.space100 + defaultPack.primitives.space50);
		assert.deepEqual(resolved.tokens['theme.dataVisualization.series'], (mode === 'light'
			? ['sand500', 'gold500', 'ochre500', 'terracotta500', 'clay500', 'umber500']
			: ['sand300', 'gold300', 'ochre300', 'terracotta300', 'clay300', 'umber300']).map((id) => defaultPack.primitives[id]));
		assert.deepEqual(resolved.recipes, defaultPack.recipes);
		assertFrozen(resolved);
		for (const value of Object.values(resolved.tokens)) {
			if (typeof value === 'number') assert.ok(Number.isFinite(value));
		}
	}
	assert.deepEqual(defaultPack, before);
});

test('p、s、list、add 及 typed 值確定解析；曲線 y 允許 overshoot 與明示負 offset', options, () => {
	const { pack, catalog } = fixture();
	pack.semantics.colors.light = '[p(color), p(color)]';
	pack.semantics.fonts.light = '[p(font), p(font)]';
	for (const mode of modes) {
		const tokens = resolveStylePack(pack, mode, catalog).tokens;
		assert.equal(tokens.alias, 12);
		assert.equal(tokens.total, 10);
		assert.equal(tokens.offset, -2);
		assert.equal(tokens.color, '#80AABBCC');
		assert.deepEqual(tokens.curve, [0.2, -0.5, 0.8, 1.5]);
		assert.deepEqual(tokens.colors, mode === 'light' ? ['#80AABBCC', '#80AABBCC'] : pack.primitives.colors);
		assert.deepEqual(tokens.fonts, mode === 'light' ? [pack.primitives.font, pack.primitives.font] : pack.primitives.fonts);
		for (const id of ['length', 'opacity', 'duration', 'weight', 'count', 'ratio', 'font', 'symbol']) {
			assert.equal(tokens[id], pack.primitives[id]);
		}
	}
});

test('非法型別、範圍、非有限值與曲線必須拒絕並定位', options, async (context) => {
	const cases = [
		['color', '#ABC'], ['color', '#GG001122'], ['color', 12], ['colors', ['#AABBCC', '#ABC']],
		['font', 12], ['fonts', ['sans-serif', 12]], ['length', -1], ['length', '12'],
		['opacity', -0.01], ['opacity', 1.01], ['duration', -1], ['weight', 0], ['weight', 1001],
		['weight', 400.5], ['count', 0], ['count', 1.5], ['ratio', 0], ['ratio', -1],
		['symbol', 12], ['curve', '[0.2, 0.5, 0.8]'], ['curve', '[-0.1, 0, 0.8, 1]'],
		['curve', '[0.2, 0, 1.1, 1]'], ['curve', '[0.2, Infinity, 0.8, 1]'], ['curve', [0.2, NaN, 0.8, 1]],
		['length', NaN], ['duration', Infinity],
	];
	for (const [index, [id, value]] of cases.entries()) {
		await context.test(`${id} 非法樣例 ${index}`, () => {
			const { pack, catalog } = fixture();
			pack.primitives[id] = value;
			rejects(() => resolveStylePack(pack, 'light', catalog), [id]);
		});
	}
	const { pack, catalog } = fixture();
	pack.semantics.total.light = 'add(s(color), s(length))';
	rejects(() => resolveStylePack(pack, 'light', catalog), ['total']);
	pack.primitives.length = Number.MAX_VALUE;
	pack.semantics.total.light = 'add(s(length), s(length))';
	rejects(() => resolveStylePack(pack, 'light', catalog), ['total']);
});

test('缺 catalog metadata、未知 mode 與不支援 catalog 版本不得解析', options, () => {
	const { pack, catalog } = fixture();
	delete catalog.parameters.color;
	rejects(() => resolveStylePack(pack, 'light', catalog), ['color']);
	const another = fixture();
	assert.throws(() => resolveStylePack(another.pack, 'sepia', another.catalog), Error);
	another.catalog.schemaVersion = 2;
	assert.throws(() => resolveStylePack(another.pack, 'light', another.catalog), Error);
});

test('catalog 宣告的 ordered 與 fits 同時保護全部既有跨 token 關係', options, async (context) => {
	for (const constraint of defaultCatalog.constraints) {
		await context.test(`${constraint.kind} ${constraint.ids?.join(' / ') ?? constraint.child}`, () => {
			const pack = structuredClone(defaultPack);
			const ids = constraint.kind === 'ordered' ? constraint.ids : [constraint.child, constraint.inset, ...constraint.containers];
			const violatedId = constraint.kind === 'ordered' ? constraint.ids[0] : constraint.child;
			pack.primitives['runtime-constraint-value'] = 1000000;
			pack.semantics[violatedId].light = 'p(runtime-constraint-value)';
			rejects(() => resolveStylePack(pack, 'light', defaultCatalog), ids);
		});
	}
});

test('snapshot 深度 frozen 且與輸入及其他 pack 隔離', options, () => {
	const { pack, catalog } = fixture();
	const snapshot = resolveStylePack(pack, 'light', catalog);
	assertFrozen(snapshot);
	assert.throws(() => { snapshot.tokens.colors.push('#000000'); }, TypeError);
	assert.throws(() => { snapshot.recipes.sample.parameters = 'changed'; }, TypeError);
	pack.primitives.colors[0] = '#FFFFFF';
	pack.recipes.sample.parameters = 'changed';
	assert.equal(snapshot.tokens.colors[0], '#AABBCC');
	assert.equal(snapshot.recipes.sample.parameters, 'color=p(color); font=p(font)');
	const second = fixture();
	second.pack.primitives.color = '#112233';
	assert.equal(resolveStylePack(second.pack, 'light', second.catalog).tokens.color, '#112233');
	assert.equal(snapshot.tokens.color, '#80AABBCC');
});

test('合法覆寫 clone 整體成功，部分 mode 保留且無共享可變資料', options, () => {
	const { pack, catalog } = fixture();
	const before = structuredClone(pack);
	const overrides = { primitives: { length: 20 }, semantics: { alias: { dark: 'p(count)' } } };
	const inputOverrides = structuredClone(overrides);
	const result = applyStyleOverrides(pack, overrides, catalog);
	assert.notEqual(result, pack);
	assert.deepEqual(pack, before);
	assert.deepEqual(overrides, inputOverrides);
	for (const mode of modes) {
		const tokens = resolveStylePack(result, mode, catalog).tokens;
		assert.equal(tokens.length, 20);
		assert.equal(tokens.alias, mode === 'dark' ? 2 : 20);
	}
	assert.notEqual(result.primitives, pack.primitives);
	assert.notEqual(result.primitives.fonts, pack.primitives.fonts);
	assert.notEqual(result.semantics.alias, pack.semantics.alias);
	assert.notEqual(result.recipes.sample, pack.recipes.sample);
});

test('覆寫不得新增 ID／mode／root key；任一模式失敗保留原 pack 及既有 snapshot', options, async (context) => {
	const invalid = [
		{ primitives: { missing: 1 } }, { semantics: { missing: { light: 'p(length)' } } },
		{ semantics: { color: { sepia: 'p(color)' } } }, { recipes: {} }, { catalog: {} },
		{ primitives: [], semantics: {} },
		...modes.map((mode) => ({ primitives: { length: 24 }, semantics: { opacity: { [mode]: 'p(length)' } } })),
	];
	for (const [index, overrides] of invalid.entries()) {
		await context.test(`拒絕覆寫 ${index}`, () => {
			const { pack, catalog } = fixture();
			const before = structuredClone(pack);
			const snapshot = resolveStylePack(pack, 'light', catalog);
			assert.throws(() => applyStyleOverrides(pack, overrides, catalog), Error);
			assert.deepEqual(pack, before, '失敗覆寫不得部分修改原始 pack');
			assert.equal(snapshot.tokens.length, 12);
			assert.deepEqual(resolveStylePack(pack, 'light', catalog), snapshot);
		});
	}
});
