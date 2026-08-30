import 'package:flutter/material.dart';

import '../foundation/klp_metrics.dart';
import '../tokens/klp_scale.dart';
import 'klp_control_geometry.dart';
import 'klp_data_geometry.dart';
import 'klp_layout_geometry.dart';
import 'klp_optical_geometry.dart';

/// 不屬於密度尺度的精確元件幾何。
@immutable
class KlpGeometryTheme extends ThemeExtension<KlpGeometryTheme> {
  const KlpGeometryTheme({
    required this.control,
    required this.data,
    required this.layout,
    required this.optical,
  });

  final KlpControlGeometry control;
  final KlpDataGeometry data;
  final KlpLayoutGeometry layout;
  final KlpOpticalGeometry optical;

  static const KlpGeometryTheme standard = KlpGeometryTheme(
    control: KlpControlGeometry(
      fieldHeight: KlpFormMetrics.fieldHeight,
      selectionControl: KlpFormMetrics.selectionControl,
      selectionIndicatorInset: KlpFormMetrics.selectionIndicatorInset,
      selectionIcon: KlpFormMetrics.selectionIcon,
      toggleWidth: KlpFormMetrics.toggleWidth,
      toggleHeight: KlpFormMetrics.toggleHeight,
      toggleThumb: KlpFormMetrics.toggleThumb,
      toggleInset: KlpFormMetrics.toggleInset,
      segmentedDenseHeight: KlpSize.segmentedDense,
      segmentedDenseInset: KlpControlMetrics.segmentedDenseInset,
      segmentedDenseItemHeight: KlpSize.segmentedDenseItem,
      scrollbarThickness: KlpControlMetrics.scrollbarThickness,
      sliderTrackHeight: 4,
      textFieldIndicatorHeightFactor: 0.4,
      textFieldLineHeightFactor: 1.3,
      textFieldMinLines: 4,
      textFieldMaxLines: 8,
      fileExplorerRowHeightAdjustment: 2,
    ),
    data: KlpDataGeometry(
      codeActionButtonSize: KlpCodeMetrics.actionButtonSize,
      codeHeaderHeight: KlpCodeMetrics.headerHeight,
      codeTerminalDot: KlpCodeMetrics.terminalDot,
      codeTerminalDotGap: KlpCodeMetrics.terminalDotGap,
      codeHeaderPaddingX: KlpCodeMetrics.headerPaddingHorizontal,
      codeBodyPaddingX: KlpCodeMetrics.bodyPaddingHorizontal,
      codeLineNumberWidth: KlpCodeMetrics.lineNumberWidth,
      codeWrappedLineWidth: KlpCodeMetrics.wrappedLineWidth,
      codeMaximumHeight: KlpCodeMetrics.defaultMaximumHeight,
      codeCollapsedHeight: KlpPlaceholderMetrics.minimumHeight,
      codeDisclosureSize: KlpSize.disclosure,
      placeholderMinimumHeight: KlpPlaceholderMetrics.minimumHeight,
      placeholderContentPaddingY: KlpPlaceholderMetrics.contentPaddingVertical,
      placeholderActionPaddingY: KlpPlaceholderMetrics.actionPaddingVertical,
      placeholderHatchBand: KlpPlaceholderMetrics.hatchBand,
      placeholderHatchGap: KlpPlaceholderMetrics.hatchGap,
      placeholderLabelTracking: KlpPlaceholderMetrics.labelLetterSpacing,
      placeholderDetailMaximumWidth: KlpPlaceholderMetrics.detailMaximumWidth,
      spinnerSquareFactor: 0.32,
      spinnerOrbitFactor: 0.22,
      spinnerCornerFactor: 0.06,
    ),
    layout: KlpLayoutGeometry(
      primaryPaneWidth: KlpSize.sidebar,
      secondaryPaneWidth: KlpSize.inspector,
      primaryPaneBreakpoint: KlpSize.primaryPaneBreakpoint,
      primaryPaneContentBreakpoint: KlpSize.primaryPaneContentBreakpoint,
      secondaryPaneBreakpoint: KlpSize.secondaryPaneBreakpoint,
      workbenchCompactSpacing: KlpScale.space200,
      menuWidth: KlpSize.menu,
      menuHeaderHeight: KlpSize.menuHeader,
      menuItemHeight: KlpSize.menuItem,
      dialogMaximumWidth: 520,
      toastMaximumWidth: 360,
      inlineNoticeBreakpoint: 480,
      statusBarBreakpoint: 400,
      settingsContentMaximumWidth: 820,
      themePreviewTileWidth: 168,
      windowToolbarHeight: KlpSize.windowToolbar,
      windowControlButtonSize: KlpSize.windowControlButton,
      windowToolbarPaddingStart: KlpScale.space250,
      windowToolbarPaddingEnd: KlpScale.space250,
      windowToolbarPaddingVertical:
          (KlpSize.windowToolbar - KlpSize.windowControlButton) / 2,
      windowAppIconSize: 18,
      windowIdentityGap: KlpScale.space200,
    ),
    optical: KlpOpticalGeometry(
      menuIconOffsetY: 1,
      railBadgeInset: 2,
      statusIconOffsetY: 1,
      monoBaselineOffsetY: -1,
      uiBaselineOffsetY: KlpTypography.uiBaselineOffset,
    ),
  );

  @override
  KlpGeometryTheme copyWith({
    KlpControlGeometry? control,
    KlpDataGeometry? data,
    KlpLayoutGeometry? layout,
    KlpOpticalGeometry? optical,
  }) => KlpGeometryTheme(
    control: control ?? this.control,
    data: data ?? this.data,
    layout: layout ?? this.layout,
    optical: optical ?? this.optical,
  );

  @override
  KlpGeometryTheme lerp(covariant KlpGeometryTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpGeometryTheme &&
          control == other.control &&
          data == other.data &&
          layout == other.layout &&
          optical == other.optical;

  @override
  int get hashCode => Object.hash(control, data, layout, optical);
}
