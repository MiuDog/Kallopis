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

Future<void> _showCommands(
	WidgetTester tester,
	ExplorerTestHarness harness,
	List<KlpExplorerCommand> commands,
	List<KlpExplorerIntent> intents,
) async {
	await harness.show(
		tester,
		KlpExplorer(
			id: explorerId('explorer'),
			data: explorerData([explorerNode('Note', commands: commands)]),
			onIntent: intents.add,
		),
	);
}

void main() {
	testWidgets('F2 輸入取消與 Escape 關閉選單不發出命令 intent', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final intents = <KlpExplorerIntent>[];
		await _showCommands(tester, harness, [
			KlpExplorerCommand(
				id: explorerId('rename'),
				label: 'Rename',
				shortcut: KlpExplorerCommandShortcut.rename,
				inputLabel: 'Name',
			),
		], intents);
		await tester.tap(find.text('Note'));
		await tester.sendKeyEvent(LogicalKeyboardKey.f2);
		await tester.pumpAndSettle();
		expect(find.byType(EditableText), findsOneWidget);
		await tester.tap(find.text('Cancel'));
		await tester.pumpAndSettle();
		expect(intents.whereType<KlpExplorerCommandRequested>(), isEmpty);
		await tester.tap(find.text('Note'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(find.text('Rename'), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await tester.pumpAndSettle();
		expect(find.text('Rename'), findsNothing);
	});

	testWidgets('右鍵不選取或啟用，停用命令不可執行，可用命令只提交一次', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final intents = <KlpExplorerIntent>[];
		final row = explorerNode('Note', commands: [
			KlpExplorerCommand(id: explorerId('unavailable'), label: 'Unavailable', enabled: false),
			KlpExplorerCommand(id: explorerId('pin'), label: 'Pin'),
		]);
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([row]), onIntent: intents.add));
		await tester.tap(find.text('Note'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		await tester.tap(find.text('Unavailable'));
		await tester.pumpAndSettle();
		expect(intents, isEmpty);
		await tester.tap(find.text('Pin'));
		await tester.pumpAndSettle();
		final command = intents.single as KlpExplorerCommandRequested;
		expect(command.itemId, row.id);
		expect(command.commandId, explorerId('pin'));
	});

	testWidgets('命名驗證空白，取消不提交，確認只輸出輸入值', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final intents = <KlpExplorerIntent>[];
		await _showCommands(tester, harness, [
			KlpExplorerCommand(
				id: explorerId('rename'),
				label: 'Rename',
				inputLabel: 'Name',
				initialValue: 'Note',
			),
		], intents);
		await _menu(tester, 'Rename');
		await tester.tap(find.text('Cancel'));
		await tester.pumpAndSettle();
		expect(intents, isEmpty);
		await _menu(tester, 'Rename');
		await tester.enterText(find.byType(EditableText), '   ');
		await tester.tap(find.text('OK'));
		await tester.pumpAndSettle();
		expect(intents, isEmpty);
		expect(find.byType(EditableText), findsOneWidget);
		await tester.enterText(find.byType(EditableText), 'Research');
		await tester.tap(find.text('OK'));
		await tester.pumpAndSettle();
		final command = intents.single as KlpExplorerCommandRequested;
		expect(command.input, 'Research');
		expect(find.byType(EditableText), findsNothing);
	});

	testWidgets('確認取消不提交，確認只發出一個命令 intent', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final intents = <KlpExplorerIntent>[];
		await _showCommands(tester, harness, [
			KlpExplorerCommand(
				id: explorerId('purge'),
				label: 'Purge',
				confirmation: 'Delete permanently?',
			),
		], intents);
		await _menu(tester, 'Purge');
		expect(find.text('Delete permanently?'), findsOneWidget);
		await tester.tap(find.text('Cancel'));
		await tester.pumpAndSettle();
		expect(intents, isEmpty);
		await _menu(tester, 'Purge');
		await tester.tap(find.text('OK'));
		await tester.pumpAndSettle();
		expect(intents.whereType<KlpExplorerCommandRequested>(), hasLength(1));
	});

	testWidgets('命令確認等待期間替換影格不允許殘留提交', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final intents = <KlpExplorerIntent>[];
		await _showCommands(tester, harness, [
			KlpExplorerCommand(id: explorerId('purge'), label: 'Purge', confirmation: 'Confirm?'),
		], intents);
		await _menu(tester, 'Purge');
		await harness.show(
			tester,
			KlpExplorer(
				id: explorerId('explorer'),
				data: explorerData([explorerNode('Replacement')]),
				onIntent: (_) {},
			),
		);
		if (find.text('OK').evaluate().isNotEmpty) {
			await tester.tap(find.text('OK'));
			await tester.pumpAndSettle();
		}
		expect(intents, isEmpty);
	});

	testWidgets('拖放預設拒絕，精確 acceptance 才發出 before inside after', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final drops = <KlpExplorerDropRequested>[];
		final source = explorerNode('Source', capabilities: const KlpExplorerCapabilities(draggable: true));
		final target = explorerNode('Target');
		final acceptances = [
			for (final position in KlpExplorerDropPlacement.values)
				KlpExplorerDropAcceptance(sourceIds: {source.id}, targetId: target.id, position: position),
		];
		KlpExplorer tree(bool allowed) => KlpExplorer(
			id: explorerId('explorer'),
			data: explorerData([source, target], acceptedDrops: allowed ? acceptances : const []),
			onIntent: (intent) {
				if (intent case final KlpExplorerDropRequested drop) drops.add(drop);
			},
		);
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
		for (final offset in [-12.0, 0.0, 12.0]) await drag(offset);
		expect(drops.map((request) => request.position), KlpExplorerDropPlacement.values);
		expect(drops.every((request) => request.sourceIds.contains(source.id) && request.targetId == target.id), isTrue);
	});

	testWidgets('手勢期間不再查詢 consumer，使用捕獲的不可變 acceptance', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final source = explorerNode('Source', capabilities: const KlpExplorerCapabilities(draggable: true));
		final target = explorerNode('Target');
		final drops = <KlpExplorerDropRequested>[];
		final accepted = <KlpExplorerDropAcceptance>[
			KlpExplorerDropAcceptance(sourceIds: {source.id}, targetId: target.id, position: KlpExplorerDropPlacement.inside),
		];
		final data = explorerData([source, target], acceptedDrops: accepted);
		accepted.clear();
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: data, onIntent: (intent) {
			if (intent case final KlpExplorerDropRequested drop) drops.add(drop);
		}));
		final from = tester.getCenter(find.text('Source'));
		await tester.dragFrom(from, tester.getCenter(find.text('Target')) - from, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(drops, hasLength(1));
	});

	testWidgets('跨 Explorer 拖放保留來源身分與 inside 意圖', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final source = explorerNode('Source', capabilities: const KlpExplorerCapabilities(draggable: true));
		final target = explorerNode('Target');
		final trees = [
			KlpExplorerTreeData(id: explorerId('source-tree'), items: [source]),
			KlpExplorerTreeData(id: explorerId('target-tree'), items: [target]),
		];
		final scope = KlpExplorerSelectionScope(id: explorerId('shared'), treeIds: trees.map((tree) => tree.id).toList(), mode: KlpExplorerSelectionMode.none);
		final acceptance = KlpExplorerDropAcceptance(sourceIds: {source.id}, targetId: target.id, position: KlpExplorerDropPlacement.inside);
		final data = KlpExplorerData(trees: trees, selectionScopes: [scope], acceptedDrops: [acceptance]);
		final drops = <KlpExplorerDropRequested>[];
		await harness.show(
			tester,
			KlpFrameGroups(
				id: explorerId('forest'),
				groups: [
					for (final tree in trees)
						KlpFrameGroup(
							id: tree.id.child('group'),
							content: [KlpExplorer(id: tree.id, data: data, onIntent: (intent) {
								if (intent case final KlpExplorerDropRequested drop) drops.add(drop);
							})],
						),
				],
			),
		);
		final from = tester.getCenter(find.text('Source'));
		await tester.dragFrom(from, tester.getCenter(find.text('Target')) - from, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(drops, hasLength(1));
		expect(drops.single.sourceIds, {source.id});
		expect(drops.single.targetId, target.id);
		expect(drops.single.position, KlpExplorerDropPlacement.inside);
	});
}
