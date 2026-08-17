import 'package:flutter/widgets.dart';

import 'package:kallopis/kallopis.dart';
import '../catalog_components.dart';

class FoundationsCatalog extends StatelessWidget {
  const FoundationsCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return const CatalogCanvas(
      children: [
        KlpSection(
          title: '文字層級',
          label: 'TYPE SYSTEM',
          child: CatalogGrid(
            children: [
              CatalogSample(
                label: 'Display / Title',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KlpText('專案控制台', role: KlpTextRole.display),
                    SizedBox(height: KlpSpace.sm),
                    KlpText('執行結果與驗證', role: KlpTextRole.title),
                  ],
                ),
              ),
              CatalogSample(
                label: 'Body / Metadata',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KlpText('規劃、協作並追蹤可驗證的專案成果。'),
                    SizedBox(height: KlpSpace.sm),
                    KlpText(
                      'LAST UPDATED / 14:28',
                      role: KlpTextRole.label,
                      tone: KlpTextTone.faint,
                    ),
                    SizedBox(height: KlpSpace.sm),
                    KlpText(
                      'run_04 / result.accepted',
                      role: KlpTextRole.code,
                      tone: KlpTextTone.muted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        KlpSection(
          title: '背景與基底區塊',
          label: 'BLOCK SURFACES',
          child: CatalogGrid(
            children: [
              CatalogSample(
                label: 'Base',
                child: KlpSurface(
                  padding: EdgeInsets.all(KlpSpace.lg),
                  child: KlpText('主要區域區塊'),
                ),
              ),
              CatalogSample(
                label: 'Inset',
                child: KlpSurface(
                  tone: KlpSurfaceTone.inset,
                  padding: EdgeInsets.all(KlpSpace.lg),
                  child: KlpText('控制項與巢狀卡片'),
                ),
              ),
              CatalogSample(
                label: 'Muted',
                child: KlpSurface(
                  tone: KlpSurfaceTone.muted,
                  padding: EdgeInsets.all(KlpSpace.lg),
                  child: KlpText('選取、Hover 與狀態'),
                ),
              ),
            ],
          ),
        ),
        KlpSection(
          title: '一條線，一種意義',
          label: 'STROKE LANGUAGE',
          child: CatalogGrid(
            children: [
              CatalogSample(
                label: 'NO EDGE / ACTION',
                child: KlpButton(label: 'Run query', onPressed: _noop),
              ),
              CatalogSample(
                label: 'DASHED / LATENT',
                child: KlpStrokeFrame(
                  role: KlpStrokeRole.latent,
                  child: Padding(
                    padding: EdgeInsets.all(KlpSpace.lg),
                    child: Center(child: KlpText('Drop a block here')),
                  ),
                ),
              ),
              CatalogSample(
                label: 'SOLID / FIELD',
                child: KlpSelect(
                  label: 'Execution target',
                  value: 'Local playground',
                  onPressed: _noop,
                ),
              ),
            ],
          ),
        ),
        KlpSection(
          title: '圖示語彙',
          label: 'SVG REPO / UI OVAL',
          child: _IconCatalog(),
        ),
      ],
    );
  }

  static void _noop() {}
}

class _IconCatalog extends StatelessWidget {
  const _IconCatalog();

  static const _icons = <String, String>{
    'Archive': KlpIcons.archive,
    'Bookmark': KlpIcons.bookmark,
    'Box': KlpIcons.box,
    'Calendar': KlpIcons.calendar,
    'Clipboard': KlpIcons.clipboard,
    'Collapse': KlpIcons.collapse,
    'Container': KlpIcons.container,
    'CPU': KlpIcons.cpu,
    'Edit': KlpIcons.edit,
    'Folder': KlpIcons.folder,
    'Folder +': KlpIcons.folderPlus,
    'Grid': KlpIcons.grid,
    'Inbox': KlpIcons.inbox,
    'Pencil': KlpIcons.pencil,
    'Search': KlpIcons.search,
    'Settings': KlpIcons.settings,
    'Status': KlpIcons.slash,
    'Sparkles': KlpIcons.sparkles,
    'Switch': KlpIcons.switchVertical,
    'Observe': KlpIcons.telescope,
    'Trash': KlpIcons.trash,
    'Team': KlpIcons.users,
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Wrap(
      spacing: KlpSpace.sm,
      runSpacing: KlpSpace.sm,
      children: [
        for (final entry in _icons.entries)
          Container(
            width: 112,
            height: 82,
            padding: const EdgeInsets.all(KlpSpace.sm),
            decoration: BoxDecoration(
              color: tokens.surfaceInset,
              borderRadius: BorderRadius.circular(KlpRadius.card),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KlpIcon(entry.value, color: tokens.text),
                const SizedBox(height: KlpSpace.sm),
                KlpText(
                  entry.key,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.muted,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
