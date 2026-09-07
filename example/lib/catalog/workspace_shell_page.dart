import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final workspaceShellPage = CatalogPageData(
  label: 'Sidebar Shell',
  title: 'Navigator Sidebar 組合',
  description: 'Identity、Navigator 三種注入模型與 footer 的 Kallopis 預設組合。',
  icon: KlpIcons.panelLeft,
  specimens: [
    Specimen(
      name: 'KlpAdaptive',
      note: '由 KlpApp 注入的平台資訊選擇 Panel Tree，尺寸響應仍由各平台分支負責。',
      build: (context) => SizedBox(
        width: context.klp.geometry.layout.primaryPaneWidth,
        height: context.klp.space.pageLarge,
        child: KlpApp(
          showWindowHeader: false,
          startMaximized: false,
          home: KlpAdaptive(
            windows: (_) =>
                const KlpPanelFrame(content: KlpText('Windows Panel Tree')),
            android: (_) =>
                const KlpPanelFrame(content: KlpText('Android Panel Tree')),
            other: (_) =>
                const KlpPanelFrame(content: KlpText('Fallback Panel Tree')),
          ),
        ),
      ),
    ),
    Specimen(
      name: 'KlpPrimarySidebarFrame',
      note: 'Sidebar Shell 將 Category、Element 與 Component 全部交由 Navigator 組成。',
      build: (context) => SizedBox(
        width: context.klp.geometry.layout.primaryPaneWidth,
        height: context.klp.space.pageLarge * 4,
        child: KlpPrimarySidebarFrame(
          header: const KlpSidebarIdentityHeader(
            icon: KlpIcons.folder,
            title: 'Workspace',
            avatarLabel: 'C',
            avatarSemanticLabel: '使用者',
          ),
          explorer: _buildNavigator(),
          status: const KlpStatusItemData(label: 'local'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpNavigator',
      note: '只有 Category、Element、Component 三種具體模型；Element 可直接位於根層。',
      build: (context) => SizedBox(
        width: context.klp.geometry.layout.primaryPaneWidth,
        height: context.klp.space.pageLarge * 4,
        child: _buildNavigator(),
      ),
    ),
    Specimen(
      name: 'KlpSidebarNavigationGroup',
      note: '按鈕列表可作為 KlpNavigatorComponent 注入，不由 Navigator 改寫高度。',
      build: (context) => KlpSidebarNavigationGroup(
        children: [
          KlpSidebarNavigationButton(
            icon: KlpIcons.folder,
            label: '第一區',
            onPressed: () {},
          ),
          KlpSidebarNavigationButton(
            icon: KlpIcons.box,
            label: '第二區',
            onPressed: () {},
          ),
        ],
      ),
    ),
  ],
);

KlpNavigator _buildNavigator() {
  return KlpNavigator(
    items: [
      const KlpNavigatorComponent(
        id: 'search',
        child: Padding(
          padding: EdgeInsets.all(KlpSpace.sm),
          child: KlpTextField(
            placeholder: '搜尋',
            leadingIcon: KlpIcons.search,
            size: KlpControlSize.xs,
          ),
        ),
      ),
      const KlpNavigatorElement(
        id: 'overview',
        label: 'Overview',
        icon: KlpIcons.grid,
        selected: true,
      ),
      const KlpNavigatorCategory(
        id: 'documents',
        label: 'Documents',
        items: [
          KlpNavigatorElement(
            id: 'design-system',
            label: 'Design System',
            icon: KlpIcons.folder,
            expanded: true,
            children: [
              KlpNavigatorElement(
                id: 'tokens',
                label: 'Design Tokens',
                icon: KlpIcons.sparkles,
                badge: '4',
              ),
              KlpNavigatorElement(
                id: 'components',
                label: 'Components',
                icon: KlpIcons.box,
                badge: '18',
              ),
            ],
          ),
          KlpNavigatorElement(
            id: 'screens',
            label: 'Screens',
            icon: KlpIcons.panelSplit,
          ),
        ],
      ),
      const KlpNavigatorComponent(
        id: 'divider',
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: KlpSpace.sm),
          child: KlpDashedDivider(),
        ),
      ),
      KlpNavigatorComponent(
        id: 'actions',
        child: KlpSidebarNavigationGroup(
          children: [
            KlpSidebarNavigationButton(
              icon: KlpIcons.clipboard,
              label: '筆記',
              onPressed: () {},
            ),
            KlpSidebarNavigationButton(
              icon: KlpIcons.sparkles,
              label: 'AI',
              onPressed: () {},
            ),
          ],
        ),
      ),
    ],
  );
}
