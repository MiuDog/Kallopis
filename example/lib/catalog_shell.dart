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
    required this.onToggleTheme,
  });

  final List<CatalogGroup> groups;
  final List<CatalogPageData> pages;
  final int selected;
  final ValueChanged<int> onSelected;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpAppScreen(
      child: Padding(
        padding: EdgeInsets.all(klp.space.compact),
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
                    onToggleTheme: onToggleTheme,
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
    required this.onToggleTheme,
  });

  final List<CatalogGroup> groups;
  final List<CatalogPageData> pages;
  final int selected;
  final ValueChanged<int> onSelected;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 72,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: klp.space.base),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KlpText('Kallopis', role: KlpTextRole.bodyStrong),
                  KlpText(
                    'COMPONENT CATALOG',
                    role: KlpTextRole.sub,
                    tone: KlpTextTone.muted,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: KlpScrollViewport(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: klp.space.compact),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final group in groups)
                      _NavGroup(
                        group: group,
                        indexOf: pages.indexOf,
                        selected: selected,
                        onSelected: onSelected,
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(klp.space.compact),
            child: KlpRailItem(
              icon: KlpIcons.settings,
              label: '切換深淺主題',
              onPressed: onToggleTheme,
            ),
          ),
        ],
      ),
    );
  }
}

/// 一個可收合的導覽分組。
class _NavGroup extends StatefulWidget {
  const _NavGroup({
    required this.group,
    required this.indexOf,
    required this.selected,
    required this.onSelected,
  });

  final CatalogGroup group;
  final int Function(CatalogPageData) indexOf;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  State<_NavGroup> createState() => _NavGroupState();
}

class _NavGroupState extends State<_NavGroup> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final containsSelected = widget.group.pages.any(
      (p) => widget.indexOf(p) == widget.selected,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpPressable(
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: klp.space.base,
              vertical: klp.space.compact,
            ),
            child: Row(
              children: [
                KlpIcon(
                  _expanded
                      ? KlpIcons.chevronDown
                      : KlpIcons.disclosureTriangle,
                  size: klp.space.iconSmall,
                  color: klp.color.textFaint,
                ),
                SizedBox(width: klp.space.compact),
                KlpText(
                  widget.group.label,
                  role: KlpTextRole.bodyStrong,
                  tone: containsSelected
                      ? KlpTextTone.primary
                      : KlpTextTone.muted,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          for (final page in widget.group.pages)
            _NavItem(
              page: page,
              index: widget.indexOf(page),
              selected: widget.indexOf(page) == widget.selected,
              onSelected: widget.onSelected,
            ),
        SizedBox(height: klp.space.tight),
      ],
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.page,
    required this.index,
    required this.selected,
    required this.onSelected,
  });

  final CatalogPageData page;
  final int index;
  final bool selected;
  final ValueChanged<int> onSelected;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final isHighlighted = widget.selected || _hovered;

    // hover 與選取是兩種強度，不是同一種：
    //   hover  → 低對比邊框，底色透明（只表示「可點」）
    //   選取   → 高對比邊框 ＋ 半透明壓深底（表示「你在這裡」）
    //
    // 壓深底用 selectionWash——前景色的低 alpha 疊層，亮態壓暗、暗態壓亮，
    // 底下表面原本的階層差不會被蓋掉。先前用的 hoverSurface 是把 surfaceInset
    // 往 text 混出來的不透明計算值，色梯亮端暖、暗端冷之後跨梯混色會落到梯外色相
    // （hover H 94°、選取 H 81°），看起來像兩種語意色。
    Widget itemContent = Container(
      decoration: BoxDecoration(
        color: widget.selected ? klp.selectionWash : null,
        borderRadius: BorderRadius.circular(klp.shape.control),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: klp.space.base,
        vertical: klp.space.tight,
      ),
      child: Row(
        children: [
          Expanded(
            child: KlpText(
              widget.page.label,
              role: KlpTextRole.body,
              tone: widget.selected
                  ? KlpTextTone.primary
                  : (_hovered ? KlpTextTone.primary : KlpTextTone.muted),
            ),
          ),
          if (widget.page.specimens.isNotEmpty)
            KlpText(
              '${widget.page.specimens.length}',
              role: KlpTextRole.code,
              tone: KlpTextTone.faint,
            ),
        ],
      ),
    );

    if (isHighlighted) {
      itemContent = KlpDashedBorder(
        color: widget.selected ? klp.color.textMuted : klp.color.guide,
        radius: klp.shape.control,
        child: itemContent,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: klp.space.compact,
        vertical: klp.space.hairline,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: KlpPressable(
          onPressed: () => widget.onSelected(widget.index),
          child: itemContent,
        ),
      ),
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
