import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';

class PlnTooltip extends StatelessWidget {
  const PlnTooltip({super.key, required this.message, required this.child});

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(message: message, excludeFromSemantics: true, child: child);
  }
}

class PlnTooltipSurface extends StatelessWidget {
  const PlnTooltipSurface({super.key, required this.message, this.contentKey});

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
          borderRadius: BorderRadius.circular(PlnRadius.control),
        );
    final textStyle =
        theme.textStyle ??
        TextStyle(
          color: tokens.textMuted,
          fontSize: PlnTypography.small,
          fontFamily: PlnTypography.uiFamily,
          fontFamilyFallback: PlnTypography.uiFallback,
        );

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        key: contentKey,
        padding:
            theme.padding ??
            const EdgeInsets.symmetric(
              horizontal: PlnSpace.sm,
              vertical: PlnSpace.xs,
            ),
        child: Text(message, style: textStyle),
      ),
    );
  }
}
