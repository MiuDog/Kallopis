import 'package:flutter/material.dart';

import 'klp_data_visualization_theme.dart';
import 'klp_shape_theme.dart';
import 'klp_surface_theme.dart';
import 'klp_visual_style.dart';
import '../foundation/klp_palette.dart';
import '../tokens/klp_scale.dart';

// 元件 import 色彩層時一併取得 token 存取面（`context.klp` 與 `context.klpColors`），
// 否則每個元件都要 import 兩個 theme 檔才拿得到值——那種摩擦會讓人選擇寫死。
export 'klp_theme_scope.dart';

/// 依任意背景色算出可讀的前景色，用於背景色由使用者資料決定（而非固定
/// theme token）的場合，例如彩色標籤或頭像底色。
///
/// 不要拿它取代 semantic token——theme 內部的文字／背景配對已經照顏色系統
/// 設計好對比，這個類別只服務「背景色本身就是可變資料」這種例外情境。
abstract final class KlpThemeContrast {
  /// 判斷背景屬於哪一階梯：
  /// - 500 以下（含 500，如 ink50 ~ ink500）：深色文字
  /// - 600 以上（含 600，如 ink600 ~ ink950）：淺色文字
  /// - 透明背景不構成獨立深色階層，回傳 false
  static bool isDarkBackground(Color background) {
    if (background.a == 0) {
      return false;
    }
    // ink500 luminance 約 0.197 (oklch 0.58)，ink600 luminance 約 0.111 (oklch 0.48)
    return background.computeLuminance() < 0.15;
  }

  /// 依據背景顏色階梯（500 以下為深色 ink900，600 以上為淺色 ink50）決定前景文字色。
  static Color foregroundFor(Color background) {
    return isDarkBackground(background) ? KlpPalette.ink50 : KlpPalette.ink900;
  }
}

/// Layer 2：semantic 色彩 token（`ThemeExtension`）。
///
/// 這是消費者實際覆寫外觀時要動的層——每個欄位是一個色彩的**用途**
/// （`surface`、`text`、`accent`……），不是某個固定的十六進位值，因此同一份
/// 元件程式碼換一套 [KlpThemeData] 就能整體變色。透過 `context.klpColors`
/// 取用，不要在元件裡直接建構或持有它的實例。
@immutable
class KlpThemeData extends ThemeExtension<KlpThemeData> {
  const KlpThemeData({
    required this.app,
    required this.surface,
    required this.surfaceInset,
    required this.surfaceMuted,
    required this.component,
    required this.stageSurface,
    required this.overlay,
    required this.surfaceRaised,
    required this.modalScrim,
    required this.guide,
    required this.divider,
    Color? pagePattern,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.border,
    required this.borderStrong,
    required this.accent,
    required this.accentSoft,
    required this.interaction,
    required this.interactionSoft,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    this.clear = KlpPalette.transparent,
    this.onStatus = KlpPalette.pureWhite,
    this.onLightBackground = KlpPalette.ink900,
    this.onDarkBackground = KlpPalette.ink50,
    this.mutedOnLightBackground = KlpPalette.ink550,
    this.mutedOnDarkBackground = KlpPalette.ink300,
    this.faintOnBackground = KlpPalette.ink400,
  }) : pagePattern = pagePattern ?? guide;

  final Color app;
  final Color surface;
  final Color surfaceInset;
  final Color surfaceMuted;
  final Color component;
  final Color stageSurface;
  final Color overlay;
  final Color surfaceRaised;
  final Color modalScrim;
  final Color guide;
  final Color divider;
  final Color pagePattern;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color border;
  final Color borderStrong;
  final Color accent;
  final Color accentSoft;
  final Color interaction;
  final Color interactionSoft;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  /// 完全透明色。名稱避開既有的 static [transparent] 視窗 preset。
  final Color clear;
  final Color onStatus;
  final Color onLightBackground;
  final Color onDarkBackground;
  final Color mutedOnLightBackground;
  final Color mutedOnDarkBackground;
  final Color faintOnBackground;

  Color get onInteraction => KlpThemeContrast.isDarkBackground(interaction)
      ? onDarkBackground
      : onLightBackground;

  Color get selection => text;

  Color get onSelection => app;

  Color get selectionBackground => interactionSoft;

  Color get selectionForeground => text;

  /// 選取狀態的半透明壓深層。強度來自 [KlpSurfaceTheme.selectionWashOpacity]；
  /// 此處的預設值只在沒有 theme 可讀時使用。
  /// **不要在這裡另訂一份強度**——同一條規則兩份實作必然靜默分岔。
  Color selectionWashWith(double opacity) => text.withValues(alpha: opacity);

  Color get selectionWash => selectionWashWith(KlpScale.opacity100);

  /// 依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）產生適用於該背景的文字色彩 token。
  /// 若背景為透明，則延續當前（上層）的文字與階層設定。
  KlpThemeData onBackground(Color background) {
    if (background.a == 0) {
      return this;
    }
    final isDark = KlpThemeContrast.isDarkBackground(background);
    return copyWith(
      text: isDark ? onDarkBackground : onLightBackground,
      textMuted: isDark ? mutedOnDarkBackground : mutedOnLightBackground,
      textFaint: faintOnBackground,
    );
  }

  KlpThemeData withWindowTransparency(
    Brightness brightness, {
    KlpSurfaceTheme surfaceTheme = KlpSurfaceTheme.elevated,
  }) {
    final paneOpacity = brightness == Brightness.light
        ? surfaceTheme.windowPaneOpacityLight
        : surfaceTheme.windowPaneOpacityDark;

    return copyWith(
      app: clear,
      surface: surface.withValues(alpha: paneOpacity),
      stageSurface: stageSurface.withValues(alpha: paneOpacity),
    );
  }

  /// 亮態。**每個角色都落在 ink 色梯上**，沒有例外——一旦有欄位用梯外的顏色，
  /// 調整色梯時它就會原地不動，而畫面上只會顯示為「某一塊怪怪的」。
  static const KlpThemeData light = KlpThemeData(
    app: KlpPalette.ink150,
    surface: KlpPalette.ink100,
    surfaceInset: KlpPalette.ink200,
    surfaceMuted: KlpPalette.ink200,
    component: KlpPalette.ink50,
    stageSurface: KlpPalette.ink50,
    overlay: KlpPalette.ink50,
    surfaceRaised: KlpPalette.ink50,
    modalScrim: KlpPalette.scrim,
    guide: KlpPalette.ink400,
    divider: KlpPalette.ink100,
    pagePattern: KlpPalette.ink200,
    text: KlpPalette.ink900,
    textMuted: KlpPalette.ink550,
    textFaint: KlpPalette.ink400,
    border: KlpPalette.line,
    borderStrong: KlpPalette.line,
    accent: KlpPalette.ink900,
    accentSoft: KlpPalette.ink200,
    interaction: KlpPalette.ink900,
    interactionSoft: KlpPalette.ink200,
    success: KlpPalette.lightSuccess,
    warning: KlpPalette.lightWarning,
    danger: KlpPalette.lightDanger,
    info: KlpPalette.lightInfo,
    clear: KlpPalette.transparent,
  );

  /// 暗態：整條梯翻轉；輔助文字使用 ink400，確保石墨表面仍達 3:1。
  static const KlpThemeData dark = KlpThemeData(
    app: KlpPalette.ink850,
    surface: KlpPalette.ink750,
    surfaceInset: KlpPalette.ink700,
    surfaceMuted: KlpPalette.ink700,
    component: KlpPalette.ink800,
    stageSurface: KlpPalette.ink800,
    overlay: KlpPalette.ink750,
    surfaceRaised: KlpPalette.ink750,
    modalScrim: KlpPalette.scrim,
    guide: KlpPalette.ink400,
    divider: KlpPalette.ink750,
    pagePattern: KlpPalette.ink600,
    text: KlpPalette.ink50,
    textMuted: KlpPalette.ink300,
    textFaint: KlpPalette.ink400,
    border: KlpPalette.line,
    borderStrong: KlpPalette.line,
    accent: KlpPalette.ink50,
    accentSoft: KlpPalette.ink750,
    interaction: KlpPalette.ink50,
    interactionSoft: KlpPalette.ink750,
    success: KlpPalette.darkSuccess,
    warning: KlpPalette.darkWarning,
    danger: KlpPalette.darkDanger,
    info: KlpPalette.darkInfo,
    clear: KlpPalette.transparent,
  );

  /// 全暗態：比 dark 再往下一階，給 OLED 與長時間閱讀用。
  static const KlpThemeData ultraDark = KlpThemeData(
    app: KlpPalette.ink950,
    surface: KlpPalette.ink850,
    surfaceInset: KlpPalette.ink800,
    surfaceMuted: KlpPalette.ink800,
    component: KlpPalette.ink900,
    stageSurface: KlpPalette.ink900,
    overlay: KlpPalette.ink850,
    surfaceRaised: KlpPalette.ink850,
    modalScrim: KlpPalette.scrim,
    guide: KlpPalette.ink450,
    divider: KlpPalette.ink800,
    pagePattern: KlpPalette.ink650,
    text: KlpPalette.ink100,
    textMuted: KlpPalette.ink350,
    textFaint: KlpPalette.ink400,
    border: KlpPalette.line,
    borderStrong: KlpPalette.line,
    accent: KlpPalette.ink100,
    accentSoft: KlpPalette.ink850,
    interaction: KlpPalette.ink100,
    interactionSoft: KlpPalette.ink850,
    success: KlpPalette.darkSuccess,
    warning: KlpPalette.darkWarning,
    danger: KlpPalette.darkDanger,
    info: KlpPalette.darkInfo,
    clear: KlpPalette.transparent,
  );

  static final KlpThemeData transparent = dark.withWindowTransparency(
    Brightness.dark,
  );

  @override
  KlpThemeData copyWith({
    Color? app,
    Color? surface,
    Color? surfaceInset,
    Color? surfaceMuted,
    Color? component,
    Color? stageSurface,
    Color? overlay,
    Color? surfaceRaised,
    Color? modalScrim,
    Color? guide,
    Color? divider,
    Color? pagePattern,
    Color? text,
    Color? textMuted,
    Color? textFaint,
    Color? border,
    Color? borderStrong,
    Color? accent,
    Color? accentSoft,
    Color? interaction,
    Color? interactionSoft,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? clear,
    Color? onStatus,
    Color? onLightBackground,
    Color? onDarkBackground,
    Color? mutedOnLightBackground,
    Color? mutedOnDarkBackground,
    Color? faintOnBackground,
  }) {
    return KlpThemeData(
      app: app ?? this.app,
      surface: surface ?? this.surface,
      surfaceInset: surfaceInset ?? this.surfaceInset,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      component: component ?? this.component,
      stageSurface: stageSurface ?? this.stageSurface,
      overlay: overlay ?? this.overlay,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      modalScrim: modalScrim ?? this.modalScrim,
      guide: guide ?? this.guide,
      divider: divider ?? this.divider,
      pagePattern: pagePattern ?? this.pagePattern,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textFaint: textFaint ?? this.textFaint,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      interaction: interaction ?? this.interaction,
      interactionSoft: interactionSoft ?? this.interactionSoft,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      clear: clear ?? this.clear,
      onStatus: onStatus ?? this.onStatus,
      onLightBackground: onLightBackground ?? this.onLightBackground,
      onDarkBackground: onDarkBackground ?? this.onDarkBackground,
      mutedOnLightBackground:
          mutedOnLightBackground ?? this.mutedOnLightBackground,
      mutedOnDarkBackground:
          mutedOnDarkBackground ?? this.mutedOnDarkBackground,
      faintOnBackground: faintOnBackground ?? this.faintOnBackground,
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
  KlpThemeData lerp(covariant KlpThemeData? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpThemeData &&
          app == other.app &&
          surface == other.surface &&
          surfaceInset == other.surfaceInset &&
          surfaceMuted == other.surfaceMuted &&
          component == other.component &&
          stageSurface == other.stageSurface &&
          overlay == other.overlay &&
          surfaceRaised == other.surfaceRaised &&
          modalScrim == other.modalScrim &&
          guide == other.guide &&
          divider == other.divider &&
          pagePattern == other.pagePattern &&
          text == other.text &&
          textMuted == other.textMuted &&
          textFaint == other.textFaint &&
          border == other.border &&
          borderStrong == other.borderStrong &&
          accent == other.accent &&
          accentSoft == other.accentSoft &&
          interaction == other.interaction &&
          interactionSoft == other.interactionSoft &&
          success == other.success &&
          warning == other.warning &&
          danger == other.danger &&
          info == other.info &&
          clear == other.clear &&
          onStatus == other.onStatus &&
          onLightBackground == other.onLightBackground &&
          onDarkBackground == other.onDarkBackground &&
          mutedOnLightBackground == other.mutedOnLightBackground &&
          mutedOnDarkBackground == other.mutedOnDarkBackground &&
          faintOnBackground == other.faintOnBackground;

  @override
  int get hashCode => Object.hashAll([
    app,
    surface,
    surfaceInset,
    surfaceMuted,
    component,
    stageSurface,
    overlay,
    surfaceRaised,
    modalScrim,
    guide,
    divider,
    pagePattern,
    text,
    textMuted,
    textFaint,
    border,
    borderStrong,
    accent,
    accentSoft,
    interaction,
    interactionSoft,
    success,
    warning,
    danger,
    info,
    clear,
    onStatus,
    onLightBackground,
    onDarkBackground,
    mutedOnLightBackground,
    mutedOnDarkBackground,
    faintOnBackground,
  ]);
}

/// 內建的 [KlpThemeData] 預設變體。[transparent] 目前解析為 [KlpThemeData.dark]
/// 的色彩再疊加透明度，不是一份獨立的色票——它描述的是「視窗背景可透」這個
/// 額外能力，而不是第四種配色。
enum KlpThemeVariant { light, dark, ultraDark, transparent }

/// 輸入欄位底色要跟隨的互動狀態。
///
/// 刻意把 [rest] 與 [hovered] 分開列舉，即使兩者目前解析成同一個顏色
/// （見 [KlpFieldStyle.colorFor]）——這是為了讓「hover 不改底色」這件事有
/// 名字可以在程式碼裡明確表達，而不是省略 hovered 這個 case 導致日後被誤判
/// 為漏寫。
enum KlpFieldFillState { rest, hovered, focused, selected, disabled, error }

/// 輸入欄位的邊框與底色查表工具。
abstract final class KlpFieldStyle {
  /// 需要 shape token，因此不能是無參數的 getter——欄位圓角屬於風格。
  static OutlineInputBorder borderFor(KlpShapeTheme shape) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(shape.control),
        borderSide: BorderSide.none,
      );

  /// 欄位底色。
  ///
  /// **hover 不改變底色。** 實作準則 §2.1：hover 是暫時的，用 `1px dashed` 表達；
  /// 填色留給 selected 那種會停留的狀態。因此 rest 與 hovered 刻意回傳同一個值——
  /// 把它們寫成同一個 case 會讓「hover 沒有底色變化」在未來被當成漏寫而補回去。
  ///
  /// focus 同樣不靠底色，走準則 §7 的焦點環。
  static Color colorFor(
    KlpThemeData tokens,
    KlpFieldFillState state, {
    KlpSurfaceTheme surface = KlpSurfaceTheme.elevated,
  }) {
    return switch (state) {
      KlpFieldFillState.rest => tokens.surfaceInset,
      KlpFieldFillState.hovered => tokens.surfaceInset,
      KlpFieldFillState.focused ||
      KlpFieldFillState.selected => tokens.surfaceInset,
      KlpFieldFillState.disabled => tokens.surfaceMuted,
      // 不合法輸入用半透明紅**疊在**欄位上，而不是先跟 surfaceInset 混成不透明色。
      // 疊層才會跟著底下實際的表面走；預混會在欄位被放到別的表面上時顏色對不上。
      KlpFieldFillState.error => tokens.danger.withValues(
        alpha: surface.invalidFillOpacity,
      ),
    };
  }

  static Color resolveInputColor(
    KlpThemeData tokens,
    Set<WidgetState> states, {
    KlpSurfaceTheme surface = KlpSurfaceTheme.elevated,
  }) {
    if (states.contains(WidgetState.disabled)) {
      return colorFor(tokens, KlpFieldFillState.disabled, surface: surface);
    }
    if (states.contains(WidgetState.error)) {
      return colorFor(tokens, KlpFieldFillState.error, surface: surface);
    }
    if (states.contains(WidgetState.focused)) {
      return colorFor(tokens, KlpFieldFillState.focused, surface: surface);
    }
    if (states.contains(WidgetState.hovered)) {
      return colorFor(tokens, KlpFieldFillState.hovered, surface: surface);
    }

    return colorFor(tokens, KlpFieldFillState.rest, surface: surface);
  }

  static WidgetStateColor inputFill(
    KlpThemeData tokens, {
    bool error = false,
    KlpSurfaceTheme surface = KlpSurfaceTheme.elevated,
  }) {
    return WidgetStateColor.resolveWith(
      (states) => error
          ? colorFor(tokens, KlpFieldFillState.error, surface: surface)
          : resolveInputColor(tokens, states, surface: surface),
    );
  }
}

/// 由一套視覺風格建出 `ThemeData`。
///
/// 色彩的來源規則刻意是**明確的，不做推測**：
///
/// - 不給 [style]：依 [brightness] 取內建 preset，套用 defaultStyle 風格。
/// - 給了 [style]：**`style.colors` 就是色彩，[brightness] 不再干涉。**
///
/// 曾經試過「偵測消費者有沒有動過色彩，沒動過才依 brightness 挑」，那是行不通的：
/// Dart 會把欄位值相同的 `const` 實例正規化成同一個物件，因此一組剛好等於內建
/// preset 的自訂色盤會被誤判為未修改，然後被靜默換掉。**能被靜默搞錯的推測就不要做。**
///
/// [accent] 為 `null` 時保留色彩層原本的 interaction 色；給定值才覆寫它。
ThemeData buildKlpTheme(
  Brightness brightness, {
  KlpAccent? accent,
  KlpVisualStyle? style,
}) {
  final baseTokens = style != null
      ? style.colors
      : (brightness == Brightness.dark
            ? KlpThemeData.dark
            : KlpThemeData.light);
  final effectiveStyle = style ?? KlpVisualStyle.forBrightness(brightness);
  return _buildKlpThemeData(baseTokens, accent: accent, style: effectiveStyle);
}

ThemeData buildKlpThemeVariant(
  KlpThemeVariant variant, {
  KlpAccent? accent,
  bool transparencyEnabled = false,
  KlpVisualStyle? style,
}) {
  final tokens = switch (variant) {
    KlpThemeVariant.light => KlpThemeData.light,
    KlpThemeVariant.dark => KlpThemeData.dark,
    KlpThemeVariant.ultraDark => KlpThemeData.ultraDark,
    KlpThemeVariant.transparent => KlpThemeData.dark,
  };

  final effectiveStyle =
      style ??
      KlpVisualStyle.defaultStyle.copyWith(
        colors: tokens,
        dataVisualization: switch (variant) {
          KlpThemeVariant.light => KlpDataVisualizationTheme.light,
          KlpThemeVariant.dark => KlpDataVisualizationTheme.dark,
          KlpThemeVariant.ultraDark => KlpDataVisualizationTheme.ultraDark,
          KlpThemeVariant.transparent => KlpDataVisualizationTheme.dark,
        },
      );

  return _buildKlpThemeData(
    tokens,
    accent: accent,
    style: effectiveStyle,
    transparencyEnabled:
        transparencyEnabled || variant == KlpThemeVariant.transparent,
  );
}

ThemeData _buildKlpThemeData(
  KlpThemeData baseTokens, {
  KlpAccent? accent,
  bool transparencyEnabled = false,
  KlpVisualStyle style = KlpVisualStyle.defaultStyle,
}) {
  // 由實際的表面色推導明暗，而不是比對是否為某個 preset 實例——自訂色盤永遠不會
  // `identical` 於 preset，用 identical 判斷會讓所有自訂主題都被當成暗色。
  final brightness = baseTokens.app.computeLuminance() > 0.5
      ? Brightness.light
      : Brightness.dark;
  final interactionColor = accent?.resolve(brightness);
  final themedTokens = interactionColor == null
      ? baseTokens
      : baseTokens.copyWith(
          interaction: interactionColor,
          interactionSoft: Color.alphaBlend(
            interactionColor.withValues(
              alpha: brightness == Brightness.dark
                  ? style.surface.accentSoftOpacityDark
                  : style.surface.accentSoftOpacityLight,
            ),
            baseTokens.surfaceInset,
          ),
        );
  final tokens = transparencyEnabled
      ? themedTokens.withWindowTransparency(
          brightness,
          surfaceTheme: style.surface,
        )
      : themedTokens;
  final baseTextTheme = ThemeData(
    brightness: brightness,
    useMaterial3: false,
    fontFamily: style.typography.uiFamily,
    fontFamilyFallback: style.typography.fallbackFor(style.typography.uiFamily),
  ).textTheme;
  final textTheme = baseTextTheme.copyWith(
    displayLarge: baseTextTheme.displayLarge?.copyWith(color: tokens.text),
    displayMedium: baseTextTheme.displayMedium?.copyWith(color: tokens.text),
    displaySmall: baseTextTheme.displaySmall?.copyWith(color: tokens.text),
    headlineLarge: baseTextTheme.headlineLarge?.copyWith(color: tokens.text),
    headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: tokens.text),
    headlineSmall: baseTextTheme.headlineSmall?.copyWith(color: tokens.text),
    titleLarge: baseTextTheme.titleLarge?.copyWith(color: tokens.text),
    titleMedium: baseTextTheme.titleMedium?.copyWith(color: tokens.text),
    titleSmall: baseTextTheme.titleSmall?.copyWith(color: tokens.text),
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(
      color: tokens.textMuted,
      fontSize: style.typography.body,
    ),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(
      color: tokens.textMuted,
      fontSize: style.typography.body,
    ),
    bodySmall: baseTextTheme.bodySmall?.copyWith(
      color: tokens.textMuted,
      fontSize: style.typography.caption,
    ),
    labelLarge: baseTextTheme.labelLarge?.copyWith(
      color: tokens.textMuted,
      fontSize: style.typography.body,
    ),
    labelMedium: baseTextTheme.labelMedium?.copyWith(
      color: tokens.textMuted,
      fontSize: style.typography.caption,
    ),
    labelSmall: baseTextTheme.labelSmall?.copyWith(
      color: tokens.textMuted,
      fontSize: style.typography.caption,
      fontWeight: style.typography.regular,
    ),
  );

  return ThemeData(
    brightness: brightness,
    useMaterial3: false,
    splashFactory: NoSplash.splashFactory,
    splashColor: tokens.clear,
    highlightColor: tokens.clear,
    scaffoldBackgroundColor: tokens.app,
    fontFamily: style.typography.uiFamily,
    fontFamilyFallback: style.typography.fallbackFor(style.typography.uiFamily),
    textTheme: textTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: tokens.interaction,
      brightness: brightness,
      surface: tokens.surface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: KlpFieldStyle.borderFor(style.shape),
      enabledBorder: KlpFieldStyle.borderFor(style.shape),
      focusedBorder: KlpFieldStyle.borderFor(style.shape),
      disabledBorder: KlpFieldStyle.borderFor(style.shape),
      errorBorder: KlpFieldStyle.borderFor(style.shape),
      focusedErrorBorder: KlpFieldStyle.borderFor(style.shape),
      hoverColor: tokens.clear,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(tokens.textFaint),
      trackColor: WidgetStatePropertyAll(tokens.clear),
      trackBorderColor: WidgetStatePropertyAll(tokens.clear),
      thickness: WidgetStatePropertyAll(
        style.geometry.control.scrollbarThickness,
      ),
      radius: Radius.circular(style.shape.pill),
      trackVisibility: const WidgetStatePropertyAll(false),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: tokens.overlay,
        borderRadius: BorderRadius.circular(style.shape.control),
      ),
      textStyle: TextStyle(
        color: tokens.textMuted,
        fontSize: style.typography.caption,
        fontFamily: style.typography.uiFamily,
        fontFamilyFallback: style.typography.fallbackFor(
          style.typography.uiFamily,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: style.spacing.compact,
        vertical: style.spacing.tight,
      ),
      waitDuration: style.motion.tooltipDelay,
      showDuration: style.motion.tooltipDwell,
      preferBelow: false,
    ),
    // 註冊完整的 token 疊層。少放任何一層，該層會回退預設而不會報錯——
    // 因此這裡以 KlpVisualStyle 為單一來源，避免逐項列舉時漏掉。
    extensions: [...style.copyWith(colors: tokens).extensions],
  );
}
