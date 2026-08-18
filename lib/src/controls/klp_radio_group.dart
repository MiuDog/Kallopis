import 'package:flutter/material.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import '../foundation/klp_palette.dart';

class KlpRadioGroup<T> extends StatelessWidget {
  const KlpRadioGroup({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final Map<T, String> items;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.klp.space.comfortable,
      runSpacing: context.klp.space.compact,
      children: [
        for (final entry in items.entries)
          _KlpRadioItem(
            label: entry.value,
            selected: entry.key == value,
            onPressed: () => onChanged(entry.key),
          ),
      ],
    );
  }
}

class _KlpRadioItem extends StatelessWidget {
  const _KlpRadioItem({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.klp.space.tight),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            checked: selected,
            inMutuallyExclusiveGroup: true,
            label: label,
            child: Material(
              color: KlpPalette.transparent,
              borderRadius: BorderRadius.circular(context.klp.shape.control),
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(context.klp.shape.control),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: tokens.textMuted,
                      width: context.klp.shape.stroke,
                    ),
                    borderRadius: BorderRadius.circular(
                      context.klp.shape.control,
                    ),
                  ),
                  child: SizedBox.square(
                    dimension: KlpFormMetrics.selectionControl,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        KlpFormMetrics.selectionIndicatorInset,
                      ),
                      child: AnimatedContainer(
                        duration: context.klp.motion.styleTransition,
                        decoration: BoxDecoration(
                          color: selected ? tokens.selection : null,
                          borderRadius: BorderRadius.circular(
                            context.klp.shape.control - 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: context.klp.space.compact),
          KlpText(label),
        ],
      ),
    );
  }
}
