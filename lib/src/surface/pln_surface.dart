import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';

enum PlnSurfaceTone {
  base,
  inset,
  muted,
  component,
  overlay,
  settingsNavigation,
  settingsContent,
  transparent,
}

class PlnSurface extends StatelessWidget {
  const PlnSurface({
    super.key,
    required this.child,
    this.tone = PlnSurfaceTone.base,
    @Deprecated('Structure surfaces never draw strokes. Use PlnStrokeFrame.')
    this.border = false,
    this.radius = PlnRadius.card,
    this.padding,
  });

  final Widget child;
  final PlnSurfaceTone tone;
  final bool border;
  final double radius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final background = switch (tone) {
      PlnSurfaceTone.base => tokens.surface,
      PlnSurfaceTone.inset => tokens.surfaceInset,
      PlnSurfaceTone.muted => tokens.surfaceMuted,
      PlnSurfaceTone.component => tokens.component,
      PlnSurfaceTone.overlay => tokens.overlay,
      PlnSurfaceTone.settingsNavigation => tokens.settingsNavigation,
      PlnSurfaceTone.settingsContent => tokens.settingsContent,
      PlnSurfaceTone.transparent => const Color(0x00000000),
    };
    final resolvedRadius = tone == PlnSurfaceTone.transparent
        ? radius
        : radius.clamp(PlnRadius.sm, double.infinity).toDouble();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(resolvedRadius),
      ),
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );
  }
}
