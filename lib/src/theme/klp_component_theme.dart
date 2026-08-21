import 'package:flutter/material.dart';

import 'klp_shape_theme.dart';
import 'klp_spacing_theme.dart';
import 'klp_surface_theme.dart';
import 'klp_geometry_theme.dart';

/// Layer 3：component token。
///
/// 只有當某個元件**需要偏離** semantic 預設時才在這裡出現。每個欄位都是 nullable，
/// `null` 表示「沿用 semantic」——因此這一層是稀疏的，不是把 semantic 抄一遍。
///
/// 元件永遠透過 [resolve] 系列方法取值，拿到的一定是已解析的具體數值，元件本身不需要
/// 知道值來自哪一層。這是「風格繼承樹」的落點：primitive → semantic → component，
/// 由下往上找第一個有定義的值。
@immutable
class KlpComponentTheme extends ThemeExtension<KlpComponentTheme> {
  const KlpComponentTheme({
    this.buttonRadius,
    this.buttonPaddingX,
    this.buttonPaddingY,
    this.buttonHeight,
    this.buttonBorderWidth,
    this.fieldRadius,
    this.fieldPaddingX,
    this.fieldHeight,
    this.fieldBorderWidth,
    this.menuRadius,
    this.menuPadding,
    this.menuItemHeight,
    this.cardRadius,
    this.cardPadding,
    this.badgeRadius,
    this.badgePaddingX,
  });

  final double? buttonRadius;
  final double? buttonPaddingX;
  final double? buttonPaddingY;
  final double? buttonHeight;
  final double? buttonBorderWidth;

  final double? fieldRadius;
  final double? fieldPaddingX;
  final double? fieldHeight;
  final double? fieldBorderWidth;

  final double? menuRadius;
  final double? menuPadding;
  final double? menuItemHeight;

  final double? cardRadius;
  final double? cardPadding;

  final double? badgeRadius;
  final double? badgePaddingX;

  /// 沒有任何偏離，全部沿用 semantic。這是預設，也是應該最常見的狀態——
  /// component token 大量出現代表 semantic 層沒設計好。
  static const KlpComponentTheme inherited = KlpComponentTheme();

  // ── 解析：component → semantic ────────────────────────────────────────────

  double resolveButtonRadius(KlpShapeTheme shape) =>
      buttonRadius ?? shape.control;
  double resolveButtonPaddingX(KlpSpacingTheme s) =>
      buttonPaddingX ?? s.controlPaddingX;
  double resolveButtonPaddingY(KlpSpacingTheme s) =>
      buttonPaddingY ?? s.controlPaddingY;
  double resolveButtonHeight(KlpSpacingTheme s) =>
      buttonHeight ?? s.controlHeight;
  double resolveButtonBorderWidth(KlpShapeTheme shape, KlpSurfaceTheme _) =>
      buttonBorderWidth ?? shape.none;

  double resolveFieldRadius(KlpShapeTheme shape) =>
      fieldRadius ?? shape.control;
  double resolveFieldPaddingX(KlpSpacingTheme s) => fieldPaddingX ?? s.compact;
  double resolveFieldHeight(KlpSpacingTheme s) =>
      fieldHeight ?? s.controlHeight;
  double resolveFieldBorderWidth(KlpShapeTheme shape) =>
      fieldBorderWidth ?? shape.none;

  double resolveMenuRadius(KlpShapeTheme shape) => menuRadius ?? shape.card;
  double resolveMenuPadding(KlpSpacingTheme s) => menuPadding ?? s.compact;
  double resolveMenuItemHeight(KlpSpacingTheme s) =>
      menuItemHeight ?? s.controlHeightSmall;
  double resolveMenuItemHeightWithGeometry(KlpGeometryTheme geometry) =>
      menuItemHeight ?? geometry.layout.menuItemHeight;

  double resolveCardRadius(KlpShapeTheme shape) => cardRadius ?? shape.card;
  double resolveCardPadding(KlpSpacingTheme s) =>
      cardPadding ?? s.containerPadding;

  double resolveBadgeRadius(KlpShapeTheme shape) =>
      badgeRadius ?? shape.control;
  double resolveBadgePaddingX(KlpSpacingTheme s) => badgePaddingX ?? s.compact;

  @override
  KlpComponentTheme copyWith({
    double? buttonRadius,
    double? buttonPaddingX,
    double? buttonPaddingY,
    double? buttonHeight,
    double? buttonBorderWidth,
    double? fieldRadius,
    double? fieldPaddingX,
    double? fieldHeight,
    double? fieldBorderWidth,
    double? menuRadius,
    double? menuPadding,
    double? menuItemHeight,
    double? cardRadius,
    double? cardPadding,
    double? badgeRadius,
    double? badgePaddingX,
  }) {
    return KlpComponentTheme(
      buttonRadius: buttonRadius ?? this.buttonRadius,
      buttonPaddingX: buttonPaddingX ?? this.buttonPaddingX,
      buttonPaddingY: buttonPaddingY ?? this.buttonPaddingY,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      buttonBorderWidth: buttonBorderWidth ?? this.buttonBorderWidth,
      fieldRadius: fieldRadius ?? this.fieldRadius,
      fieldPaddingX: fieldPaddingX ?? this.fieldPaddingX,
      fieldHeight: fieldHeight ?? this.fieldHeight,
      fieldBorderWidth: fieldBorderWidth ?? this.fieldBorderWidth,
      menuRadius: menuRadius ?? this.menuRadius,
      menuPadding: menuPadding ?? this.menuPadding,
      menuItemHeight: menuItemHeight ?? this.menuItemHeight,
      cardRadius: cardRadius ?? this.cardRadius,
      cardPadding: cardPadding ?? this.cardPadding,
      badgeRadius: badgeRadius ?? this.badgeRadius,
      badgePaddingX: badgePaddingX ?? this.badgePaddingX,
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
  KlpComponentTheme lerp(covariant KlpComponentTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpComponentTheme &&
          buttonRadius == other.buttonRadius &&
          buttonPaddingX == other.buttonPaddingX &&
          buttonPaddingY == other.buttonPaddingY &&
          buttonHeight == other.buttonHeight &&
          buttonBorderWidth == other.buttonBorderWidth &&
          fieldRadius == other.fieldRadius &&
          fieldPaddingX == other.fieldPaddingX &&
          fieldHeight == other.fieldHeight &&
          fieldBorderWidth == other.fieldBorderWidth &&
          menuRadius == other.menuRadius &&
          menuPadding == other.menuPadding &&
          menuItemHeight == other.menuItemHeight &&
          cardRadius == other.cardRadius &&
          cardPadding == other.cardPadding &&
          badgeRadius == other.badgeRadius &&
          badgePaddingX == other.badgePaddingX;

  @override
  int get hashCode => Object.hash(
    buttonRadius,
    buttonPaddingX,
    buttonPaddingY,
    buttonHeight,
    buttonBorderWidth,
    fieldRadius,
    fieldPaddingX,
    fieldHeight,
    fieldBorderWidth,
    menuRadius,
    menuPadding,
    menuItemHeight,
    cardRadius,
    cardPadding,
    badgeRadius,
    badgePaddingX,
  );
}
