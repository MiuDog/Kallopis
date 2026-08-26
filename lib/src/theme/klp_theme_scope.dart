import 'package:flutter/material.dart';

import 'klp_component_theme.dart';
import 'klp_data_visualization_theme.dart';
import 'klp_geometry_theme.dart';
import 'klp_motion_theme.dart';
import 'klp_shape_theme.dart';
import 'klp_spacing_theme.dart';
import 'klp_surface_theme.dart';
import 'klp_theme.dart';
import 'klp_typography_theme.dart';
import 'klp_visual_style.dart';

/// 元件取得所有 token 的唯一入口。
///
/// 元件寫 `context.klp.space.base`，不寫 `KlpSpace.md` 之類的編譯期常數——後者換 theme
/// 時不會跟著變，而且不會有任何錯誤訊息告訴你它沒變。
///
/// 每個 getter 在對應的 `ThemeExtension` 缺席時回退到預設值而非拋錯：庫被放進一個沒有
/// 設定 Kallopis theme 的 app 時應該仍能渲染，只是長成預設風格。
@immutable
class KlpTheme {
  const KlpTheme({
    required this.color,
    required this.type,
    required this.space,
    required this.shape,
    required this.motion,
    required this.surface,
    required this.component,
    this.dataVisualization = KlpDataVisualizationTheme.light,
    this.geometry = KlpGeometryTheme.standard,
  });

  final KlpThemeData color;
  final KlpTypographyTheme type;
  final KlpSpacingTheme space;
  final KlpShapeTheme shape;
  final KlpMotionTheme motion;
  final KlpSurfaceTheme surface;
  final KlpComponentTheme component;
  final KlpDataVisualizationTheme dataVisualization;
  final KlpGeometryTheme geometry;

  static KlpTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return KlpTheme(
      color: theme.extension<KlpThemeData>() ?? KlpThemeData.light,
      type:
          theme.extension<KlpTypographyTheme>() ??
          KlpTypographyTheme.proportional,
      space:
          theme.extension<KlpSpacingTheme>() ??
          KlpSpacingTheme.comfortableDensity,
      shape: theme.extension<KlpShapeTheme>() ?? KlpShapeTheme.standardShape,
      motion:
          theme.extension<KlpMotionTheme>() ?? KlpMotionTheme.standardMotion,
      surface: theme.extension<KlpSurfaceTheme>() ?? KlpSurfaceTheme.elevated,
      component:
          theme.extension<KlpComponentTheme>() ?? KlpComponentTheme.inherited,
      dataVisualization:
          theme.extension<KlpDataVisualizationTheme>() ??
          (theme.brightness == Brightness.dark
              ? KlpDataVisualizationTheme.dark
              : KlpDataVisualizationTheme.light),
      geometry:
          theme.extension<KlpGeometryTheme>() ?? KlpGeometryTheme.standard,
    );
  }

  static KlpVisualStyle styleOf(BuildContext context) {
    final tokens = of(context);
    return KlpVisualStyle(
      name: 'resolved',
      colors: tokens.color,
      typography: tokens.type,
      spacing: tokens.space,
      shape: tokens.shape,
      motion: tokens.motion,
      surface: tokens.surface,
      components: tokens.component,
      dataVisualization: tokens.dataVisualization,
      geometry: tokens.geometry,
    );
  }

  // ── 已解析的 component token ────────────────────────────────────────────
  // 元件呼叫這些，不自己組合 component 與 semantic 兩層。

  double get buttonRadius => component.resolveButtonRadius(shape);
  double get buttonHeight => component.resolveButtonHeight(space);
  double get buttonBorderWidth =>
      component.resolveButtonBorderWidth(shape, surface);
  EdgeInsets get buttonInsets => EdgeInsets.symmetric(
    horizontal: component.resolveButtonPaddingX(space),
    vertical: component.resolveButtonPaddingY(space),
  );

  double get fieldRadius => component.resolveFieldRadius(shape);
  double get fieldHeight => component.resolveFieldHeight(space);
  double get fieldBorderWidth => component.resolveFieldBorderWidth(shape);
  double get fieldPaddingX => component.resolveFieldPaddingX(space);

  double get menuRadius => component.resolveMenuRadius(shape);
  double get menuPadding => component.resolveMenuPadding(space);
  double get menuItemHeight =>
      component.resolveMenuItemHeightWithGeometry(geometry);

  double get cardRadius => component.resolveCardRadius(shape);
  double get cardPadding => component.resolveCardPadding(space);

  double get badgeRadius => component.resolveBadgeRadius(shape);
  double get badgePaddingX => component.resolveBadgePaddingX(space);

  List<BoxShadow> get overlayShadow => surface.overlayShadow(color.text);

  /// 半透明的中性壓深層。
  ///
  /// 用於需要「壓一層」而非「換一個表面」的場合（例如疊在語意色塊上）。
  /// **hover 不用這個**——見 [hoverBorder]。
  Color get selectionWash =>
      color.selectionWashWith(surface.selectionWashOpacity);

  /// hover 的虛線邊框色。
  ///
  /// 實作準則 §2.1：hover 是**暫時的**，不是狀態，因此用虛線而非填色。填色留給
  /// selected——那是會停留的狀態。兩者若都用填色，使用者分不出「指標剛好在這裡」
  /// 和「我選了這個」。
  ///
  /// 全部 hover 都從這裡取色，才不會出現十幾個元件各自調一個「差不多的灰」。
  Color get hoverBorder => color.guide.withValues(alpha: shape.dashedOpacity);

  /// selected 的填色。
  ///
  /// **刻意不是 accent。** 實作準則第 5 條：accent 只用於主要 CTA、文字連結、
  /// 鍵盤焦點與明確可執行的操作，不得用於 selected、checked、目前導覽項目——
  /// 那會讓「可以按下去做某件事」與「你現在在這裡」用同一個顏色說話。
  ///
  /// 選取的第二個訊號是文字由 secondary 升到 primary（見準則 §2.1），
  /// 因此不需要靠顏色強度來表達，中性表面就夠。
  Color get selectedSurface => color.surfaceMuted;

  /// 目前是不是暗色主題。
  ///
  /// 由主表面的相對亮度推導，而不是讀 `Theme.of(context).brightness`：後者是
  /// Material 自己的狀態，與這個庫的色彩層各自獨立——消費者只覆寫 [KlpThemeData]
  /// 而沒同步 Material 的 brightness 時，兩者就會給出相反的答案。
  ///
  /// **元件不得自己寫 `computeLuminance() < 0.5`**：那會讓「什麼算暗色」這條規則
  /// 散成好幾份，各自的門檻還可能不同。
  bool get isDark => color.surface.computeLuminance() < 0.5;

  /// 依目前明暗挑一個值。兩個分支都必須是 token，不是字面值。
  T byBrightness<T>({required T light, required T dark}) =>
      isDark ? dark : light;
}

/// 用一組覆寫過的色彩 token 包住子樹。
///
/// 「把 [KlpThemeData] 換掉、其餘 extension 原封不動」這件事原本在 `KlpSurface`、
/// `KlpPanelFrame`、`KlpStageFrame`、`KlpAppScreen` 各寫了一份完全相同的
/// `Theme.of(context).copyWith(extensions: ...)`。四份實作只要有一份漏掉
/// `where((ext) => ext is! KlpThemeData)`，該子樹就會拿到兩個色彩層，而且不會報錯。
class KlpTokenOverride extends StatelessWidget {
  const KlpTokenOverride({
    super.key,
    required this.colors,
    required this.child,
  });

  /// 要套用到子樹的色彩層。
  final KlpThemeData colors;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final inherited = Theme.of(context);

    return Theme(
      data: inherited.copyWith(
        extensions: [
          ...inherited.extensions.values.where((ext) => ext is! KlpThemeData),
          colors,
        ],
      ),
      child: child,
    );
  }
}

/// 讓元件寫 `context.klp.space.base`。
extension KlpThemeContext on BuildContext {
  /// 全部 token 層。新程式碼一律用這個。
  KlpTheme get klp => KlpTheme.of(this);

  /// 只取色彩層的捷徑。色彩是最常單獨使用的一層，因此保留這個縮寫，
  /// 但它不是取得其他 token 的途徑——間距、圓角、動畫都必須經由 [klp]。
  ///
  /// **它委派給 [klp]，不自己解析。** 先前這裡有一份獨立的
  /// `extension<KlpThemeData>() ?? KlpThemeData.light`，與 [KlpTheme.of] 裡的那份
  /// 是同一條規則的兩份實作——改了其中一份的回退行為，另一份不會報錯，只是不一致。
  KlpThemeData get klpColors => klp.color;
}
