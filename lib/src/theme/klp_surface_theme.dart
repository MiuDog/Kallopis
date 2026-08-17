import 'package:flutter/material.dart';

import '../tokens/klp_scale.dart';

/// 表面的分層手法：用陰影，還是用邊框。
///
/// 這是終端機風與現代風最根本的分歧，而且兩者互斥——終端機用實線框界定區塊、完全沒有
/// 陰影；現代風用柔和陰影浮起、邊框極淡或省略。把它做成 enum 而不是兩組獨立的
/// shadow／border 參數，是為了讓「陰影開著又畫滿實線框」這種不會出錯但一定醜的組合
/// 從型別上就不可能出現。
enum KlpSurfaceSeparation {
  /// 用陰影分層，邊框僅作輔助。
  shadow,

  /// 用實線邊框分層，不使用陰影。
  outline,
}

/// Layer 2：表面分層與陰影的 semantic token。
@immutable
class KlpSurfaceTheme extends ThemeExtension<KlpSurfaceTheme> {
  const KlpSurfaceTheme({
    required this.separation,
    required this.overlayBlur,
    required this.overlaySpread,
    required this.overlayOffsetY,
    required this.overlayShadowOpacity,
    required this.hoverContrastMix,
    required this.scrimOpacity,
  });

  final KlpSurfaceSeparation separation;

  final double overlayBlur;
  final double overlaySpread;
  final double overlayOffsetY;
  final double overlayShadowOpacity;

  /// hover 時前景色混入表面的比例。終端機風通常用反白而非微亮，比例會高很多。
  final double hoverContrastMix;

  final double scrimOpacity;

  bool get usesShadow => separation == KlpSurfaceSeparation.shadow;

  /// 依分層手法產生浮層陰影。`outline` 風格回傳空清單——元件不需要知道現在是哪種風格。
  List<BoxShadow> overlayShadow(Color shadowColor) {
    if (!usesShadow) return const <BoxShadow>[];
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: overlayShadowOpacity),
        blurRadius: overlayBlur,
        spreadRadius: overlaySpread,
        offset: Offset(0, overlayOffsetY),
      ),
    ];
  }

  static const KlpSurfaceTheme elevated = KlpSurfaceTheme(
    separation: KlpSurfaceSeparation.shadow,
    overlayBlur: 18,
    overlaySpread: 1,
    overlayOffsetY: 8,
    overlayShadowOpacity: KlpScale.opacity220,
    hoverContrastMix: 0.08,
    scrimOpacity: 0.6,
  );

  static const KlpSurfaceTheme outlined = KlpSurfaceTheme(
    separation: KlpSurfaceSeparation.outline,
    overlayBlur: 0,
    overlaySpread: 0,
    overlayOffsetY: 0,
    overlayShadowOpacity: 0,
    hoverContrastMix: 0.16,
    scrimOpacity: 0.8,
  );

  @override
  KlpSurfaceTheme copyWith({
    KlpSurfaceSeparation? separation,
    double? overlayBlur,
    double? overlaySpread,
    double? overlayOffsetY,
    double? overlayShadowOpacity,
    double? hoverContrastMix,
    double? scrimOpacity,
  }) {
    return KlpSurfaceTheme(
      separation: separation ?? this.separation,
      overlayBlur: overlayBlur ?? this.overlayBlur,
      overlaySpread: overlaySpread ?? this.overlaySpread,
      overlayOffsetY: overlayOffsetY ?? this.overlayOffsetY,
      overlayShadowOpacity: overlayShadowOpacity ?? this.overlayShadowOpacity,
      hoverContrastMix: hoverContrastMix ?? this.hoverContrastMix,
      scrimOpacity: scrimOpacity ?? this.scrimOpacity,
    );
  }

  @override
  KlpSurfaceTheme lerp(covariant KlpSurfaceTheme? other, double t) {
    if (other == null) return this;
    double l(double a, double b) => a + (b - a) * t;
    return KlpSurfaceTheme(
      separation: t < 0.5 ? separation : other.separation,
      overlayBlur: l(overlayBlur, other.overlayBlur),
      overlaySpread: l(overlaySpread, other.overlaySpread),
      overlayOffsetY: l(overlayOffsetY, other.overlayOffsetY),
      overlayShadowOpacity: l(overlayShadowOpacity, other.overlayShadowOpacity),
      hoverContrastMix: l(hoverContrastMix, other.hoverContrastMix),
      scrimOpacity: l(scrimOpacity, other.scrimOpacity),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpSurfaceTheme &&
          separation == other.separation &&
          overlayBlur == other.overlayBlur &&
          overlaySpread == other.overlaySpread &&
          overlayOffsetY == other.overlayOffsetY &&
          overlayShadowOpacity == other.overlayShadowOpacity &&
          hoverContrastMix == other.hoverContrastMix &&
          scrimOpacity == other.scrimOpacity;

  @override
  int get hashCode => Object.hash(
    separation,
    overlayBlur,
    overlaySpread,
    overlayOffsetY,
    overlayShadowOpacity,
    hoverContrastMix,
    scrimOpacity,
  );
}
