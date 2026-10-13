import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_theme.dart';

// 只從共通公開入口取得期望值，不讀取 Flutter adapter 的實作。
void main() {
	late Map<String, Object?> source;
	late Map<String, Object?> catalog;
	late Map<String, Object?> reference;
	late Directory root;

	setUpAll(() async {
		root = Directory.current;
		while (!File('${root.path}/styles/kallopis-v1.json').existsSync()) {
			if (root.parent.path == root.path) {
				throw StateError('找不到共通 style pack 測試來源');
			}
			root = root.parent;
		}
		source = _map(jsonDecode(File('${root.path}/styles/kallopis-v1.json').readAsStringSync()));
		catalog = _map(jsonDecode(File('${root.path}/styles/catalog.json').readAsStringSync()));
		const script = '''
import fs from 'node:fs';
import {resolveStylePack} from './styles/src/index.mjs';
const pack = JSON.parse(fs.readFileSync('./styles/kallopis-v1.json', 'utf8'));
const catalog = JSON.parse(fs.readFileSync('./styles/catalog.json', 'utf8'));
const result = {};
for (const mode of ['light', 'dark', 'ultraDark', 'transparent']) {
	result[mode] = resolveStylePack(pack, mode, catalog).tokens;
}
console.log(JSON.stringify(result));
''';
		final result = await Process.run('node', ['--input-type=module', '-e', script], workingDirectory: root.path);
		expect(result.exitCode, 0, reason: '共通公開 resolver harness 失敗：${result.stderr}');
		reference = _map(jsonDecode(result.stdout as String));
	});

	test('JSON object／string 與 generated defaults 保存全部 canonical 資料', () {
		final object = KlpStylePack.parse(_clone(source));
		final string = KlpStylePack.parse(jsonEncode(source));
		expect(object.data, source);
		expect(string.data, source);
		expect(KlpStylePack.defaults().data, source);
		expect(klpStyleParameters, catalog['parameters']);
		expect(klpStyleParameters.length, 350);
	});

	for (final mode in KlpThemeVariant.values) {
		test('${mode.name} 的全部 350 semantic 與 Node 公開 resolver 一致', () {
			final actual = KlpStylePack.defaults().resolve(mode);
			final expected = _map(reference[mode.name]);
			expect(actual.length, 350);
			expect(actual.keys.toSet(), expected.keys.toSet());
			for (final id in expected.keys) {
				expect(actual[id], expected[id], reason: '${mode.name}: $id');
			}
		});

		test('${mode.name} 的全部 semantic 都有公開 native codec 映射', () {
			final encoded = KlpVisualStyleJson.encode(KlpStylePack.defaults().toVisualStyle(mode));
			final parameters = _map(catalog['parameters']);
			for (final entry in _map(reference[mode.name]).entries) {
				Object? expected = entry.value;
				final type = _map(parameters[entry.key])['type'];
				if (type == 'color') expected = _argb(expected as String);
				if (type == 'color-array') expected = (expected as List).map((v) => _argb(v as String)).toList();
				expect(_at(encoded, entry.key.substring('theme.'.length)), expected, reason: '${mode.name}: ${entry.key}');
			}
		});
	}

	test('輸入與 snapshot 深層隔離，所有公開資料不可變', () {
		final input = _clone(source);
		final pack = KlpStylePack.parse(input);
		final snapshot = pack.resolve(KlpThemeVariant.light);
		_map(input['primitives'])['parchment150'] = '#FF123456';
		_map(_map(input['semantics'])['theme.colors.app'])['light'] = 'p(ink1000)';
		expect(pack.data, source);
		expect(snapshot, reference['light']);
		_expectFrozen(pack.data);
		_expectFrozen(snapshot);
		_expectFrozen(klpStyleParameters);
	});

	test('部分 mode、primitive、s 引用、list 與 numeric add 原子覆寫', () {
		final pack = KlpStylePack.defaults();
		final before = pack.resolve(KlpThemeVariant.light);
		final overrides = <String, Object?>{
			'primitives': <String, Object?>{'parchment150': '#80123456'},
			'semantics': <String, Object?>{
				'theme.colors.app': <String, Object?>{'dark': 's(theme.colors.surface)'},
				'theme.spacing.controlPaddingX': <String, Object?>{'light': 'add(s(theme.spacing.tight), s(theme.spacing.space0_5))'},
				'theme.typography.sansFallback': <String, Object?>{'light': '[p(family-noto-sans-tc), p(family-sans-serif)]'},
			},
		};
		final changed = pack.applyOverrides(overrides);
		_map(overrides['primitives'])['parchment150'] = '#FFFFFFFF';
		expect(changed.resolve(KlpThemeVariant.light)['theme.colors.app'], '#80123456');
		expect(changed.resolve(KlpThemeVariant.dark)['theme.colors.app'], _map(reference['dark'])['theme.colors.surface']);
		expect(changed.resolve(KlpThemeVariant.light)['theme.spacing.controlPaddingX'],
			(_map(reference['light'])['theme.spacing.tight'] as num) + (_map(reference['light'])['theme.spacing.space0_5'] as num));
		expect(changed.resolve(KlpThemeVariant.light)['theme.typography.sansFallback'], [
			_map(source['primitives'])['family-noto-sans-tc'],
			_map(source['primitives'])['family-sans-serif'],
		]);
		expect(changed.resolve(KlpThemeVariant.ultraDark), reference['ultraDark']);
		expect(pack.data, source);
		expect(before, reference['light']);
	});

	test('任何 mode 失敗都拒絕整批覆寫，來源與舊 snapshot 不變', () {
		final pack = KlpStylePack.defaults();
		final snapshot = pack.resolve(KlpThemeVariant.light);
		_expectRejected(() => pack.applyOverrides({
			'primitives': {'parchment150': '#FF123456'},
			'semantics': {'theme.spacing.controlPaddingX': {'transparent': 'p(trackingTight)'}},
		}), 'theme.spacing.controlPaddingX');
		expect(pack.data, source);
		expect(snapshot, reference['light']);
		for (final mode in KlpThemeVariant.values) {
			expect(pack.resolve(mode), reference[mode.name]);
		}
	});

	test('覆寫不可新增 ID、模式或行為根鍵', () {
		final pack = KlpStylePack.defaults();
		for (final overrides in <Map<String, Object?>>[
			{'primitives': {'unknown': 1}},
			{'semantics': {'theme.unknown': {'light': 'p(space100)'}}},
			{'semantics': {'theme.colors.app': {'unknown': 'p(ink1000)'}}},
			{'recipes': {}},
			{'constraints': []},
			{'handlers': {}},
		]) {
			expect(() => pack.applyOverrides(overrides), throwsA(anything), reason: '$overrides');
		}
	});

	test('交換版本、身份、canonical IDs、模式、引用與循環必須拒絕', () {
		final mutations = <void Function(Map<String, Object?>)>[
			(p) => p['schemaVersion'] = 2,
			(p) => p['id'] = '',
			(p) => p['version'] = '',
			(p) => p['primitives'] = [],
			(p) => _map(p['primitives']).remove('space0'),
			(p) => _map(p['primitives'])['newPrimitive'] = 1,
			(p) => _map(p['semantics']).remove('theme.colors.app'),
			(p) => _map(p['semantics'])['theme.unknown'] = _modes('p(space0)'),
			(p) => _map(p['recipes']).remove(_map(p['recipes']).keys.first),
			(p) => _map(_map(p['semantics'])['theme.colors.app']).remove('dark'),
			(p) => _map(_map(p['semantics'])['theme.colors.app'])['other'] = 'p(ink1000)',
			(p) => _map(_map(p['semantics'])['theme.colors.app'])['light'] = 'p(missing)',
			(p) => _map(_map(p['semantics'])['theme.colors.app'])['light'] = 's(theme.missing)',
			(p) => _map(_map(p['semantics'])['theme.colors.app'])['light'] = 's(theme.colors.app)',
			(p) {
				final semantics = _map(p['semantics']);
				_map(semantics['theme.colors.app'])['dark'] = 's(theme.colors.surface)';
				_map(semantics['theme.colors.surface'])['dark'] = 's(theme.colors.app)';
			},
			(p) {
				final recipes = _map(p['recipes']);
				final id = recipes.keys.first;
				_map(recipes[id])['inherit'] = id;
			},
		];
		for (var i = 0; i < mutations.length; i++) {
			final input = _clone(source);
			mutations[i](input);
			expect(() => KlpStylePack.parse(input), throwsA(anything), reason: '非法交換案例 $i');
		}
		for (final input in [null, [], true, 1, '{broken']) {
			expect(() => KlpStylePack.parse(input), throwsA(anything));
		}
	});

	test('型別、有限數值與 catalog 範圍帶 semantic ID 診斷', () {
		final parameters = _map(catalog['parameters']);
		final expressions = <String, String>{
			'color': 'p(space100)',
			'color-array': '[p(space100)]',
			'font-family': 'p(space100)',
			'font-family-array': '[p(space100)]',
			'length': 'p(ink1000)',
			'ratio': 'p(space0)',
			'opacity': 'p(space100)',
			'duration': 'p(trackingTight)',
			'weight': 'p(space0)',
			'count': 'p(space0)',
			'curve': '[p(space100), p(space0), p(space0), p(space100)]',
			'symbol': 'p(space100)',
		};
		for (final entry in expressions.entries) {
			final id = parameters.entries.firstWhere((p) => _map(p.value)['type'] == entry.key).key;
			_expectRejected(() => KlpStylePack.defaults().applyOverrides({
				'semantics': {id: {'light': entry.value}},
			}), id);
		}
		for (final value in [double.nan, double.infinity, double.negativeInfinity, {}, [true]]) {
			final input = _clone(source);
			_map(input['primitives'])['space100'] = value;
			expect(() => KlpStylePack.parse(input), throwsA(anything));
		}
		for (final color in ['#123', '#GG123456']) {
			_expectRejected(() => KlpStylePack.defaults().applyOverrides({'primitives': {'parchment150': color}}), 'theme.colors.app');
		}
	});

	test('ordered 與 fits 不可被有效型別的數值繞過', () {
		for (final id in [
			'theme.geometry.control.textFieldMinLines',
			'theme.geometry.layout.settingsNavigationMinimumWidth',
			'theme.geometry.control.toggleThumb',
			'theme.geometry.control.segmentedDenseItemHeight',
		]) {
			_expectRejected(() => KlpStylePack.defaults().applyOverrides({
				'semantics': {id: {'light': 'p(radiusFull)'}},
			}), id);
		}
	});

	test('native duration 保留微秒，字重支援 1 到 1000', () {
		for (final weight in [1, 357, 1000]) {
			final pack = KlpStylePack.defaults().applyOverrides({'primitives': {'weight400': weight}});
			expect(pack.toVisualStyle(KlpThemeVariant.light).typography.regular.value, weight);
		}
		final pack = KlpStylePack.defaults().applyOverrides({
			'semantics': {'theme.motion.stateTransition': {'light': 'p(length-3_5)'}},
		});
		expect(pack.toVisualStyle(KlpThemeVariant.light).motion.stateTransition.inMicroseconds, 3500);
		final precise = KlpStylePack.defaults().applyOverrides({
			'primitives': {'length-3_5': 3.5001},
			'semantics': {'theme.motion.stateTransition': {'light': 'p(length-3_5)'}},
		});
		expect(precise.resolve(KlpThemeVariant.light)['theme.motion.stateTransition'], 3.5001);
		_expectRejected(() => precise.toVisualStyle(KlpThemeVariant.light), 'theme.motion.stateTransition');
	});

	test('pack 注入與顯式 style 互斥，透明 pack 不可重複加透明度', () {
		final pack = KlpStylePack.defaults();
		expect(() => buildKlpThemeVariant(KlpThemeVariant.light, style: KlpVisualStyle.defaultStyle, stylePack: pack), throwsArgumentError);
		for (final mode in KlpThemeVariant.values) {
			final expected = pack.toVisualStyle(mode).colors;
			for (final enabled in [false, true]) {
				final theme = buildKlpThemeVariant(mode, stylePack: pack, transparencyEnabled: enabled);
				expect(KlpVisualStyleJson.encode(pack.toVisualStyle(mode).copyWith(colors: theme.extension<KlpThemeData>()!))['colors'], KlpVisualStyleJson.encode(pack.toVisualStyle(mode).copyWith(colors: expected))['colors']);
			}
		}
	});

	testWidgets('獨立 Theme tree 的 context.klp 隔離，替換後更新並可恢復', (tester) async {
		final base = KlpStylePack.defaults();
		final alternate = base.applyOverrides({'primitives': {'parchment150': '#FF123456'}});
		final observed = <Color>[];
		Widget tree(KlpStylePack left) => MaterialApp(home: Row(children: [
			for (final pack in [left, base])
				Theme(data: buildKlpThemeVariant(KlpThemeVariant.light, stylePack: pack), child: Builder(builder: (context) {
					observed.add(context.klp.color.app);
					return const SizedBox();
				})),
		]));
		await tester.pumpWidget(tree(base));
		expect(observed.take(2), [base.toVisualStyle(KlpThemeVariant.light).colors.app, base.toVisualStyle(KlpThemeVariant.light).colors.app]);
		observed.clear();
		await tester.pumpWidget(tree(alternate));
		expect(observed, [const Color(0xFF123456), base.toVisualStyle(KlpThemeVariant.light).colors.app]);
		observed.clear();
		await tester.pumpWidget(tree(base));
		expect(observed, [base.toVisualStyle(KlpThemeVariant.light).colors.app, base.toVisualStyle(KlpThemeVariant.light).colors.app]);
		expect(base.data, source);
	});
}

Map<String, Object?> _map(Object? value) => value as Map<String, Object?>;

Map<String, Object?> _clone(Map<String, Object?> value) => _map(jsonDecode(jsonEncode(value)));

Map<String, Object?> _modes(String expression) => {
	for (final variant in KlpThemeVariant.values) variant.name: expression,
};

String _argb(String value) => (value.length == 7 ? '#FF${value.substring(1)}' : value).toUpperCase();

Object? _at(Map<String, Object?> value, String path) {
	Object? current = value;
	for (final key in path.split('.')) {
		expect(current, isA<Map>(), reason: '公開 native codec 缺少 $path 的父層');
		expect((current as Map).containsKey(key), isTrue, reason: '公開 native codec 缺少 $path');
		current = current[key];
	}
	return current;
}

void _expectRejected(Object? Function() action, String id) {
	expect(action, throwsA(predicate<Object>((error) => error.toString().contains(id))), reason: '診斷必須包含 $id');
}

void _expectFrozen(Object? value) {
	if (value is Map) {
		for (final nested in value.values) {
			_expectFrozen(nested);
		}
		expect(() => value.clear(), throwsUnsupportedError);
	} else if (value is List) {
		for (final nested in value) {
			_expectFrozen(nested);
		}
		expect(() => value.clear(), throwsUnsupportedError);
	}
}
