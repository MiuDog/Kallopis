import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import '../foundation/klp_palette.dart';

class KlpSegmentedControl extends StatelessWidget {
  const KlpSegmentedControl({
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
    final tokens = context.klpColors;

    return Container(
      height: dense ? KlpSize.segmentedDense : null,
      padding: EdgeInsets.all(
        dense ? KlpControlMetrics.segmentedDenseInset : KlpSpace.xs,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceInset,
        borderRadius: BorderRadius.circular(KlpRadius.card),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < items.length; index++)
            if (expanded)
              Expanded(
                child: _KlpSegment(
                  key: itemKeys?[index],
                  label: items[index],
                  icon: icons?[index],
                  selected: index == selected,
                  dense: dense,
                  onPressed: () => onSelected(index),
                ),
              )
            else
              _KlpSegment(
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

class _KlpSegment extends StatelessWidget {
  const _KlpSegment({
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
    final tokens = context.klpColors;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? tokens.component : KlpPalette.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KlpRadius.control),
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
          borderRadius: BorderRadius.circular(KlpRadius.control),
          child: SizedBox(
            height: dense ? KlpSize.segmentedDenseItem : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: KlpSpace.md,
                vertical: dense ? 0 : KlpSpace.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    KlpIcon(
                      icon!,
                      size: dense ? KlpSize.iconSmall : KlpSize.icon,
                      color: selected ? tokens.text : tokens.textMuted,
                    ),
                    const SizedBox(width: KlpSpace.sm),
                  ],
                  Flexible(
                    child: KlpText(
                      label,
                      role: dense ? KlpTextRole.caption : KlpTextRole.body,
                      tone: selected ? KlpTextTone.primary : KlpTextTone.muted,
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
