import assert from 'node:assert/strict';
import test from 'node:test';
import { resolveKlpLinearLayout } from '../dist/index.js';

// 與 Flutter 使用相同期望幾何，只觀察公開入口。
const cases = [
	["預設等分與間距守恆",100,5,2,[{},{},{}],[30,30,30],5,0,false],
	["非整數 flex 與順序",100,0,0,[{"flex":0.5},{"flex":1.5},{"flex":0}],[25,75,0],0,0,false],
	["依序達 maximum 後再分配",100,0,0,[{"maximum":10},{"maximum":30,"flex":2},{"flex":1}],[10,30,60],0,0,false],
	["全部達 maximum 保留 unused",100,5,1,[{"maximum":20},{"maximum":30}],[20,30],5,45,false],
	["零 flex 保留 preferred 與 unused",100,0,0,[{"preferred":20,"flex":0},{"preferred":30,"flex":0}],[20,30],0,50,false],
	["preferred 超量依 minimum 以上比例壓縮",100,0,0,[{"minimum":10,"preferred":90},{"minimum":20,"preferred":60}],[56.666666666666664,43.333333333333336],0,0,false],
	["preferred clamp 於兩端限制",100,0,0,[{"minimum":20,"preferred":5,"flex":0},{"maximum":30,"preferred":80,"flex":0}],[20,30],0,50,false],
	["minimum 不足只依 minimum 比例退化",30,0,0,[{"minimum":40,"preferred":100,"flex":100},{"minimum":20,"flex":0},{"flex":100}],[20,10,0],0,0,true],
	["恰好滿足 minimum 不標記壓縮",30,0,0,[{"minimum":10,"preferred":80},{"minimum":20,"preferred":80}],[10,20],0,0,false],
	["巨大 gutter 壓縮占滿主軸",90,1e+308,3,[{},{}],[0,0],30,0,true],
	["巨大 minimum 加總仍有限",90,0,0,[{"minimum":1e+308},{"minimum":1e+308},{"minimum":5e+307}],[36,36,18],0,0,true],
	["巨大 preferred 加總保留 minimum",100,0,0,[{"minimum":10,"preferred":1e+308,"flex":0},{"minimum":20,"preferred":1e+308,"flex":0}],[45,55],0,0,false],
	["巨大 flex 正規化保留權重",90,0,0,[{"flex":1e+308},{"flex":1e+308},{"flex":5e+307}],[36,36,18],0,0,false],
	["巨大 flex 達上限再分配",100,0,0,[{"maximum":10,"flex":1e+308},{"flex":1e+308}],[10,90],0,0,false],
	["巨大 extent 仍守恆",1e+308,0,0,[{},{}],[5e+307,5e+307],0,0,false],
	["空 items 仍保留間距",20,3,2,[],[],3,14,false],
	["零 extent 沒有 minimum",0,0,0,[{},{}],[0,0],0,0,false],
	["零 extent 與正 minimum",0,0,0,[{"minimum":1}],[0],0,0,true],
	["零 gutterCount 不扣間距",20,0,0,[{}],[20],0,0,false],
];

function close(actual, expected, label) {
	assert.ok(Number.isFinite(actual) && actual >= 0, `${label} 必須有限非負`);
	assert.ok(Math.abs(actual - expected) <= 1e-6 * Math.max(1, expected), `${label}：${actual} != ${expected}`);
}

function check(input, result, extents, gutter, unused, compressed) {
	assert.equal(result.extents.length, input.items.length, '項目次序與數量必須保留');
	extents.forEach((expected, index) => close(result.extents[index], expected, `extents[${index}]`));
	close(result.gutter, gutter, 'gutter');
	close(result.unused, unused, 'unused');
	assert.equal(result.compressed, compressed);
	const scale = Math.max(1, input.extent);
	const total = result.extents.reduce((sum, value) => sum + value / scale, 0)
		+ (result.gutter / scale) * input.gutterCount + result.unused / scale;
	assert.ok(Math.abs(total - input.extent / scale) <= 1e-6, '內容、間距與留白必須守恆');
	assert.ok(Object.isFrozen(result), 'result 必須 frozen');
	assert.ok(Object.isFrozen(result.extents), 'extents 必須 frozen');
}

for (const [name, extent, gutter, gutterCount, items, extents, actualGutter, unused, compressed] of cases) {
	test(name, () => {
		const input = { extent, gutter, gutterCount, items: structuredClone(items) };
		const before = structuredClone(input);
		check(input, resolveKlpLinearLayout(input), extents, actualGutter, unused, compressed);
		assert.deepEqual(input, before, '解析不得修改 caller');
		assert.ok(!Object.isFrozen(input.items), '解析不得凍結 caller');
	});
}

test('非法幾何於執行時拒絕且不修改 caller', () => {
	const invalid = [];
	for (const field of ['extent', 'gutter']) {
		for (const value of [-1, NaN, Infinity, -Infinity]) invalid.push({ [field]: value });
	}
	for (const value of [-1, 0.5, NaN, Infinity, -Infinity]) invalid.push({ gutterCount: value });
	for (const field of ['minimum', 'maximum', 'preferred', 'flex']) {
		for (const value of [-1, NaN, Infinity, -Infinity]) invalid.push({ items: [{ [field]: value }] });
	}
	invalid.push({ items: [{ minimum: 2, maximum: 1 }] });
	for (const change of invalid) {
		const input = { extent: 100, gutter: 0, gutterCount: 0, items: [{}], ...change };
		const before = structuredClone(input);
		assert.throws(() => resolveKlpLinearLayout(input));
		assert.deepEqual(input, before, '非法資料不得部分改寫 caller');
	}
});

test('caller、result 及重複呼叫互相隔離', () => {
	const input = { extent: 100, gutter: 0, gutterCount: 0, items: [{ flex: 1 }, { flex: 3 }] };
	const first = resolveKlpLinearLayout(input);
	check(input, first, [25, 75], 0, 0, false);
	assert.throws(() => first.extents[0] = 99, TypeError);
	assert.throws(() => first.extents.push(1), TypeError);
	assert.throws(() => first.gutter = 99, TypeError);
	assert.throws(() => first.unused = 99, TypeError);
	assert.throws(() => first.compressed = true, TypeError);
	input.items[0].flex = 3;
	input.items.pop();
	check(input, resolveKlpLinearLayout(input), [100], 0, 0, false);
	assert.deepEqual(first.extents, [25, 75], 'caller 後續改動不得污染舊結果');
	const original = { extent: 100, gutter: 0, gutterCount: 0, items: [{ flex: 1 }, { flex: 3 }] };
	check(original, resolveKlpLinearLayout(original), [25, 75], 0, 0, false);
});
