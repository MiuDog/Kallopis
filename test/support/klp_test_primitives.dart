import 'package:kallopis/kallopis_declarative.dart';

/// 兩套差異明確的測試原料，不是正式預設風格。
KlpPrimitiveSet klpTestPrimitives({bool alternate = false}) {
  final factor = alternate ? 2.0 : 1.0;
  final fontFamily = alternate
      ? 'packages/kallopis/IBM Plex Mono'
      : 'packages/kallopis/Noto Sans TC';
  return KlpPrimitiveSet(
    colors: List.generate(
      8,
      (index) => KlpColor(
        alternate ? 255 - index * 24 : index * 24,
        index * 16,
        alternate ? 48 : 128,
      ),
    ),
    distances: List.generate(8, (index) => KlpDistance(index * 4 * factor)),
    radii: List.generate(8, (index) => KlpRadius(index * factor)),
    strokeWidths: List.generate(
      8,
      (index) => KlpStrokeWidth(index * 0.5 * factor),
    ),
    fontSizes: List.generate(
      8,
      (index) => KlpFontSize((10 + index * 2) * factor),
    ),
    fontWeights: List.generate(
      8,
      (index) => KlpFontWeight(100 + index * 100 + (alternate ? 50 : 0)),
    ),
    lineHeights: List.generate(
      8,
      (index) => KlpLineHeight(1 + index * 0.1 * factor),
    ),
    letterSpacings: List.generate(
      8,
      (index) => KlpLetterSpacing((index - 3) * 0.1 * factor),
    ),
    durations: List.generate(
      8,
      (index) => KlpDuration(index * (alternate ? 40 : 20)),
    ),
    fontFamilies: List.generate(
      8,
      (_) => KlpFontFamily(fontFamily, fallback: const ['sans-serif']),
    ),
    curves: List.generate(
      8,
      (index) => KlpCurve(
        0.1 + index * 0.05,
        alternate ? 0.2 : 0.0,
        0.6 + index * 0.05,
        alternate ? 0.8 : 1.0,
      ),
    ),
  );
}
