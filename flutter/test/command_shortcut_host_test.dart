import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

class _Host {

	/* registry：產品命令唯一權威；maps：保存借用的 keymap，於測試結束由產品解除。
	 * keymap：目前宿主 session；now：可控毫秒 clock，讓 timer 邊界不依真實等待。
	 * context：可替換的產品資料；first、second、outside：觀察內部與外部原生焦點。
	 * controller：原生文字及 composing 權威；handling、results：公開回呼原物件紀錄。
	 * focusId、editable、composing：產品 focus 與組字投影，獨立於原生文字判斷。
	 * text、mounted：控制原生 editor 與宿主存在；childResult：產品子元件的事件決定。
	 * bubbled：父節點收到的 keydown 次數，觀察 only-handled 攔截。
	 * callback、handlingCallback：可替換產品回呼，驗證 latest callback 與診斷通道。
	 */
	final registry = KlpCommandRegistry<Object>();
	final maps = <KlpCommandKeymap<Object>>[];
	late KlpCommandKeymap<Object> keymap;
	double now = 0;
	Object context = Object();
	final first = FocusNode();
	final second = FocusNode();
	final outside = FocusNode();
	final controller = TextEditingController(text: 'native');
	final handling = <KlpShortcutHandling>[];
	final results = <KlpCommandExecutionResult>[];
	String focusId = 'editor';
	bool editable = false;
	bool composing = false;
	bool text = false;
	bool mounted = true;
	KeyEventResult childResult = KeyEventResult.ignored;
	int bubbled = 0;
	void Function(KlpCommandExecutionResult)? callback;
	void Function(KlpShortcutHandling)? handlingCallback;

	_Host() {
		replace();
	}

	void replace() {
		keymap = KlpCommandKeymap<Object>(registry: registry, chordTimeoutMs: 100, now: () => now);
		maps.add(keymap);
	}

	void bind(String id, List<KlpShortcutStroke> sequence, {FutureOr<Object?> Function(Object)? handler, bool allowRepeat = false, bool allowInEditable = false}) {
		// 產品透過公開 registry 註冊 handler；宿主不得另建命令執行權威。
		registry.register(KlpCommandDefinition<Object>(id: id, label: id, handler: handler ?? (value) => value));
		keymap.register(KlpShortcutBinding<Object>(
			id: id,
			commandId: id,
			sequence: sequence,
			scope: KlpShortcutScope.app,
			allowRepeat: allowRepeat,
			allowInEditable: allowInEditable,
		));
	}

	Widget build() {
		final resultCallback = callback;
		final observedHandling = handlingCallback;
		final nativeChild = Focus(focusNode: first, onKeyEvent: (node, event) => childResult, child: const SizedBox(height: 20));
		final editor = EditableText(
			controller: controller,
			focusNode: first,
			style: const TextStyle(fontSize: 14),
			cursorColor: Colors.black,
			backgroundCursorColor: Colors.grey,
		);
		final children = Column(children: [text ? editor : nativeChild, Focus(focusNode: second, child: const SizedBox(height: 20))]);
		final host = KlpCommandShortcutHost<Object>(
			keymap: keymap,
			getContext: () => context,
			getFocus: () => KlpShortcutFocus(focusId: focusId, editable: editable),
			getIsComposing: () => composing,
			onHandling: (value) { handling.add(value); observedHandling?.call(value); },
			onResult: (value) { results.add(value); resultCallback?.call(value); },
			child: children,
		);
		final parent = Focus(onKeyEvent: (node, event) { if (event is KeyDownEvent) bubbled++; return KeyEventResult.ignored; }, child: mounted ? host : const SizedBox());
		return MaterialApp(home: Scaffold(body: Column(children: [parent, Focus(focusNode: outside, child: const SizedBox(height: 20))])));
	}

	void dispose() {
		for (final map in maps) { map.dispose(); }
		registry.dispose();
		first.dispose();
		second.dispose();
		outside.dispose();
		controller.dispose();
	}
}

Future<void> _show(WidgetTester tester, _Host host) async {
	// 原生樹保留同位置宿主，rebuild 可更新產品回呼而不換 session。
	await tester.pumpWidget(host.build());
	await tester.pump();
}

Future<void> _focus(WidgetTester tester, FocusNode node) async {
	// 透過 FocusManager 的公開流程發出真實 primaryFocus 變動。
	node.requestFocus();
	await tester.pump();
}

void _test(String name, Future<void> Function(WidgetTester, _Host) check) {
	testWidgets(name, (tester) async {
		final host = _Host();
		try {
			await check(tester, host);
		}
		finally {
			await tester.pumpWidget(const SizedBox());
			host.dispose();
		}
	});
}

void main() {
	_test('native logical keys actual modifiers repeat keyup synthesized and only handled interception', (tester, host) async {
		host.bind('save', [KlpShortcutStroke(key: 's', ctrl: true)]);
		host.bind('repeat', [KlpShortcutStroke(key: 'r')], allowRepeat: true);
		host.bind('single', [KlpShortcutStroke(key: 'b')]);
		host.bind('arrow', [KlpShortcutStroke(key: 'arrowdown')]);
		await _show(tester, host);
		await _focus(tester, host.first);
		await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
		expect(host.handling.last.handled, isFalse);
		expect(host.bubbled, 1);
		await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
		await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
		await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
		expect(host.results, isEmpty, reason: '額外 shift 不得被 primary 或 ctrl 匹配忽略。');
		await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
		final beforeHandled = host.bubbled;
		await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
		await tester.pump();
		expect(host.results.single.value, same(host.context));
		expect(host.bubbled, beforeHandled, reason: 'handled 事件不得繼續傳到產品父節點。');
		await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
		final count = host.handling.length;
		// 由原生平台入口送 synthesized 資料；HardwareKeyboard 單獨處理不會派送 Focus 的 KeyMessage。
		final dispatchNative = tester.binding.platformDispatcher.onKeyData!;
		dispatchNative(ui.KeyData(
			type: ui.KeyEventType.down,
			physical: PhysicalKeyboardKey.keyA.usbHidUsage,
			logical: LogicalKeyboardKey.arrowDown.keyId,
			timeStamp: Duration.zero,
			character: null,
			synthesized: true,
		));
		dispatchNative(ui.KeyData(
			type: ui.KeyEventType.up,
			physical: PhysicalKeyboardKey.keyA.usbHidUsage,
			logical: LogicalKeyboardKey.arrowDown.keyId,
			timeStamp: Duration.zero,
			character: null,
			synthesized: true,
		));
		expect(host.handling.length, count);
		// ignored arrow 仍可觸發 MaterialApp 的原生方向巡覽；先完成巡覽再聚焦本次事件的產品 child。
		await tester.pump();
		await _focus(tester, host.first);
		expect(host.first.hasPrimaryFocus, isTrue);
		// 測試框架同時送 KeyData 與 raw message，讓 logical／physical 差異進入真正 Focus 管線。
		await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown, physicalKey: PhysicalKeyboardKey.keyA);
		await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown, physicalKey: PhysicalKeyboardKey.keyA);
		await tester.pump();
		expect(host.handling.length, count + 1, reason: 'keyup 不得再次處理。');
		expect(host.results.last.commandId, 'arrow');
		await _focus(tester, host.first);
		expect(host.first.hasPrimaryFocus, isTrue);
		final beforeRepeat = host.handling.length;
		await tester.sendKeyDownEvent(LogicalKeyboardKey.keyB);
		await tester.pump();
		expect(host.handling.length, beforeRepeat + 1, reason: 'normal keydown 必須實際到達宿主。');
		await tester.sendKeyRepeatEvent(LogicalKeyboardKey.keyB);
		expect(host.handling.length, beforeRepeat + 2, reason: 'repeat 必須實際到達宿主，不得以先前事件判斷。');
		expect(host.handling.last.handled, isFalse);
		expect(host.results.where((value) => value.commandId == 'single').length, 1);
		await tester.sendKeyUpEvent(LogicalKeyboardKey.keyB);
		await tester.sendKeyDownEvent(LogicalKeyboardKey.keyR);
		await tester.pump();
		await tester.sendKeyRepeatEvent(LogicalKeyboardKey.keyR);
		await tester.pump();
		expect(host.results.where((value) => value.commandId == 'repeat').length, 2);
		await tester.sendKeyUpEvent(LogicalKeyboardKey.keyR);
	});

	_test('focused child handled and skipRemainingHandlers never reach host', (tester, host) async {
		host.bind('work', [KlpShortcutStroke(key: 'x')]);
		for (final decision in [KeyEventResult.handled, KeyEventResult.skipRemainingHandlers]) {
			host.childResult = decision;
			await _show(tester, host);
			await _focus(tester, host.first);
			await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
		}
		expect(host.handling, isEmpty);
		expect(host.results, isEmpty);
	});

	_test('product editable composing and explicit recording protect native input', (tester, host) async {
		host.bind('work', [KlpShortcutStroke(key: 'x')]);
		host.bind('allowed', [KlpShortcutStroke(key: 'a')], allowInEditable: true);
		host.bind('chord', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c')], allowInEditable: true);
		host.editable = true;
		await _show(tester, host);
		await _focus(tester, host.first);
		await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
		expect(host.handling.last.handled, isFalse);
		await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
		await tester.pump();
		expect(host.results.single.commandId, 'allowed');
		await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
		expect(host.keymap.pendingSequence, isNotEmpty);
		host.composing = true;
		await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
		expect(host.keymap.pendingSequence, isEmpty);
		expect(host.handling.last.handled, isFalse);
		host.keymap.beginRecording('editor');
		host.composing = true;
		await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
		expect(host.keymap.isRecording, isTrue);
		expect(host.keymap.recordedSequence, isEmpty);
		host.composing = false;
		await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
		expect(host.handling.last.state, KlpShortcutHandlingState.recording);
		expect(host.keymap.recordedSequence.single.key, 'x');
		expect(host.results.length, 1);
	});

	_test('EditableText native editable and composing are ORed with product projections', (tester, host) async {
		host.text = true;
		host.bind('plain', [KlpShortcutStroke(key: 'f1')]);
		host.bind('allowed', [KlpShortcutStroke(key: 'f2')], allowInEditable: true);
		await _show(tester, host);
		await _focus(tester, host.first);
		await tester.sendKeyEvent(LogicalKeyboardKey.f1);
		expect(host.handling.last.handled, isFalse);
		await tester.sendKeyEvent(LogicalKeyboardKey.f2);
		await tester.pump();
		expect(host.results.single.commandId, 'allowed');
		// controller 是原生組字來源，產品 callback 刻意維持 false。
		host.controller.value = const TextEditingValue(text: 'native', selection: TextSelection.collapsed(offset: 2), composing: TextRange(start: 0, end: 2));
		host.keymap.beginRecording('editor');
		await tester.sendKeyEvent(LogicalKeyboardKey.f2);
		expect(host.handling.last.handled, isFalse);
		expect(host.keymap.isRecording, isTrue);
		expect(host.keymap.recordedSequence, isEmpty);
		host.controller.clearComposing();
		host.composing = true;
		await tester.sendKeyEvent(LogicalKeyboardKey.f2);
		expect(host.keymap.recordedSequence, isEmpty);
		host.composing = false;
		await tester.sendKeyEvent(LogicalKeyboardKey.f2);
		expect(host.keymap.recordedSequence.single.key, 'f2');
		expect(host.results.length, 1);
	});

	_test('prefix timer survives callback rebuild and ignored modifier without extending deadline', (tester, host) async {
		host.bind('chord', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c'), KlpShortcutStroke(key: 'v')]);
		await _show(tester, host);
		await _focus(tester, host.first);
		await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
		expect(host.keymap.pendingSequence.length, 1);
		host.now = 50;
		await tester.pump(const Duration(milliseconds: 50));
		await _show(tester, host);
		await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);
		expect(host.keymap.pendingSequence.length, 1);
		final count = host.handling.length;
		host.now = 100;
		await tester.pump(const Duration(milliseconds: 50));
		expect(host.keymap.pendingSequence, isEmpty);
		expect(host.handling.length, count, reason: 'timer 不得虛構原生事件回呼。');
		await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
		host.now = 150;
		await tester.pump(const Duration(milliseconds: 50));
		await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
		host.now = 200;
		await tester.pump(const Duration(milliseconds: 50));
		expect(host.keymap.pendingSequence.length, 2, reason: '合法新 prefix step 必須重設期限。');
		host.now = 250;
		await tester.pump(const Duration(milliseconds: 50));
		expect(host.keymap.pendingSequence, isEmpty);
		expect(host.results, isEmpty);
	});

	_test('native internal focus cancels chord and leave cancels recording without another event', (tester, host) async {
		host.bind('chord', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c')]);
		await _show(tester, host);
		await _focus(tester, host.first);
		await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
		await _focus(tester, host.second);
		expect(host.keymap.pendingSequence, isEmpty);
		host.keymap.beginRecording('editor');
		await _focus(tester, host.first);
		expect(host.keymap.isRecording, isTrue, reason: '宿主內轉換只立即取消 chord。');
		await _focus(tester, host.outside);
		expect(host.keymap.isRecording, isFalse);
		expect(host.keymap.recordedSequence, isEmpty);
	});

	_test('same session pending result reaches latest callback as original result and context', (tester, host) async {
		final pending = Completer<Object?>();
		Object? receivedContext;
		host.bind('slow', [KlpShortcutStroke(key: 's')], handler: (value) { receivedContext = value; return pending.future; });
		var oldCalls = 0;
		host.callback = (value) { oldCalls++; };
		await _show(tester, host);
		await _focus(tester, host.first);
		final latestContext = Object();
		host.context = latestContext;
		await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
		final execution = host.handling.single.execution!;
		KlpCommandExecutionResult? latest;
		host.callback = (value) { latest = value; };
		await _show(tester, host);
		final value = Object();
		pending.complete(value);
		final original = await execution;
		await tester.pump();
		expect(receivedContext, same(latestContext));
		expect(oldCalls, 0);
		expect(latest, same(original));
		expect(host.results.single, same(original));
		expect(original.value, same(value));
	});

	for (final transition in ['replacement', 'unmount']) {
		_test('$transition cleans chord recording timer and drops stale async result without disposing borrowed owners', (tester, host) async {
			final pending = Completer<Object?>();
			host.bind('slow', [KlpShortcutStroke(key: 's')], handler: (value) => pending.future);
			host.bind('chord', [KlpShortcutStroke(key: 'k'), KlpShortcutStroke(key: 'c')]);
			await _show(tester, host);
			await _focus(tester, host.first);
			await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
			final execution = host.handling.last.execution!;
			await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
			final old = host.keymap;
			if (transition == 'replacement') { host.replace(); }
			else { host.mounted = false; }
			await _show(tester, host);
			expect(old.pendingSequence, isEmpty);
			expect(old.isDisposed, isFalse);
			expect(host.registry.isDisposed, isFalse);
			final value = Object();
			pending.complete(value);
			expect((await execution).value, same(value));
			await tester.pump();
			expect(host.results, isEmpty);
			// 產品可再借用同一個 keymap，清理不應破壞所有權。
			host.keymap = old;
			host.mounted = true;
			await _show(tester, host);
			await _focus(tester, host.first);
			old.beginRecording('editor');
			if (transition == 'replacement') { host.replace(); }
			else { host.mounted = false; }
			await _show(tester, host);
			expect(old.isRecording, isFalse);
			expect(old.isDisposed, isFalse);
			host.now = 100;
			await tester.pump(const Duration(milliseconds: 100));
			expect(tester.takeException(), isNull);
		});
	}

	_test('callback errors use Flutter diagnostics without undoing handled or changing registry result', (tester, host) async {
		final diagnostics = <Object>[];
		final previousReporter = FlutterError.onError;
		final handlingError = StateError('handling callback');
		final resultError = StateError('result callback');
		final handlerError = StateError('command handler');
		host.bind('work', [KlpShortcutStroke(key: 'x')]);
		host.bind('failure', [KlpShortcutStroke(key: 'f')], handler: (value) => throw handlerError);
		host.handlingCallback = (value) => throw handlingError;
		host.callback = (value) => throw resultError;
		await _show(tester, host);
		await _focus(tester, host.first);
		// 同時到達的同步與 Future 錯誤仍各自保留原 diagnostic，避免依 microtask 次序判定。
		FlutterError.onError = (details) { diagnostics.add(details.exception); };
		try {
			await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
			await tester.pump();
			expect(diagnostics, [same(handlingError), same(resultError)]);
			expect(host.bubbled, 0);
			expect(host.results.single.status, KlpCommandExecutionStatus.executed);
		}
		finally {
			FlutterError.onError = previousReporter;
		}
		host.handlingCallback = null;
		host.callback = null;
		await _show(tester, host);
		await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
		await tester.pump();
		expect(host.results.last.status, KlpCommandExecutionStatus.error);
		expect(host.results.last.error, same(handlerError));
		expect(tester.takeException(), isNull);
	});
}
