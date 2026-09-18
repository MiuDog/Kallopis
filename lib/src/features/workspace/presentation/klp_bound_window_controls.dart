part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀視窗控制呈現紀錄，攜帶最大化輸入、操作回呼及已解析樣式。
/// 不屬使用端 API，不擁有原生視窗狀態或執行平台操作。
final class KlpBoundWindowControls extends KlpBoundTemplate {
	final bool isMaximized;
	final void Function()? onMinimize;
	final void Function()? onToggleMaximize;
	final void Function()? onClose;
	final KlpColor background;
	final KlpColor foreground;
	final KlpColor closeHover;
	final KlpColor focusColor;
	final KlpDistance extent;
	final KlpDistance buttonExtent;
	final KlpDistance gap;
	final KlpRadius radius;
	final KlpStrokeWidth focusWidth;
	const KlpBoundWindowControls({required this.isMaximized, required this.onMinimize, required this.onToggleMaximize, required this.onClose, required this.background, required this.foreground, required this.closeHover, required this.focusColor, required this.extent, required this.buttonExtent, required this.gap, required this.radius, required this.focusWidth});
}
