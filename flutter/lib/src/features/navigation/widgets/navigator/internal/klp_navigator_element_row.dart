part of '../klp_navigator.dart';

class _KlpNavigatorElementRow extends StatelessWidget {
  const _KlpNavigatorElementRow({
    required this.element,
    required this.level,
    required this.isExpanded,
    required this.isSelected,
    required this.onToggle,
  });

  final KlpNavigatorElement element;
  final int level;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;

    return KlpRow(
      children: [
        KlpBox(
          marginInsets: KlpBoxInsets.directional(
            start: level * klp.space.tight,
          ),
          width: klp.space.iconSmall + klp.geometry.layout.treeLeadingGap,
          child: element.isBranch
              ? KlpGestureRegion(
                  behavior: HitTestBehavior.opaque,
                  onTap: onToggle,
                  child: _KlpNavigatorDisclosure(
                    expanded: isExpanded,
                    size: klp.space.iconSmall,
                    selected: isSelected,
                  ),
                )
              : null,
        ),
        KlpIcon(
          element.icon ??
              (element.isBranch ? KlpIcons.folder : KlpIcons.clipboard),
          size: klp.space.iconSmall,
          color: isSelected ? tokens.text : tokens.textMuted,
        ),
        KlpBox(width: klp.space.contentInlineGap),
        KlpExpanded(
          child: KlpText(
            element.label,
            role: KlpTextRole.code,
            color: tokens.text,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (element.badge != null) ...[
          KlpBox(width: klp.space.contentInlineGap),
          KlpText(element.badge!, role: KlpTextRole.code, color: tokens.text),
        ],
        if (element.trailing != null) element.trailing!,
      ],
    );
  }
}
