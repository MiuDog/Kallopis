import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('navigation rail 只在原群組內回報重新排序', (tester) async {
    (int, int)? reordered;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: SizedBox(
          width: 80,
          height: 400,
          child: KlpNavigationRail(
            top: KlpRailItemGroup(
              id: 'top',
              onReorder: (oldIndex, newIndex) {
                reordered = (oldIndex, newIndex);
              },
              items: [
                KlpRailButtonEntry(
                  id: 'first',
                  icon: KlpIcons.inbox,
                  label: 'First',
                  onPressed: () {},
                ),
                KlpRailButtonEntry(
                  id: 'second',
                  icon: KlpIcons.search,
                  label: 'Second',
                  onPressed: () {},
                ),
                KlpRailButtonEntry(
                  id: 'third',
                  icon: KlpIcons.settings,
                  label: 'Third',
                  onPressed: () {},
                ),
              ],
            ),
            center: const KlpRailItemGroup(id: 'center', items: []),
            bottom: const KlpRailItemGroup(id: 'bottom', items: []),
          ),
        ),
      ),
    );

    final first = tester.getCenter(find.byKey(const ValueKey('first')));
    final third = tester.getRect(find.byKey(const ValueKey('third')));
    final gesture = await tester.startGesture(first);
    await gesture.moveTo(Offset(third.center.dx, third.bottom - 1));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(reordered, (0, 2));
  });

  testWidgets('navigation rail center 保持無捲軸且內容靠上', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: SizedBox(
          width: 80,
          height: 240,
          child: KlpNavigationRail(
            top: const KlpRailItemGroup(id: 'top', items: []),
            center: KlpRailItemGroup(
              id: 'center',
              items: [
                KlpRailButtonEntry(
                  id: 'center-item',
                  icon: KlpIcons.inbox,
                  label: 'Center',
                  onPressed: () {},
                ),
              ],
            ),
            bottom: const KlpRailItemGroup(id: 'bottom', items: []),
          ),
        ),
      ),
    );

    expect(find.byType(Scrollbar), findsNothing);
    final rail = tester.getRect(find.byType(KlpNavigationRail));
    final item = tester.getRect(find.byKey(const ValueKey('center-item')));
    expect(item.center.dy, lessThan(rail.center.dy));
  });
}
