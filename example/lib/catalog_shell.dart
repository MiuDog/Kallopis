import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

import 'catalog_model.dart';
import 'catalog/generated/catalog_style_semantics.g.dart';

class CatalogShell extends StatefulWidget {
  const CatalogShell({
    super.key,
    required this.groups,
    required this.pages,
    required this.selected,
    required this.onSelected,
    this.appBuilder,
  });

  final List<CatalogGroup> groups;
  final List<CatalogPageData> pages;
  final int selected;
  final ValueChanged<int> onSelected;

  /// 在目錄狀態之外組裝 App，同時讓 home 接收真正的 Panel Tree。
  final Widget Function(KlpPanelLayout panelLayout)? appBuilder;

  @override
  State<CatalogShell> createState() => _CatalogShellState();
}

class _CatalogShellState extends State<CatalogShell> {
  final ScrollController _navigationScrollController = ScrollController();
  KlpDockLayoutData? _layout;

  @override
  void dispose() {
    _navigationScrollController.dispose();
    super.dispose();
  }

  KlpDockLayoutData _initialLayout(double navigationWidth) {
    return KlpDockLayoutData(
      left: KlpDockAreaData(
        axis: Axis.vertical,
        extent: navigationWidth,
        groups: const [
          KlpDockGroupData(
            id: 'catalog-navigation-group',
            panelIds: ['catalog-navigation'],
            activePanelId: 'catalog-navigation',
            mainAxisExtent: 480,
          ),
        ],
      ),
      right: const KlpDockAreaData(
        axis: Axis.vertical,
        extent: 260,
        groups: [],
        isVisible: false,
      ),
      bottom: const KlpDockAreaData(
        axis: Axis.horizontal,
        extent: 200,
        groups: [],
        isVisible: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        final layout = _layout ?? _initialLayout(compact ? 200 : 260);
        final navigation = _CatalogNavigation(
          groups: widget.groups,
          pages: widget.pages,
          selected: widget.selected,
          onSelected: widget.onSelected,
          scrollController: _navigationScrollController,
        );

        final panelLayout = KlpDockLayout(
          stage: KlpPanelFrame(
            padding: EdgeInsets.zero,
            content: _CatalogStage(page: widget.pages[widget.selected]),
          ),
          panels: [
            KlpDockPanel(
              id: 'catalog-navigation',
              header: const KlpText('目錄', role: KlpTextRole.code),
              content: navigation,
              contentScrollController: _navigationScrollController,
              allowSide: true,
              allowBottom: false,
            ),
          ],
          layout: layout,
          onLayoutChanged: (value) {
            setState(() => _layout = value);
          },
          leftConstraints: const KlpDockAreaConstraints(
            minExtent: 180,
            maxExtent: 360,
          ),
          rightConstraints: const KlpDockAreaConstraints(
            minExtent: 180,
            maxExtent: 360,
          ),
          bottomConstraints: const KlpDockAreaConstraints(
            minExtent: 140,
            maxExtent: 320,
          ),
        );
        return widget.appBuilder?.call(panelLayout) ??
            KlpAppScreen(child: panelLayout);
      },
    );
  }
}

class _CatalogNavigation extends StatelessWidget {
  const _CatalogNavigation({
    required this.groups,
    required this.pages,
    required this.selected,
    required this.onSelected,
    required this.scrollController,
  });

  final List<CatalogGroup> groups;
  final List<CatalogPageData> pages;
  final int selected;
  final ValueChanged<int> onSelected;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final selectedPageLabel = selected >= 0 && selected < pages.length
        ? pages[selected].label
        : null;

    final categories = [
      for (final group in groups)
        KlpExplorerCategory(
          id: group.id,
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
      scrollController: scrollController,
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
                      _SpecimenBlock(
                        specimen: specimen,
                        visualStyle: page.visualStyle,
                      ),
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
  const _SpecimenBlock({required this.specimen, this.visualStyle});

  final Specimen specimen;
  final KlpVisualStyle Function(KlpVisualStyle base)? visualStyle;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final semantics = catalogStyleSemantics[specimen.name];
    final semanticDescription =
        semantics?.description ?? '風格語意：未宣告（此元件尚未產生可追蹤資料）';
    Widget? demo;
    if (specimen.hasDemo) {
      demo = Builder(builder: specimen.build!);
      if (visualStyle != null) {
        final style = visualStyle!(KlpTheme.styleOf(context));
        demo = Theme(
          data: Theme.of(context).copyWith(extensions: style.extensions),
          child: demo,
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: klp.space.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (specimen.sectionLabel != null) ...[
            KlpText(specimen.sectionLabel!, role: KlpTextRole.bodyStrong),
            SizedBox(height: klp.space.contentStackGap),
          ],
          Wrap(
            spacing: klp.space.tight,
            runSpacing: klp.space.tight,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              KlpText(specimen.name, role: KlpTextRole.body),
              KlpTooltip(
                message: semantics?.tooltipMessage ?? '此元件尚未產生風格語意追蹤資料。',
                child: const KlpBadge(
                  label: '風格語意',
                  variant: KlpBadgeVariant.outline,
                ),
              ),
              if (!specimen.hasDemo) ...[
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
          SizedBox(height: klp.space.tight),
          KlpText(
            semanticDescription,
            role: KlpTextRole.caption,
            tone: KlpTextTone.faint,
          ),
          SizedBox(height: klp.space.base),
          if (specimen.hasDemo)
            KlpSurface(
              tone: KlpSurfaceTone.transparent,
              padding: EdgeInsets.symmetric(vertical: klp.space.contentInset),
              child: demo!,
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
