import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart';

import 'klp_explorer_test.dart' show ExplorerTestHarness, explorerData, explorerId, explorerNode;

const _branch = KlpExplorerCapabilities(selectable: true, collapsible: true);
const _toggle = KlpExplorerCapabilities(collapsible: true, primaryAction: KlpExplorerPrimaryAction.toggleExpansion);

void main() {

	test('完整展開提案可保留或清除隱藏三層後代，且不修改快照與其他樹', () {
		// 後代 ID 故意不沿父 ID 命名，收合必須依實際 children 走訪。
		final deep = explorerNode('Deep', capabilities: _branch, children: [explorerNode('Leaf')]);
		final middle = explorerNode('Middle', capabilities: _branch, children: [deep]);
		final parent = explorerNode('Parent', capabilities: _branch, children: [middle]);
		final sibling = explorerNode('Sibling', capabilities: _branch, children: [explorerNode('Sibling leaf')]);
		final other = explorerNode('Other', capabilities: _branch, children: [explorerNode('Other leaf')]);
		final original = {deep.id, sibling.id};
		final trees = [KlpExplorerTreeData(id: explorerId('a'), items: [parent, sibling], expandedIds: original), KlpExplorerTreeData(id: explorerId('b'), items: [other], expandedIds: {other.id})];
		final scope = KlpExplorerSelectionScope(id: explorerId('scope'), treeIds: trees.map((tree) => tree.id).toList(), mode: KlpExplorerSelectionMode.multiple, selectedIds: {explorerId('Leaf'), other.id}, anchorId: explorerId('Leaf'));
		final data = KlpExplorerData(trees: trees, selectionScopes: [scope]);
		final snapshot = data.snapshot;
		expect(snapshot.trees[explorerId('a')]!.visibleIds, isNot(contains(deep.id)));
		expect(data.expandedIdsAfter(parent.id, false), original);
		expect(data.expandedIdsAfter(parent.id, true, collapseDescendants: true), {...original, parent.id});
		final proposal = data.expandedIdsAfter(parent.id, false, collapseDescendants: true);
		expect(proposal, {sibling.id});
		expect(() => proposal.add(parent.id), throwsUnsupportedError);
		expect(snapshot.trees[explorerId('a')]!.expandedIds, original);
		expect(snapshot.trees[explorerId('b')]!.expandedIds, {other.id});
		expect(snapshot.selectionScopes[scope.id]!.selectedIds, {explorerId('Leaf'), other.id});
		expect(snapshot.selectionScopes[scope.id]!.anchorId, explorerId('Leaf'));
		expect(original, {deep.id, sibling.id});
	});

	test('空分類可展開，未知項與空節點或固定分類不可提出展開', () {
		final empty = KlpExplorerCategoryModel(id: explorerId('Empty category'), row: KlpExplorerRowData(title: 'Empty category'), capabilities: _toggle);
		final fixed = KlpExplorerCategoryModel(id: explorerId('Fixed category'), row: KlpExplorerRowData(title: 'Fixed category'));
		final node = explorerNode('Empty node', capabilities: _branch);
		final data = explorerData([empty, fixed, node], expanded: {empty.id});
		expect(data.snapshot.trees[explorerId('explorer')]!.expandedIds, {empty.id});
		expect(data.expandedIdsAfter(empty.id, false), isEmpty);
		expect(data.expandedIdsAfter(empty.id, true), {empty.id});
		for (final id in [explorerId('Missing'), fixed.id, node.id]) {
			for (final expanded in [false, true]) {
				expect(() => data.expandedIdsAfter(id, expanded), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'explorer_invalid_expansion')));
			}
		}
	});

	testWidgets('空分類指標與鍵盤提出相同切換且不連帶選取或啟用', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final changes = <(KlpId, bool)>[];
		var unrelated = 0;
		final category = KlpExplorerCategoryModel(id: explorerId('Empty'), row: KlpExplorerRowData(title: 'Empty'), capabilities: _toggle);
		KlpExplorer tree(bool open) => KlpExplorer(id: explorerId('explorer'), data: explorerData([category], expanded: open ? {category.id} : {}), onExpandedChanged: (id, expanded) => changes.add((id, expanded)), onActivate: (_) => unrelated++, onSelectionChanged: (_) => unrelated++);

		// 指標命中箭頭與標題都只提出展開，資料仍由 consumer 提交。
		await harness.show(tester, tree(false));
		final arrow = find.bySemanticsLabel('Expand Empty');
		expect(arrow, findsOneWidget);
		expect(tester.getSize(arrow).width, 20);
		await tester.tap(arrow);
		expect(changes, [(category.id, true)]);
		await tester.tap(find.text('Empty'));
		expect(changes.last, (category.id, true));
		changes.clear();
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
		expect(changes, [(category.id, true)]);
		await harness.show(tester, tree(true));
		changes.clear();
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.sendKeyEvent(LogicalKeyboardKey.space);
		expect(changes, [(category.id, false), (category.id, false), (category.id, false)]);
		expect(unrelated, 0);
	});

	testWidgets('分類與節點箭頭共用12px，固定空分類仍顯示非操作箭頭', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final category = KlpExplorerCategoryModel(id: explorerId('Category'), row: KlpExplorerRowData(title: 'Category'), capabilities: _toggle);
		final fixed = KlpExplorerCategoryModel(id: explorerId('Fixed'), row: KlpExplorerRowData(title: 'Fixed'));
		final node = explorerNode('Node', capabilities: _branch, children: [explorerNode('Child')]);
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: explorerData([category, fixed, node])));
		for (final label in ['Expand Category', 'Expand Node']) {
			final arrow = find.bySemanticsLabel(label);
			expect(arrow, findsOneWidget);
			expect(tester.getSize(arrow).width, 20);
			final glyph = find.descendant(of: arrow, matching: find.byType(KlpFlutterLucideIcon));
			expect(tester.getSize(glyph).width, 12);
		}
		expect(find.bySemanticsLabel('Expand Fixed'), findsNothing);
		expect(find.bySemanticsLabel('Collapse Fixed'), findsNothing);
		expect(find.byType(KlpFlutterLucideIcon), findsNWidgets(3));
	});
}
