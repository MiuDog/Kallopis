import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final dockingLayoutPage = CatalogPageData(
  label: 'Docking',
  title: '可停駐工作區',
  description: '以固定 Stage 搭配左、下、右 Area；panel 可在 header 或 tab 上拖曳、合併與拆分。',
  icon: KlpIcons.panelSplit,
  specimens: [
    Specimen(
      name: 'KlpDockLayout',
      note:
          'Bottom：header 合併 tab，content 右半部只向右新增 Group。空 Side 使用中央區域全高落點線；Group 分隔線直接跟隨滑鼠位置。',
      build: (context) => const _DockLayoutDemo(),
    ),
    Specimen(
      name: 'KlpDockHeader',
      note: '固定 32px；左側可水平捲動，右側 actions 寬度不足時由右向左收入更多選單。',
      build: (context) => SizedBox(
        width: 220,
        height: 120,
        child: KlpPanelFrame(
          headerSize: KlpPanelHeaderSize.dock,
          header: KlpDockHeader(
            leading: const KlpText(
              'COMPACT DOCK HEADER',
              role: KlpTextRole.code,
            ),
            actions: [
              KlpDockHeaderAction(
                icon: KlpIcons.search,
                label: '搜尋',
                onPressed: () {},
              ),
              KlpDockHeaderAction(
                icon: KlpIcons.refresh,
                label: '重新整理',
                onPressed: () {},
              ),
              KlpDockHeaderAction(
                icon: KlpIcons.settings,
                label: '設定',
                onPressed: () {},
              ),
              KlpDockHeaderAction(
                icon: KlpIcons.trash,
                label: '刪除',
                onPressed: () {},
              ),
            ],
          ),
          content: const Center(child: KlpText('Resize the Catalog window')),
        ),
      ),
    ),
  ],
);

class _DockLayoutDemo extends StatefulWidget {
  const _DockLayoutDemo();

  @override
  State<_DockLayoutDemo> createState() => _DockLayoutDemoState();
}

class _DockLayoutDemoState extends State<_DockLayoutDemo> {
  static const KlpDockLayoutData _initialLayout = KlpDockLayoutData(
    left: KlpDockAreaData(
      axis: Axis.vertical,
      extent: 220,
      groups: [
        KlpDockGroupData(
          id: 'left-project',
          panelIds: ['project'],
          activePanelId: 'project',
          mainAxisExtent: 220,
        ),
        KlpDockGroupData(
          id: 'left-outline',
          panelIds: ['outline'],
          activePanelId: 'outline',
          mainAxisExtent: 220,
        ),
      ],
    ),
    right: KlpDockAreaData(
      axis: Axis.vertical,
      extent: 220,
      groups: [
        KlpDockGroupData(
          id: 'right-inspector',
          panelIds: ['inspector', 'history'],
          activePanelId: 'inspector',
          mainAxisExtent: 220,
        ),
        KlpDockGroupData(
          id: 'right-tokens',
          panelIds: ['tokens'],
          activePanelId: 'tokens',
          mainAxisExtent: 220,
        ),
      ],
    ),
    bottom: KlpDockAreaData(
      axis: Axis.horizontal,
      extent: 200,
      groups: [
        KlpDockGroupData(
          id: 'bottom-terminal',
          panelIds: ['terminal'],
          activePanelId: 'terminal',
          mainAxisExtent: 320,
        ),
        KlpDockGroupData(
          id: 'bottom-problems',
          panelIds: ['problems'],
          activePanelId: 'problems',
          mainAxisExtent: 320,
        ),
      ],
    ),
  );

  KlpDockLayoutData _layout = _initialLayout;

  late final List<KlpDockPanel> _panels = [
    _panel(
      'project',
      'PROJECT',
      'Project explorer · side only',
      allowBottom: false,
    ),
    _panel('outline', 'OUTLINE', 'Document outline'),
    _panel(
      'terminal',
      'TERMINAL',
      'Terminal output · bottom only',
      allowSide: false,
    ),
    _panel('problems', 'PROBLEMS', 'Problems and diagnostics'),
    _panel(
      'inspector',
      'INSPECTOR',
      'Selected element properties',
      actions: [
        KlpDockHeaderAction(
          icon: KlpIcons.search,
          label: '搜尋',
          onPressed: () {},
        ),
        KlpDockHeaderAction(
          icon: KlpIcons.refresh,
          label: '重新整理',
          onPressed: () {},
        ),
        KlpDockHeaderAction(
          icon: KlpIcons.settings,
          label: '設定',
          onPressed: () {},
        ),
      ],
    ),
    _panel('tokens', 'TOKENS', 'Resolved design tokens'),
    _panel('history', 'HISTORY', 'Change history'),
  ];

  KlpDockPanel _panel(
    String id,
    String title,
    String content, {
    bool allowBottom = true,
    bool allowSide = true,
    List<KlpDockHeaderAction> actions = const [],
  }) {
    return KlpDockPanel(
      id: id,
      header: KlpText(title, role: KlpTextRole.code),
      content: Center(child: KlpText(content, tone: KlpTextTone.muted)),
      allowBottom: allowBottom,
      allowSide: allowSide,
      actions: actions,
    );
  }

  void _toggleArea(String slot) {
    setState(() {
      switch (slot) {
        case 'left':
          _layout = _layout.copyWith(
            left: _layout.left.copyWith(isVisible: !_layout.left.isVisible),
          );
        case 'bottom':
          _layout = _layout.copyWith(
            bottom: _layout.bottom.copyWith(
              isVisible: !_layout.bottom.isVisible,
            ),
          );
        case 'right':
          _layout = _layout.copyWith(
            right: _layout.right.copyWith(isVisible: !_layout.right.isVisible),
          );
      }
    });
  }

  void _clearBottom() {
    setState(() {
      _layout = _layout.copyWith(
        bottom: _layout.bottom.copyWith(groups: const [], isVisible: false),
      );
    });
  }

  void _resetLayout() {
    setState(() => _layout = _initialLayout);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: context.klp.space.actionGap,
            children: [
              KlpButton(
                label: 'Toggle left',
                onPressed: () => _toggleArea('left'),
              ),
              KlpButton(
                label: 'Toggle bottom',
                onPressed: () => _toggleArea('bottom'),
              ),
              KlpButton(
                label: 'Toggle right',
                onPressed: () => _toggleArea('right'),
              ),
              KlpButton(label: 'Clear bottom', onPressed: _clearBottom),
              KlpButton(label: 'Reset layout', onPressed: _resetLayout),
            ],
          ),
          SizedBox(height: context.klp.space.contentStackGap),
          Expanded(
            child: KlpDockLayout(
              stage: const KlpPanelFrame(
                header: KlpPanelHeader(title: 'STAGE'),
                content: Center(
                  child: KlpText('Fixed stage', role: KlpTextRole.code),
                ),
              ),
              panels: _panels,
              layout: _layout,
              onLayoutChanged: (layout) => setState(() => _layout = layout),
              leftConstraints: const KlpDockAreaConstraints(
                minExtent: 160,
                maxExtent: 360,
              ),
              rightConstraints: const KlpDockAreaConstraints(
                minExtent: 160,
                maxExtent: 360,
              ),
              bottomConstraints: const KlpDockAreaConstraints(
                minExtent: 140,
                maxExtent: 320,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
