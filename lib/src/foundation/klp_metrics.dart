import 'package:flutter/widgets.dart';

abstract final class KlpSpace {
  static const double xxs = 2; // space-0.5
  static const double xs = 4; // space-1
  static const double sm = 8; // space-2
  static const double md = 12; // space-3
  static const double lg = 16; // space-4
  static const double xl = 24; // space-6
  static const double xxl = 32; // space-8
  static const double sectionLarge = 48; // space-12
  static const double page = 64; // space-16
  static const double pageLarge = 96; // space-24
}

abstract final class KlpLayoutGap {
  static const double lg = 10;
}

abstract final class KlpRadius {
  static const double none = 0;
  static const double sm = 2; // radius-sm: 2px
  static const double md = 8; // radius-md: 6px~8px
  static const double lg = 16; // radius-lg: 12px~16px
  static const double full = 9999; // radius-full: 9999px

  static const double control = md;
  static const double card = md;
  static const double panel = lg;
  static const double pill = full;
}

abstract final class KlpLine {
  static const double hairline = 1;
  static const double width = 2;
  static const double dashedLength = 3;
  static const double dashedGap = 2;
  static const double dashedOpacity = 0.78;
}

abstract final class KlpMotion {
  static const Duration themeTransition = Duration.zero;
  static const Duration styleTransition = Duration.zero;
}

abstract final class KlpElevation {
  static const double menuBlurRadius = 18;
  static const double menuSpreadRadius = 1;
  static const double menuOffsetY = 8;
  static const double menuShadowOpacity = 0.22;
}

abstract final class KlpSize {
  static const double controlSmall = 32; // SM: 32px
  static const double control = 40; // MD: 40px
  static const double controlLarge = 48; // LG: 48px
  static const double controlXLarge = 56; // XL: 56px
  static const double segmentedDense = 30;
  static const double segmentedDenseItem = 24;
  static const double iconButton = 32;
  static const double tab = 32;
  static const double iconSmall = 14; // 14px
  static const double iconBase = 16; // 16px
  static const double disclosure = 9;
  static const double icon = 20; // 20px
  static const double iconMedium = 24; // 24px
  static const double iconLarge = 32; // 32px
  static const double windowToolbar = 38;
  static const double rail = 56;
  static const double header = 60;
  static const double statusBar = 30;
  static const double listTileTrailingMax = 112;
  static const double primaryPaneBreakpoint = 400;
  static const double primaryPaneContentBreakpoint = 800;
  static const double secondaryPaneBreakpoint = 1120;
  static const double sidebar = 300;
  static const double inspector = 350;
  static const double menu = 200;
  static const double menuHeader = 28;
  static const double menuItem = 28;
}

abstract final class KlpFormMetrics {
  static const double fieldHeight = 30;
  static const double selectionControl = 14;
  static const double selectionIndicatorInset = 2;
  static const double selectionIndicator =
      selectionControl - selectionIndicatorInset * 2;
  static const double selectionIcon = 10;
  static const double toggleWidth = 30;
  static const double toggleHeight = 16;
  static const double toggleThumb = 12;
  static const double toggleInset = 2;
}

abstract final class KlpControlMetrics {
  static const double segmentedDenseInset = 3;
  static const double scrollbarThickness = 5;
  static const double scrollbarEndControlExtent = 14;
  static const double scrollbarEndControlRightInset =
      (scrollbarThickness - scrollbarEndControlExtent) / 2;
  static const double scrollbarPageIncrement = 0.8;
}

abstract final class KlpPlaceholderMetrics {
  static const double minimumHeight = 120;
  static const double markerSize = 6;
  static const double contentPaddingHorizontal = 16;
  static const double contentPaddingVertical = 12;
  static const double contentGap = 4;
  static const double actionLeadingGap = 4;
  static const double actionPaddingHorizontal = 12;
  static const double actionPaddingVertical = 5;
  static const double hatchBand = 10.5;
  static const double hatchGap = 10.5;
  static const double hatchStrokeWidth = hatchBand;
  static const double darkHatchColorMix = 0.18;
  static const double latentStrokeOpacity = 0.32;
  static const double labelLetterSpacing = 1.32;
  static const double detailMaximumWidth = 336;
}

abstract final class KlpCodeMetrics {
  static const double actionButtonSize = 26;
  static const double actionIconSize = 14;
  static const double headerHeight = 32;
  static const double terminalDot = 4;
  static const double terminalDotGap = 3;
  static const double terminalGroupGap = 8;
  static const double headerPaddingHorizontal = 10;
  static const double bodyPaddingHorizontal = 10;
  static const double bodyPaddingVertical = 8;
  static const double lineNumberWidth = 32;
  static const double wrappedLineWidth = 520;
  static const double defaultMaximumHeight = 320;
}

abstract final class KlpTypography {
  // 比例字體與等寬字體統一使用系統預設字體。
  static const String sansFamily = 'sans-serif';
  static const List<String> sansFallback = [
    'Microsoft JhengHei UI',
    'Microsoft JhengHei',
    'PingFang TC',
    'Noto Sans TC',
    'sans-serif',
  ];
  static const String monoFamily = 'monospace';
  static const List<String> monoFallback = [
    'Consolas',
    'Courier New',
    'monospace',
  ];

  // UI chrome 與一般文字使用比例字體，讓 App Shell 的字型度量在各機器保持一致。
  static const String uiFamily = sansFamily;
  static const List<String> uiFallback = sansFallback;

  // 編輯器標題與正文沿用相同比例字體；程式碼、路徑與 log 例外，仍走 monoFamily。
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

abstract final class KlpTransparency {
  static const double lightPaneOpacity = 0.88;
  static const double darkPaneOpacity = 0.72;
}
