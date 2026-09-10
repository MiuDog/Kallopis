import '../../../../composition/nodes/klp_composite_node.dart';
import '../../../../composition/slots/klp_children.dart';
import '../../../../composition/slots/klp_slot.dart';
import '../../../../composition/slots/klp_screen_body.dart';
import 'klp_rail_item.dart';

/// 三區受控結構宣告；選取狀態與呈現由本庫在安裝後持有。
final class KlpRail implements KlpCompositeNode, KlpScreenBody {

	static const String typeId = 'kallopis.rail';
	static final topSlot = KlpSlot<KlpRailItem>(owner: typeId, name: 'top');
	static final centerSlot = KlpSlot<KlpRailItem>(owner: typeId, name: 'center');
	static final bottomSlot = KlpSlot<KlpRailItem>(owner: typeId, name: 'bottom');

	@override
	final String id;
	final List<KlpRailItem> top;
	final List<KlpRailItem> center;
	final List<KlpRailItem> bottom;
	final void Function(String)? onSelected;
	@override
	final KlpChildren children;

	KlpRail({required String id, List<KlpRailItem> top = const [], List<KlpRailItem> center = const [], List<KlpRailItem> bottom = const [], void Function(String)? onSelected}) : this._(id, List<KlpRailItem>.unmodifiable(top), List<KlpRailItem>.unmodifiable(center), List<KlpRailItem>.unmodifiable(bottom), onSelected);

	KlpRail._(this.id, this.top, this.center, this.bottom, this.onSelected) : children = KlpChildren([topSlot.assign(top), centerSlot.assign(center), bottomSlot.assign(bottom)]);

	@override
	String get definitionId => typeId;
}
