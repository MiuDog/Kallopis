import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart' as umbrella;
import 'package:kallopis/kallopis_foundation.dart' as stable;

import 'klp_prepared_module_boundary_test.dart';

void main() {
	test('Stable and umbrella preserve toolbar and action identity and constructors', () {
		const first = stable.KlpSelectionAction(id: 'apply', label: 'Apply', onPressed: null);
		const second = umbrella.KlpSelectionAction(id: 'apply', label: 'Apply', onPressed: null);
		expect(identical(first, second), isTrue);
		expect(first.danger, isFalse);
		const toolbar = stable.KlpSelectionToolbar(count: 2, countLabel: '2 selected', actions: [first]);
		const alias = umbrella.KlpSelectionToolbar(count: 2, countLabel: '2 selected', actions: [second]);
		expect(toolbar.runtimeType, alias.runtimeType);
		expect(toolbar, isA<umbrella.KlpSelectionToolbar>());
		expect(first, isA<umbrella.KlpSelectionAction>());
		expect(toolbar.count, 2);
		expect(toolbar.countLabel, '2 selected');
		expect(toolbar.actions.single, same(first));
		expect(toolbar.onClear, isNull);
		expect(toolbar.clearLabel, 'Clear');
		expect(toolbar.dashed, isTrue);
		void callback() {}
		final action = stable.KlpSelectionAction(id: 'delete', label: 'Delete', onPressed: callback, danger: true);
		final configured = stable.KlpSelectionToolbar(
			key: const ValueKey('toolbar'),
			count: 1,
			countLabel: 'Selected',
			actions: [action],
			onClear: callback,
			clearLabel: null,
			dashed: false,
		);
		expect(configured.key, const ValueKey('toolbar'));
		expect(configured.onClear, same(callback));
		expect(configured.clearLabel, isNull);
		expect(configured.dashed, isFalse);
		expect(action.id, 'delete');
		expect(action.label, 'Delete');
		expect(action.onPressed, same(callback));
		expect(action.danger, isTrue);
	});
	testWidgets('toolbar preserves enabled disabled danger callbacks and clear semantics', (tester) async {
		final semantics = tester.ensureSemantics();
		var applied = 0;
		var removed = 0;
		var cleared = 0;
		final toolbar = stable.KlpSelectionToolbar(
			count: 2,
			countLabel: '2 selected',
			actions: [
				stable.KlpSelectionAction(id: 'apply', label: 'Apply', onPressed: () => applied++),
				const stable.KlpSelectionAction(id: 'disabled', label: 'Disabled', onPressed: null),
				stable.KlpSelectionAction(id: 'delete', label: 'Delete', onPressed: () => removed++, danger: true),
			],
			onClear: () => cleared++,
			clearLabel: 'Clear selection',
			dashed: false,
		);
		// 透過 Stable 入口建構真實工具列，檢查事件與可程式觀察的語意。
		await tester.pumpWidget(MaterialApp(theme: umbrella.buildKlpTheme(Brightness.light), home: toolbar));
		expect(find.text('2 selected'), findsOneWidget);
		final buttons = tester.widgetList<stable.KlpButton>(find.byType(stable.KlpButton)).toList();
		expect(buttons.map((button) => button.label), ['Apply', 'Disabled', 'Delete']);
		expect(buttons.map((button) => button.compact), everyElement(isTrue));
		expect(buttons.map((button) => button.tone), [stable.KlpButtonTone.ghost, stable.KlpButtonTone.ghost, stable.KlpButtonTone.danger]);
		expect(buttons[1].onPressed, isNull);
		final applyNode = tester.getSemantics(find.bySemanticsLabel('Apply'));
		expect(applyNode.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
		expect(applyNode.label, 'Apply');
		final disabledNode = tester.getSemantics(find.bySemanticsLabel('Disabled'));
		expect(disabledNode.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
		final clearNode = tester.getSemantics(find.byType(stable.KlpActionRegion));
		expect(clearNode.hasFlag(SemanticsFlag.isButton), isTrue);
		expect(clearNode.label, contains('Clear selection'));
		expect(clearNode.hasFlag(SemanticsFlag.isEnabled), isTrue);
		await tester.tap(find.text('Apply'));
		await tester.tap(find.text('Delete'));
		await tester.tap(find.text('Clear selection'));
		expect([applied, removed, cleared], [1, 1, 1]);
		expect(tester.takeException(), isNull);
		semantics.dispose();
	});
	testWidgets('clear control remains absent when callback or label is absent', (tester) async {
		for (final toolbar in [
			const stable.KlpSelectionToolbar(count: 0, countLabel: 'None', actions: [], clearLabel: 'Clear selection'),
			stable.KlpSelectionToolbar(count: 0, countLabel: 'None', actions: [], onClear: () {}, clearLabel: null),
		]) {
			await tester.pumpWidget(MaterialApp(theme: umbrella.buildKlpTheme(Brightness.light), home: toolbar));
			expect(find.bySemanticsLabel('Clear selection'), findsNothing);
			expect(find.byType(stable.KlpActionRegion), findsNothing);
		}
	});
	test('Stable exports exactly original toolbar and action declarations without internal prepared or style types', () {
		for (final entry in ['lib/kallopis_foundation.dart', 'lib/kallopis.dart']) {
			final symbols = preparedPublicSymbols(entry);
			expect(symbols['KlpSelectionToolbar'], 'lib/src/features/actions/selection_toolbar/internal/klp_selection_toolbar_widget.dart');
			expect(symbols['KlpSelectionAction'], 'lib/src/foundation/interaction/filter/models/klp_selection_action.dart');
			expect(symbols.keys, isNot(contains('KlpButtonStyle')));
			expect(symbols.keys.where((name) => name.startsWith('KlpBound') || name.startsWith('KlpPrepared')), isEmpty);
		}
	});
}
