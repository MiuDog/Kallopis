import 'package:kallopis/kallopis_declarative.dart';

/// 兩套完整中立原料只供操作示範，並非本庫正式預設風格。
KlpPrimitiveSet demoPrimitives({required bool alternate}) {
  final List<KlpColor> colors;
  if (alternate) {
    colors = [
      KlpColor(240, 242, 246),
      KlpColor(18, 22, 28),
      KlpColor(186, 198, 216),
      KlpColor(160, 176, 198),
      KlpColor(128, 148, 176),
      KlpColor(96, 120, 158),
      KlpColor(56, 88, 144),
      KlpColor(20, 64, 136),
    ];
  } else {
    colors = [
      KlpColor(18, 22, 28),
      KlpColor(244, 246, 250),
      KlpColor(56, 66, 82),
      KlpColor(72, 88, 110),
      KlpColor(96, 116, 144),
      KlpColor(128, 152, 180),
      KlpColor(164, 190, 220),
      KlpColor(132, 184, 255),
    ];
  }
  return KlpPrimitiveSet(
    colors: colors,
    distances: [
      0.0,
      4.0,
      8.0,
      16.0,
      24.0,
      32.0,
      40.0,
      48.0,
    ].map(KlpDistance.new).toList(),
    radii: [
      0.0,
      4.0,
      8.0,
      12.0,
      16.0,
      20.0,
      24.0,
      32.0,
    ].map(KlpRadius.new).toList(),
    strokeWidths: [
      0.0,
      1.0,
      1.5,
      2.0,
      2.5,
      3.0,
      3.5,
      4.0,
    ].map(KlpStrokeWidth.new).toList(),
    fontSizes: [
      10.0,
      12.0,
      14.0,
      16.0,
      18.0,
      20.0,
      24.0,
      32.0,
    ].map(KlpFontSize.new).toList(),
    fontWeights: [
      100,
      200,
      300,
      400,
      500,
      600,
      700,
      800,
    ].map(KlpFontWeight.new).toList(),
    lineHeights: [
      1.0,
      1.2,
      1.3,
      1.4,
      1.5,
      1.6,
      1.8,
      2.0,
    ].map(KlpLineHeight.new).toList(),
    letterSpacings: [
      -0.3,
      -0.2,
      -0.1,
      0.0,
      0.1,
      0.2,
      0.3,
      0.4,
    ].map(KlpLetterSpacing.new).toList(),
    durations: [
      0,
      60,
      100,
      140,
      180,
      240,
      320,
      400,
    ].map(KlpDuration.new).toList(),
    fontFamilies: List.generate(
      8,
      (_) => KlpFontFamily(
        'packages/kallopis/IBM Plex Mono',
        fallback: const ['packages/kallopis/Noto Sans TC'],
      ),
    ),
    curves: List.generate(8, (_) => KlpCurve(0.2, 0.0, 0.2, 1.0)),
  );
}
