part of '../klp_metrics.dart';

/// 舊版 static const 字型階梯；新元件必須改讀 context.klp.type。
abstract final class KlpTypography {
  static const String sansFamily = 'packages/kallopis/Noto Sans TC';
  static const List<String> sansFallback = [
    'Noto Sans TC',
    'Microsoft JhengHei UI',
    'Microsoft JhengHei',
    'PingFang TC',
    'sans-serif',
  ];
  static const String monoFamily = 'packages/kallopis/IBM Plex Mono';
  static const List<String> monoFallback = [
    sansFamily,
    'IBM Plex Mono',
    'Consolas',
    'Courier New',
    'monospace',
  ];
  static const String uiFamily = sansFamily;
  static const List<String> uiFallback = sansFallback;
  static const String bodyFamily = sansFamily;
  static const List<String> bodyFallback = sansFallback;
  static const double micro = 10;
  static const double caption = 12;
  static const double small = 12;
  static const double sub = 14;
  static const double body = 16;
  static const double lead = 18;
  static const double h4 = 22;
  static const double h3 = 28;
  static const double section = 28;
  static const double headingSmall = 22;
  static const double h2 = 36;
  static const double heading = 36;
  static const double editorHeading = 36;
  static const double h1 = 48;
  static const double title = 48;
  static const double headline = 48;
  static const double display = 64;
  static const double hero = 64;
  static const double microLineHeight = 1.200;
  static const double captionLineHeight = 1.333;
  static const double subLineHeight = 1.428;
  static const double bodyLineHeight = 1.500;
  static const double leadLineHeight = 1.555;
  static const double h4LineHeight = 1.272;
  static const double h3LineHeight = 1.285;
  static const double h2LineHeight = 1.222;
  static const double h1LineHeight = 1.166;
  static const double displayLineHeight = 1.125;
  static const double displayLetterSpacing = -0.5;
  static const double labelLetterSpacing = 1.2;
  static const double uiBaselineOffset = 0;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w400;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w700;
}
