import 'package:flutter/widgets.dart';

import '../foundation/klp_icon.dart';
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

    return Padding(
      padding: EdgeInsets.all(context.klp.space.section),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tokens.surfaceInset,
              borderRadius: BorderRadius.circular(context.klp.shape.card),
            ),
            child: KlpIcon(
              icon,
              size: context.klp.space.iconLarge,
              color: tokens.textMuted,
            ),
          ),
          SizedBox(height: context.klp.space.comfortable),
          KlpText(
            title,
            role: KlpTextRole.section,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.klp.space.tight),
          KlpText(
            message,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            SizedBox(height: context.klp.space.comfortable),
            action!,
          ],
        ],
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
        height: 10,
        decoration: BoxDecoration(
          color: context.klpColors.surfaceMuted,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
        ),
      ),
    );
  }
}
