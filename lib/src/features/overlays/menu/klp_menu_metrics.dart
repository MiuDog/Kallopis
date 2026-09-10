part of '../klp_menu.dart';

abstract final class _KlpMenuMetrics {
  static double width(BuildContext context) =>
      context.klp.geometry.layout.menuWidth;
  static double headerHeight(BuildContext context) =>
      context.klp.geometry.layout.menuHeaderHeight;
  static double horizontalPadding(BuildContext context) =>
      context.klp.menuPadding;
  static double itemHeight(BuildContext context) => context.klp.menuItemHeight;
  static double iconSize(BuildContext context) => context.klp.space.iconSmall;
  static double iconGap(BuildContext context) =>
      context.klp.space.overlayItemGap;
  static double iconOpticalOffsetY(BuildContext context) =>
      context.klp.geometry.optical.menuIconOffsetY;

  // 這三項來自 theme，因此不能是編譯期常數。
  static double panelRadius(BuildContext context) => context.klp.menuRadius;
  static double menuBlurRadius(BuildContext context) =>
      context.klp.surface.overlayBlur;
  static double menuOffsetY(BuildContext context) =>
      context.klp.surface.overlayOffsetY;
}
