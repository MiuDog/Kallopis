part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀 Explorer 項目資料，保留來源與放置身分、子項目及動作。
/// 不屬使用端 API，不自行變更階層、選取或展開狀態。
final class KlpBoundExplorerItemData {
	final KlpPlacementId id;
	final KlpId sourceId;
	final String label;
	final bool folder;
	final bool branch;
	final bool category;
	final bool collapsible;
	final bool selectable;
	final String? icon;
	final String? badge;
	final bool selected;
	final bool expanded;
	final List<KlpBoundExplorerItemData> children;
	final List<KlpBoundWorkspaceCommand> actions;
	const KlpBoundExplorerItemData({required this.id, required this.sourceId, required this.label, required this.folder, required this.branch, this.category = false, this.collapsible = true, required this.selectable, this.icon, this.badge, required this.selected, required this.expanded, required this.children, this.actions = const []});
}
