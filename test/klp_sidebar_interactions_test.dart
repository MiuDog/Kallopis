import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'klp_explorer_test.dart' show ExplorerTestHarness, explorerData, explorerId, explorerNode;

Future<void> _menu(WidgetTester tester, String command) async {
	await tester.tap(find.text('Note'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
	await tester.pumpAndSettle();
	await tester.tap(find.text(command));
	await tester.pumpAndSettle();
}

Future<void> _showCommands(WidgetTester tester, ExplorerTestHarness harness, List<KlpWorkspaceCommand> commands) async {
	await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([explorerNode('Note', commands: commands)])));
}

void main() {

	testWidgets('F2 輸入取消與 Escape 關閉選單不執行命令', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		var calls = 0;
		final results = <KlpWorkspaceCommandResult>[];
		await _showCommands(tester, harness, [KlpWorkspaceCommand(label: 'Rename', shortcut: KlpWorkspaceCommandShortcut.rename, inputLabel: 'Name', onInvoke: (_) { calls++; }, onResult: results.add)]);
		await tester.tap(find.text('Note'));
		await tester.sendKeyEvent(LogicalKeyboardKey.f2);
		await tester.pumpAndSettle();
		expect(find.byType(EditableText), findsOneWidget);
		await tester.tap(find.text('Cancel'));
		await tester.pumpAndSettle();
		expect(results.single.status, KlpWorkspaceCommandStatus.canceled);
		await tester.tap(find.text('Note'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(find.text('Rename'), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await tester.pumpAndSettle();
		expect(find.text('Rename'), findsNothing);
		expect(calls, 0);
	});

	testWidgets('右鍵不選取或啟用，停用命令不可執行，可用命令只提交一次', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		var actions = 0;
		var calls = 0;
		final row = explorerNode('Note', commands: [KlpWorkspaceCommand(label: 'Unavailable', enabled: false, onInvoke: (_) { calls += 100; }), KlpWorkspaceCommand(label: 'Pin', onInvoke: (_) { calls++; })]);
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([row]), onSelectionChanged: (_) => actions++, onActivate: (_) => actions++));
		await tester.tap(find.text('Note'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		await tester.tap(find.text('Unavailable'));
		await tester.pumpAndSettle();
		expect(calls, 0);
		await tester.tap(find.text('Pin'));
		await tester.pumpAndSettle();
		expect(calls, 1);
		expect(actions, 0);
	});

	testWidgets('命名驗證空白，取消不提交，確認回傳完成結果', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final names = <String?>[];
		final results = <KlpWorkspaceCommandResult>[];
		await _showCommands(tester, harness, [KlpWorkspaceCommand(label: 'Rename', inputLabel: 'Name', initialValue: 'Note', onInvoke: names.add, onResult: results.add)]);
		await _menu(tester, 'Rename');
		await tester.tap(find.text('Cancel'));
		await tester.pumpAndSettle();
		expect(names, isEmpty);
		expect(results.single.status, KlpWorkspaceCommandStatus.canceled);
		await _menu(tester, 'Rename');
		await tester.enterText(find.byType(EditableText), '   ');
		await tester.tap(find.text('OK'));
		await tester.pumpAndSettle();
		expect(names, isEmpty);
		expect(find.byType(EditableText), findsOneWidget);
		await tester.enterText(find.byType(EditableText), 'Research');
		await tester.tap(find.text('OK'));
		await tester.pumpAndSettle();
		expect(names, ['Research']);
		expect(results.last.status, KlpWorkspaceCommandStatus.completed);
		expect(find.byType(EditableText), findsNothing);
	});

	testWidgets('確認取消不執行，非同步完成與失敗保留結果資料', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final results = <KlpWorkspaceCommandResult>[];
		var calls = 0;
		final completed = Completer<void>();
		await _showCommands(tester, harness, [KlpWorkspaceCommand(label: 'Purge', confirmation: 'Delete permanently?', onInvoke: (_) { calls++; return completed.future; }, onResult: results.add)]);
		await _menu(tester, 'Purge');
		expect(find.text('Delete permanently?'), findsOneWidget);
		await tester.tap(find.text('Cancel'));
		await tester.pumpAndSettle();
		expect(calls, 0);
		expect(results.single.status, KlpWorkspaceCommandStatus.canceled);
		await _menu(tester, 'Purge');
		await tester.tap(find.text('OK'));
		await tester.pump();
		expect(calls, 1);
		expect(results, hasLength(1));
		completed.complete();
		await tester.pumpAndSettle();
		expect(results.last.status, KlpWorkspaceCommandStatus.completed);

		// 失敗要回報原始錯誤及堆疊，不能偽裝完成或丟失列資料。
		final failure = StateError('save failed');
		final trace = StackTrace.current;
		await _showCommands(tester, harness, [KlpWorkspaceCommand(label: 'Fail', onInvoke: (_) => Future<void>.error(failure, trace), onResult: results.add)]);
		await _menu(tester, 'Fail');
		expect(results.last.status, KlpWorkspaceCommandStatus.failed);
		expect(results.last.error, same(failure));
		expect(results.last.stackTrace.toString(), trace.toString());
		expect(find.text('Note'), findsOneWidget);
		expect(tester.takeException(), isNull);
	});

	testWidgets('命令確認等待期間替換影格不允許殘留提交', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		var calls = 0;
		await _showCommands(tester, harness, [KlpWorkspaceCommand(label: 'Purge', confirmation: 'Confirm?', onInvoke: (_) { calls++; })]);
		await _menu(tester, 'Purge');
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([explorerNode('Replacement')])));
		if (find.text('OK').evaluate().isNotEmpty) {
			await tester.tap(find.text('OK'));
			await tester.pumpAndSettle();
		}
		expect(calls, 0);
	});

	testWidgets('拖放預設拒絕，明示許可才發出 before inside after', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final drops = <KlpExplorerDropRequest>[];
		final source = explorerNode('Source', capabilities: const KlpExplorerCapabilities(draggable: true));
		KlpExplorer tree(bool allowed) => KlpExplorer(id: explorerId('explorer'), data: explorerData([source, explorerNode('Target')]), canDrop: allowed ? (_) => true : null, onDrop: drops.add);
		Future<void> drag(double offset) async {
			final from = tester.getCenter(find.text('Source'));
			final to = tester.getCenter(find.text('Target')) + Offset(0, offset);
			await tester.dragFrom(from, to - from, kind: PointerDeviceKind.mouse);
			await tester.pumpAndSettle();
		}
		await harness.show(tester, tree(false));
		await drag(0);
		expect(drops, isEmpty);
		await harness.show(tester, tree(true));
		for (final offset in [-12.0, 0.0, 12.0]) {
			await drag(offset);
		}
		expect(drops.map((request) => request.position), [KlpExplorerDropPlacement.before, KlpExplorerDropPlacement.inside, KlpExplorerDropPlacement.after]);
		expect(drops.every((request) => request.sourceIds.contains(source.id) && request.targetId == explorerId('Target')), isTrue);
		expect(find.text('Source'), findsOneWidget);
	});

	testWidgets('拖放預覽許可不可取代提交當下的許可', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		var allowed = true;
		var checks = 0;
		var drops = 0;
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([explorerNode('Source', capabilities: const KlpExplorerCapabilities(draggable: true)), explorerNode('Target')]), canDrop: (_) { checks++; return allowed; }, onDrop: (_) => drops++));
		final gesture = await tester.startGesture(tester.getCenter(find.text('Source')), kind: PointerDeviceKind.mouse);
		await gesture.moveBy(const Offset(20, 0));
		await tester.pump();
		await gesture.moveTo(tester.getCenter(find.text('Target')));
		await tester.pump();
		expect(checks, greaterThan(0));
		final previewChecks = checks;
		allowed = false;
		await gesture.up();
		await tester.pumpAndSettle();
		expect(checks, greaterThan(previewChecks));
		expect(drops, 0);
	});

	testWidgets('跨 Explorer 拖放保留來源出現身分與 inside 意圖', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final source = explorerNode('Source', capabilities: const KlpExplorerCapabilities(draggable: true));
		final target = explorerNode('Target');
		final trees = [KlpExplorerTreeData(id: explorerId('source-tree'), items: [source]), KlpExplorerTreeData(id: explorerId('target-tree'), items: [target])];
		final scope = KlpExplorerSelectionScope(id: explorerId('shared'), treeIds: trees.map((tree) => tree.id).toList(), mode: KlpExplorerSelectionMode.none);
		final data = KlpExplorerData(trees: trees, selectionScopes: [scope]);
		final drops = <KlpExplorerDropRequest>[];
		await harness.show(tester, KlpFrameGroups(id: explorerId('forest'), groups: [for (final tree in trees) KlpFrameGroup(id: tree.id.child('group'), content: [KlpExplorer(id: tree.id, data: data, canDrop: (request) => request.sourceIds.contains(source.id) && request.targetId == target.id && request.position == KlpExplorerDropPlacement.inside, onDrop: drops.add)])]));
		final from = tester.getCenter(find.text('Source'));
		await tester.dragFrom(from, tester.getCenter(find.text('Target')) - from, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(drops, hasLength(1));
		expect(drops.single.sourceIds, {source.id});
		expect(drops.single.targetId, target.id);
		expect(drops.single.position, KlpExplorerDropPlacement.inside);
	});
}
