import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import '../foundation/klp_palette.dart';

enum KlpSurfaceTone {
  base,
  inset,
  muted,
  component,
  overlay,
  raised,
  transparent,
}

class KlpSurface extends StatelessWidget {
  const KlpSurface({
    super.key,
    required this.child,
    this.tone = KlpSurfaceTone.base,
    this.radius,
    this.padding,
  });

  final Widget child;
  final KlpSurfaceTone tone;
  /// `null` 表示沿用 theme 的卡片圓角。指定值只用於刻意偏離的場合。
  final double? radius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = klp.color;
    final effectiveRadius = radius ?? klp.cardRadius;
    final background = switch (tone) {
      KlpSurfaceTone.base => tokens.surface,
      KlpSurfaceTone.inset => tokens.surfaceInset,
      KlpSurfaceTone.muted => tokens.surfaceMuted,
      KlpSurfaceTone.component => tokens.component,
      KlpSurfaceTone.overlay => tokens.overlay,
      KlpSurfaceTone.raised => tokens.surfaceRaised,
      KlpSurfaceTone.transparent => KlpPalette.transparent,
    };
    final resolvedRadius = tone == KlpSurfaceTone.transparent
        ? effectiveRadius
        : effectiveRadius.clamp(klp.shape.control, double.infinity).toDouble();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(resolvedRadius),
      ),
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );
  }
}
