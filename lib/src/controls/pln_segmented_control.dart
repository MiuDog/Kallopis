import 'package:flutter/material.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnSegmentedControl extends StatelessWidget {
  const PlnSegmentedControl({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
    this.icons,
    this.itemKeys,
    this.expanded = false,
    this.dense = false,
  }) : assert(icons == null || icons.length == items.length),
       assert(itemKeys == null || itemKeys.length == items.length);

  final List<String> items;
  final int selected;
  final ValueChanged<int> onSelected;
  final List<String>? icons;
  final List<Key?>? itemKeys;
  final bool expanded;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return Container(
      height: dense ? PlnSize.segmentedDense : null,
      padding: EdgeInsets.all(
        dense ? PlnControlMetrics.segmentedDenseInset : PlnSpace.xs,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceInset,
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < items.length; index++)
            if (expanded)
              Expanded(
                child: _PlnSegment(
                  key: itemKeys?[index],
                  label: items[index],
                  icon: icons?[index],
                  selected: index == selected,
                  dense: dense,
                  onPressed: () => onSelected(index),
                ),
              )
            else
              _PlnSegment(
                key: itemKeys?[index],
                label: items[index],
                icon: icons?[index],
                selected: index == selected,
                dense: dense,
                onPressed: () => onSelected(index),
              ),
        ],
      ),
    );
  }
}

class _PlnSegment extends StatelessWidget {
  const _PlnSegment({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.dense,
    required this.onPressed,
  });

  final String label;
  final String? icon;
  final bool selected;
  final bool dense;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? tokens.component : const Color(0x00000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PlnRadius.control),
        ),
        child: InkWell(
          onTap: onPressed,
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (selected) return tokens.component;
            if (!states.contains(WidgetState.hovered)) {
              return tokens.surfaceMuted.withValues(alpha: 0);
            }

            return tokens.hoverSurface;
          }),
          borderRadius: BorderRadius.circular(PlnRadius.control),
          child: SizedBox(
            height: dense ? PlnSize.segmentedDenseItem : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: PlnSpace.md,
                vertical: dense ? 0 : PlnSpace.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    PlnIcon(
                      icon!,
                      size: dense ? PlnSize.iconSmall : PlnSize.icon,
                      color: selected ? tokens.text : tokens.textMuted,
                    ),
                    const SizedBox(width: PlnSpace.sm),
                  ],
                  Flexible(
                    child: PlnText(
                      label,
                      role: dense ? PlnTextRole.caption : PlnTextRole.body,
                      tone: selected ? PlnTextTone.primary : PlnTextTone.muted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
