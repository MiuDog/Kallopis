import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// 本庫建立的唯一結構投影；不對 consumer 匯出。
final class KlpExplorerEntryNode implements KlpCompositeNode {

	static const typeId = 'kallopis.explorer.entry';
	static final childSlot = KlpSlot<KlpExplorerEntryNode>(owner: typeId, name: 'children');
	@override
	final KlpId id;
	@override
	final KlpChildren children;

	KlpExplorerEntryNode(this.id, List<KlpExplorerEntryNode> children) : children = KlpChildren([childSlot.assign(children)]);

	@override
	String get definitionId => typeId;
}
