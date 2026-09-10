import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'support/load_test_fonts.dart';
import 'support/sidebar_navigation_button_background.dart';
import 'support/sidebar_navigation_button_subject.dart';

void main() {
	setUpAll(loadKlpTestFonts);

	testWidgets('fills the sidebar width and owns its control height', (
		tester,
	) async {
		await tester.pumpWidget(
			SidebarNavigationButtonSubject(onPressed: () {}),
		);

		final size = tester.getSize(find.byType(KlpSidebarNavigationButton));
		final context = tester.element(find.byType(KlpSidebarNavigationButton));

		expect(size.width, 240);
		expect(size.height, context.klp.space.controlHeightXSmall);
		expect(find.text('Project'), findsOneWidget);
		expect(find.byType(KlpIcon), findsOneWidget);
	});

	testWidgets('matches explorer icon and text sizing', (tester) async {
		await tester.pumpWidget(
			SidebarNavigationButtonSubject(onPressed: () {}),
		);

		final iconBox = find.byKey(const ValueKey(klpNavigationIconBoxKey));
		final glyph = find.byType(KlpIcon);
		final tokens = tester.element(iconBox).klp.space;

		expect(iconBox, findsOneWidget);
		expect(tester.getSize(iconBox), Size.square(tokens.iconSmall));
		expect(tester.getSize(glyph), Size.square(tokens.iconSmall));
		expect(
			tester.widget<KlpText>(find.widgetWithText(KlpText, 'Project')).role,
			KlpTextRole.code,
		);
	});

	testWidgets('matches the approved navigation icon proportions', (
		tester,
	) async {
		await tester.binding.setSurfaceSize(const Size(240, 30));
		addTearDown(() => tester.binding.setSurfaceSize(null));
		await tester.pumpWidget(
			SidebarNavigationButtonSubject(onPressed: () {}),
		);

		await expectLater(
			find.byType(KlpSidebarNavigationButton),
			matchesGoldenFile('goldens/klp_sidebar_navigation_button_light.png'),
		);
	});

	testWidgets('exposes selection and dispatches the navigation event', (
		tester,
	) async {
		var pressed = false;
		await tester.pumpWidget(
			SidebarNavigationButtonSubject(
				selected: true,
				onPressed: () => pressed = true,
			),
		);

		final semantics = tester.getSemantics(
			find.byType(KlpSidebarNavigationButton),
		);
		expect(semantics.flagsCollection.isSelected, Tristate.isTrue);

		await tester.tap(find.text('Project'));
		expect(pressed, isTrue);
	});

	for (final brightness in Brightness.values) {
		testWidgets(
			'hover and selection share the text-colored wash in ${brightness.name}',
			(tester) async {
				await tester.pumpWidget(
					SidebarNavigationButtonSubject(
						onPressed: () {},
						selected: true,
						brightness: brightness,
					),
				);
				final selectedContext = tester.element(
					find.byType(KlpSidebarNavigationButton),
				);
				final selectedBackground = sidebarNavigationButtonBackground(tester);
				expect(selectedBackground, selectedContext.klp.selectionWash);
				expect(
					selectedBackground,
					selectedContext.klpColors.text.withValues(
						alpha: selectedContext.klp.surface.selectionWashOpacity,
					),
				);
				expect(
					tester
							.widget<KlpText>(find.widgetWithText(KlpText, 'Project'))
							.color,
					selectedContext.klpColors.text,
				);
				expect(
					tester.widget<KlpIcon>(find.byType(KlpIcon)).color,
					selectedContext.klpColors.text,
				);

				await tester.pumpWidget(
					SidebarNavigationButtonSubject(
						onPressed: () {},
						brightness: brightness,
					),
				);
				final idleContext = tester.element(
					find.byType(KlpSidebarNavigationButton),
				);
				expect(
					tester
							.widget<KlpText>(find.widgetWithText(KlpText, 'Project'))
							.color,
					idleContext.klpColors.text,
				);
				expect(
					tester.widget<KlpIcon>(find.byType(KlpIcon)).color,
					idleContext.klpColors.textMuted,
				);

				final mouse = await tester.createGesture(
					kind: PointerDeviceKind.mouse,
				);
				addTearDown(mouse.removePointer);
				await mouse.addPointer();
				await mouse.moveTo(
					tester.getCenter(find.byType(KlpSidebarNavigationButton)),
				);
				await tester.pump();
				expect(
					sidebarNavigationButtonBackground(tester),
					selectedBackground,
				);
			},
		);
	}

	testWidgets('navigation group places adjacent buttons without a gap', (
		tester,
	) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: Scaffold(
					body: SizedBox(
						width: 240,
						child: KlpSidebarNavigationGroup(
							children: [
								KlpSidebarNavigationButton(
									key: const ValueKey('first-navigation-button'),
									icon: KlpIcons.folder,
									label: 'First',
									onPressed: () {},
								),
								KlpSidebarNavigationButton(
									key: const ValueKey('second-navigation-button'),
									icon: KlpIcons.clipboard,
									label: 'Second',
									onPressed: () {},
								),
							],
						),
					),
				),
			),
		);

		final first = tester.getRect(
			find.byKey(const ValueKey('first-navigation-button')),
		);
		final second = tester.getRect(
			find.byKey(const ValueKey('second-navigation-button')),
		);

		expect(second.top, first.bottom);
	});
}
