import 'package:flutter/foundation.dart';

/// 表單與互動控制項的精確幾何。
@immutable
class KlpControlGeometry {
  const KlpControlGeometry({
    required this.fieldHeight,
    required this.selectionControl,
    required this.selectionIndicatorInset,
    required this.selectionIcon,
    required this.toggleWidth,
    required this.toggleHeight,
    required this.toggleThumb,
    required this.toggleInset,
    required this.segmentedDenseHeight,
    required this.segmentedDenseInset,
    required this.segmentedDenseItemHeight,
    required this.scrollbarThickness,
    required this.sliderTrackHeight,
    required this.textFieldIndicatorHeightFactor,
    required this.textFieldLineHeightFactor,
    required this.textFieldMinLines,
    required this.textFieldMaxLines,
    required this.fileExplorerRowHeightAdjustment,
  });

  final double fieldHeight;
  final double selectionControl;
  final double selectionIndicatorInset;
  final double selectionIcon;
  final double toggleWidth;
  final double toggleHeight;
  final double toggleThumb;
  final double toggleInset;
  final double segmentedDenseHeight;
  final double segmentedDenseInset;
  final double segmentedDenseItemHeight;
  final double scrollbarThickness;
  final double sliderTrackHeight;
  final double textFieldIndicatorHeightFactor;
  final double textFieldLineHeightFactor;
  final int textFieldMinLines;
  final int textFieldMaxLines;
  final double fileExplorerRowHeightAdjustment;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpControlGeometry &&
          fieldHeight == other.fieldHeight &&
          selectionControl == other.selectionControl &&
          selectionIndicatorInset == other.selectionIndicatorInset &&
          selectionIcon == other.selectionIcon &&
          toggleWidth == other.toggleWidth &&
          toggleHeight == other.toggleHeight &&
          toggleThumb == other.toggleThumb &&
          toggleInset == other.toggleInset &&
          segmentedDenseHeight == other.segmentedDenseHeight &&
          segmentedDenseInset == other.segmentedDenseInset &&
          segmentedDenseItemHeight == other.segmentedDenseItemHeight &&
          scrollbarThickness == other.scrollbarThickness &&
          sliderTrackHeight == other.sliderTrackHeight &&
          textFieldIndicatorHeightFactor ==
              other.textFieldIndicatorHeightFactor &&
          textFieldLineHeightFactor == other.textFieldLineHeightFactor &&
          textFieldMinLines == other.textFieldMinLines &&
          textFieldMaxLines == other.textFieldMaxLines &&
          fileExplorerRowHeightAdjustment ==
              other.fileExplorerRowHeightAdjustment;

  @override
  int get hashCode => Object.hashAll(<Object>[
    fieldHeight,
    selectionControl,
    selectionIndicatorInset,
    selectionIcon,
    toggleWidth,
    toggleHeight,
    toggleThumb,
    toggleInset,
    segmentedDenseHeight,
    segmentedDenseInset,
    segmentedDenseItemHeight,
    scrollbarThickness,
    sliderTrackHeight,
    textFieldIndicatorHeightFactor,
    textFieldLineHeightFactor,
    textFieldMinLines,
    textFieldMaxLines,
    fileExplorerRowHeightAdjustment,
  ]);
}
