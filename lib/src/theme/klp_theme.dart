import 'package:flutter/material.dart';

import 'klp_data_visualization_theme.dart';
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
    required this.settingsNavigation,
    required this.settingsContent,
    required this.modalScrim,
    required this.guide,
    required this.divider,
    required this.diffAdd,
    required this.diffRemove,
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
  final Color settingsNavigation;
  final Color settingsContent;
  final Color modalScrim;
  final Color guide;
  final Color divider;
  final Color diffAdd;
  final Color diffRemove;
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

  Color get hoverSurface =>
      Color.lerp(surfaceInset, text, KlpInteraction.hoverContrastMix)!;

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
    settingsNavigation: KlpPalette.paper,
    settingsContent: KlpPalette.component,
    modalScrim: KlpPalette.modalScrim,
    guide: KlpPalette.guide,
    divider: KlpPalette.divider,
    diffAdd: KlpPalette.diffAdd,
    diffRemove: KlpPalette.diffRemove,
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
    settingsNavigation: KlpPalette.duskMuted,
    settingsContent: KlpPalette.duskLifted,
    modalScrim: KlpPalette.modalScrim,
    guide: KlpPalette.duskGuide,
    divider: KlpPalette.duskDivider,
    diffAdd: KlpPalette.nightDiffAdd,
    diffRemove: KlpPalette.nightDiffRemove,
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
    settingsNavigation: KlpPalette.nightInset,
    settingsContent: KlpPalette.nightMuted,
    modalScrim: KlpPalette.modalScrim,
    guide: KlpPalette.nightGuide,
    divider: KlpPalette.nightDivider,
    diffAdd: KlpPalette.nightDiffAdd,
    diffRemove: KlpPalette.nightDiffRemove,
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
    Color? settingsNavigation,
    Color? settingsContent,
    Color? modalScrim,
    Color? guide,
    Color? divider,
    Color? diffAdd,
    Color? diffRemove,
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
      settingsNavigation: settingsNavigation ?? this.settingsNavigation,
      settingsContent: settingsContent ?? this.settingsContent,
      modalScrim: modalScrim ?? this.modalScrim,
      guide: guide ?? this.guide,
      divider: divider ?? this.divider,
      diffAdd: diffAdd ?? this.diffAdd,
      diffRemove: diffRemove ?? this.diffRemove,
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
      settingsNavigation: Color.lerp(
        settingsNavigation,
        other.settingsNavigation,
        t,
      )!,
      settingsContent: Color.lerp(settingsContent, other.settingsContent, t)!,
      modalScrim: Color.lerp(modalScrim, other.modalScrim, t)!,
      guide: Color.lerp(guide, other.guide, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      diffAdd: Color.lerp(diffAdd, other.diffAdd, t)!,
      diffRemove: Color.lerp(diffRemove, other.diffRemove, t)!,
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
  static OutlineInputBorder get border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(KlpRadius.control),
    borderSide: BorderSide.none,
  );

  static Color colorFor(KlpThemeData tokens, KlpFieldFillState state) {
    return switch (state) {
      KlpFieldFillState.rest => tokens.surfaceInset,
      KlpFieldFillState.hovered => tokens.hoverSurface,
      KlpFieldFillState.focused ||
      KlpFieldFillState.selected => tokens.hoverSurface,
      KlpFieldFillState.disabled => tokens.surfaceMuted,
      KlpFieldFillState.error => tokens.diffRemove,
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
}) {
  final baseTokens = brightness == Brightness.dark
      ? KlpThemeData.dark
      : KlpThemeData.light;
  return _buildKlpThemeData(baseTokens, accent: accent);
}

ThemeData buildKlpThemeVariant(
  KlpThemeVariant variant, {
  KlpAccent accent = KlpAccent.ink,
  bool transparencyEnabled = false,
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
    transparencyEnabled:
        transparencyEnabled || variant == KlpThemeVariant.transparent,
  );
}

ThemeData _buildKlpThemeData(
  KlpThemeData baseTokens, {
  KlpAccent accent = KlpAccent.ink,
  bool transparencyEnabled = false,
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
    fontFamily: KlpTypography.uiFamily,
    fontFamilyFallback: KlpTypography.uiFallback,
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
      fontSize: KlpTypography.body,
    ),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(
      color: tokens.textMuted,
      fontSize: KlpTypography.body,
    ),
    bodySmall: baseTextTheme.bodySmall?.copyWith(
      color: tokens.textMuted,
      fontSize: KlpTypography.small,
    ),
    labelLarge: baseTextTheme.labelLarge?.copyWith(
      color: tokens.textMuted,
      fontSize: KlpTypography.body,
    ),
    labelMedium: baseTextTheme.labelMedium?.copyWith(
      color: tokens.textMuted,
      fontSize: KlpTypography.small,
    ),
    labelSmall: baseTextTheme.labelSmall?.copyWith(
      color: tokens.textMuted,
      fontSize: KlpTypography.small,
      fontWeight: KlpTypography.regular,
    ),
  );

  return ThemeData(
    brightness: brightness,
    useMaterial3: false,
    splashFactory: NoSplash.splashFactory,
    splashColor: const Color(0x00000000),
    highlightColor: const Color(0x00000000),
    scaffoldBackgroundColor: tokens.app,
    fontFamily: KlpTypography.uiFamily,
    fontFamilyFallback: KlpTypography.uiFallback,
    textTheme: textTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: tokens.interaction,
      brightness: brightness,
      surface: tokens.surface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: KlpFieldStyle.border,
      enabledBorder: KlpFieldStyle.border,
      focusedBorder: KlpFieldStyle.border,
      disabledBorder: KlpFieldStyle.border,
      errorBorder: KlpFieldStyle.border,
      focusedErrorBorder: KlpFieldStyle.border,
      hoverColor: KlpFieldStyle.colorFor(tokens, KlpFieldFillState.hovered),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(tokens.textFaint),
      trackColor: const WidgetStatePropertyAll(Color(0x00000000)),
      trackBorderColor: const WidgetStatePropertyAll(Color(0x00000000)),
      thickness: const WidgetStatePropertyAll(
        KlpControlMetrics.scrollbarThickness,
      ),
      radius: const Radius.circular(KlpRadius.full),
      trackVisibility: const WidgetStatePropertyAll(false),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: tokens.overlay,
        borderRadius: BorderRadius.circular(KlpRadius.control),
      ),
      textStyle: TextStyle(
        color: tokens.textMuted,
        fontSize: KlpTypography.small,
        fontFamily: KlpTypography.uiFamily,
        fontFamilyFallback: KlpTypography.uiFallback,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: KlpSpace.sm,
        vertical: KlpSpace.xs,
      ),
      waitDuration: const Duration(milliseconds: 450),
      showDuration: const Duration(seconds: 4),
      preferBelow: false,
    ),
    extensions: [tokens, dataVisualizationTokens],
  );
}
