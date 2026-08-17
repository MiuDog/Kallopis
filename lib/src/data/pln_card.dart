import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnCard extends StatelessWidget {
  const PlnCard({
    super.key,
    required this.title,
    required this.child,
    this.label,
    this.leading,
    this.trailing,
    this.footer,
    this.selected = false,
  });

  final String title;
  final String? label;
  final Widget? leading;
  final Widget? trailing;
  final Widget child;
  final Widget? footer;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? tokens.selectionBackground : tokens.component,
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(PlnSpace.md),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: PlnSpace.sm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label != null)
                        PlnText(label!, role: PlnTextRole.label),
                      PlnText(title, role: PlnTextRole.bodyStrong),
                    ],
                  ),
                ),
                trailing ?? const SizedBox.shrink(),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(PlnSpace.md), child: child),
          if (footer != null)
            Padding(padding: const EdgeInsets.all(PlnSpace.sm), child: footer!),
        ],
      ),
    );
  }
}
