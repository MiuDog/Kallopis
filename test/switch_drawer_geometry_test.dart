import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {

	test('switch and drawer dimensions copy independently and round trip', () {
		final base = KlpVisualStyle.defaultStyle;
		final control = base.geometry.control;
		final layout = base.geometry.layout;
		expect([control.switchTrackWidth, control.switchTrackHeight, control.switchThumb], [36, 20, 16]);
		expect([layout.drawerWidth, layout.drawerHeight], [320, 320]);
		final cases = <(String, String, KlpGeometryTheme)>[
			('control', 'switchTrackWidth', base.geometry.copyWith(control: control.copyWith(switchTrackWidth: 48))),
			('control', 'switchTrackHeight', base.geometry.copyWith(control: control.copyWith(switchTrackHeight: 48))),
			('control', 'switchThumb', base.geometry.copyWith(control: control.copyWith(switchThumb: 48))),
			('layout', 'drawerWidth', base.geometry.copyWith(layout: layout.copyWith(drawerWidth: 48))),
			('layout', 'drawerHeight', base.geometry.copyWith(layout: layout.copyWith(drawerHeight: 48))),
		];
		final original = KlpVisualStyleJson.encode(base);
		for (final (group, key, geometry) in cases) {
			final encoded = KlpVisualStyleJson.encode(base.copyWith(geometry: geometry));
			final expected = <Object?, Object?>{...(original['geometry'] as Map)[group] as Map, key: 48.0};
			expect((encoded['geometry'] as Map)[group], expected);
			expect(encoded['spacing'], original['spacing']);
			expect((encoded['spacing'] as Map).containsKey(key), isFalse);
			expect(geometry, isNot(base.geometry));
			expect(geometry.control.copyWith(), geometry.control);
			expect(geometry.control.copyWith().hashCode, geometry.control.hashCode);
			expect(geometry.layout.copyWith(), geometry.layout);
			expect(geometry.layout.copyWith().hashCode, geometry.layout.hashCode);
			expect(base.geometry.lerp(geometry, 0.49), base.geometry);
			expect(base.geometry.lerp(geometry, 0.5), geometry);
			expect(KlpVisualStyleJson.encode(KlpVisualStyleJson.decode(encoded)), encoded);
		}
	});

	test('legacy dimensions migrate from spacing with explicit geometry precedence', () {
		for (final version in <int?>[null, 1, 2]) {
			final spacing = <String, Object?>{
				'switchTrackWidth': 46,
				'switchTrackHeight': 26,
				'switchThumb': 18,
				'drawerWidth': 360,
				'drawerHeight': 280,
			};
			final input = <String, Object?>{
				'spacing': spacing,
				'geometry': {'control': {'switchThumb': 20}, 'layout': {'drawerHeight': 300}},
			};
			if (version != null) input['schemaVersion'] = version;

			final decoded = KlpVisualStyleJson.decode(input);
			final control = decoded.geometry.control;
			final layout = decoded.geometry.layout;
			expect([control.switchTrackWidth, control.switchTrackHeight, control.switchThumb], [46, 26, 20]);
			expect([layout.drawerWidth, layout.drawerHeight], [360, 300]);
			expect(spacing.length, 5);
			expect(spacing['switchThumb'], 18);
			expect(KlpVisualStyleJson.encode(decoded)['schemaVersion'], 3);
		}
	});

	test('dimension migration preserves omitted base values and reports invalid paths', () {
		final standard = KlpVisualStyle.defaultStyle;
		final base = standard.copyWith(geometry: standard.geometry.copyWith(control: standard.geometry.control.copyWith(switchThumb: 19)));
		expect(KlpVisualStyleJson.decode({'schemaVersion': 2, 'spacing': {'drawerWidth': 444}}, base: base).geometry.control.switchThumb, 19);
		expect(() => KlpVisualStyleJson.decode({'schemaVersion': 2, 'spacing': {'switchThumb': -1}}), throwsA(isA<FormatException>().having((error) => error.message, 'path', contains('spacing.switchThumb'))));
		expect(() => KlpVisualStyleJson.decode({'schemaVersion': 3, 'spacing': {'drawerWidth': 320}}), throwsA(isA<FormatException>().having((error) => error.message, 'path', contains('spacing.drawerWidth'))));
		expect(() => KlpVisualStyleJson.decode({'schemaVersion': 3, 'geometry': {'layout': {'drawerHeight': -1}}}), throwsA(isA<FormatException>().having((error) => error.message, 'path', contains('geometry.layout.drawerHeight'))));
	});

	testWidgets('compact switch preserves defaults and follows independently injected geometry', (tester) async {
		final base = KlpVisualStyle.defaultStyle;
		final custom = base.copyWith(geometry: base.geometry.copyWith(control: base.geometry.control.copyWith(switchTrackWidth: 52, switchTrackHeight: 28, switchThumb: 18)));
		bool? changed;
		for (final style in [base, custom]) {
			await tester.pumpWidget(MaterialApp(
				theme: buildKlpTheme(Brightness.light, style: style),
				themeAnimationDuration: Duration.zero,
				home: Material(child: Center(child: KlpCompactSwitch(value: false, label: 'Toggle', onChanged: (value) => changed = value))),
			));
			final control = style.geometry.control;
			expect(tester.getSize(find.byType(KlpCompactSwitch)), Size(control.switchTrackWidth, control.switchTrackHeight));
			expect(find.byWidgetPredicate((widget) => widget is SizedBox && widget.width == control.switchThumb && widget.height == control.switchThumb), findsOneWidget);
			changed = null;
			await tester.tap(find.byType(KlpCompactSwitch));
			expect(changed, isTrue);
		}
		await tester.pumpWidget(MaterialApp(home: Material(child: Center(child: KlpCompactSwitch(value: true, label: 'Disabled', onChanged: null)))));
		changed = null;
		await tester.tap(find.byType(KlpCompactSwitch));
		expect(changed, isNull);
	});

	testWidgets('drawer geometry applies to all edges and explicit size wins', (tester) async {
		final base = KlpVisualStyle.defaultStyle;
		final custom = base.copyWith(geometry: base.geometry.copyWith(layout: base.geometry.layout.copyWith(drawerWidth: 360, drawerHeight: 280)));
		for (final style in [base, custom]) {
			for (final edge in KlpDrawerEdge.values) {
				for (final size in <double?>[null, 210]) {
					await tester.pumpWidget(MaterialApp(
						theme: buildKlpTheme(Brightness.light, style: style),
						themeAnimationDuration: Duration.zero,
						home: KlpDrawer(open: true, edge: edge, size: size, onScrimTap: () {}, child: const SizedBox.expand()),
					));
					final slide = tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));
					final panel = slide.child! as KlpBox;
					final horizontal = edge == KlpDrawerEdge.left || edge == KlpDrawerEdge.right;
					expect(horizontal ? panel.width : panel.height, size ?? (horizontal ? style.geometry.layout.drawerWidth : style.geometry.layout.drawerHeight));
					expect(tester.takeException(), isNull);
				}
			}
		}
	});
}
