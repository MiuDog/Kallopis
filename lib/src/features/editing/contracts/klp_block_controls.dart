import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_block_control_slot_child.dart';

/// 啟用本庫區塊控制；consumer 只提供結構身分。
final class KlpBlockControls implements KlpBlockControlSlotChild {
	static const typeId = 'kallopis.block-controls';
	@override
	final KlpId id;

	const KlpBlockControls({required this.id});

	@override
	String get definitionId => typeId;
	@override
	Iterable<KlpBlockControlSlotChild> get children => const [];
}
