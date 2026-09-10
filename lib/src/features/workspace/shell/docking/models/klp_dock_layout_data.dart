part of '../klp_dock_layout_models.dart';

/// 描述固定 Stage 周圍三個可停駐區域的受控布局狀態。
@immutable
class KlpDockLayoutData {
	final KlpDockAreaData left;
	final KlpDockAreaData right;
	final KlpDockAreaData bottom;

	const KlpDockLayoutData({
		required this.left,
		required this.right,
		required this.bottom,
	});

	KlpDockLayoutData copyWith({
		KlpDockAreaData? left,
		KlpDockAreaData? right,
		KlpDockAreaData? bottom,
	}) {
		return KlpDockLayoutData(
			left: left ?? this.left,
			right: right ?? this.right,
			bottom: bottom ?? this.bottom,
		);
	}
}
