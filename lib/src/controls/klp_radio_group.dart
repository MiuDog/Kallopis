import 'package:flutter/material.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

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
      spacing: KlpSpace.lg,
      runSpacing: KlpSpace.sm,
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
      padding: const EdgeInsets.symmetric(vertical: KlpSpace.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            checked: selected,
            inMutuallyExclusiveGroup: true,
            label: label,
            child: Material(
              color: const Color(0x00000000),
              borderRadius: BorderRadius.circular(KlpRadius.control),
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(KlpRadius.control),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: tokens.textMuted,
                      width: KlpLine.width,
                    ),
                    borderRadius: BorderRadius.circular(KlpRadius.control),
                  ),
                  child: SizedBox.square(
                    dimension: KlpFormMetrics.selectionControl,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        KlpFormMetrics.selectionIndicatorInset,
                      ),
                      child: AnimatedContainer(
                        duration: KlpMotion.styleTransition,
                        decoration: BoxDecoration(
                          color: selected ? tokens.selection : null,
                          borderRadius: BorderRadius.circular(KlpRadius.sm - 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: KlpSpace.sm),
          KlpText(label),
        ],
      ),
    );
  }
}
