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
    required this.scrimOpacity,
    required this.selectionWashOpacity,
    required this.statusFillOpacity,
    required this.pressProgressOpacity,
    required this.diffFillOpacity,
    required this.gridLineOpacity,
    required this.veilOpacity,
    required this.statusRowOpacity,
    required this.statusRowSelectedOpacity,
    required this.statusRowOpacityDark,
    required this.statusRowSelectedOpacityDark,
    required this.frostedOpacity,
    required this.frostedVeilOpacity,
  });

  final KlpSurfaceSeparation separation;

  final double overlayBlur;
  final double overlaySpread;
  final double overlayOffsetY;
  final double overlayShadowOpacity;

  final double scrimOpacity;

  /// 選取狀態的壓深層強度。用前景色以低 alpha 疊上，因此亮態壓暗、暗態壓亮，
  /// 且底下表面原本的階層差不會被蓋掉。
  ///
  /// hover 只用低對比虛線細框表示可點，選取才加上這層壓深。若兩態共用一種表達，
  /// 畫面上就分不出來。
  final double selectionWashOpacity;

  /// 語意色當底時的疊層強度（danger 按鈕、狀態晶片）。
  final double statusFillOpacity;

  /// 長按進度條的疊層強度。
  final double pressProgressOpacity;

  /// 差異檢視中整行增刪底色的強度。
  final double diffFillOpacity;

  /// 資料格線由前景色推導時的強度。
  final double gridLineOpacity;

  /// 載入／禁用時蓋在內容上的遮罩強度。
  final double veilOpacity;

  /// 資料列以語意色染底時的強度。亮暗兩態分開，因為同一個 alpha 疊在深底與淺底上
  /// 讀起來的強度差很多。
  final double statusRowOpacity;

  /// 同上，選取中的資料列。
  final double statusRowSelectedOpacity;

  /// 同 [statusRowOpacity]，暗態。
  final double statusRowOpacityDark;

  /// 同 [statusRowSelectedOpacity]，暗態。
  final double statusRowSelectedOpacityDark;

  /// 霧化表面本身的透明度。
  final double frostedOpacity;

  /// 霧化套在透明表面上時借用的底色強度。
  final double frostedVeilOpacity;

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
    scrimOpacity: 0.6,
    selectionWashOpacity: KlpScale.opacity100,
    statusFillOpacity: KlpScale.opacity160,
    pressProgressOpacity: KlpScale.opacity550,
    diffFillOpacity: KlpScale.opacity120,
    gridLineOpacity: KlpScale.opacity180,
    veilOpacity: KlpScale.opacity820,
    statusRowOpacity: KlpScale.opacity140,
    statusRowSelectedOpacity: KlpScale.opacity320,
    statusRowOpacityDark: KlpScale.opacity280,
    statusRowSelectedOpacityDark: KlpScale.opacity480,
    frostedOpacity: KlpScale.opacity140,
    frostedVeilOpacity: KlpScale.opacity120,
  );

  @override
  KlpSurfaceTheme copyWith({
    KlpSurfaceSeparation? separation,
    double? overlayBlur,
    double? overlaySpread,
    double? overlayOffsetY,
    double? overlayShadowOpacity,
    double? scrimOpacity,
    double? selectionWashOpacity,
    double? statusFillOpacity,
    double? pressProgressOpacity,
    double? diffFillOpacity,
    double? gridLineOpacity,
    double? veilOpacity,
    double? statusRowOpacity,
    double? statusRowSelectedOpacity,
    double? statusRowOpacityDark,
    double? statusRowSelectedOpacityDark,
    double? frostedOpacity,
    double? frostedVeilOpacity,
  }) {
    return KlpSurfaceTheme(
      separation: separation ?? this.separation,
      overlayBlur: overlayBlur ?? this.overlayBlur,
      overlaySpread: overlaySpread ?? this.overlaySpread,
      overlayOffsetY: overlayOffsetY ?? this.overlayOffsetY,
      overlayShadowOpacity: overlayShadowOpacity ?? this.overlayShadowOpacity,
      scrimOpacity: scrimOpacity ?? this.scrimOpacity,
      selectionWashOpacity: selectionWashOpacity ?? this.selectionWashOpacity,
      statusFillOpacity: statusFillOpacity ?? this.statusFillOpacity,
      pressProgressOpacity: pressProgressOpacity ?? this.pressProgressOpacity,
      diffFillOpacity: diffFillOpacity ?? this.diffFillOpacity,
      gridLineOpacity: gridLineOpacity ?? this.gridLineOpacity,
      veilOpacity: veilOpacity ?? this.veilOpacity,
      statusRowOpacity: statusRowOpacity ?? this.statusRowOpacity,
      statusRowSelectedOpacity:
          statusRowSelectedOpacity ?? this.statusRowSelectedOpacity,
      statusRowOpacityDark: statusRowOpacityDark ?? this.statusRowOpacityDark,
      statusRowSelectedOpacityDark:
          statusRowSelectedOpacityDark ?? this.statusRowSelectedOpacityDark,
      frostedOpacity: frostedOpacity ?? this.frostedOpacity,
      frostedVeilOpacity: frostedVeilOpacity ?? this.frostedVeilOpacity,
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
          scrimOpacity == other.scrimOpacity &&
          selectionWashOpacity == other.selectionWashOpacity &&
          statusFillOpacity == other.statusFillOpacity &&
          pressProgressOpacity == other.pressProgressOpacity &&
          diffFillOpacity == other.diffFillOpacity &&
          gridLineOpacity == other.gridLineOpacity &&
          veilOpacity == other.veilOpacity &&
          statusRowOpacity == other.statusRowOpacity &&
          statusRowSelectedOpacity == other.statusRowSelectedOpacity &&
          statusRowOpacityDark == other.statusRowOpacityDark &&
          statusRowSelectedOpacityDark == other.statusRowSelectedOpacityDark &&
          frostedOpacity == other.frostedOpacity &&
          frostedVeilOpacity == other.frostedVeilOpacity;

  @override
  int get hashCode => Object.hash(
    separation,
    overlayBlur,
    overlaySpread,
    overlayOffsetY,
    overlayShadowOpacity,
    scrimOpacity,
    selectionWashOpacity,
    statusFillOpacity,
    pressProgressOpacity,
    diffFillOpacity,
    gridLineOpacity,
    veilOpacity,
    statusRowOpacity,
    statusRowSelectedOpacity,
    statusRowOpacityDark,
    statusRowSelectedOpacityDark,
    frostedOpacity,
    frostedVeilOpacity,
  );
}
