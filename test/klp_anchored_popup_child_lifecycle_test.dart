import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'klp_explorer_test.dart' show ExplorerTestHarness, explorerId;

void main() {
	testWidgets('consumer 關閉 popup 時一併關閉自己的子命令選單並返回 trigger', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		final requests = <bool>[];
		final results = <KlpWorkspaceCommandResult>[];
		var invocations = 0;
		final command = KlpWorkspaceCommand(label: 'Rename project', onInvoke: (_) => invocations++, onResult: results.add);
		final item = KlpAnchoredPopupItem(id: explorerId('project'), label: 'Project with commands', commands: [command]);
		KlpAnchoredPopup declaration(bool open) => _popup(open: open, changed: (value, _) => requests.add(value), items: [item]);
		await harness.show(tester, declaration(true));
		await tester.tap(find.text('Project with commands'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
		await tester.pumpAndSettle();
		expect(find.text('Rename project'), findsOneWidget);

		// 同一 placement 接收新的受控 open；不執行子選單的產品命令。
		await harness.show(tester, declaration(false));
		expect(find.text('Rename project'), findsNothing);
		expect(find.text('Project with commands'), findsNothing);
		expect(invocations, 0);
		expect(results, isEmpty);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.pumpAndSettle();
		expect(requests, [true]);
		expect(invocations, 0);
		expect(results, isEmpty);
	});

	testWidgets('子視窗首次建構前 consumer 已關閉 popup，不留下延後出現的互動', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		for (final useMenu in [true, false]) {
			final requests = <bool>[];
			final results = <KlpWorkspaceCommandResult>[];
			var invocations = 0;
			final command = KlpWorkspaceCommand(
				label: 'Pending rename',
				inputLabel: 'Pending project name',
				submitLabel: 'Apply pending change',
				cancelLabel: 'Cancel pending change',
				onInvoke: (_) => invocations++,
				onResult: results.add,
			);
			final item = KlpAnchoredPopupItem(id: explorerId('pending-project'), label: 'Pending project', commands: [command]);
			KlpAnchoredPopup declaration(bool open) => _popup(open: open, changed: (value, _) => requests.add(value), items: useMenu ? [item] : null, actions: useMenu ? null : [command]);
			await harness.show(tester, declaration(true));
			if (useMenu) {
				await tester.tap(find.text('Pending project'), buttons: kSecondaryMouseButton, kind: PointerDeviceKind.mouse);
			}
			else {
				await tester.tap(find.text('Pending rename'));
			}

			// 刻意不 pump 子 route；先提交關閉，再讓宿主建構下一幀。
			await harness.show(tester, declaration(false));
			expect(find.text('Pending rename'), findsNothing);
			expect(find.text('Pending project'), findsNothing);
			expect(find.text('Apply pending change'), findsNothing);
			expect(find.text('Cancel pending change'), findsNothing);
			expect(find.byType(EditableText), findsNothing);
			expect(invocations, 0);
			expect(results, isEmpty);
			await tester.sendKeyEvent(LogicalKeyboardKey.enter);
			await tester.pumpAndSettle();
			expect(requests, [true]);
			expect(invocations, 0);
			expect(results, isEmpty);
		}
	});

	testWidgets('consumer 關閉 popup 時取消自己的輸入與確認流程，不回呼已失效命令', (tester) async {
		final harness = ExplorerTestHarness();
		addTearDown(harness.runtime.dispose);
		for (final requiresInput in [true, false]) {
			final requests = <bool>[];
			final results = <KlpWorkspaceCommandResult>[];
			var invocations = 0;
			final command = KlpWorkspaceCommand(
				label: requiresInput ? 'Edit project name' : 'Remove project',
				inputLabel: requiresInput ? 'Project name' : null,
				initialValue: requiresInput ? 'Original project' : null,
				confirmation: requiresInput ? null : 'Remove this project?',
				submitLabel: 'Apply change',
				cancelLabel: 'Keep current',
				onInvoke: (_) => invocations++,
				onResult: results.add,
			);
			KlpAnchoredPopup declaration(bool open) => _popup(open: open, changed: (value, _) => requests.add(value), actions: [command]);
			await harness.show(tester, declaration(true));
			await tester.tap(find.text(command.label));
			await tester.pumpAndSettle();
			expect(find.text('Apply change'), findsOneWidget);
			expect(find.text('Keep current'), findsOneWidget);
			if (requiresInput) {
				await tester.enterText(find.byType(EditableText), 'Updated project');
			}
			else {
				expect(find.text('Remove this project?'), findsOneWidget);
			}

			// 關閉後不留 orphan dialog；Enter 只能再次向 trigger 請求開啟。
			await harness.show(tester, declaration(false));
			expect(find.text('Apply change'), findsNothing);
			expect(find.text('Keep current'), findsNothing);
			expect(find.byType(EditableText), findsNothing);
			expect(find.text('Remove this project?'), findsNothing);
			expect(invocations, 0);
			expect(results, isEmpty);
			await tester.sendKeyEvent(LogicalKeyboardKey.enter);
			await tester.pumpAndSettle();
			expect(requests, [true]);
			expect(invocations, 0);
			expect(results, isEmpty);
		}
	});
}

KlpAnchoredPopup _popup({
	required bool open,
	required void Function(bool, KlpAnchoredPopupChangeReason) changed,
	List<KlpAnchoredPopupItem>? items,
	List<KlpWorkspaceCommand>? actions,
}) => KlpAnchoredPopup(
	id: explorerId('popup-child-owner'),
	trigger: KlpWorkspaceBlock(id: explorerId('popup-child-trigger'), kind: KlpWorkspaceBlockKind.action, title: 'Projects'),
	open: open,
	accessibilityLabel: 'Project commands',
	items: items,
	actions: actions,
	onOpenChanged: changed,
);
