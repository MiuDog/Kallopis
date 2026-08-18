import 'package:flutter/material.dart';

import 'klp_component_theme.dart';
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
  });

  final KlpThemeData color;
  final KlpTypographyTheme type;
  final KlpSpacingTheme space;
  final KlpShapeTheme shape;
  final KlpMotionTheme motion;
  final KlpSurfaceTheme surface;
  final KlpComponentTheme component;

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
  double get menuItemHeight => component.resolveMenuItemHeight(space);

  double get cardRadius => component.resolveCardRadius(shape);
  double get cardPadding => component.resolveCardPadding(space);

  double get badgeRadius => component.resolveBadgeRadius(shape);
  double get badgePaddingX => component.resolveBadgePaddingX(space);

  List<BoxShadow> get overlayShadow => surface.overlayShadow(color.text);

  /// hover 底色。混合比例來自 surface 層，因此不同風格的 hover 對比可以不同。
  Color get hoverSurface => color.hoverSurfaceWith(surface.hoverContrastMix);
}

/// 讓元件寫 `context.klp.space.base`。
extension KlpThemeContext on BuildContext {
  /// 全部 token 層。新程式碼一律用這個。
  KlpTheme get klp => KlpTheme.of(this);

  /// 只取色彩層的捷徑。色彩是最常單獨使用的一層，因此保留這個縮寫，
  /// 但它不是取得其他 token 的途徑——間距、圓角、動畫都必須經由 [klp]。
  KlpThemeData get klpColors =>
      Theme.of(this).extension<KlpThemeData>() ?? KlpThemeData.light;
}
