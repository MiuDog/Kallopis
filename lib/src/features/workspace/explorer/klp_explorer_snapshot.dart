import 'dart:collection';

import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_explorer_model.dart';

part 'internal/klp_explorer_capture.dart';

/// 已驗證的單一出現位置；不持有 consumer 的可變 item 實例。
final class KlpExplorerItemSnapshot {

	final KlpId id;
	final KlpExplorerRole role;
	final bool canHaveChildren;
	final KlpExplorerRowData row;
	final KlpExplorerCapabilities capabilities;
	final KlpId? parentId;
	final KlpId treeId;
	final List<KlpId> childIds;

	KlpExplorerItemSnapshot._({required this.id, required this.role, required this.canHaveChildren, required this.row, required this.capabilities, required this.parentId, required this.treeId, required List<KlpId> childIds})
		: childIds = List.unmodifiable(childIds);

	bool get hasChildren => childIds.isNotEmpty;
	bool get canToggleExpansion => capabilities.collapsible && (role == KlpExplorerRole.category || hasChildren);
}

/// 根順序、展開集合與可見順序均來自同一次完整驗證。
final class KlpExplorerTreeSnapshot {

	final KlpId id;
	final List<KlpId> rootIds;
	final Set<KlpId> expandedIds;
	final List<KlpId> visibleIds;

	KlpExplorerTreeSnapshot._({required this.id, required List<KlpId> rootIds, required Set<KlpId> expandedIds, required List<KlpId> visibleIds})
		: rootIds = List.unmodifiable(rootIds),
		expandedIds = Set.unmodifiable(expandedIds),
		visibleIds = List.unmodifiable(visibleIds);
}

/// 全量驗證邊界；失敗時不回傳局部樹，也不維護另一份已提交狀態。
final class KlpExplorerSnapshot {

	final Map<KlpId, KlpExplorerItemSnapshot> items;
	final Map<KlpId, KlpExplorerTreeSnapshot> trees;
	final Map<KlpId, KlpExplorerSelectionScope> selectionScopes;
	final Map<KlpId, KlpId> scopeByTree;
	final List<KlpExplorerDropAcceptance> acceptedDrops;

	KlpExplorerSnapshot._({required Map<KlpId, KlpExplorerItemSnapshot> items, required Map<KlpId, KlpExplorerTreeSnapshot> trees, required Map<KlpId, KlpExplorerSelectionScope> selectionScopes, required Map<KlpId, KlpId> scopeByTree, required List<KlpExplorerDropAcceptance> acceptedDrops})
		: items = Map.unmodifiable(items),
		trees = Map.unmodifiable(trees),
		selectionScopes = Map.unmodifiable(selectionScopes),
		scopeByTree = Map.unmodifiable(scopeByTree),
		acceptedDrops = List.unmodifiable(acceptedDrops);

	factory KlpExplorerSnapshot.capture({required List<KlpExplorerTreeData> trees, required List<KlpExplorerSelectionScope> selectionScopes, List<KlpExplorerDropAcceptance> acceptedDrops = const []}) {
		final snapshot = _captureExplorer(trees, selectionScopes, acceptedDrops);
		for (var index = 0; index < acceptedDrops.length; index++) {
			final acceptance = acceptedDrops[index];
			final request = KlpExplorerDropRequest(sourceIds: acceptance.sourceIds, targetId: acceptance.targetId, position: acceptance.position);
			if (!snapshot._structurallyPermitsDrop(request)) {
				throw KlpContractError('explorer_invalid_drop_acceptance', 'Explorer 放置許可不符合目前完整資料。');
			}
			if (acceptedDrops.take(index).any((existing) => existing.matches(request))) {
				throw KlpContractError('explorer_duplicate_drop_acceptance', 'Explorer 放置許可不得重複。');
			}
		}
		return snapshot;
	}

	List<KlpId> visibleIdsForScope(KlpId scopeId) {
		final scope = selectionScopes[scopeId];
		if (scope == null) {
			throw KlpContractError('explorer_invalid_scope', '未知選取範圍：$scopeId。');
		}

		return List.unmodifiable(scope.treeIds.expand((id) => trees[id]!.visibleIds));
	}

	List<KlpId> selectableIdsForScope(KlpId scopeId) => List.unmodifiable(visibleIdsForScope(scopeId).where((id) => items[id]!.capabilities.selectable));

	/// 預覽與提交均只讀取 capture 時固定的精確許可，不執行 consumer 邏輯。
	bool permitsDrop(KlpExplorerDropRequest request) => _structurallyPermitsDrop(request) && acceptedDrops.any((acceptance) => acceptance.matches(request));

	bool _structurallyPermitsDrop(KlpExplorerDropRequest request) {
		// 步驟 1：先確認必要的來源、目標及子項承載資格。
		if (request.sourceIds.isEmpty) return false;

		final target = items[request.targetId];
		if (target == null) return false;

		final inside = request.position == KlpExplorerDropPlacement.inside;
		if (inside && !target.canHaveChildren) return false;

		// 步驟 2：children 關係是唯一階層來源，不以 ID 的文字路徑判斷祖先。
		for (final id in request.sourceIds) {
			final source = items[id];
			if (source == null || !source.capabilities.draggable) return false;

			KlpId? ancestorId = target.id;
			while (ancestorId != null) {
				if (ancestorId == id) return false;

				ancestorId = items[ancestorId]!.parentId;
			}

			if (source.role == KlpExplorerRole.category) {
				if (inside || target.parentId != null || source.treeId != target.treeId) return false;
			}
		}

		return true;
	}
}
