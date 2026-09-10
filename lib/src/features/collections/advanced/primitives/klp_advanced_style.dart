part of '../klp_advanced_data.dart';

class _KlpAdvancedStyle {
  const _KlpAdvancedStyle({
    required this.component,
    required this.surfaceInset,
    required this.surfaceMuted,
    required this.divider,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.selectionForeground,
    required this.warning,
    required this.info,
    required this.success,
    required this.danger,
    required this.cardRadius,
    required this.controlRadius,
    required this.strokeWidth,
    required this.controlHeight,
    required this.controlHeightLarge,
    required this.controlInset,
    required this.contentInset,
    required this.baseSpace,
    required this.tightSpace,
    required this.comfortableSpace,
    required this.inlineGap,
    required this.iconSize,
    required this.iconSmall,
    required this.treeLeadingGap,
    required this.filePreviewHeight,
    required this.statusRowOpacity,
    required this.statusRowSelectedOpacity,
  });

  factory _KlpAdvancedStyle.from(BuildContext context) {
    final klp = context.klp;
    final colors = context.klpColors;
    final surface = klp.surface;
    final isDark = klp.isDark;

    return _KlpAdvancedStyle(
      component: colors.component,
      surfaceInset: colors.surfaceInset,
      surfaceMuted: colors.surfaceMuted,
      divider: colors.divider,
      text: colors.text,
      textMuted: colors.textMuted,
      textFaint: colors.textFaint,
      selectionForeground: colors.selectionForeground,
      warning: colors.warning,
      info: colors.info,
      success: colors.success,
      danger: colors.danger,
      cardRadius: klp.shape.card,
      controlRadius: klp.shape.control,
      strokeWidth: klp.shape.hairline,
      controlHeight: klp.space.controlHeight,
      controlHeightLarge: klp.space.controlHeightLarge,
      controlInset: klp.space.controlInset,
      contentInset: klp.space.contentInset,
      baseSpace: klp.space.base,
      tightSpace: klp.space.tight,
      comfortableSpace: klp.space.comfortable,
      inlineGap: klp.space.contentInlineGap,
      iconSize: klp.space.icon,
      iconSmall: klp.space.iconSmall,
      treeLeadingGap: klp.geometry.layout.treeLeadingGap,
      filePreviewHeight: klp.geometry.data.filePreviewHeight,
      statusRowOpacity: isDark
          ? surface.statusRowOpacityDark
          : surface.statusRowOpacity,
      statusRowSelectedOpacity: isDark
          ? surface.statusRowSelectedOpacityDark
          : surface.statusRowSelectedOpacity,
    );
  }

  final Color component;
  final Color surfaceInset;
  final Color surfaceMuted;
  final Color divider;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color selectionForeground;
  final Color warning;
  final Color info;
  final Color success;
  final Color danger;
  final double cardRadius;
  final double controlRadius;
  final double strokeWidth;
  final double controlHeight;
  final double controlHeightLarge;
  final double controlInset;
  final double contentInset;
  final double baseSpace;
  final double tightSpace;
  final double comfortableSpace;
  final double inlineGap;
  final double iconSize;
  final double iconSmall;
  final double treeLeadingGap;
  final double filePreviewHeight;
  final double statusRowOpacity;
  final double statusRowSelectedOpacity;
}
