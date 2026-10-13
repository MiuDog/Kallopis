import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 與 React 共用手寫 wire；不以 codec 自產資料取代格式驗證。
const _wire = '''{
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
}''';

final _allPanels = <KlpDockPanelPolicy>[
	KlpDockPanelPolicy(id: 'a'),
	KlpDockPanelPolicy(id: 'gone'),
	KlpDockPanelPolicy(id: 'b'),
	KlpDockPanelPolicy(id: 'gone2'),
	KlpDockPanelPolicy(id: 'c'),
	KlpDockPanelPolicy(id: 'd'),
];

Map<String, dynamic> _document() => jsonDecode(_wire) as Map<String, dynamic>;
Map<String, dynamic> _area(Map<String, dynamic> document, String name) => document['areas'][name] as Map<String, dynamic>;
Map<String, dynamic> _group(Map<String, dynamic> document, String name) => _area(document, name)['groups'][0] as Map<String, dynamic>;

void main() {
	test('公開手寫 wire 保留順序、原始 identity 與全部布局值', () {
		final result = KlpDockLayoutCodec.restore(_wire, panels: _allPanels);
		expect(result.missingPanelIds, isEmpty);
		expect(result.availablePanelIds, isEmpty);
		expect(jsonDecode(KlpDockLayoutCodec.encode(result.layout)), _document());
		expect(result.layout.left.axis, Axis.horizontal);
		expect(result.layout.left.isVisible, isFalse);
		expect(result.layout.left.extent, 120.5);
		expect(result.layout.left.groups.map((group) => group.id), [' left ', 'remove']);
		expect(result.layout.left.groups.first.panelIds, ['a', 'gone', 'b']);
		expect(result.layout.left.groups.first.activePanelId, 'gone');
		expect(result.layout.left.groups.first.mainAxisExtent, 77.25);
		final second = KlpDockLayoutCodec.restore(KlpDockLayoutCodec.encode(result.layout), panels: _allPanels);
		expect(jsonDecode(KlpDockLayoutCodec.encode(second.layout)), _document());
	});

	test('missing 按保存順序移除，active 回退，available 按 registry 順序', () {
		final panels = <KlpDockPanelPolicy>[
			KlpDockPanelPolicy(id: 'new'),
			KlpDockPanelPolicy(id: 'b'),
			KlpDockPanelPolicy(id: 'a'),
			KlpDockPanelPolicy(id: 'c'),
			KlpDockPanelPolicy(id: 'd'),
			KlpDockPanelPolicy(id: 'idle'),
		];
		final result = KlpDockLayoutCodec.restore(_wire, panels: panels);
		expect(result.missingPanelIds, ['gone', 'gone2']);
		expect(result.availablePanelIds, ['new', 'idle']);
		final expected = _document();
		_area(expected, 'left')['groups'].removeAt(1);
		_group(expected, 'left')['panelIds'] = ['a', 'b'];
		_group(expected, 'left')['activePanelId'] = 'a';
		expect(jsonDecode(KlpDockLayoutCodec.encode(result.layout)), expected);
		expect(panels.map((panel) => panel.id), ['new', 'b', 'a', 'c', 'd', 'idle']);
		panels.clear();
		expect(result.availablePanelIds, ['new', 'idle']);
		final empty = KlpDockLayoutCodec.restore(_wire, panels: []);
		expect(empty.missingPanelIds, ['a', 'gone', 'b', 'gone2', 'c', 'd']);
		for (final name in ['left', 'right', 'bottom']) {
			_area(expected, name)['groups'] = <dynamic>[];
		}
		expect(jsonDecode(KlpDockLayoutCodec.encode(empty.layout)), expected);
	});

	test('所有層拒絕缺欄、未知欄及錯誤型別', () {
		final levels = <Map<String, dynamic> Function(Map<String, dynamic>)>[
			(document) => document,
			(document) => document['areas'] as Map<String, dynamic>,
			(document) => _area(document, 'left'),
			(document) => _group(document, 'left'),
		];
		for (final select in levels) {
			final fields = select(_document()).keys.toList();
			for (final field in fields) {
				final missing = _document();
				select(missing).remove(field);
				_reject(jsonEncode(missing), '缺少 $field');
				final wrongType = _document();
				select(wrongType)[field] = null;
				_reject(jsonEncode(wrongType), '$field 錯誤型別');
			}
			final extra = _document();
			select(extra)['unknown'] = true;
			_reject(jsonEncode(extra), '未知欄位');
		}
	});

	test('跨語言拒絕樣本涵蓋版本、identity、active 與幾何', () {
		for (final source in ['{', 'null', '[]', _wire.replaceFirst('"schemaVersion": 1', '"schemaVersion": 2')]) {
			_reject(source, 'JSON 或版本非法');
		}
		final mutations = <void Function(Map<String, dynamic>)>[
			(document) => _area(document, 'left')['axis'] = 'diagonal',
			(document) => _area(document, 'left')['isVisible'] = 1,
			(document) => _group(document, 'left')['panelIds'] = [],
			(document) => _group(document, 'left')['panelIds'] = ['a', 1],
			(document) => _group(document, 'left')['panelIds'] = ['a', 'a'],
			(document) => _group(document, 'left')['activePanelId'] = 'outside',
			(document) => _group(document, 'right')['id'] = ' left ',
			(document) {
				_group(document, 'bottom')['panelIds'] = ['a'];
				_group(document, 'bottom')['activePanelId'] = 'a';
			},
		];
		for (final invalidId in ['', ' \t ']) {
			mutations.add((document) => _group(document, 'left')['id'] = invalidId);
			mutations.add((document) {
				_group(document, 'left')['panelIds'] = [invalidId];
				_group(document, 'left')['activePanelId'] = invalidId;
			});
		}
		for (final mutate in mutations) {
			final document = _document();
			mutate(document);
			_reject(jsonEncode(document), '非法結構或全域 identity');
		}
		for (final value in ['NaN', 'Infinity', '-Infinity', '1e400', '-1']) {
			_reject(_wire.replaceFirst('"extent":120.5', '"extent":$value'), 'area extent $value');
			_reject(_wire.replaceFirst('"mainAxisExtent":77.25', '"mainAxisExtent":$value'), 'group extent $value');
		}
		_reject(_wire.replaceFirst('"mainAxisExtent":77.25', '"mainAxisExtent":0'), 'group extent 零');
		// 完整驗證必須先於 missing reconciliation，不可刪除非法資料來假裝成功。
		final invalid = _document();
		_group(invalid, 'bottom')['panelIds'] = ['a'];
		_group(invalid, 'bottom')['activePanelId'] = 'a';
		expect(() => KlpDockLayoutCodec.restore(jsonEncode(invalid), panels: []), throwsFormatException);
	});

	test('registry 非法 id、重複與已存在 panel capability 整份拒絕', () {
		for (final panels in <List<KlpDockPanelPolicy>>[
			[KlpDockPanelPolicy(id: '')],
			[KlpDockPanelPolicy(id: ' \t ')],
			[KlpDockPanelPolicy(id: 'a'), KlpDockPanelPolicy(id: 'a')],
			[KlpDockPanelPolicy(id: 'a', allowSide: false)],
			[KlpDockPanelPolicy(id: 'c', allowSide: false)],
			[KlpDockPanelPolicy(id: 'd', allowBottom: false)],
		]) {
			expect(() => KlpDockLayoutCodec.restore(_wire, panels: panels), throwsFormatException);
		}
		final permitted = KlpDockLayoutCodec.restore(_wire, panels: [
			KlpDockPanelPolicy(id: 'a', allowBottom: false),
			KlpDockPanelPolicy(id: 'd', allowSide: false),
			KlpDockPanelPolicy(id: 'unplaced', allowSide: false, allowBottom: false),
		]);
		expect(permitted.availablePanelIds, ['unplaced']);
	});

	test('encode 驗證現有布局，不依 registry 過濾或修改來源', () {
		final layout = KlpDockLayoutCodec.restore(_wire, panels: _allPanels).layout;
		final panelIds = ['a', 'gone', 'b'];
		final groups = [layout.left.groups.first.copyWith(panelIds: panelIds), layout.left.groups.last];
		final source = layout.copyWith(left: layout.left.copyWith(groups: groups));
		final encoded = KlpDockLayoutCodec.encode(source);
		expect(jsonDecode(encoded), _document());
		expect(source.left.groups, same(groups));
		expect(source.left.groups.first.panelIds, same(panelIds));
		expect(panelIds, ['a', 'gone', 'b']);
		expect(groups.length, 2);
		panelIds.clear();
		groups.clear();
		expect(jsonDecode(encoded), _document());
		final invalidLayouts = <KlpDockLayoutData>[
			layout.copyWith(left: layout.left.copyWith(extent: double.infinity)),
			layout.copyWith(left: layout.left.copyWith(groups: [layout.left.groups.first.copyWith(mainAxisExtent: double.infinity)])),
			layout.copyWith(left: layout.left.copyWith(groups: [layout.left.groups.first.copyWith(panelIds: [])])),
			layout.copyWith(left: layout.left.copyWith(groups: [layout.left.groups.first.copyWith(activePanelId: 'outside')])),
			layout.copyWith(right: layout.right.copyWith(groups: [layout.right.groups.first.copyWith(id: ' left ')])),
			layout.copyWith(bottom: layout.bottom.copyWith(groups: [layout.bottom.groups.first.copyWith(panelIds: ['a'], activePanelId: 'a')])),
		];
		for (final invalid in invalidLayouts) {
			expect(() => KlpDockLayoutCodec.encode(invalid), throwsFormatException);
		}
		expect(jsonDecode(KlpDockLayoutCodec.encode(layout)), _document());
	});

	test('restore 結果所有巢狀集合及 diagnostics 不可變', () {
		final result = KlpDockLayoutCodec.restore(_wire, panels: _allPanels);
		for (final area in [result.layout.left, result.layout.right, result.layout.bottom]) {
			expect(() => area.groups.add(area.groups.first), throwsUnsupportedError);
			expect(() => area.groups[0] = area.groups.first, throwsUnsupportedError);
			expect(() => area.groups.clear(), throwsUnsupportedError);
			for (final group in area.groups) {
				expect(() => group.panelIds.add('extra'), throwsUnsupportedError);
				expect(() => group.panelIds[0] = 'extra', throwsUnsupportedError);
				expect(() => group.panelIds.clear(), throwsUnsupportedError);
			}
		}
		final reconciled = KlpDockLayoutCodec.restore(_wire, panels: [KlpDockPanelPolicy(id: 'a'), KlpDockPanelPolicy(id: 'new')]);
		for (final ids in [result.missingPanelIds, result.availablePanelIds, reconciled.missingPanelIds, reconciled.availablePanelIds]) {
			expect(() => ids.add('extra'), throwsUnsupportedError);
			expect(() => ids.clear(), throwsUnsupportedError);
		}
		final empty = KlpDockLayoutCodec.restore(_wire, panels: []);
		for (final area in [empty.layout.left, empty.layout.right, empty.layout.bottom]) {
			expect(() => area.groups.add(result.layout.left.groups.first), throwsUnsupportedError);
		}
		expect(jsonDecode(KlpDockLayoutCodec.encode(result.layout)), _document());
	});
}

void _reject(String source, String reason) {
	expect(() => KlpDockLayoutCodec.restore(source, panels: _allPanels), throwsFormatException, reason: reason);
}
