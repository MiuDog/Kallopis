import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  Widget buildSubject({
    required VoidCallback? onPressed,
    bool selected = false,
  }) {
    return MaterialApp(
      theme: buildKlpTheme(Brightness.light),
      home: Scaffold(
        body: SizedBox(
          width: 240,
          child: KlpSidebarNavigationButton(
            icon: KlpIcons.folder,
            label: 'Project',
            selected: selected,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  testWidgets('fills the sidebar width and owns its control height', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(onPressed: () {}));

    final size = tester.getSize(find.byType(KlpSidebarNavigationButton));
    final context = tester.element(find.byType(KlpSidebarNavigationButton));

    expect(size.width, 240);
    expect(size.height, context.klp.space.controlHeightSmall);
    expect(find.text('Project'), findsOneWidget);
    expect(find.byType(KlpIcon), findsOneWidget);
  });

  testWidgets('separates the navigation icon box from its glyph', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(onPressed: () {}));

    final iconBox = find.byKey(const ValueKey(klpNavigationIconBoxKey));
    final glyph = find.byType(KlpIcon);

    expect(iconBox, findsOneWidget);
    expect(tester.getSize(iconBox), const Size.square(20));
    expect(tester.getSize(glyph), const Size.square(18));
  });

  testWidgets('matches the approved navigation icon proportions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(240, 36));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildSubject(onPressed: () {}));

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
      buildSubject(selected: true, onPressed: () => pressed = true),
    );

    final semantics = tester.getSemantics(
      find.byType(KlpSidebarNavigationButton),
    );
    expect(semantics.flagsCollection.isSelected, Tristate.isTrue);

    await tester.tap(find.text('Project'));
    expect(pressed, isTrue);
  });
}
