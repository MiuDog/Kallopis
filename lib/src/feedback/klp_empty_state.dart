import 'package:flutter/widgets.dart';

import '../foundation/klp_icon.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpEmptyState extends StatelessWidget {
  const KlpEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final String icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return KlpDashedBorder(
      radius: klp.shape.card,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(klp.space.section),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            KlpIcon(icon, size: klp.space.iconLarge, color: tokens.textMuted),
            SizedBox(height: klp.space.comfortable),
            KlpText(
              title,
              role: KlpTextRole.section,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: klp.space.tight),
            KlpText(
              message,
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              SizedBox(height: klp.space.comfortable),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class KlpSkeletonLine extends StatelessWidget {
  const KlpSkeletonLine({super.key, this.width = double.infinity});

  final double width;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: width,
        height: context.klp.space.skeletonLine,
        decoration: BoxDecoration(
          color: context.klpColors.surfaceInset,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
        ),
      ),
    );
  }
}
