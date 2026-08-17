import 'package:flutter/material.dart';

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
    series: [
      Color(0xFFE0BE73),
      Color(0xFFD3A152),
      Color(0xFFC6823D),
      Color(0xFFA96836),
      Color(0xFF895137),
      Color(0xFF683E33),
    ],
    seriesWash: [
      Color(0xFFF8F1E2),
      Color(0xFFF6EBD7),
      Color(0xFFF3E4CF),
      Color(0xFFEEDDD0),
      Color(0xFFE9D8D1),
      Color(0xFFE4D5D1),
    ],
    axis: Color(0xFFD6D0C6),
    grid: Color(0xFFE4E1DA),
    gridStrong: Color(0xFFC8C0B4),
    label: Color(0xFF6B6459),
    value: Color(0xFF1D1D1D),
    plotBackground: Color(0x00000000),
    crosshair: Color(0xFF8C8477),
    marketUp: Color(0xFF2D8057),
    marketUpWash: Color(0xFFDFF0E5),
    marketDown: Color(0xFFA7443F),
    marketDownWash: Color(0xFFFAE3E2),
    marketFlat: Color(0xFF8C8477),
  );

  static const dark = KlpDataVisualizationTheme(
    series: [
      Color(0xFFF0D79A),
      Color(0xFFE8BD70),
      Color(0xFFDFA04E),
      Color(0xFFC88745),
      Color(0xFFA86D43),
      Color(0xFF89573E),
    ],
    seriesWash: [
      Color(0xFF453D2B),
      Color(0xFF443725),
      Color(0xFF413222),
      Color(0xFF3D2D22),
      Color(0xFF382A23),
      Color(0xFF332724),
    ],
    axis: Color(0xFF585249),
    grid: Color(0xFF433F3A),
    gridStrong: Color(0xFF6A6256),
    label: Color(0xFFB8B2A4),
    value: Color(0xFFF5F2EC),
    plotBackground: Color(0x00000000),
    crosshair: Color(0xFF918A7B),
    marketUp: Color(0xFF67AE86),
    marketUpWash: Color(0xFF243B2D),
    marketDown: Color(0xFFD27B74),
    marketDownWash: Color(0xFF472925),
    marketFlat: Color(0xFF918A7B),
  );

  static const ultraDark = KlpDataVisualizationTheme(
    series: [
      Color(0xFFF0D79A),
      Color(0xFFE8BD70),
      Color(0xFFDFA04E),
      Color(0xFFC88745),
      Color(0xFFA86D43),
      Color(0xFF89573E),
    ],
    seriesWash: [
      Color(0xFF302B20),
      Color(0xFF30271B),
      Color(0xFF2E241A),
      Color(0xFF2C211B),
      Color(0xFF291F1C),
      Color(0xFF261D1C),
    ],
    axis: Color(0xFF45413A),
    grid: Color(0xFF34302B),
    gridStrong: Color(0xFF585249),
    label: Color(0xFFB8B2A4),
    value: Color(0xFFF5F2EC),
    plotBackground: Color(0x00000000),
    crosshair: Color(0xFF7A7566),
    marketUp: Color(0xFF67AE86),
    marketUpWash: Color(0xFF1D3025),
    marketDown: Color(0xFFD27B74),
    marketDownWash: Color(0xFF3B2320),
    marketFlat: Color(0xFF7A7566),
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

  @override
  KlpDataVisualizationTheme lerp(
    covariant KlpDataVisualizationTheme? other,
    double t,
  ) {
    if (other == null) return this;

    return KlpDataVisualizationTheme(
      series: _lerpColors(series, other.series, t),
      seriesWash: _lerpColors(seriesWash, other.seriesWash, t),
      axis: Color.lerp(axis, other.axis, t)!,
      grid: Color.lerp(grid, other.grid, t)!,
      gridStrong: Color.lerp(gridStrong, other.gridStrong, t)!,
      label: Color.lerp(label, other.label, t)!,
      value: Color.lerp(value, other.value, t)!,
      plotBackground: Color.lerp(plotBackground, other.plotBackground, t)!,
      crosshair: Color.lerp(crosshair, other.crosshair, t)!,
      marketUp: Color.lerp(marketUp, other.marketUp, t)!,
      marketUpWash: Color.lerp(marketUpWash, other.marketUpWash, t)!,
      marketDown: Color.lerp(marketDown, other.marketDown, t)!,
      marketDownWash: Color.lerp(marketDownWash, other.marketDownWash, t)!,
      marketFlat: Color.lerp(marketFlat, other.marketFlat, t)!,
    );
  }

  static List<Color> _lerpColors(
    List<Color> first,
    List<Color> second,
    double t,
  ) {
    final count = first.length < second.length ? first.length : second.length;
    return [
      for (var index = 0; index < count; index++)
        Color.lerp(first[index], second[index], t)!,
    ];
  }
}

extension KlpDataVisualizationThemeContext on BuildContext {
  KlpDataVisualizationTheme get plnDataVisualizationTheme {
    return Theme.of(this).extension<KlpDataVisualizationTheme>() ??
        KlpDataVisualizationTheme.light;
  }
}
