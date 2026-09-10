part of '../klp_dock_layout_models.dart';

/// 限制可停駐區域的最小與最大像素尺寸，不決定產品保存策略。
@immutable
class KlpDockAreaConstraints {
	final double minExtent;
	final double maxExtent;

	const KlpDockAreaConstraints({
		required this.minExtent,
		required this.maxExtent,
	}) : assert(minExtent > 0),
			 assert(maxExtent >= minExtent);

	double get closeThreshold => minExtent / 2;
}
