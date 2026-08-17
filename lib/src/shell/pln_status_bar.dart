import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnStatusBar extends StatelessWidget {
  const PlnStatusBar({
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
    final tokens = context.plnTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 400;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: PlnSpace.sm),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? tokens.success : tokens.textFaint,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: PlnSpace.sm),
              Expanded(
                child: PlnText(
                  leading,
                  role: PlnTextRole.code,
                  tone: PlnTextTone.muted,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!compact)
                PlnText(
                  trailing,
                  role: PlnTextRole.code,
                  tone: PlnTextTone.faint,
                ),
            ],
          ),
        );
      },
    );
  }
}
