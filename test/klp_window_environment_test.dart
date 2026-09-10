import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {

	Widget testBed({required KlpAppPlatform environment, required Widget child}) {
		return MaterialApp(
			theme: buildKlpTheme(Brightness.light).copyWith(platform: TargetPlatform.windows),
			home: KlpEnvironmentScope(
				platform: KlpPlatformInfo(platform: environment),
				child: Scaffold(body: child),
			),
		);
	}

	testWidgets('adaptive controls prefer environment scope over Material theme', (tester) async {
		const minimizeKey = ValueKey('minimize');
		const closeKey = ValueKey('close');

		await tester.pumpWidget(
			testBed(
				environment: KlpAppPlatform.macos,
				child: KlpWindowControls(
					onMinimize: () {},
					onToggleMaximize: () {},
					onClose: () {},
					minimizeKey: minimizeKey,
					closeKey: closeKey,
				),
			),
		);

		expect(tester.getTopLeft(find.byKey(closeKey)).dx, lessThan(tester.getTopLeft(find.byKey(minimizeKey)).dx));
	});

	testWidgets('window header prefers environment and keeps explicit override', (tester) async {
		await tester.pumpWidget(
			testBed(
				environment: KlpAppPlatform.macos,
				child: const KlpWindowHeader(titleText: 'Environment'),
			),
		);

		expect(tester.widget<KlpWindowControls>(find.byType(KlpWindowControls)).style, KlpWindowControlsStyle.macOS);

		await tester.pumpWidget(
			testBed(
				environment: KlpAppPlatform.macos,
				child: const KlpWindowHeader(
					titleText: 'Explicit',
					platform: KlpAppPlatform.windows,
				),
			),
		);

		expect(tester.widget<KlpWindowControls>(find.byType(KlpWindowControls)).style, KlpWindowControlsStyle.windows);
	});

	testWidgets('explicit controls style wins over environment scope', (tester) async {
		const minimizeKey = ValueKey('minimize');
		const closeKey = ValueKey('close');

		await tester.pumpWidget(
			testBed(
				environment: KlpAppPlatform.macos,
				child: KlpWindowControls(
					onMinimize: () {},
					onToggleMaximize: () {},
					onClose: () {},
					style: KlpWindowControlsStyle.windows,
					minimizeKey: minimizeKey,
					closeKey: closeKey,
				),
			),
		);

		expect(tester.getTopLeft(find.byKey(minimizeKey)).dx, lessThan(tester.getTopLeft(find.byKey(closeKey)).dx));
	});
}
