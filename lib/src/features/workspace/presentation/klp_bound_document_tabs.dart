part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀頁籤呈現紀錄，攜帶頁籤、事件回呼及已解析樣式。
/// 不屬使用端 API，不擁有文件選取、關閉或釘選狀態。
final class KlpBoundDocumentTabs extends KlpBoundTemplate {
	final List<KlpBoundDocumentTabData> tabs;
	final void Function(KlpPlacementId)? onSelected;
	final void Function(KlpPlacementId)? onClose;
	final void Function(KlpPlacementId, bool)? onPinnedChanged;
	final KlpColor background;
	final KlpColor foreground;
	final KlpColor selectedBackground;
	final KlpColor mutedForeground;
	final KlpColor focusColor;
	final KlpDistance extent;
	final KlpDistance inset;
	final KlpDistance gap;
	final KlpRadius radius;
	final KlpStrokeWidth focusWidth;
	final KlpBoundTextStyle textStyle;
	const KlpBoundDocumentTabs({required this.tabs, required this.onSelected, required this.onClose, required this.onPinnedChanged, required this.background, required this.foreground, required this.selectedBackground, required this.mutedForeground, required this.focusColor, required this.extent, required this.inset, required this.gap, required this.radius, required this.focusWidth, required this.textStyle});
}
