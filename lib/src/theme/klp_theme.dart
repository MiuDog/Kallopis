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
      KlpPalette.ink.computeLuminance(),
    );
    final lightContrast = _contrastRatio(
      backgroundLuminance,
      KlpPalette.pureWhite.computeLuminance(),
    );

    return darkContrast >= lightContrast
        ? KlpPalette.ink
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

  static const KlpThemeData light = KlpThemeData(
    app: KlpPalette.canvas,
    surface: KlpPalette.paper,
    surfaceInset: KlpPalette.paperInset,
    surfaceMuted: KlpPalette.canvasMuted,
    component: KlpPalette.component,
    stageSurface: KlpPalette.stage,
    overlay: KlpPalette.component,
    surfaceRaised: KlpPalette.component,
    modalScrim: KlpPalette.modalScrim,
    guide: KlpPalette.guide,
    divider: KlpPalette.divider,
    text: KlpPalette.ink,
    textMuted: KlpPalette.inkMuted,
    textFaint: KlpPalette.inkFaint,
    border: KlpPalette.line,
    borderStrong: KlpPalette.lineStrong,
    accent: KlpPalette.accent,
    accentSoft: KlpPalette.accentSoft,
    interaction: KlpPalette.interaction,
    interactionSoft: KlpPalette.interactionSoft,
    success: KlpPalette.lightSuccess,
    warning: KlpPalette.lightWarning,
    danger: KlpPalette.lightDanger,
    info: KlpPalette.lightInfo,
  );

  static const KlpThemeData dark = KlpThemeData(
    app: KlpPalette.duskRaised,
    surface: KlpPalette.duskMuted,
    surfaceInset: KlpPalette.duskLifted,
    surfaceMuted: KlpPalette.duskLifted,
    component: KlpPalette.duskInset,
    stageSurface: KlpPalette.duskStage,
    overlay: KlpPalette.duskLifted,
    surfaceRaised: KlpPalette.duskLifted,
    modalScrim: KlpPalette.modalScrim,
    guide: KlpPalette.duskGuide,
    divider: KlpPalette.duskDivider,
    text: KlpPalette.chalk,
    textMuted: KlpPalette.chalkMuted,
    textFaint: KlpPalette.chalkFaint,
    border: KlpPalette.nightLine,
    borderStrong: KlpPalette.nightLineStrong,
    accent: KlpPalette.chalk,
    accentSoft: KlpPalette.duskMuted,
    interaction: KlpPalette.chalk,
    interactionSoft: KlpPalette.duskMuted,
    success: KlpPalette.darkSuccess,
    warning: KlpPalette.darkWarning,
    danger: KlpPalette.darkDanger,
    info: KlpPalette.darkInfo,
  );

  static const KlpThemeData ultraDark = KlpThemeData(
    app: KlpPalette.night,
    surface: KlpPalette.nightInset,
    surfaceInset: KlpPalette.nightMuted,
    surfaceMuted: KlpPalette.nightMuted,
    component: KlpPalette.nightComponent,
    stageSurface: KlpPalette.nightStage,
    overlay: KlpPalette.nightMuted,
    surfaceRaised: KlpPalette.nightMuted,
    modalScrim: KlpPalette.modalScrim,
    guide: KlpPalette.nightGuide,
    divider: KlpPalette.nightDivider,
    text: KlpPalette.chalk,
    textMuted: KlpPalette.chalkMuted,
    textFaint: KlpPalette.chalkFaint,
    border: KlpPalette.nightLine,
    borderStrong: KlpPalette.nightLineStrong,
    accent: KlpPalette.chalk,
    accentSoft: KlpPalette.nightInset,
    interaction: KlpPalette.chalk,
    interactionSoft: KlpPalette.nightInteractionSoft,
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
  static OutlineInputBorder borderFor(KlpShapeTheme shape) => OutlineInputBorder(
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

ThemeData buildKlpTheme(
  Brightness brightness, {
  KlpAccent accent = KlpAccent.ink,
  KlpVisualStyle style = KlpVisualStyle.modern,
}) {
  final baseTokens = brightness == Brightness.dark
      ? KlpThemeData.dark
      : KlpThemeData.light;
  return _buildKlpThemeData(baseTokens, accent: accent, style: style);
}

ThemeData buildKlpThemeVariant(
  KlpThemeVariant variant, {
  KlpAccent accent = KlpAccent.ink,
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
  KlpAccent accent = KlpAccent.ink,
  bool transparencyEnabled = false,
  KlpVisualStyle style = KlpVisualStyle.modern,
}) {
  final brightness = identical(baseTokens, KlpThemeData.light)
      ? Brightness.light
      : Brightness.dark;
  final interactionColor = accent.resolve(brightness);
  final themedTokens = baseTokens.copyWith(
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
  final dataVisualizationTokens = identical(baseTokens, KlpThemeData.light)
      ? KlpDataVisualizationTheme.light
      : identical(baseTokens, KlpThemeData.dark)
      ? KlpDataVisualizationTheme.dark
      : KlpDataVisualizationTheme.ultraDark;
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
