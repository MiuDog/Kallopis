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

  testWidgets('settings dialog 在桌面尺寸使用固定 pane 幾何', (tester) async {
    tester.view.physicalSize = const Size(1920, 1032);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      app(
        const KlpSettingsDialog(
          child: KlpSettingsPage(
            navigation: SizedBox(key: ValueKey('navigation')),
            content: SizedBox(key: ValueKey('content')),
          ),
        ),
      ),
    );

    final frame = tester.getRect(
      find.byKey(const ValueKey('klp-settings-dialog-frame')),
    );
    final navigation = tester.getRect(find.byKey(const ValueKey('navigation')));
    final content = tester.getRect(find.byKey(const ValueKey('content')));
    final layout = contextGeometry(tester);

    expect(frame.size, const Size(1380, 880));
    expect(navigation.width, layout.settingsNavigationWidth);
    expect(content.left - navigation.right, layout.settingsPaneGap);
    expect(content.width, 1070);
    expect(frame.center, const Offset(960, 516));
  });

  testWidgets('settings scope switcher 使用等寬選項並回報切換', (tester) async {
    var selected = 1;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 300,
            child: KlpSettingsScopeSwitcher(
              options: const [
                KlpSettingsScopeOption(label: 'Project', icon: KlpIcons.folder),
                KlpSettingsScopeOption(label: 'App', icon: KlpIcons.settings),
              ],
              selectedIndex: selected,
              onSelected: (value) => setState(() => selected = value),
            ),
          ),
        ),
      ),
    );

    final project = find.byKey(const ValueKey('klp-settings-scope-0'));
    final application = find.byKey(const ValueKey('klp-settings-scope-1'));
    expect(tester.getSize(project).width, tester.getSize(application).width);
		expect(
			tester.getSize(project).height,
			tester
				.element(find.byType(KlpSettingsScopeSwitcher))
				.klp
				.space
				.controlHeightXSmall,
		);

    await tester.tap(project);
    await tester.pump();
    expect(selected, 0);
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
		final tileCenter = tester.getRect(find.byType(KlpListTile)).center.dy;
		final titleCenter = tester.getRect(find.text('Appearance')).center.dy;
		expect(titleCenter, closeTo(tileCenter, 1));
  });

  testWidgets('settings page 的拖曳寬度受 semantic 範圍限制', (tester) async {
    double? changedWidth;
    await tester.pumpWidget(
      app(
        SizedBox(
          width: 1000,
          height: 600,
          child: KlpSettingsPage(
            navigationWidth: 220,
            navigationResizeLabel: 'Resize navigation',
            onNavigationWidthChanged: (value) => changedWidth = value,
            navigation: const SizedBox(),
            content: const SizedBox(),
          ),
        ),
      ),
    );

    await tester.drag(
      find.bySemanticsLabel('Resize navigation'),
      const Offset(400, 0),
    );
    expect(
      changedWidth,
      contextGeometry(tester).settingsNavigationMaximumWidth,
    );
  });

  testWidgets('navigation header 固定在導覽捲動區外', (tester) async {
    await tester.pumpWidget(
      app(
        SizedBox(
          width: 260,
          height: 300,
          child: KlpSettingsNavigationPane(
            header: const KlpSettingsNavigationHeader(
              key: ValueKey('settings-header'),
              title: 'User',
              search: KlpSettingsSearchField(placeholder: 'Search'),
            ),
            children: [
              for (var index = 0; index < 20; index++)
                KlpSettingsNavigationItem(
                  title: 'Section $index',
                  onPressed: () {},
                ),
            ],
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byKey(const ValueKey('settings-header')),
      ),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('settings-header')), findsOneWidget);
		final searchField = tester.widget<KlpTextField>(
			find.descendant(
				of: find.byType(KlpSettingsSearchField),
				matching: find.byType(KlpTextField),
			),
		);
		expect(searchField.outlined, isTrue);
  });

	testWidgets('message composer starts at one line and grows up to five', (
		tester,
	) async {
		await tester.pumpWidget(
			app(
				KlpMessageComposer(
					placeholder: 'Message',
					sendLabel: 'Send',
					attachLabel: 'Attach',
					onSend: () {},
					onAttach: () {},
				),
			),
		);

		final field = tester.widget<KlpTextField>(
			find.descendant(
				of: find.byType(KlpMessageComposer),
				matching: find.byType(KlpTextField),
			),
		);
		expect(field.minLines, 1);
		expect(field.maxLines, 5);
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

  testWidgets('content pane 將關閉動作固定在右上角', (tester) async {
    await tester.pumpWidget(
      app(
        const SizedBox(
          width: 1070,
          height: 880,
          child: KlpSettingsContentPane(
            title: 'Appearance',
            trailing: SizedBox(
              key: ValueKey('close-action'),
              width: 32,
              height: 32,
            ),
            child: SizedBox(),
          ),
        ),
      ),
    );

    final pane = tester.getRect(find.byType(KlpSettingsContentPane));
    final close = tester.getRect(find.byKey(const ValueKey('close-action')));
    final space = tester.element(find.byType(KlpSettingsContentPane)).klp.space;

    expect(close.top - pane.top, space.tight);
    expect(pane.right - close.right, space.compact);
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

  testWidgets('radio group 點擊文字也會選取整列', (tester) async {
    String? selected;
    await tester.pumpWidget(
      app(
        KlpRadioGroup<String>(
          items: const {'tree': 'Tree', 'flat': 'Flat'},
          value: 'tree',
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('Flat'));
    expect(selected, 'flat');
  });
}

KlpLayoutGeometry contextGeometry(WidgetTester tester) {
  final context = tester.element(find.byType(KlpSettingsPage));
  return context.klp.geometry.layout;
}
