part of '../klp_workspace_components_declarative_test.dart';

void registerWorkspaceDialogChecks() {
	testWidgets('dialog obeys controlled values and exposes change submit cancel and error', (tester) async {
		KlpMutableState<KlpApplication>? source;
		final destination = KlpDestination<int, String>(KlpId.parse('home'));
		final initial = destination.location(0);
		Future<void> show(KlpNode node) async {
			final screen = KlpScreen(id: KlpId.parse('screen'), accessibilityLabel: 'Dialog', child: KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), child: _groups(node))));
			final application = KlpApplication(
				title: 'Dialog',
				router: KlpRouter(id: KlpId.parse('router'), initial: initial, routes: [KlpRoute(destination, screen: (_) => screen)]),
			);
			if (source == null) {
				source = KlpMutableState(application);
				runKlpApp(source!.readOnly);
			}
			else { source!.value = application; }
			await tester.pumpAndSettle();
			expect(tester.takeException(), isNull);
		}
		addTearDown(() => source?.dispose());
		final changes = <String>[];
		var submitted = 0;
		var cancelled = 0;
		KlpWorkspaceBlock dialog(String value) => KlpWorkspaceBlock(
			id: KlpId.parse('controlled.dialog'),
			kind: KlpWorkspaceBlockKind.dialog,
			title: '建立筆記',
			query: value,
			onQueryChanged: changes.add,
			hint: '名稱',
			lines: ['名稱不可空白'],
			items: [KlpWorkspaceItem(title: '建立', onPressed: () => submitted++), KlpWorkspaceItem(title: '取消', onPressed: () => cancelled++)],
		);

		// 必須由公開宣告編譯並顯示受控值與錯誤，不能只測孤立 renderer。
		await show(dialog('初始名稱'));
		await tester.pumpAndSettle();
		expect(find.text('初始名稱'), findsOneWidget);
		expect(find.text('名稱不可空白'), findsOneWidget);
		await tester.enterText(find.byType(EditableText), '使用者改名');
		expect(changes, ['使用者改名']);
		expect((submitted, cancelled), (0, 0));

		// 外部狀態改變要更新相同 id 的欄位；初始化值不能冒充受控值。
		await show(dialog('權威改名'));
		await tester.pumpAndSettle();
		expect(find.text('權威改名'), findsOneWidget);
		expect(find.text('使用者改名'), findsNothing);
		expect(changes, ['使用者改名']);
		await tester.testTextInput.receiveAction(TextInputAction.done);
		await tester.pump();
		expect((submitted, cancelled), (1, 0));
		await tester.tap(find.text('取消'));
		await tester.pump();
		expect((submitted, cancelled), (1, 1));
		expect(tester.takeException(), isNull);
	});
}
