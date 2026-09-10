part of '../klp_code_viewer.dart';

class _KlpCodeStyle {
  const _KlpCodeStyle({
    required this.stageSurface,
    required this.surfaceInset,
    required this.divider,
    required this.clear,
    required this.textFaint,
    required this.textMuted,
    required this.selectionForeground,
    required this.selectionBackground,
    required this.selectionWash,
    required this.success,
    required this.danger,
    required this.onStatus,
    required this.cardRadius,
    required this.controlRadius,
    required this.strokeWidth,
    required this.headerHeight,
    required this.headerPaddingX,
    required this.bodyPaddingX,
    required this.bodyPaddingY,
    required this.actionPaddingX,
    required this.microPaddingY,
    required this.actionButtonSize,
    required this.iconSmall,
    required this.disclosureSize,
    required this.terminalDotSize,
    required this.terminalDotGap,
    required this.lineNumberWidth,
    required this.gutterNumberWidth,
    required this.gutterMarkerWidth,
    required this.collapsedHeight,
    required this.maximumHeight,
    required this.diffFillOpacity,
  });

  factory _KlpCodeStyle.from(BuildContext context) {
    final klp = context.klp;
    final colors = context.klpColors;

    return _KlpCodeStyle(
      stageSurface: colors.stageSurface,
      surfaceInset: colors.surfaceInset,
      divider: colors.divider,
      clear: colors.clear,
      textFaint: colors.textFaint,
      textMuted: colors.textMuted,
      selectionForeground: colors.selectionForeground,
      selectionBackground: colors.selectionBackground,
      selectionWash: klp.selectionWash,
      success: colors.success,
      danger: colors.danger,
      onStatus: colors.onStatus,
      cardRadius: klp.shape.card,
      controlRadius: klp.shape.control,
      strokeWidth: klp.shape.hairline,
      headerHeight: klp.geometry.data.codeHeaderHeight,
      headerPaddingX: klp.geometry.data.codeHeaderPaddingX,
      bodyPaddingX: klp.geometry.data.codeBodyPaddingX,
      bodyPaddingY: klp.space.contentInset,
      actionPaddingX: klp.space.controlInset,
      microPaddingY: klp.space.hairline,
      actionButtonSize: klp.geometry.data.codeActionButtonSize,
      iconSmall: klp.space.iconSmall,
      disclosureSize: klp.geometry.data.codeDisclosureSize,
      terminalDotSize: klp.geometry.data.codeTerminalDot,
      terminalDotGap: klp.geometry.data.codeTerminalDotGap,
      lineNumberWidth: klp.geometry.data.codeLineNumberWidth,
      gutterNumberWidth: klp.space.gutterNumber,
      gutterMarkerWidth: klp.space.gutterMarker,
      collapsedHeight: klp.geometry.data.codeCollapsedHeight,
      maximumHeight: klp.geometry.data.codeMaximumHeight,
      diffFillOpacity: klp.surface.diffFillOpacity,
    );
  }

  final Color stageSurface;
  final Color surfaceInset;
  final Color divider;
  final Color clear;
  final Color textFaint;
  final Color textMuted;
  final Color selectionForeground;
  final Color selectionBackground;
  final Color selectionWash;
  final Color success;
  final Color danger;
  final Color onStatus;
  final double cardRadius;
  final double controlRadius;
  final double strokeWidth;
  final double headerHeight;
  final double headerPaddingX;
  final double bodyPaddingX;
  final double bodyPaddingY;
  final double actionPaddingX;
  final double microPaddingY;
  final double actionButtonSize;
  final double iconSmall;
  final double disclosureSize;
  final double terminalDotSize;
  final double terminalDotGap;
  final double lineNumberWidth;
  final double gutterNumberWidth;
  final double gutterMarkerWidth;
  final double collapsedHeight;
  final double maximumHeight;
  final double diffFillOpacity;
}
