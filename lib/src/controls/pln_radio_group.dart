import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnRadioGroup<T> extends StatelessWidget {
  const PlnRadioGroup({
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
      spacing: PlnSpace.lg,
      runSpacing: PlnSpace.sm,
      children: [
        for (final entry in items.entries)
          _PlnRadioItem(
            label: entry.value,
            selected: entry.key == value,
            onPressed: () => onChanged(entry.key),
          ),
      ],
    );
  }
}

class _PlnRadioItem extends StatelessWidget {
  const _PlnRadioItem({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PlnSpace.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            checked: selected,
            inMutuallyExclusiveGroup: true,
            label: label,
            child: Material(
              color: const Color(0x00000000),
              borderRadius: BorderRadius.circular(PlnRadius.control),
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(PlnRadius.control),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: tokens.textMuted,
                      width: PlnLine.width,
                    ),
                    borderRadius: BorderRadius.circular(PlnRadius.control),
                  ),
                  child: SizedBox.square(
                    dimension: PlnFormMetrics.selectionControl,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        PlnFormMetrics.selectionIndicatorInset,
                      ),
                      child: AnimatedContainer(
                        duration: PlnMotion.styleTransition,
                        decoration: BoxDecoration(
                          color: selected ? tokens.selection : null,
                          borderRadius: BorderRadius.circular(PlnRadius.sm - 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: PlnSpace.sm),
          PlnText(label),
        ],
      ),
    );
  }
}
