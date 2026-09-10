import 'package:flutter/foundation.dart';

import '../legacy_tokens/primitive_token.dart';

/// 表單與互動控制項的精確幾何。
@immutable
class KlpControlGeometry {
	const KlpControlGeometry({
		this.switchTrackWidth = 36,
		this.switchTrackHeight = 20,
		this.switchThumb = 16,

		this.pageBackgroundHitRadius = KlpScale.space200,
		this.presenceMarkerExtent = KlpScale.space200,
		this.colorPickerCursorRadius = KlpScale.space200,
		this.swatchExtent = KlpScale.space200,
		this.segmentedProgressHeight = KlpScale.space200,

		required this.buttonHeightXSmall,
		required this.buttonHeightSmall,
		required this.buttonHeight,
		required this.buttonHeightLarge,
		required this.buttonHeightXLarge,
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
		required this.segmentedDenseContentInset,
		required this.segmentedDenseItemHeight,
		required this.slidingSelectionHeight,
		required this.slidingSelectionSegmentWidth,
		required this.slidingSelectionPadding,
		required this.slidingSelectionIndicatorHeight,
		required this.scrollbarThickness,
		required this.sliderTrackHeight,
		required this.colorPlaneExtent,
		required this.textFieldIndicatorHeightFactor,
		required this.textFieldLineHeightFactor,
		required this.textFieldMinLines,
		required this.textFieldMaxLines,
		required this.fileExplorerRowHeightAdjustment,
	});

	final double switchTrackWidth;
	final double switchTrackHeight;
	final double switchThumb;
	final double buttonHeightXSmall;
	final double buttonHeightSmall;
	final double buttonHeight;
	final double buttonHeightLarge;
	final double buttonHeightXLarge;
	final double pageBackgroundHitRadius;
	final double presenceMarkerExtent;
	final double colorPickerCursorRadius;
	final double swatchExtent;
	final double segmentedProgressHeight;
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
	final double segmentedDenseContentInset;
	final double segmentedDenseItemHeight;
	final double slidingSelectionHeight;
	final double slidingSelectionSegmentWidth;
	final double slidingSelectionPadding;
	final double slidingSelectionIndicatorHeight;
	final double scrollbarThickness;
	final double sliderTrackHeight;
	final double colorPlaneExtent;
	final double textFieldIndicatorHeightFactor;
	final double textFieldLineHeightFactor;
	final int textFieldMinLines;
	final int textFieldMaxLines;
	final double fileExplorerRowHeightAdjustment;

	KlpControlGeometry copyWith({
		double? switchTrackWidth,
		double? switchTrackHeight,
		double? switchThumb,

		double? pageBackgroundHitRadius,
		double? presenceMarkerExtent,
		double? colorPickerCursorRadius,
		double? swatchExtent,
		double? segmentedProgressHeight,

		double? buttonHeightXSmall,
		double? buttonHeightSmall,
		double? buttonHeight,
		double? buttonHeightLarge,
		double? buttonHeightXLarge,
		double? fieldHeight,
		double? selectionControl,
		double? selectionIndicatorInset,
		double? selectionIcon,
		double? toggleWidth,
		double? toggleHeight,
		double? toggleThumb,
		double? toggleInset,
		double? segmentedDenseHeight,
		double? segmentedDenseInset,
		double? segmentedDenseContentInset,
		double? segmentedDenseItemHeight,
		double? slidingSelectionHeight,
		double? slidingSelectionSegmentWidth,
		double? slidingSelectionPadding,
		double? slidingSelectionIndicatorHeight,
		double? scrollbarThickness,
		double? sliderTrackHeight,
		double? colorPlaneExtent,
		double? textFieldIndicatorHeightFactor,
		double? textFieldLineHeightFactor,
		int? textFieldMinLines,
		int? textFieldMaxLines,
		double? fileExplorerRowHeightAdjustment,
	}) => KlpControlGeometry(
		switchTrackWidth: switchTrackWidth ?? this.switchTrackWidth,
		switchTrackHeight: switchTrackHeight ?? this.switchTrackHeight,
		switchThumb: switchThumb ?? this.switchThumb,

		pageBackgroundHitRadius: pageBackgroundHitRadius ?? this.pageBackgroundHitRadius,
		presenceMarkerExtent: presenceMarkerExtent ?? this.presenceMarkerExtent,
		colorPickerCursorRadius: colorPickerCursorRadius ?? this.colorPickerCursorRadius,
		swatchExtent: swatchExtent ?? this.swatchExtent,
		segmentedProgressHeight: segmentedProgressHeight ?? this.segmentedProgressHeight,

		buttonHeightXSmall: buttonHeightXSmall ?? this.buttonHeightXSmall,
		buttonHeightSmall: buttonHeightSmall ?? this.buttonHeightSmall,
		buttonHeight: buttonHeight ?? this.buttonHeight,
		buttonHeightLarge: buttonHeightLarge ?? this.buttonHeightLarge,
		buttonHeightXLarge: buttonHeightXLarge ?? this.buttonHeightXLarge,
		fieldHeight: fieldHeight ?? this.fieldHeight,
		selectionControl: selectionControl ?? this.selectionControl,
		selectionIndicatorInset: selectionIndicatorInset ?? this.selectionIndicatorInset,
		selectionIcon: selectionIcon ?? this.selectionIcon,
		toggleWidth: toggleWidth ?? this.toggleWidth,
		toggleHeight: toggleHeight ?? this.toggleHeight,
		toggleThumb: toggleThumb ?? this.toggleThumb,
		toggleInset: toggleInset ?? this.toggleInset,
		segmentedDenseHeight: segmentedDenseHeight ?? this.segmentedDenseHeight,
		segmentedDenseInset: segmentedDenseInset ?? this.segmentedDenseInset,
		segmentedDenseContentInset: segmentedDenseContentInset ?? this.segmentedDenseContentInset,
		segmentedDenseItemHeight: segmentedDenseItemHeight ?? this.segmentedDenseItemHeight,
		slidingSelectionHeight: slidingSelectionHeight ?? this.slidingSelectionHeight,
		slidingSelectionSegmentWidth: slidingSelectionSegmentWidth ?? this.slidingSelectionSegmentWidth,
		slidingSelectionPadding: slidingSelectionPadding ?? this.slidingSelectionPadding,
		slidingSelectionIndicatorHeight: slidingSelectionIndicatorHeight ?? this.slidingSelectionIndicatorHeight,
		scrollbarThickness: scrollbarThickness ?? this.scrollbarThickness,
		sliderTrackHeight: sliderTrackHeight ?? this.sliderTrackHeight,
		colorPlaneExtent: colorPlaneExtent ?? this.colorPlaneExtent,
		textFieldIndicatorHeightFactor: textFieldIndicatorHeightFactor ?? this.textFieldIndicatorHeightFactor,
		textFieldLineHeightFactor: textFieldLineHeightFactor ?? this.textFieldLineHeightFactor,
		textFieldMinLines: textFieldMinLines ?? this.textFieldMinLines,
		textFieldMaxLines: textFieldMaxLines ?? this.textFieldMaxLines,
		fileExplorerRowHeightAdjustment: fileExplorerRowHeightAdjustment ?? this.fileExplorerRowHeightAdjustment,
	);

	@override
	bool operator ==(Object other) =>
			identical(this, other) ||
			other is KlpControlGeometry &&
					switchTrackWidth == other.switchTrackWidth &&
					switchTrackHeight == other.switchTrackHeight &&
					switchThumb == other.switchThumb &&
					pageBackgroundHitRadius == other.pageBackgroundHitRadius &&
					presenceMarkerExtent == other.presenceMarkerExtent &&
					colorPickerCursorRadius == other.colorPickerCursorRadius &&
					swatchExtent == other.swatchExtent &&
					segmentedProgressHeight == other.segmentedProgressHeight &&
					buttonHeightXSmall == other.buttonHeightXSmall &&
					buttonHeightSmall == other.buttonHeightSmall &&
					buttonHeight == other.buttonHeight &&
					buttonHeightLarge == other.buttonHeightLarge &&
					buttonHeightXLarge == other.buttonHeightXLarge &&
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
					segmentedDenseContentInset == other.segmentedDenseContentInset &&
					segmentedDenseItemHeight == other.segmentedDenseItemHeight &&
					slidingSelectionHeight == other.slidingSelectionHeight &&
					slidingSelectionSegmentWidth == other.slidingSelectionSegmentWidth &&
					slidingSelectionPadding == other.slidingSelectionPadding &&
					slidingSelectionIndicatorHeight == other.slidingSelectionIndicatorHeight &&
					scrollbarThickness == other.scrollbarThickness &&
					sliderTrackHeight == other.sliderTrackHeight &&
					colorPlaneExtent == other.colorPlaneExtent &&
					textFieldIndicatorHeightFactor == other.textFieldIndicatorHeightFactor &&
					textFieldLineHeightFactor == other.textFieldLineHeightFactor &&
					textFieldMinLines == other.textFieldMinLines &&
					textFieldMaxLines == other.textFieldMaxLines &&
					fileExplorerRowHeightAdjustment == other.fileExplorerRowHeightAdjustment;

	@override
	int get hashCode => Object.hashAll(<Object>[
		switchTrackWidth,
		switchTrackHeight,
		switchThumb,

		pageBackgroundHitRadius,
		presenceMarkerExtent,
		colorPickerCursorRadius,
		swatchExtent,
		segmentedProgressHeight,

		buttonHeightXSmall,
		buttonHeightSmall,
		buttonHeight,
		buttonHeightLarge,
		buttonHeightXLarge,
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
		segmentedDenseContentInset,
		segmentedDenseItemHeight,
		slidingSelectionHeight,
		slidingSelectionSegmentWidth,
		slidingSelectionPadding,
		slidingSelectionIndicatorHeight,
		scrollbarThickness,
		sliderTrackHeight,
		colorPlaneExtent,
		textFieldIndicatorHeightFactor,
		textFieldLineHeightFactor,
		textFieldMinLines,
		textFieldMaxLines,
		fileExplorerRowHeightAdjustment,
	]);
}
