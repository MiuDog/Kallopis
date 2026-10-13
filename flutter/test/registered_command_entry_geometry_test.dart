import 'dart:async';
import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 測試只透過公開入口與原生布局；產品資料由此宿主持有。
class _Context {
	bool checked = true;
}

class _Host {
	_Host(this.menu);
	final bool menu;
	// 同一產品權威與編輯控制器必須跨尺寸、風格重建保存。
	final registry = KlpCommandRegistry<_Context>();
	final context = _Context();
	final controller = TextEditingController.fromValue(const TextEditingValue(
		text: 'product text',
		selection: TextSelection(baseOffset: 1, extentOffset: 4),
	));
	final results = <KlpCommandExecutionResult>[];
	KlpVisualStyle style = KlpVisualStyle.defaultStyle;
	Size size = const Size(400, 180);
	final items = const [
		KlpCommandReference(commandId: 'toggle', kind: KlpCommandKind.toggle),
		KlpCommandReference(commandId: 'plain'),
		KlpCommandReference(commandId: 'disabled'),
		KlpCommandReference(commandId: 'hidden'),
	];
	_Context getContext() => context;
	Object? getValue(_Context value) => value;

	Widget entry() {
		if (menu) {
			return KlpRegisteredCommandMenu<_Context>(
				registry: registry,
				getContext: getContext,
				items: items,
				label: 'Commands',
				emptyLabel: 'Empty',
				onResult: results.add,
			);
		}
		return KlpRegisteredCommandToolbar<_Context>(
			registry: registry,
			getContext: getContext,
			items: items,
			label: 'Commands',
			onResult: results.add,
		);
	}

	Widget build() => MaterialApp(
		theme: buildKlpTheme(Brightness.light, style: style),
		themeAnimationDuration: Duration.zero,
		home: Scaffold(body: Stack(children: [
			Positioned(
				left: 0,
				top: 0,
				width: 300,
				height: 50,
				child: TextField(controller: controller),
			),
			Positioned(
				left: 0,
				top: 60,
				width: size.width,
				height: size.height,
				child: Align(alignment: Alignment.topLeft, child: entry()),
			),
		])),
	);

	void register({Completer<Object?>? pending}) {
		Object? toggle(_Context value) => pending?.future ?? value;
		bool checked(_Context value) => value.checked;
		bool disabled(_Context value) => false;
		registry.register(KlpCommandDefinition<_Context>(
			id: 'toggle',
			label: 'Toggle',
			icon: KlpIcons.check,
			handler: toggle,
			isChecked: checked,
		));
		registry.register(KlpCommandDefinition<_Context>(id: 'plain', label: 'Plain', handler: getValue));
		registry.register(KlpCommandDefinition<_Context>(
			id: 'disabled',
			label: 'Disabled',
			handler: getValue,
			isEnabled: disabled,
		));
		registry.register(KlpCommandDefinition<_Context>(
			id: 'hidden',
			label: 'Hidden',
			handler: getValue,
			isVisible: disabled,
		));
	}
	void dispose() {
		registry.dispose();
		controller.dispose();
	}
}

KlpVisualStyle _extreme(String part) {
	final base = KlpVisualStyle.defaultStyle;
	if (part == 'outer') return base.copyWith(spacing: base.spacing.copyWith(tight: 500));
	if (part == 'padding') return base.copyWith(components: base.components.copyWith(menuPadding: 500, buttonPaddingX: 500));
	return base.copyWith(
		spacing: base.spacing.copyWith(
			tight: 0,
			iconSmall: 500,
			controlContentGap: 500,
			overlayItemGap: 500,
		),
		components: base.components.copyWith(menuPadding: 0, buttonPaddingX: 0),
		geometry: base.geometry.copyWith(layout: base.geometry.layout.copyWith(commandMenuWidth: 5000)),
	);
}

Finder _entry(_Host host) => find.byType(host.menu ? KlpRegisteredCommandMenu<_Context> : KlpRegisteredCommandToolbar<_Context>);
Finder _row(String label) => find.bySemanticsLabel(label);
Future<void> _show(WidgetTester tester, _Host host) async {
	await tester.pumpWidget(host.build());
	await tester.pump();
}
List<String> _order(WidgetTester tester) {
	final labels = <String>[];
	void visit(SemanticsNode node) {
		if (const {'Toggle', 'Plain', 'Disabled'}.contains(node.label)) labels.add(node.label);
		for (final child in node.debugListChildrenInOrder(DebugSemanticsDumpOrder.traversalOrder)) {
			visit(child);
		}
	}
	final view = tester.binding.renderViews.singleWhere((view) => view.flutterView == tester.view);
	visit(view.owner!.semanticsOwner!.rootSemanticsNode!);
	return labels;
}
void _test(String name, bool menu, Future<void> Function(WidgetTester, _Host) body) {
	Future<void> run(WidgetTester tester) async {
		final semantics = tester.ensureSemantics();
		final host = _Host(menu);
		try {
			await body(tester, host);
		} finally {
			await tester.pumpWidget(const SizedBox());
			host.dispose();
			semantics.dispose();
		}
	}
	testWidgets(name, run);
}
Future<void> _finite(WidgetTester tester, _Host host) async {
	final name = host.menu ? 'menu' : 'toolbar';
	host.register();
	for (final style in [KlpVisualStyle.defaultStyle, _extreme('outer'), _extreme('padding'), _extreme('content')]) {
		host.style = style;
		for (final size in [Size.zero, const Size(1, 1), const Size(12, 8), const Size(120, 40)]) {
			host.size = size;
			await _show(tester, host);
			expect(tester.takeException(), isNull, reason: '$name $size must not overflow or fail native layout');
			final actual = tester.getSize(_entry(host));
			expect(actual.width.isFinite && actual.height.isFinite, isTrue);
			expect(actual.width, lessThanOrEqualTo(size.width));
			expect(actual.height, lessThanOrEqualTo(size.height));
			final icons = find.descendant(of: _entry(host), matching: find.byType(KlpIcon));
			for (final icon in icons.evaluate()) {
				expect(tester.getSize(find.byWidget(icon.widget)).width, lessThanOrEqualTo(size.width / 2));
			}
			// 有效幾何不得寫回原風格 extension。
			final resolved = tester.element(_entry(host)).klp;
			expect(resolved.space, same(style.spacing));
			expect(resolved.component, same(style.components));
			expect(resolved.geometry, same(style.geometry));
		}
	}
}

Future<void> _standard(WidgetTester tester, _Host host) async {
	host.register();
	await _show(tester, host);
	final icon = find.descendant(of: _row('Toggle'), matching: find.byType(KlpIcon));
	final plainIcon = find.descendant(of: _row('Plain'), matching: find.byType(KlpIcon));
	expect(icon, findsOneWidget);
	expect(plainIcon, findsNothing);
	expect(tester.getSize(icon).width, host.style.spacing.iconSmall);
	final tokens = tester.element(_entry(host)).klp;
	final inset = host.menu ? tokens.menuPadding : tokens.buttonInsets.left;
	final plainLeft = tester.getTopLeft(find.text('Plain')).dx - tester.getTopLeft(_row('Plain')).dx;
	expect(plainLeft, closeTo(inset, 0.001));
	if (host.menu) expect(tester.getSize(_entry(host)).width, host.style.geometry.layout.commandMenuWidth);
	expect(tester.takeException(), isNull);
}

Future<void> _updates(WidgetTester tester, _Host host) async {
	final pending = Completer<Object?>();
	host.register(pending: pending);
	await _show(tester, host);
	final editingState = tester.state(find.byType(EditableText));
	final editingValue = host.controller.value;
	final entryElement = tester.element(_entry(host));
	await tester.tap(_row('Toggle'));
	await tester.pump();
	await tester.tap(_row('Plain'));
	await tester.pump();
	final focus = FocusManager.instance.primaryFocus;
	expect(focus, isNotNull);
	host.results.clear();
	host.style = _extreme('content');
	host.size = const Size(120, 90);
	await _show(tester, host);
	expect(tester.takeException(), isNull);
	expect(FocusManager.instance.primaryFocus, same(focus));
	expect(tester.state(find.byType(EditableText)), same(editingState));
	expect(host.controller.value, editingValue);
	expect(tester.element(_entry(host)), same(entryElement));
	expect(host.registry.getState('toggle', host.context)!.running, isTrue);
	// 還原足量槽後，語意順序與原權限仍來自同 registry。
	host.style = KlpVisualStyle.defaultStyle;
	host.size = const Size(400, 180);
	await _show(tester, host);
	expect(FocusManager.instance.primaryFocus, same(focus));
	expect(_order(tester), ['Toggle', 'Plain', 'Disabled']);
	expect(_row('Hidden'), findsNothing);
	expect(tester.getSemantics(_row('Toggle')).flagsCollection.isChecked == CheckedState.isTrue, isTrue);
	expect(tester.getSemantics(_row('Toggle')).flagsCollection.isEnabled == Tristate.isTrue, isFalse);
	expect(tester.getSemantics(_row('Disabled')).flagsCollection.isEnabled == Tristate.isTrue, isFalse);
	await tester.sendKeyEvent(LogicalKeyboardKey.enter);
	await tester.pump();
	expect(host.results.single.commandId, 'plain');
	expect(host.results.single.value, same(host.context));
	pending.complete(host.context);
	await tester.pump();
	await tester.pump();
	expect(host.results.last.commandId, 'toggle');
	expect(host.results.last.value, same(host.context));
	expect(tester.getSemantics(_row('Toggle')).flagsCollection.isEnabled == Tristate.isTrue, isTrue);
	expect(tester.takeException(), isNull);
}

void main() {
	for (final menu in [false, true]) {
		final name = menu ? 'menu' : 'toolbar';
		_test('$name accepts zero and narrow finite slots with extreme legal geometry', menu, _finite);
		_test('$name preserves standard geometry and gives icon-free text no decorative slot', menu, _standard);
		_test('$name style and size updates retain product state, focus, pending and command semantics', menu, _updates);
	}
}
