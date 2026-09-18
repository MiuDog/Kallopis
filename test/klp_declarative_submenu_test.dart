import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

final _destination = KlpDestination<int, String>(KlpId.parse('home'));

void main() {

	test('submenu snapshots children and rejects ambiguous recursive declarations', () {
		final leaf = _leaf('Run', () {});
		final children = [leaf];
		final parent = _parent('Parent', children);
		children.clear();
		expect(parent.children, [same(leaf)]);
		expect(() => parent.children.clear(), throwsUnsupportedError);
		expect(leaf.children, isEmpty);
		final invalid = throwsA(anyOf(isA<ArgumentError>(), isA<KlpContractError>()));
		expect(() => KlpMenuItem(id: KlpId.parse('bad'), label: 'Bad', children: [leaf], onPressed: () {}), invalid);

		// 重複識別碼跨層或跨分支仍會使整份選單失去唯一定位。
		expect(() => _menu([leaf, parent]), invalid);
		expect(() => _menu([parent, _parent('Other', [_parent('Deep', [leaf])])]), invalid);
		expect(() => _menu([_parent('Run', [leaf])]), invalid);
	});

	testWidgets('pointer enters one level at a time and matching header returns', (tester) async {
		var calls = 0;
		final tree = _parent('Parent', [_parent('Nested', [_leaf('Run', () => calls++)])]);
		await _mount(tester, _menu([tree, _leaf('Root sibling', () => calls++)]));
		expect(find.text('Nested'), findsNothing);
		await _tap(tester, 'Parent');
		expect(find.text('Actions'), findsNothing);
		expect(find.text('Root sibling'), findsNothing);
		expect(find.text('Parent'), findsOneWidget);
		expect(find.text('Nested'), findsOneWidget);
		expect(find.text('Run'), findsNothing);
		await _tap(tester, 'Nested');
		expect(find.text('Parent'), findsNothing);
		expect(find.text('Nested'), findsOneWidget);
		await _tap(tester, 'Run');
		expect(calls, 1);

		// 返回標頭用進入項目的原始標籤，逐層回到根面板。
		await _tap(tester, 'Nested');
		expect(find.text('Run'), findsNothing);
		expect(find.text('Parent'), findsOneWidget);
		await _tap(tester, 'Parent');
		expect(find.text('Actions'), findsOneWidget);
		expect(find.text('Root sibling'), findsOneWidget);
		expect(calls, 1);
	});

	for (final opener in [LogicalKeyboardKey.enter, LogicalKeyboardKey.space, LogicalKeyboardKey.arrowRight]) {
		testWidgets('${opener.keyLabel} enters submenu and ArrowLeft restores parent focus', (tester) async {
			var calls = 0;
			var escapes = 0;
			final items = [_leaf('First', () => calls++), _parent('Parent', [_parent('Nested', [_leaf('Run', () => calls++)])])];
			await _mount(tester, KlpMenu(id: KlpId.parse('menu'), label: 'Actions', items: items, onEscape: () => escapes++));
			await _key(tester, LogicalKeyboardKey.end);
			await _key(tester, opener);
			expect(find.text('Nested'), findsOneWidget);
			await _key(tester, LogicalKeyboardKey.home);
			await _key(tester, opener);
			expect(find.text('Run'), findsOneWidget);
			await _key(tester, LogicalKeyboardKey.escape);
			expect(escapes, 1);
			expect(calls, 0);

			// 返回後立即再進入，以行為確認焦點留在原父項而非第一列。
			await _key(tester, LogicalKeyboardKey.arrowLeft);
			await _key(tester, LogicalKeyboardKey.arrowLeft);
			await _key(tester, opener);
			expect(find.text('Nested'), findsOneWidget);
			expect(find.text('First'), findsNothing);
			expect(calls, 0);
		});
	}

	testWidgets('disabled parents and children remain inert for pointer and keyboard', (tester) async {
		var calls = 0;
		final disabledParent = KlpMenuItem(id: KlpId.parse('disabled-parent'), label: 'Disabled parent', enabled: false, children: [_leaf('Hidden', () => calls++)]);
		final disabledLeaf = KlpMenuItem(id: KlpId.parse('disabled-leaf'), label: 'Disabled leaf', enabled: false, onPressed: () => calls++);
		final nestedDisabled = KlpMenuItem(id: KlpId.parse('nested-disabled'), label: 'Nested disabled', enabled: false, children: [_leaf('Deep hidden', () => calls++)]);
		await _mount(tester, _menu([disabledParent, _parent('Parent', [disabledLeaf, nestedDisabled, _leaf('Run', () => calls++)])]));
		await _tap(tester, 'Disabled parent');
		expect(find.text('Hidden'), findsNothing);
		await _key(tester, LogicalKeyboardKey.home);
		await _key(tester, LogicalKeyboardKey.enter);
		expect(find.text('Disabled leaf'), findsOneWidget);
		await _tap(tester, 'Disabled leaf');
		await _tap(tester, 'Nested disabled');
		expect(find.text('Deep hidden'), findsNothing);
		expect(calls, 0);
		await _key(tester, LogicalKeyboardKey.home);
		await _key(tester, LogicalKeyboardKey.enter);
		expect(calls, 1);
	});

	testWidgets('replacement preserves valid nested path and revokes retained descendant events', (tester) async {
		var oldCalls = 0;
		var newCalls = 0;
		final source = await _mount(tester, _deepMenu(() => oldCalls++));
		await _tap(tester, 'Parent');
		await _tap(tester, 'Nested');

		// 唯一 Flutter seam 與既有 menu 測試一致：保留已安裝事件而非原始 consumer callback。
		final detector = find.ancestor(of: find.text('Run'), matching: find.byType(GestureDetector)).first;
		final oldTap = tester.widget<GestureDetector>(detector).onTap;
		expect(oldTap, isNotNull);
		oldTap!();
		expect(oldCalls, 1);
		await _replace(tester, source, _deepMenu(() => newCalls++));
		expect(find.text('Run'), findsOneWidget);
		expect(find.text('Parent'), findsNothing);
		oldTap();
		expect(oldCalls, 1);
		expect(newCalls, 0);
		await _tap(tester, 'Run');
		expect(newCalls, 1);
		expect(tester.takeException(), isNull);
	});

	testWidgets('replacement revokes a retained parent event before it can reopen removed children', (tester) async {
		var calls = 0;
		final source = await _mount(tester, _deepMenu(() => calls++));

		// 保留已呈現父項的入口，更新後不得以舊資料重建導覽路徑。
		final detector = find.ancestor(of: find.text('Parent'), matching: find.byType(GestureDetector)).first;
		final oldTap = tester.widget<GestureDetector>(detector).onTap;
		expect(oldTap, isNotNull);
		await _replace(tester, source, _menu([_leaf('Replacement', () => calls++)]));
		oldTap!();
		await tester.pump();
		expect(find.text('Actions'), findsOneWidget);
		expect(find.text('Replacement'), findsOneWidget);
		expect(find.text('Parent'), findsNothing);
		expect(find.text('Nested'), findsNothing);
		expect(find.text('Run'), findsNothing);
		expect(calls, 0);
		expect(tester.takeException(), isNull);
	});

	for (final change in ['removed', 'disabled', 'empty']) {
		testWidgets('replacement truncates $change ancestor path to its valid prefix', (tester) async {
			final source = await _mount(tester, _deepMenu(() {}));
			await _tap(tester, 'Parent');
			await _tap(tester, 'Nested');
			final remaining = <KlpMenuItem>[_leaf('Sibling', () {})];
			if (change == 'disabled') {
				remaining.add(KlpMenuItem(id: KlpId.parse('nested'), label: 'Nested', enabled: false, children: [_leaf('Run', () {})]));
			}
			if (change == 'empty') {
				remaining.add(_leaf('Nested', () {}));
			}
			await _replace(tester, source, _menu([_parent('Parent', remaining)]));
			expect(find.text('Parent'), findsOneWidget);
			expect(find.text('Sibling'), findsOneWidget);
			expect(find.text('Run'), findsNothing);
			expect(find.text('Actions'), findsNothing);

			// 連最外層父項也移除時，安全回到根層的新資料。
			await _replace(tester, source, _menu([_leaf('Replacement', () {})]));
			expect(find.text('Actions'), findsOneWidget);
			expect(find.text('Replacement'), findsOneWidget);
			expect(find.text('Parent'), findsNothing);
			expect(tester.takeException(), isNull);
		});
	}
}

KlpMenuItem _leaf(String label, VoidCallback callback) => KlpMenuItem(id: KlpId.parse(label.toLowerCase().replaceAll(' ', '-')), label: label, onPressed: callback);

KlpMenuItem _parent(String label, List<KlpMenuItem> children) => KlpMenuItem(id: KlpId.parse(label.toLowerCase()), label: label, children: children);

KlpMenu _menu(List<KlpMenuItem> items) => KlpMenu(id: KlpId.parse('menu'), label: 'Actions', items: items);

KlpMenu _deepMenu(VoidCallback callback) => _menu([_parent('Parent', [_parent('Nested', [_leaf('Run', callback)])])]);

KlpApplication _application(KlpMenu menu) {
	final group = KlpFrameGroup(id: KlpId.parse('group'), content: [menu]);
	final groups = KlpFrameGroups(id: KlpId.parse('groups'), groups: [group]);
	final frame = KlpAppFrame(id: KlpId.parse('frame'), child: groups);
	final screen = KlpScreen(id: KlpId.parse('screen'), accessibilityLabel: 'Submenu test', child: KlpAppLayout(id: KlpId.parse('layout'), child: frame));
	final router = KlpRouter(id: KlpId.parse('router'), initial: _destination.location(0), routes: [KlpRoute(_destination, screen: (_) => screen)]);
	return KlpApplication(title: 'Submenu test', router: router);
}

Future<KlpMutableState<KlpApplication>> _mount(WidgetTester tester, KlpMenu menu) async {
	final source = KlpMutableState(_application(menu));
	addTearDown(source.dispose);

	// 正式應用入口提供 frame lease 與 renderer，避免自行模擬私有狀態。
	runKlpApp(source.readOnly);
	await tester.pump();
	await tester.pump();
	expect(tester.takeException(), isNull);
	return source;
}

Future<void> _replace(WidgetTester tester, KlpMutableState<KlpApplication> source, KlpMenu menu) async {
	source.value = _application(menu);
	await tester.pump();
	await tester.pump();
}

Future<void> _tap(WidgetTester tester, String label) async {
	// 透過命中測試操作目前層級。
	await tester.tap(find.text(label));
	await tester.pump();
}

Future<void> _key(WidgetTester tester, LogicalKeyboardKey key) async {
	// 完整送出按下與放開，避免跨步驟保留按鍵狀態。
	await tester.sendKeyEvent(key);
	await tester.pump();
}
