
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 此宿主與資料僅屬於回歸測試；語意容器模擬產品獨立的背景導航。
class _Host {
	final registry = KlpCommandRegistry<Object>();
	final backgroundKey = GlobalKey<_BackgroundState>();
	final controller = TextEditingController.fromValue(const TextEditingValue(text: 'Original product value', selection: TextSelection(baseOffset: 2, extentOffset: 8)));
	final dismissals = <KlpCommandDismissReason>[];
	bool open = false;
	bool mounted = true;
	int backgroundCalls = 0;
	int commandCalls = 0;
	int backgroundMounts = 0;

	_Host() {
		registry.register(KlpCommandDefinition<Object>(id: 'available', label: 'Available command', handler: (_) => ++commandCalls));
	}

	Widget build() {
		final children = <Widget>[
			_Background(key: backgroundKey, host: this),
			if (mounted) KlpRegisteredCommandPalette<Object>(
				registry: registry,
				getContext: () => this,
				open: open,
				label: 'Product commands',
				searchLabel: 'Search commands',
				emptyLabel: 'No commands',
				onResult: (_) {},
				onDismiss: dismissals.add,
			),
		];
		return MaterialApp(theme: buildKlpTheme(Brightness.light), home: Scaffold(body: SizedBox.expand(child: Stack(children: children))));
	}

	void dispose() {
		registry.dispose();
		controller.dispose();
	}
}

class _Background extends StatefulWidget {
	const _Background({required this.host, super.key});
	final _Host host;

	@override
	State<_Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<_Background> {
	int count = 0;

	@override
	void initState() {
		super.initState();
		widget.host.backgroundMounts++;
	}

	@override
	Widget build(BuildContext context) {
		void updateCount() {
			count++;
			widget.host.backgroundCalls++;
		}
		void navigate() => setState(updateCount);
		final children = <Widget>[
			Positioned(
				left: 120, top: 320,
				width: 160, height: 60,
				child: ElevatedButton(onPressed: navigate, child: const Text('Background navigation')),
			),
			Positioned(
				left: 10, top: 450, width: 300,
				child: TextField(controller: widget.host.controller, decoration: const InputDecoration(labelText: 'Background input')),
			),
		];
		return Semantics(container: true, child: Stack(children: children));
	}
}

Future<void> _frames(WidgetTester tester) async {
	await tester.pump();
	await tester.pump();
}

Future<void> _show(WidgetTester tester, _Host host) async {
	await tester.pumpWidget(host.build());
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
	// 只檢查原生 View 對外送出的樹；已掛載但被排除的個別節點不算可操作。
	visit(_owner(tester).rootSemanticsNode!);
	return nodes;
}

SemanticsNode _actionable(WidgetTester tester, String label) {
	bool matches(SemanticsNode node) => node.label == label && node.getSemanticsData().hasAction(SemanticsAction.tap);
	return _nodes(tester).singleWhere(matches);
}

void _test(String name, Future<void> Function(WidgetTester, _Host) body) {
	Future<void> run(WidgetTester tester) async {
		debugDefaultTargetPlatformOverride = TargetPlatform.windows;
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
				debugDefaultTargetPlatformOverride = null;
			}
		}
	}
	testWidgets(name, run);
}

void main() {
	Future<void> backgroundIsolation(WidgetTester tester, _Host host) async {
		await _show(tester, host);
		_actionable(tester, 'Background navigation');
		host.open = true;
		await _show(tester, host);
		bool backgroundAction(SemanticsNode node) {
			final data = node.getSemanticsData();
			return node.label.contains('Background') && (
				data.hasAction(SemanticsAction.tap) ||
				data.hasAction(SemanticsAction.focus) ||
				data.hasAction(SemanticsAction.setText)
			);
		}
		expect(_nodes(tester).where(backgroundAction), isEmpty, reason: '開啟的 modal 不得在原生可存取樹留下可操作背景。');
		final candidate = _actionable(tester, 'Available command');
		_owner(tester).performAction(candidate.id, SemanticsAction.tap);
		await _frames(tester);
		expect(host.commandCalls, 1);
		expect(host.backgroundCalls, 0);
		expect(host.dismissals, [KlpCommandDismissReason.executed]);
	}
	_test('Windows modal excludes background actions while candidate remains actionable', backgroundIsolation);

	Future<void> scrimPointer(WidgetTester tester, _Host host) async {
		host.open = true;
		await _show(tester, host);
		// 此座標落在背景導航上、面板外；必須由 scrim 接住原生 pointer。
		await tester.tapAt(const Offset(200, 350));
		await _frames(tester);
		expect(host.dismissals, [KlpCommandDismissReason.outside]);
		expect(host.backgroundCalls, 0);
		expect(host.commandCalls, 0);
	}
	_test('Windows scrim pointer dismisses outside without invoking background navigation', scrimPointer);

	Future<void> nativeDismissal(WidgetTester tester, _Host host) async {
		host.open = true;
		await _show(tester, host);
		final nativeLabel = MaterialLocalizations.of(tester.element(find.byType(Scaffold))).modalBarrierDismissLabel;
		bool dismissalAction(SemanticsNode node) {
			final data = node.getSemanticsData();
			return data.hasAction(SemanticsAction.dismiss) || (
				(node.label == 'Product commands' || node.label == nativeLabel) &&
				data.hasAction(SemanticsAction.tap)
			);
		}
		final dismissers = _nodes(tester).where(dismissalAction).toList();
		expect(dismissers, isNotEmpty, reason: 'Windows 原生可存取入口必須能提出 modal outside dismiss。');
		for (final node in dismissers) {
			expect(node.label.trim(), isNotEmpty);
			final action = node.getSemanticsData().hasAction(SemanticsAction.dismiss)
				? SemanticsAction.dismiss : SemanticsAction.tap;
			_owner(tester).performAction(node.id, action);
			await _frames(tester);
		}
		expect(host.dismissals, List.filled(dismissers.length, KlpCommandDismissReason.outside));
		expect(host.backgroundCalls, 0);
		expect(host.commandCalls, 0);
	}
	_test('Windows exposes a named native dismissal action that only requests outside', nativeDismissal);

	for (final transition in ['close', 'unmount']) {
		Future<void> restoration(WidgetTester tester, _Host host) async {
			await _show(tester, host);
			final background = _actionable(tester, 'Background navigation');
			_owner(tester).performAction(background.id, SemanticsAction.tap);
			await _frames(tester);
			final state = host.backgroundKey.currentState!;
			final originalValue = host.controller.value;
			host.open = true;
			await _show(tester, host);
			expect(host.backgroundKey.currentState, same(state));
			expect(state.count, 1);
			expect(host.controller.value, originalValue);
			if (transition == 'close') {
				host.open = false;
			} else {
				host.mounted = false;
			}
			await _show(tester, host);
			expect(host.backgroundKey.currentState, same(state));
			expect(host.backgroundMounts, 1);
			expect(host.controller.value, originalValue);
			final restored = _actionable(tester, 'Background navigation');
			_owner(tester).performAction(restored.id, SemanticsAction.tap);
			await _frames(tester);
			expect(state.count, 2);
			expect(host.backgroundCalls, 2);
			expect(host.dismissals, isEmpty);
		}
		_test('Windows background semantics and product state return after $transition', restoration);
	}
}
