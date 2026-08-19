import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

import '../foundation/klp_palette.dart';
import '../theme/klp_theme.dart';

/// 表面在階層中的位置。由淺到深：`base` → `inset` → `muted`，另有 `component`
/// （控制項底色）、`overlay`（浮層）、`raised`（次級內容區）、`stage`（舞台區）、
/// `accent` / `accentSoft`（強調色表面）與 `transparent`。
enum KlpSurfaceTone {
  base,
  inset,
  muted,
  component,
  overlay,
  raised,
  stage,
  accent,
  accentSoft,
  transparent,
}

/// 有底色的容器，是所有區塊的基底。`tone` 指定它在表面階層中的位置，
/// 支援邊框、微漸層、外發光與霧化透明（毛玻璃）等多種原生 Box 視覺效果。
/// 文字顏色依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）自適應渲染。
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

  /// `null` 表示沿用 theme 的卡片圓角。指定值只用於刻意偏離的場合。
  final double? radius;
  final EdgeInsetsGeometry? padding;

  /// 自訂外邊框或方向性邊線。
  final BoxBorder? border;

  /// 背景微漸層效果。
  final Gradient? gradient;

  /// 投影、內發光或外發光光暈效果。
  final List<BoxShadow>? shadows;

  /// 是否啟用毛玻璃（BackdropFilter 霧化透明）效果。
  final bool frosted;

  /// 霧化透明之高斯模糊強度 (sigma)。預設為 12.0。
  final double? blurSigma;

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
      KlpSurfaceTone.stage => tokens.stageSurface,
      KlpSurfaceTone.accent => tokens.accent,
      KlpSurfaceTone.accentSoft => tokens.accentSoft,
      KlpSurfaceTone.transparent => KlpPalette.transparent,
    };
    final resolvedRadius = tone == KlpSurfaceTone.transparent
        ? effectiveRadius
        : effectiveRadius.clamp(klp.shape.control, double.infinity).toDouble();

    Widget result = Padding(padding: padding ?? EdgeInsets.zero, child: child);

    if (background != KlpPalette.transparent && background.a > 0) {
      final surfaceTokens = tokens.onBackground(background);
      result = KlpTokenOverride(colors: surfaceTokens, child: result);
    }

    final effectiveBg = frosted
        ? (background == KlpPalette.transparent
              ? KlpPalette.transparent
              : background.withValues(alpha: klp.surface.frostedOpacity))
        : background;

    Widget surfaceBox = DecoratedBox(
      decoration: BoxDecoration(
        color: gradient != null ? null : effectiveBg,
        gradient: gradient,
        borderRadius: BorderRadius.circular(resolvedRadius),
        border: border,
      ),
      child: result,
    );

    if (frosted) {
      surfaceBox = ClipRRect(
        borderRadius: BorderRadius.circular(resolvedRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma ?? 12.0,
            sigmaY: blurSigma ?? 12.0,
          ),
          child: surfaceBox,
        ),
      );
    }

    if (shadows != null && shadows!.isNotEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(resolvedRadius),
          boxShadow: shadows,
        ),
        child: surfaceBox,
      );
    }

    return surfaceBox;
  }
}
