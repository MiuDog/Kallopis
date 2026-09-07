import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {

	testWidgets('adaptive selects the explicit platform and other fallback', (tester) async {
		for (final hasOther in [true, false]) {
			for (final platform in KlpAppPlatform.values) {
				final calls = <String>[];
				final adaptive = KlpAdaptive(
					windows: (_) { calls.add('windows'); return const _ProbePanel('windows'); },
					android: (_) { calls.add('android'); return const _ProbePanel('android'); },
					other: hasOther ? (_) { calls.add('other'); return const _ProbePanel('other'); } : null,
				);
				await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: KlpEnvironmentScope(platform: KlpPlatformInfo(platform: platform), child: adaptive)));
				final expected = switch (platform) {
					KlpAppPlatform.windows => 'windows',
					KlpAppPlatform.android => 'android',
					_ => hasOther ? 'other' : 'windows',
				};
				expect(calls, [expected], reason: '$platform with other=$hasOther');
				expect(find.text(expected), findsOneWidget);
			}
		}
	});

	testWidgets('adaptive requires environment even when other is supplied', (tester) async {
		await tester.pumpWidget(KlpAdaptive(
			windows: (_) => const _ProbePanel('windows'),
			android: (_) => const _ProbePanel('android'),
			other: (_) => const _ProbePanel('other'),
		));
		expect(tester.takeException(), isA<StateError>());
	});

	testWidgets('adaptive rebuilds for platform changes but not legacy app theme changes', (tester) async {
		var adaptiveBuilds = 0;
		var environmentBuilds = 0;
		var appBuilds = 0;
		final controller = _TestAppController();
		final adaptive = KlpAdaptive(
			windows: (_) { adaptiveBuilds++; return const _ProbePanel('windows'); },
			android: (_) { adaptiveBuilds++; return const _ProbePanel('android'); },
		);
		final children = Column(children: [
			adaptive,
			Builder(builder: (context) {
				environmentBuilds++;
				context.klpPlatform;
				return const SizedBox.shrink();
			}),
			Builder(builder: (context) {
				appBuilds++;
				KlpApp.of(context);
				return const SizedBox.shrink();
			}),
		]);

		// 舊 AppScope 與環境 scope 各自更新，固定子樹以量測訂閱通知。
		Future<void> pump(KlpAppPlatform platform) async {
			await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: KlpAppScope(
				controller: controller,
				platform: const KlpPlatformInfo(platform: KlpAppPlatform.windows),
				brightness: controller.brightness,
				themeMode: controller.themeMode,
				child: KlpEnvironmentScope(platform: KlpPlatformInfo(platform: platform), child: children),
			)));
		}
		await pump(KlpAppPlatform.windows);
		expect([adaptiveBuilds, environmentBuilds, appBuilds], [1, 1, 1]);
		controller.currentBrightness = Brightness.dark;
		await pump(KlpAppPlatform.windows);
		expect([adaptiveBuilds, environmentBuilds, appBuilds], [1, 1, 2]);
		controller.currentMode = ThemeMode.system;
		await pump(KlpAppPlatform.windows);
		expect([adaptiveBuilds, environmentBuilds, appBuilds], [1, 1, 3]);
		await pump(KlpAppPlatform.android);
		expect([adaptiveBuilds, environmentBuilds, appBuilds], [2, 2, 3]);
		expect(find.text('android'), findsOneWidget);
	});

	testWidgets('local constraints choose layout without changing the adaptive platform', (tester) async {
		var windowsBuilds = 0;
		var androidBuilds = 0;
		final adaptive = KlpAdaptive(
			windows: (_) { windowsBuilds++; return const _ProbePanel('windows', responsive: true); },
			android: (_) { androidBuilds++; return const _ProbePanel('android', responsive: true); },
		);
		Future<void> pump(double width, KlpAppPlatform platform) async {
			await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: MediaQuery(
				data: const MediaQueryData(size: Size(1200, 800)),
				child: Align(alignment: Alignment.topLeft, child: SizedBox(width: width, height: 100, child: KlpEnvironmentScope(platform: KlpPlatformInfo(platform: platform), child: adaptive))),
			)));
		}
		await pump(700, KlpAppPlatform.windows);
		expect(find.text('windows wide'), findsOneWidget);
		await pump(300, KlpAppPlatform.windows);
		expect(find.text('windows narrow'), findsOneWidget);
		expect([windowsBuilds, androidBuilds], [1, 0]);
		await pump(300, KlpAppPlatform.android);
		expect(find.text('android narrow'), findsOneWidget);
		expect([windowsBuilds, androidBuilds], [1, 1]);
	});
}

class _ProbePanel extends StatelessWidget implements KlpPanelLayout {

	final String label;
	final bool responsive;

	const _ProbePanel(this.label, {this.responsive = false});

	@override
	Widget build(BuildContext context) {
		if (!responsive) return Text(label);

		return LayoutBuilder(builder: (context, constraints) => Text('$label ${constraints.maxWidth >= 600 ? 'wide' : 'narrow'}'));
	}

	@override
	Widget buildPanelLayout(BuildContext context) => build(context);
}

class _TestAppController implements KlpAppController {

	Brightness currentBrightness = Brightness.light;
	ThemeMode currentMode = ThemeMode.light;
	final KlpKeyBindingController keyBindingController = KlpKeyBindingController();

	@override
	Brightness get brightness => currentBrightness;
	@override
	ThemeMode get themeMode => currentMode;
	@override
	KlpKeyBindingController get keyBindings => keyBindingController;
	@override
	void setThemeMode(ThemeMode mode) => currentMode = mode;
	@override
	void toggleBrightness() => currentBrightness = currentBrightness == Brightness.light ? Brightness.dark : Brightness.light;
}
