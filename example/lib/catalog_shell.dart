import 'package:flutter/material.dart';

import 'package:kallopis/kallopis.dart';
import 'catalog_page.dart';

class CatalogShell extends StatelessWidget {
  const CatalogShell({
    super.key,
    required this.pages,
    required this.selected,
    required this.onSelected,
    required this.onToggleTheme,
  });

  final List<CatalogPageData> pages;
  final int selected;
  final ValueChanged<int> onSelected;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Scaffold(
      body: ColoredBox(
        color: tokens.app,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(KlpLayoutGap.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 820;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: compact ? KlpSize.rail + KlpSpace.sm : 244,
                      child: _CatalogNavigation(
                        pages: pages,
                        selected: selected,
                        compact: compact,
                        onSelected: onSelected,
                        onToggleTheme: onToggleTheme,
                      ),
                    ),
                    const SizedBox(width: KlpLayoutGap.lg),
                    Expanded(child: _CatalogStage(page: pages[selected])),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogNavigation extends StatelessWidget {
  const _CatalogNavigation({
    required this.pages,
    required this.selected,
    required this.compact,
    required this.onSelected,
    required this.onToggleTheme,
  });

  final List<CatalogPageData> pages;
  final int selected;
  final bool compact;
  final ValueChanged<int> onSelected;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(KlpRadius.panel),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: KlpSize.header,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: KlpSpace.md),
              child: compact
                  ? Center(
                      child: KlpIcon(KlpIcons.container, color: tokens.text),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KlpText('Kallopis', role: KlpTextRole.bodyStrong),
                        KlpText(
                          'COMPONENT CATALOG / 01',
                          role: KlpTextRole.label,
                          tone: KlpTextTone.faint,
                        ),
                      ],
                    ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(KlpSpace.sm),
              itemCount: pages.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: KlpSpace.xs),
              itemBuilder: (context, index) {
                final page = pages[index];

                if (compact) {
                  return KlpRailItem(
                    icon: page.icon,
                    label: page.label,
                    selected: index == selected,
                    onPressed: () => onSelected(index),
                  );
                }

                return KlpListTile(
                  icon: page.icon,
                  title: page.label,
                  selected: index == selected,
                  onPressed: () => onSelected(index),
                  trailing: KlpText(
                    '${index + 1}'.padLeft(2, '0'),
                    role: KlpTextRole.code,
                    tone: KlpTextTone.faint,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(KlpSpace.sm),
            child: compact
                ? KlpRailItem(
                    icon: KlpIcons.settings,
                    label: '切換主題',
                    onPressed: onToggleTheme,
                  )
                : KlpListTile(
                    icon: KlpIcons.settings,
                    title: '切換深淺主題',
                    onPressed: onToggleTheme,
                  ),
          ),
        ],
      ),
    );
  }
}

class _CatalogStage extends StatelessWidget {
  const _CatalogStage({required this.page});

  final CatalogPageData page;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 480;

        return Container(
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(KlpRadius.panel),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: KlpSize.header + KlpSpace.xs,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? KlpSpace.md : KlpSpace.lg,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KlpText(
                              page.title,
                              role: KlpTextRole.section,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (!compact)
                              KlpText(
                                page.description,
                                role: KlpTextRole.caption,
                                tone: KlpTextTone.muted,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      if (!compact) const KlpBadge(label: 'LIVE', dot: true),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ColoredBox(
                  key: const ValueKey('catalog-component-canvas'),
                  color: tokens.app,
                  child: page.child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
