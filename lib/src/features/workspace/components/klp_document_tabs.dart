import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// 一份文件分頁的資料；選取與關閉意圖歸消費端管理。
final class KlpDocumentTab implements KlpNode {
	static const typeId = 'kallopis.document_tab';
	@override
	final KlpId id;
	final String label;
	final bool dirty;
	final bool closable;
	final bool pinned;

	KlpDocumentTab({required this.id, required this.label, this.dirty = false, this.closable = true, this.pinned = false}) {
		if (label.trim().isEmpty) throw ArgumentError.value(label, 'label', 'Document tab label must not be empty.');
	}

	@override
	Iterable<KlpNode> get children => const [];
	@override
	String get definitionId => typeId;
}

/// 文件分頁列；關閉只回報意圖，不刪除 consumer 的文件資料。
final class KlpDocumentTabs implements KlpCompositeNode {
	static const typeId = 'kallopis.document_tabs';
	static final tabSlot = KlpSlot<KlpDocumentTab>(owner: typeId, name: 'tabs');
	@override
	final KlpId id;
	final List<KlpDocumentTab> tabs;
	final KlpId? selectedId;
	final void Function(KlpId)? onSelected;
	final void Function(KlpId)? onClose;
	final void Function(KlpId, bool)? onPinnedChanged;
	@override
	final KlpChildren children;

	KlpDocumentTabs({required this.id, required List<KlpDocumentTab> tabs, this.selectedId, this.onSelected, this.onClose, this.onPinnedChanged})
		: tabs = List.unmodifiable(tabs),
			children = KlpChildren([tabSlot.assign(tabs)]);

	@override
	String get definitionId => typeId;
}
