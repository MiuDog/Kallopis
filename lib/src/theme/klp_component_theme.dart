import 'package:flutter/material.dart';

import 'klp_shape_theme.dart';
import 'klp_spacing_theme.dart';
import 'klp_surface_theme.dart';

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
  double resolveButtonBorderWidth(
    KlpShapeTheme shape,
    KlpSurfaceTheme surface,
  ) => buttonBorderWidth ?? (surface.usesShadow ? 0 : shape.hairline);

  double resolveFieldRadius(KlpShapeTheme shape) =>
      fieldRadius ?? shape.control;
  double resolveFieldPaddingX(KlpSpacingTheme s) =>
      fieldPaddingX ?? s.controlPaddingX;
  double resolveFieldHeight(KlpSpacingTheme s) =>
      fieldHeight ?? s.controlHeight;
  double resolveFieldBorderWidth(KlpShapeTheme shape) =>
      fieldBorderWidth ?? shape.hairline;

  double resolveMenuRadius(KlpShapeTheme shape) => menuRadius ?? shape.card;
  double resolveMenuPadding(KlpSpacingTheme s) => menuPadding ?? s.compact;
  double resolveMenuItemHeight(KlpSpacingTheme s) =>
      menuItemHeight ?? s.controlHeightSmall;

  double resolveCardRadius(KlpShapeTheme shape) => cardRadius ?? shape.card;
  double resolveCardPadding(KlpSpacingTheme s) =>
      cardPadding ?? s.containerPadding;

  double resolveBadgeRadius(KlpShapeTheme shape) => badgeRadius ?? shape.pill;
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

  @override
  KlpComponentTheme lerp(covariant KlpComponentTheme? other, double t) {
    if (other == null) return this;
    double? l(double? a, double? b) {
      if (a == null && b == null) return null;
      if (a == null || b == null) return t < 0.5 ? a : b;
      return a + (b - a) * t;
    }

    return KlpComponentTheme(
      buttonRadius: l(buttonRadius, other.buttonRadius),
      buttonPaddingX: l(buttonPaddingX, other.buttonPaddingX),
      buttonPaddingY: l(buttonPaddingY, other.buttonPaddingY),
      buttonHeight: l(buttonHeight, other.buttonHeight),
      buttonBorderWidth: l(buttonBorderWidth, other.buttonBorderWidth),
      fieldRadius: l(fieldRadius, other.fieldRadius),
      fieldPaddingX: l(fieldPaddingX, other.fieldPaddingX),
      fieldHeight: l(fieldHeight, other.fieldHeight),
      fieldBorderWidth: l(fieldBorderWidth, other.fieldBorderWidth),
      menuRadius: l(menuRadius, other.menuRadius),
      menuPadding: l(menuPadding, other.menuPadding),
      menuItemHeight: l(menuItemHeight, other.menuItemHeight),
      cardRadius: l(cardRadius, other.cardRadius),
      cardPadding: l(cardPadding, other.cardPadding),
      badgeRadius: l(badgeRadius, other.badgeRadius),
      badgePaddingX: l(badgePaddingX, other.badgePaddingX),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpComponentTheme &&
          buttonRadius == other.buttonRadius &&
          buttonBorderWidth == other.buttonBorderWidth &&
          fieldRadius == other.fieldRadius &&
          menuRadius == other.menuRadius &&
          cardRadius == other.cardRadius &&
          badgeRadius == other.badgeRadius;

  @override
  int get hashCode => Object.hash(
    buttonRadius,
    buttonBorderWidth,
    fieldRadius,
    menuRadius,
    cardRadius,
    badgeRadius,
  );
}
