import 'package:flutter/material.dart';

import '../tokens/klp_scale.dart';

/// 表面的分層手法：純色階層 (tone)、實線邊框 (outline)、霧化透明 (frosted)、原生 Box 漸層 (gradient) 或傳統陰影 (shadow)。
///
/// 多種手法各有適用場景。不推薦單純依賴陰影；現代介面更推崇純色階明度差、
/// 清晰邊框、壓克力霧化或微漸層光澤。
enum KlpSurfaceSeparation {
  /// 單調特殊顏色 / 表面色階分層（純色明度階梯，無邊框無陰影）。
  tone,

  /// 用實線邊框分層，不使用陰影（推薦之清晰結構手法）。
  outline,

  /// 霧化透明 / 毛玻璃分層（BackdropFilter 搭配半透明表面）。
  frosted,

  /// 原生 Box 漸層與微光分層。
  gradient,

  /// 用陰影分層（不推薦之傳統做法，僅為相容性保留）。
  shadow,
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
    required this.selectionWashOpacity,
  });

  final KlpSurfaceSeparation separation;

  final double overlayBlur;
  final double overlaySpread;
  final double overlayOffsetY;
  final double overlayShadowOpacity;

  /// hover 時前景色混入表面的比例。走反白而非微亮的風格，這個比例會高很多。
  final double hoverContrastMix;

  final double scrimOpacity;

  /// 選取狀態的壓深層強度。用前景色以低 alpha 疊上，因此亮態壓暗、暗態壓亮，
  /// 且底下表面原本的階層差不會被蓋掉。
  ///
  /// 與 [hoverContrastMix] 是兩種強度而非同一種：hover 只用低對比邊框表示可點，
  /// 選取才加上這層壓深。兩者若共用一個值，兩態在畫面上就分不出來。
  final double selectionWashOpacity;

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
    selectionWashOpacity: KlpScale.opacity100,
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
    double? selectionWashOpacity,
  }) {
    return KlpSurfaceTheme(
      separation: separation ?? this.separation,
      overlayBlur: overlayBlur ?? this.overlayBlur,
      overlaySpread: overlaySpread ?? this.overlaySpread,
      overlayOffsetY: overlayOffsetY ?? this.overlayOffsetY,
      overlayShadowOpacity: overlayShadowOpacity ?? this.overlayShadowOpacity,
      hoverContrastMix: hoverContrastMix ?? this.hoverContrastMix,
      scrimOpacity: scrimOpacity ?? this.scrimOpacity,
      selectionWashOpacity: selectionWashOpacity ?? this.selectionWashOpacity,
    );
  }

  /// **不做內插。**
  ///
  /// `MaterialApp` 在 theme 變更時會跑一段過場並沿路呼叫 `lerp`。各層若各自內插，
  /// 中途會出現「某幾層已經換了、某幾層還沒」的混合狀態——那正是切換深淺色時看起來
  /// 「有些元件沒有跟著變」的原因：它們不是沒變，是停在中間值上。
  ///
  /// 因此整個 token 疊層一律在中點原子性地翻轉，任何時刻都只會是完整的其中一套。
  @override
  KlpSurfaceTheme lerp(covariant KlpSurfaceTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
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
          scrimOpacity == other.scrimOpacity &&
          selectionWashOpacity == other.selectionWashOpacity;

  @override
  int get hashCode => Object.hash(
    separation,
    overlayBlur,
    overlaySpread,
    overlayOffsetY,
    overlayShadowOpacity,
    hoverContrastMix,
    scrimOpacity,
    selectionWashOpacity,
  );
}
