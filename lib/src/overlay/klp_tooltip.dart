import 'package:flutter/material.dart';

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
    final tokens = context.klpColors;
    final decoration =
        theme.decoration ??
        BoxDecoration(
          color: tokens.overlay,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
        );
    final textStyle =
        theme.textStyle ??
        TextStyle(
          color: tokens.textMuted,
          fontSize: context.klp.type.caption,
          fontFamily: context.klp.type.uiFamily,
          fontFamilyFallback: context.klp.type.fallbackFor(
            context.klp.type.uiFamily,
          ),
        );

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        key: contentKey,
        padding:
            theme.padding ??
            EdgeInsets.symmetric(
              horizontal: context.klp.space.compact,
              vertical: context.klp.space.tight,
            ),
        child: Text(message, style: textStyle),
      ),
    );
  }
}
