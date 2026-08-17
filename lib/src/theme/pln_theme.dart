import 'package:flutter/material.dart';

import 'pln_data_visualization_theme.dart';
import '../foundation/pln_accent.dart';
import '../foundation/pln_metrics.dart';
import '../foundation/pln_palette.dart';

abstract final class PlnThemeContrast {
  static Color foregroundFor(Color background) {
    final backgroundLuminance = background.computeLuminance();
    final darkContrast = _contrastRatio(
      backgroundLuminance,
      PlnPalette.ink.computeLuminance(),
    );
    final lightContrast = _contrastRatio(
      backgroundLuminance,
      PlnPalette.pureWhite.computeLuminance(),
    );

    return darkContrast >= lightContrast
        ? PlnPalette.ink
        : PlnPalette.pureWhite;
  }

  static double _contrastRatio(double first, double second) {
    final lighter = first > second ? first : second;
    final darker = first > second ? second : first;
    return (lighter + 0.05) / (darker + 0.05);
  }
}

@immutable
class PlnThemeData extends ThemeExtension<PlnThemeData> {
  const PlnThemeData({
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

  Color get onInteraction => PlnThemeContrast.foregroundFor(interaction);

  Color get onStatus => PlnPalette.pureWhite;

  Color get selection => text;

  Color get onSelection => app;

  Color get selectionBackground => surfaceMuted;

  Color get selectionForeground => text;

  Color get hoverSurface =>
      Color.lerp(surfaceInset, text, PlnInteraction.hoverContrastMix)!;

  PlnThemeData withWindowTransparency(Brightness brightness) {
    final paneOpacity = brightness == Brightness.light
        ? PlnTransparency.lightPaneOpacity
        : PlnTransparency.darkPaneOpacity;

    return copyWith(
      app: Colors.transparent,
      surface: surface.withValues(alpha: paneOpacity),
      stageSurface: stageSurface.withValues(alpha: paneOpacity),
    );
  }

  static const PlnThemeData light = PlnThemeData(
    app: PlnPalette.canvas,
    surface: PlnPalette.paper,
    surfaceInset: PlnPalette.paperInset,
    surfaceMuted: PlnPalette.canvasMuted,
    component: PlnPalette.component,
    stageSurface: PlnPalette.stage,
    overlay: PlnPalette.component,
    settingsNavigation: PlnPalette.paper,
    settingsContent: PlnPalette.component,
    modalScrim: PlnPalette.modalScrim,
    guide: PlnPalette.guide,
    divider: PlnPalette.divider,
    diffAdd: PlnPalette.diffAdd,
    diffRemove: PlnPalette.diffRemove,
    text: PlnPalette.ink,
    textMuted: PlnPalette.inkMuted,
    textFaint: PlnPalette.inkFaint,
    border: PlnPalette.line,
    borderStrong: PlnPalette.lineStrong,
    accent: PlnPalette.accent,
    accentSoft: PlnPalette.accentSoft,
    interaction: PlnPalette.interaction,
    interactionSoft: PlnPalette.interactionSoft,
    success: PlnPalette.lightSuccess,
    warning: PlnPalette.lightWarning,
    danger: PlnPalette.lightDanger,
    info: PlnPalette.lightInfo,
  );

  static const PlnThemeData dark = PlnThemeData(
    app: PlnPalette.duskRaised,
    surface: PlnPalette.duskMuted,
    surfaceInset: PlnPalette.duskLifted,
    surfaceMuted: PlnPalette.duskLifted,
    component: PlnPalette.duskInset,
    stageSurface: PlnPalette.duskStage,
    overlay: PlnPalette.duskLifted,
    settingsNavigation: PlnPalette.duskMuted,
    settingsContent: PlnPalette.duskLifted,
    modalScrim: PlnPalette.modalScrim,
    guide: PlnPalette.duskGuide,
    divider: PlnPalette.duskDivider,
    diffAdd: PlnPalette.nightDiffAdd,
    diffRemove: PlnPalette.nightDiffRemove,
    text: PlnPalette.chalk,
    textMuted: PlnPalette.chalkMuted,
    textFaint: PlnPalette.chalkFaint,
    border: PlnPalette.nightLine,
    borderStrong: PlnPalette.nightLineStrong,
    accent: PlnPalette.chalk,
    accentSoft: PlnPalette.duskMuted,
    interaction: PlnPalette.chalk,
    interactionSoft: PlnPalette.duskMuted,
    success: PlnPalette.darkSuccess,
    warning: PlnPalette.darkWarning,
    danger: PlnPalette.darkDanger,
    info: PlnPalette.darkInfo,
  );

  static const PlnThemeData ultraDark = PlnThemeData(
    app: PlnPalette.night,
    surface: PlnPalette.nightInset,
    surfaceInset: PlnPalette.nightMuted,
    surfaceMuted: PlnPalette.nightMuted,
    component: PlnPalette.nightComponent,
    stageSurface: PlnPalette.nightStage,
    overlay: PlnPalette.nightMuted,
    settingsNavigation: PlnPalette.nightInset,
    settingsContent: PlnPalette.nightMuted,
    modalScrim: PlnPalette.modalScrim,
    guide: PlnPalette.nightGuide,
    divider: PlnPalette.nightDivider,
    diffAdd: PlnPalette.nightDiffAdd,
    diffRemove: PlnPalette.nightDiffRemove,
    text: PlnPalette.chalk,
    textMuted: PlnPalette.chalkMuted,
    textFaint: PlnPalette.chalkFaint,
    border: PlnPalette.nightLine,
    borderStrong: PlnPalette.nightLineStrong,
    accent: PlnPalette.chalk,
    accentSoft: PlnPalette.nightInset,
    interaction: PlnPalette.chalk,
    interactionSoft: PlnPalette.nightInteractionSoft,
    success: PlnPalette.darkSuccess,
    warning: PlnPalette.darkWarning,
    danger: PlnPalette.darkDanger,
    info: PlnPalette.darkInfo,
  );

  static final PlnThemeData transparent = dark.withWindowTransparency(
    Brightness.dark,
  );

  @override
  PlnThemeData copyWith({
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
    return PlnThemeData(
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
  PlnThemeData lerp(covariant PlnThemeData? other, double t) {
    if (other == null) return this;

    return PlnThemeData(
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

enum PlnThemeVariant { light, dark, ultraDark, transparent }

extension PlnThemeContext on BuildContext {
  PlnThemeData get plnTheme =>
      Theme.of(this).extension<PlnThemeData>() ?? PlnThemeData.light;
}

enum PlnFieldFillState { rest, hovered, focused, selected, disabled, error }

abstract final class PlnFieldStyle {
  static OutlineInputBorder get border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(PlnRadius.control),
    borderSide: BorderSide.none,
  );

  static Color colorFor(PlnThemeData tokens, PlnFieldFillState state) {
    return switch (state) {
      PlnFieldFillState.rest => tokens.surfaceInset,
      PlnFieldFillState.hovered => tokens.hoverSurface,
      PlnFieldFillState.focused ||
      PlnFieldFillState.selected => tokens.hoverSurface,
      PlnFieldFillState.disabled => tokens.surfaceMuted,
      PlnFieldFillState.error => tokens.diffRemove,
    };
  }

  static Color resolveInputColor(PlnThemeData tokens, Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return colorFor(tokens, PlnFieldFillState.disabled);
    }
    if (states.contains(WidgetState.error)) {
      return colorFor(tokens, PlnFieldFillState.error);
    }
    if (states.contains(WidgetState.focused)) {
      return colorFor(tokens, PlnFieldFillState.focused);
    }
    if (states.contains(WidgetState.hovered)) {
      return colorFor(tokens, PlnFieldFillState.hovered);
    }

    return colorFor(tokens, PlnFieldFillState.rest);
  }

  static WidgetStateColor inputFill(PlnThemeData tokens, {bool error = false}) {
    return WidgetStateColor.resolveWith(
      (states) => error
          ? colorFor(tokens, PlnFieldFillState.error)
          : resolveInputColor(tokens, states),
    );
  }
}

ThemeData buildPlnTheme(
  Brightness brightness, {
  PlnAccent accent = PlnAccent.ink,
}) {
  final baseTokens = brightness == Brightness.dark
      ? PlnThemeData.dark
      : PlnThemeData.light;
  return _buildPlnThemeData(baseTokens, accent: accent);
}

ThemeData buildPlnThemeVariant(
  PlnThemeVariant variant, {
  PlnAccent accent = PlnAccent.ink,
  bool transparencyEnabled = false,
}) {
  final tokens = switch (variant) {
    PlnThemeVariant.light => PlnThemeData.light,
    PlnThemeVariant.dark => PlnThemeData.dark,
    PlnThemeVariant.ultraDark => PlnThemeData.ultraDark,
    PlnThemeVariant.transparent => PlnThemeData.dark,
  };

  return _buildPlnThemeData(
    tokens,
    accent: accent,
    transparencyEnabled:
        transparencyEnabled || variant == PlnThemeVariant.transparent,
  );
}

ThemeData _buildPlnThemeData(
  PlnThemeData baseTokens, {
  PlnAccent accent = PlnAccent.ink,
  bool transparencyEnabled = false,
}) {
  final brightness = identical(baseTokens, PlnThemeData.light)
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
  final dataVisualizationTokens = identical(baseTokens, PlnThemeData.light)
      ? PlnDataVisualizationTheme.light
      : identical(baseTokens, PlnThemeData.dark)
      ? PlnDataVisualizationTheme.dark
      : PlnDataVisualizationTheme.ultraDark;
  final baseTextTheme = ThemeData(
    brightness: brightness,
    useMaterial3: false,
    fontFamily: PlnTypography.uiFamily,
    fontFamilyFallback: PlnTypography.uiFallback,
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
      fontSize: PlnTypography.body,
    ),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(
      color: tokens.textMuted,
      fontSize: PlnTypography.body,
    ),
    bodySmall: baseTextTheme.bodySmall?.copyWith(
      color: tokens.textMuted,
      fontSize: PlnTypography.small,
    ),
    labelLarge: baseTextTheme.labelLarge?.copyWith(
      color: tokens.textMuted,
      fontSize: PlnTypography.body,
    ),
    labelMedium: baseTextTheme.labelMedium?.copyWith(
      color: tokens.textMuted,
      fontSize: PlnTypography.small,
    ),
    labelSmall: baseTextTheme.labelSmall?.copyWith(
      color: tokens.textMuted,
      fontSize: PlnTypography.small,
      fontWeight: PlnTypography.regular,
    ),
  );

  return ThemeData(
    brightness: brightness,
    useMaterial3: false,
    splashFactory: NoSplash.splashFactory,
    splashColor: const Color(0x00000000),
    highlightColor: const Color(0x00000000),
    scaffoldBackgroundColor: tokens.app,
    fontFamily: PlnTypography.uiFamily,
    fontFamilyFallback: PlnTypography.uiFallback,
    textTheme: textTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: tokens.interaction,
      brightness: brightness,
      surface: tokens.surface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: PlnFieldStyle.border,
      enabledBorder: PlnFieldStyle.border,
      focusedBorder: PlnFieldStyle.border,
      disabledBorder: PlnFieldStyle.border,
      errorBorder: PlnFieldStyle.border,
      focusedErrorBorder: PlnFieldStyle.border,
      hoverColor: PlnFieldStyle.colorFor(tokens, PlnFieldFillState.hovered),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(tokens.textFaint),
      trackColor: const WidgetStatePropertyAll(Color(0x00000000)),
      trackBorderColor: const WidgetStatePropertyAll(Color(0x00000000)),
      thickness: const WidgetStatePropertyAll(
        PlnControlMetrics.scrollbarThickness,
      ),
      radius: const Radius.circular(PlnRadius.full),
      trackVisibility: const WidgetStatePropertyAll(false),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: tokens.overlay,
        borderRadius: BorderRadius.circular(PlnRadius.control),
      ),
      textStyle: TextStyle(
        color: tokens.textMuted,
        fontSize: PlnTypography.small,
        fontFamily: PlnTypography.uiFamily,
        fontFamilyFallback: PlnTypography.uiFallback,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: PlnSpace.sm,
        vertical: PlnSpace.xs,
      ),
      waitDuration: const Duration(milliseconds: 450),
      showDuration: const Duration(seconds: 4),
      preferBelow: false,
    ),
    extensions: [tokens, dataVisualizationTokens],
  );
}
