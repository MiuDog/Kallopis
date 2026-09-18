import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'internal/klp_explorer_entry_node.dart';
import 'klp_explorer_model.dart';
import 'klp_explorer_snapshot.dart';

/// 同一森林的完整宣告；首次 capture 固定內容，更新須建立新宣告。
final class KlpExplorerData {

	final List<KlpExplorerTreeData> trees;
	final List<KlpExplorerSelectionScope> selectionScopes;
	final List<KlpExplorerDropAcceptance> acceptedDrops;
	late final KlpExplorerSnapshot snapshot = KlpExplorerSnapshot.capture(trees: trees, selectionScopes: selectionScopes, acceptedDrops: acceptedDrops);

	KlpExplorerData({required List<KlpExplorerTreeData> trees, required List<KlpExplorerSelectionScope> selectionScopes, List<KlpExplorerDropAcceptance> acceptedDrops = const []})
		: trees = List.unmodifiable(trees),
		selectionScopes = List.unmodifiable(selectionScopes),
		acceptedDrops = List.unmodifiable(acceptedDrops);

	/// 計算單樹的完整展開提案；是否提交及遞迴收合由 consumer 決定。
	Set<KlpId> expandedIdsAfter(KlpId id, bool expanded, {bool collapseDescendants = false}) {
		// 步驟 1：使用已驗證快照，所有切換入口共用同一資格。
		final item = snapshot.items[id];
		if (item == null || !item.canToggleExpansion) {
			throw KlpContractError('explorer_invalid_expansion', '項目不允許切換展開：$id。');
		}

		// 步驟 2：只建立所屬樹的提案，不改動已確認狀態。
		final next = Set<KlpId>.of(snapshot.trees[item.treeId]!.expandedIds);
		if (expanded) {
			next.add(id);
		}
		else {
			next.remove(id);
			if (collapseDescendants) {
				// 完整 children 包含不可見後代；不以可見列或 ID 字串推導階層。
				final pending = List<KlpId>.of(item.childIds);
				while (pending.isNotEmpty) {
					final descendant = snapshot.items[pending.removeLast()]!;
					next.remove(descendant.id);
					pending.addAll(descendant.childIds);
				}
			}
		}
		return Set.unmodifiable(next);
	}
}

/// 封閉的樹呈現入口；consumer 只提供資料及語意事件。
final class KlpExplorer implements KlpCompositeNode {

	static const typeId = 'kallopis.explorer';
	static final itemSlot = KlpSlot<KlpExplorerEntryNode>(owner: typeId, name: 'items');
	@override
	final KlpId id;
	final KlpExplorerData data;
	final void Function(KlpExplorerIntent)? onIntent;
	final KlpExplorerController? controller;
	@override
	late final KlpChildren children = _captureChildren();

	KlpExplorer({required this.id, required this.data, this.onIntent, this.controller}) {
		final snapshot = data.snapshot;
		final interactive = snapshot.items.values.any((item) => item.capabilities.selectable || item.capabilities.collapsible || item.capabilities.primaryAction == KlpExplorerPrimaryAction.activate || item.row.inlineActions.any((command) => command.enabled) || item.row.contextActions.any((command) => command.enabled)) || data.acceptedDrops.isNotEmpty;
		if (interactive && onIntent == null) {
			throw KlpContractError('explorer_missing_intent_handler', '可互動的 Explorer 必須提供 onIntent。');
		}
	}

	@override
	String get definitionId => typeId;

	KlpChildren _captureChildren() {
		final snapshot = data.snapshot;
		final tree = snapshot.trees[id];
		if (tree == null) {
			throw KlpContractError('explorer_invalid_scope', 'Explorer 的 ID 不在完整森林中：$id。');
		}

		// 前序反向建立確保 child 已存在，不以遞迴建立第二份階層輸入。
		final nodes = <KlpId, KlpExplorerEntryNode>{};
		for (final item in snapshot.items.values.toList().reversed) {
			if (item.treeId != id) continue;

			nodes[item.id] = KlpExplorerEntryNode(item.id, [for (final child in item.childIds) nodes[child]!]);
		}

		return KlpChildren([itemSlot.assign([for (final root in tree.rootIds) nodes[root]!])]);
	}
}
