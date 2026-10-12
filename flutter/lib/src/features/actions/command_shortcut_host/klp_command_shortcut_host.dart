import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../command_keymap/klp_command_keymap.dart';
import '../command_registry/klp_command_registry.dart';

/// 將 focused descendant 未處理的原生按鍵交同 keymap，不接管產品文字或命令權威。
class KlpCommandShortcutHost<C> extends StatefulWidget {

	/* keymap 借用解析權威；三個 get 回呼讀當次產品 context／focus／custom editor組字。
	 * onHandling 回原解析供產品呈現；onResult 回原execution；child 保留原生布局與元件。
	 */
	final KlpCommandKeymap<C> keymap;
	final C Function() getContext;
	final KlpShortcutFocus Function() getFocus;
	final bool Function() getIsComposing;
	final ValueChanged<KlpShortcutHandling> onHandling;
	final ValueChanged<KlpCommandExecutionResult> onResult;
	final Widget child;

	const KlpCommandShortcutHost({
		super.key,
		required this.keymap,
		required this.getContext,
		required this.getFocus,
		required this.getIsComposing,
		required this.onHandling,
		required this.onResult,
		required this.child,
	});

	@override
	State<KlpCommandShortcutHost<C>> createState() => _ShortcutHostState<C>();
}

class _ShortcutHostState<C> extends State<KlpCommandShortcutHost<C>> {

	/* _focus 是不可tab stop的原生宿主；_primary 僅觀察native identity，不生成產品focus鏈。
	 * _timer 單一owned deadline；_session 隔離replacement/unmount的舊Future。
	 */
	final FocusNode _focus = FocusNode(canRequestFocus: false, skipTraversal: true);
	FocusNode? _primary;
	Timer? _timer;
	int _session = 0;

	@override
	void initState() {
		super.initState();
		_primary = FocusManager.instance.primaryFocus;

		// 只觀察原生焦點變動，不註冊HardwareKeyboard global handler。
		FocusManager.instance.addListener(_focusChanged);
	}

	@override
	void didUpdateWidget(covariant KlpCommandShortcutHost<C> oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (identical(oldWidget.keymap, widget.keymap)) return;

		_session++;
		_clear(oldWidget.keymap, true);
	}

	@override
	void dispose() {
		_session++;
		FocusManager.instance.removeListener(_focusChanged);
		_clear(widget.keymap, true);
		_focus.dispose();
		super.dispose();
	}

	void _focusChanged() {
		final next = FocusManager.instance.primaryFocus;
		if (identical(next, _primary)) return;

		_primary = next;
		_clear(widget.keymap, !_focus.hasFocus);
	}

	void _clear(KlpCommandKeymap<C> keymap, bool outside) {
		_cancelTimer();
		keymap.cancelChord();
		if (outside) keymap.cancelRecording();
	}

	void _cancelTimer() {
		_timer?.cancel();
		_timer = null;
	}

	KeyEventResult _keydown(FocusNode node, KeyEvent event) {
		if (event.synthesized || event is! KeyDownEvent && event is! KeyRepeatEvent) return KeyEventResult.ignored;

		final keymap = widget.keymap;
		final session = _session;
		late KlpShortcutHandling result;
		try {
			// 原生EditableText與產品投影做OR，不用KeyEvent.character猜測輸入法。
			final nativeEditor = _editor();
			final composing = nativeEditor?.controller.value.composing;
			final nativeComposing = composing != null && composing.isValid && !composing.isCollapsed;
			final focus = widget.getFocus();
			final projected = KlpShortcutFocus(
				focusId: focus.focusId,
				pageId: focus.pageId,
				regionId: focus.regionId,
				componentId: focus.componentId,
				editable: focus.editable || nativeEditor != null,
			);
			final keyboard = HardwareKeyboard.instance;
			final input = KlpShortcutInput(
				key: _logical(event.logicalKey),
				ctrl: keyboard.isControlPressed,
				alt: keyboard.isAltPressed,
				shift: keyboard.isShiftPressed,
				meta: keyboard.isMetaPressed,
				repeat: event is KeyRepeatEvent,
				composing: widget.getIsComposing() || nativeComposing,
			);
			result = keymap.handle(input, projected, widget.getContext());
		}
		catch (error, stack) {
			_report(error, stack);
			return KeyEventResult.ignored;
		}

		// 產品callback錯誤不重試dispatch，也不改已決定的原生handled結果。
		try {
			_updateTimer(result);
			widget.onHandling(result);
		}
		catch (error, stack) {
			_report(error, stack);
		}
		final execution = result.execution;
		if (execution != null) _deliver(execution, keymap, session);
		return result.handled ? KeyEventResult.handled : KeyEventResult.ignored;
	}

	EditableText? _editor() {
		final context = FocusManager.instance.primaryFocus?.context;
		if (context == null) return null;
		if (context.widget is EditableText) return context.widget as EditableText;

		return context.findAncestorWidgetOfExactType<EditableText>();
	}

	void _updateTimer(KlpShortcutHandling result) {
		if (widget.keymap.pendingSequence.isEmpty) {
			_cancelTimer();
			return;
		}
		if (result.state == KlpShortcutHandlingState.prefix) _cancelTimer();
		if (_timer == null) _scheduleTimer(widget.keymap, _session);
	}

	void _scheduleTimer(KlpCommandKeymap<C> keymap, int session) {
		// 單一原生timeout只呼叫public expireChord；ignored modifier不延長期限。
		void expire() {
			_timer = null;
			if (!_current(keymap, session)) return;

			try {
				keymap.expireChord();
				if (keymap.pendingSequence.isNotEmpty) _scheduleTimer(keymap, session);
			}
			catch (error, stack) {
				_report(error, stack);
			}
		}
		_timer = Timer(Duration(milliseconds: keymap.chordTimeoutMs), expire);
	}

	bool _current(KlpCommandKeymap<C> keymap, int session) {
		return mounted && session == _session && identical(widget.keymap, keymap);
	}

	Future<void> _deliver(Future<KlpCommandExecutionResult> execution, KlpCommandKeymap<C> keymap, int session) async {
		try {
			final result = await execution;
			if (_current(keymap, session)) widget.onResult(result);
		}
		catch (error, stack) {
			_report(error, stack);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Focus(focusNode: _focus, onKeyEvent: _keydown, child: widget.child);
	}
}

String _logical(LogicalKeyboardKey key) {
	// 已知named logical keys維持跨框架共同名字，其他鍵保留native keyLabel的布局語意。
	final named = {
		/* 原生logical key為key，canonical named字串為value；不採physical scan-code。 */
		LogicalKeyboardKey.enter: 'enter',
		LogicalKeyboardKey.escape: 'escape',
		LogicalKeyboardKey.tab: 'tab',
		LogicalKeyboardKey.space: 'space',
		LogicalKeyboardKey.backspace: 'backspace',
		LogicalKeyboardKey.delete: 'delete',
		LogicalKeyboardKey.insert: 'insert',
		LogicalKeyboardKey.home: 'home',
		LogicalKeyboardKey.end: 'end',
		LogicalKeyboardKey.pageUp: 'pageup',
		LogicalKeyboardKey.pageDown: 'pagedown',
		LogicalKeyboardKey.arrowUp: 'arrowup',
		LogicalKeyboardKey.arrowDown: 'arrowdown',
		LogicalKeyboardKey.arrowLeft: 'arrowleft',
		LogicalKeyboardKey.arrowRight: 'arrowright',
	};
	return named[key] ?? key.keyLabel.toLowerCase();
}

void _report(Object error, StackTrace stack) {
	// diagnostic本身失敗不能蓋過原命令結果或破壞owned資源清理。
	try {
		FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack, library: 'Kallopis command shortcut host'));
	}
	catch (_) {
		// 原生宿主已收到diagnostic嘗試，不重試dispatch。
	}
}
