import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';

enum KlpSurfaceTone {
  base,
  inset,
  muted,
  component,
  overlay,
  settingsNavigation,
  settingsContent,
  transparent,
}

class KlpSurface extends StatelessWidget {
  const KlpSurface({
    super.key,
    required this.child,
    this.tone = KlpSurfaceTone.base,
    @Deprecated('Structure surfaces never draw strokes. Use KlpStrokeFrame.')
    this.border = false,
    this.radius = KlpRadius.card,
    this.padding,
  });

  final Widget child;
  final KlpSurfaceTone tone;
  final bool border;
  final double radius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final background = switch (tone) {
      KlpSurfaceTone.base => tokens.surface,
      KlpSurfaceTone.inset => tokens.surfaceInset,
      KlpSurfaceTone.muted => tokens.surfaceMuted,
      KlpSurfaceTone.component => tokens.component,
      KlpSurfaceTone.overlay => tokens.overlay,
      KlpSurfaceTone.settingsNavigation => tokens.settingsNavigation,
      KlpSurfaceTone.settingsContent => tokens.settingsContent,
      KlpSurfaceTone.transparent => const Color(0x00000000),
    };
    final resolvedRadius = tone == KlpSurfaceTone.transparent
        ? radius
        : radius.clamp(KlpRadius.sm, double.infinity).toDouble();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(resolvedRadius),
      ),
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );
  }
}
