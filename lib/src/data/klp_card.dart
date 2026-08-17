import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpCard extends StatelessWidget {
  const KlpCard({
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
    final tokens = context.klpColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? tokens.selectionBackground : tokens.component,
        borderRadius: BorderRadius.circular(KlpRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(KlpSpace.md),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: KlpSpace.sm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label != null)
                        KlpText(label!, role: KlpTextRole.label),
                      KlpText(title, role: KlpTextRole.bodyStrong),
                    ],
                  ),
                ),
                trailing ?? const SizedBox.shrink(),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(KlpSpace.md), child: child),
          if (footer != null)
            Padding(padding: const EdgeInsets.all(KlpSpace.sm), child: footer!),
        ],
      ),
    );
  }
}
