import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis_catalog/catalog/registry.dart';
import 'package:kallopis_catalog/catalog/settings_pages.dart';
import 'package:kallopis_catalog/catalog/token_pages.dart';
import 'package:kallopis_catalog/catalog_shell.dart';

void main() {
  test('Catalog 登錄顏色模式與全部 Settings 公開元件', () {
    expect(
      catalogGroups.singleWhere((group) => group.label == 'Colors').pages,
      contains(colorModesPage),
    );
    expect(
      settingsPage.specimens.map((specimen) => specimen.name),
      containsAll({
        'KlpSettingsPage',
        'KlpSettingsNavigationPane',
        'KlpSettingsContentPane',
        'KlpSettingsNavigationGroup',
        'KlpSettingsNavigationItem',
        'KlpSettingsField',
        'KlpSettingsActionBar',
        'KlpThemeModePicker',
      }),
    );
  });

  testWidgets('Settings Catalog 在窄版不 overflow', (tester) async {
    tester.view.physicalSize = const Size(760, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: CatalogShell(
          groups: catalogGroups,
          pages: catalogPages,
          selected: catalogPages.indexOf(settingsPage),
          onSelected: (_) {},
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(KlpSettingsPage), findsWidgets);
  });
}
