import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

// 同一應用 session 必須保留 destination identity，替換的只有選單資料。
final _destination = KlpDestination<int, String>(KlpId.parse('home'));

void main() {

	test('menu rejects ambiguous declarations and snapshots its items', () {
		final item = _item('Open', () {});
		final items = [item];
		final menu = _menu(items);
		items.clear();
		expect(menu.items, [same(item)]);
		expect(() => menu.items.clear(), throwsUnsupportedError);

		// 只約束拒絕輸入，不固定錯誤訊息或庫內驗證順序。
		final invalid = throwsA(anyOf(isA<ArgumentError>(), isA<KlpContractError>()));
		expect(() => KlpMenu(id: KlpId.parse('menu'), label: ' ', items: [item]), invalid);
		expect(() => KlpMenuItem(id: KlpId.parse('empty'), label: '', onPressed: () {}), invalid);
		expect(() => _menu([item, item]), invalid);
		expect(() => KlpMenuItem(id: KlpId.parse('separator'), label: 'Bad separator', separatedBefore: true, dashedSeparatorBefore: true, onPressed: () {}), invalid);
	});

	testWidgets('public application renders menu data and dispatches only enabled pointer actions', (tester) async {
		final calls = <String>[];
		final menu = _menu([
			KlpMenuItem(id: KlpId.parse('open'), label: 'Open', icon: KlpWorkspaceIcon.folder, shortcut: 'Ctrl+O', onPressed: () => calls.add('open')),
			KlpMenuItem(id: KlpId.parse('disabled'), label: 'Unavailable', enabled: false, onPressed: () => calls.add('disabled')),
			KlpMenuItem(id: KlpId.parse('toggle'), label: 'Visible', toggleValue: true, separatedBefore: true, onPressed: () => calls.add('toggle')),
			KlpMenuItem(id: KlpId.parse('delete'), label: 'Delete', destructive: true, dashedSeparatorBefore: true, onPressed: () => calls.add('delete')),
			KlpMenuItem(id: KlpId.parse('more'), label: 'More', hasSubmenu: true, onPressed: () => calls.add('more')),
		]);
		await _mount(tester, menu);
		expect(find.text('Actions'), findsOneWidget);
		expect(find.text('Ctrl+O'), findsOneWidget);

		// 經實際命中測試觸發行為，停用項目不能呼叫 consumer。
		for (final label in ['Open', 'Unavailable', 'Visible', 'Delete', 'More']) {
			await tester.tap(find.text(label));
			await tester.pump();
		}
		expect(calls, ['open', 'toggle', 'delete', 'more']);
		expect(tester.takeException(), isNull);
	});

	testWidgets('keyboard navigation skips disabled entries and activates with Enter and Space', (tester) async {
		final calls = <String>[];
		var escapes = 0;
		final menu = KlpMenu(
			id: KlpId.parse('menu'),
			label: 'Actions',
			onEscape: () => escapes++,
			items: [
				KlpMenuItem(id: KlpId.parse('disabled-first'), label: 'Disabled first', enabled: false, onPressed: () => calls.add('disabled')),
				_item('First', () => calls.add('first')),
				KlpMenuItem(id: KlpId.parse('disabled-middle'), label: 'Disabled middle', enabled: false, onPressed: () => calls.add('disabled')),
				_item('Last', () => calls.add('last')),
				KlpMenuItem(id: KlpId.parse('disabled-last'), label: 'Disabled last', enabled: false, onPressed: () => calls.add('disabled')),
			],
		);
		await _mount(tester, menu);

		// 方向鍵和首尾鍵只能到达可執行項，移動本身不觸發動作。
		await _key(tester, LogicalKeyboardKey.home);
		expect(calls, isEmpty);
		await _key(tester, LogicalKeyboardKey.enter);
		expect(calls, ['first']);
		await _key(tester, LogicalKeyboardKey.arrowDown);
		expect(calls, ['first']);
		await _key(tester, LogicalKeyboardKey.space);
		expect(calls, ['first', 'last']);
		await _key(tester, LogicalKeyboardKey.arrowUp);
		await _key(tester, LogicalKeyboardKey.enter);
		expect(calls, ['first', 'last', 'first']);
		await _key(tester, LogicalKeyboardKey.end);
		await _key(tester, LogicalKeyboardKey.space);
		expect(calls, ['first', 'last', 'first', 'last']);
		await _key(tester, LogicalKeyboardKey.escape);
		expect(escapes, 1);
		expect(calls, ['first', 'last', 'first', 'last']);
		expect(tester.takeException(), isNull);
	});

	testWidgets('all disabled menu keeps keyboard actions inert and Escape available', (tester) async {
		var actions = 0;
		var escapes = 0;
		final menu = KlpMenu(id: KlpId.parse('menu'), label: 'Actions', items: [KlpMenuItem(id: KlpId.parse('disabled'), label: 'Unavailable', enabled: false, onPressed: () => actions++)], onEscape: () => escapes++);
		await _mount(tester, menu);
		for (final key in [LogicalKeyboardKey.home, LogicalKeyboardKey.end, LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.enter, LogicalKeyboardKey.space, LogicalKeyboardKey.escape]) {
			await _key(tester, key);
		}
		expect(actions, 0);
		expect(escapes, 1);
		expect(tester.takeException(), isNull);
	});

	testWidgets('hover matches selected background and leaves controlled selection unchanged', (tester) async {
		var calls = 0;
		final menu = KlpMenu(
			id: KlpId.parse('menu'),
			label: 'Actions',
			autofocus: false,
			items: [
				KlpMenuItem(id: KlpId.parse('selected'), label: 'Selected', selected: true, onPressed: () => calls++),
				_item('Idle', () => calls++),
			],
		);
		await _mount(tester, menu);
		final idleFill = _background(tester, 'Idle');
		final selectedFill = _background(tester, 'Selected');
		expect(selectedFill, isNotNull);
		expect(selectedFill, isNot(idleFill));

		// 此處只比較宣告式 renderer 的確定色值，不判斷視覺品質。
		final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
		await mouse.addPointer(location: const Offset(1, 1));
		await mouse.moveTo(tester.getCenter(find.text('Idle')));
		await tester.pumpAndSettle();
		expect(_background(tester, 'Idle'), selectedFill);
		expect(_background(tester, 'Selected'), selectedFill);
		expect(calls, 0);
		await mouse.moveTo(const Offset(1, 1));
		await tester.pumpAndSettle();
		expect(_background(tester, 'Idle'), idleFill);
		expect(_background(tester, 'Selected'), selectedFill);
		expect(menu.items.map((item) => item.selected), [true, false]);
		await mouse.removePointer();
	});

	testWidgets('application replacement revokes callbacks retained from the old rendered frame', (tester) async {
		var oldCalls = 0;
		var newCalls = 0;
		final source = await _mount(tester, _menu([_item('Run', () => oldCalls++)]));

		// 測試專用 Flutter seam：保留已安裝的事件，不直接呼叫 consumer 原始 callback。
		final detector = find.ancestor(of: find.text('Run'), matching: find.byType(GestureDetector)).first;
		final oldTap = tester.widget<GestureDetector>(detector).onTap;
		expect(oldTap, isNotNull);
		oldTap!();
		expect(oldCalls, 1);

		// 替換整份 application 後，即使外界持有舊事件也不能操作舊資料。
		source.value = _application(_menu([_item('Run', () => newCalls++)]));
		await tester.pump();
		await tester.pump();
		oldTap();
		expect(oldCalls, 1);
		expect(newCalls, 0);
		await tester.tap(find.text('Run'));
		await tester.pump();
		expect(newCalls, 1);
		expect(tester.takeException(), isNull);
	});
}

KlpMenuItem _item(String label, VoidCallback callback) => KlpMenuItem(id: KlpId.parse(label.toLowerCase()), label: label, onPressed: callback);

KlpMenu _menu(List<KlpMenuItem> items) => KlpMenu(id: KlpId.parse('menu'), label: 'Actions', items: items);

KlpApplication _application(KlpMenu menu) {
	final group = KlpFrameGroup(id: KlpId.parse('group'), content: [menu]);
	final groups = KlpFrameGroups(id: KlpId.parse('groups'), groups: [group]);
	final frame = KlpAppFrame(id: KlpId.parse('frame'), child: groups);
	final screen = KlpScreen(id: KlpId.parse('screen'), accessibilityLabel: 'Menu test', child: KlpAppLayout(id: KlpId.parse('layout'), child: frame));
	final router = KlpRouter(id: KlpId.parse('router'), initial: _destination.location(0), routes: [KlpRoute(_destination, screen: (_) => screen)]);
	return KlpApplication(title: 'Menu test', primitives: KlpWorkspacePreset.light(), router: router);
}

Future<KlpMutableState<KlpApplication>> _mount(WidgetTester tester, KlpMenu menu) async {
	final source = KlpMutableState(_application(menu));
	addTearDown(source.dispose);

	// 透過正式應用安裝 adapter、風格解析與 renderer；測試不裝載舊 Widget。
	runKlpApp(source.readOnly);
	await tester.pump();
	await tester.pump();
	expect(tester.takeException(), isNull);
	return source;
}

Future<void> _key(WidgetTester tester, LogicalKeyboardKey key) async {
	// 送出完整按下／放開事件，避免測試持續按鍵狀態汙染下一步。
	await tester.sendKeyEvent(key);
	await tester.pump();
}

Color? _background(WidgetTester tester, String label) {
	// 使用 Flutter 已呈現的最近背景作為確定性觀察介面，不 import 私有選單實作。
	final boxes = find.ancestor(of: find.text(label), matching: find.byType(DecoratedBox));
	final decoration = tester.widget<DecoratedBox>(boxes.first).decoration as BoxDecoration;
	return decoration.color;
}
