import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('pressable rest 透明且 hover 使用 Kallopis 中性高亮', (tester) async {
    await tester.pumpWidget(_fixture(selected: false));

    expect(_stateHighlight, findsNothing);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.byType(KlpPressable)));
    await tester.pump();

    final context = tester.element(find.byType(KlpPressable));
    expect(_highlightColor(tester), context.klp.selectionWash);
  });

  testWidgets('pressable selected 使用半透明選取色並優先於 hover', (tester) async {
    await tester.pumpWidget(_fixture(selected: true));

    final context = tester.element(find.byType(KlpPressable));
    final selectedColor = context.klp.selectedWash;
    expect(selectedColor.a, lessThan(1));
    expect(selectedColor.r, context.klp.color.interaction.r);
    expect(_highlightColor(tester), selectedColor);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.byType(KlpPressable)));
    await tester.pump();

    expect(_highlightColor(tester), selectedColor);
  });
}

Finder get _stateHighlight =>
    find.byKey(const ValueKey('klp-pressable-state-highlight'));

Color _highlightColor(WidgetTester tester) {
  final decoration =
      tester.widget<DecoratedBox>(_stateHighlight).decoration as BoxDecoration;
  return decoration.color!;
}

Widget _fixture({required bool selected}) {
  return MaterialApp(
    theme: buildKlpTheme(Brightness.light),
    home: Scaffold(
      body: KlpPressable(
        selected: selected,
        onPressed: () {},
        child: const SizedBox(width: 160, height: 48),
      ),
    ),
  );
}
