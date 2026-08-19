import 'package:flutter/widgets.dart';

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
    final tokens = context.klpColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 400;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.klp.space.compact),
          child: Row(
            children: [
              Container(
                width: context.klp.space.indicatorDot,
                height: context.klp.space.indicatorDot,
                decoration: BoxDecoration(
                  color: active ? tokens.success : tokens.textFaint,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: context.klp.space.compact),
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
