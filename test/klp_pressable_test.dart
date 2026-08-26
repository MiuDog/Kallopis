import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('rest 什麼都不畫，hover 畫虛線而非填色', (tester) async {
    await tester.pumpWidget(_fixture(selected: false));

    expect(_stateHighlight, findsNothing);
    expect(_hoverBorder, findsNothing);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.byType(KlpPressable)));
    await tester.pump();

    // 準則 §2.1：hover 是暫時的，用 1px dashed；填色留給 selected。
    expect(_hoverBorder, findsOneWidget);
    expect(_stateHighlight, findsNothing);
  });

  testWidgets('selected 用填色，且不是 accent', (tester) async {
    await tester.pumpWidget(_fixture(selected: true));

    final context = tester.element(find.byType(KlpPressable));
    final selected = context.klp.selectedSurface;

    // 準則第 5 條：accent 不得用於 selected。
    expect(
      selected.toARGB32(),
      isNot(context.klp.color.interaction.toARGB32()),
    );
    expect(_highlightColor(tester), selected);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.byType(KlpPressable)));
    await tester.pump();

    // selected 優先於 hover——已經選取的東西不該因為指標經過而改變外觀。
    expect(_highlightColor(tester), selected);
    expect(_hoverBorder, findsNothing);
  });
}

Finder get _stateHighlight => find.byKey(const ValueKey('klp-state-highlight'));

Finder get _hoverBorder => find.byKey(const ValueKey('klp-state-hover-border'));

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
