part of '../klp_dock_panel.dart';

/// 可停駐布局中的產品中立面板描述；內容與可放置方向由呼叫端提供。
@immutable
class KlpDockPanel {
  final String id;
  final Widget? header;
  final Widget content;
  final ScrollController? contentScrollController;
  final bool isDraggable;

  /// 是否允許放入 Stage 下方的 Bottom Area。
  final bool allowBottom;

  /// 是否允許放入 Stage 左右兩側的 Area。
  final bool allowSide;

  /// Active panel 顯示於 Dock Header 右側的產品動作。
  final List<KlpDockHeaderAction> actions;

  const KlpDockPanel({
    required this.id,
    this.header,
    required this.content,
    this.contentScrollController,
    bool isDraggable = true,
    this.allowBottom = true,
    this.allowSide = true,
    this.actions = const [],
  }) : isDraggable = header != null && isDraggable;
}
