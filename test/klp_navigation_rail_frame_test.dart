import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('navigation rail frame is an explicit shell composition', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpNavigationRailFrame(
          child: KlpNavigationRail(
            top: KlpRailItemGroup(
              id: 'top',
              items: [
                KlpRailButtonEntry(
                  id: 'home',
                  icon: KlpIcons.inbox,
                  label: 'Home',
                  onPressed: () {},
                ),
                KlpRailButtonEntry(
                  id: 'search',
                  icon: KlpIcons.search,
                  label: 'Search',
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

    expect(find.byType(KlpNavigationRailFrame), findsOneWidget);
    expect(find.byType(KlpNavigationRail), findsOneWidget);
    final home = tester.getRect(find.byKey(const ValueKey('home')));
    final search = tester.getRect(find.byKey(const ValueKey('search')));
    expect(search.top - home.bottom, 8);
  });
}
