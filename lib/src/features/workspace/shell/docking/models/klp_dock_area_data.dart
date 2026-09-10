part of '../klp_dock_layout_models.dart';

/// 描述單一可停駐區域的方向、群組、可見性與像素尺寸。
@immutable
class KlpDockAreaData {
	/// Area 內部 group 的排列方向。
	final Axis axis;
	final List<KlpDockGroupData> groups;
	final bool isVisible;

	/// 左右 Area 代表寬度，Bottom Area 代表高度。
	final double extent;

	const KlpDockAreaData({
		required this.axis,
		required this.groups,
		required this.extent,
		this.isVisible = true,
	}) : assert(extent >= 0);

	KlpDockAreaData copyWith({
		Axis? axis,
		List<KlpDockGroupData>? groups,
		bool? isVisible,
		double? extent,
	}) {
		return KlpDockAreaData(
			axis: axis ?? this.axis,
			groups: groups ?? this.groups,
			extent: extent ?? this.extent,
			isVisible: isVisible ?? this.isVisible,
		);
	}
}
