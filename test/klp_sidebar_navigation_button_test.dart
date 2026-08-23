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
