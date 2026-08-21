import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpRadioGroup<T> extends StatelessWidget {
  const KlpRadioGroup({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.descriptions,
    this.vertical = false,
  });

  final Map<T, String> items;
  final T value;
  final ValueChanged<T> onChanged;
  final Map<T, String>? descriptions;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final entry in items.entries) ...[
            _KlpRadioItem(
              label: entry.value,
              description: descriptions?[entry.key],
              selected: entry.key == value,
              onPressed: () => onChanged(entry.key),
            ),
            SizedBox(height: context.klp.space.tight),
          ],
        ],
      );
    }

    return Wrap(
      spacing: context.klp.space.comfortable,
      runSpacing: context.klp.space.compact,
      children: [
        for (final entry in items.entries)
          _KlpRadioItem(
            label: entry.value,
            description: descriptions?[entry.key],
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
    this.description,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final String? description;
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
              color: tokens.clear,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onPressed,
                customBorder: const CircleBorder(),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? tokens.text : tokens.textMuted,
                      width: context.klp.shape.stroke,
                    ),
                  ),
                  child: SizedBox.square(
                    dimension: context.klp.geometry.control.selectionControl,
                    child: Padding(
                      padding: EdgeInsets.all(
                        context.klp.geometry.control.selectionIndicatorInset,
                      ),
                      child: AnimatedContainer(
                        duration: context.klp.motion.styleTransition,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected ? tokens.text : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: context.klp.space.compact),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                KlpText(label, role: KlpTextRole.bodyStrong),
                if (description != null) ...[
                  SizedBox(height: context.klp.space.tight),
                  KlpText(
                    description!,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
