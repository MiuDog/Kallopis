import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('disabled menu item cannot invoke its action', (tester) async {
    var enabledCount = 0;
    var disabledCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpMenu(
            label: 'Page actions',
            items: [
              KlpMenuItemData(
                label: 'Enabled',
                onPressed: () => enabledCount++,
              ),
              KlpMenuItemData(
                label: 'Disabled',
                enabled: false,
                onPressed: () => disabledCount++,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Disabled'));
    await tester.pump();
    expect(disabledCount, 0);

    await tester.tap(find.text('Enabled'));
    await tester.pump();
    expect(enabledCount, 1);
  });

  testWidgets('menu item renders a compact trailing toggle state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpMenu(
            label: 'Folder actions',
            items: [
              KlpMenuItemData(
                label: 'Offline available',
                toggleValue: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    final toggle = tester.widget<KlpToggleIndicator>(
      find.byType(KlpToggleIndicator),
    );
    expect(toggle.value, isTrue);
  });

  testWidgets('submenu item renders a trailing disclosure indicator', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpMenu(
            label: 'Plan resources',
            items: [
              KlpMenuItemData(
                label: '建立 Page',
                hasSubmenu: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('pln-menu-submenu-indicator')),
      findsOneWidget,
    );
  });

  testWidgets('programmatic selection uses the menu active surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpMenu(
            label: 'Block types',
            items: [
              KlpMenuItemData(
                label: 'Heading 2',
                selected: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    final itemMaterial = tester.widget<Material>(
      find
          .ancestor(of: find.text('Heading 2'), matching: find.byType(Material))
          .first,
    );
    final tokens = KlpThemeContext(
      tester.element(find.text('Heading 2')),
    ).klpColors;
    expect(itemMaterial.color, tokens.hoverSurface);
  });
}
