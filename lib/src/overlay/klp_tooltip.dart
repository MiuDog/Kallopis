import 'package:flutter/material.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';

class KlpTooltip extends StatelessWidget {
  const KlpTooltip({super.key, required this.message, required this.child});

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(message: message, excludeFromSemantics: true, child: child);
  }
}

class KlpTooltipSurface extends StatelessWidget {
  const KlpTooltipSurface({super.key, required this.message, this.contentKey});

  final String message;
  final Key? contentKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).tooltipTheme;
    final tokens = context.plnTheme;
    final decoration =
        theme.decoration ??
        BoxDecoration(
          color: tokens.overlay,
          borderRadius: BorderRadius.circular(KlpRadius.control),
        );
    final textStyle =
        theme.textStyle ??
        TextStyle(
          color: tokens.textMuted,
          fontSize: KlpTypography.small,
          fontFamily: KlpTypography.uiFamily,
          fontFamilyFallback: KlpTypography.uiFallback,
        );

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        key: contentKey,
        padding:
            theme.padding ??
            const EdgeInsets.symmetric(
              horizontal: KlpSpace.sm,
              vertical: KlpSpace.xs,
            ),
        child: Text(message, style: textStyle),
      ),
    );
  }
}
