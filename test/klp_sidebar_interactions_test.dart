import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';

/// 經正式公開節點、編譯器及渲染器驗證互動，測試不直接呼叫 callback 冒充操作。
final class SidebarHarness {

	final runtime = KlpTreeRuntime();

	Future<void> show(WidgetTester tester, KlpNode child) async {
		final screen = KlpScreen(id: KlpId.parse('screen'), accessibilityLabel: 'Sidebar', child: KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), child: KlpFrameGroups(id: KlpId.parse('groups'), groups: [KlpFrameGroup(id: KlpId.parse('group'), content: [child])]))));
		final values = KlpWorkspacePreset.light();
		runtime.update(root: screen, adapters: klpApplicationAdapters(), primitives: values);
		await tester.pumpWidget(WidgetsApp(color: const Color(0xff000000), builder: (_, _) => KlpFlutterRenderer(content: runtime.frame!.content)));
		await tester.pumpAndSettle();
		expect(tester.takeException(), isNull);
	}
}

void main() {
	testWidgets('F2 開啟命名且 Escape 關閉右鍵選單，不執行命令', (tester) async {
		final harness = SidebarHarness();
		addTearDown(harness.runtime.dispose);
		var calls = 0;
		await harness.show(tester, KlpExplorer(id: KlpId.root('explorer'), onSelected: (_) {}, items: [KlpExplorerItem(id: KlpId.root('note'), label: 'Keyboard note', kind: KlpExplorerItemKind.file, actions: [
			KlpWorkspaceCommand(label: 'Rename', shortcut: KlpWorkspaceCommandShortcut.rename, inputLabel: 'Name', onInvoke: (_) => calls++),
		])]));
		await tester.tap(find.text('Keyboard note'));
		await tester.pumpAndSettle();
		await tester.sendKeyEvent(LogicalKeyboardKey.f2);
		await tester.pumpAndSettle();
		expect(find.byType(EditableText), findsOneWidget);
		await tester.tap(find.text('Cancel'));
		await tester.pumpAndSettle();
		await tester.tap(find.text('Keyboard note'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(find.text('Rename'), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await tester.pumpAndSettle();
		expect(find.text('Rename'), findsNothing);
		expect(calls, 0);
	});

	testWidgets('資料列頂部與底部拖放分別發出 before 與 after', (tester) async {
		final harness = SidebarHarness();
		addTearDown(harness.runtime.dispose);
		final file = KlpId.parse('file');
		final folder = KlpId.parse('folder');
		final positions = <KlpExplorerDropPosition>[];
		await harness.show(tester, KlpExplorer(id: KlpId.parse('explorer'), onMove: (_, _, position) => positions.add(position), items: [
			KlpExplorerItem(id: file, label: 'Source', kind: KlpExplorerItemKind.file),
			KlpExplorerItem(id: folder, label: 'Target', kind: KlpExplorerItemKind.folder),
		]));
		for (final offset in [-12.0, 12.0]) {
			final from = tester.getCenter(find.text('Source'));
			final to = tester.getCenter(find.text('Target')) + Offset(0, offset);
			await tester.dragFrom(from, to - from, kind: PointerDeviceKind.mouse);
			await tester.pumpAndSettle();
		}
		expect(positions, [KlpExplorerDropPosition.before, KlpExplorerDropPosition.after]);
	});
	testWidgets('跨 Explorer 拖放保留來源公開 ID，不丟失文件分類到收藏的意圖', (tester) async {
		final harness = SidebarHarness();
		addTearDown(harness.runtime.dispose);
		final source = KlpId.parse('source');
		final destination = KlpId.parse('destination');
		final moved = <Set<KlpId>>[];
		await harness.show(tester, KlpFrameGroups(id: KlpId.parse('explorers'), groups: [
			KlpFrameGroup(id: KlpId.parse('source-group'), content: [KlpExplorer(id: KlpId.parse('source-tree'), onMove: (_, _, _) {}, items: [KlpExplorerItem(id: source, label: 'Source document', kind: KlpExplorerItemKind.file)])]),
			KlpFrameGroup(id: KlpId.parse('destination-group'), content: [KlpExplorer(
				id: KlpId.parse('destination-tree'),
				canMove: (ids, target, position) => ids.contains(source) && target == destination && position == KlpExplorerDropPosition.inside,
				onMove: (ids, _, _) => moved.add(ids),
				items: [KlpExplorerItem(id: destination, label: 'Destination folder', kind: KlpExplorerItemKind.folder)],
			)]),
		]));
		final from = tester.getCenter(find.text('Source document'));
		final to = tester.getCenter(find.text('Destination folder'));
		await tester.dragFrom(from, to - from, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(moved, [{source}]);
	});

	testWidgets('拖放只發出合法的同樹移動意圖，拒絕的目的地不修改狀態', (tester) async {
		final harness = SidebarHarness();
		addTearDown(harness.runtime.dispose);
		final file = KlpId.parse('file');
		final folder = KlpId.parse('folder');
		final moves = <(Set<KlpId>, KlpId, KlpExplorerDropPosition)>[];
		KlpExplorer tree(bool allowed) => KlpExplorer(
			id: KlpId.parse('explorer'),
			canMove: (ids, target, position) => allowed && target == folder && position == KlpExplorerDropPosition.inside,
			onMove: (ids, target, position) => moves.add((ids, target, position)),
			items: [KlpExplorerItem(id: file, label: 'Note', kind: KlpExplorerItemKind.file), KlpExplorerItem(id: folder, label: 'Folder', kind: KlpExplorerItemKind.folder)],
		);
		Future<void> drag() async {
			final from = tester.getCenter(find.text('Note'));
			final to = tester.getCenter(find.text('Folder'));
			await tester.dragFrom(from, to - from, kind: PointerDeviceKind.mouse);
			await tester.pumpAndSettle();
		}
		await harness.show(tester, tree(false));
		await drag();
		expect(moves, isEmpty);
		await harness.show(tester, tree(true));
		await drag();
		expect(moves, hasLength(1));
		expect(moves.single.$1, {file});
		expect(moves.single.$2, folder);
		expect(moves.single.$3, KlpExplorerDropPosition.inside);
		expect(find.text('Note'), findsOneWidget, reason: '移動意圖必須等待消費端更新樹');
	});

	testWidgets('右鍵選單不開啟文件；停用命令不可執行，可用命令只通知一次', (tester) async {
		final harness = SidebarHarness();
		addTearDown(harness.runtime.dispose);
		var opened = 0;
		var called = 0;
		await harness.show(tester, KlpExplorer(id: KlpId.parse('explorer'), onSelected: (_) => opened++, items: [KlpExplorerItem(
			id: KlpId.parse('note'), label: 'Note', kind: KlpExplorerItemKind.file,
			actions: [
				KlpWorkspaceCommand(label: 'Unavailable', enabled: false, onInvoke: (_) => called += 100),
				KlpWorkspaceCommand(label: 'Pin note', onInvoke: (_) => called++),
			],
		)]));
		await tester.tap(find.text('Note'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(opened, 0);
		expect(find.text('Pin note'), findsOneWidget);
		await tester.tap(find.text('Unavailable'));
		await tester.pumpAndSettle();
		expect(called, 0);
		await tester.tap(find.text('Pin note'));
		await tester.pumpAndSettle();
		expect(called, 1);
		expect(opened, 0);
	});

	testWidgets('命名輸入支援取消與空白驗證，確認後才傳送新名稱', (tester) async {
		final harness = SidebarHarness();
		addTearDown(harness.runtime.dispose);
		final names = <String?>[];
		await harness.show(tester, KlpExplorer(id: KlpId.parse('explorer'), items: [KlpExplorerItem(
			id: KlpId.parse('note'), label: 'Note', kind: KlpExplorerItemKind.file,
			actions: [KlpWorkspaceCommand(label: 'Rename', inputLabel: 'New name', initialValue: 'Note', onInvoke: names.add)],
		)]));
		Future<void> rename() async {
			await tester.tap(find.text('Note'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
			await tester.pumpAndSettle();
			await tester.tap(find.text('Rename'));
			await tester.pumpAndSettle();
		}
		await rename();
		await tester.tap(find.text('Cancel'));
		await tester.pumpAndSettle();
		expect(names, isEmpty);
		await rename();
		await tester.enterText(find.byType(EditableText), '   ');
		await tester.tap(find.text('OK'));
		await tester.pumpAndSettle();
		expect(names, isEmpty);
		expect(find.byType(EditableText), findsOneWidget);
		await tester.enterText(find.byType(EditableText), 'Research');
		await tester.tap(find.text('OK'));
		await tester.pumpAndSettle();
		expect(names, ['Research']);
		expect(find.byType(EditableText), findsNothing);
	});

	testWidgets('永久刪除確認取消不執行，確認才觸發命令', (tester) async {
		final harness = SidebarHarness();
		addTearDown(harness.runtime.dispose);
		var deleted = 0;
		await harness.show(tester, KlpExplorer(id: KlpId.parse('explorer'), items: [KlpExplorerItem(
			id: KlpId.parse('note'), label: 'Note', kind: KlpExplorerItemKind.file,
			actions: [KlpWorkspaceCommand(label: 'Purge', destructive: true, confirmation: 'Delete permanently?', onInvoke: (_) => deleted++)],
		)]));
		Future<void> purge() async {
			await tester.tap(find.text('Note'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
			await tester.pumpAndSettle();
			await tester.tap(find.text('Purge'));
			await tester.pumpAndSettle();
		}
		await purge();
		expect(find.text('Delete permanently?'), findsOneWidget);
		await tester.tap(find.text('Cancel'));
		await tester.pumpAndSettle();
		expect(deleted, 0);
		await purge();
		await tester.tap(find.text('OK'));
		await tester.pumpAndSettle();
		expect(deleted, 1);
	});

	testWidgets('Ctrl 多選由消費端控制，純分類不能混入文件批次', (tester) async {
		final harness = SidebarHarness();
		addTearDown(harness.runtime.dispose);
		final a = KlpId.parse('a');
		final b = KlpId.parse('b');
		final category = KlpId.parse('category');
		Set<KlpId> selected = {};
		KlpExplorer tree() => KlpExplorer(
			id: KlpId.parse('explorer'), selectedIds: selected, expandedIds: {category},
			onSelectionChanged: (ids) => selected = ids,
			items: [KlpExplorerItem(id: category, label: 'Documents', kind: KlpExplorerItemKind.category, children: [
				KlpExplorerItem(id: a, label: 'Alpha', kind: KlpExplorerItemKind.file),
				KlpExplorerItem(id: b, label: 'Beta', kind: KlpExplorerItemKind.file),
			])],
		);
		await harness.show(tester, tree());
		await tester.tap(find.text('Alpha'));
		await harness.show(tester, tree());
		await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
		await tester.tap(find.text('Beta'));
		await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
		await harness.show(tester, tree());
		expect(selected, {a, b});
		await tester.tap(find.text('Documents'));
		await tester.pumpAndSettle();
		expect(selected, isNot(contains(category)));
	});
}
