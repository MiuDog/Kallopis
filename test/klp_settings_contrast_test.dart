import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

void main() {
	testWidgets('Settings 所有顏色模式都維持左深右淺與可讀文字', (tester) async {
		final themes = <(String, ThemeData)>[
			for (final variant in KlpThemeVariant.values) (variant.name, buildKlpThemeVariant(variant)),
			('contrasting', buildKlpTheme(Brightness.dark, style: contrastingStyle)),
		];
		for (final (label, theme) in themes) {
			await tester.pumpWidget(_specimen(theme));

			final navigation = find.byType(KlpSettingsNavigationPane);
			final content = find.byType(KlpSettingsContentPane);
			final navigationColor = _background(tester, navigation);
			final contentColor = _background(tester, content);
			expect(navigationColor.computeLuminance(), lessThan(contentColor.computeLuminance()), reason: label);
			expect(_contrast(navigationColor, _textColor(tester, const ValueKey('navigation-text'))), greaterThanOrEqualTo(4.5), reason: '$label navigation');
			expect(_contrast(contentColor, _textColor(tester, const ValueKey('content-text'))), greaterThanOrEqualTo(4.5), reason: '$label content');
			expect(tester.takeException(), isNull);
		}
	});

	testWidgets('Settings 雙 pane 間距使用縮小後的 space200 幾何', (tester) async {
		await tester.pumpWidget(_specimen(buildKlpTheme(Brightness.light)));

		final page = find.byType(KlpSettingsPage);
		final layout = tester.element(page).klp.geometry.layout;
		final navigation = tester.getRect(find.byType(KlpSettingsNavigationPane));
		final content = tester.getRect(find.byType(KlpSettingsContentPane));
		expect(layout.settingsPaneGap, KlpScale.space200);
		expect(content.left - navigation.right, layout.settingsPaneGap);
	});
}

Widget _specimen(ThemeData theme) {
	final page = KlpSettingsPage(
		navigation: const KlpSettingsNavigationPane(children: [KlpText('Navigation', key: ValueKey('navigation-text'))]),
		content: const KlpSettingsContentPane(title: 'Settings', child: KlpText('Content', key: ValueKey('content-text'))),
	);
	return MaterialApp(theme: theme, home: SizedBox(width: 1000, height: 600, child: page));
}

Color _background(WidgetTester tester, Finder pane) {
	final surface = find.descendant(of: pane, matching: find.byType(KlpSurface)).first;
	final boxes = tester.widgetList<DecoratedBox>(find.descendant(of: surface, matching: find.byType(DecoratedBox)));
	return (boxes.first.decoration as BoxDecoration).color!;
}

Color _textColor(WidgetTester tester, Key key) {
	final text = find.descendant(of: find.byKey(key), matching: find.byType(Text));
	return tester.widget<Text>(text).style!.color!;
}

double _contrast(Color first, Color second) {
	final bright = first.computeLuminance() + 0.05;
	final dark = second.computeLuminance() + 0.05;
	return bright > dark ? bright / dark : dark / bright;
}
