import 'package:flutter/material.dart';

import 'klp_data_visualization_theme.dart';
import 'klp_shape_theme.dart';
import 'klp_visual_style.dart';
import '../foundation/klp_accent.dart';
import '../foundation/klp_metrics.dart';
import '../foundation/klp_palette.dart';

// 元件 import 色彩層時一併取得 token 存取面（`context.klp` 與 `context.klpColors`），
// 否則每個元件都要 import 兩個 theme 檔才拿得到值——那種摩擦會讓人選擇寫死。
export 'klp_theme_scope.dart';

abstract final class KlpThemeContrast {
  static Color foregroundFor(Color background) {
    final backgroundLuminance = background.computeLuminance();
    final darkContrast = _contrastRatio(
      backgroundLuminance,
      KlpPalette.ink900.computeLuminance(),
    );
    final lightContrast = _contrastRatio(
      backgroundLuminance,
      KlpPalette.pureWhite.computeLuminance(),
    );

    return darkContrast >= lightContrast
        ? KlpPalette.ink900
        : KlpPalette.pureWhite;
  }

  static double _contrastRatio(double first, double second) {
    final lighter = first > second ? first : second;
    final darker = first > second ? second : first;
    return (lighter + 0.05) / (darker + 0.05);
  }
}

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
  });

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

  Color get onInteraction => KlpThemeContrast.foregroundFor(interaction);

  /// 語意色塊上的前景。語意色的明度都在中段，白字是兩態下都成立的選擇。
  Color get onStatus => KlpPalette.pureWhite;

  Color get selection => text;

  Color get onSelection => app;

  Color get selectionBackground => surfaceMuted;

  Color get selectionForeground => text;

  /// hover 底色。混合比例來自 [KlpSurfaceTheme.hoverContrastMix]；此處的預設值只在
  /// 沒有 theme 可讀時使用（例如純色彩層的單元測試）。
  /// **不要在這裡另訂一份比例**——同一條規則兩份實作必然靜默分岔。
  Color hoverSurfaceWith(double contrastMix) =>
      Color.lerp(surfaceInset, text, contrastMix)!;

  Color get hoverSurface => hoverSurfaceWith(0.08);

  KlpThemeData withWindowTransparency(Brightness brightness) {
    final paneOpacity = brightness == Brightness.light
        ? KlpTransparency.lightPaneOpacity
        : KlpTransparency.darkPaneOpacity;

    return copyWith(
      app: Colors.transparent,
      surface: surface.withValues(alpha: paneOpacity),
      stageSurface: stageSurface.withValues(alpha: paneOpacity),
    );
  }

  /// 亮態。**每個角色都落在 ink 色梯上**，沒有例外——一旦有欄位用梯外的顏色，
  /// 調整色梯時它就會原地不動，而畫面上只會顯示為「某一塊怪怪的」。
  static const KlpThemeData light = KlpThemeData(
    app: KlpPalette.ink200,
    surface: KlpPalette.ink100,
    surfaceInset: KlpPalette.ink200,
    surfaceMuted: KlpPalette.ink300,
    component: KlpPalette.ink50,
    stageSurface: KlpPalette.ink50,
    overlay: KlpPalette.ink50,
    surfaceRaised: KlpPalette.ink50,
    modalScrim: KlpPalette.scrim,
    guide: KlpPalette.ink400,
    divider: KlpPalette.ink300,
    text: KlpPalette.ink900,
    textMuted: KlpPalette.ink600,
    textFaint: KlpPalette.ink500,
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
  );

  /// 暗態：整條梯翻轉。文字三階與亮態對稱（50／300／500 對 900／600／500）。
  static const KlpThemeData dark = KlpThemeData(
    app: KlpPalette.ink900,
    surface: KlpPalette.ink800,
    surfaceInset: KlpPalette.ink700,
    surfaceMuted: KlpPalette.ink700,
    component: KlpPalette.ink800,
    stageSurface: KlpPalette.ink900,
    overlay: KlpPalette.ink700,
    surfaceRaised: KlpPalette.ink700,
    modalScrim: KlpPalette.scrim,
    guide: KlpPalette.ink500,
    divider: KlpPalette.ink700,
    text: KlpPalette.ink50,
    textMuted: KlpPalette.ink300,
    textFaint: KlpPalette.ink500,
    border: KlpPalette.line,
    borderStrong: KlpPalette.line,
    accent: KlpPalette.ink50,
    accentSoft: KlpPalette.ink700,
    interaction: KlpPalette.ink50,
    interactionSoft: KlpPalette.ink700,
    success: KlpPalette.darkSuccess,
    warning: KlpPalette.darkWarning,
    danger: KlpPalette.darkDanger,
    info: KlpPalette.darkInfo,
  );

  /// 全暗態：比 dark 再往下一階，給 OLED 與長時間閱讀用。
  static const KlpThemeData ultraDark = KlpThemeData(
    app: KlpPalette.ink950,
    surface: KlpPalette.ink900,
    surfaceInset: KlpPalette.ink800,
    surfaceMuted: KlpPalette.ink800,
    component: KlpPalette.ink900,
    stageSurface: KlpPalette.ink950,
    overlay: KlpPalette.ink800,
    surfaceRaised: KlpPalette.ink800,
    modalScrim: KlpPalette.scrim,
    guide: KlpPalette.ink500,
    divider: KlpPalette.ink700,
    text: KlpPalette.ink50,
    textMuted: KlpPalette.ink300,
    textFaint: KlpPalette.ink500,
    border: KlpPalette.line,
    borderStrong: KlpPalette.line,
    accent: KlpPalette.ink50,
    accentSoft: KlpPalette.ink800,
    interaction: KlpPalette.ink50,
    interactionSoft: KlpPalette.ink800,
    success: KlpPalette.darkSuccess,
    warning: KlpPalette.darkWarning,
    danger: KlpPalette.darkDanger,
    info: KlpPalette.darkInfo,
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
    );
  }

  @override
  KlpThemeData lerp(covariant KlpThemeData? other, double t) {
    if (other == null) return this;

    return KlpThemeData(
      app: Color.lerp(app, other.app, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceInset: Color.lerp(surfaceInset, other.surfaceInset, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      component: Color.lerp(component, other.component, t)!,
      stageSurface: Color.lerp(stageSurface, other.stageSurface, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      modalScrim: Color.lerp(modalScrim, other.modalScrim, t)!,
      guide: Color.lerp(guide, other.guide, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      interaction: Color.lerp(interaction, other.interaction, t)!,
      interactionSoft: Color.lerp(interactionSoft, other.interactionSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

enum KlpThemeVariant { light, dark, ultraDark, transparent }

enum KlpFieldFillState { rest, hovered, focused, selected, disabled, error }

abstract final class KlpFieldStyle {
  /// 需要 shape token，因此不能是無參數的 getter——欄位圓角屬於風格。
  static OutlineInputBorder borderFor(KlpShapeTheme shape) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(shape.control),
        borderSide: BorderSide.none,
      );

  static Color colorFor(
    KlpThemeData tokens,
    KlpFieldFillState state, {
    double hoverContrastMix = 0.08,
  }) {
    final hover = tokens.hoverSurfaceWith(hoverContrastMix);
    return switch (state) {
      KlpFieldFillState.rest => tokens.surfaceInset,
      KlpFieldFillState.hovered => hover,
      KlpFieldFillState.focused || KlpFieldFillState.selected => hover,
      KlpFieldFillState.disabled => tokens.surfaceMuted,
      // 錯誤底色由 danger 推導，而不是借用其他角色的顏色：借用會在調整 danger 時
      // 靜默失去同步。
      KlpFieldFillState.error => Color.alphaBlend(
        tokens.danger.withValues(alpha: 0.16),
        tokens.surfaceInset,
      ),
    };
  }

  static Color resolveInputColor(KlpThemeData tokens, Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return colorFor(tokens, KlpFieldFillState.disabled);
    }
    if (states.contains(WidgetState.error)) {
      return colorFor(tokens, KlpFieldFillState.error);
    }
    if (states.contains(WidgetState.focused)) {
      return colorFor(tokens, KlpFieldFillState.focused);
    }
    if (states.contains(WidgetState.hovered)) {
      return colorFor(tokens, KlpFieldFillState.hovered);
    }

    return colorFor(tokens, KlpFieldFillState.rest);
  }

  static WidgetStateColor inputFill(KlpThemeData tokens, {bool error = false}) {
    return WidgetStateColor.resolveWith(
      (states) => error
          ? colorFor(tokens, KlpFieldFillState.error)
          : resolveInputColor(tokens, states),
    );
  }
}

/// 由一套視覺風格建出 `ThemeData`。
///
/// 色彩的來源規則刻意是**明確的，不做推測**：
///
/// - 不給 [style]：依 [brightness] 取內建 preset，套用 modern 風格。
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
  final effectiveStyle = style ?? KlpVisualStyle.modern;
  final baseTokens = style != null
      ? style.colors
      : (brightness == Brightness.dark
            ? KlpThemeData.dark
            : KlpThemeData.light);
  return _buildKlpThemeData(baseTokens, accent: accent, style: effectiveStyle);
}

ThemeData buildKlpThemeVariant(
  KlpThemeVariant variant, {
  KlpAccent? accent,
  bool transparencyEnabled = false,
  KlpVisualStyle style = KlpVisualStyle.modern,
}) {
  final tokens = switch (variant) {
    KlpThemeVariant.light => KlpThemeData.light,
    KlpThemeVariant.dark => KlpThemeData.dark,
    KlpThemeVariant.ultraDark => KlpThemeData.ultraDark,
    KlpThemeVariant.transparent => KlpThemeData.dark,
  };

  return _buildKlpThemeData(
    tokens,
    accent: accent,
    style: style,
    transparencyEnabled:
        transparencyEnabled || variant == KlpThemeVariant.transparent,
  );
}

ThemeData _buildKlpThemeData(
  KlpThemeData baseTokens, {
  KlpAccent? accent,
  bool transparencyEnabled = false,
  KlpVisualStyle style = KlpVisualStyle.modern,
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
              alpha: brightness == Brightness.dark ? 0.22 : 0.16,
            ),
            baseTokens.surfaceInset,
          ),
        );
  final tokens = transparencyEnabled
      ? themedTokens.withWindowTransparency(brightness)
      : themedTokens;
  final dataVisualizationTokens = switch (brightness) {
    Brightness.light => KlpDataVisualizationTheme.light,
    Brightness.dark =>
      identical(baseTokens, KlpThemeData.ultraDark)
          ? KlpDataVisualizationTheme.ultraDark
          : KlpDataVisualizationTheme.dark,
  };
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
    splashColor: KlpPalette.transparent,
    highlightColor: KlpPalette.transparent,
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
      hoverColor: KlpFieldStyle.colorFor(tokens, KlpFieldFillState.hovered),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(tokens.textFaint),
      trackColor: const WidgetStatePropertyAll(KlpPalette.transparent),
      trackBorderColor: const WidgetStatePropertyAll(KlpPalette.transparent),
      thickness: const WidgetStatePropertyAll(
        KlpControlMetrics.scrollbarThickness,
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
      showDuration: style.motion.toastDwell * 8,
      preferBelow: false,
    ),
    // 註冊完整的 token 疊層。少放任何一層，該層會回退預設而不會報錯——
    // 因此這裡以 KlpVisualStyle 為單一來源，避免逐項列舉時漏掉。
    extensions: [
      ...style.copyWith(colors: tokens).extensions,
      dataVisualizationTokens,
    ],
  );
}
