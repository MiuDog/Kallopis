part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀 Explorer 呈現紀錄，攜帶階層資料、事件回呼及已解析樣式。
/// 不屬使用端 API，不擁有產品階層、選取或移動權威。
final class KlpBoundExplorer extends KlpBoundTemplate {
	final List<KlpBoundExplorerItemData> items;
	final bool allowNesting;
	final bool showCommandButtons;
	final String actionsLabel, expandLabel, collapseLabel;
	final int spacing;
	final void Function(KlpPlacementId)? onSelected;
	final void Function(KlpPlacementId, bool)? onExpandedChanged;
	final void Function(Set<KlpPlacementId>)? onSelectionChanged;
	final bool Function(Set<KlpId>, KlpPlacementId, int)? canMove;
	final void Function(Set<KlpId>, KlpPlacementId, int)? onMove;
	final KlpColor background;
	final KlpColor foreground;
	final KlpColor selectedBackground;
	final KlpColor mutedForeground;
	final KlpColor focusColor;
	final KlpDistance rowExtent;
	/// 分類與圖示依既有語意節奏縮減，消費端不提供原始尺寸。
	double get categoryExtent => rowExtent.value - inset.value;
	double get categoryFontSize => textStyle.fontSize.value - gap.value / 2;
	double get itemIconExtent => indent.value - gap.value / 2;
	final KlpDistance gap;
	final KlpDistance indent;
	final KlpDistance inset;
	final KlpRadius radius;
	final KlpStrokeWidth focusWidth;
	final KlpBoundTextStyle textStyle;
	const KlpBoundExplorer({required this.items, this.allowNesting = true, this.showCommandButtons = true, this.actionsLabel = 'Actions', this.expandLabel = 'Expand', this.collapseLabel = 'Collapse', this.spacing = 2, required this.onSelected, required this.onExpandedChanged, this.onSelectionChanged, this.canMove, this.onMove, required this.background, required this.foreground, required this.selectedBackground, required this.mutedForeground, required this.focusColor, required this.rowExtent, required this.gap, required this.indent, required this.inset, required this.radius, required this.focusWidth, required this.textStyle});
}
