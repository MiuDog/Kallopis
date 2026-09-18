part of 'klp_workspace_presentation.dart';

/// 已驗證資料、語意樣式與有效影格事件，不保留產品種類分支。
final class KlpBoundExplorer extends KlpBoundTemplate {

	final KlpId treeId;
	final KlpExplorerSnapshot snapshot;
	final void Function(KlpExplorerIntent)? onIntent;
	final KlpExplorerController? controller;
	final bool Function() isActive;
	final KlpColor surface, foreground, mutedForeground, selectedBackground, focusColor;
	final KlpDistance nodeExtent, categoryExtent, iconExtent, disclosureIconExtent, indent, inset, gap, disclosureExtent, actionExtent;
	final KlpFontSize categoryFontSize;
	final KlpRadius radius;
	final KlpStrokeWidth focusWidth;
	final KlpBoundTextStyle textStyle;

	const KlpBoundExplorer({required this.treeId, required this.snapshot, required this.onIntent, required this.controller, required this.isActive, required this.surface, required this.foreground, required this.mutedForeground, required this.selectedBackground, required this.focusColor, required this.nodeExtent, required this.categoryExtent, required this.iconExtent, required this.disclosureIconExtent, required this.categoryFontSize, required this.indent, required this.inset, required this.gap, required this.disclosureExtent, required this.actionExtent, required this.radius, required this.focusWidth, required this.textStyle});

	KlpExplorerTreeSnapshot get tree => snapshot.trees[treeId]!;
	KlpExplorerSelectionScope get selection => snapshot.selectionScopes[snapshot.scopeByTree[treeId]]!;
	bool permitsDrop(KlpExplorerDropRequest request) => snapshot.permitsDrop(request);
	Set<KlpId> expandedIdsAfter(KlpId id, bool expanded) {
		final item = snapshot.items[id]!;
		final next = Set<KlpId>.of(snapshot.trees[item.treeId]!.expandedIds);
		if (expanded) {
			next.add(id);
		}
		else {
			next.remove(id);
		}
		return Set.unmodifiable(next);
	}
}
