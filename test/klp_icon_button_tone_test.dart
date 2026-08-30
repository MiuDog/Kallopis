import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadKlpIconFont);

  const buttonKey = ValueKey('icon-button');

  Widget buildSubject({KlpIconButtonTone? tone, bool selected = false}) {
    final button = tone == null
        ? KlpIconButton(
            key: buttonKey,
            icon: KlpIcons.edit,
            label: 'Edit',
            onPressed: () {},
            selected: selected,
          )
        : KlpIconButton(
            key: buttonKey,
            icon: KlpIcons.edit,
            label: 'Edit',
            onPressed: () {},
            selected: selected,
            tone: tone,
          );

    return MaterialApp(
      theme: buildKlpTheme(Brightness.light),
      home: Scaffold(body: Center(child: button)),
    );
  }

  Color? background(WidgetTester tester) {
    final material = find.descendant(
      of: find.byKey(buttonKey),
      matching: find.byType(Material),
    );

    return tester.widget<Material>(material).color;
  }

  testWidgets('default tone preserves the standalone resting background', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    final button = tester.widget<KlpIconButton>(find.byKey(buttonKey));
    final context = tester.element(find.byKey(buttonKey));

    expect(button.tone, KlpIconButtonTone.standalone);
    expect(background(tester), context.klpColors.component);
  });

  testWidgets('inline tone rests transparent', (tester) async {
    await tester.pumpWidget(buildSubject(tone: KlpIconButtonTone.inline));

    final context = tester.element(find.byKey(buttonKey));
    expect(background(tester), context.klp.color.clear);
  });

  testWidgets('inline tone keeps the shared hover and focus feedback', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(tone: KlpIconButtonTone.inline));
    final context = tester.element(find.byKey(buttonKey));
    final activeBackground = Color.alphaBlend(
      context.klp.selectionWash,
      context.klpColors.component,
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.byKey(buttonKey)));
    await tester.pump();
    expect(background(tester), activeBackground);

    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(background(tester), context.klp.color.clear);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(background(tester), activeBackground);
  });

  testWidgets('inline selected state keeps the shared selection feedback', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(tone: KlpIconButtonTone.inline, selected: true),
    );

    final context = tester.element(find.byKey(buttonKey));
    expect(background(tester), context.klpColors.selectionBackground);
  });

  testWidgets('matches the approved resting tones', (tester) async {
    await tester.binding.setSurfaceSize(const Size(80, 40));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Scaffold(
          body: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                KlpIconButton(
                  icon: KlpIcons.edit,
                  label: 'Standalone',
                  onPressed: () {},
                ),
                KlpIconButton(
                  icon: KlpIcons.edit,
                  label: 'Inline',
                  onPressed: () {},
                  tone: KlpIconButtonTone.inline,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Row),
      matchesGoldenFile('goldens/klp_icon_button_tones_light.png'),
    );
  });
}
