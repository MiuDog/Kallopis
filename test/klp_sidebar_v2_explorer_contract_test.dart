import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';

/// 透過公開宣告式節點驗證 Explorer 的實際 renderer 互動。
final class _SidebarV2Harness {
	final runtime = KlpTreeRuntime();

	Future<void> show(WidgetTester tester, KlpExplorer explorer) async {
		final screen = KlpScreen(
			id: KlpId.parse('screen'),
			accessibilityLabel: 'Sidebar v2',
			child: KlpAppLayout(
				id: KlpId.parse('layout'),
				child: KlpAppFrame(
					id: KlpId.parse('frame'),
					child: KlpFrameGroups(
						id: KlpId.parse('groups'),
						groups: [
							KlpFrameGroup(id: KlpId.parse('group'), content: [explorer]),
						],
					),
				),
			),
		);
		runtime.update(
			root: screen,
			adapters: klpApplicationAdapters(),
			primitives: KlpWorkspacePreset.light(),
		);
		await tester.pumpWidget(
			WidgetsApp(
				color: const Color(0xff000000),
				builder: (_, _) => KlpFlutterRenderer(content: runtime.frame!.content),
			),
		);
		await tester.pumpAndSettle();
		expect(tester.takeException(), isNull);
	}
}

void main() {
	testWidgets('branch 標題選取與 disclosure 展開分離', (tester) async {
		final harness = _SidebarV2Harness();
		addTearDown(harness.runtime.dispose);
		final branch = KlpId.parse('branch');
		final selections = <KlpId>[];
		final expansions = <(KlpId, bool)>[];
		await harness.show(
			tester,
			KlpExplorer(
				id: KlpId.parse('explorer'),
				onSelected: selections.add,
				onExpandedChanged: (id, expanded) => expansions.add((id, expanded)),
				items: [
					KlpExplorerItem(
						id: branch,
						label: 'Project page',
						kind: KlpExplorerItemKind.branch,
						children: [
							KlpExplorerItem(
								id: KlpId.parse('child'),
								label: 'Child page',
								kind: KlpExplorerItemKind.file,
							),
						],
					),
				],
			),
		);

		await tester.tap(find.text('Project page'));
		await tester.pump();
		expect(selections, [branch]);
		expect(expansions, isEmpty, reason: '標題不得同時切換展開狀態。');

		await tester.tap(find.bySemanticsLabel('Expand Project page'));
		await tester.pump();
		expect(selections, [branch], reason: 'disclosure 不得觸發選取。');
		expect(expansions, [(branch, true)]);
	});

	testWidgets('selectable false 的 branch 點擊標題只送出展開事件', (tester) async {
		final harness = _SidebarV2Harness();
		addTearDown(harness.runtime.dispose);
		final branch = KlpId.parse('structure');
		final selections = <KlpId>[];
		final expansions = <(KlpId, bool)>[];
		await harness.show(
			tester,
			KlpExplorer(
				id: KlpId.parse('explorer'),
				onSelected: selections.add,
				onExpandedChanged: (id, expanded) => expansions.add((id, expanded)),
				items: [
					KlpExplorerItem(
						id: branch,
						label: 'Structure',
						kind: KlpExplorerItemKind.branch,
						selectable: false,
						children: [
							KlpExplorerItem(
								id: KlpId.parse('leaf'),
								label: 'Leaf',
								kind: KlpExplorerItemKind.file,
							),
						],
					),
				],
			),
		);

		await tester.tap(find.text('Structure'));
		await tester.pump();
		expect(selections, isEmpty);
		expect(expansions, [(branch, true)]);
	});

	testWidgets('contextMenuOnly 隱藏尾端按鈕並保留三種內容選單入口', (tester) async {
		final harness = _SidebarV2Harness();
		addTearDown(harness.runtime.dispose);
		await harness.show(
			tester,
			KlpExplorer(
				id: KlpId.parse('explorer'),
				actionsLabel: 'Row actions',
				commandPresentation: KlpExplorerCommandPresentation.contextMenuOnly,
				onSelected: (_) {},
				items: [
					KlpExplorerItem(
						id: KlpId.parse('page'),
						label: 'Page',
						kind: KlpExplorerItemKind.file,
						actions: [
							KlpWorkspaceCommand(label: 'Archive', onInvoke: (_) {}),
						],
					),
				],
			),
		);

		expect(find.bySemanticsLabel(RegExp('Row actions')), findsNothing);

		await tester.tap(
			find.text('Page'),
			buttons: kSecondaryMouseButton,
			kind: PointerDeviceKind.mouse,
		);
		await tester.pumpAndSettle();
		expect(find.text('Archive'), findsOneWidget);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await tester.pumpAndSettle();

		await tester.tap(find.text('Page'));
		await tester.pump();
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
