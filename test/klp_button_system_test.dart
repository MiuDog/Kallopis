import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

void main() {
	testWidgets('KlpButton 預設為 sm 且 compact 為 xs', (tester) async {
		for (final style in [KlpVisualStyle.defaultStyle, contrastingStyle]) {
			await tester.pumpWidget(_sizeSpecimen(style));

			expect(tester.getSize(_button(const ValueKey('default'))).height, style.spacing.controlHeightSmall);
			expect(tester.getSize(_button(const ValueKey('compact'))).height, style.spacing.controlHeightXSmall);
		}
	});

	testWidgets('KlpButton hover 與 selected 使用不同語意 wash', (tester) async {
		await tester.pumpWidget(_stateSpecimen());
		final rest = _background(tester, const ValueKey('rest'));

		final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
		await mouse.addPointer();
		await mouse.moveTo(tester.getCenter(_button(const ValueKey('rest'))));
		await tester.pumpAndSettle();
		final hovered = _background(tester, const ValueKey('rest'));
		final selected = _background(tester, const ValueKey('selected'));

		expect(hovered, isNot(rest));
		expect(selected, isNot(rest));
		expect(selected, isNot(hovered));
		expect(tester.getSemantics(_button(const ValueKey('selected'))).flagsCollection.isSelected, Tristate.isTrue);
	});

	test('primary 降低表面反差但維持文字 AA 對比', () {
		for (final tokens in [KlpThemeData.light, KlpThemeData.dark]) {
			final lowered = _contrast(tokens.interactionSoft, tokens.surface);
			final previous = _contrast(tokens.interaction, tokens.surface);
			final text = _contrast(tokens.interaction, tokens.interactionSoft);

			expect(lowered, lessThan(previous));
			expect(text, greaterThanOrEqualTo(4.5));
		}
	});

	testWidgets('全部 selected tone 在暗色模式維持緊湊布局', (tester) async {
		for (final tone in KlpButtonTone.values) {
			await tester.pumpWidget(_isolatedButton(tone: tone, selected: true));
			expect(tester.takeException(), isNull, reason: '${tone.name} selected overflow');
		}
	});

	testWidgets('全部尺寸在暗色模式維持內容布局', (tester) async {
		for (final size in KlpControlSize.values) {
			await tester.pumpWidget(_isolatedButton(size: size));
			expect(tester.takeException(), isNull, reason: '${size.name} overflow');
		}
	});
}

Widget _sizeSpecimen(KlpVisualStyle style) {
	final home = Row(
		children: [
			KlpButton(key: const ValueKey('default'), label: 'Default', onPressed: _noop),
			KlpButton(key: const ValueKey('compact'), label: 'Compact', compact: true, onPressed: _noop),
		],
	);
	return MaterialApp(key: ValueKey(style.name), theme: buildKlpTheme(Brightness.light, style: style), home: home);
}

Widget _stateSpecimen() {
	final home = Row(
		children: [
			KlpButton(key: const ValueKey('rest'), label: 'Rest', tone: KlpButtonTone.secondary, onPressed: _noop),
			KlpButton(key: const ValueKey('selected'), label: 'Selected', tone: KlpButtonTone.secondary, selected: true, onPressed: _noop),
		],
	);
	return MaterialApp(theme: buildKlpTheme(Brightness.light), home: home);
}

Widget _isolatedButton({KlpButtonTone tone = KlpButtonTone.primary, KlpControlSize? size, bool selected = false}) {
	final home = Center(child: KlpButton(label: 'Button', tone: tone, size: size, selected: selected, onPressed: _noop));
	return MaterialApp(theme: buildKlpTheme(Brightness.dark), home: home);
}

Color _background(WidgetTester tester, Key key) {
	final button = _button(key);
	final containers = find.descendant(of: button, matching: find.byType(Container));
	final surface = tester.widgetList<Container>(containers).firstWhere((widget) => widget.decoration is BoxDecoration);
	return (surface.decoration! as BoxDecoration).color!;
}

Finder _button(Key key) => find.byWidgetPredicate((widget) => widget is KlpButton && widget.key == key);

double _contrast(Color first, Color second) {
	final bright = first.computeLuminance() + 0.05;
	final dark = second.computeLuminance() + 0.05;
	return bright > dark ? bright / dark : dark / bright;
}

void _noop() {}
