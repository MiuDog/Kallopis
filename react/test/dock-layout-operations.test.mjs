import assert from 'node:assert/strict';
import test from 'node:test';
import { applyKlpDockAction, encodeKlpDockLayout, restoreKlpDockLayout } from '../dist/index.js';

// 手寫最小布局；policy 與預期值不依賴產品實作。
const layout = () => ({
	left: { axis: 'vertical', isVisible: false, extent: 120, groups: [
		{ id: 'left', panelIds: ['a', 'b', 'c'], activePanelId: 'b', mainAxisExtent: 80 },
	] },
	right: { axis: 'horizontal', isVisible: false, extent: 0, groups: [
		{ id: 'right', panelIds: ['d'], activePanelId: 'd', mainAxisExtent: 30 },
	] },
	bottom: { axis: 'horizontal', isVisible: false, extent: 90, groups: [
		{ id: 'bottom', panelIds: ['e'], activePanelId: 'e', mainAxisExtent: 40 },
	] },
});
const policies = () => ['a', 'b', 'c', 'd', 'e', 'idle'].map((id) => ({ id }));
const tab = (area, groupId, index) => ({ kind: 'tab', area, groupId, index });
const newGroup = (area, groupId, index, extent = 25.5) => ({ kind: 'group', area, groupId, index, extent });
const group = (value, area) => value[area].groups[0];

function frozen(value) {
	if (value === null || typeof value !== 'object') return;
	assert.ok(Object.isFrozen(value), '所有結果布局物件及陣列必須不可變');
	for (const child of Object.values(value)) frozen(child);
}

function checked(source, panels, action, expected) {
	const before = structuredClone({ source, panels, action });
	const result = applyKlpDockAction(source, panels, action);
	assert.deepEqual(result.layout, expected, '單步操作只能改變契約指定的保存值');
	assert.equal(result.changed, JSON.stringify(before.source) !== JSON.stringify(expected));
	assert.deepEqual({ source, panels, action }, before, '成功與 no-op 都不得改寫 caller');
	assert.ok(!Object.isFrozen(source) && !Object.isFrozen(panels) && !Object.isFrozen(action), '不得凍結 caller');
	assert.notStrictEqual(result.layout, source, 'no-op 也要隔離布局快照');
	assert.notStrictEqual(result.layout.left.groups, source.left.groups);
	frozen(result.layout);
	assert.deepEqual(restoreKlpDockLayout(encodeKlpDockLayout(result.layout), panels).layout, expected);
	return result;
}

function rejected(action, source = layout(), panels = policies(), reason = '非法操作必須原子拒絕') {
	const before = structuredClone({ source, panels, action });
	assert.throws(() => applyKlpDockAction(source, panels, action), TypeError, reason);
	assert.deepEqual({ source, panels, action }, before, '失敗不得部分修改 caller');
}

test('select 不展開 area，同群重排使用移除來源後的最終 index', () => {
	const source = layout();
	const expected = layout();
	group(expected, 'left').activePanelId = 'c';
	checked(source, policies(), { type: 'select', panelId: 'c' }, expected);
	checked(source, policies(), { type: 'select', panelId: 'b' }, source);
	const reordered = layout();
	group(reordered, 'left').panelIds = ['b', 'c', 'a'];
	group(reordered, 'left').activePanelId = 'a';
	reordered.left.isVisible = true;
	checked(source, policies(), { type: 'move', panelId: 'a', destination: tab('left', 'left', 2) }, reordered);
	const lone = layout();
	lone.right.isVisible = true;
	checked(lone, policies(), { type: 'move', panelId: 'd', destination: tab('right', 'right', 0) }, lone);
});

test('跨區 tab move 保留來源偏好尺寸、active fallback 並移除空 group', () => {
	const expected = layout();
	group(expected, 'left').panelIds = ['a', 'c'];
	group(expected, 'left').activePanelId = 'a';
	group(expected, 'right').panelIds = ['d', 'b'];
	group(expected, 'right').activePanelId = 'b';
	expected.right.isVisible = true;
	checked(layout(), policies(), { type: 'move', panelId: 'b', destination: tab('right', 'right', 1) }, expected);
	const emptySource = layout();
	emptySource.right.groups = [];
	group(emptySource, 'bottom').panelIds = ['d', 'e'];
	group(emptySource, 'bottom').activePanelId = 'd';
	emptySource.bottom.isVisible = true;
	checked(layout(), policies(), { type: 'move', panelId: 'd', destination: tab('bottom', 'bottom', 0) }, emptySource);
});

test('split 與 open 新 group 保留原字元、偏好尺寸及 final group index', () => {
	const expected = layout();
	group(expected, 'left').panelIds = ['a', 'c'];
	group(expected, 'left').activePanelId = 'a';
	expected.left.groups.push({ id: ' split ', panelIds: ['b'], activePanelId: 'b', mainAxisExtent: 25.5 });
	expected.left.isVisible = true;
	checked(layout(), policies(), { type: 'move', panelId: 'b', destination: newGroup('left', ' split ', 1) }, expected);
	const replaced = layout();
	replaced.right.groups = [{ id: 'new', panelIds: ['d'], activePanelId: 'd', mainAxisExtent: 9999 }];
	replaced.right.isVisible = true;
	checked(layout(), policies(), { type: 'move', panelId: 'd', destination: newGroup('right', 'new', 0, 9999) }, replaced);
	const opened = layout();
	opened.bottom.groups.unshift({ id: 'opened', panelIds: ['idle'], activePanelId: 'idle', mainAxisExtent: 25.5 });
	opened.bottom.isVisible = true;
	checked(layout(), policies(), { type: 'open', panelId: 'idle', destination: newGroup('bottom', 'opened', 0) }, opened);
});

test('merge 依來源 tab 順序插入，目標 active 取來源且來源 area 原值保留', () => {
	const expected = layout();
	expected.left.groups = [];
	group(expected, 'right').panelIds = ['d', 'a', 'b', 'c'];
	group(expected, 'right').activePanelId = 'b';
	expected.right.isVisible = true;
	checked(layout(), policies(), { type: 'merge', sourceGroupId: 'left', targetGroupId: 'right', index: 1 }, expected);
	const sameArea = layout();
	sameArea.left.groups.push({ id: 'second', panelIds: ['idle'], activePanelId: 'idle', mainAxisExtent: 10 });
	const combined = structuredClone(sameArea);
	combined.left.groups.shift();
	group(combined, 'left').panelIds = ['a', 'b', 'c', 'idle'];
	group(combined, 'left').activePanelId = 'b';
	combined.left.isVisible = true;
	checked(sameArea, policies(), { type: 'merge', sourceGroupId: 'left', targetGroupId: 'second', index: 0 }, combined);
});

test('close denied 為 no-op，approved fallback／刪空 group 並可由完整 registry 再 open', () => {
	checked(layout(), policies(), { type: 'close', panelId: 'b', approved: false }, layout());
	const expected = layout();
	group(expected, 'left').panelIds = ['a', 'c'];
	group(expected, 'left').activePanelId = 'a';
	checked(layout(), policies(), { type: 'close', panelId: 'b', approved: true }, expected);
	const closed = layout();
	closed.right.groups = [];
	const result = checked(layout(), policies(), { type: 'close', panelId: 'd', approved: true }, closed);
	assert.deepEqual(restoreKlpDockLayout(encodeKlpDockLayout(result.layout), policies()).availablePanelIds, ['d', 'idle']);
	const reopened = structuredClone(closed);
	group(reopened, 'bottom').panelIds = ['e', 'd'];
	group(reopened, 'bottom').activePanelId = 'd';
	reopened.bottom.isVisible = true;
	checked(structuredClone(result.layout), policies(), { type: 'open', panelId: 'd', destination: tab('bottom', 'bottom', 1) }, reopened);
});

test('visibility 可 collapse／reopen；resize 只保存偏好值，允許 area 零及超 viewport 值', () => {
	const shown = layout();
	shown.left.isVisible = true;
	checked(layout(), policies(), { type: 'visibility', area: 'left', isVisible: true }, shown);
	checked(shown, policies(), { type: 'visibility', area: 'left', isVisible: false }, layout());
	checked(layout(), policies(), { type: 'visibility', area: 'left', isVisible: false }, layout());
	for (const extent of [0, 12345.5]) {
		const expected = layout();
		expected.left.extent = extent;
		checked(layout(), policies(), { type: 'resizeArea', area: 'left', extent }, expected);
	}
	const expected = layout();
	group(expected, 'left').mainAxisExtent = 12345.5;
	checked(layout(), policies(), { type: 'resizeGroup', groupId: 'left', extent: 12345.5 }, expected);
	checked(layout(), policies(), { type: 'resizeGroup', groupId: 'left', extent: 80 }, layout());
});

test('操作前先拒絕非法／缺清冊／原 capability 衝突，不能以 close 或 no-op 修復', () => {
	const denied = { type: 'close', panelId: 'b', approved: false };
	for (const panels of [
		policies().filter((panel) => panel.id !== 'b'),
		[...policies(), { id: 'a' }],
		[...policies(), { id: 'unknown', extra: true }],
		policies().map((panel) => panel.id === 'b' ? { id: 'b', allowSide: false } : panel),
	]) rejected(denied, layout(), panels);
	const invalid = layout();
	group(invalid, 'left').activePanelId = 'missing';
	rejected({ type: 'close', panelId: 'b', approved: true }, invalid);
	const unknown = layout();
	unknown.left.extra = true;
	rejected(denied, unknown);
	const panels = policies().map((panel) => panel.id === 'b' ? { id: 'b', allowBottom: false } : panel);
	rejected({ type: 'move', panelId: 'b', destination: tab('bottom', 'bottom', 0) }, layout(), panels);
	rejected({ type: 'merge', sourceGroupId: 'left', targetGroupId: 'bottom', index: 0 }, layout(), panels);
	const bottomOnly = policies().map((panel) => panel.id === 'idle' ? { id: 'idle', allowSide: false } : panel);
	rejected({ type: 'open', panelId: 'idle', destination: newGroup('right', 'new', 0) }, layout(), bottomOnly);
});

test('action 與 destination 拒絕缺欄、未知欄、錯誤型別及非法 identity', () => {
	const actions = [
		{ type: 'select', panelId: 'a' },
		{ type: 'move', panelId: 'a', destination: tab('right', 'right', 0) },
		{ type: 'open', panelId: 'idle', destination: newGroup('right', 'new', 0) },
		{ type: 'merge', sourceGroupId: 'left', targetGroupId: 'right', index: 0 },
		{ type: 'close', panelId: 'a', approved: false },
		{ type: 'visibility', area: 'left', isVisible: true },
		{ type: 'resizeArea', area: 'left', extent: 0 },
		{ type: 'resizeGroup', groupId: 'left', extent: 1 },
	];
	for (const action of actions) {
		rejected({ ...action, extra: true });
		for (const field of Object.keys(action)) {
			const missing = structuredClone(action);
			delete missing[field];
			rejected(missing);
			rejected({ ...action, [field]: null });
		}
	}
	for (const destination of [tab('right', 'right', 0), newGroup('right', 'new', 0)]) {
		rejected({ type: 'move', panelId: 'a', destination: { ...destination, extra: true } });
		for (const field of Object.keys(destination)) {
			const missing = { ...destination };
			delete missing[field];
			rejected({ type: 'move', panelId: 'a', destination: missing });
			rejected({ type: 'move', panelId: 'a', destination: { ...destination, [field]: null } });
		}
	}
	for (const action of [undefined, null, [], {}, { type: 'unknown' },
		{ type: 'close', panelId: 'a', approved: 1 },
		{ type: 'visibility', area: 'left', isVisible: 'true' },
		{ type: 'visibility', area: 'stage', isVisible: true },
		{ type: 'resizeArea', area: 'stage', extent: 1 },
		{ type: 'open', panelId: 'missing', destination: tab('right', 'right', 0) },
		{ type: 'merge', sourceGroupId: 'left', targetGroupId: 'missing', index: 0 },
		{ type: 'move', panelId: 'a', destination: tab('bottom', 'right', 0) },
		{ type: 'merge', sourceGroupId: 'left', targetGroupId: 'left', index: 0 },
		{ type: 'open', panelId: 'a', destination: tab('right', 'right', 0) },
		{ type: 'move', panelId: 'idle', destination: tab('right', 'right', 0) },
	]) rejected(action);
	for (const id of ['', ' \t ', 'missing']) {
		rejected({ type: 'select', panelId: id });
		rejected({ type: 'close', panelId: id, approved: false });
		rejected({ type: 'resizeGroup', groupId: id, extent: 1 });
		rejected({ type: 'merge', sourceGroupId: id, targetGroupId: 'right', index: 0 });
		rejected({ type: 'move', panelId: 'a', destination: tab('right', id, 0) });
	}
	for (const id of ['', ' \t ', 'left', 'right', 'bottom']) {
		rejected({ type: 'move', panelId: 'd', destination: newGroup('right', id, 0) }, layout(), policies(), 'new group id 不得重用操作前任何 group id');
	}
});

test('index 不 clamp 且使用 final 長度，geometry 拒絕非有限／負數及 group 零', () => {
	for (const index of [-1, 0.5, NaN, Infinity, '0']) {
		rejected({ type: 'move', panelId: 'a', destination: tab('right', 'right', index) });
		rejected({ type: 'open', panelId: 'idle', destination: newGroup('right', 'new', index) });
		rejected({ type: 'merge', sourceGroupId: 'left', targetGroupId: 'right', index });
	}
	rejected({ type: 'move', panelId: 'a', destination: tab('left', 'left', 3) });
	rejected({ type: 'move', panelId: 'd', destination: tab('right', 'right', 1) });
	rejected({ type: 'move', panelId: 'd', destination: newGroup('right', 'new', 1) });
	rejected({ type: 'open', panelId: 'idle', destination: newGroup('right', 'new', 2) });
	rejected({ type: 'merge', sourceGroupId: 'left', targetGroupId: 'right', index: 2 });
	for (const extent of [NaN, Infinity, -Infinity, -1, '2']) {
		rejected({ type: 'resizeArea', area: 'left', extent });
		rejected({ type: 'resizeGroup', groupId: 'left', extent });
		rejected({ type: 'open', panelId: 'idle', destination: newGroup('right', 'new', 0, extent) });
	}
	rejected({ type: 'resizeGroup', groupId: 'left', extent: 0 });
	rejected({ type: 'open', panelId: 'idle', destination: newGroup('right', 'new', 0, 0) });
});

test('結果拒絕 mutation，caller 後續修改不污染成功及 no-op 快照', () => {
	for (const action of [{ type: 'select', panelId: 'a' }, { type: 'close', panelId: 'b', approved: false }]) {
		const source = layout();
		const panels = policies();
		const expected = layout();
		if (action.type === 'select') group(expected, 'left').activePanelId = 'a';
		const result = checked(source, panels, action, expected);
		assert.throws(() => result.layout.left.extent = 1, TypeError);
		assert.throws(() => group(result.layout, 'left').panelIds.push('idle'), TypeError);
		assert.throws(() => result.layout.right.groups.length = 0, TypeError);
		source.left.groups[0].panelIds.length = 0;
		source.right.groups.length = 0;
		panels[0].id = 'changed';
		action.panelId = 'changed';
		assert.deepEqual(result.layout, expected);
	}
});
