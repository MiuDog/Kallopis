import 'package:flutter/foundation.dart';

/// 程式碼、placeholder 與資料型元件的精確幾何。
@immutable
class KlpDataGeometry {
  const KlpDataGeometry({
    required this.codeActionButtonSize,
    required this.codeHeaderHeight,
    required this.codeTerminalDot,
    required this.codeTerminalDotGap,
    required this.codeHeaderPaddingX,
    required this.codeBodyPaddingX,
    required this.codeLineNumberWidth,
    required this.codeWrappedLineWidth,
    required this.codeMaximumHeight,
    required this.codeCollapsedHeight,
    required this.codeDisclosureSize,
    required this.filePreviewHeight,
    required this.previewCardCompactHeight,
    required this.previewCardStandardHeight,
    required this.previewCardLargeHeight,
    required this.dateGridCellHeight,
    required this.keyValueLabelWidthCompact,
    required this.keyValueLabelWidthStandard,
    required this.stepperMarkerSize,
    required this.stepperLabelWidth,
    required this.progressIndeterminateFraction,
    required this.placeholderMinimumHeight,
    required this.placeholderContentPaddingY,
    required this.placeholderActionPaddingY,
    required this.placeholderHatchBand,
    required this.placeholderHatchGap,
    required this.placeholderLabelTracking,
    required this.placeholderDetailMaximumWidth,
    required this.spinnerSquareFactor,
    required this.spinnerOrbitFactor,
    required this.spinnerCornerFactor,
  });

  final double codeActionButtonSize;
  final double codeHeaderHeight;
  final double codeTerminalDot;
  final double codeTerminalDotGap;
  final double codeHeaderPaddingX;
  final double codeBodyPaddingX;
  final double codeLineNumberWidth;
  final double codeWrappedLineWidth;
  final double codeMaximumHeight;
  final double codeCollapsedHeight;
  final double codeDisclosureSize;
  final double filePreviewHeight;
  final double previewCardCompactHeight;
  final double previewCardStandardHeight;
  final double previewCardLargeHeight;
  final double dateGridCellHeight;
  final double keyValueLabelWidthCompact;
  final double keyValueLabelWidthStandard;
  final double stepperMarkerSize;
  final double stepperLabelWidth;
  final double progressIndeterminateFraction;
  final double placeholderMinimumHeight;
  final double placeholderContentPaddingY;
  final double placeholderActionPaddingY;
  final double placeholderHatchBand;
  final double placeholderHatchGap;
  final double placeholderLabelTracking;
  final double placeholderDetailMaximumWidth;
  final double spinnerSquareFactor;
  final double spinnerOrbitFactor;
  final double spinnerCornerFactor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpDataGeometry &&
          codeActionButtonSize == other.codeActionButtonSize &&
          codeHeaderHeight == other.codeHeaderHeight &&
          codeTerminalDot == other.codeTerminalDot &&
          codeTerminalDotGap == other.codeTerminalDotGap &&
          codeHeaderPaddingX == other.codeHeaderPaddingX &&
          codeBodyPaddingX == other.codeBodyPaddingX &&
          codeLineNumberWidth == other.codeLineNumberWidth &&
          codeWrappedLineWidth == other.codeWrappedLineWidth &&
          codeMaximumHeight == other.codeMaximumHeight &&
          codeCollapsedHeight == other.codeCollapsedHeight &&
          codeDisclosureSize == other.codeDisclosureSize &&
          filePreviewHeight == other.filePreviewHeight &&
          previewCardCompactHeight == other.previewCardCompactHeight &&
          previewCardStandardHeight == other.previewCardStandardHeight &&
          previewCardLargeHeight == other.previewCardLargeHeight &&
          dateGridCellHeight == other.dateGridCellHeight &&
          keyValueLabelWidthCompact == other.keyValueLabelWidthCompact &&
          keyValueLabelWidthStandard == other.keyValueLabelWidthStandard &&
          stepperMarkerSize == other.stepperMarkerSize &&
          stepperLabelWidth == other.stepperLabelWidth &&
          progressIndeterminateFraction ==
              other.progressIndeterminateFraction &&
          placeholderMinimumHeight == other.placeholderMinimumHeight &&
          placeholderContentPaddingY == other.placeholderContentPaddingY &&
          placeholderActionPaddingY == other.placeholderActionPaddingY &&
          placeholderHatchBand == other.placeholderHatchBand &&
          placeholderHatchGap == other.placeholderHatchGap &&
          placeholderLabelTracking == other.placeholderLabelTracking &&
          placeholderDetailMaximumWidth ==
              other.placeholderDetailMaximumWidth &&
          spinnerSquareFactor == other.spinnerSquareFactor &&
          spinnerOrbitFactor == other.spinnerOrbitFactor &&
          spinnerCornerFactor == other.spinnerCornerFactor;

  @override
  int get hashCode => Object.hashAll(<Object>[
    codeActionButtonSize,
    codeHeaderHeight,
    codeTerminalDot,
    codeTerminalDotGap,
    codeHeaderPaddingX,
    codeBodyPaddingX,
    codeLineNumberWidth,
    codeWrappedLineWidth,
    codeMaximumHeight,
    codeCollapsedHeight,
    codeDisclosureSize,
    filePreviewHeight,
    previewCardCompactHeight,
    previewCardStandardHeight,
    previewCardLargeHeight,
    dateGridCellHeight,
    keyValueLabelWidthCompact,
    keyValueLabelWidthStandard,
    stepperMarkerSize,
    stepperLabelWidth,
    progressIndeterminateFraction,
    placeholderMinimumHeight,
    placeholderContentPaddingY,
    placeholderActionPaddingY,
    placeholderHatchBand,
    placeholderHatchGap,
    placeholderLabelTracking,
    placeholderDetailMaximumWidth,
    spinnerSquareFactor,
    spinnerOrbitFactor,
    spinnerCornerFactor,
  ]);
}
