import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'klp_explorer_test.dart' show ExplorerTestHarness, explorerId;

KlpWorkspaceBlock popupTrigger() => KlpWorkspaceBlock(id: explorerId('popup-trigger'), kind: KlpWorkspaceBlockKind.action, title: 'Projects');

KlpAnchoredPopup popup({
	required bool open,
	required void Function(bool, KlpAnchoredPopupChangeReason) changed,
	List<KlpAnchoredPopupItem>? items,
	List<KlpWorkspaceCommand>? actions,
	KlpAnchoredPopupState state = KlpAnchoredPopupState.ready,
	String? message,
}) => KlpAnchoredPopup(
	id: explorerId('popup'),
	trigger: popupTrigger(),
	open: open,
	accessibilityLabel: 'Project manager',
	title: 'Manage projects',
	items: items,
	actions: actions,
	state: state,
	message: message,
	onOpenChanged: changed,
);

void main() {

	test('列身分不依賴名稱，重複身分及無效宣告明確拒絕', () {
		final first = KlpAnchoredPopupItem(id: explorerId('first'), label: 'Untitled');
		final second = KlpAnchoredPopupItem(id: explorerId('second'), label: 'Untitled');
		expect(() => popup(open: false, changed: (_, _) {}, items: [first, second]), returnsNormally);
		expect(() => popup(open: false, changed: (_, _) {}, items: [first, first]), throwsArgumentError);
		expect(() => popup(open: false, changed: (_, _) {}), throwsArgumentError);
		expect(() => popup(open: false, changed: (_, _) {}, state: KlpAnchoredPopupState.error, message: ' '), throwsArgumentError);
		expect(() => popup(open: false, changed: (_, _) {}, state: KlpAnchoredPopupState.result), throwsArgumentError);
		expect(() => KlpAnchoredPopupItem(id: explorerId('empty'), label: ' '), throwsArgumentError);
	});

	test('trigger 不可同時攜帶產品操作或選取', () {
		for (final trigger in [
			KlpWorkspaceBlock(id: explorerId('trigger'), kind: KlpWorkspaceBlockKind.paper, title: 'Invalid'),
			KlpWorkspaceBlock(id: explorerId('trigger'), kind: KlpWorkspaceBlockKind.action, title: 'Invalid', onPressed: () {}),
			KlpWorkspaceBlock(id: explorerId('trigger'), kind: KlpWorkspaceBlockKind.action, title: 'Invalid', selected: true),
		]) {
			expect(() => KlpAnchoredPopup(id: explorerId('popup'), trigger: trigger, open: false, accessibilityLabel: 'Popup', items: [], onOpenChanged: (_, _) {}), throwsArgumentError);
		}
	});

	testWidgets('trigger 外點 Escape 只提出請求，consumer 回填才改變開關', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final events = <String>[];
		var productCalls = 0;
		final items = [KlpAnchoredPopupItem(id: explorerId('item'), label: 'Saved project', onPressed: () => productCalls++)];
		void changed(bool value, KlpAnchoredPopupChangeReason reason) => events.add('$value:${reason.name}');
		await harness.show(tester, popup(open: false, changed: changed, items: items));
		await tester.tap(find.text('Projects'));
		await tester.pump();
		expect(events, ['true:trigger']);
		expect(find.text('Saved project'), findsNothing);
		await harness.show(tester, popup(open: true, changed: changed, items: items));
		expect(find.text('Saved project'), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await tester.pump();
		expect(events.last, 'false:escape');
		expect(find.text('Saved project'), findsOneWidget);
		await tester.tapAt(const Offset(790, 590));
		await tester.pump();
		expect(events.last, 'false:outside');
		expect(find.text('Saved project'), findsOneWidget);
		await tester.tap(find.text('Projects'));
		await tester.pump();
		expect(events.last, 'false:trigger');
		expect(productCalls, 0);
		await harness.show(tester, popup(open: false, changed: changed, items: items));
		expect(find.text('Saved project'), findsNothing);
	});

	testWidgets('同身分更新回饋與 disabled，內容操作不自動關閉', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final changes = <bool>[];
		var calls = 0;
		List<KlpAnchoredPopupItem> items(bool enabled) => [KlpAnchoredPopupItem(id: explorerId('item'), label: 'Project', enabled: enabled, onPressed: () => calls++)];
		await harness.show(tester, popup(open: true, changed: (value, _) => changes.add(value), items: items(true), state: KlpAnchoredPopupState.loading));
		await tester.tap(find.text('Project'));
		await tester.pump();
		expect(calls, 1);
		expect(changes, isEmpty);
		await harness.show(tester, popup(open: true, changed: (value, _) => changes.add(value), items: items(false), state: KlpAnchoredPopupState.error, message: 'Save failed'));
		expect(find.text('Save failed'), findsOneWidget);
		await tester.tap(find.text('Project'));
		expect(calls, 1);
		await harness.show(tester, popup(open: true, changed: (value, _) => changes.add(value), items: items(true), state: KlpAnchoredPopupState.result, message: 'Saved'));
		expect(find.text('Save failed'), findsNothing);
		expect(find.text('Saved'), findsOneWidget);
		await tester.tap(find.text('Project'));
		expect(calls, 2);
		expect(changes, isEmpty);
	});

	testWidgets('焦點跳過 disabled、Tab 循環，關閉返回 trigger', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final calls = <String>[];
		final changes = <bool>[];
		final items = [
			KlpAnchoredPopupItem(id: explorerId('disabled'), label: 'Disabled', enabled: false, onPressed: () => calls.add('disabled')),
			KlpAnchoredPopupItem(id: explorerId('first'), label: 'First', onPressed: () => calls.add('first')),
			KlpAnchoredPopupItem(id: explorerId('second'), label: 'Second', onPressed: () => calls.add('second')),
		];
		await harness.show(tester, popup(open: true, changed: (value, _) => changes.add(value), items: items));
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.sendKeyEvent(LogicalKeyboardKey.tab);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.sendKeyEvent(LogicalKeyboardKey.tab);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		expect(calls, ['first', 'second', 'first']);
		await harness.show(tester, popup(open: false, changed: (value, _) => changes.add(value), items: items));
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		expect(changes, [true]);
	});

	testWidgets('子命令選單執行及 Escape 不關閉父 popup', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final changes = <bool>[];
		var commands = 0;
		final command = KlpWorkspaceCommand(label: 'Rename', onInvoke: (_) => commands++);
		final item = KlpAnchoredPopupItem(id: explorerId('item'), label: 'Project', commands: [command]);
		await harness.show(tester, popup(open: true, changed: (value, _) => changes.add(value), items: [item]));
		await tester.tap(find.text('Project'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(find.text('Rename'), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await tester.pumpAndSettle();
		expect(find.text('Rename'), findsNothing);
		expect(find.text('Project'), findsOneWidget);
		expect(changes, isEmpty);
		await tester.tap(find.text('Project'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		await tester.tap(find.text('Rename'));
		await tester.pumpAndSettle();
		expect(commands, 1);
		expect(changes, isEmpty);
		expect(find.text('Project'), findsOneWidget);
	});
}
