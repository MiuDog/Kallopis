part of '../klp_dock_layout.dart';

@immutable
class _KlpDockPanelDragData {
  const _KlpDockPanelDragData({
    required this.slot,
    required this.groupId,
    required this.panelId,
  });

  final _KlpDockAreaSlot slot;
  final String groupId;
  final String panelId;
}
