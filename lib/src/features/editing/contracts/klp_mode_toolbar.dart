import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_mode_tool_slot_child.dart';

/// K04 結構節點只帶身分；候選、來源與 handler 均由 enclosing editor 注入。
final class KlpModeToolbar implements KlpModeToolSlotChild {
	static const typeId = 'kallopis.editing.modeToolbar';
	@override
	final KlpId id;

	const KlpModeToolbar({required this.id});

	@override
	String get definitionId => typeId;
	@override
	Iterable<KlpModeToolSlotChild> get children => const [];
}
