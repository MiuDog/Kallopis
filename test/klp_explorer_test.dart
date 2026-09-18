import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:kallopis/src/styling/presets/klp_workspace_preset.dart';

KlpId explorerId(String value) => KlpId.root(value);

KlpExplorerNodeModel explorerNode(String title, {KlpExplorerCapabilities capabilities = const KlpExplorerCapabilities(selectable: true, primaryAction: KlpExplorerPrimaryAction.activate), List<KlpExplorerItemModel> children = const [], bool canHaveChildren = true, List<KlpExplorerCommand> commands = const []}) {
	return KlpExplorerNodeModel(id: explorerId(title), row: KlpExplorerRowData(title: title, contextActions: commands), canHaveChildren: canHaveChildren, capabilities: capabilities, children: children);
}

KlpExplorerData explorerData(List<KlpExplorerItemModel> items, {Set<KlpId> selected = const {}, Set<KlpId> expanded = const {}, KlpId? anchor, KlpExplorerSelectionMode mode = KlpExplorerSelectionMode.multiple, List<KlpExplorerDropAcceptance> acceptedDrops = const []}) {
	final tree = KlpExplorerTreeData(id: explorerId('explorer'), items: items, expandedIds: expanded);
	final scope = KlpExplorerSelectionScope(id: explorerId('scope'), treeIds: [tree.id], mode: mode, selectedIds: selected, anchorId: anchor);
	return KlpExplorerData(trees: [tree], selectionScopes: [scope], acceptedDrops: acceptedDrops);
}

/// 以正式 root、runtime 與 renderer 觀察 consumer 可見結果。
final class ExplorerTestHarness {

	final runtime = KlpTreeRuntime();

	Future<void> show(WidgetTester tester, KlpNode child) async {
		final screen = KlpScreen(id: explorerId('screen'), accessibilityLabel: 'Explorer', child: KlpAppLayout(id: explorerId('layout'), child: KlpAppFrame(id: explorerId('frame'), child: KlpFrameGroups(id: explorerId('groups'), groups: [KlpFrameGroup(id: explorerId('group'), content: [child])]))));
		runtime.update(root: screen, adapters: klpApplicationAdapters(), primitives: KlpWorkspacePreset.light());
		await tester.pumpWidget(WidgetsApp(color: const Color(0xff000000), builder: (_, _) => KlpFlutterRenderer(content: runtime.frame!.content)));
		await tester.pumpAndSettle();
		expect(tester.takeException(), isNull);
	}
}

void main() {

	testWidgets('普通點擊依序提出選取與啟用，等待 consumer 提交完整狀態', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final events = <String>[];
		final changes = <KlpExplorerSelectionRequested>[];
		final data = explorerData([explorerNode('Alpha')]);
		await harness.show(tester, KlpExplorer(id: explorerId('explorer'), data: data, onIntent: (intent) {
			if (intent case final KlpExplorerSelectionRequested change) {
				changes.add(change);
				events.add('selection');
			}
			if (intent case KlpExplorerActivationRequested(:final itemId)) events.add('activate:${itemId.value}');
		}));
		await tester.tap(find.text('Alpha'));
		await tester.pump();
		expect(events, ['selection', 'activate:Alpha']);
		expect(changes.single.scopeId, explorerId('scope'));
		expect(changes.single.selectedIds, {explorerId('Alpha')});
		expect(changes.single.anchorId, explorerId('Alpha'));
		await tester.tap(find.text('Alpha'));
		await tester.pump();
		expect(changes.last.selectedIds, {explorerId('Alpha')});
		expect(find.text('Alpha'), findsOneWidget);
	});

	testWidgets('失敗的新宣告保留上一影格與原有有效回呼', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		var activations = 0;
		KlpExplorer tree(KlpExplorerData data) => KlpExplorer(id: explorerId('explorer'), data: data, onIntent: (intent) {
			if (intent is KlpExplorerActivationRequested) activations++;
		});
		await harness.show(tester, tree(explorerData([explorerNode('Kept')])));
		final previous = harness.runtime.frame!;
		final invalid = explorerData([explorerNode('Replacement')], selected: {explorerId('Kept')});
		expect(() => tree(invalid), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'explorer_invalid_selection')));
		expect(harness.runtime.frame, same(previous));
		expect(previous.lease.isActive, isTrue);
		expect(find.text('Kept'), findsOneWidget);
		expect(find.text('Replacement'), findsNothing);
		await tester.tap(find.text('Kept'));
		expect(activations, 1);
	});

	testWidgets('已退役影格的 Explorer 回呼不能提交選取或啟用', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		var calls = 0;
		KlpExplorer tree(String title) => KlpExplorer(id: explorerId('explorer'), data: explorerData([explorerNode(title)]), onIntent: (_) => calls++);
		await harness.show(tester, tree('Old'));
		final previous = harness.runtime.frame!;
		await harness.show(tester, tree('New'));
		expect(previous.lease.isActive, isFalse);
		await tester.pumpWidget(WidgetsApp(color: const Color(0xff000000), builder: (_, _) => KlpFlutterRenderer(content: previous.content)));
		await tester.pumpAndSettle();
		await tester.tap(find.text('Old'));
		await tester.pump();
		expect(calls, 0);
	});

	testWidgets('同一森林的多棵樹以明示 scope 順序完成 Shift 選取', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		Set<KlpId> selected = {};
		KlpId? anchor;
		final activations = <KlpId>[];
		KlpFrameGroups forest() {
			final trees = [KlpExplorerTreeData(id: explorerId('a-tree'), items: [explorerNode('A')]), KlpExplorerTreeData(id: explorerId('b-tree'), items: [explorerNode('B'), explorerNode('C')])];
			final scope = KlpExplorerSelectionScope(id: explorerId('shared'), treeIds: trees.map((tree) => tree.id).toList(), mode: KlpExplorerSelectionMode.multiple, selectedIds: selected, anchorId: anchor);
			final data = KlpExplorerData(trees: trees, selectionScopes: [scope]);
			void handle(KlpExplorerIntent intent) {
				if (intent case KlpExplorerSelectionRequested(:final selectedIds, :final anchorId)) {
					selected = selectedIds;
					anchor = anchorId;
				}
				if (intent case KlpExplorerActivationRequested(:final itemId)) activations.add(itemId);
			}
			return KlpFrameGroups(id: explorerId('forest'), groups: [for (final tree in trees) KlpFrameGroup(id: tree.id.child('group'), content: [KlpExplorer(id: tree.id, data: data, onIntent: handle)])]);
		}
		await harness.show(tester, forest());
		await tester.tap(find.text('A'));
		await harness.show(tester, forest());
		await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
		await tester.tap(find.text('C'));
		await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
		expect(selected, {explorerId('A'), explorerId('B'), explorerId('C')});
		expect(activations, [explorerId('A')]);
	});

	testWidgets('樹鍵盤移動焦點與展開分離，Enter 才執行主動作', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final activations = <KlpId>[];
		final expansions = <(KlpId, bool)>[];
		final branch = explorerNode('Parent', capabilities: const KlpExplorerCapabilities(collapsible: true, primaryAction: KlpExplorerPrimaryAction.activate), children: [explorerNode('Child')]);
		KlpExplorer tree(bool open) => KlpExplorer(id: explorerId('explorer'), data: explorerData([branch, explorerNode('Next')], expanded: open ? {branch.id} : {}), onIntent: (intent) {
			if (intent case KlpExplorerActivationRequested(:final itemId)) activations.add(itemId);
			if (intent case KlpExplorerExpansionRequested(:final itemId, :final expanded)) expansions.add((itemId, expanded));
		});
		await harness.show(tester, tree(false));
		await tester.tap(find.text('Parent'));
		activations.clear();
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
		expect(expansions, [(branch.id, true)]);
		expect(activations, isEmpty);
		await harness.show(tester, tree(true));
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		expect(activations, [explorerId('Child')]);
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		expect(activations.last, branch.id);
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
		expect(expansions.last, (branch.id, false));
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		expect(activations.last, explorerId('Next'));
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		expect(activations.last, explorerId('Child'));
	});
}
