import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final workspaceShellPage = CatalogPageData(
  label: 'Sidebar Shell',
  title: 'Primary Sidebar 組合',
  description: 'Identity、導覽、Explorer 與 footer 的 Kallopis 預設組合。',
  icon: KlpIcons.panelLeft,
  specimens: [
    Specimen(
      name: 'KlpPrimarySidebarFrame',
      note: '消費端只提供四個語意區塊，不自行指定 panel chrome。',
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
          navigation: KlpSidebarNavigationGroup(
            children: [
              KlpSidebarNavigationButton(
                icon: KlpIcons.clipboard,
                label: '筆記',
                selected: true,
                onPressed: () {},
              ),
              KlpSidebarNavigationButton(
                icon: KlpIcons.sparkles,
                label: 'AI',
                onPressed: () {},
              ),
            ],
          ),
          explorer: const KlpFileExplorer(
            sections: [
              KlpFileExplorerSection(id: 'pinned', title: '釘選'),
              KlpFileExplorerSection(id: 'notes', title: '筆記'),
            ],
          ),
          footer: const KlpStatusIndicator(label: 'local'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpSidebarNavigationGroup',
      note: '統一管理相鄰導覽列的垂直節奏。',
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
    Specimen(
      name: 'KlpFileExplorerSection',
      note: 'Explorer 內可定位、可收合的結構分區。',
      build: (context) => const KlpFileExplorer(
        sections: [KlpFileExplorerSection(id: 'section', title: '分區')],
      ),
    ),
  ],
);
