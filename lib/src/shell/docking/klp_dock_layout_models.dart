import 'package:flutter/widgets.dart';

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

/// 描述同一可停駐區域內的一組分頁及目前顯示項目。
@immutable
class KlpDockGroupData {
  final String id;

  /// 群組內的分頁，由左到右排列。
  final List<String> panelIds;

  /// 目前顯示的 panel。
  final String activePanelId;

  /// Group 沿著 Area 排列方向的像素尺寸。
  final double mainAxisExtent;

  const KlpDockGroupData({
    required this.id,
    required this.panelIds,
    required this.activePanelId,
    required this.mainAxisExtent,
  }) : assert(mainAxisExtent > 0);

  KlpDockGroupData copyWith({
    String? id,
    List<String>? panelIds,
    String? activePanelId,
    double? mainAxisExtent,
  }) {
    return KlpDockGroupData(
      id: id ?? this.id,
      panelIds: panelIds ?? this.panelIds,
      activePanelId: activePanelId ?? this.activePanelId,
      mainAxisExtent: mainAxisExtent ?? this.mainAxisExtent,
    );
  }
}
