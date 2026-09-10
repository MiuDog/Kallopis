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
      name: 'KlpSettingsDialog',
      note: '設定專用 modal 尺寸與置中框架；內容仍由產品組裝。',
      build: (context) => const SizedBox(
        height: 360,
        child: KlpSettingsDialog(child: _SettingsPageDemo()),
      ),
    ),
    Specimen(
      name: 'KlpSettingsPage',
      note: '設定殼層：寬版使用獨立雙 pane，窄版上下排列。',
      build: (context) => SizedBox(
        height: context.klp.geometry.layout.primaryPaneBreakpoint,
        child: const _SettingsPageDemo(),
      ),
    ),
    Specimen(
      name: 'KlpSettingsScopeSwitcher',
      note: '等寬切換專案與 App 等設定 scope；scope 狀態由產品持有。',
      build: (context) => KlpSettingsScopeSwitcher(
        options: const [
          KlpSettingsScopeOption(label: 'Project', icon: KlpIcons.folder),
          KlpSettingsScopeOption(label: 'App', icon: KlpIcons.settings),
        ],
        selectedIndex: 1,
        onSelected: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpSettingsNavigationHeader',
      note: '固定在導覽捲動區外，組合 identity、輔助動作與搜尋欄。',
      build: (context) => _navigationHeader(),
    ),
    Specimen(
      name: 'KlpSettingsSearchField',
      note: '設定搜尋的標準小型欄位；查詢和過濾仍由產品持有。',
      build: (context) =>
          const KlpSettingsSearchField(placeholder: 'Search settings'),
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
      name: 'KlpSettingsContentHeader',
      note: '右欄標題、說明與關閉／輔助動作的共用組合。',
      build: (context) => KlpSettingsContentHeader(
        title: 'Appearance',
        description: 'Choose how the application renders surfaces.',
        trailing: KlpIconButton(
          icon: KlpIcons.x,
          label: 'Close settings',
          tone: KlpIconButtonTone.inline,
          onPressed: () {},
        ),
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
  header: _navigationHeader(),
  children: [
    KlpSettingsNavigationGroup(label: 'APP', children: [_appearanceItem()]),
  ],
);

KlpSettingsNavigationHeader _navigationHeader() {
  return KlpSettingsNavigationHeader(
    scopeSwitcher: KlpSettingsScopeSwitcher(
      options: const [
        KlpSettingsScopeOption(label: 'Project', icon: KlpIcons.folder),
        KlpSettingsScopeOption(label: 'App', icon: KlpIcons.settings),
      ],
      selectedIndex: 1,
      onSelected: (_) {},
    ),
    search: const KlpSettingsSearchField(placeholder: 'Search settings'),
  );
}

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

class _SettingsPageDemo extends StatefulWidget {
  const _SettingsPageDemo();

  @override
  State<_SettingsPageDemo> createState() => _SettingsPageDemoState();
}

class _SettingsPageDemoState extends State<_SettingsPageDemo> {
  double? _navigationWidth;

  @override
  Widget build(BuildContext context) {
    return KlpSettingsPage(
      navigationWidth: _navigationWidth,
      onNavigationWidthChanged: (value) {
        setState(() => _navigationWidth = value);
      },
      navigationResizeLabel: 'Resize settings navigation',
      navigation: _navigationPane(),
      content: _contentPane(),
    );
  }
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
