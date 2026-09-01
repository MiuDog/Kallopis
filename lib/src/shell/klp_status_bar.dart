import 'package:flutter/widgets.dart';

import '../feedback/klp_status_indicator.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpStatusBar extends StatelessWidget {
  const KlpStatusBar({
    super.key,
    required this.leading,
    required this.trailing,
    this.active = true,
  });

  final String leading;
  final String trailing;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxWidth <
            context.klp.geometry.layout.statusBarBreakpoint;

        return Row(
          children: [
            Expanded(
              child: KlpStatusIndicator(
                label: leading,
                active: active,
                expanded: true,
              ),
            ),
            if (!compact)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  end: context.klp.space.compact,
                ),
                child: KlpText(
                  trailing,
                  role: KlpTextRole.code,
                  tone: KlpTextTone.faint,
                ),
              ),
          ],
        );
      },
    );
  }
}
