import assert from 'node:assert/strict';
import test from 'node:test';
import { resolveKlpDockGeometry } from '../dist/index.js';

// 根配額對照共同契約與 Flutter 公開 probes，不讀兩端私有實作。
function area(id, extent, { visible = true, empty = false } = {}) {
	return {
		axis: 'vertical', isVisible: visible, extent,
		groups: empty ? [] : [{ id: `group-${id}`, panelIds: [id], activePanelId: id, mainAxisExtent: 100 }],
	};
}

function args(change = {}) {
	return {
		width: 600, height: 400, handleExtent: 8,
		layout: { left: area('l', 100), right: area('r', 120), bottom: area('b', 80) },
		leftConstraints: { minExtent: 80 }, rightConstraints: { minExtent: 80 },
		bottomConstraints: { minExtent: 40 }, ...change,
	};
}

function close(actual, expected, label) {
	assert.ok(Number.isFinite(actual) && actual >= 0, `${label} 必須有限非負`);
	assert.ok(Math.abs(actual - expected) <= 1e-6 * Math.max(1, expected), `${label}：${actual} != ${expected}`);
}

function rect(actual, expected, label) {
	assert.ok(actual, `${label} 必須存在`);
	['left', 'top', 'width', 'height'].forEach((field, index) => close(actual[field], expected[index], `${label}.${field}`));
}

function frozen(value) {
	if (value === null || typeof value !== 'object') return;
	assert.ok(Object.isFrozen(value), '所有結果物件必須 frozen');
	Object.values(value).forEach(frozen);
}

function check(input) {
	const before = structuredClone(input);
	const result = resolveKlpDockGeometry(input);
	for (const name of ['stage', 'left', 'right', 'bottom', 'header', 'leftHandle', 'rightHandle', 'bottomHandle']) {
		const value = result[name];
		if (value === null) continue;
		assert.ok(value, `${name} 必須是 rect 或合法空槽`);
		for (const field of ['left', 'top', 'width', 'height']) close(value[field], value[field], `${name}.${field}`);
		assert.ok(value.left / Math.max(1, input.width) + value.width / Math.max(1, input.width) <= input.width / Math.max(1, input.width) + 1e-6, `${name} 不得超出 root 寬度`);
		assert.ok(value.top / Math.max(1, input.height) + value.height / Math.max(1, input.height) <= input.height / Math.max(1, input.height) + 1e-6, `${name} 不得超出 root 高度`);
	}
	for (const name of ['maximumLeft', 'maximumRight', 'maximumBottom']) close(result[name], result[name], name);
	frozen(result);
	assert.deepEqual(input, before, '解析不得回寫保存偏好或 caller constraints');
	assert.ok(!Object.isFrozen(input) && !Object.isFrozen(input.layout) && !Object.isFrozen(input.leftConstraints), '解析不得凍結 caller');
	return result;
}

test('正常 root 左區全高、header 跨中央及右區、Bottom 只在 Stage 下方', () => {
	const result = check(args({ headerExtent: 40 }));
	rect(result.left, [0, 0, 100, 400], 'left');
	rect(result.header, [108, 0, 492, 40], 'header');
	rect(result.right, [480, 40, 120, 360], 'right');
	rect(result.stage, [108, 40, 364, 272], 'stage');
	rect(result.bottom, [108, 320, 364, 80], 'bottom');
	rect(result.leftHandle, [100, 0, 8, 400], 'leftHandle');
	rect(result.rightHandle, [472, 40, 8, 360], 'rightHandle');
	rect(result.bottomHandle, [108, 312, 364, 8], 'bottomHandle');
	close(result.maximumLeft, 464, 'maximumLeft');
	close(result.maximumRight, 484, 'maximumRight');
	close(result.maximumBottom, 352, 'maximumBottom');
});

test('左右 minimum 不足同比例退化為 48/96 且不回寫 extent', () => {
	const input = args({ width: 160, leftConstraints: { minExtent: 100 }, rightConstraints: { minExtent: 200 } });
	input.layout.left.extent = 180;
	input.layout.right.extent = 240;
	input.layout.bottom.groups = [];
	const result = check(input);
	rect(result.left, [0, 0, 48, 400], 'left');
	rect(result.stage, [56, 0, 0, 400], 'stage');
	rect(result.right, [64, 0, 96, 400], 'right');
	close(result.maximumLeft, 48, 'maximumLeft');
	close(result.maximumRight, 96, 'maximumRight');
});

test('header 與 Bottom shortage 保留零 Stage、有效 gutter 並 clamp 頂列', () => {
	const input = args({ height: 60, headerExtent: 20, bottomConstraints: { minExtent: 100 } });
	input.layout.left.groups = [];
	input.layout.right.groups = [];
	input.layout.bottom.extent = 200;
	let result = check(input);
	rect(result.header, [0, 0, 600, 20], 'header');
	rect(result.stage, [0, 20, 600, 0], 'stage');
	rect(result.bottomHandle, [0, 20, 600, 8], 'bottomHandle');
	rect(result.bottom, [0, 28, 600, 32], 'bottom');
	close(result.maximumBottom, 32, 'maximumBottom');
	input.headerExtent = 200;
	result = check(input);
	rect(result.header, [0, 0, 600, 60], 'header');
	rect(result.stage, [0, 60, 600, 0], 'stage');
	rect(result.bottom, [0, 60, 600, 0], 'bottom');
	rect(result.bottomHandle, [0, 60, 600, 0], 'bottomHandle');
	close(result.maximumBottom, 0, 'maximumBottom');
});

test('hidden/empty 不占正文與 gutter，reopen handle clamp 在可用軸內', () => {
	for (const [width, height] of [[200, 120], [0, 0], [0, 120], [200, 0]]) {
		const input = args({ width, height, headerExtent: 20, handleExtent: 1e308 });
		input.layout.left.isVisible = false;
		input.layout.right.groups = [];
		input.layout.bottom.isVisible = false;
		const result = check(input);
		const header = Math.min(20, height);
		assert.equal(result.left, null);
		assert.equal(result.right, null);
		assert.equal(result.bottom, null);
		rect(result.stage, [0, header, width, height - header], 'stage');
		rect(result.leftHandle, [0, 0, width, height], 'leftHandle');
		rect(result.rightHandle, [0, header, width, height - header], 'rightHandle');
		rect(result.bottomHandle, [0, header, width, height - header], 'bottomHandle');
	}
});

test('巨大 handle 先吃滿有限軸，零 handle 與零 viewport 仍守恆', () => {
	for (const handleExtent of [1e308, 0]) {
		for (const [width, height] of [[200, 120], [0, 0], [0, 120], [200, 0]]) {
			const result = check(args({ width, height, handleExtent }));
			if (handleExtent === 1e308) {
				rect(result.left, [0, 0, 0, height], 'left');
				rect(result.right, [width, 0, 0, height], 'right');
				rect(result.stage, [width / 2, 0, 0, 0], 'stage');
				rect(result.leftHandle, [0, 0, width / 2, height], 'leftHandle');
				rect(result.rightHandle, [width / 2, 0, width / 2, height], 'rightHandle');
				rect(result.bottomHandle, [width / 2, 0, 0, height], 'bottomHandle');
				close(result.maximumLeft, 0, 'maximumLeft');
				close(result.maximumRight, 0, 'maximumRight');
				close(result.maximumBottom, 0, 'maximumBottom');
			} else if (width === 200 && height === 120) {
				rect(result.left, [0, 0, 80 + 40 / 3, 120], 'left');
				rect(result.right, [80 + 40 / 3, 0, 80 + 80 / 3, 120], 'right');
				rect(result.stage, [80 + 40 / 3, 0, 0, 40], 'stage');
			}
		}
	}
});

test('resize budget 扣另一 actual side 與有效 handles，正 Infinity 無邏輯上限', () => {
	// 此跨框架例子明定把手為 4：400 - 另一側 100 - 兩個把手 4 = 292。
	const input = args({ width: 400, handleExtent: 4, leftConstraints: { minExtent: 80, maxExtent: Infinity }, rightConstraints: { minExtent: 80, maxExtent: Infinity }, bottomConstraints: { minExtent: 40, maxExtent: Infinity } });
	input.layout.right.extent = 100;
	const result = check(input);
	close(result.maximumLeft, 292, 'maximumLeft');
	close(result.maximumRight, 292, 'maximumRight');
	const omitted = structuredClone(input);
	for (const name of ['leftConstraints', 'rightConstraints', 'bottomConstraints']) delete omitted[name].maxExtent;
	assert.deepEqual(check(omitted), result, '省略 maximum 與正 Infinity 幾何相同');
});

test('省略 header 與零高 header 有別；省略 Bottom constraints 僅合法 hidden 且空', () => {
	const input = args();
	input.layout.bottom.isVisible = false;
	input.layout.bottom.groups = [];
	delete input.bottomConstraints;
	const result = check(input);
	assert.equal(result.header, null);
	rect(result.right, [480, 0, 120, 400], 'right');
	rect(result.bottomHandle, [108, 400, 364, 0], 'bottomHandle');
	close(result.maximumBottom, 400, 'maximumBottom');
	rect(check({ ...input, headerExtent: 0 }).header, [108, 0, 492, 0], '零高 header');
	for (const bottom of [area('b', 80, { visible: false }), area('b', 80, { empty: true })]) {
		assert.throws(() => resolveKlpDockGeometry({ ...input, layout: { ...input.layout, bottom } }), TypeError);
	}
});

test('非法有限參數、constraints 與 malformed layout 原子拒絕且不修改 caller', () => {
	const mutations = [];
	for (const field of ['width', 'height', 'handleExtent', 'headerExtent']) {
		for (const value of [-1, NaN, Infinity, -Infinity, null, '8']) mutations.push((input) => input[field] = value);
	}
	for (const name of ['leftConstraints', 'rightConstraints', 'bottomConstraints']) {
		for (const value of [-1, NaN, Infinity, -Infinity, null, '8']) mutations.push((input) => input[name].minExtent = value);
		for (const value of [-1, NaN, -Infinity, null, '8', 1]) mutations.push((input) => input[name].maxExtent = value);
		mutations.push((input) => input[name] = null);
		mutations.push((input) => delete input[name].minExtent);
	}
	for (const name of ['width', 'height', 'handleExtent', 'layout', 'leftConstraints', 'rightConstraints']) mutations.push((input) => delete input[name]);
	mutations.push((input) => input.layout.left.extent = Infinity);
	mutations.push((input) => input.layout.left.groups[0].activePanelId = 'outside');
	mutations.push((input) => input.layout.right.groups[0].id = input.layout.left.groups[0].id);
	mutations.push((input) => input.layout.left.unknown = true);
	mutations.push((input) => input.layout = null);
	for (const mutate of mutations) {
		const input = args();
		mutate(input);
		const before = structuredClone(input);
		assert.throws(() => resolveKlpDockGeometry(input), TypeError, '非法公開參數必須拒絕');
		assert.deepEqual(input, before, '拒絕不得部分改寫 caller');
		assert.ok(!Object.isFrozen(input), '拒絕不得凍結 caller');
	}
	for (const input of [null, undefined, [], 1]) assert.throws(() => resolveKlpDockGeometry(input), TypeError);
});

test('deep frozen snapshot 與可修改 caller、重複呼叫互相隔離', () => {
	const input = args({ headerExtent: 40 });
	const first = check(input);
	const before = structuredClone(first);
	assert.throws(() => first.stage.width = 99, TypeError);
	assert.throws(() => first.leftHandle.left = 99, TypeError);
	assert.throws(() => first.maximumLeft = 99, TypeError);
	input.layout.left.extent = 180;
	input.layout.left.groups[0].panelIds.push('extra');
	input.leftConstraints.minExtent = 100;
	const second = check(input);
	assert.notStrictEqual(second, first);
	assert.notStrictEqual(second.stage, first.stage);
	close(second.left.width, 180, '後續 caller left');
	assert.deepEqual(first, before, 'caller 及新結果不得污染舊 snapshot');
	assert.deepEqual(check(args({ headerExtent: 40 })), before, '重複原始呼叫結果保持一致');
});
