import assert from 'node:assert/strict';
import test from 'node:test';
import { encodeKlpDockLayout, restoreKlpDockLayout } from '../dist/index.js';

// 與 Flutter 共用手寫 wire；不以 codec 自產資料取代格式驗證。
const wire = `{
	"schemaVersion": 1,
	"areas": {
		"left": {"axis":"horizontal","isVisible":false,"extent":120.5,"groups":[
			{"id":" left ","panelIds":["a","gone","b"],"activePanelId":"gone","mainAxisExtent":77.25},
			{"id":"remove","panelIds":["gone2"],"activePanelId":"gone2","mainAxisExtent":9}
		]},
		"right": {"axis":"vertical","isVisible":true,"extent":0,"groups":[
			{"id":"right","panelIds":["c"],"activePanelId":"c","mainAxisExtent":11}
		]},
		"bottom": {"axis":"horizontal","isVisible":true,"extent":88,"groups":[
			{"id":"bottom","panelIds":["d"],"activePanelId":"d","mainAxisExtent":13}
		]}
	}
}`;

const allPanels = ['a', 'gone', 'b', 'gone2', 'c', 'd'].map((id) => ({ id }));
const document = () => JSON.parse(wire);
const area = (value, name) => value.areas[name];
const group = (value, name) => area(value, name).groups[0];
const reject = (source, reason) => assert.throws(() => restoreKlpDockLayout(source, allPanels), TypeError, reason);

test('公開手寫 wire 保留順序、原始 identity 與全部布局值', () => {
	const result = restoreKlpDockLayout(wire, allPanels);
	assert.deepEqual(result.layout, document().areas);
	assert.deepEqual(result.missingPanelIds, []);
	assert.deepEqual(result.availablePanelIds, []);
	assert.deepEqual(JSON.parse(encodeKlpDockLayout(result.layout)), document());
	const second = restoreKlpDockLayout(encodeKlpDockLayout(result.layout), allPanels);
	assert.deepEqual(second.layout, document().areas);
	assert.deepEqual(restoreKlpDockLayout(wire.replace('"schemaVersion": 1', '"schemaVersion": 1.0'), allPanels).layout, result.layout);
});

test('missing 按保存順序移除，active 回退，available 按 registry 順序', () => {
	const panels = ['new', 'b', 'a', 'c', 'd', 'idle'].map((id) => ({ id }));
	const before = structuredClone(panels);
	const result = restoreKlpDockLayout(wire, panels);
	assert.deepEqual(result.missingPanelIds, ['gone', 'gone2']);
	assert.deepEqual(result.availablePanelIds, ['new', 'idle']);
	const expected = document();
	area(expected, 'left').groups.pop();
	group(expected, 'left').panelIds = ['a', 'b'];
	group(expected, 'left').activePanelId = 'a';
	assert.deepEqual(result.layout, expected.areas);
	assert.deepEqual(panels, before, '不得改寫 registry');
	assert.ok(!Object.isFrozen(panels) && panels.every((panel) => !Object.isFrozen(panel)), '不得凍結 caller');
	panels[0].id = 'changed';
	panels.length = 0;
	assert.deepEqual(result.availablePanelIds, ['new', 'idle']);
	const empty = restoreKlpDockLayout(wire, []);
	assert.deepEqual(empty.missingPanelIds, ['a', 'gone', 'b', 'gone2', 'c', 'd']);
	assert.deepEqual(empty.availablePanelIds, []);
	for (const name of ['left', 'right', 'bottom']) area(expected, name).groups = [];
	assert.deepEqual(empty.layout, expected.areas);
});

test('所有 wire 層拒絕缺欄、未知欄及錯誤型別', () => {
	const levels = [(value) => value, (value) => value.areas, (value) => area(value, 'left'), (value) => group(value, 'left')];
	for (const select of levels) {
		for (const field of Object.keys(select(document()))) {
			const missing = document();
			delete select(missing)[field];
			reject(JSON.stringify(missing), `缺少 ${field}`);
			const wrongType = document();
			select(wrongType)[field] = null;
			reject(JSON.stringify(wrongType), `${field} 錯誤型別`);
		}
		const extra = document();
		select(extra).unknown = true;
		reject(JSON.stringify(extra), '未知欄位');
	}
	for (const source of [undefined, document(), 1]) reject(source, 'restore 只接受 JSON string');
});

test('跨語言拒絕樣本涵蓋版本、identity、active 與幾何', () => {
	for (const source of ['{', 'null', '[]', wire.replace('"schemaVersion": 1', '"schemaVersion": 2')]) reject(source, 'JSON 或版本非法');
	const mutations = [
		(value) => area(value, 'left').axis = 'diagonal',
		(value) => area(value, 'left').isVisible = 1,
		(value) => group(value, 'left').panelIds = [],
		(value) => group(value, 'left').panelIds = ['a', 1],
		(value) => group(value, 'left').panelIds = ['a', 'a'],
		(value) => group(value, 'left').activePanelId = 'outside',
		(value) => group(value, 'right').id = ' left ',
		(value) => {
			group(value, 'bottom').panelIds = ['a'];
			group(value, 'bottom').activePanelId = 'a';
		},
	];
	for (const invalidId of ['', ' \t ']) {
		mutations.push((value) => group(value, 'left').id = invalidId);
		mutations.push((value) => {
			group(value, 'left').panelIds = [invalidId];
			group(value, 'left').activePanelId = invalidId;
		});
	}
	for (const mutate of mutations) {
		const value = document();
		mutate(value);
		reject(JSON.stringify(value), '非法結構或全域 identity');
	}
	for (const value of ['NaN', 'Infinity', '-Infinity', '1e400', '-1']) {
		reject(wire.replace('"extent":120.5', `"extent":${value}`), `area extent ${value}`);
		reject(wire.replace('"mainAxisExtent":77.25', `"mainAxisExtent":${value}`), `group extent ${value}`);
	}
	reject(wire.replace('"mainAxisExtent":77.25', '"mainAxisExtent":0'), 'group extent 零');
	// 完整驗證先於 missing reconciliation，不可刪除非法資料來假裝成功。
	const invalid = document();
	group(invalid, 'bottom').panelIds = ['a'];
	group(invalid, 'bottom').activePanelId = 'a';
	assert.throws(() => restoreKlpDockLayout(JSON.stringify(invalid), []), TypeError);
});

test('registry 非法 id、欄位、型別與 capability 整份拒絕', () => {
	const invalidRegistries = [
		null, {}, [null], [{}], [{ id: 1 }], [{ id: '' }], [{ id: ' \t ' }],
		[{ id: 'a' }, { id: 'a' }], [{ id: 'a', unknown: true }],
		[{ id: 'a', allowSide: false }], [{ id: 'c', allowSide: false }], [{ id: 'd', allowBottom: false }],
	];
	for (const field of ['allowSide', 'allowBottom']) {
		for (const value of [null, 0, 'true', {}, []]) invalidRegistries.push([{ id: 'a', [field]: value }]);
	}
	for (const panels of invalidRegistries) {
		const before = structuredClone(panels);
		assert.throws(() => restoreKlpDockLayout(wire, panels), TypeError);
		assert.deepEqual(panels, before, '失敗不得改寫 registry');
	}
	const permitted = restoreKlpDockLayout(wire, [
		{ id: 'a', allowBottom: false, allowSide: undefined },
		{ id: 'd', allowSide: false, allowBottom: undefined },
		{ id: 'unplaced', allowSide: false, allowBottom: false },
	]);
	assert.deepEqual(permitted.availablePanelIds, ['unplaced']);
});

test('encode 完整驗證 native 布局，不過濾或修改 caller', () => {
	const layout = document().areas;
	const before = structuredClone(layout);
	const encoded = encodeKlpDockLayout(layout);
	assert.deepEqual(JSON.parse(encoded), document());
	assert.deepEqual(layout, before);
	assert.ok(!Object.isFrozen(layout) && !Object.isFrozen(layout.left.groups) && !Object.isFrozen(layout.left.groups[0].panelIds));
	layout.left.groups[0].panelIds.length = 0;
	layout.left.groups.length = 0;
	assert.deepEqual(JSON.parse(encoded), document(), 'caller 後續改動不得污染 snapshot');
	const levels = [(value) => value, (value) => value.left, (value) => value.left.groups[0]];
	for (const select of levels) {
		for (const field of Object.keys(select(document().areas))) {
			for (const change of ['missing', 'null']) {
				const invalid = document().areas;
				if (change === 'missing') delete select(invalid)[field];
				else select(invalid)[field] = null;
				assert.throws(() => encodeKlpDockLayout(invalid), TypeError, `${field} ${change}`);
			}
		}
		const invalid = document().areas;
		select(invalid).unknown = true;
		assert.throws(() => encodeKlpDockLayout(invalid), TypeError, '不得默默刪除未知欄');
	}
	const mutations = [
		(value) => value.left.groups[0].panelIds = [],
		(value) => value.left.groups[0].activePanelId = 'outside',
		(value) => value.right.groups[0].id = ' left ',
		(value) => {
			value.bottom.groups[0].panelIds = ['a'];
			value.bottom.groups[0].activePanelId = 'a';
		},
	];
	for (const value of [NaN, Infinity, -Infinity, -1]) {
		mutations.push((layout) => layout.left.extent = value);
		mutations.push((layout) => layout.left.groups[0].mainAxisExtent = value);
	}
	mutations.push((layout) => layout.left.groups[0].mainAxisExtent = 0);
	for (const mutate of mutations) {
		const invalid = document().areas;
		mutate(invalid);
		const previous = structuredClone(invalid);
		assert.throws(() => encodeKlpDockLayout(invalid), TypeError);
		assert.deepEqual(invalid, previous, '失敗不得部分改寫 caller');
	}
	assert.deepEqual(JSON.parse(encodeKlpDockLayout(before)), document());
});

test('restore 結果深層 frozen 並與重複呼叫隔離', () => {
	function frozen(value) {
		if (value === null || typeof value !== 'object') return;
		assert.ok(Object.isFrozen(value), '所有結果物件及 arrays 必須 frozen');
		for (const child of Object.values(value)) frozen(child);
	}
	const result = restoreKlpDockLayout(wire, allPanels);
	const reconciled = restoreKlpDockLayout(wire, [{ id: 'a' }, { id: 'new' }]);
	const empty = restoreKlpDockLayout(wire, []);
	for (const value of [result, reconciled, empty]) frozen(value);
	assert.throws(() => result.layout.left.extent = 99, TypeError);
	assert.throws(() => result.layout.left.groups[0].activePanelId = 'b', TypeError);
	assert.throws(() => result.layout.left.groups[0].panelIds.push('extra'), TypeError);
	assert.throws(() => empty.layout.left.groups.push(result.layout.left.groups[0]), TypeError);
	assert.throws(() => reconciled.missingPanelIds.length = 0, TypeError);
	assert.throws(() => reconciled.availablePanelIds.push('extra'), TypeError);
	const second = restoreKlpDockLayout(wire, allPanels);
	assert.notStrictEqual(result.layout, second.layout);
	assert.notStrictEqual(result.layout.left.groups[0].panelIds, second.layout.left.groups[0].panelIds);
	assert.deepEqual(result.layout, document().areas);
});
