import 'dart:async';
import 'dart:ui' show SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 只使用公開元件與原生語意、指標、鍵盤；產品 context 保持引用。
class _Context {
	bool visible = true;
	bool enabled = true;
	bool checked = false;
}

const _references = [
	KlpCommandReference(commandId: 'z', kind: KlpCommandKind.toggle),
	KlpCommandReference(commandId: 'a'),
	KlpCommandReference(commandId: 'disabled'),
	KlpCommandReference(commandId: 'hidden'),
	KlpCommandReference(commandId: 'missing'),
	KlpCommandReference(commandId: 'broken'),
];

Widget _entry({
	required bool menu,
	required KlpCommandRegistry<_Context> registry,
	required _Context Function() getContext,
	required ValueChanged<KlpCommandExecutionResult> onResult,
	List<KlpCommandReference> items = _references,
	String label = 'Commands',
	String emptyLabel = 'Nothing available',
	bool autoFocus = false,
	VoidCallback? onDismiss,
}) {
	if (menu) {
		return KlpRegisteredCommandMenu<_Context>(
			registry: registry,
			getContext: getContext,
			items: items,
			label: label,
			emptyLabel: emptyLabel,
			onResult: onResult,
			autoFocus: autoFocus,
			onDismiss: onDismiss,
		);
	}
	return KlpRegisteredCommandToolbar<_Context>(
		registry: registry,
		getContext: getContext,
		items: items,
		label: label,
		onResult: onResult,
	);
}

Widget _app(Widget child) => MaterialApp(theme: buildKlpTheme(Brightness.light), home: Scaffold(body: child));

Finder _row(String label) => find.bySemanticsLabel(label);

bool _flag(WidgetTester tester, String label, SemanticsFlag flag) => tester.getSemantics(_row(label)).hasFlag(flag);

Future<void> _tap(WidgetTester tester, String label) async {
	await tester.tap(_row(label));
	await tester.pump();
}

void _focused(WidgetTester tester, String label) {
	expect(_flag(tester, label, SemanticsFlag.isFocused), isTrue);
}

List<String> _semanticOrder(WidgetTester tester, Set<String> labels) {
	final found = <String>[];
	void visit(SemanticsNode node) {
		if (labels.contains(node.label)) found.add(node.label);
		for (final child in node.debugListChildrenInOrder(DebugSemanticsDumpOrder.traversalOrder)) {
			visit(child);
		}
	}
	visit(tester.binding.pipelineOwner.semanticsOwner!.rootSemanticsNode!);
	return found;
}

void main() {
	// 同一 registry 的兩個公開入口必須共用 pending 權威。
	testWidgets('toolbar and menu share pending without blocking another command', (tester) async {
		final semantics = tester.ensureSemantics();
		addTearDown(semantics.dispose);
		final registry = KlpCommandRegistry<_Context>();
		addTearDown(registry.dispose);
		final context = _Context();
		final pending = Completer<Object?>();
		var calls = 0;
		final results = <KlpCommandExecutionResult>[];
		registry.register(KlpCommandDefinition<_Context>(id: 'z', label: 'Shared', handler: (value) { calls++; return pending.future; }));
		registry.register(KlpCommandDefinition<_Context>(id: 'a', label: 'Independent', handler: (value) => value));
		await tester.pumpWidget(_app(Column(children: [
			_entry(menu: false, registry: registry, getContext: () => context, onResult: results.add),
			_entry(menu: true, registry: registry, getContext: () => context, onResult: results.add),
		])));
		Finder inEntry(bool menu, String label) => find.descendant(of: find.byType(menu ? KlpRegisteredCommandMenu<_Context> : KlpRegisteredCommandToolbar<_Context>), matching: _row(label));
		await tester.tap(inEntry(false, 'Shared'));
		await tester.pump();
		for (final menu in [false, true]) {
			expect(tester.getSemantics(inEntry(menu, 'Shared')).hasFlag(SemanticsFlag.isEnabled), isFalse);
		}
		await tester.tap(inEntry(true, 'Shared'));
		await tester.pump();
		expect(calls, 1);
		await tester.tap(inEntry(true, 'Independent'));
		await tester.pump();
		expect(results.single.commandId, 'a');
		pending.complete(context);
		await tester.pump();
		expect(results.last.value, same(context));
		for (final menu in [false, true]) {
			expect(tester.getSemantics(inEntry(menu, 'Shared')).hasFlag(SemanticsFlag.isEnabled), isTrue);
		}
	});

	for (final menu in [false, true]) {
		final name = menu ? 'menu' : 'toolbar';
		testWidgets('$name shares metadata, item order, toggle and current gates', (tester) async {
			final semantics = tester.ensureSemantics();
			addTearDown(semantics.dispose);
			final registry = KlpCommandRegistry<_Context>();
			addTearDown(registry.dispose);
			var context = _Context();
			final results = <KlpCommandExecutionResult>[];
			var calls = 0;
			registry.register(KlpCommandDefinition<_Context>(
				id: 'z', label: 'Toggle', description: 'Toggle description',
				handler: (value) { calls++; return value; },
				isVisible: (value) => value.visible,
				isEnabled: (value) => value.enabled,
				isChecked: (value) => value.checked,
			));
			final unregister = registry.register(KlpCommandDefinition<_Context>(id: 'a', label: 'Action', handler: (value) => value));
			registry.register(KlpCommandDefinition<_Context>(
				id: 'disabled', label: 'Disabled', handler: (value) { calls++; return value; },
				isEnabled: (value) => false,
			));
			registry.register(KlpCommandDefinition<_Context>(
				id: 'hidden', label: 'Hidden', handler: (value) { calls++; return value; },
				isVisible: (value) => false,
			));
			registry.register(KlpCommandDefinition<_Context>(
				id: 'broken', label: 'Broken', handler: (value) { calls++; return value; },
				isEnabled: (value) => throw StateError('condition'),
			));
			await tester.pumpWidget(_app(_entry(menu: menu, registry: registry, getContext: () => context, onResult: results.add)));
			expect(_semanticOrder(tester, {'Toggle', 'Action', 'Disabled'}), ['Toggle', 'Action', 'Disabled']);
			expect(_row('Hidden'), findsNothing);
			expect(_row('Broken'), findsNothing);
			expect(_flag(tester, 'Disabled', SemanticsFlag.isEnabled), isFalse);
			expect(_flag(tester, 'Toggle', SemanticsFlag.hasCheckedState), isTrue);
			expect(_flag(tester, 'Toggle', SemanticsFlag.isChecked), isFalse);
			expect(_flag(tester, 'Action', SemanticsFlag.hasCheckedState), isFalse);
			if (menu) expect(find.text('Toggle description'), findsOneWidget);
			await _tap(tester, 'Disabled');
			expect(calls, 0);
			// 未 rebuild 的 context 切換也必須在 activation 重新讀取。
			context = _Context()..enabled = false;
			await _tap(tester, 'Toggle');
			expect(calls, 0);
			expect(results.every((result) => result.status != KlpCommandExecutionStatus.executed), isTrue);
			context = _Context()..checked = true;
			registry.refresh();
			await tester.pump();
			expect(_flag(tester, 'Toggle', SemanticsFlag.isChecked), isTrue);
			await _tap(tester, 'Toggle');
			expect(calls, 1);
			expect(results.last.value, same(context));
			context.visible = false;
			registry.refresh();
			await tester.pump();
			expect(_row('Toggle'), findsNothing);
			unregister();
			await tester.pump();
			expect(_row('Action'), findsNothing);
			registry.dispose();
			await tester.pump();
			expect(_row('Disabled'), findsNothing);
			expect(tester.takeException(), isNull);
		});

		testWidgets('$name preserves original async result, latest callback and independent commands', (tester) async {
			final semantics = tester.ensureSemantics();
			addTearDown(semantics.dispose);
			final registry = KlpCommandRegistry<_Context>();
			addTearDown(registry.dispose);
			var context = _Context();
			final pending = Completer<Object?>();
			final first = <KlpCommandExecutionResult>[];
			final latest = <KlpCommandExecutionResult>[];
			var calls = 0;
			registry.register(KlpCommandDefinition<_Context>(id: 'z', label: 'Slow', handler: (value) { calls++; return pending.future; }));
			registry.register(KlpCommandDefinition<_Context>(id: 'a', label: 'Other', handler: (value) => value));
			await tester.pumpWidget(_app(_entry(menu: menu, registry: registry, getContext: () => context, onResult: first.add)));
			await _tap(tester, 'Slow');
			expect(_flag(tester, 'Slow', SemanticsFlag.isEnabled), isFalse);
			await _tap(tester, 'Slow');
			expect(calls, 1);
			context = _Context();
			await tester.pumpWidget(_app(_entry(menu: menu, registry: registry, getContext: () => context, onResult: latest.add)));
			await _tap(tester, 'Other');
			expect(latest.single.value, same(context));
			final value = <String>[];
			pending.complete(value);
			await tester.pump();
			expect(first, isEmpty);
			expect(latest.last.commandId, 'z');
			expect(latest.last.status, KlpCommandExecutionStatus.executed);
			expect(latest.last.value, same(value));
			value.add('mutable');
			expect(latest.last.value, ['mutable']);
			expect(_flag(tester, 'Slow', SemanticsFlag.isEnabled), isTrue);
		});

		for (final lifecycle in ['unregister', 'unmount', 'replacement']) {
			testWidgets('$name isolates pending completion after $lifecycle', (tester) async {
				final registry = KlpCommandRegistry<_Context>();
				final replacement = KlpCommandRegistry<_Context>();
				addTearDown(registry.dispose);
				addTearDown(replacement.dispose);
				final context = _Context();
				final pending = Completer<Object?>();
				final error = StateError('original error');
				final results = <KlpCommandExecutionResult>[];
				final unregister = registry.register(KlpCommandDefinition<_Context>(id: 'z', label: 'Slow', handler: (value) => pending.future));
				await tester.pumpWidget(_app(_entry(menu: menu, registry: registry, getContext: () => context, onResult: results.add)));
				await _tap(tester, 'Slow');
				if (lifecycle == 'unregister') {
					unregister();
					await tester.pump();
				} else if (lifecycle == 'unmount') {
					await tester.pumpWidget(_app(const SizedBox()));
				} else {
					await tester.pumpWidget(_app(_entry(menu: menu, registry: replacement, getContext: () => context, onResult: results.add)));
				}
				pending.completeError(error);
				await tester.pump();
				if (lifecycle == 'unregister') {
					expect(results.single.commandId, 'z');
					expect(results.single.status, KlpCommandExecutionStatus.error);
					expect(results.single.error, same(error));
					expect(results.single.phase, KlpCommandErrorPhase.handler);
				} else {
					expect(results, isEmpty);
				}
				expect(tester.takeException(), isNull);
			});
		}

		testWidgets('$name keyboard wraps enabled items and activates only key down', (tester) async {
			final semantics = tester.ensureSemantics();
			addTearDown(semantics.dispose);
			final registry = KlpCommandRegistry<_Context>();
			addTearDown(registry.dispose);
			final context = _Context();
			final results = <KlpCommandExecutionResult>[];
			var dismissed = 0;
			for (final id in ['z', 'a', 'disabled']) {
				registry.register(KlpCommandDefinition<_Context>(
					id: id, label: id, handler: (value) => id,
					isEnabled: (value) => id != 'disabled',
				));
			}
			await tester.pumpWidget(_app(_entry(
				menu: menu, registry: registry, getContext: () => context,
				onResult: results.add, onDismiss: () => dismissed++,
			)));
			await _tap(tester, 'z');
			results.clear();
			final forward = menu ? LogicalKeyboardKey.arrowDown : LogicalKeyboardKey.arrowRight;
			final backward = menu ? LogicalKeyboardKey.arrowUp : LogicalKeyboardKey.arrowLeft;
			await tester.sendKeyEvent(forward);
			await tester.pump();
			_focused(tester, 'a');
			await tester.sendKeyEvent(forward);
			await tester.pump();
			_focused(tester, 'z');
			await tester.sendKeyEvent(backward);
			await tester.pump();
			_focused(tester, 'a');
			await tester.sendKeyEvent(LogicalKeyboardKey.home);
			await tester.pump();
			_focused(tester, 'z');
			await tester.sendKeyEvent(LogicalKeyboardKey.end);
			await tester.pump();
			_focused(tester, 'a');
			for (final key in [LogicalKeyboardKey.enter, LogicalKeyboardKey.space]) {
				await tester.sendKeyDownEvent(key);
				await tester.pump();
				await tester.sendKeyRepeatEvent(key);
				await tester.pump();
				await tester.sendKeyUpEvent(key);
				await tester.pump();
			}
			expect(results.map((result) => result.commandId), ['a', 'a']);
			await tester.sendKeyEvent(LogicalKeyboardKey.escape);
			await tester.pump();
			expect(dismissed, menu ? 1 : 0);
		});

		testWidgets('$name rejects blank labels and invalid references before interaction', (tester) async {
			final registry = KlpCommandRegistry<_Context>();
			addTearDown(registry.dispose);
			final context = _Context();
			for (final items in [
				const [KlpCommandReference(commandId: ' \t')],
				const [KlpCommandReference(commandId: 'a'), KlpCommandReference(commandId: 'a')],
			]) {
				await tester.pumpWidget(_app(const SizedBox()));
				Object? error;
				try {
					await tester.pumpWidget(_app(_entry(menu: menu, registry: registry, getContext: () => context, onResult: (_) {}, items: items)));
					error = tester.takeException();
				} catch (caught) { error = caught; }
				expect(error, isArgumentError);
			}
			for (final invalidEmpty in [false, if (menu) true]) {
				await tester.pumpWidget(_app(const SizedBox()));
				Object? error;
				try {
					await tester.pumpWidget(_app(_entry(
						menu: menu, registry: registry, getContext: () => context,
						onResult: (_) {}, label: invalidEmpty ? 'Commands' : ' \t',
						emptyLabel: invalidEmpty ? '\n' : 'Empty',
					)));
					error = tester.takeException();
				} catch (caught) { error = caught; }
				expect(error, isArgumentError);
			}
		});

		testWidgets('$name remains valid in a finite host with many long labels', (tester) async {
			final registry = KlpCommandRegistry<_Context>();
			addTearDown(registry.dispose);
			final context = _Context();
			final items = <KlpCommandReference>[];
			for (var i = 0; i < 24; i++) {
				final id = 'item$i';
				items.add(KlpCommandReference(commandId: id));
				registry.register(KlpCommandDefinition<_Context>(id: id, label: 'Very long product command label $i', handler: (value) => null));
			}
			await tester.pumpWidget(_app(SizedBox(
				width: 180, height: 120,
				child: _entry(menu: menu, registry: registry, getContext: () => context, onResult: (_) {}, items: items),
			)));
			await tester.pump();
			expect(tester.takeException(), isNull);
		});
	}

	for (final autoFocus in [false, true]) {
		for (final empty in [false, true]) {
			testWidgets('menu autofocus=$autoFocus empty=$empty honors host focus', (tester) async {
				final semantics = tester.ensureSemantics();
				addTearDown(semantics.dispose);
				final registry = KlpCommandRegistry<_Context>();
				addTearDown(registry.dispose);
				final context = _Context();
				final hostFocus = FocusNode();
				addTearDown(hostFocus.dispose);
				await tester.pumpWidget(_app(Column(children: [Focus(focusNode: hostFocus, child: const Text('Host')), const SizedBox()])));
				hostFocus.requestFocus();
				await tester.pump();
				if (!empty) registry.register(KlpCommandDefinition<_Context>(id: 'a', label: 'Available', handler: (value) => value));
				var dismissed = 0;
				final results = <KlpCommandExecutionResult>[];
				await tester.pumpWidget(_app(Column(children: [
					Focus(focusNode: hostFocus, child: const Text('Host')),
					_entry(
						menu: true, registry: registry, getContext: () => context,
						onResult: results.add, autoFocus: autoFocus, onDismiss: () => dismissed++,
					),
				])));
				await tester.pump();
				expect(hostFocus.hasFocus, !autoFocus);
				if (empty) {
					expect(find.text('Nothing available'), findsOneWidget);
					for (final key in [LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.home, LogicalKeyboardKey.enter, LogicalKeyboardKey.space]) {
						await tester.sendKeyEvent(key);
					}
					await tester.pump();
					expect(results, isEmpty);
				} else if (autoFocus) {
					_focused(tester, 'Available');
				}
				if (autoFocus) {
					await tester.sendKeyEvent(LogicalKeyboardKey.escape);
					await tester.pump();
					expect(dismissed, 1);
				}
				expect(tester.takeException(), isNull);
			});
		}
	}
}


