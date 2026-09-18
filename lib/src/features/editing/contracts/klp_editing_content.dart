import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_source.dart';
import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_screen_body.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_block_control_slot_child.dart';
import 'klp_command_slot_child.dart';
import 'klp_mode_tool_slot_child.dart';

/// 編輯內容；可作為畫面主體或放入組合容器中，提供者仍擁有資料來源與編輯權威。
/// KLP-0020 的舊正文相容／必要維護與回退節點；新正文使用 KlpBlockNoteEditingContent，且由上游掌管正文、選取與 undo。
final class KlpEditingContent implements KlpScreenBody, KlpCompositeNode {
	static const typeId = 'kallopis.editing';
	static final blockControlsSlot = KlpSlot<KlpBlockControlSlotChild>(owner: typeId, name: 'blockControls', max: 1);
	static final anchoredCommandsSlot = KlpSlot<KlpCommandSlotChild>(owner: typeId, name: 'anchoredCommands', max: 1);
	static final modeToolbarSlot = KlpSlot<KlpModeToolSlotChild>(owner: typeId, name: 'modeToolbar', max: 1);
	@override
	final KlpId id;
	final KlpEditingSource source;
	final KlpBlockControlSlotChild? blockControls;
	final KlpCommandSlotChild? anchoredCommands;
	final KlpModeToolSlotChild? modeToolbar;
	@override
	final KlpChildren children;

	KlpEditingContent({required this.id, required this.source, this.blockControls, this.anchoredCommands, this.modeToolbar})
		: children = KlpChildren([
			blockControlsSlot.assign(blockControls == null ? const [] : [blockControls]),
			anchoredCommandsSlot.assign(anchoredCommands == null ? const [] : [anchoredCommands]),
			modeToolbarSlot.assign(modeToolbar == null ? const [] : [modeToolbar]),
		]);

	@override
	String get definitionId => typeId;
}
