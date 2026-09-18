import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

final _destination = KlpDestination<int, String>(KlpId.parse('home'));

void main() {

	test('popup trigger rejects blank labels', () {
		final invalid = throwsA(anyOf(isA<ArgumentError>(), isA<KlpContractError>()));
		for (final label in ['', '  ', '\t\n']) {
			expect(() => KlpMenu(id: KlpId.parse('menu'), label: 'Actions', triggerLabel: label, items: [_leaf('Run', () {})]), invalid);
		}
	});

	testWidgets('null trigger preserves the inline panel', (tester) async {
		await _mount(tester, KlpMenu(id: KlpId.parse('menu'), label: 'Actions', triggerLabel: null, items: [_leaf('Run', () {})]));
		expect(find.text('Actions'), findsOneWidget);
		expect(find.text('Run'), findsOneWidget);
	});

	testWidgets('popup opens closed, parents remain open, disabled is inert and leaf closes once', (tester) async {
		var calls = 0;
		final disabled = KlpMenuItem(id: KlpId.parse('disabled'), label: 'Disabled', enabled: false, onPressed: () => calls++);
		final parent = KlpMenuItem(id: KlpId.parse('parent'), label: 'Parent', children: [disabled, _leaf('Run', () => calls++)]);
		await _mount(tester, _menu([parent]));
		expect(find.text('Open menu'), findsOneWidget);
		expect(find.text('Actions'), findsNothing);
		expect(find.text('Parent'), findsNothing);
		await _tap(tester, 'Open menu');
		expect(find.text('Actions'), findsOneWidget);
		await _tap(tester, 'Parent');
		expect(find.text('Run'), findsOneWidget);
		await _tap(tester, 'Disabled');
		expect(calls, 0);
		expect(find.text('Run'), findsOneWidget);

		// 沿用既有測試的 Flutter 事件 seam，檢查已關閉事件不可重複提交。
		final oldTap = _installedTap(tester, 'Run');
		await _tap(tester, 'Run');
		expect(calls, 1);
		expect(find.text('Run'), findsNothing);
		oldTap();
		await tester.pump();
		expect(calls, 1);

		// 不另設焦點，直接操作返回入口的鍵盤以驗證關閉後焦點。
		await _key(tester, LogicalKeyboardKey.enter);
		expect(find.text('Parent'), findsOneWidget);
		expect(find.text('Run'), findsNothing);
	});

	for (final opener in [LogicalKeyboardKey.enter, LogicalKeyboardKey.space, LogicalKeyboardKey.arrowDown]) {
		testWidgets('focused ${opener.keyLabel} opens and Escape dismisses with trigger focus', (tester) async {
			var calls = 0;
			var escapes = 0;
			await _mount(tester, _menu([_leaf('Run', () => calls++)], onEscape: () => escapes++));

			// 只要求公開呈現入口的最近 Focus，不依賴私有控制器或 renderer 類別。
			Focus.of(tester.element(find.text('Open menu'))).requestFocus();
			await tester.pump();
			await _key(tester, opener);
			expect(find.text('Run'), findsOneWidget);
			await _key(tester, LogicalKeyboardKey.escape);
			expect(find.text('Run'), findsNothing);
			expect(calls, 0);
			expect(escapes, 1);
			await _key(tester, opener);
			expect(find.text('Run'), findsOneWidget);
			expect(escapes, 1);
		});
	}

	testWidgets('outside tap dismisses without action or click through', (tester) async {
		var calls = 0;
		var backgroundCalls = 0;
		await _mount(tester, _menu([_leaf('Run', () => calls++)]), background: () => backgroundCalls++);
		final outsidePoint = tester.getCenter(find.text('Background action'));
		await _tap(tester, 'Open menu');
		await tester.tapAt(outsidePoint);
		await tester.pump();
		expect(find.text('Run'), findsNothing);
		expect(calls, 0);
		expect(backgroundCalls, 0);
		await _key(tester, LogicalKeyboardKey.enter);
		expect(find.text('Run'), findsOneWidget);
		await _key(tester, LogicalKeyboardKey.escape);
		await _tap(tester, 'Background action');
		expect(backgroundCalls, 1);
	});

	testWidgets('removing menu removes overlay and revokes retained trigger and item events', (tester) async {
		var calls = 0;
		final source = await _mount(tester, _menu([_leaf('Run', () => calls++)]));
		final oldTrigger = _installedTap(tester, 'Open menu');
		await _tap(tester, 'Open menu');
		final oldItem = _installedTap(tester, 'Run');
		source.value = _application(null);
		await tester.pump();
		await tester.pump();
		expect(find.text('Open menu'), findsNothing);
		expect(find.text('Run'), findsNothing);
		oldItem();
		oldTrigger();
		await tester.pump();
		expect(calls, 0);
		expect(find.text('Run'), findsNothing);
		expect(tester.takeException(), isNull);
	});

	testWidgets('long popup remains operable after viewport shrinks', (tester) async {
		var calls = 0;
		tester.view.devicePixelRatio = 1;
		tester.view.physicalSize = const Size(600, 500);
		addTearDown(tester.view.resetPhysicalSize);
		addTearDown(tester.view.resetDevicePixelRatio);
		await _mount(tester, _menu(List.generate(30, (index) => _leaf('Item $index', () => calls++))));
		await _tap(tester, 'Open menu');
		tester.view.physicalSize = const Size(360, 280);
		await tester.pump();
		await tester.pump();
		expect(tester.takeException(), isNull);

		// 實際捲動至最後一列，驗證視窗裁切後仍能命中操作。
		final popupScroll = find.ancestor(of: find.text('Item 0'), matching: find.byType(Scrollable)).first;
		await tester.scrollUntilVisible(find.text('Item 29'), 140, scrollable: popupScroll);
		await tester.pump();
		final bounds = tester.getRect(find.text('Item 29'));
		expect(bounds.left, greaterThanOrEqualTo(0));
		expect(bounds.top, greaterThanOrEqualTo(0));
		expect(bounds.right, lessThanOrEqualTo(360));
		expect(bounds.bottom, lessThanOrEqualTo(280));
		await _tap(tester, 'Item 29');
		expect(calls, 1);
		expect(find.text('Item 29'), findsNothing);
		expect(tester.takeException(), isNull);
	});
}

KlpMenuItem _leaf(String label, VoidCallback callback) => KlpMenuItem(id: KlpId.parse(label.toLowerCase().replaceAll(' ', '-')), label: label, onPressed: callback);

KlpMenu _menu(List<KlpMenuItem> items, {VoidCallback? onEscape}) => KlpMenu(id: KlpId.parse('menu'), label: 'Actions', triggerLabel: 'Open menu', items: items, onEscape: onEscape);

KlpApplication _application(KlpMenu? menu, {VoidCallback? background}) {
	final outside = KlpMenu(id: KlpId.parse('background'), label: 'Background', items: [_leaf('Background action', background ?? () {})]);
	final group = KlpFrameGroup(id: KlpId.parse('group'), content: [outside, if (menu != null) menu]);
	final groups = KlpFrameGroups(id: KlpId.parse('groups'), groups: [group]);
	final frame = KlpAppFrame(id: KlpId.parse('frame'), child: groups);
	final screen = KlpScreen(id: KlpId.parse('screen'), accessibilityLabel: 'Popup test', child: KlpAppLayout(id: KlpId.parse('layout'), child: frame));
	final router = KlpRouter(id: KlpId.parse('router'), initial: _destination.location(0), routes: [KlpRoute(_destination, screen: (_) => screen)]);
	return KlpApplication(title: 'Popup test', router: router);
}

Future<KlpMutableState<KlpApplication>> _mount(WidgetTester tester, KlpMenu menu, {VoidCallback? background}) async {
	final source = KlpMutableState(_application(menu, background: background));
	addTearDown(source.dispose);

	// 正式公開入口負責安裝真實框架、事件 lease 與 renderer。
	runKlpApp(source.readOnly);
	await tester.pump();
	await tester.pump();
	expect(tester.takeException(), isNull);
	return source;
}

VoidCallback _installedTap(WidgetTester tester, String label) {
	// 僅使用已安裝的 Flutter callback，以重現延遲事件而不引用產品內部。
	final detector = find.ancestor(of: find.text(label), matching: find.byType(GestureDetector)).first;
	final callback = tester.widget<GestureDetector>(detector).onTap;
	expect(callback, isNotNull);
	return callback!;
}

Future<void> _tap(WidgetTester tester, String label) async {
	// 經由命中測試操作入口或目前可見項目。
	await tester.tap(find.text(label));
	await tester.pump();
}

Future<void> _key(WidgetTester tester, LogicalKeyboardKey key) async {
	// 發送完整按下與放開，以隔離每一步鍵盤狀態。
	await tester.sendKeyEvent(key);
	await tester.pump();
}
