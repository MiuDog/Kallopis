import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../typography/pln_text.dart';

class PlnPanelHeader extends StatelessWidget {
  const PlnPanelHeader({
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
      padding: const EdgeInsets.symmetric(horizontal: PlnSpace.md),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: PlnSpace.sm),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlnText(
                  title,
                  role: PlnTextRole.bodyStrong,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (label != null)
                  PlnText(
                    label!,
                    role: PlnTextRole.label,
                    tone: PlnTextTone.faint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          for (final action in actions) ...[
            const SizedBox(width: PlnSpace.xs),
            action,
          ],
        ],
      ),
    );
  }
}
