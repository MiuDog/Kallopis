import 'dart:async';
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 測試資料與宿主只屬於本檔；不引用元件的私有狀態或節點。
class _Context {
	bool visible = true;
	bool enabled = true;
}

class _Host {
	KlpCommandRegistry<_Context> registry = KlpCommandRegistry<_Context>();
	_Context context = _Context();
	bool open = true;
	bool mounted = true;
	int reads = 0;
	final results = <KlpCommandExecutionResult>[];
	final dismissals = <KlpCommandDismissReason>[];
	ValueChanged<KlpCommandExecutionResult>? callback;
	ThemeData theme = buildKlpTheme(Brightness.light);
	final originalFocus = FocusNode();
	final externalFocus = FocusNode();
	final background = TextEditingController.fromValue(const TextEditingValue(
		text: 'product original text',
		selection: TextSelection(baseOffset: 2, extentOffset: 7),
	));

	void dispose() {
		registry.dispose();
		originalFocus.dispose();
		externalFocus.dispose();
		background.dispose();
	}

	Widget build() => MaterialApp(
		theme: buildKlpTheme(Brightness.light),
		home: Scaffold(body: Theme(
			data: theme,
			// 宿主佔滿 viewport，避免宿主本身的零尺寸影響 overlay 原生語意。
			child: SizedBox.expand(child: Stack(children: [
				Positioned(
					top: 0, left: 0,
					width: 300, height: 60,
					child: TextField(
					key: const ValueKey('background'),
					focusNode: originalFocus,
					controller: background,
					),
				),
				Positioned(
					top: 60, left: 0,
					child: Focus(focusNode: externalFocus, child: const Text('External')),
				),
				if (mounted) KlpRegisteredCommandPalette<_Context>(
					registry: registry,
					getContext: () { reads++; return context; },
					open: open,
					label: 'Product commands',
					searchLabel: 'Search commands',
					emptyLabel: 'No matching command',
					onResult: (result) => (callback ?? results.add)(result),
					onDismiss: dismissals.add,
				),
			])),
		)),
	);
}

Future<void> _frames(WidgetTester tester) async {
	// Future 完成與原生焦點／語意排程允許各自推進 frame。
	await tester.pump();
	await tester.pump();
}

Future<void> _show(WidgetTester tester, _Host host) async {
	await tester.pumpWidget(host.build());
	await _frames(tester);
}

Finder _row(String label) => find.bySemanticsLabel(label);

Finder _input() => find.byWidgetPredicate(
	(widget) => widget is EditableText && widget.focusNode.hasFocus,
);

EditableText _editing(WidgetTester tester) => tester.widget<EditableText>(_input());

Future<void> _query(WidgetTester tester, String value) async {
	await tester.enterText(_input(), value);
	await _frames(tester);
}

Future<void> _queryValue(WidgetTester tester, String value) async {
	// 單行 EditableText 會過濾 LF；完整分詞契約從公開 controller／onChanged 邊界注入。
	final input = _editing(tester);
	input.controller.value = TextEditingValue(
		text: value,
		selection: TextSelection.collapsed(offset: value.length),
	);
	input.onChanged?.call(value);
	await _frames(tester);
}

Future<void> _tap(WidgetTester tester, String label) async {
	await tester.tap(_row(label));
	await _frames(tester);
}

bool _flag(WidgetTester tester, String label, SemanticsFlag flag) {
	final flags = tester.getSemantics(_row(label)).flagsCollection;
	return switch (flag) {
		SemanticsFlag.isEnabled => flags.isEnabled == Tristate.isTrue,
		SemanticsFlag.isSelected => flags.isSelected == Tristate.isTrue,
		_ => throw ArgumentError.value(flag, 'flag', '未定義的測試旗標'),
	};
}

List<String> _order(WidgetTester tester, Set<String> labels) {
	final found = <String>[];
	void visit(SemanticsNode node) {
		if (labels.contains(node.label)) found.add(node.label);
		for (final child in node.debugListChildrenInOrder(DebugSemanticsDumpOrder.traversalOrder)) {
			visit(child);
		}
	}
	// 原生多 View 的語意 root 屬於該 RenderView owner，舊 pipelineOwner 可是空樹。
	final view = tester.binding.renderViews.singleWhere((view) => view.flutterView == tester.view);
	visit(view.owner!.semanticsOwner!.rootSemanticsNode!);
	return found;
}

void _test(String name, Future<void> Function(WidgetTester, _Host) body) {
	testWidgets(name, (tester) async {
		final semantics = tester.ensureSemantics();
		final host = _Host();
		try {
			await body(tester, host);
		} finally {
			try {
				await tester.pumpWidget(const SizedBox());
				await _frames(tester);
			} finally {
				host.dispose();
				semantics.dispose();
			}
		}
	});
}

void _command(_Host host, String id, String label, {
	FutureOr<Object?> Function(_Context)? handler,
	String? description,
	String? category,
	List<String> keywords = const [],
	bool enabled = true,
	bool visible = true,
}) {
	host.registry.register(KlpCommandDefinition<_Context>(
		id: id,
		label: label,
		handler: handler ?? (context) => context,
		description: description,
		category: category,
		keywords: keywords,
		isEnabled: (context) => enabled && context.enabled,
		isVisible: (context) => visible && context.visible,
	));
}

void main() {
	_test('closed host has no query or focus; every label rejects whitespace', (tester, host) async {
		host.open = false;
		_command(host, 'a', 'Available');
		await _show(tester, host);
		expect(host.reads, 0);
		expect(_row('Available'), findsNothing);
		expect(find.byType(KlpTextField), findsNothing);
		for (final invalid in ['label', 'searchLabel', 'emptyLabel']) {
			await tester.pumpWidget(const SizedBox());
			Object? error;
			try {
				// const 公開建構子允許建立 widget；驗證在原生掛載邊界觀察。
				await tester.pumpWidget(MaterialApp(home: KlpRegisteredCommandPalette<_Context>(
					registry: host.registry,
					getContext: () => host.context,
					open: false,
					label: invalid == 'label' ? ' \t\n' : 'Commands',
					searchLabel: invalid == 'searchLabel' ? ' \t\n' : 'Search',
					emptyLabel: invalid == 'emptyLabel' ? ' \t\n' : 'Empty',
					onResult: (_) {},
					onDismiss: (_) {},
				)));
				error = tester.takeException();
			} catch (caught) { error = caught; }
			expect(error, isArgumentError, reason: invalid);
		}
	});

	_test('all complete metadata fields and separate words participate in search', (tester, host) async {
		_command(host, 'identity', '中文筆記',
			description: 'Detailed explanation', category: 'Workspace',
			keywords: ['AliasOne', 'aliasTwo'],
		);
		_command(host, 'boundary', 'ab', category: 'cd');
		await _show(tester, host);
		for (final query in [
			'IDENTITY', '中文', '筆記', 'detailed', 'workspace',
			'aliasone', 'aliastwo', '中文 explanation workspace aliastwo',
		]) {
			await _query(tester, query);
			expect(_row('中文筆記'), findsOneWidget, reason: query);
		}
		await _query(tester, 'bc');
		expect(_row('ab'), findsNothing);
		expect(find.text('No matching command'), findsOneWidget);
	});

	_test('scores exact prefix substring subsequence and ties use UTF16 IDs', (tester, host) async {
		_command(host, 'z', 'abcd');
		_command(host, 'b', 'xxabcd');
		_command(host, 'a', 'a-b-c-d');
		_command(host, 'd', 'abcd longer');
		_command(host, 'c', 'Exact alias', keywords: ['abcd']);
		_command(host, '\uE000', 'BMP tie', keywords: ['abcd']);
		_command(host, '\u{10000}', 'Astral tie', keywords: ['abcd']);
		await _show(tester, host);
		final labels = {
			'abcd', 'xxabcd', 'a-b-c-d', 'abcd longer',
			'Exact alias', 'BMP tie', 'Astral tie',
		};
		expect(_order(tester, labels), [
			'a-b-c-d', 'xxabcd', 'Exact alias', 'abcd longer',
			'abcd', 'Astral tie', 'BMP tie',
		]);
		await _query(tester, 'abcd');
		expect(_order(tester, labels), [
			'Exact alias', 'abcd', 'Astral tie', 'BMP tie',
			'abcd longer', 'xxabcd', 'a-b-c-d',
		]);
	});

	_test('token separators are exactly ECMAScript whitespace and preserve U0085', (tester, host) async {
		_command(host, 'words', 'Target', keywords: ['one', 'two']);
		_command(host, 'nel', 'NEL literal', keywords: ['one\u0085two']);
		await _show(tester, host);
		final separators = [
			for (var code = 9; code <= 13; code++) code,
			0x20, 0xA0, 0x1680,
			for (var code = 0x2000; code <= 0x200A; code++) code,
			0x2028, 0x2029, 0x202F, 0x205F, 0x3000, 0xFEFF,
		];
		for (final code in separators) {
			final separator = String.fromCharCode(code);
			await _queryValue(tester, '${separator}one$separator${separator}two$separator');
			expect(_row('Target'), findsOneWidget, reason: 'U+${code.toRadixString(16)}');
		}
		await _query(tester, 'one\u0085two');
		expect(_row('Target'), findsNothing);
		expect(_row('NEL literal'), findsOneWidget);
		await _query(tester, '\u0085one two\u0085');
		expect(_row('Target'), findsNothing);
	});

	_test('word scores sum and all disabled results have no selected candidate', (tester, host) async {
		_command(host, 'a', 'Sum four', keywords: ['xxone', 'xxtwo']);
		_command(host, 'z', 'Sum three', keywords: ['one', 't-w-o']);
		await _show(tester, host);
		await _query(tester, 'one two');
		expect(_order(tester, {'Sum four', 'Sum three'}), ['Sum three', 'Sum four']);
		host.context.enabled = false;
		host.registry.refresh();
		await _frames(tester);
		for (final label in ['Sum three', 'Sum four']) {
			expect(_flag(tester, label, SemanticsFlag.isEnabled), isFalse);
			expect(_flag(tester, label, SemanticsFlag.isSelected), isFalse);
		}
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await _frames(tester);
		expect(host.results, isEmpty);
		host.context = _Context()..visible = false;
		await _query(tester, 'sum');
		expect(find.text('No matching command'), findsOneWidget);
	});

	_test('visibility disabled current context refresh registration and disposal', (tester, host) async {
		var calls = 0;
		_command(host, 'a', 'Available', handler: (context) { calls++; return context; });
		_command(host, 'd', 'Disabled', enabled: false);
		_command(host, 'h', 'Hidden', visible: false);
		await _show(tester, host);
		expect(_row('Hidden'), findsNothing);
		expect(_flag(tester, 'Disabled', SemanticsFlag.isEnabled), isFalse);
		await _tap(tester, 'Disabled');
		expect(calls, 0);
		host.context = _Context()..enabled = false;
		await _tap(tester, 'Available');
		expect(calls, 0);
		expect(host.dismissals, isEmpty);
		host.context = _Context();
		host.registry.refresh();
		await _frames(tester);
		await _tap(tester, 'Available');
		expect(host.results.last.value, same(host.context));
		expect(calls, 1);
		host.context.visible = false;
		host.registry.refresh();
		await _frames(tester);
		expect(_row('Available'), findsNothing);
		host.context.visible = true;
		final unregister = host.registry.register(KlpCommandDefinition<_Context>(
			id: 'new', label: 'New registration', handler: (_) => null,
		));
		await _frames(tester);
		expect(_row('New registration'), findsOneWidget);
		unregister();
		await _frames(tester);
		expect(_row('New registration'), findsNothing);
		host.registry.dispose();
		await _frames(tester);
		expect(find.text('No matching command'), findsOneWidget);
		expect(tester.takeException(), isNull);
	});

	_test('native input focus keyboard wraps usable candidates and Enter only once', (tester, host) async {
		var calls = 0;
		_command(host, 'a', 'Alpha', handler: (_) => ++calls);
		_command(host, 'b', 'Blocked', enabled: false);
		_command(host, 'c', 'Charlie', handler: (_) => ++calls);
		await _show(tester, host);
		expect(_editing(tester).focusNode.hasFocus, isTrue);
		expect(_flag(tester, 'Alpha', SemanticsFlag.isSelected), isTrue);
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
		await _frames(tester);
		expect(_flag(tester, 'Charlie', SemanticsFlag.isSelected), isTrue);
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
		await _frames(tester);
		expect(_flag(tester, 'Alpha', SemanticsFlag.isSelected), isTrue);
		await tester.sendKeyEvent(LogicalKeyboardKey.tab);
		await _frames(tester);
		expect(_editing(tester).focusNode.hasFocus, isTrue);
		await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
		await _frames(tester);
		await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter);
		await _frames(tester);
		await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
		expect(calls, 1);
		expect(host.results.single.commandId, 'a');
		expect(host.dismissals, [KlpCommandDismissReason.executed]);
		await _tap(tester, 'Charlie');
		expect(_editing(tester).focusNode.hasFocus, isTrue);
	});

	_test('composition does not activate navigate or dismiss and editing keys stay native', (tester, host) async {
		_command(host, 'a', 'abcd');
		_command(host, 'b', 'abcd second');
		await _show(tester, host);
		tester.testTextInput.updateEditingValue(const TextEditingValue(
			text: 'abcd', selection: TextSelection.collapsed(offset: 2),
			composing: TextRange(start: 0, end: 4),
		));
		await _frames(tester);
		for (final key in [
			LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.arrowUp,
			LogicalKeyboardKey.enter, LogicalKeyboardKey.escape,
		]) {
			await tester.sendKeyEvent(key);
			await _frames(tester);
		}
		expect(host.results, isEmpty);
		expect(host.dismissals, isEmpty);
		expect(_flag(tester, 'abcd', SemanticsFlag.isSelected), isTrue);
		tester.testTextInput.updateEditingValue(const TextEditingValue(
			text: 'abcd', selection: TextSelection.collapsed(offset: 2),
		));
		await _frames(tester);
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
		await _frames(tester);
		expect(_editing(tester).controller.selection.baseOffset, 1);
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
		await _frames(tester);
		expect(_editing(tester).controller.selection.baseOffset, 2);
		await tester.sendKeyEvent(LogicalKeyboardKey.home);
		await _frames(tester);
		expect(_editing(tester).controller.selection.baseOffset, 0);
		await tester.sendKeyEvent(LogicalKeyboardKey.end);
		await _frames(tester);
		expect(_editing(tester).controller.selection.baseOffset, 4);
		expect(_flag(tester, 'abcd', SemanticsFlag.isSelected), isTrue);
	});

	_test('controlled dismiss reasons do not independently close the overlay', (tester, host) async {
		_command(host, 'a', 'Available');
		await _show(tester, host);
		await tester.tap(_input());
		await _frames(tester);
		expect(host.dismissals, isEmpty);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await _frames(tester);
		expect(host.dismissals, [KlpCommandDismissReason.escape]);
		expect(_row('Available'), findsOneWidget);
		await tester.tapAt(const Offset(1, 599));
		await _frames(tester);
		expect(host.dismissals.last, KlpCommandDismissReason.outside);
		await _tap(tester, 'Available');
		expect(host.dismissals.last, KlpCommandDismissReason.executed);
		host.open = false;
		await _show(tester, host);
		expect(_row('Available'), findsNothing);
	});

	_test('query and selected ID survive theme size and registry refresh; reopening resets', (tester, host) async {
		_command(host, 'a', 'Shared alpha');
		_command(host, 'b', 'Shared beta');
		await _show(tester, host);
		await _query(tester, 'shared');
		await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
		await _frames(tester);
		host.registry.refresh();
		await _frames(tester);
		expect(_flag(tester, 'Shared beta', SemanticsFlag.isSelected), isTrue);
		host.theme = buildKlpTheme(Brightness.dark);
		await _show(tester, host);
		await tester.binding.setSurfaceSize(const Size(640, 420));
		addTearDown(() => tester.binding.setSurfaceSize(null));
		await _frames(tester);
		expect(_editing(tester).controller.text, 'shared');
		expect(_flag(tester, 'Shared beta', SemanticsFlag.isSelected), isTrue);
		final old = host.registry;
		host.registry = KlpCommandRegistry<_Context>();
		addTearDown(old.dispose);
		_command(host, 'b', 'Shared replacement');
		await _show(tester, host);
		expect(_editing(tester).controller.text, 'shared');
		expect(_row('Shared beta'), findsNothing);
		expect(_row('Shared replacement'), findsOneWidget);
		host.open = false;
		await _show(tester, host);
		host.open = true;
		await _show(tester, host);
		expect(_editing(tester).controller.text, isEmpty);
	});

	_test('running candidates are disabled but other commands and latest callbacks work', (tester, host) async {
		final pending = Completer<Object?>();
		final first = <KlpCommandExecutionResult>[];
		final latest = <KlpCommandExecutionResult>[];
		var calls = 0;
		_command(host, 'a', 'Slow', handler: (_) { calls++; return pending.future; });
		_command(host, 'b', 'Other');
		host.callback = first.add;
		await _show(tester, host);
		await _tap(tester, 'Slow');
		expect(_flag(tester, 'Slow', SemanticsFlag.isEnabled), isFalse);
		expect(_flag(tester, 'Other', SemanticsFlag.isSelected), isTrue);
		await _tap(tester, 'Slow');
		expect(calls, 1);
		host.callback = latest.add;
		host.context = _Context();
		await _show(tester, host);
		await _tap(tester, 'Other');
		expect(latest.single.value, same(host.context));
		final value = <String>[];
		pending.complete(value);
		await _frames(tester);
		expect(first, isEmpty);
		expect(latest.last.commandId, 'a');
		expect(latest.last.value, same(value));
		expect(_flag(tester, 'Slow', SemanticsFlag.isEnabled), isTrue);
	});

	_test('original handler errors stay open and callback throws remain retryable', (tester, host) async {
		final handlerError = StateError('original handler');
		final callbackError = StateError('original callback');
		var calls = 0;
		_command(host, 'a', 'Failure', handler: (_) => throw handlerError);
		_command(host, 'b', 'Retry', handler: (_) => ++calls);
		await _show(tester, host);
		await _tap(tester, 'Failure');
		expect(host.results.single.error, same(handlerError));
		expect(host.results.single.phase, KlpCommandErrorPhase.handler);
		expect(host.results.single.status, KlpCommandExecutionStatus.error);
		expect(host.dismissals, isEmpty);
		host.callback = (_) => throw callbackError;
		await _show(tester, host);
		for (var attempt = 1; attempt <= 2; attempt++) {
			await _tap(tester, 'Retry');
			expect(tester.takeException(), same(callbackError));
			expect(calls, attempt);
			expect(host.dismissals, isEmpty);
			expect(_flag(tester, 'Retry', SemanticsFlag.isEnabled), isTrue);
		}
	});

	for (final transition in ['close', 'unmount', 'reopen', 'replacement']) {
		_test('pending result does not affect another session after $transition', (tester, host) async {
			final pending = Completer<Object?>();
			var finished = false;
			_command(host, 'a', 'Slow', handler: (_) async {
				try {
					return await pending.future;
				} finally {
					finished = true;
				}
			});
			await _show(tester, host);
			await _tap(tester, 'Slow');
			if (transition == 'replacement') {
				final old = host.registry;
				addTearDown(old.dispose);
				host.registry = KlpCommandRegistry<_Context>();
				_command(host, 'a', 'New owner');
			} else if (transition == 'unmount') {
				host.mounted = false;
			} else {
				host.open = false;
			}
			await _show(tester, host);
			if (transition == 'reopen') {
				host.open = true;
				await _show(tester, host);
			}
			if (transition == 'close' || transition == 'replacement') {
				pending.completeError(StateError('stale original error'));
			} else {
				pending.complete(Object());
			}
			await _frames(tester);
			expect(finished, isTrue);
			expect(host.results, isEmpty);
			expect(host.dismissals, isEmpty);
			expect(tester.takeException(), isNull);
		});
	}

	for (final transition in ['close', 'unmount', 'replacement']) {
		_test('return focus and original selection survive $transition', (tester, host) async {
			host.open = false;
			_command(host, 'a', 'Available');
			await _show(tester, host);
			host.originalFocus.requestFocus();
			await _frames(tester);
			final original = host.background.value;
			host.open = true;
			await _show(tester, host);
			expect(host.originalFocus.hasFocus, isFalse);
			if (transition == 'replacement') {
				final old = host.registry;
				addTearDown(old.dispose);
				host.registry = KlpCommandRegistry<_Context>();
				_command(host, 'a', 'New owner');
				await _show(tester, host);
			}
			if (transition == 'unmount') {
				host.mounted = false;
			} else {
				host.open = false;
			}
			await _show(tester, host);
			expect(host.originalFocus.hasFocus, isTrue);
			expect(host.background.value, original);
		});
	}

	_test('callback external focus is preserved after controlled close', (tester, host) async {
		host.open = false;
		_command(host, 'a', 'Move focus');
		await _show(tester, host);
		host.originalFocus.requestFocus();
		await _frames(tester);
		host.open = true;
		host.callback = (_) {
			host.externalFocus.requestFocus();
			host.open = false;
		};
		await _show(tester, host);
		await _tap(tester, 'Move focus');
		await _show(tester, host);
		expect(host.externalFocus.hasFocus, isTrue);
		expect(host.originalFocus.hasFocus, isFalse);
		// 父層 callback 所改的 open 經原生 rebuild 後，不得再提出關閉意圖。
		final count = host.dismissals.length;
		await _frames(tester);
		expect(host.dismissals.length, count);
	});

	_test('overlay inherits calling theme updates and stays finite in tiny viewports', (tester, host) async {
		for (var index = 0; index < 16; index++) {
			_command(host, 'item$index', 'Long product command label $index');
		}
		await _show(tester, host);
		for (final brightness in [Brightness.dark, Brightness.light]) {
			final colors = brightness == Brightness.dark
				? KlpThemeData.dark.copyWith(overlay: const Color(0xFF123456))
				: KlpThemeData.light.copyWith(overlay: const Color(0xFF654321));
			host.theme = buildKlpTheme(brightness).copyWith(extensions: [
				...buildKlpTheme(brightness).extensions.values.where((extension) => extension is! KlpThemeData),
				colors,
			]);
			await _show(tester, host);
			expect(tester.element(_input()).klp.color.overlay, colors.overlay);
		}
		addTearDown(() => tester.binding.setSurfaceSize(null));
		for (final size in [
			const Size(180, 120), const Size(1, 1),
			const Size(0, 0), const Size(20, 800),
		]) {
			await tester.binding.setSurfaceSize(size);
			await _frames(tester);
			expect(tester.takeException(), isNull, reason: '$size');
		}
	});
}
