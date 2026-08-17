import 'package:flutter/widgets.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnEmptyState extends StatelessWidget {
  const PlnEmptyState({
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
    final tokens = context.plnTheme;

    return Padding(
      padding: const EdgeInsets.all(PlnSpace.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tokens.surfaceInset,
              borderRadius: BorderRadius.circular(PlnRadius.card),
            ),
            child: PlnIcon(
              icon,
              size: PlnSize.iconLarge,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: PlnSpace.lg),
          PlnText(
            title,
            role: PlnTextRole.section,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PlnSpace.xs),
          PlnText(
            message,
            role: PlnTextRole.caption,
            tone: PlnTextTone.muted,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[const SizedBox(height: PlnSpace.lg), action!],
        ],
      ),
    );
  }
}

class PlnSkeletonLine extends StatelessWidget {
  const PlnSkeletonLine({super.key, this.width = double.infinity});

  final double width;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: width,
        height: 10,
        decoration: BoxDecoration(
          color: context.plnTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(PlnRadius.control),
        ),
      ),
    );
  }
}
