import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../styling/legacy_theme/klp_theme.dart';
import 'klp_surface_tone.dart';

export 'klp_surface_tone.dart';

/// 有底色的容器，是所有區塊的基底。`tone` 指定它在表面階層中的位置，
/// 支援邊框、微漸層、外發光與霧化透明（毛玻璃）等多種原生 Box 視覺效果。
class KlpSurface extends StatelessWidget {
  const KlpSurface({
    super.key,
    required this.child,
    this.tone = KlpSurfaceTone.base,
    this.radius,
    this.padding,
    this.border,
    this.gradient,
    this.shadows,
    this.frosted = false,
    this.blurSigma,
  });

  final Widget child;
  final KlpSurfaceTone tone;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final bool frosted;
  final double? blurSigma;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = klp.color;
    final effectiveRadius =
        radius ?? (tone == KlpSurfaceTone.app ? 0 : klp.cardRadius);
    final background = switch (tone) {
      KlpSurfaceTone.app => tokens.app,
      KlpSurfaceTone.base => tokens.surface,
      KlpSurfaceTone.inset => tokens.surfaceInset,
      KlpSurfaceTone.muted => tokens.surfaceMuted,
      KlpSurfaceTone.component => tokens.component,
      KlpSurfaceTone.overlay => tokens.overlay,
      KlpSurfaceTone.raised => tokens.surfaceRaised,
      KlpSurfaceTone.stage => tokens.stageSurface,
      KlpSurfaceTone.accent => tokens.accent,
      KlpSurfaceTone.accentSoft => tokens.accentSoft,
      KlpSurfaceTone.transparent => tokens.clear,
    };
    final preservesExactRadius =
        tone == KlpSurfaceTone.transparent || tone == KlpSurfaceTone.app;
    var resolvedRadius = effectiveRadius;
    if (!preservesExactRadius) {
      resolvedRadius = effectiveRadius
          .clamp(klp.shape.control, double.infinity)
          .toDouble();
    }

    Widget result = Padding(padding: padding ?? EdgeInsets.zero, child: child);
    if (background != tokens.clear && background.a > 0) {
      final surfaceTokens = tokens.onBackground(background);

      result = KlpTokenOverride(colors: surfaceTokens, child: result);
    }

    var effectiveBackground = background;
    if (frosted && background != tokens.clear) {
      effectiveBackground = background.withValues(
        alpha: klp.surface.frostedOpacity,
      );
    }
    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: gradient != null ? null : effectiveBackground,
        gradient: gradient,
        borderRadius: BorderRadius.circular(resolvedRadius),
        border: border,
      ),
      child: result,
    );

    if (frosted) {
      surface = ClipRRect(
        borderRadius: BorderRadius.circular(resolvedRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma ?? klp.surface.backdropBlurSigma,
            sigmaY: blurSigma ?? klp.surface.backdropBlurSigma,
          ),
          child: surface,
        ),
      );
    }

    if (shadows != null && shadows!.isNotEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(resolvedRadius),
          boxShadow: shadows,
        ),
        child: surface,
      );
    }

    return surface;
  }
}
