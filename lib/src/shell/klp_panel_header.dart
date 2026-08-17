import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../typography/klp_text.dart';

class KlpPanelHeader extends StatelessWidget {
  const KlpPanelHeader({
    super.key,
    required this.title,
    this.label,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final String? label;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KlpSpace.md),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: KlpSpace.sm),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KlpText(
                  title,
                  role: KlpTextRole.bodyStrong,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (label != null)
                  KlpText(
                    label!,
                    role: KlpTextRole.label,
                    tone: KlpTextTone.faint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          for (final action in actions) ...[
            const SizedBox(width: KlpSpace.xs),
            action,
          ],
        ],
      ),
    );
  }
}
