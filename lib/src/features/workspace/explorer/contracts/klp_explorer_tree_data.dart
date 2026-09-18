import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_explorer_item_model.dart';

enum KlpExplorerSelectionMode { none, single, multiple }

/// 一棵完整樹及其受控展開狀態；捕捉時一併驗證。
final class KlpExplorerTreeData {

	final KlpId id;
	final List<KlpExplorerItemModel> items;
	final Set<KlpId> expandedIds;

	KlpExplorerTreeData({required this.id, required List<KlpExplorerItemModel> items, Set<KlpId> expandedIds = const {}})
		: items = List.unmodifiable(items),
		expandedIds = Set.unmodifiable(expandedIds);
}

/// 每棵樹恰屬一個範圍；treeIds 順序定義跨樹的可見順序。
final class KlpExplorerSelectionScope {

	final KlpId id;
	final List<KlpId> treeIds;
	final KlpExplorerSelectionMode mode;
	final Set<KlpId> selectedIds;
	final KlpId? anchorId;

	KlpExplorerSelectionScope({required this.id, required List<KlpId> treeIds, required this.mode, Set<KlpId> selectedIds = const {}, this.anchorId})
		: treeIds = List.unmodifiable(treeIds),
		selectedIds = Set.unmodifiable(selectedIds);
}

/// 完整選取提案；consumer 同批更新集合與跨樹錨點。
final class KlpExplorerSelectionChange {

	final KlpId scopeId;
	final Set<KlpId> selectedIds;
	final KlpId? anchorId;

	KlpExplorerSelectionChange({required this.scopeId, required Set<KlpId> selectedIds, required this.anchorId}) : selectedIds = Set.unmodifiable(selectedIds);
}
