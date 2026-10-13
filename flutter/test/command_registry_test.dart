import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 產品自行擁有可變 context；registry 不得保存或複製其狀態。
class _Context {
	bool visible = true;
	bool enabled = true;
	bool checked = false;
	final List<String> values = [];
}

KlpCommandDefinition<_Context> _command(
	String id, {
	FutureOr<Object?> Function(_Context)? handler,
}) => KlpCommandDefinition<_Context>(
	id: id,
	label: id,
	handler: handler ?? (context) => context,
);

void _result(
	KlpCommandExecutionResult result,
	String id,
	KlpCommandExecutionStatus status,
) {
	expect(result.commandId, id);
	expect(result.status.name, status.name);
	if (status != KlpCommandExecutionStatus.executed) expect(result.value, isNull);
	if (status != KlpCommandExecutionStatus.error) {
		expect(result.error, isNull);
		expect(result.phase, isNull);
	}
}

void main() {
	test('metadata validation is atomic and preserves caller strings and keywords', () {
		final registry = KlpCommandRegistry<_Context>();
		addTearDown(registry.dispose);
		final context = _Context();
		var notifications = 0;
		registry.subscribe(() => notifications++);
		final invalid = <KlpCommandDefinition<_Context>>[
			_command(' \t'),
			KlpCommandDefinition(id: 'x', label: '\n', handler: (context) => null),
			KlpCommandDefinition(id: 'x', label: 'x', description: ' ', handler: (context) => null),
			KlpCommandDefinition(id: 'x', label: 'x', category: '\t', handler: (context) => null),
			KlpCommandDefinition(id: 'x', label: 'x', keywords: ['valid', ' '], handler: (context) => null),
		];
		for (final definition in invalid) {
			expect(() => registry.register(definition), throwsArgumentError);
			expect(registry.version, 0);
			expect(notifications, 0);
			expect(registry.list(context), isEmpty);
		}
		final keywords = [' key '];
		registry.register(KlpCommandDefinition<_Context>(
			id: ' x ', label: ' label ', description: ' desc ', category: ' cat ',
			keywords: keywords, handler: (context) => context,
		));
		keywords.add('caller');
		keywords[0] = 'changed';
		final state = registry.getState(' x ', context)!;
		expect([state.id, state.label, state.description, state.category], [' x ', ' label ', ' desc ', ' cat ']);
		expect(state.keywords, [' key ']);
		expect(registry.getState('x', context), isNull);
		expect(() => registry.register(_command(' x ')), throwsArgumentError);
		expect(registry.version, 1);
		expect(notifications, 1);
		expect(registry.getState(' x ', context)!.label, ' label ');
	});

	test('latest generic context and closures determine all conditions', () async {
		final registry = KlpCommandRegistry<_Context>();
		addTearDown(registry.dispose);
		final first = _Context();
		final latest = _Context()..visible = false;
		var external = true;
		registry.register(KlpCommandDefinition<_Context>(
			id: 'conditional', label: 'Conditional', handler: (context) => context,
			isVisible: (context) => context.visible,
			isEnabled: (context) => context.enabled && external,
			isChecked: (context) => context.checked,
		));
		final before = registry.getState('conditional', first)!;
		expect([before.visible, before.enabled, before.checked, before.running], [true, true, false, false]);
		latest.enabled = false;
		latest.checked = true;
		final after = registry.getState('conditional', latest)!;
		expect([after.visible, after.enabled, after.checked], [false, false, true]);
		expect(before.visible, isTrue);
		external = false;
		registry.refresh();
		expect(registry.getState('conditional', first)!.enabled, isFalse);
		external = true;
		latest.visible = true;
		latest.enabled = true;
		final result = await registry.execute('conditional', latest);
		_result(result, 'conditional', KlpCommandExecutionStatus.executed);
		expect(result.value, same(latest));
		latest.values.add('product remains mutable');
		expect((result.value as _Context).values, ['product remains mutable']);
	});

	test('lists use UTF16 id ordering and immutable diagnostic snapshots', () {
		final registry = KlpCommandRegistry<_Context>();
		addTearDown(registry.dispose);
		final context = _Context();
		for (final id in ['\uE000', 'z', '\u{10000}', 'a']) {
			registry.register(_command(id));
		}
		registry.register(KlpCommandDefinition<_Context>(
			id: 'hidden', label: 'hidden', keywords: ['one'], handler: (context) => null,
			isVisible: (context) => false,
		));
		final snapshot = registry.list(context);
		expect(snapshot.map((state) => state.id), ['a', 'hidden', 'z', '\u{10000}', '\uE000']);
		expect(snapshot[1].visible, isFalse);
		expect([snapshot[0].visible, snapshot[0].enabled, snapshot[0].checked], [true, true, false]);
		expect(() => snapshot.clear(), throwsUnsupportedError);
		expect(() => snapshot[1].keywords.add('two'), throwsUnsupportedError);
		registry.register(_command('new'));
		expect(snapshot.length, 5);
	});

	test('registration disposer owns its token across ID reuse', () {
		final registry = KlpCommandRegistry<_Context>();
		addTearDown(registry.dispose);
		final context = _Context();
		final old = registry.register(_command('same'));
		old();
		final current = registry.register(_command('same'));
		final version = registry.version;
		old();
		expect(registry.version, version);
		expect(registry.getState('same', context), isNotNull);
		current();
		current();
		expect(registry.version, version + 1);
		expect(registry.list(context), isEmpty);
	});

	test('invalid IDs and missing hidden disabled gates never call handler', () async {
		final registry = KlpCommandRegistry<_Context>();
		addTearDown(registry.dispose);
		final context = _Context();
		var calls = 0;
		var notifications = 0;
		registry.subscribe(() => notifications++);
		registry.register(KlpCommandDefinition<_Context>(
			id: 'gated', label: 'gated', handler: (context) { calls++; return null; },
			isVisible: (context) => context.visible, isEnabled: (context) => context.enabled,
		));
		expect(() => registry.getState(' ', context), throwsArgumentError);
		await expectLater(() => registry.execute(' ', context), throwsArgumentError);
		final version = registry.version;
		_result(await registry.execute('absent', context), 'absent', KlpCommandExecutionStatus.missing);
		context.visible = false;
		context.enabled = false;
		_result(await registry.execute('gated', context), 'gated', KlpCommandExecutionStatus.hidden);
		context.visible = true;
		_result(await registry.execute('gated', context), 'gated', KlpCommandExecutionStatus.disabled);
		expect(calls, 0);
		expect(registry.version, version);
		expect(notifications, 1);
	});

	for (final predicate in ['visible', 'enabled', 'checked']) {
		test('$predicate errors preserve the original error in state and execution', () async {
			final registry = KlpCommandRegistry<_Context>();
			addTearDown(registry.dispose);
			final context = _Context();
			final error = Object();
			var calls = 0;
			bool condition(_Context context) => throw error;
			registry.register(KlpCommandDefinition<_Context>(
				id: 'error', label: 'error', handler: (context) { calls++; return null; },
				isVisible: predicate == 'visible' ? condition : null,
				isEnabled: predicate == 'enabled' ? condition : null,
				isChecked: predicate == 'checked' ? condition : null,
			));
			final state = registry.getState('error', context)!;
			expect([state.visible, state.enabled, state.checked], [false, false, false]);
			expect(state.conditionError!.error, same(error));
			expect(registry.list(context).single.conditionError!.error, same(error));
			final version = registry.version;
			final result = await registry.execute('error', context);
			_result(result, 'error', KlpCommandExecutionStatus.error);
			expect(result.phase?.name, 'condition');
			expect(result.error, same(error));
			expect(calls, 0);
			expect(registry.version, version);
		});
	}

	test('sync and Future handlers retain original values and errors', () async {
		final registry = KlpCommandRegistry<_Context>();
		addTearDown(registry.dispose);
		final context = _Context();
		final value = <String>[];
		final syncError = Object();
		final futureError = Object();
		registry.register(_command('sync', handler: (context) => value));
		registry.register(_command('future', handler: (context) async => value));
		registry.register(_command('syncError', handler: (context) => throw syncError));
		registry.register(_command('futureError', handler: (context) => Future<Object?>.error(futureError)));
		for (final id in ['sync', 'future']) {
			final result = await registry.execute(id, context);
			_result(result, id, KlpCommandExecutionStatus.executed);
			expect(result.value, same(value));
		}
		value.add('mutable');
		for (final entry in {'syncError': syncError, 'futureError': futureError}.entries) {
			final result = await registry.execute(entry.key, context);
			_result(result, entry.key, KlpCommandExecutionStatus.error);
			expect(result.error, same(entry.value));
			expect(result.phase?.name, 'handler');
			expect(registry.getState(entry.key, context)!.running, isFalse);
		}
	});

	test('pending gates recheck conditions, preserve running diagnostics and allow other commands', () async {
		final registry = KlpCommandRegistry<_Context>();
		addTearDown(registry.dispose);
		final context = _Context();
		final first = Completer<Object?>();
		final second = Completer<Object?>();
		final conditionError = Object();
		var failCondition = false;
		var calls = 0;
		registry.register(KlpCommandDefinition<_Context>(
			id: 'first', label: 'first', handler: (context) { calls++; return first.future; },
			isVisible: (context) => failCondition ? throw conditionError : context.visible,
			isEnabled: (context) => context.enabled,
		));
		registry.register(_command('second', handler: (context) => second.future));
		final pending = registry.execute('first', context);
		expect(registry.getState('first', context)!.running, isTrue);
		final version = registry.version;
		_result(await registry.execute('first', context), 'first', KlpCommandExecutionStatus.busy);
		context.visible = false;
		_result(await registry.execute('first', context), 'first', KlpCommandExecutionStatus.hidden);
		context.visible = true;
		context.enabled = false;
		_result(await registry.execute('first', context), 'first', KlpCommandExecutionStatus.disabled);
		failCondition = true;
		final diagnostic = registry.getState('first', context)!;
		expect(diagnostic.running, isTrue);
		expect(diagnostic.conditionError!.error, same(conditionError));
		final error = await registry.execute('first', context);
		expect(error.phase?.name, 'condition');
		expect(error.error, same(conditionError));
		expect(registry.version, version);
		final other = registry.execute('second', context);
		expect(registry.getState('second', context)!.running, isTrue);
		second.complete('second');
		expect((await other).value, 'second');
		expect(registry.getState('first', context)!.running, isTrue);
		first.complete('first');
		expect((await pending).value, 'first');
		expect(calls, 1);
		expect(registry.getState('first', context)!.running, isFalse);
	});

	for (final transition in ['remove', 'replace', 'dispose']) {
		test('pending $transition retains product result without stale notifications', () async {
			final registry = KlpCommandRegistry<_Context>();
			addTearDown(registry.dispose);
			final context = _Context();
			final old = Completer<Object?>();
			final current = Completer<Object?>();
			var notifications = 0;
			registry.subscribe(() => notifications++);
			final remove = registry.register(_command('same', handler: (context) => old.future));
			final pending = registry.execute('same', context);
			Future<KlpCommandExecutionResult>? replacement;
			if (transition == 'dispose') {
				registry.dispose();
			} else {
				remove();
				if (transition == 'replace') {
					registry.register(_command('same', handler: (context) => current.future));
					replacement = registry.execute('same', context);
				}
			}
			final version = registry.version;
			final count = notifications;
			final value = Object();
			old.complete(value);
			final result = await pending;
			_result(result, 'same', KlpCommandExecutionStatus.executed);
			expect(result.value, same(value));
			expect(registry.version, version);
			expect(notifications, count);
			if (replacement != null) {
				expect(registry.getState('same', context)!.running, isTrue);
				current.complete('replacement');
				expect((await replacement).value, 'replacement');
				expect(registry.getState('same', context)!.running, isFalse);
			} else {
				expect(registry.getState('same', context), isNull);
			}
		});
	}

	for (final transition in ['remove', 'replace', 'dispose']) {
		test('start observer $transition prevents an obsolete handler from starting', () async {
			final registry = KlpCommandRegistry<_Context>();
			addTearDown(registry.dispose);
			final context = _Context();
			var oldCalls = 0;
			var currentCalls = 0;
			var acted = false;
			final remove = registry.register(_command('same', handler: (context) { oldCalls++; return null; }));
			registry.subscribe(() {
				if (acted || registry.getState('same', context)?.running != true) return;
				acted = true;
				if (transition == 'dispose') {
					registry.dispose();
				} else {
					remove();
					if (transition == 'replace') {
						registry.register(_command('same', handler: (context) { currentCalls++; return null; }));
					}
				}
			});
			final result = await registry.execute('same', context);
			_result(result, 'same', transition == 'dispose' ? KlpCommandExecutionStatus.disposed : KlpCommandExecutionStatus.missing);
			expect(oldCalls, 0);
			expect(currentCalls, 0);
			if (transition == 'replace') {
				expect(registry.getState('same', context)!.running, isFalse);
				_result(await registry.execute('same', context), 'same', KlpCommandExecutionStatus.executed);
				expect(currentCalls, 1);
			}
		});
	}

	test('observer FlutterError is isolated from handler results and running cleanup', () async {
		final registry = KlpCommandRegistry<_Context>();
		addTearDown(registry.dispose);
		final previous = FlutterError.onError;
		final reports = <FlutterErrorDetails>[];
		FlutterError.onError = reports.add;
		addTearDown(() => FlutterError.onError = previous);
		final error = Object();
		final pendingValue = Completer<Object?>();
		registry.register(_command('work', handler: (context) => pendingValue.future));
		var healthy = 0;
		final unsubscribe = registry.subscribe(() => throw error);
		registry.addListener(() => healthy++);
		final context = _Context();
		final pending = registry.execute('work', context);
		pendingValue.complete('value');
		final result = await pending;
		_result(result, 'work', KlpCommandExecutionStatus.executed);
		expect(result.value, 'value');
		expect(registry.getState('work', context)!.running, isFalse);
		expect(healthy, 2);
		expect(reports.length, 2);
		expect(reports.every((report) => identical(report.exception, error)), isTrue);
		unsubscribe();
		final businessError = Object();
		registry.register(_command('business', handler: (context) => throw businessError));
		final failure = await registry.execute('business', context);
		expect(failure.error, same(businessError));
		expect(failure.phase?.name, 'handler');
		expect(reports.length, 2);
	});

	test('native listeners and duplicate subscriptions have independent owners', () {
		final registry = _ListenerInspectableRegistry<_Context>();
		addTearDown(registry.dispose);
		var calls = 0;
		void listener() => calls++;
		registry.addListener(listener);
		registry.addListener(listener);
		final first = registry.subscribe(listener);
		final second = registry.subscribe(listener);
		expect(registry.hasRegisteredListeners, isTrue);
		registry.refresh();
		expect(calls, 4);
		first();
		first();
		registry.removeListener(listener);
		registry.refresh();
		expect(calls, 6);
		second();
		registry.removeListener(listener);
		expect(registry.hasRegisteredListeners, isFalse);
		registry.refresh();
		expect(calls, 6);
	});

	for (final order in ['subscribe-first', 'native-first', 'subscribe-only']) {
		test('removeListener cannot remove subscription owner: $order', () {
			final registry = _ListenerInspectableRegistry<_Context>();
			addTearDown(registry.dispose);
			var calls = 0;
			void listener() => calls++;
			if (order == 'native-first') registry.addListener(listener);
			final unsubscribe = registry.subscribe(listener);
			if (order == 'subscribe-first') registry.addListener(listener);
			registry.refresh();
			final initial = order == 'subscribe-only' ? 1 : 2;
			expect(calls, initial);
			registry.removeListener(listener);
			registry.removeListener(listener);
			registry.refresh();
			expect(calls, initial + 1);
			expect(registry.hasRegisteredListeners, isTrue);
			unsubscribe();
			expect(registry.hasRegisteredListeners, isFalse);
			registry.refresh();
			expect(calls, initial + 1);
		});
	}

	test('version and notifications reflect each lifecycle transition once', () async {
		final registry = KlpCommandRegistry<_Context>();
		final context = _Context();
		final pendingValue = Completer<Object?>();
		final observed = <int>[];
		registry.subscribe(() => observed.add(registry.version));
		expect(registry.version, 0);
		final remove = registry.register(_command('work', handler: (context) => pendingValue.future));
		final pending = registry.execute('work', context);
		pendingValue.complete(null);
		final result = await pending;
		_result(result, 'work', KlpCommandExecutionStatus.executed);
		expect(result.value, isNull);
		registry.refresh();
		remove();
		remove();
		await registry.execute('work', context);
		registry.dispose();
		registry.dispose();
		expect(observed, [1, 2, 3, 4, 5, 6]);
		expect(registry.version, 6);
	});

	test('dispose final notification observes closed state and rejects later mutations', () async {
		final registry = _ListenerInspectableRegistry<_Context>();
		final context = _Context();
		final remove = registry.register(_command('work'));
		var finals = 0;
		final unsubscribe = registry.subscribe(() {
			finals++;
			expect(registry.isDisposed, isTrue);
			expect(registry.getState('work', context), isNull);
			expect(registry.list(context), isEmpty);
		});
		registry.dispose();
		expect(finals, 1);
		expect(registry.hasRegisteredListeners, isFalse);
		expect(() => registry.register(_command('new')), throwsStateError);
		expect(() => registry.subscribe(() {}), throwsStateError);
		expect(() => registry.addListener(() {}), throwsStateError);
		expect(registry.refresh, throwsStateError);
		registry.removeListener(() {});
		remove();
		unsubscribe();
		registry.dispose();
		_result(await registry.execute('work', context), 'work', KlpCommandExecutionStatus.disposed);
		expect(finals, 1);
		expect(registry.version, 2);
	});

	test('dispose inside a native notification is legal and immediately closes registry', () {
		final registry = _ListenerInspectableRegistry<_Context>();
		final context = _Context();
		final previous = FlutterError.onError;
		final reports = <FlutterErrorDetails>[];
		FlutterError.onError = reports.add;
		addTearDown(() => FlutterError.onError = previous);
		var didDispose = false;
		var sawFinal = false;
		registry.addListener(() {
			if (registry.isDisposed) { sawFinal = true; return; }
			if (!didDispose) { didDispose = true; registry.dispose(); }
		});
		registry.register(_command('work'));
		expect(didDispose, isTrue);
		expect(sawFinal, isTrue);
		expect(registry.isDisposed, isTrue);
		expect(registry.list(context), isEmpty);
		expect(registry.hasRegisteredListeners, isFalse);
		expect(registry.version, 2);
		expect(reports, isEmpty);
		registry.dispose();
	});
}

// 透過子類別合法觀察相同的 listener ownership，不改變通知或清理行為。
class _ListenerInspectableRegistry<C> extends KlpCommandRegistry<C> {
	bool get hasRegisteredListeners => super.hasListeners;
}
