import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

const _themeOptions = [
  KlpThemeModeOption(
    mode: KlpThemePreviewMode.light,
    label: 'Light',
    description: 'Paper white',
  ),
  KlpThemeModeOption(
    mode: KlpThemePreviewMode.dark,
    label: 'Dark',
    description: 'Warm near-black',
  ),
  KlpThemeModeOption(
    mode: KlpThemePreviewMode.ultraDark,
    label: 'Ultra Dark',
    description: 'True black',
  ),
  KlpThemeModeOption(
    mode: KlpThemePreviewMode.system,
    label: 'Follow system',
    description: 'Match the platform',
  ),
  KlpThemeModeOption(
    mode: KlpThemePreviewMode.transparent,
    label: 'Transparent',
    description: 'Desktop material',
  ),
];

final settingsPage = CatalogPageData(
  label: 'Settings',
  title: '設定頁與外觀',
  description: '共用設定版面、導覽、欄位、動作列與顏色模式。',
  icon: KlpIcons.settings,
  specimens: [
    Specimen(
      name: 'KlpSettingsPage',
      note: '依 semantic breakpoint 在雙欄與上下排列間切換，不擁有 route 或產品 scope。',
      build: (context) => SizedBox(
        height: context.klp.geometry.layout.primaryPaneBreakpoint,
        child: KlpSettingsPage(
          navigation: _navigationPane(),
          content: _contentPane(),
        ),
      ),
    ),
    Specimen(
      name: 'KlpSettingsNavigationPane',
      note: '設定導覽的 token 表面、內距與捲動容器；header 可組合 scope switcher 與搜尋。',
      build: (context) => SizedBox(
        height: context.klp.geometry.layout.primaryPaneBreakpoint,
        child: _navigationPane(),
      ),
    ),
    Specimen(
      name: 'KlpSettingsContentPane',
      note: '標題與設定內容可捲動，footer 固定於捲動區外。',
      build: (context) => SizedBox(
        height: context.klp.geometry.layout.primaryPaneBreakpoint,
        child: _contentPane(),
      ),
    ),
    Specimen(
      name: 'KlpSettingsNavigationGroup',
      note: '不可收縮的分類標題；分類集合由產品層提供。',
      build: (context) => KlpSettingsNavigationGroup(
        label: 'APP',
        children: [_appearanceItem()],
      ),
    ),
    Specimen(
      name: 'KlpSettingsNavigationItem',
      note: '只有目前 section 會展開 field deep links，並以 semantic divider 顯示導引線。',
      build: (context) => _appearanceItem(),
    ),
    Specimen(
      name: 'KlpSettingsField',
      note: '設定欄位的標題、說明與控制項 slot；highlighted 使用 semantic muted surface。',
      build: (context) => const KlpSettingsField(
        title: 'Docs width',
        description: 'Use the available stage width.',
        highlighted: true,
        child: KlpToggle(value: true, label: 'Full width', onChanged: null),
      ),
    ),
    Specimen(
      name: 'KlpSettingsActionBar',
      note: '只呈現狀態與動作；dirty／saving／failure 狀態機仍由產品擁有。',
      build: (context) => KlpSettingsActionBar(
        message: 'Unsaved changes',
        actions: [
          KlpButton(
            label: 'Reset',
            tone: KlpButtonTone.ghost,
            compact: true,
            onPressed: () {},
          ),
          KlpButton(label: 'Save', compact: true, onPressed: () {}),
        ],
      ),
    ),
    Specimen(
      name: 'KlpThemeModePicker',
      note: '受控的顏色模式選擇器；模式保存與系統亮度解析由產品層負責。',
      build: (context) => const _ThemeModePickerDemo(),
    ),
  ],
);

KlpSettingsNavigationPane _navigationPane() => KlpSettingsNavigationPane(
  header: Column(
    children: [
      KlpSegmentedControl(
        items: const ['Project', 'App'],
        selected: 1,
        expanded: true,
        dense: true,
        onSelected: (_) {},
      ),
      const SizedBox(height: KlpSpace.sm),
      const KlpTextField(
        placeholder: 'Search settings',
        leadingIcon: KlpIcons.search,
      ),
    ],
  ),
  children: [
    KlpSettingsNavigationGroup(label: 'APP', children: [_appearanceItem()]),
  ],
);

KlpSettingsNavigationItem _appearanceItem() => KlpSettingsNavigationItem(
  title: 'Appearance',
  icon: KlpIcons.grid,
  selected: true,
  onPressed: () {},
  children: [
    KlpListTile(title: 'Color mode', compact: true, onPressed: () {}),
    KlpListTile(title: 'Accent', compact: true, onPressed: () {}),
  ],
);

KlpSettingsContentPane _contentPane() => KlpSettingsContentPane(
  title: 'Appearance',
  description: 'Choose how the application renders surfaces and contrast.',
  footer: KlpSettingsActionBar(
    message: 'Saved',
    tone: KlpTextTone.success,
    actions: [KlpButton(label: 'Save', compact: true, onPressed: () {})],
  ),
  child: KlpSettingsField(
    title: 'Color mode',
    description: 'Changes apply immediately without a theme transition.',
    child: KlpThemeModePicker(
      options: _themeOptions,
      selected: KlpThemePreviewMode.light,
      onSelected: (_) {},
    ),
  ),
);

class _ThemeModePickerDemo extends StatefulWidget {
  const _ThemeModePickerDemo();

  @override
  State<_ThemeModePickerDemo> createState() => _ThemeModePickerDemoState();
}

class _ThemeModePickerDemoState extends State<_ThemeModePickerDemo> {
  KlpThemePreviewMode _selected = KlpThemePreviewMode.light;

  @override
  Widget build(BuildContext context) => KlpThemeModePicker(
    options: _themeOptions,
    selected: _selected,
    onSelected: (value) => setState(() => _selected = value),
  );
}
