part of '../klp_dock_layout_models.dart';

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
