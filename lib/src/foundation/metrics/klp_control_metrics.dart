part of '../klp_metrics.dart';

/// 分段控制項、滑動選擇與捲軸固定幾何。
abstract final class KlpControlMetrics {
	static const double segmentedDenseInset = 3;
	static const double segmentedDenseContentInset = 0;
	static const double slidingSelectionHeight = 36;
	static const double slidingSelectionSegmentWidth = 41.4;
	static const double slidingSelectionPadding = 2;
	static const double slidingSelectionIndicatorHeight = 30;
	static const double scrollbarThickness = 5;
	static const double scrollbarEndControlExtent = 14;
	static const double scrollbarEndControlRightInset = (scrollbarThickness - scrollbarEndControlExtent) / 2;
	static const double scrollbarPageIncrement = 0.8;
}
