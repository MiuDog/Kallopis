import 'package:flutter/material.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpTabs extends StatelessWidget {
  const KlpTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onSelected,
  });

  final List<String> tabs;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: KlpSize.tab,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var index = 0; index < tabs.length; index++) ...[
              _KlpTab(
                label: tabs[index],
                selected: selected == index,
                onPressed: () => onSelected(index),
              ),
              if (index < tabs.length - 1) const SizedBox(width: KlpSpace.xs),
            ],
          ],
        ),
      ),
    );
  }
}

class _KlpTab extends StatelessWidget {
  const _KlpTab({
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

    return Material(
      color: selected ? tokens.surfaceMuted : tokens.surfaceInset,
      borderRadius: BorderRadius.circular(KlpRadius.control),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(KlpRadius.control),
        child: Container(
          height: KlpSize.tab,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: KlpSpace.md),
          child: KlpText(
            label,
            role: KlpTextRole.body,
            tone: selected ? KlpTextTone.primary : KlpTextTone.muted,
          ),
        ),
      ),
    );
  }
}
