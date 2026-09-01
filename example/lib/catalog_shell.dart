import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import 'catalog_model.dart';

class CatalogShell extends StatelessWidget {
  const CatalogShell({
    super.key,
    required this.groups,
    required this.pages,
    required this.selected,
    required this.onSelected,
  });

  final List<CatalogGroup> groups;
  final List<CatalogPageData> pages;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpAppScreen(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          klp.space.compact,
          0,
          klp.space.compact,
          klp.space.compact,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 900;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: compact ? 200 : 260,
                  child: _CatalogNavigation(
                    groups: groups,
                    pages: pages,
                    selected: selected,
                    onSelected: onSelected,
                  ),
                ),
                SizedBox(width: klp.space.compact),
                Expanded(child: _CatalogStage(page: pages[selected])),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CatalogNavigation extends StatelessWidget {
  const _CatalogNavigation({
    required this.groups,
    required this.pages,
    required this.selected,
    required this.onSelected,
  });

  final List<CatalogGroup> groups;
  final List<CatalogPageData> pages;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedPageLabel = selected >= 0 && selected < pages.length
        ? pages[selected].label
        : null;

    final categories = [
      for (final group in groups)
        KlpExplorerCategory(
          id: group.label,
          label: group.label,
          collapsible: true,
          nodes: [
            for (final page in group.pages)
              KlpExplorerNode(
                id: page.label,
                label: page.label,
                kind: KlpExplorerNodeKind.file,
                icon: page.icon,
                badge: page.specimens.isNotEmpty
                    ? '${page.specimens.length}'
                    : null,
                selected: page.label == selectedPageLabel,
              ),
          ],
        ),
    ];

    return KlpExplorer(
      scrollKey: const ValueKey('catalog-navigation-scroll'),
      categories: categories,
      selectedNodeId: selectedPageLabel,
      onNodeSelected: (id) {
        final index = pages.indexWhere((page) => page.label == id);
        if (index >= 0) onSelected(index);
      },
    );
  }
}

class _CatalogStage extends StatelessWidget {
  const _CatalogStage({required this.page});

  final CatalogPageData page;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      tone: KlpSurfaceTone.stage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
			SizedBox(
				height: 72,
				child: Padding(
					padding: EdgeInsets.symmetric(horizontal: klp.space.base),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KlpText(page.title, role: KlpTextRole.section),
                        KlpText(
                          page.description,
                          role: KlpTextRole.sub,
                          tone: KlpTextTone.muted,
                        ),
                      ],
                    ),
                  ),
                  if (page.specimens.isNotEmpty)
                    KlpBadge(
                      label: '${page.demoCount}/${page.specimens.length}',
                      tone: page.demoCount == page.specimens.length
                          ? KlpFeedbackTone.success
                          : KlpFeedbackTone.warning,
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: KlpScrollViewport(
              key: const ValueKey('catalog-stage-scroll'),
              child: Padding(
                padding: EdgeInsets.all(klp.space.comfortable),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (page.tokenView != null) page.tokenView!(context),
                    if (page.tokenView != null && page.specimens.isNotEmpty)
                      SizedBox(height: klp.space.section),
                    for (final specimen in page.specimens)
                      _SpecimenBlock(specimen: specimen),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecimenBlock extends StatelessWidget {
  const _SpecimenBlock({required this.specimen});

  final Specimen specimen;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Padding(
      padding: EdgeInsets.only(bottom: klp.space.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              KlpText(specimen.name, role: KlpTextRole.body),
              if (!specimen.hasDemo) ...[
                SizedBox(width: klp.space.compact),
                const KlpBadge(label: '尚未展示', tone: KlpFeedbackTone.warning),
              ],
            ],
          ),
          if (specimen.note != null) ...[
            SizedBox(height: klp.space.tight),
            KlpText(
              specimen.note!,
              role: KlpTextRole.sub,
              tone: KlpTextTone.muted,
            ),
          ],
          SizedBox(height: klp.space.base),
          if (specimen.hasDemo)
            KlpSurface(
              tone: KlpSurfaceTone.transparent,
              padding: EdgeInsets.symmetric(vertical: klp.space.compact),
              child: specimen.build!(context),
            )
          else
            const KlpDashedBorder(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: KlpText(
                    '這個元件還沒有示範',
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.faint,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
