import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import '../foundation/klp_palette.dart';

/// 表面在階層中的位置。由淺到深：`base` → `inset` → `muted`，另有 `component`
/// （控制項底色）、`overlay`（浮層）、`raised`（次級內容區）與 `transparent`。
enum KlpSurfaceTone {
  base,
  inset,
  muted,
  component,
  overlay,
  raised,
  transparent,
}

/// 有底色的容器，是所有區塊的基底。`tone` 指定它在表面階層中的位置，
/// 實際色值與圓角由 theme 決定。
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
