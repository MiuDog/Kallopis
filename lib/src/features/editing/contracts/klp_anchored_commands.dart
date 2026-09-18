import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_command_slot_child.dart';

/// 啟用本庫定位命令機制；consumer 只提供結構身分。
final class KlpAnchoredCommands implements KlpCommandSlotChild {
	static const typeId = 'kallopis.anchored-commands';
	@override
	final KlpId id;

	const KlpAnchoredCommands({required this.id});

	@override
	String get definitionId => typeId;
	@override
	Iterable<KlpCommandSlotChild> get children => const [];
}
