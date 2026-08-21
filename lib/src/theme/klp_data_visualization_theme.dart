import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../foundation/klp_palette.dart';

@immutable
class KlpDataVisualizationTheme
    extends ThemeExtension<KlpDataVisualizationTheme> {
  const KlpDataVisualizationTheme({
    required this.series,
    required this.seriesWash,
    required this.axis,
    required this.grid,
    required this.gridStrong,
    required this.label,
    required this.value,
    required this.plotBackground,
    required this.crosshair,
    required this.marketUp,
    required this.marketUpWash,
    required this.marketDown,
    required this.marketDownWash,
    required this.marketFlat,
  });

  final List<Color> series;
  final List<Color> seriesWash;
  final Color axis;
  final Color grid;
  final Color gridStrong;
  final Color label;
  final Color value;
  final Color plotBackground;
  final Color crosshair;
  final Color marketUp;
  final Color marketUpWash;
  final Color marketDown;
  final Color marketDownWash;
  final Color marketFlat;

  Color seriesColor(int index) {
    if (series.isEmpty) return value;
    return series[index.abs() % series.length];
  }

  Color seriesWashColor(int index) {
    if (seriesWash.isEmpty) return plotBackground;
    return seriesWash[index.abs() % seriesWash.length];
  }

  static const light = KlpDataVisualizationTheme(
    series: KlpPalette.chartSeriesLight,
    seriesWash: KlpPalette.chartSeriesWashLight,
    axis: KlpPalette.chartAxisLight,
    grid: KlpPalette.chartGridLight,
    gridStrong: KlpPalette.chartGridStrongLight,
    label: KlpPalette.chartLabelLight,
    value: KlpPalette.chartValueLight,
    plotBackground: KlpPalette.transparent,
    crosshair: KlpPalette.chartCrosshairLight,
    marketUp: KlpPalette.chartMarketUpLight,
    marketUpWash: KlpPalette.chartMarketUpWashLight,
    marketDown: KlpPalette.chartMarketDownLight,
    marketDownWash: KlpPalette.chartMarketDownWashLight,
    marketFlat: KlpPalette.chartMarketFlatLight,
  );

  static const dark = KlpDataVisualizationTheme(
    series: KlpPalette.chartSeriesDark,
    seriesWash: KlpPalette.chartSeriesWashDark,
    axis: KlpPalette.chartAxisDark,
    grid: KlpPalette.chartGridDark,
    gridStrong: KlpPalette.chartGridStrongDark,
    label: KlpPalette.chartLabelDark,
    value: KlpPalette.chartValueDark,
    plotBackground: KlpPalette.transparent,
    crosshair: KlpPalette.chartCrosshairDark,
    marketUp: KlpPalette.chartMarketUpDark,
    marketUpWash: KlpPalette.chartMarketUpWashDark,
    marketDown: KlpPalette.chartMarketDownDark,
    marketDownWash: KlpPalette.chartMarketDownWashDark,
    marketFlat: KlpPalette.chartMarketFlatDark,
  );

  static const ultraDark = KlpDataVisualizationTheme(
    series: KlpPalette.chartSeriesDark,
    seriesWash: KlpPalette.chartSeriesWashUltraDark,
    axis: KlpPalette.chartAxisUltraDark,
    grid: KlpPalette.chartGridUltraDark,
    gridStrong: KlpPalette.chartGridStrongUltraDark,
    label: KlpPalette.chartLabelUltraDark,
    value: KlpPalette.chartValueUltraDark,
    plotBackground: KlpPalette.transparent,
    crosshair: KlpPalette.chartCrosshairUltraDark,
    marketUp: KlpPalette.chartMarketUpUltraDark,
    marketUpWash: KlpPalette.chartMarketUpWashUltraDark,
    marketDown: KlpPalette.chartMarketDownUltraDark,
    marketDownWash: KlpPalette.chartMarketDownWashUltraDark,
    marketFlat: KlpPalette.chartMarketFlatUltraDark,
  );

  @override
  KlpDataVisualizationTheme copyWith({
    List<Color>? series,
    List<Color>? seriesWash,
    Color? axis,
    Color? grid,
    Color? gridStrong,
    Color? label,
    Color? value,
    Color? plotBackground,
    Color? crosshair,
    Color? marketUp,
    Color? marketUpWash,
    Color? marketDown,
    Color? marketDownWash,
    Color? marketFlat,
  }) {
    return KlpDataVisualizationTheme(
      series: series ?? this.series,
      seriesWash: seriesWash ?? this.seriesWash,
      axis: axis ?? this.axis,
      grid: grid ?? this.grid,
      gridStrong: gridStrong ?? this.gridStrong,
      label: label ?? this.label,
      value: value ?? this.value,
      plotBackground: plotBackground ?? this.plotBackground,
      crosshair: crosshair ?? this.crosshair,
      marketUp: marketUp ?? this.marketUp,
      marketUpWash: marketUpWash ?? this.marketUpWash,
      marketDown: marketDown ?? this.marketDown,
      marketDownWash: marketDownWash ?? this.marketDownWash,
      marketFlat: marketFlat ?? this.marketFlat,
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
  KlpDataVisualizationTheme lerp(
    covariant KlpDataVisualizationTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpDataVisualizationTheme &&
          listEquals(series, other.series) &&
          listEquals(seriesWash, other.seriesWash) &&
          axis == other.axis &&
          grid == other.grid &&
          gridStrong == other.gridStrong &&
          label == other.label &&
          value == other.value &&
          plotBackground == other.plotBackground &&
          crosshair == other.crosshair &&
          marketUp == other.marketUp &&
          marketUpWash == other.marketUpWash &&
          marketDown == other.marketDown &&
          marketDownWash == other.marketDownWash &&
          marketFlat == other.marketFlat;

  @override
  int get hashCode => Object.hashAll([
    Object.hashAll(series),
    Object.hashAll(seriesWash),
    axis,
    grid,
    gridStrong,
    label,
    value,
    plotBackground,
    crosshair,
    marketUp,
    marketUpWash,
    marketDown,
    marketDownWash,
    marketFlat,
  ]);
}

extension KlpDataVisualizationThemeContext on BuildContext {
  KlpDataVisualizationTheme get klpDataVisualization {
    return Theme.of(this).extension<KlpDataVisualizationTheme>() ??
        KlpDataVisualizationTheme.light;
  }
}
