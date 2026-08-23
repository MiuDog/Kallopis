import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('block 共通基底提供 hover 與 clicked 高亮', (tester) async {
    final hoverStates = <bool>[];
    var selected = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Center(
              child: KlpBlock(
                selected: selected,
                handleLabel: 'Block actions',
                onHandlePressed: (_) {},
                onHover: hoverStates.add,
                onPressed: () => setState(() => selected = true),
                child: const KlpText('一般段落'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('klp-block-highlight')), findsNothing);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.byType(KlpBlock)));
    await tester.pump();

    expect(hoverStates, contains(true));
    expect(find.byKey(const ValueKey('klp-block-highlight')), findsOneWidget);

    await tester.tap(find.text('一般段落'));
    await tester.pump();

    expect(selected, isTrue);
    expect(find.byKey(const ValueKey('klp-block-highlight')), findsOneWidget);
  });

  testWidgets('六點操作鈕回報全域座標並提供可選拖曳手勢', (tester) async {
    Offset? menuAnchor;
    var dragDelta = Offset.zero;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Scaffold(
          body: KlpBlock(
            handleLabel: 'Block actions',
            onHandlePressed: (position) => menuAnchor = position,
            onHandleDragUpdate: (details) => dragDelta += details.delta,
            onPressed: () {},
            child: const KlpText('表格'),
          ),
        ),
      ),
    );

    final handle = find.byKey(const ValueKey('klp-block-handle'));
    final icon = tester.widget<KlpIcon>(
      find.descendant(of: handle, matching: find.byType(KlpIcon)),
    );

    expect(icon.asset, KlpIcons.gripVertical);

    await tester.tap(handle);
    await tester.drag(handle, const Offset(60, 40));
    await tester.pump();

    expect(menuAnchor, isNotNull);
    expect(dragDelta, isNot(Offset.zero));
  });
}
