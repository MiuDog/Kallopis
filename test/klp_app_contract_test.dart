import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {

	testWidgets('lightStyle and darkStyle remain complete consumer styles', (tester) async {
		final lightStyle = KlpVisualStyle.defaultStyle.copyWith(
			name: 'consumer-light',
			colors: KlpThemeData.dark,
			dataVisualization: KlpDataVisualizationTheme.dark,
		);
		final darkStyle = KlpVisualStyle.defaultStyle.copyWith(
			name: 'consumer-dark',
			colors: KlpThemeData.light,
			dataVisualization: KlpDataVisualizationTheme.light,
		);
		late KlpAppController controller;
		late KlpTheme resolved;

		await tester.pumpWidget(
			KlpApp(
				startMaximized: false,
				showWindowHeader: false,
				lightStyle: lightStyle,
				darkStyle: darkStyle,
				home: KlpPanelFrame(
					padding: EdgeInsets.zero,
					content: Builder(
						builder: (context) {
							controller = KlpApp.of(context);
							resolved = context.klp;
							return const SizedBox.shrink();
						},
					),
				),
			),
		);

		expect(resolved.color.surface.toARGB32(), KlpThemeData.dark.surface.toARGB32());
		expect(resolved.dataVisualization.axis.toARGB32(), KlpDataVisualizationTheme.dark.axis.toARGB32());

		controller.setThemeMode(ThemeMode.dark);
		await tester.pump();

		expect(resolved.color.surface.toARGB32(), KlpThemeData.light.surface.toARGB32());
		expect(resolved.dataVisualization.axis.toARGB32(), KlpDataVisualizationTheme.light.axis.toARGB32());
	});

	testWidgets('legacy style retains non-color layers and built-in palettes', (tester) async {
		final spacing = KlpSpacingTheme.comfortableDensity.copyWith(base: 13);
		final style = KlpVisualStyle.defaultStyle.copyWith(
			colors: KlpThemeData.light,
			spacing: spacing,
		);
		late KlpTheme resolved;

		await tester.pumpWidget(
			KlpApp(
				startMaximized: false,
				showWindowHeader: false,
				initialThemeMode: ThemeMode.dark,
				style: style,
				home: KlpPanelFrame(
					padding: EdgeInsets.zero,
					content: Builder(
						builder: (context) {
							resolved = context.klp;
							return const SizedBox.shrink();
						},
					),
				),
			),
		);

		expect(resolved.color.surface.toARGB32(), KlpThemeData.dark.surface.toARGB32());
		expect(resolved.space.base, 13);
	});

	testWidgets('system mode rebuilds when platform brightness changes', (tester) async {
		addTearDown(tester.platformDispatcher.clearAllTestValues);
		tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
		late KlpAppController controller;
		late KlpThemeData colors;

		await tester.pumpWidget(
			KlpApp(
				startMaximized: false,
				showWindowHeader: false,
				initialThemeMode: ThemeMode.system,
				home: KlpPanelFrame(
					padding: EdgeInsets.zero,
					content: Builder(
						builder: (context) {
							controller = KlpApp.of(context);
							colors = context.klpColors;
							return const SizedBox.shrink();
						},
					),
				),
			),
		);

		expect(controller.brightness, Brightness.light);
		expect(colors.surface.toARGB32(), KlpThemeData.light.surface.toARGB32());

		tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
		await tester.pump();

		expect(controller.brightness, Brightness.dark);
		expect(colors.surface.toARGB32(), KlpThemeData.dark.surface.toARGB32());
	});

	testWidgets('consumer localization delegate overrides built-in values', (tester) async {
		late KlpLocalizations resolved;

		await tester.pumpWidget(
			KlpApp(
				startMaximized: false,
				showWindowHeader: false,
				localizationsDelegates: const [
					KlpLocalizationsDelegate(
						KlpLocalizations(windowCloseLabel: 'Close from consumer'),
					),
				],
				home: KlpPanelFrame(
					padding: EdgeInsets.zero,
					content: Builder(
						builder: (context) {
							resolved = KlpLocalizations.of(context);
							return const SizedBox.shrink();
						},
					),
				),
			),
		);

		expect(resolved.windowCloseLabel, 'Close from consumer');
	});
}
