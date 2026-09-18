part of '../klp_explorer_snapshot.dart';

/// 捕捉中的暫存只存在於本次呼叫，成功後轉成不可變紀錄。
final class _ItemCapture {

	final KlpId id;
	final KlpExplorerRole role;
	final bool canHaveChildren;
	final KlpExplorerRowData row;
	final KlpExplorerCapabilities capabilities;
	final KlpId? parentId;
	final KlpId treeId;
	final List<KlpId> childIds = [];

	_ItemCapture({required this.id, required this.role, required this.canHaveChildren, required this.row, required this.capabilities, required this.parentId, required this.treeId});

	KlpExplorerItemSnapshot freeze() => KlpExplorerItemSnapshot._(
		id: id,
		role: role,
		canHaveChildren: canHaveChildren,
		row: row,
		capabilities: capabilities,
		parentId: parentId,
		treeId: treeId,
		childIds: childIds,
	);
}

/// 顯式進出堆疊可辨識物件循環，且不以遞迴呼叫深度限制產品階層。
final class _ItemVisit {

	final KlpExplorerItemModel source;
	final _ItemCapture? parent;
	final bool exiting;

	const _ItemVisit(this.source, this.parent, {this.exiting = false});
}

KlpExplorerSnapshot _captureExplorer(List<KlpExplorerTreeData> treeInput, List<KlpExplorerSelectionScope> scopeInput) {
	// 步驟 1：固定本次森林範圍，預留樹的出現身分以偵測跨層重複。
	final declarations = List<KlpExplorerTreeData>.of(treeInput);
	final scopes = List<KlpExplorerSelectionScope>.of(scopeInput);
	final usedIds = <KlpId>{};
	final captured = <KlpId, _ItemCapture>{};
	final roots = <KlpId, List<KlpId>>{};
	for (final tree in declarations) {
		if (!usedIds.add(tree.id)) {
			throw KlpContractError('explorer_duplicate_id', '樹出現身分重複：${tree.id}。');
		}

		roots[tree.id] = [];
	}

	// 步驟 2：每個合法出現的 interface 欄位只讀一次；不保留外部可變物件。
	for (final tree in declarations) {
		final active = HashSet<KlpExplorerItemModel>.identity();
		final stack = tree.items.reversed.map((item) => _ItemVisit(item, null)).toList();
		while (stack.isNotEmpty) {
			final visit = stack.removeLast();
			final source = visit.source;
			if (visit.exiting) {
				active.remove(source);
				continue;
			}

			if (!active.add(source)) {
				throw const KlpContractError('explorer_cycle', 'Explorer children 包含物件循環。');
			}

			final id = source.id;
			if (!usedIds.add(id)) {
				throw KlpContractError('explorer_duplicate_id', '項目出現身分重複：$id。');
			}

			final role = source.role;
			final canHaveChildren = source.canHaveChildren;
			final row = source.row;
			final capabilities = source.capabilities;
			final children = List<KlpExplorerItemModel>.of(source.children);
			if (role == KlpExplorerRole.category && visit.parent != null) {
				throw KlpContractError('explorer_invalid_role', '分類只能出現在樹根：$id。');
			}

			if (!canHaveChildren && children.isNotEmpty) {
				throw KlpContractError('explorer_children_not_allowed', '此節點類型不承載子項：$id。');
			}

			if (capabilities.primaryAction == KlpExplorerPrimaryAction.toggleExpansion && !capabilities.collapsible) {
				throw KlpContractError('explorer_invalid_primary_action', '切換展開需要收合能力：$id。');
			}

			if (row.title.trim().isEmpty) {
				throw KlpContractError('explorer_invalid_title', 'Explorer 主標題不得為空：$id。');
			}

			final item = _ItemCapture(
				id: id,
				role: role,
				canHaveChildren: canHaveChildren,
				row: row,
				capabilities: capabilities,
				parentId: visit.parent?.id,
				treeId: tree.id,
			);
			captured[id] = item;
			(visit.parent?.childIds ?? roots[tree.id]!).add(id);
			stack.add(_ItemVisit(source, visit.parent, exiting: true));
			for (final child in children.reversed) {
				stack.add(_ItemVisit(child, item));
			}
		}
	}

	// 步驟 3：完整結構存在後驗證展開，避免逐列修補造成半份有效輸入。
	final items = {for (final entry in captured.entries) entry.key: entry.value.freeze()};
	final trees = <KlpId, KlpExplorerTreeSnapshot>{};
	for (final tree in declarations) {
		for (final id in tree.expandedIds) {
			final item = items[id];
			if (item == null || item.treeId != tree.id || !item.canToggleExpansion) {
				throw KlpContractError('explorer_invalid_expansion', '展開狀態不符合目前完整樹：$id。');
			}
		}

		final visible = <KlpId>[];
		final stack = roots[tree.id]!.reversed.toList();
		while (stack.isNotEmpty) {
			final id = stack.removeLast();
			final item = items[id]!;
			visible.add(id);
			if (!item.capabilities.collapsible || tree.expandedIds.contains(id)) {
				stack.addAll(item.childIds.reversed);
			}
		}

		trees[tree.id] = KlpExplorerTreeSnapshot._(
			id: tree.id,
			rootIds: roots[tree.id]!,
			expandedIds: tree.expandedIds,
			visibleIds: visible,
		);
	}

	// 步驟 4：驗證選取範圍是樹的完整分割，再驗證每個受控選取。
	final selectionScopes = <KlpId, KlpExplorerSelectionScope>{};
	final scopeByTree = <KlpId, KlpId>{};
	for (final scope in scopes) {
		if (selectionScopes.containsKey(scope.id) || scope.treeIds.isEmpty) {
			throw KlpContractError('explorer_invalid_scope', '選取範圍重複或沒有成員：${scope.id}。');
		}

		selectionScopes[scope.id] = scope;
		for (final treeId in scope.treeIds) {
			if (!trees.containsKey(treeId) || scopeByTree.containsKey(treeId)) {
				throw KlpContractError('explorer_invalid_scope', '樹不存在或重複加入選取範圍：$treeId。');
			}

			scopeByTree[treeId] = scope.id;
		}

		if (scope.mode == KlpExplorerSelectionMode.none && scope.selectedIds.isNotEmpty || scope.mode == KlpExplorerSelectionMode.single && scope.selectedIds.length > 1) {
			throw KlpContractError('explorer_invalid_selection', '選取數量不符合範圍模式：${scope.id}。');
		}

		for (final id in {...scope.selectedIds, ?scope.anchorId}) {
			final item = items[id];
			if (item == null || !item.capabilities.selectable || scopeByTree[item.treeId] != scope.id) {
				throw KlpContractError('explorer_invalid_selection', '選取項目不存在、不可選取或不屬於此範圍：$id。');
			}
		}
	}

	if (scopeByTree.length != trees.length) {
		throw const KlpContractError('explorer_invalid_scope', '每棵 Explorer 樹必須恰屬一個明確選取範圍。');
	}

	return KlpExplorerSnapshot._(items: items, trees: trees, selectionScopes: selectionScopes, scopeByTree: scopeByTree);
}
