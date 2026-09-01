import 'package:flutter/widgets.dart';

import '../typography/klp_text.dart';
import '../theme/klp_theme.dart';

class KlpPanelHeader extends StatelessWidget {
  const KlpPanelHeader({
    super.key,
    required this.title,
    this.label,
    this.leading,
    this.actions = const [],
    this.titleRole = KlpTextRole.bodyStrong,
  });

  final String title;
  final String? label;
  final Widget? leading;
  final List<Widget> actions;
  final KlpTextRole titleRole;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.klp.space.compact),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: context.klp.space.compact),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KlpText(
                  title,
                  role: titleRole,
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
            SizedBox(width: context.klp.space.tight),
            action,
          ],
        ],
      ),
    );
  }
}
