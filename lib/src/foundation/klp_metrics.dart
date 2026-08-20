import 'package:flutter/widgets.dart';

/// 舊版的 static const 間距階梯，抽取自 Planist 時仍有元件直接引用。
///
/// 這一層**不會隨 theme 變化**，屬於待清除的欠債，不是給新元件用的字彙表——
/// 新程式碼請改讀 `context.klp.space`（semantic 層）。`test/token_discipline_test.dart`
/// 用棘輪列管剩餘引用數，只能減少、不能增加。
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

/// 舊版的 static const 版面間隙，僅剩少數版面預設值仍引用。
///
/// 與 [KlpSpace] 同屬待清除的欠債層——新程式碼請改讀 `context.klp.space`。
abstract final class KlpLayoutGap {
  static const double lg = 10;
}

/// 舊版的 static const 圓角階梯，抽取自 Planist 時仍有元件直接引用。
///
/// 與 [KlpSpace] 同屬待清除的欠債層，不隨 theme 變化——新程式碼請改讀
/// `context.klp.shape` 或對應的 semantic token。
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

/// 舊版的 static const 線條幾何：粗細與虛線的長度／間隙／透明度。
///
/// 與 [KlpSpace] 同屬待清除的欠債層，不隨 theme 變化——hover 虛線實際取用的是
/// `context.klp` 上對應的 semantic token（例如 [KlpTheme.hoverBorder]），
/// 這個類別僅保留給尚未遷移的舊呼叫端。
abstract final class KlpLine {
  static const double hairline = 1;
  static const double width = 2;
  static const double dashedLength = 3;
  static const double dashedGap = 2;
  static const double dashedOpacity = 0.78;
}

/// 舊版的 static const 動畫時長，目前兩個值都固定為 [Duration.zero]。
///
/// 本產品在 theme／style 切換時刻意不做過場動畫——切換是使用者主動觸發的離散
/// 事件，補間動畫只會讓「切好了沒」變得模糊。與 [KlpSpace] 同屬待清除的欠債層，
/// 新程式碼請改讀 `context.klp.motion`。
abstract final class KlpMotion {
  static const Duration themeTransition = Duration.zero;
  static const Duration styleTransition = Duration.zero;
}

/// 舊版的 static const 陰影參數，僅供選單彈出層的投影使用。
///
/// 與 [KlpSpace] 同屬待清除的欠債層，不隨 theme 變化——新程式碼請改讀
/// `context.klp.surface` 上對應的 overlay 陰影 token。
abstract final class KlpElevation {
  static const double menuBlurRadius = 18;
  static const double menuSpreadRadius = 1;
  static const double menuOffsetY = 8;
  static const double menuShadowOpacity = 0.22;
}

/// 舊版的 static const 尺寸階梯：控制項高度、圖示尺寸、面板寬度與 responsive
/// 斷點全部混在一起。
///
/// 與 [KlpSpace] 同屬待清除的欠債層。面板寬度與斷點（[sidebar]、[inspector]、
/// [primaryPaneBreakpoint] 等）是刻意保留的版面預設值，消費者可用 widget 參數
/// 覆寫，不屬於風格；其餘控制項與圖示尺寸新程式碼請改讀 `context.klp` 上對應的
/// semantic token。
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

/// 表單控制項（勾選框、切換開關）的固定幾何：欄位高度、選取指示器的尺寸與內縮。
///
/// 這些是控制項繪製時的座標關係，不是可覆寫的風格——例如 [selectionIndicator]
/// 是從 [selectionControl] 扣掉兩側內縮算出來的，動一個值另一個就得跟著算，
/// 因此整組留在 component 層而非拆進 theme。
abstract final class KlpFormMetrics {
  static const double fieldHeight = 30;
  static const double selectionControl = 18;
  static const double selectionIndicatorInset = 3.5;
  static const double selectionIndicator =
      selectionControl - selectionIndicatorInset * 2;
  static const double selectionIcon = 12;
  static const double toggleWidth = 30;
  static const double toggleHeight = 16;
  static const double toggleThumb = 12;
  static const double toggleInset = 2;
}

/// 分段控制項與捲軸的固定幾何。
///
/// [scrollbarEndControlRightInset] 是從 [scrollbarThickness] 與
/// [scrollbarEndControlExtent] 算出來的置中位移，兩者是連動的繪製參數而非各自
/// 獨立的風格值，因此留在同一個類別而非拆進 theme。
abstract final class KlpControlMetrics {
  static const double segmentedDenseInset = 3;
  static const double scrollbarThickness = 5;
  static const double scrollbarEndControlExtent = 14;
  static const double scrollbarEndControlRightInset =
      (scrollbarThickness - scrollbarEndControlExtent) / 2;
  static const double scrollbarPageIncrement = 0.8;
}

/// [KlpRegionPlaceholder] 專用的固定幾何：內距、間隙，以及斜線底紋
/// （hatch）的繪製參數。
///
/// `hatchBand`／`hatchGap`／`darkHatchColorMix` 這類值是畫斜線底紋這個具體
/// 視覺效果的座標，不是一般意義的風格 token，因此留在元件旁邊而非拆進 theme。
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

/// [KlpCodeViewer] 與相關程式碼展示元件的固定幾何：header 高度、終端機圓點
/// 間距、行號欄寬與自動換行寬度。
///
/// 這些是程式碼區塊這個具體版面的量測值，只有 [KlpCodeViewer] 一系會用到，
/// 因此不進 semantic 層而是留在元件旁邊。
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

/// 舊版的 static const 字型階梯：字族、字級、行高、字距與字重全部混在一起。
///
/// 與 [KlpSpace] 同屬待清除的欠債層，不隨 theme 變化——新程式碼請改讀
/// [KlpTextStyles] 或 `context.klp` 上對應的 semantic token。字族刻意統一走
/// 系統預設字體並附上完整的中日文 fallback 清單（[sansFallback]），
/// 而不是綁定單一商業字型。
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

/// 舊版的 static const 面板透明度，僅剩少數視窗背景仍直接引用。
///
/// 與 [KlpSpace] 同屬待清除的欠債層，不隨 theme 變化——新程式碼請改讀
/// `context.klp.surface` 上對應的透明度 token。
abstract final class KlpTransparency {
  static const double lightPaneOpacity = 0.88;
  static const double darkPaneOpacity = 0.72;
}
