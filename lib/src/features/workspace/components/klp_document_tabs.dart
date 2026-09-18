import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// 一份文件分頁的不可變產品資料，不具有可單獨組裝的 node 身分。
final class KlpDocumentTabData {

	final KlpId id;
	final String label;
	final bool dirty;
	final bool selectable;
	final bool closable;
	final bool pinnable;
	final bool pinned;

	KlpDocumentTabData({required this.id, required this.label, this.dirty = false, this.selectable = true, this.closable = true, this.pinnable = false, this.pinned = false}) {
		if (label.trim().isEmpty) {
			throw KlpContractError('document_tabs_invalid_label', 'Document tab 標籤不得為空。');
		}
	}
}

/// 文件分頁列的完整 consumer-owned projection。
final class KlpDocumentTabsData {

	final List<KlpDocumentTabData> tabs;
	final KlpId? selectedId;

	KlpDocumentTabsData({required List<KlpDocumentTabData> tabs, this.selectedId}) : tabs = List.unmodifiable(tabs) {
		final ids = <KlpId>{};
		for (final tab in tabs) {
			if (!ids.add(tab.id)) {
				throw KlpContractError('document_tabs_duplicate_id', 'Document tab ID 不得重複：${tab.id}。');
			}
		}
		if (selectedId != null && !ids.contains(selectedId)) {
			throw KlpContractError('document_tabs_invalid_selection', '選取的 Document tab 不存在：$selectedId。');
		}
	}
}

sealed class KlpDocumentTabsIntent {

	const KlpDocumentTabsIntent();
}

final class KlpDocumentTabSelectionRequested extends KlpDocumentTabsIntent {

	final KlpId tabId;

	const KlpDocumentTabSelectionRequested(this.tabId);
}

final class KlpDocumentTabCloseRequested extends KlpDocumentTabsIntent {

	final KlpId tabId;

	const KlpDocumentTabCloseRequested(this.tabId);
}

final class KlpDocumentTabPinRequested extends KlpDocumentTabsIntent {

	final KlpId tabId;
	final bool pinned;

	const KlpDocumentTabPinRequested(this.tabId, this.pinned);
}

/// 文件分頁列；所有互動只輸出 intent，不改寫 consumer 的文件資料。
final class KlpDocumentTabs implements KlpNode {

	static const typeId = 'kallopis.document_tabs';
	@override
	final KlpId id;
	final KlpDocumentTabsData data;
	final void Function(KlpDocumentTabsIntent)? onIntent;

	KlpDocumentTabs({required this.id, required this.data, this.onIntent}) {
		final interactive = data.tabs.any((tab) => tab.selectable || tab.closable || tab.pinnable);
		if (interactive && onIntent == null) {
			throw KlpContractError('document_tabs_missing_intent_handler', '可互動的 Document Tabs 必須提供 onIntent。');
		}
	}

	@override
	Iterable<KlpNode> get children => const [];

	@override
	String get definitionId => typeId;
}
