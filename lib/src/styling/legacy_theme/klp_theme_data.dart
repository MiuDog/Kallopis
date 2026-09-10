import 'package:flutter/material.dart';

import '../legacy_tokens/primitive_token.dart';
import 'klp_surface_theme.dart';

part '../presets/legacy/default_colors.dart';

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
    Color? brand,
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
  }) : brand = brand ?? accent,
       pagePattern = pagePattern ?? guide;

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

  /// 產品識別的主題色；不自動覆寫操作用途的 [accent] 或 [interaction]。
  final Color brand;

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
  static const KlpThemeData light = _defaultColorsLight;

  /// 暗態：整條梯翻轉；輔助文字使用 ink400，確保石墨表面仍達 3:1。
  static const KlpThemeData dark = _defaultColorsDark;

  /// 全暗態：比 dark 再往下一階，給 OLED 與長時間閱讀用。
  static const KlpThemeData ultraDark = _defaultColorsUltraDark;

  static final KlpThemeData transparent = _defaultColorsTransparent;

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
    Color? brand,
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
      brand: brand ?? this.brand,
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
          brand == other.brand &&
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
    brand,
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
