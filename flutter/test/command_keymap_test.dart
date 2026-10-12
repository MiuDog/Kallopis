import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 產品條件由當次 context 擁有，不在快捷鍵核心建立第二份權威。
class _Context {

	/* visible、enabled 控制同 registry 的 gate；allowed 控制 binding 的 when。
	 * 欄位可變，讓測試直接觀察每次 handle 是否重新查詢產品條件。
	 */
	bool visible = true;
	bool enabled = true;
	bool allowed = true;
}

void _command(KlpCommandRegistry<_Context> registry, String id, {FutureOr<Object?> Function(_Context)? handler}) {
	// 命令與 handler 僅註冊於產品 registry，keymap 只能經此公開入口執行。
	registry.register(KlpCommandDefinition<_Context>(
		id: id,
		label: id,
		handler: handler ?? (context) => context,
		isVisible: (context) => context.visible,
		isEnabled: (context) => context.enabled,
	));
}

KlpCommandKeymap<_Context> _keymap(KlpCommandRegistry<_Context> registry, {KlpShortcutPlatform platform = KlpShortcutPlatform.other, double Function()? now}) {
	final keymap = KlpCommandKeymap<_Context>(registry: registry, platform: platform, now: now);
	addTearDown(keymap.dispose);
	addTearDown(registry.dispose);
	return keymap;
}

KlpShortcutBinding<_Context> _binding(
	String id,
	List<KlpShortcutStroke> sequence, {
	String? commandId,
	KlpShortcutScope scope = KlpShortcutScope.app,
	String? scopeId,
	int priority = 0,
	bool allowRepeat = false,
	bool allowInEditable = false,
	bool Function(_Context)? when,
}) => KlpShortcutBinding<_Context>(
	id: id,
	commandId: commandId ?? id,
	sequence: sequence,
	scope: scope,
	scopeId: scopeId,
	priority: priority,
	allowRepeat: allowRepeat,
	allowInEditable: allowInEditable,
	when: when,
);

void _ignored(KlpShortcutHandling handling) {
	expect(handling.state, KlpShortcutHandlingState.ignored);
	expect(handling.handled, isFalse);
	expect(handling.bindingId, isNull);
	expect(handling.commandId, isNull);
	expect(handling.execution, isNull);
}

void main() {
	final focus = KlpShortcutFocus(focusId: 'editor');
	final context = _Context();

	for (final platform in KlpShortcutPlatform.values) {
		test('primary projects on $platform and modifiers match exactly', () async {
			final registry = KlpCommandRegistry<_Context>();
			final keymap = _keymap(registry, platform: platform);
			_command(registry, 'save');
			keymap.register(_binding('save', [KlpShortcutStroke(key: 's', primary: true)]));
			final mac = platform == KlpShortcutPlatform.mac;
			final matched = keymap.handle(KlpShortcutInput(key: 's', ctrl: !mac, meta: mac), focus, context);
			expect(matched.state, KlpShortcutHandlingState.executed);
			expect(matched.handled, isTrue);
			expect(matched.bindingId, 'save');
			expect(matched.commandId, 'save');
			expect((await matched.execution!).value, same(context));
			_ignored(keymap.handle(KlpShortcutInput(key: 's', ctrl: mac, meta: !mac), focus, context));
			_ignored(keymap.handle(KlpShortcutInput(key: 's', ctrl: !mac, meta: mac, shift: true), focus, context));
			_ignored(keymap.handle(KlpShortcutInput(key: 's', ctrl: true, meta: true), focus, context));
			keymap.register(_binding('both', [KlpShortcutStroke(key: 'b', primary: true, ctrl: true, meta: true)], commandId: 'save'));
			expect(keymap.handle(KlpShortcutInput(key: 'b', ctrl: true, meta: true), focus, context).state, KlpShortcutHandlingState.executed);
		});
	}

	test('scope then priority then UTF16 ID determine the winner independently of registration order', () async {
		final registry = KlpCommandRegistry<_Context>();
		final keymap = _keymap(registry);
		final chain = KlpShortcutFocus(focusId: 'f', pageId: 'p', regionId: 'r', componentId: 'c');
		final removers = <void Function()>[];
		for (final scope in KlpShortcutScope.values) {
			final id = scope.name;
			_command(registry, id);
			final scopeId = {'page': 'p', 'region': 'r', 'component': 'c'}[id];
			removers.add(keymap.register(_binding(id, [KlpShortcutStroke(key: 'x')], scope: scope, scopeId: scopeId, priority: scope == KlpShortcutScope.app ? 999 : 0)));
		}
		for (final id in ['component', 'region', 'page', 'app']) {
			final handling = keymap.handle(KlpShortcutInput(key: 'x'), chain, context);
			expect(handling.bindingId, id);
			await handling.execution!;
			removers[KlpShortcutScope.values.indexWhere((scope) => scope.name == id)]();
		}
		for (final id in ['\uE000', '\u{10000}', 'priority']) {
			_command(registry, id);
			keymap.register(_binding(id, [KlpShortcutStroke(key: 'x')], priority: id == 'priority' ? 1 : 0));
		}
		final high = keymap.handle(KlpShortcutInput(key: 'x'), focus, context);
		expect(high.bindingId, 'priority');
		await high.execution!;
		keymap.setOverride('priority', null);
		final lexical = keymap.handle(KlpShortcutInput(key: 'x'), focus, context);
		expect(lexical.bindingId, '\u{10000}');
		await lexical.execution!;
		_ignored(keymap.handle(KlpShortcutInput(key: 'x'), KlpShortcutFocus(focusId: 'outside', editable: true), context));
	});

	test('conflicts use projected modifiers and only current same-scope executable bindings', () {
		final registry = KlpCommandRegistry<_Context>();
		final keymap = _keymap(registry);
		for (final id in ['z', 'a', 'long', 'page', 'off']) {
			_command(registry, id);
		}
		final first = KlpShortcutStroke(key: 'k', primary: true);
		keymap.register(_binding('z', [first]));
		keymap.register(_binding('a', [KlpShortcutStroke(key: 'k', ctrl: true)], priority: 2));
		keymap.register(_binding('long', [first, KlpShortcutStroke(key: 'c')]));
		keymap.register(_binding('page', [first], scope: KlpShortcutScope.page, scopeId: 'p'));
		keymap.register(_binding('off', [first], when: (context) => false));
		final collisions = keymap.conflicts(KlpShortcutFocus(focusId: 'f', pageId: 'p'), context);
		expect(collisions.map((conflict) => conflict.bindingIds), [['a', 'long'], ['a', 'z'], ['long', 'z']]);
		expect(collisions.map((conflict) => conflict.kind), [KlpShortcutConflictKind.prefix, KlpShortcutConflictKind.exact, KlpShortcutConflictKind.prefix]);
		expect(collisions.map((conflict) => conflict.winnerId), ['a', 'a', 'long']);
		expect(() => collisions.first.bindingIds.clear(), throwsUnsupportedError);
		expect(registry.version, 5);
		final disabled = _Context()..enabled = false;
		expect(keymap.conflicts(focus, disabled), isEmpty);
		expect(keymap.conflicts(KlpShortcutFocus(focusId: 'f', editable: true), context), isEmpty);
	});

	test('winning longer chord defers a lower short command and reprocesses mismatches once', () async {
		final registry = KlpCommandRegistry<_Context>();
		final keymap = _keymap(registry);
		for (final id in ['short', 'long', 'fresh']) {
			_command(registry, id);
		}
		keymap.register(_binding('short', [KlpShortcutStroke(key: 'k')]));
		keymap.register(_binding('long', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c')], priority: 1));
		keymap.register(_binding('fresh', [KlpShortcutStroke(key: 'x')]));
		final prefix = keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		expect(prefix.state, KlpShortcutHandlingState.prefix);
		expect(prefix.bindingId, 'long');
		expect(prefix.execution, isNull);
		expect(registry.version, 3);
		final snapshot = keymap.pendingSequence;
		expect(snapshot.single.key, 'k');
		expect(() => snapshot.clear(), throwsUnsupportedError);
		_ignored(keymap.handle(KlpShortcutInput(key: 'Shift'), focus, context));
		expect(keymap.pendingSequence.single.key, 'k');
		final completed = keymap.handle(KlpShortcutInput(key: 'c'), focus, context);
		expect(completed.bindingId, 'long');
		await completed.execution!;
		expect(keymap.pendingSequence, isEmpty);
		expect(snapshot.single.key, 'k');
		keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		final fresh = keymap.handle(KlpShortcutInput(key: 'x'), focus, context);
		expect(fresh.bindingId, 'fresh');
		await fresh.execution!;
		keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		_ignored(keymap.handle(KlpShortcutInput(key: 'q'), focus, context));
		expect(keymap.pendingSequence, isEmpty);
		keymap.register(_binding('higher-short', [KlpShortcutStroke(key: 'k')], commandId: 'short', priority: 2));
		final immediate = keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		expect(immediate.bindingId, 'higher-short');
		expect(immediate.state, KlpShortcutHandlingState.executed);
		await immediate.execution!;
		expect(keymap.pendingSequence, isEmpty);
	});

	test('chords cancel on escape focus chain composition and expire at the injected deadline', () {
		final registry = KlpCommandRegistry<_Context>();
		var now = 0.0;
		final keymap = _keymap(registry, now: () => now);
		_command(registry, 'chord');
		keymap.register(_binding('chord', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c'), KlpShortcutStroke(key: 'v')]));
		void start() {
			keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		}
		start();
		final cancel = keymap.handle(KlpShortcutInput(key: 'escape'), focus, context);
		expect(cancel.state, KlpShortcutHandlingState.cancelled);
		expect(cancel.handled, isTrue);
		expect(cancel.execution, isNull);
		expect(keymap.cancelChord(), isFalse);
		start();
		expect(keymap.cancelChord(), isTrue);
		expect(keymap.cancelChord(), isFalse);
		for (final changed in [
			KlpShortcutFocus(focusId: 'other'),
			KlpShortcutFocus(focusId: 'editor', pageId: 'p'),
			KlpShortcutFocus(focusId: 'editor', regionId: 'r'),
			KlpShortcutFocus(focusId: 'editor', componentId: 'c'),
			KlpShortcutFocus(focusId: 'editor', editable: true),
		]) {
			start();
			_ignored(keymap.handle(KlpShortcutInput(key: 'c'), changed, context));
			expect(keymap.pendingSequence, isEmpty);
		}
		start();
		_ignored(keymap.handle(KlpShortcutInput(key: 'c', composing: true), focus, context));
		expect(keymap.pendingSequence, isEmpty);
		start();
		now = 999;
		expect(keymap.expireChord(), isFalse);
		keymap.handle(KlpShortcutInput(key: 'c'), focus, context);
		now = 1998;
		expect(keymap.expireChord(), isFalse);
		now = 1999;
		expect(keymap.expireChord(), isTrue);
		expect(keymap.expireChord(), isFalse);
		start();
		now = 2999;
		_ignored(keymap.handle(KlpShortcutInput(key: 'v'), focus, context));
		expect(keymap.pendingSequence, isEmpty);
		start();
		final before = keymap.pendingSequence;
		for (final invalid in [double.nan, -1.0, 2998.0]) {
			now = invalid;
			expect(keymap.expireChord, throwsA(anything));
			expect(keymap.pendingSequence.map((stroke) => stroke.key), before.map((stroke) => stroke.key));
		}
		now = 2999;
		expect(keymap.cancelChord(), isTrue);
	});

	test('text repeat when and same registry gates never intercept unavailable commands', () async {
		final registry = KlpCommandRegistry<_Context>();
		final keymap = _keymap(registry);
		final current = _Context();
		final pending = Completer<Object?>();
		var calls = 0;
		final remove = registry.register(KlpCommandDefinition<_Context>(
			id: 'work',
			label: 'work',
			handler: (context) { calls++; return pending.future; },
			isVisible: (context) => context.visible,
			isEnabled: (context) => context.enabled,
		));
		keymap.register(_binding('work', [KlpShortcutStroke(key: 's')], when: (context) => context.allowed));
		_ignored(keymap.handle(KlpShortcutInput(key: 's', repeat: true), focus, current));
		_ignored(keymap.handle(KlpShortcutInput(key: 's'), KlpShortcutFocus(focusId: 'editor', editable: true), current));
		_ignored(keymap.handle(KlpShortcutInput(key: 's', composing: true), focus, current));
		current.allowed = false;
		_ignored(keymap.handle(KlpShortcutInput(key: 's'), focus, current));
		current.allowed = true;
		current.visible = false;
		_ignored(keymap.handle(KlpShortcutInput(key: 's'), focus, current));
		current.visible = true;
		current.enabled = false;
		_ignored(keymap.handle(KlpShortcutInput(key: 's'), focus, current));
		current.enabled = true;
		keymap.register(_binding('throw', [KlpShortcutStroke(key: 'e')], commandId: 'work', when: (context) => throw Object()));
		_ignored(keymap.handle(KlpShortcutInput(key: 'e'), focus, current));
		keymap.register(_binding('safe', [KlpShortcutStroke(key: 'r')], commandId: 'work', allowRepeat: true, allowInEditable: true));
		final started = keymap.handle(KlpShortcutInput(key: 'r', repeat: true), KlpShortcutFocus(focusId: 'editor', editable: true), current);
		expect(started.state, KlpShortcutHandlingState.executed);
		expect(calls, 1);
		_ignored(keymap.handle(KlpShortcutInput(key: 's'), focus, current));
		final value = Object();
		remove();
		pending.complete(value);
		final result = await started.execution!;
		expect(result.status, KlpCommandExecutionStatus.executed);
		expect(result.value, same(value));
		_ignored(keymap.handle(KlpShortcutInput(key: 's'), focus, current));
		_command(registry, 'work', handler: (context) => Future<Object?>.error(value));
		final failure = await keymap.handle(KlpShortcutInput(key: 's'), focus, current).execution!;
		expect(failure.status, KlpCommandExecutionStatus.error);
		expect(failure.error, same(value));
		expect(failure.phase?.name, 'handler');
		registry.dispose();
		_ignored(keymap.handle(KlpShortcutInput(key: 's'), focus, current));
		expect(calls, 1);
	});

	test('binding disposer owns its registration and removes only its override', () async {
		final registry = KlpCommandRegistry<_Context>();
		final keymap = _keymap(registry);
		_command(registry, 'work');
		final old = keymap.register(_binding('binding', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c')], commandId: 'work'));
		expect(() => keymap.register(_binding('binding', [KlpShortcutStroke(key: 'x')])), throwsStateError);
		keymap.setOverride('binding', [KlpShortcutStroke(key: 'x')]);
		old();
		expect((keymap.exportOverrides()['bindings'] as Map), isEmpty);
		final current = keymap.register(_binding('binding', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c')], commandId: 'work'));
		keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		old();
		expect(keymap.pendingSequence, isNotEmpty);
		final result = keymap.handle(KlpShortcutInput(key: 'c'), focus, context);
		expect(result.bindingId, 'binding');
		await result.execution!;
		keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		current();
		current();
		expect(keymap.pendingSequence, isEmpty);
		_ignored(keymap.handle(KlpShortcutInput(key: 'k'), focus, context));
		expect(registry.getState('work', context), isNotNull);
	});

	test('overrides are atomic validated isolated DTOs with roundtrip and restore', () async {
		final registry = KlpCommandRegistry<_Context>();
		final keymap = _keymap(registry);
		for (final id in ['work', 'off']) {
			_command(registry, id);
		}
		final defaults = [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c')];
		keymap.register(_binding('work', defaults));
		defaults.clear();
		keymap.register(_binding('off', [KlpShortcutStroke(key: 'o')]));
		final replacement = [KlpShortcutStroke(key: 'x', alt: true)];
		keymap.setOverride('work', replacement);
		replacement.clear();
		keymap.setOverride('off', null);
		// 經 JSON roundtrip 建立 caller 可變 DTO；輸出也可以合法地是唯讀 snapshot。
		final saved = jsonDecode(jsonEncode(keymap.exportOverrides())) as Map<String, dynamic>;
		expect(saved['schemaVersion'], 1);
		final data = saved['bindings'] as Map;
		expect(data['off'], isNull);
		expect(((data['work'] as List).single as Map)['key'], 'x');
		expect(((data['work'] as List).single as Map)['alt'], isTrue);
		keymap.restore('work');
		keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		expect(keymap.pendingSequence.single.key, 'k');
		expect(() => keymap.setOverride('work', []), throwsArgumentError);
		expect(keymap.pendingSequence.single.key, 'k');
		final invalid = <Map<String, Object?>>[
			{'schemaVersion': 2, 'bindings': {}},
			{'schemaVersion': 1.0, 'bindings': {}},
			{'schemaVersion': 1, 'bindings': {}, 'extra': true},
			{'schemaVersion': 1, 'bindings': {'unknown': null}},
			{'schemaVersion': 1, 'bindings': {'work': []}},
			{'schemaVersion': 1, 'bindings': {'work': [{'key': 'A'}]}},
			{'schemaVersion': 1, 'bindings': {'work': [{'key': 'x', 'ctrl': 'true'}]}},
			{'schemaVersion': 1, 'bindings': {'work': [{'key': 'x', 'extra': true}]}},
			{'schemaVersion': 1, 'bindings': {'work': List.generate(5, (_) => {'key': 'x'})}},
		];
		for (final value in invalid) {
			final before = keymap.exportOverrides();
			expect(() => keymap.importOverrides(value), throwsArgumentError);
			expect(keymap.exportOverrides(), before);
			expect(keymap.pendingSequence.single.key, 'k');
		}
		keymap.importOverrides(saved);
		expect(keymap.pendingSequence, isEmpty);
		expect(keymap.exportOverrides(), saved);
		(data['work'] as List).clear();
		data.clear();
		final result = keymap.handle(KlpShortcutInput(key: 'x', alt: true), focus, context);
		expect(result.bindingId, 'work');
		await result.execution!;
		_ignored(keymap.handle(KlpShortcutInput(key: 'o'), focus, context));
		final exported = keymap.exportOverrides();
		try {
			((exported['bindings'] as Map)['work'] as List).clear();
		}
		on UnsupportedError {
			// 唯讀 DTO 也符合 caller mutation 不影響核心的契約。
		}
		final isolated = (keymap.exportOverrides()['bindings'] as Map)['work'] as List;
		expect((isolated.single as Map)['key'], 'x');
		expect(() => keymap.setOverride('unknown', null), throwsArgumentError);
		expect(() => keymap.restore('unknown'), throwsArgumentError);
		keymap.importOverrides({'schemaVersion': 1, 'bindings': {}});
		expect(keymap.exportOverrides()['bindings'], isEmpty);
		keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		expect(keymap.pendingSequence.single.key, 'k');
		keymap.setOverride('work', [KlpShortcutStroke(key: 'x')]);
		expect(keymap.pendingSequence, isEmpty);
	});

	test('recording never dispatches and obeys focus composition repeat escape and four strokes', () {
		final registry = KlpCommandRegistry<_Context>();
		final keymap = _keymap(registry);
		var calls = 0;
		_command(registry, 'work', handler: (context) { calls++; return null; });
		keymap.register(_binding('work', [KlpShortcutStroke(key: 'x')]));
		keymap.register(_binding('chord', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c')], commandId: 'work'));
		keymap.handle(KlpShortcutInput(key: 'k'), focus, context);
		expect(keymap.pendingSequence, isNotEmpty);
		keymap.beginRecording('editor');
		expect(keymap.pendingSequence, isEmpty);
		keymap.setOverride('work', null);
		expect(keymap.isRecording, isTrue);
		final editable = KlpShortcutFocus(focusId: 'editor', editable: true);
		_ignored(keymap.handle(KlpShortcutInput(key: 'x', composing: true), editable, context));
		expect(keymap.isRecording, isTrue);
		_ignored(keymap.handle(KlpShortcutInput(key: 'x', repeat: true), editable, context));
		_ignored(keymap.handle(KlpShortcutInput(key: 'Dead'), editable, context));
		for (final key in ['x', 'c', 'v', 'b']) {
			final recording = keymap.handle(KlpShortcutInput(key: key, ctrl: true), editable, context);
			expect(recording.state, KlpShortcutHandlingState.recording);
			expect(recording.handled, isTrue);
			expect(recording.execution, isNull);
		}
		_ignored(keymap.handle(KlpShortcutInput(key: 'n'), editable, context));
		final recorded = keymap.finishRecording();
		expect(recorded.map((stroke) => stroke.key), ['x', 'c', 'v', 'b']);
		expect(recorded.every((stroke) => stroke.ctrl && !stroke.primary), isTrue);
		expect(() => recorded.clear(), throwsUnsupportedError);
		expect(keymap.isRecording, isFalse);
		expect(keymap.recordedSequence.length, 4);
		keymap.beginRecording('editor');
		expect(keymap.recordedSequence, isEmpty);
		keymap.handle(KlpShortcutInput(key: 'x'), focus, context);
		_ignored(keymap.handle(KlpShortcutInput(key: 'x'), KlpShortcutFocus(focusId: 'other'), context));
		expect(keymap.isRecording, isFalse);
		expect(keymap.recordedSequence, isEmpty);
		keymap.beginRecording('editor');
		final cancelled = keymap.handle(KlpShortcutInput(key: 'escape'), focus, context);
		expect(cancelled.state, KlpShortcutHandlingState.cancelled);
		expect(cancelled.handled, isTrue);
		expect(keymap.isRecording, isFalse);
		expect(keymap.finishRecording(), isEmpty);
		keymap.cancelRecording();
		expect(calls, 0);
		expect(recorded.length, 4);
	});

	test('invalid definitions reject and dispose clears owned state without disposing registry', () async {
		final registry = KlpCommandRegistry<_Context>();
		final keymap = _keymap(registry);
		_command(registry, 'work');
		for (final sequence in [<KlpShortcutStroke>[], List.generate(5, (_) => KlpShortcutStroke(key: 'x'))]) {
			expect(() => keymap.register(_binding('invalid', sequence, commandId: 'work')), throwsArgumentError);
		}
		expect(() => keymap.register(_binding('invalid', [KlpShortcutStroke(key: 'Unknown')], commandId: 'work')), throwsArgumentError);
		expect(() => keymap.register(_binding('invalid', [KlpShortcutStroke(key: 'x')], scope: KlpShortcutScope.page)), throwsArgumentError);
		expect(() => keymap.register(_binding('invalid', [KlpShortcutStroke(key: 'x')], scopeId: 'unexpected')), throwsArgumentError);
		keymap.register(_binding('work', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c')]));
		keymap.setOverride('work', [KlpShortcutStroke(key: 'x')]);
		keymap.beginRecording('editor');
		keymap.handle(KlpShortcutInput(key: 'x'), focus, context);
		keymap.dispose();
		keymap.dispose();
		expect(keymap.isDisposed, isTrue);
		expect(registry.isDisposed, isFalse);
		expect(keymap.pendingSequence, isEmpty);
		expect(keymap.recordedSequence, isEmpty);
		expect(keymap.exportOverrides()['bindings'], isEmpty);
		_ignored(keymap.handle(KlpShortcutInput(key: 'x'), focus, context));
		expect(keymap.cancelChord(), isFalse);
		expect(keymap.expireChord(), isFalse);
		expect(keymap.finishRecording(), isEmpty);
		keymap.cancelRecording();
		expect(() => keymap.beginRecording('editor'), throwsStateError);
		expect(() => keymap.register(_binding('new', [KlpShortcutStroke(key: 'x')])), throwsStateError);
		expect(() => keymap.setOverride('work', null), throwsStateError);
		expect(() => keymap.restore('work'), throwsStateError);
		expect(() => keymap.importOverrides({'schemaVersion': 1, 'bindings': {}}), throwsStateError);
		expect((await registry.execute('work', context)).value, same(context));
	});
}
