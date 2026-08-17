import 'package:flutter/widgets.dart';

abstract final class KlpSpace {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double page = 40;
}

abstract final class KlpLayoutGap {
  static const double lg = 10;
}

abstract final class KlpRadius {
  static const double none = 0;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 10;
  static const double full = 999;

  static const double control = sm;
  static const double card = md;
  static const double panel = lg;
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

abstract final class KlpInteraction {
  static const double hoverContrastMix = 0.08;
}

abstract final class KlpElevation {
  static const double menuBlurRadius = 18;
  static const double menuSpreadRadius = 1;
  static const double menuOffsetY = 8;
  static const double menuShadowOpacity = 0.22;
}

abstract final class KlpSize {
  static const double controlSmall = 26;
  static const double control = 32;
  static const double controlLarge = 40;
  static const double segmentedDense = 30;
  static const double segmentedDenseItem = 24;
  static const double iconButton = 30;
  static const double tab = 32;
  static const double iconSmall = 14;
  static const double disclosure = 9;
  static const double icon = 18;
  static const double iconLarge = 22;
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
  static const double contentPaddingVertical = 20;
  static const double contentGap = 4;
  static const double actionLeadingGap = 4;
  static const double actionPaddingHorizontal = 12;
  static const double actionPaddingVertical = 5;
  static const double hatchBand = 6;
  static const double hatchGap = 6;
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
  // 比例字體：以隨 Kallopis 打包的 IBM Plex Sans TC 為主，確保任何機器都渲染一致；
  // Noto Sans TC 未打包，只在系統剛好安裝時作為缺字 fallback。
  //
  // 字型隨套件散佈，家族名必須帶 `packages/<套件名>/` 前綴。少了前綴不會編譯失敗，
  // 而是靜默 fallback 到系統預設字型——這是本次抽取唯一會無聲退化的地方。
  static const String sansFamily = 'packages/kallopis/IBM Plex Sans TC';
  static const List<String> sansFallback = ['Noto Sans TC'];
  static const String monoFamily = 'packages/kallopis/IBM Plex Mono';
  static const List<String> monoFallback = ['Noto Sans TC', sansFamily];

  // UI chrome 與一般文字使用比例字體，讓 App Shell 的字型度量在各機器保持一致。
  static const String uiFamily = sansFamily;
  static const List<String> uiFallback = sansFallback;

  // 編輯器標題與正文沿用相同比例字體；程式碼、路徑與 log 例外，仍走 monoFamily。
  static const String bodyFamily = sansFamily;
  static const List<String> bodyFallback = sansFallback;

  static const double small = 12;
  static const double body = 14;
  static const double section = 16;
  static const double headingSmall = 19;
  static const double equation = 19;
  static const double heading = 24;
  static const double editorHeading = 24;
  static const double title = 32;
  static const double headline = 32;
  static const double display = 40;
  static const double hero = 40;

  static const double displayLineHeight = 1.15;
  static const double labelLineHeight = 1.2;
  static const double headlineLineHeight = 1.25;
  static const double headingSmallLineHeight = 1.3;
  static const double headingLineHeight = 1.35;
  static const double compactLineHeight = 1.4;
  static const double editorLineHeight = 1.45;
  static const double bodyLineHeight = 1.5;
  static const double codeLineHeight = 1.55;
  static const double readingLineHeight = 1.65;

  static const double displayLetterSpacing = -0.5;
  static const double labelLetterSpacing = 1.2;
  static const double uiBaselineOffset = 0;

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

abstract final class KlpTransparency {
  static const double lightPaneOpacity = 0.88;
  static const double darkPaneOpacity = 0.72;
}

abstract final class KlpInsets {
  static const EdgeInsets control = EdgeInsets.symmetric(
    horizontal: KlpSpace.md,
    vertical: KlpSpace.sm,
  );

  static const EdgeInsets section = EdgeInsets.all(KlpSpace.lg);

  static const EdgeInsets scrollableNavigation = EdgeInsets.fromLTRB(
    KlpSpace.sm,
    KlpSpace.sm,
    KlpSpace.lg,
    KlpSpace.sm,
  );
}
