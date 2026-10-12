import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 與 React operations 共用手寫初始值及操作情境。
KlpDockLayoutData _layout() => KlpDockLayoutData(
	left: KlpDockAreaData(axis: Axis.vertical, isVisible: false, extent: 120, groups: [
		KlpDockGroupData(id: 'left', panelIds: ['a', 'b', 'c'], activePanelId: 'b', mainAxisExtent: 80),
	]),
	right: KlpDockAreaData(axis: Axis.horizontal, isVisible: false, extent: 0, groups: [
		KlpDockGroupData(id: 'right', panelIds: ['d'], activePanelId: 'd', mainAxisExtent: 30),
	]),
	bottom: KlpDockAreaData(axis: Axis.horizontal, isVisible: false, extent: 90, groups: [
		KlpDockGroupData(id: 'bottom', panelIds: ['e'], activePanelId: 'e', mainAxisExtent: 40),
	]),
);

List<KlpDockPanelPolicy> _panels() => ['a', 'b', 'c', 'd', 'e', 'idle'].map((id) => KlpDockPanelPolicy(id: id)).toList();
KlpDockDestination _tab(KlpDockArea area, String groupId, int index) => KlpDockDestination.tab(area: area, groupId: groupId, index: index);
KlpDockDestination _new(KlpDockArea area, String groupId, int index, [double extent = 25.5]) => KlpDockDestination.group(area: area, groupId: groupId, index: index, extent: extent);

// 直接觀察公開保存值；非法來源的快照也不經 codec 修復。
Map<String, dynamic> _value(KlpDockLayoutData layout) => {
	for (final entry in {'left': layout.left, 'right': layout.right, 'bottom': layout.bottom}.entries)
		entry.key: {
			'axis': entry.value.axis.name,
			'isVisible': entry.value.isVisible,
			'extent': entry.value.extent,
			'groups': [for (final group in entry.value.groups) {
				'id': group.id,
				'panelIds': [...group.panelIds],
				'activePanelId': group.activePanelId,
				'mainAxisExtent': group.mainAxisExtent,
			}],
		},
};
Map<String, dynamic> _expected() => _value(_layout());
Map<String, dynamic> _group(Map<String, dynamic> expected, String area) => expected[area]['groups'][0] as Map<String, dynamic>;
List<Object> _policyValue(List<KlpDockPanelPolicy> panels) => [for (final panel in panels) [panel.id, panel.allowSide, panel.allowBottom]];

KlpDockActionResult _checked(KlpDockLayoutData source, KlpDockAction action, Map<String, dynamic> expected, {List<KlpDockPanelPolicy>? panels}) {
	final registry = panels ?? _panels();
	final before = _value(source);
	final registryBefore = _policyValue(registry);
	final result = applyKlpDockAction(layout: source, panels: registry, action: action);
	expect(_value(result.layout), expected, reason: '只能改變契約指定的保存值');
	expect(result.changed, jsonEncode(before) != jsonEncode(expected));
	expect(_value(source), before, reason: '成功及 no-op 都不得改寫 caller');
	expect(_policyValue(registry), registryBefore);
	expect(identical(result.layout, source), isFalse);
	for (final area in [result.layout.left, result.layout.right, result.layout.bottom]) {
		expect(() => area.groups.clear(), throwsUnsupportedError);
		for (final group in area.groups) {
			expect(() => group.panelIds.add('idle'), throwsUnsupportedError);
		}
	}
	return result;
}

void _rejected(KlpDockAction action, {KlpDockLayoutData? source, List<KlpDockPanelPolicy>? panels}) {
	final layout = source ?? _layout();
	final registry = panels ?? _panels();
	final before = _value(layout);
	final registryBefore = _policyValue(registry);
	expect(() => applyKlpDockAction(layout: layout, panels: registry, action: action), throwsFormatException);
	expect(_value(layout), before, reason: '拒絕必須原子完成');
	expect(_policyValue(registry), registryBefore);
}

void main() {
	test('select 不展開 area；同群重排使用 final index 並保留單 tab group', () {
		final expected = _expected();
		_group(expected, 'left')['activePanelId'] = 'c';
		_checked(_layout(), const KlpDockAction.select(panelId: 'c'), expected);
		_checked(_layout(), const KlpDockAction.select(panelId: 'b'), _expected());
		final reordered = _expected();
		_group(reordered, 'left')['panelIds'] = ['b', 'c', 'a'];
		_group(reordered, 'left')['activePanelId'] = 'a';
		reordered['left']['isVisible'] = true;
		_checked(_layout(), KlpDockAction.move(panelId: 'a', destination: _tab(KlpDockArea.left, 'left', 2)), reordered);
		final lone = _layout();
		final shown = lone.copyWith(right: lone.right.copyWith(isVisible: true));
		_checked(shown, KlpDockAction.move(panelId: 'd', destination: _tab(KlpDockArea.right, 'right', 0)), _value(shown));
	});

	test('跨區 move 更新 active fallback、刪空 group 並保留來源尺寸', () {
		final expected = _expected();
		_group(expected, 'left')['panelIds'] = ['a', 'c'];
		_group(expected, 'left')['activePanelId'] = 'a';
		_group(expected, 'right')['panelIds'] = ['d', 'b'];
		_group(expected, 'right')['activePanelId'] = 'b';
		expected['right']['isVisible'] = true;
		_checked(_layout(), KlpDockAction.move(panelId: 'b', destination: _tab(KlpDockArea.right, 'right', 1)), expected);
		final emptied = _expected();
		emptied['right']['groups'] = [];
		_group(emptied, 'bottom')['panelIds'] = ['d', 'e'];
		_group(emptied, 'bottom')['activePanelId'] = 'd';
		emptied['bottom']['isVisible'] = true;
		_checked(_layout(), KlpDockAction.move(panelId: 'd', destination: _tab(KlpDockArea.bottom, 'bottom', 0)), emptied);
	});

	test('split 與 open 保留原 identity、尺寸與移除來源後 group index', () {
		final split = _expected();
		_group(split, 'left')['panelIds'] = ['a', 'c'];
		_group(split, 'left')['activePanelId'] = 'a';
		split['left']['groups'].add({'id': ' split ', 'panelIds': ['b'], 'activePanelId': 'b', 'mainAxisExtent': 25.5});
		split['left']['isVisible'] = true;
		_checked(_layout(), KlpDockAction.move(panelId: 'b', destination: _new(KlpDockArea.left, ' split ', 1)), split);
		final replaced = _expected();
		replaced['right']['groups'] = [{'id': 'new', 'panelIds': ['d'], 'activePanelId': 'd', 'mainAxisExtent': 9999.0}];
		replaced['right']['isVisible'] = true;
		_checked(_layout(), KlpDockAction.move(panelId: 'd', destination: _new(KlpDockArea.right, 'new', 0, 9999)), replaced);
		final opened = _expected();
		opened['bottom']['groups'].insert(0, {'id': 'opened', 'panelIds': ['idle'], 'activePanelId': 'idle', 'mainAxisExtent': 25.5});
		opened['bottom']['isVisible'] = true;
		_checked(_layout(), KlpDockAction.open(panelId: 'idle', destination: _new(KlpDockArea.bottom, 'opened', 0)), opened);
	});

	test('merge 保留 tab 順序、來源 active 與來源 area 原值', () {
		final expected = _expected();
		expected['left']['groups'] = [];
		_group(expected, 'right')['panelIds'] = ['d', 'a', 'b', 'c'];
		_group(expected, 'right')['activePanelId'] = 'b';
		expected['right']['isVisible'] = true;
		_checked(_layout(), const KlpDockAction.merge(sourceGroupId: 'left', targetGroupId: 'right', index: 1), expected);
		final same = _layout();
		same.left.groups.add(KlpDockGroupData(id: 'second', panelIds: ['idle'], activePanelId: 'idle', mainAxisExtent: 10));
		final combined = _value(same);
		combined['left']['groups'].removeAt(0);
		_group(combined, 'left')['panelIds'] = ['a', 'b', 'c', 'idle'];
		_group(combined, 'left')['activePanelId'] = 'b';
		combined['left']['isVisible'] = true;
		_checked(same, const KlpDockAction.merge(sourceGroupId: 'left', targetGroupId: 'second', index: 0), combined);
	});

	test('close denied no-op；approved fallback、刪空 group 後仍可 open', () {
		_checked(_layout(), const KlpDockAction.close(panelId: 'b', approved: false), _expected());
		final fallback = _expected();
		_group(fallback, 'left')['panelIds'] = ['a', 'c'];
		_group(fallback, 'left')['activePanelId'] = 'a';
		_checked(_layout(), const KlpDockAction.close(panelId: 'b', approved: true), fallback);
		final closed = _expected();
		closed['right']['groups'] = [];
		final result = _checked(_layout(), const KlpDockAction.close(panelId: 'd', approved: true), closed);
		expect(KlpDockLayoutCodec.restore(KlpDockLayoutCodec.encode(result.layout), panels: _panels()).availablePanelIds, ['d', 'idle']);
		final reopened = _value(result.layout);
		_group(reopened, 'bottom')['panelIds'] = ['e', 'd'];
		_group(reopened, 'bottom')['activePanelId'] = 'd';
		reopened['bottom']['isVisible'] = true;
		_checked(result.layout, KlpDockAction.open(panelId: 'd', destination: _tab(KlpDockArea.bottom, 'bottom', 1)), reopened);
	});

	test('visibility collapse／reopen 與 resize 只改偏好值，允許 area 零', () {
		final shown = _expected();
		shown['left']['isVisible'] = true;
		final result = _checked(_layout(), const KlpDockAction.visibility(area: KlpDockArea.left, isVisible: true), shown);
		_checked(result.layout, const KlpDockAction.visibility(area: KlpDockArea.left, isVisible: false), _expected());
		_checked(_layout(), const KlpDockAction.visibility(area: KlpDockArea.left, isVisible: false), _expected());
		for (final extent in [0.0, 12345.5]) {
			final expected = _expected();
			expected['left']['extent'] = extent;
			_checked(_layout(), KlpDockAction.resizeArea(area: KlpDockArea.left, extent: extent), expected);
		}
		final resized = _expected();
		_group(resized, 'left')['mainAxisExtent'] = 12345.5;
		_checked(_layout(), const KlpDockAction.resizeGroup(groupId: 'left', extent: 12345.5), resized);
		_checked(_layout(), const KlpDockAction.resizeGroup(groupId: 'left', extent: 80), _expected());
	});

	test('操作前拒絕缺清冊、重複 registry、非法 active 及 capability 衝突', () {
		const denied = KlpDockAction.close(panelId: 'b', approved: false);
		_rejected(denied, panels: _panels().where((panel) => panel.id != 'b').toList());
		_rejected(denied, panels: [..._panels(), KlpDockPanelPolicy(id: 'a')]);
		_rejected(denied, panels: [..._panels(), KlpDockPanelPolicy(id: ' \t ')]);
		_rejected(denied, panels: _panels().map((panel) => panel.id == 'b' ? KlpDockPanelPolicy(id: 'b', allowSide: false) : panel).toList());
		final invalid = _layout();
		invalid.left.groups[0] = invalid.left.groups[0].copyWith(activePanelId: 'missing');
		_rejected(const KlpDockAction.close(panelId: 'b', approved: true), source: invalid);
		final panels = _panels().map((panel) => panel.id == 'b' ? KlpDockPanelPolicy(id: 'b', allowBottom: false) : panel).toList();
		_rejected(KlpDockAction.move(panelId: 'b', destination: _tab(KlpDockArea.bottom, 'bottom', 0)), panels: panels);
		_rejected(const KlpDockAction.merge(sourceGroupId: 'left', targetGroupId: 'bottom', index: 0), panels: panels);
		_rejected(KlpDockAction.open(panelId: 'idle', destination: _new(KlpDockArea.right, 'new', 0)), panels: _panels().map((panel) => panel.id == 'idle' ? KlpDockPanelPolicy(id: 'idle', allowSide: false) : panel).toList());
	});

	test('拒絕不存在或非法 identity、錯誤 placement 與操作前重複新 group id', () {
		for (final id in ['', ' \t ', 'missing']) {
			_rejected(KlpDockAction.select(panelId: id));
			_rejected(KlpDockAction.close(panelId: id, approved: false));
			_rejected(KlpDockAction.resizeGroup(groupId: id, extent: 1));
			_rejected(KlpDockAction.merge(sourceGroupId: id, targetGroupId: 'right', index: 0));
			_rejected(KlpDockAction.move(panelId: 'a', destination: _tab(KlpDockArea.right, id, 0)));
		}
		for (final id in ['', ' \t ', 'left', 'right', 'bottom']) {
			_rejected(KlpDockAction.move(panelId: 'd', destination: _new(KlpDockArea.right, id, 0)));
		}
		_rejected(KlpDockAction.open(panelId: 'missing', destination: _tab(KlpDockArea.right, 'right', 0)));
		_rejected(const KlpDockAction.merge(sourceGroupId: 'left', targetGroupId: 'missing', index: 0));
		_rejected(const KlpDockAction.merge(sourceGroupId: 'left', targetGroupId: 'left', index: 0));
		_rejected(KlpDockAction.move(panelId: 'a', destination: _tab(KlpDockArea.bottom, 'right', 0)));
		_rejected(KlpDockAction.open(panelId: 'a', destination: _tab(KlpDockArea.right, 'right', 0)));
		_rejected(KlpDockAction.move(panelId: 'idle', destination: _tab(KlpDockArea.right, 'right', 0)));
	});

	test('index 不 clamp 且使用 final 長度；geometry 拒絕非有限、負數及 group 零', () {
		_rejected(KlpDockAction.move(panelId: 'a', destination: _tab(KlpDockArea.right, 'right', -1)));
		_rejected(KlpDockAction.open(panelId: 'idle', destination: _new(KlpDockArea.right, 'new', -1)));
		_rejected(const KlpDockAction.merge(sourceGroupId: 'left', targetGroupId: 'right', index: -1));
		_rejected(KlpDockAction.move(panelId: 'a', destination: _tab(KlpDockArea.left, 'left', 3)));
		_rejected(KlpDockAction.move(panelId: 'd', destination: _tab(KlpDockArea.right, 'right', 1)));
		_rejected(KlpDockAction.move(panelId: 'd', destination: _new(KlpDockArea.right, 'new', 1)));
		_rejected(KlpDockAction.open(panelId: 'idle', destination: _new(KlpDockArea.right, 'new', 2)));
		_rejected(const KlpDockAction.merge(sourceGroupId: 'left', targetGroupId: 'right', index: 2));
		for (final extent in [double.nan, double.infinity, double.negativeInfinity, -1.0]) {
			_rejected(KlpDockAction.resizeArea(area: KlpDockArea.left, extent: extent));
			_rejected(KlpDockAction.resizeGroup(groupId: 'left', extent: extent));
			_rejected(KlpDockAction.open(panelId: 'idle', destination: _new(KlpDockArea.right, 'new', 0, extent)));
		}
		_rejected(const KlpDockAction.resizeGroup(groupId: 'left', extent: 0));
		_rejected(KlpDockAction.open(panelId: 'idle', destination: _new(KlpDockArea.right, 'new', 0, 0)));
	});

	test('成功與 no-op 快照深層隔離，caller 後續仍可修改', () {
		for (final selects in [true, false]) {
			final action = selects ? const KlpDockAction.select(panelId: 'a') : const KlpDockAction.close(panelId: 'b', approved: false);
			final source = _layout();
			final panels = _panels();
			final expected = _expected();
			if (selects) _group(expected, 'left')['activePanelId'] = 'a';
			final result = _checked(source, action, expected, panels: panels);
			source.left.groups.first.panelIds.clear();
			source.right.groups.clear();
			panels.clear();
			expect(_value(result.layout), expected);
		}
	});
}
