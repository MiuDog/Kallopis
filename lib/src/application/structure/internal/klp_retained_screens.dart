import '../../../composition/definitions/klp_definition.dart';
import '../../../composition/nodes/internal/klp_scope_boundary.dart';
import '../../../composition/nodes/klp_composite_node.dart';
import '../../../composition/slots/klp_children.dart';
import '../../../composition/slots/klp_slot.dart';
import '../klp_screen.dart';

/// 應用根將全部保留畫面放入同一棵樹，只有目前 entry 開啟操作資格。
final class KlpRetainedScreens implements KlpCompositeNode {

	static const typeId = 'kallopis.retainedScreens';
	static final entriesSlot = KlpSlot<KlpScopeBoundary>(owner: typeId, name: 'entries', min: 1);
	static final contract = KlpDefinition<KlpRetainedScreens>(typeId, slots: [entriesSlot]);

	@override
	final String id;
	final String activeEntry;
	@override
	final KlpChildren children;

	KlpRetainedScreens({required this.id, required this.activeEntry, required Map<String, KlpScreen> screens}) : children = _children(screens, activeEntry);

	static KlpChildren _children(Map<String, KlpScreen> screens, String activeEntry) {
		if (!screens.containsKey(activeEntry)) throw ArgumentError('Active screen entry must exist.');

		final entries = [for (final entry in screens.entries) KlpScopeBoundary(id: entry.key, child: entry.value, active: entry.key == activeEntry)];
		return KlpChildren([entriesSlot.assign(entries)]);
	}

	@override
	String get definitionId => typeId;
}
