part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀選項呈現資料，攜帶標籤、選取輸入與回呼；不屬使用端 API，也不管理選取狀態。
final class KlpBoundWorkspaceChoice {
	final String label;
	final bool selected;
	final void Function()? onSelected;
	const KlpBoundWorkspaceChoice({required this.label, required this.selected, this.onSelected});
}
