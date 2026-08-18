import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 分頁列。`selected` 是索引，`tabs` 是顯示文字；本元件不持有狀態。
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
      height: context.klp.space.chromeTab,
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
              if (index < tabs.length - 1) SizedBox(width: context.klp.space.tight),
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
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: Container(
          height: context.klp.space.chromeTab,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: context.klp.space.base),
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
