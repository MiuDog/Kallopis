part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀項目呈現資料，攜帶文字、圖示、狀態輸入及事件回呼。
/// 不屬使用端 API，不自行管理勾選或選取狀態。
final class KlpBoundWorkspaceItem {
	final String title;
	final String? subtitle;
	final String? symbol;
	final int? icon;
	final bool? checked;
	final bool selected;
	final void Function()? onPressed;
	final void Function(bool)? onCheckedChanged;
	const KlpBoundWorkspaceItem({required this.title, this.subtitle, this.symbol, this.icon, this.checked, this.selected = false, this.onPressed, this.onCheckedChanged});
}
