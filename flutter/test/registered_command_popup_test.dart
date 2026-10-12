import 'dart:async';
import 'dart:ui' show SemanticsAction, SemanticsFlag;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 此宿主只使用公開入口；產品狀態與原生量測不依賴 popup 私有實作。
class _Host {
	// 產品持有註冊表；關閉 popup 不得釋放此權威。
	KlpCommandRegistry<Object> registry = KlpCommandRegistry<Object>();
	final retired = <KlpCommandRegistry<Object>>[];
	final context = Object();
	final results = <KlpCommandExecutionResult>[];
	final dismissals = <KlpCommandPopupDismissReason>[];
	final events = <String>[];
	ValueChanged<KlpCommandExecutionResult>? callback;
	// 受控生命週期、錨點與風格由產品更新。
	bool open = true;
	bool mounted = true;
	Rect anchor = const Rect.fromLTWH(100, 100, 80, 30);
	TextDirection direction = TextDirection.ltr;
	KlpVisualStyle style = KlpVisualStyle.defaultStyle;
	List<KlpCommandReference> items = const [KlpCommandReference(commandId: 'available')];
	int reads = 0;
	int calls = 0;
	// 背景編輯器、焦點及 State 必須跨 modal 保存。
	final backgroundKey = GlobalKey<_BackgroundState>();
	final originalFocus = FocusNode();
	final externalFocus = FocusNode();
	final controller = TextEditingController.fromValue(const TextEditingValue(text: 'Product value', selection: TextSelection(baseOffset: 2, extentOffset: 7)));

	_Host() {
		register('available', 'Available');
	}

	Object getContext() {
		reads++;
		return context;
	}

	void result(KlpCommandExecutionResult value) {
		events.add('result');
		(callback ?? results.add)(value);
	}

	void dismiss(KlpCommandPopupDismissReason reason) {
		events.add(reason.name);
		dismissals.add(reason);
	}

	void register(
		String id,
		String label, {
		FutureOr<Object?> Function(Object)? handler,
		bool enabled = true,
		bool visible = true,
		bool checked = false,
	}) {
		Object? execute(Object value) {
			calls++;
			return value;
		}
		bool isEnabled(Object value) => enabled;
		bool isVisible(Object value) => visible;
		bool isChecked(Object value) => checked;
		registry.register(KlpCommandDefinition<Object>(
			id: id,
			label: label,
			handler: handler ?? execute,
			isEnabled: isEnabled,
			isVisible: isVisible,
			isChecked: isChecked,
		));
	}

	void replaceRegistry() {
		retired.add(registry);
		registry = KlpCommandRegistry<Object>();
		register('available', 'Replacement');
	}

	Widget popup() => KlpRegisteredCommandPopup<Object>(
		registry: registry,
		getContext: getContext,
		items: items,
		open: open,
		anchor: anchor,
		label: 'Product commands',
		emptyLabel: 'Empty commands',
		onResult: result,
		onDismiss: dismiss,
	);

	Widget build() {
		final children = <Widget>[_Background(key: backgroundKey, host: this), if (mounted) popup()];
		final content = Directionality(textDirection: direction, child: SizedBox.expand(child: Stack(children: children)));
		return MaterialApp(theme: buildKlpTheme(Brightness.light, style: style), themeAnimationDuration: Duration.zero, home: Scaffold(body: content));
	}

	void dispose() {
		registry.dispose();
		for (final previous in retired) {
			previous.dispose();
		}
		originalFocus.dispose();
		externalFocus.dispose();
		controller.dispose();
	}
}

class _Background extends StatefulWidget {
	const _Background({required this.host, super.key});
	// 產品宿主保有唯一 controller 與焦點。
	final _Host host;
	@override
	State<_Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<_Background> {
	// 此局部值可偵測 modal 是否意外卸載產品 State。
	int count = 0;
	void increment() {
		void update() => count++;
		setState(update);
	}
	@override
	Widget build(BuildContext context) {
		final children = <Widget>[
			Positioned(left: 500, top: 450, width: 220, height: 60, child: ElevatedButton(onPressed: increment, child: const Text('Background navigation'))),
			Positioned(left: 10, top: 450, width: 300, child: TextField(controller: widget.host.controller, focusNode: widget.host.originalFocus, decoration: const InputDecoration(labelText: 'Background input'))),
			Focus(focusNode: widget.host.externalFocus, child: const Text('External owner')),
		];
		// 非 Positioned 焦點文字不得讓背景 Stack 收縮而漏掉產品按鈕的原生 hit region。
		return SizedBox.expand(child: Semantics(container: true, child: Stack(children: children)));
	}
}

Future<void> _frames(WidgetTester tester) async {
	// 有限次 frame 提供原生量測、焦點與語意收斂機會。
	for (var index = 0; index < 4; index++) {
		await tester.pump();
	}
}

Future<void> _show(WidgetTester tester, _Host host) async {
	await tester.pumpWidget(host.build());
	await _frames(tester);
}

Finder _menu() => find.byType(KlpRegisteredCommandMenu<Object>);
Finder _row(String label) => find.bySemanticsLabel(label);
Rect _bounds(WidgetTester tester) => tester.getRect(_menu());

Future<void> _tap(WidgetTester tester, String label) async {
	await tester.tap(_row(label));
	await _frames(tester);
}

SemanticsOwner _owner(WidgetTester tester) {
	final view = tester.binding.renderViews.singleWhere((view) => view.flutterView == tester.view);
	return view.owner!.semanticsOwner!;
}

List<SemanticsNode> _nodes(WidgetTester tester) {
	final nodes = <SemanticsNode>[];
	void visit(SemanticsNode node) {
		nodes.add(node);
		for (final child in node.debugListChildrenInOrder(DebugSemanticsDumpOrder.traversalOrder)) {
			visit(child);
		}
	}
	visit(_owner(tester).rootSemanticsNode!);
	return nodes;
}

void _finite(WidgetTester tester, Size viewport) {
	// 校驗實際原生 Overlay 尺寸；不能只以 setSurfaceSize 的請求值當作有效 viewport。
	final overlay = Overlay.of(tester.element(_menu()));
	expect(tester.getSize(find.byWidget(overlay.widget)), viewport);
	final bounds = _bounds(tester);
	for (final value in [bounds.left, bounds.top, bounds.right, bounds.bottom, bounds.width, bounds.height]) {
		expect(value.isFinite, isTrue, reason: '公開 menu 原生 bounds 必須有限。');
	}
	final allowed = Offset.zero & viewport;
	expect(bounds.left, greaterThanOrEqualTo(allowed.left));
	expect(bounds.top, greaterThanOrEqualTo(allowed.top));
	expect(bounds.right, lessThanOrEqualTo(allowed.right));
	expect(bounds.bottom, lessThanOrEqualTo(allowed.bottom));
	expect(tester.takeException(), isNull);
}

void _test(String name, Future<void> Function(WidgetTester, _Host) body) {
	Future<void> run(WidgetTester tester) async {
		debugDefaultTargetPlatformOverride = TargetPlatform.windows;
		final semantics = tester.ensureSemantics();
		final host = _Host();
		try {
			await body(tester, host);
		} finally {
			await tester.pumpWidget(const SizedBox());
			await _frames(tester);
			await tester.binding.setSurfaceSize(null);
			host.dispose();
			semantics.dispose();
			debugDefaultTargetPlatformOverride = null;
		}
	}
	testWidgets(name, run);
}

void main() {
	Future<void> closedAndInvalid(WidgetTester tester, _Host host) async {
		host.open = false;
		await _show(tester, host);
		expect(host.reads, 0);
		expect(_menu(), findsNothing);
		final anchors = [
			const Rect.fromLTWH(double.nan, 0, 1, 1),
			const Rect.fromLTWH(0, double.infinity, 1, 1),
			const Rect.fromLTWH(0, 0, -1, 1),
			const Rect.fromLTWH(0, 0, 1, -1),
			const Rect.fromLTWH(0, 0, double.infinity, 1),
		];
		for (final anchor in anchors) {
			await tester.pumpWidget(const SizedBox());
			host.anchor = anchor;
			Object? error;
			try {
				await tester.pumpWidget(host.build());
				error = tester.takeException();
			} catch (caught) {
				error = caught;
			}
			expect(error, isArgumentError, reason: '$anchor');
		}
	}
	_test('closed popup does not query and invalid anchors reject', closedAndInvalid);

	Future<void> placement(WidgetTester tester, _Host host) async {
		for (final anchor in [const Rect.fromLTWH(100, 100, 0, 0), const Rect.fromLTWH(100, 100, 80, 30)]) {
			host.anchor = anchor;
			await _show(tester, host);
			_finite(tester, const Size(800, 600));
			expect(_bounds(tester).top, greaterThanOrEqualTo(anchor.bottom));
		}
		host.anchor = const Rect.fromLTWH(100, 580, 80, 10);
		await _show(tester, host);
		_finite(tester, const Size(800, 600));
		expect(_bounds(tester).bottom, lessThanOrEqualTo(host.anchor.top));
		for (final direction in TextDirection.values) {
			host.direction = direction;
			host.anchor = const Rect.fromLTWH(350, 100, 80, 30);
			await _show(tester, host);
			if (direction == TextDirection.ltr) {
				expect(_bounds(tester).left, host.anchor.left);
			} else {
				expect(_bounds(tester).right, host.anchor.right);
			}
			for (final anchor in [
				const Rect.fromLTWH(-100, -100, 0, 0),
				const Rect.fromLTWH(900, 700, 40, 20),
				const Rect.fromLTWH(790, 10, 0, 0),
				const Rect.fromLTWH(10, 590, 0, 0),
				const Rect.fromLTWH(1e300, -1e300, 1e299, 1e299),
			]) {
				host.anchor = anchor;
				await _show(tester, host);
				_finite(tester, const Size(800, 600));
			}
		}
	}
	_test('point and rect prefer below, flip above and remain inside all viewport edges', placement);

	Future<void> constrained(WidgetTester tester, _Host host) async {
		final base = KlpVisualStyle.defaultStyle;
		final largeContent = base.copyWith(
			spacing: base.spacing.copyWith(iconSmall: 500, controlContentGap: 500, overlayItemGap: 500),
			components: base.components.copyWith(menuPadding: 500, buttonPaddingX: 500),
			geometry: base.geometry.copyWith(layout: base.geometry.layout.copyWith(commandMenuWidth: 1e300)),
		);
		final largeInset = base.copyWith(geometry: base.geometry.copyWith(layout: base.geometry.layout.copyWith(overlayViewportInset: 1e300)));
		for (final style in [base, largeContent, largeInset]) {
			host.style = style;
			for (final size in [Size.zero, const Size(1, 1), const Size(120, 40)]) {
				await tester.binding.setSurfaceSize(size);
				await _show(tester, host);
				_finite(tester, size);
				final tokens = tester.element(_menu()).klp;
				expect(tokens.geometry, same(host.style.geometry));
				expect(tokens.component, same(host.style.components));
			}
		}
	}
	_test('zero and narrow viewports with extreme legal style stay finite without mutating style', constrained);

	Future<void> largerSide(WidgetTester tester, _Host host) async {
		final items = <KlpCommandReference>[];
		for (var index = 0; index < 12; index++) {
			host.register('item$index', 'Item $index');
			items.add(KlpCommandReference(commandId: 'item$index'));
		}
		host.items = items;
		host.anchor = const Rect.fromLTWH(100, 140, 0, 0);
		await tester.binding.setSurfaceSize(const Size(400, 220));
		await _show(tester, host);
		_finite(tester, const Size(400, 220));
		expect(_bounds(tester).bottom, lessThanOrEqualTo(host.anchor.top));
		expect(_bounds(tester).height, lessThanOrEqualTo(host.anchor.top));
		final scrollable = find.descendant(of: _menu(), matching: find.byType(Scrollable));
		expect(scrollable, findsWidgets, reason: '兩側都不足時內容仍由原生 scrollport 保留。');
	}
	_test('content exceeding both sides uses the larger finite side and remains scrollable', largerSide);

	Future<void> liveUpdates(WidgetTester tester, _Host host) async {
		await _show(tester, host);
		final focus = FocusManager.instance.primaryFocus;
		final state = host.backgroundKey.currentState;
		final value = host.controller.value;
		final base = KlpVisualStyle.defaultStyle;
		host.style = base.copyWith(geometry: base.geometry.copyWith(layout: base.geometry.layout.copyWith(commandMenuWidth: 200)));
		host.anchor = const Rect.fromLTWH(200, 200, 0, 0);
		host.direction = TextDirection.rtl;
		await tester.binding.setSurfaceSize(const Size(640, 420));
		await _show(tester, host);
		_finite(tester, const Size(640, 420));
		expect(tester.element(_menu()).klp.geometry, same(host.style.geometry));
		expect(Directionality.of(tester.element(_menu())), TextDirection.rtl);
		expect(FocusManager.instance.primaryFocus, same(focus));
		expect(host.backgroundKey.currentState, same(state));
		expect(host.controller.value, value);
		await tester.pumpAndSettle();
		expect(tester.binding.hasScheduledFrame, isFalse);
	}
	_test('anchor native resize and captured caller style updates retain focus and product state', liveUpdates);

	Future<void> menuContract(WidgetTester tester, _Host host) async {
		host.register('toggle', 'Toggle', checked: true);
		host.register('disabled', 'Disabled', enabled: false);
		host.register('hidden', 'Hidden', visible: false);
		host.items = const [
			KlpCommandReference(commandId: 'toggle', kind: KlpCommandKind.toggle),
			KlpCommandReference(commandId: 'disabled'),
			KlpCommandReference(commandId: 'available'),
			KlpCommandReference(commandId: 'hidden'),
		];
		await _show(tester, host);
		final labels = _nodes(tester).map((node) => node.label).where({'Toggle', 'Disabled', 'Available'}.contains).toList();
		expect(labels, ['Toggle', 'Disabled', 'Available']);
		expect(_row('Hidden'), findsNothing);
		expect(tester.getSemantics(_row('Toggle')).hasFlag(SemanticsFlag.isChecked), isTrue);
		expect(tester.getSemantics(_row('Disabled')).hasFlag(SemanticsFlag.isEnabled), isFalse);
		await _tap(tester, 'Disabled');
		expect(host.calls, 0);
		await _tap(tester, 'Available');
		expect(host.results.single.value, same(host.context));
		expect(host.events, ['result', 'executed']);
	}
	_test('same registered menu preserves supplied order checked state gates and original result', menuContract);

	Future<void> controlled(WidgetTester tester, _Host host) async {
		await _show(tester, host);
		for (var attempt = 0; attempt < 2; attempt++) {
			await tester.sendKeyEvent(LogicalKeyboardKey.escape);
			await _frames(tester);
			await tester.tapAt(const Offset(610, 480));
			await _frames(tester);
			await _tap(tester, 'Available');
		}
		expect(host.dismissals, [KlpCommandPopupDismissReason.escape, KlpCommandPopupDismissReason.outside, KlpCommandPopupDismissReason.executed]);
		expect(host.calls, 2);
		expect(_menu(), findsOneWidget);
		expect(host.backgroundKey.currentState!.count, 0);
		host.open = false;
		await _show(tester, host);
		expect(_menu(), findsNothing);
		host.open = true;
		await _show(tester, host);
		await tester.sendKeyEvent(LogicalKeyboardKey.escape);
		await _frames(tester);
		expect(host.dismissals.last, KlpCommandPopupDismissReason.escape);
		expect(host.dismissals.length, 4);
	}
	_test('controlled intents deduplicate per session while ignored dismissal stays operable', controlled);

	Future<void> errors(WidgetTester tester, _Host host) async {
		final original = StateError('handler failure');
		Object? fail(Object value) => throw original;
		host.register('failure', 'Failure', handler: fail);
		host.items = const [KlpCommandReference(commandId: 'failure'), KlpCommandReference(commandId: 'available')];
		await _show(tester, host);
		await _tap(tester, 'Failure');
		expect(host.results.single.error, same(original));
		expect(host.results.single.status, KlpCommandExecutionStatus.error);
		expect(host.dismissals, isEmpty);
		final callbackError = StateError('product callback');
		void throwCallback(KlpCommandExecutionResult result) => throw callbackError;
		host.callback = throwCallback;
		await _show(tester, host);
		await _tap(tester, 'Available');
		expect(tester.takeException(), same(callbackError));
		expect(host.dismissals, isEmpty);
		expect(_menu(), findsOneWidget);
	}
	_test('handler errors remain open and product callback errors use native error channel', errors);

	for (final transition in ['close', 'reopen', 'unmount', 'replacement']) {
		Future<void> stale(WidgetTester tester, _Host host) async {
			final pending = Completer<Object?>();
			var slowCalls = 0;
			Object? slow(Object value) {
				slowCalls++;
				return pending.future;
			}
			host.register('slow', 'Slow', handler: slow);
			host.items = const [KlpCommandReference(commandId: 'slow'), KlpCommandReference(commandId: 'available')];
			await _show(tester, host);
			await _tap(tester, 'Slow');
			expect(tester.getSemantics(_row('Slow')).hasFlag(SemanticsFlag.isEnabled), isFalse);
			await _tap(tester, 'Slow');
			expect(slowCalls, 1);
			if (transition == 'replacement') {
				host.replaceRegistry();
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
			pending.complete(host.context);
			await _frames(tester);
			expect(host.results, isEmpty);
			expect(host.dismissals, isEmpty);
			if (transition == 'reopen' || transition == 'replacement') {
				expect(_menu(), findsOneWidget);
				await _tap(tester, transition == 'replacement' ? 'Replacement' : 'Available');
				expect(host.dismissals, [KlpCommandPopupDismissReason.executed]);
			}
			expect(tester.takeException(), isNull);
		}
		_test('pending completion cannot affect the current owner after $transition', stale);
	}

	for (final transition in ['close', 'unmount']) {
		Future<void> restoration(WidgetTester tester, _Host host) async {
			host.open = false;
			await _show(tester, host);
			await tester.tap(find.text('Background navigation'));
			host.originalFocus.requestFocus();
			await _frames(tester);
			final state = host.backgroundKey.currentState;
			final value = host.controller.value;
			host.open = true;
			await _show(tester, host);
			expect(host.originalFocus.hasFocus, isFalse);
			for (var attempt = 0; attempt < 3; attempt++) {
				await tester.sendKeyEvent(LogicalKeyboardKey.tab);
				await _frames(tester);
				expect(host.originalFocus.hasFocus || host.externalFocus.hasFocus, isFalse);
			}
			bool backgroundAction(SemanticsNode node) {
				final data = node.getSemanticsData();
				return node.label.contains('Background') && (data.hasAction(SemanticsAction.tap) || data.hasAction(SemanticsAction.setText) || data.hasAction(SemanticsAction.focus));
			}
			expect(_nodes(tester).where(backgroundAction), isEmpty);
			if (transition == 'close') {
				host.open = false;
			} else {
				host.mounted = false;
			}
			await _show(tester, host);
			expect(host.originalFocus.hasFocus, isTrue);
			expect(host.backgroundKey.currentState, same(state));
			expect(state!.count, 1);
			expect(host.controller.value, value);
			await tester.tap(find.text('Background navigation'));
			await _frames(tester);
			expect(state.count, 2);
			expect(host.registry.getState('available', host.context), isNotNull);
			expect(host.dismissals, isEmpty);
			await tester.pumpAndSettle();
			expect(tester.binding.hasScheduledFrame, isFalse, reason: '已解除的 owner 不得持續安排量測 frame。');
		}
		_test('Windows modal isolates semantics and Tab then restores focus and background state on $transition', restoration);
	}

	Future<void> externalFocus(WidgetTester tester, _Host host) async {
		host.open = false;
		await _show(tester, host);
		host.originalFocus.requestFocus();
		await _frames(tester);
		host.open = true;
		await _show(tester, host);
		host.externalFocus.requestFocus();
		await _frames(tester);
		host.open = false;
		await _show(tester, host);
		expect(host.externalFocus.hasFocus, isTrue);
		expect(host.originalFocus.hasFocus, isFalse);
	}
	_test('closing does not steal focus moved to another product owner', externalFocus);

	Future<void> namedDismiss(WidgetTester tester, _Host host) async {
		await _show(tester, host);
		final nativeLabel = MaterialLocalizations.of(tester.element(find.byType(Scaffold))).modalBarrierDismissLabel;
		bool dismissAction(SemanticsNode node) {
			final data = node.getSemanticsData();
			return data.hasAction(SemanticsAction.dismiss) || ((node.label == nativeLabel || node.label == 'Product commands') && data.hasAction(SemanticsAction.tap));
		}
		final dismissers = _nodes(tester).where(dismissAction).toList();
		expect(dismissers, isNotEmpty, reason: 'Windows 必須公開可命名且可操作的原生 dismiss。');
		for (final node in dismissers) {
			expect(node.label.trim(), isNotEmpty);
			final action = node.getSemanticsData().hasAction(SemanticsAction.dismiss) ? SemanticsAction.dismiss : SemanticsAction.tap;
			_owner(tester).performAction(node.id, action);
			await _frames(tester);
		}
		expect(host.dismissals, [KlpCommandPopupDismissReason.outside]);
		expect(host.calls, 0);
		expect(host.backgroundKey.currentState!.count, 0);
		final available = _nodes(tester).singleWhere((node) => node.label == 'Available' && node.getSemanticsData().hasAction(SemanticsAction.tap));
		_owner(tester).performAction(available.id, SemanticsAction.tap);
		await _frames(tester);
		expect(host.calls, 1);
		expect(host.dismissals.last, KlpCommandPopupDismissReason.executed);
	}
	_test('Windows named native dismiss and command actions remain accessible without background click through', namedDismiss);
}
