import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_menu_item.dart';

/// 獨立選單面板；顯示時機與項目狀態由 consumer 管理。
final class KlpMenu implements KlpNode {

	static const typeId = 'kallopis.menu';
	@override
	final KlpId id;
	final String label;
	final String? triggerLabel;
	final List<KlpMenuItem> items;
	final bool autofocus;
	final void Function()? onEscape;

	KlpMenu({
		required this.id,
		required this.label,
		required List<KlpMenuItem> items,
		this.autofocus = true,
		this.onEscape,
		this.triggerLabel,
	}) : items = List.unmodifiable(items) {
		if (triggerLabel != null && triggerLabel!.trim().isEmpty) {
			throw KlpContractError('menu_empty_trigger', '選單入口標籤不可為空。');
		}
		// 固定項目快照並拒絕無法辨識的語意資料。
		if (label.trim().isEmpty) {
			throw KlpContractError('menu_empty_label', '選單標籤不可為空。');
		}

		final ids = <KlpId>{};
		void validate(List<KlpMenuItem> items) {
			for (final item in items) {
				if (!ids.add(item.id)) {
					throw KlpContractError('menu_duplicate_item', '選單項目識別不可重複：${item.id}。');
				}
				validate(item.children);
			}
		}
		validate(this.items);
	}

	@override
	String get definitionId => typeId;
	@override
	Iterable<KlpNode> get children => const [];
}
