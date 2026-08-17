import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
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
    final tokens = context.plnTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 400;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: KlpSpace.sm),
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
              const SizedBox(width: KlpSpace.sm),
              Expanded(
                child: KlpText(
                  leading,
                  role: KlpTextRole.code,
                  tone: KlpTextTone.muted,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!compact)
                KlpText(
                  trailing,
                  role: KlpTextRole.code,
                  tone: KlpTextTone.faint,
                ),
            ],
          ),
        );
      },
    );
  }
}
