import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnTabs extends StatelessWidget {
  const PlnTabs({
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
      height: PlnSize.tab,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var index = 0; index < tabs.length; index++) ...[
              _PlnTab(
                label: tabs[index],
                selected: selected == index,
                onPressed: () => onSelected(index),
              ),
              if (index < tabs.length - 1) const SizedBox(width: PlnSpace.xs),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlnTab extends StatelessWidget {
  const _PlnTab({
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

    return Material(
      color: selected ? tokens.surfaceMuted : tokens.surfaceInset,
      borderRadius: BorderRadius.circular(PlnRadius.control),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: Container(
          height: PlnSize.tab,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: PlnSpace.md),
          child: PlnText(
            label,
            role: PlnTextRole.body,
            tone: selected ? PlnTextTone.primary : PlnTextTone.muted,
          ),
        ),
      ),
    );
  }
}
