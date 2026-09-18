import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'klp_explorer_test.dart' show ExplorerTestHarness, explorerData, explorerId, explorerNode;

void main() {

	testWidgets('標題選取與啟用分離，disclosure 只提出展開', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final selections = <KlpExplorerSelectionChange>[];
		final expansions = <(KlpId, bool)>[];
		final parent = explorerNode('Project page', capabilities: const KlpExplorerCapabilities(selectable: true, collapsible: true), children: [explorerNode('Child page')]);
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([parent]), onSelectionChanged: selections.add, onExpandedChanged: (id, expanded) => expansions.add((id, expanded))));
		await tester.tap(find.text('Project page'));
		await tester.pump();
		expect(selections.single.selectedIds, {parent.id});
		expect(expansions, isEmpty);
		await tester.tap(find.bySemanticsLabel('Expand Project page'));
		await tester.pump();
		expect(selections, hasLength(1));
		expect(expansions, [(parent.id, true)]);
		expect(find.text('Child page'), findsNothing, reason: '展開必須等待 consumer 提交');
	});

	testWidgets('不可選取節點可切換展開，分類可明示選取，空節點没有 disclosure', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final selections = <KlpExplorerSelectionChange>[];
		final expansions = <(KlpId, bool)>[];
		const toggle = KlpExplorerCapabilities(collapsible: true, primaryAction: KlpExplorerPrimaryAction.toggleExpansion);
		final structure = explorerNode('Structure', capabilities: toggle, children: [explorerNode('Leaf')]);
		final empty = explorerNode('Empty', capabilities: toggle);
		final category = KlpExplorerCategoryModel(id: explorerId('Category'), row: KlpExplorerRowData(title: 'Category'), capabilities: const KlpExplorerCapabilities(selectable: true));
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([structure, empty, category]), onSelectionChanged: selections.add, onExpandedChanged: (id, expanded) => expansions.add((id, expanded))));
		await tester.tap(find.text('Structure'));
		expect(selections, isEmpty);
		expect(expansions, [(structure.id, true)]);
		expect(find.bySemanticsLabel('Expand Empty'), findsNothing);
		await tester.tap(find.text('Empty'));
		expect(expansions, hasLength(1));
		await tester.tap(find.text('Category'));
		expect(selections.single.selectedIds, {category.id});
	});

	testWidgets('Ctrl 與 Meta 切換選取不啟用內容', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		Set<KlpId> selected = {};
		KlpId? anchor;
		final activated = <KlpId>[];
		KlpExplorer tree() => KlpExplorer(id: explorerId('explorer'), data: explorerData([explorerNode('A'), explorerNode('B')], selected: selected, anchor: anchor), onSelectionChanged: (change) { selected = change.selectedIds; anchor = change.anchorId; }, onActivate: activated.add);
		await harness.show(tester, tree());
		await tester.tap(find.text('A'));
		await harness.show(tester, tree());
		await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
		await tester.tap(find.text('B'));
		await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
		expect(selected, {explorerId('A'), explorerId('B')});
		await harness.show(tester, tree());
		await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
		await tester.tap(find.text('A'));
		await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
		expect(selected, {explorerId('B')});
		expect(activated, [explorerId('A')]);
	});

	testWidgets('只有內容選單不新增尾端按鈕，保留右鍵與鍵盤入口', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final page = explorerNode('Page', commands: [KlpWorkspaceCommand(label: 'Archive', onInvoke: (_) {})]);
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([page]), actionsLabel: 'Row actions'));
		expect(find.bySemanticsLabel(RegExp('Row actions')), findsNothing);
		await tester.tap(find.text('Page'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(find.text('Archive'), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await tester.pumpAndSettle();
		await tester.tap(find.text('Page'));
		await tester.sendKeyEvent(LogicalKeyboardKey.contextMenu);
		await tester.pumpAndSettle();
		expect(find.text('Archive'), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await tester.pumpAndSettle();
		await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
		await tester.sendKeyEvent(LogicalKeyboardKey.f10);
		await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
		await tester.pumpAndSettle();
		expect(find.text('Archive'), findsOneWidget);
	});
}
