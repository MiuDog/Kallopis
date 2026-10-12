part of '../klp_dock_panel.dart';

/// 可停駐布局中的產品中立面板描述；內容與可放置方向由呼叫端提供。
@immutable
class KlpDockPanel {
	final String id;
	final Widget? header;
	final Widget content;
	final ScrollController? contentScrollController;
	final bool isDraggable;

	/// 產品投影的釘選與修改狀態，不改布局順序或保存格式。
	final bool isPinned;
	final bool isDirty;
	/// 產品批准後才從布局移出；正文與 registry 始終由產品保留。
	final FutureOr<bool> Function()? onCloseRequested;
	/// 可選的產品關閉文案，省略時使用本庫既有在地化。
	final String? closeLabel;

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
		this.isPinned = false,
		this.isDirty = false,
		this.onCloseRequested,
		this.closeLabel,
	}) : isDraggable = header != null && isDraggable;
}
