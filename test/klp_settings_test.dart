import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  Widget app(Widget child) => MaterialApp(
    theme: buildKlpTheme(Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('settings page 依 semantic breakpoint 切換版面', (tester) async {
    Future<void> pumpAt(double width) => tester.pumpWidget(
      app(
        SizedBox(
          width: width,
          height: 600,
          child: const KlpSettingsPage(
            navigation: SizedBox(key: ValueKey('navigation')),
            content: SizedBox(key: ValueKey('content')),
          ),
        ),
      ),
    );

    await pumpAt(1000);
    expect(
      find.byKey(const ValueKey('klp-settings-two-column')),
      findsOneWidget,
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('content'))).dx,
      greaterThan(
        tester.getTopLeft(find.byKey(const ValueKey('navigation'))).dx,
      ),
    );

    await pumpAt(700);
    expect(
      find.byKey(const ValueKey('klp-settings-single-column')),
      findsOneWidget,
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('content'))).dy,
      greaterThan(
        tester.getTopLeft(find.byKey(const ValueKey('navigation'))).dy,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation item 只在選取時建立 field deep links', (tester) async {
    Widget item(bool selected) => app(
      KlpSettingsNavigationItem(
        title: 'Appearance',
        selected: selected,
        onPressed: () {},
        children: const [KlpText('Color mode', key: ValueKey('field-link'))],
      ),
    );

    await tester.pumpWidget(item(false));
    expect(find.byKey(const ValueKey('field-link')), findsNothing);

    await tester.pumpWidget(item(true));
    expect(find.byKey(const ValueKey('field-link')), findsOneWidget);

    final surface = tester.widget<KlpSurface>(
      find.byKey(const ValueKey('klp-settings-field-guide')),
    );
    expect(surface.border, isNotNull);
  });

  testWidgets('content pane 將 footer 保留在捲動區外', (tester) async {
    await tester.pumpWidget(
      app(
        const SizedBox(
          width: 700,
          height: 500,
          child: KlpSettingsContentPane(
            title: 'Appearance',
            description: 'Choose a color mode.',
            footer: SizedBox(key: ValueKey('footer')),
            child: SizedBox(height: 900, key: ValueKey('long-content')),
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byKey(const ValueKey('footer')),
      ),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('footer')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme mode picker 呈現所有選項並回報選取', (tester) async {
    KlpThemePreviewMode? selected;
    const options = [
      KlpThemeModeOption(
        mode: KlpThemePreviewMode.light,
        label: 'Light',
        description: 'Paper white',
      ),
      KlpThemeModeOption(
        mode: KlpThemePreviewMode.dark,
        label: 'Dark',
        description: 'Warm dark',
      ),
      KlpThemeModeOption(
        mode: KlpThemePreviewMode.ultraDark,
        label: 'Ultra Dark',
        description: 'True black',
      ),
      KlpThemeModeOption(
        mode: KlpThemePreviewMode.system,
        label: 'System',
        description: 'Follow system',
      ),
      KlpThemeModeOption(
        mode: KlpThemePreviewMode.transparent,
        label: 'Transparent',
        description: 'Desktop material',
      ),
    ];

    await tester.pumpWidget(
      app(
        KlpThemeModePicker(
          options: options,
          selected: KlpThemePreviewMode.light,
          onSelected: (value) => selected = value,
        ),
      ),
    );

    expect(find.byType(KlpThemePreviewTile), findsNWidgets(options.length));
    await tester.tap(find.byKey(const ValueKey('theme-preview-dark')));
    expect(selected, KlpThemePreviewMode.dark);
  });

  testWidgets('settings field 的強調色只使用 semantic surface tone', (tester) async {
    await tester.pumpWidget(
      app(
        const KlpSettingsField(
          title: 'Color mode',
          description: 'Choose how surfaces are rendered.',
          highlighted: true,
          child: KlpText('Control'),
        ),
      ),
    );

    final surface = tester.widget<KlpSurface>(find.byType(KlpSurface));
    expect(surface.tone, KlpSurfaceTone.muted);
  });

  testWidgets('settings action bar 在窄寬度會重排動作而不 overflow', (tester) async {
    await tester.pumpWidget(
      app(
        SizedBox(
          width: 260,
          child: KlpSettingsActionBar(
            message: 'Unsaved changes remain',
            actions: [
              KlpButton(label: 'Reset', compact: true, onPressed: () {}),
              KlpButton(label: 'Save', compact: true, onPressed: () {}),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
