import '../../composition/nodes/klp_composite_node.dart';
import '../../composition/slots/klp_children.dart';
import '../../composition/slots/klp_slot.dart';
import '../../composition/slots/klp_screen_body.dart';

/// 畫面宣告只接受具有畫面內容資格的節點，渲染由本庫負責。
final class KlpScreen implements KlpCompositeNode {

	static const String typeId = 'kallopis.screen';
	static final bodySlot = KlpSlot<KlpScreenBody>(owner: typeId, name: 'body', min: 1, max: 1);

	@override
	final String id;
	final String accessibilityLabel;
	final KlpScreenBody child;
	@override
	final KlpChildren children;

	KlpScreen({
		required this.id,
		required this.accessibilityLabel,
		required this.child,
	}) : children = KlpChildren([bodySlot.assign([child])]) {
		if (accessibilityLabel.trim().isEmpty) {
			throw ArgumentError.value(
				accessibilityLabel,
				'accessibilityLabel',
				'Screen accessibility label cannot be empty.',
			);
		}
	}

	@override
	String get definitionId => typeId;
}
