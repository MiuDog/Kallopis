import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:krepis_block_note/krepis_block_note.dart' show KrepisPageReference;
import 'klp_workspace_command.dart';

/// Explorer 項目的封閉種類；不定義產品的檔案副檔名或資料來源。
enum KlpExplorerItemKind { file, folder, category, branch }

/// 受控圖示語意，避免消費端注入 Widget 或資產路徑。
enum KlpExplorerIcon { file, folder, image, music, board }
/// Explorer 項目間距的語意選項；實際距離由本庫呈現契約決定，不承載原始尺寸。
enum KlpExplorerSpacing { standard, relaxed, flush }
/// Explorer 命令的封閉入口政策；不改變命令內容或樣式。
enum KlpExplorerCommandPresentation { buttonAndContextMenu, contextMenuOnly }
/// Explorer 移動請求相對目標的位置；不執行資料搬移或決定移動權限。
enum KlpExplorerDropPosition { before, inside, after }

/// Explorer 的資料節點；階層、選取與展開狀態均由 consumer 擁有。
final class KlpExplorerItem implements KlpCompositeNode {
	static const typeId = 'kallopis.explorer_item';
	static final childSlot = KlpSlot<KlpExplorerItem>(owner: typeId, name: 'children');

	@override
	final KlpId id;
	final String label;
	final KlpExplorerItemKind kind;
	final KlpExplorerIcon? icon;
	final String? badge;
	final bool collapsible;
	final bool selectable;
	final List<KlpWorkspaceCommand> actions;
	final List<KlpExplorerItem> items;
	@override
	final KlpChildren children;

	KlpExplorerItem({required this.id, required this.label, required this.kind, this.icon, this.badge, this.collapsible = true, this.selectable = true, this.actions = const [], List<KlpExplorerItem> children = const []})
		: items = List.unmodifiable(children),
			children = KlpChildren([childSlot.assign(children)]) {
		if (label.trim().isEmpty) throw ArgumentError.value(label, 'label', 'Explorer item label must not be empty.');
		if (kind == KlpExplorerItemKind.file && children.isNotEmpty) throw ArgumentError.value(children, 'children', 'A file cannot contain Explorer children.');
	}

	@override
	String get definitionId => typeId;
}

/// 可控 Explorer；互動只通知 consumer，重建前不自行改變資料。
final class KlpExplorer implements KlpCompositeNode {

	static const typeId = 'kallopis.explorer';
	static final itemSlot = KlpSlot<KlpExplorerItem>(owner: typeId, name: 'items');

	@override
	final KlpId id;
	final List<KlpExplorerItem> items;
	final Map<KlpId, KrepisPageReference> pageReferences;
	final bool allowNesting;
	final String actionsLabel, expandLabel, collapseLabel;
	final KlpExplorerSpacing spacing;
	final KlpExplorerCommandPresentation commandPresentation;
	final KlpId? selectedId;
	final Set<KlpId> selectedIds;
	final Set<KlpId> expandedIds;
	final void Function(KlpId)? onSelected;
	final void Function(Set<KlpId>)? onSelectionChanged;
	final void Function(KlpId, bool)? onExpandedChanged;
	final bool Function(Set<KlpId>, KlpId, KlpExplorerDropPosition)? canMove;
	final void Function(Set<KlpId>, KlpId, KlpExplorerDropPosition)? onMove;
	@override
	final KlpChildren children;

	KlpExplorer({required this.id, required List<KlpExplorerItem> items, Map<KlpId, KrepisPageReference> pageReferences = const {}, this.selectedId, Set<KlpId> selectedIds = const {}, this.allowNesting = true, this.actionsLabel = 'Actions', this.expandLabel = 'Expand', this.collapseLabel = 'Collapse', this.spacing = KlpExplorerSpacing.flush, this.commandPresentation = KlpExplorerCommandPresentation.buttonAndContextMenu, Set<KlpId> expandedIds = const {}, this.onSelected, this.onSelectionChanged, this.onExpandedChanged, this.canMove, this.onMove})
		: items = List.unmodifiable(items),
			pageReferences = Map.unmodifiable(pageReferences),
			selectedIds = Set.unmodifiable(selectedIds),
			expandedIds = Set.unmodifiable(expandedIds),
			children = KlpChildren([itemSlot.assign(items)]) {
		// 只驗證既有可選來源；頁面身分不改寫角色、階層或移動權限。
		if (this.pageReferences.isEmpty) return;

		final eligible = <KlpId>{};
		void collect(Iterable<KlpExplorerItem> items) {
			for (final item in items) {
				if (item.selectable && item.kind != KlpExplorerItemKind.category) eligible.add(item.id);
				collect(item.items);
			}
		}
		collect(this.items);
		for (final sourceId in this.pageReferences.keys) {
			if (!eligible.contains(sourceId)) throw ArgumentError.value(sourceId, 'pageReferences', 'Page references require a present selectable non-category Explorer item.');
		}
	}

	@override
	String get definitionId => typeId;
}
