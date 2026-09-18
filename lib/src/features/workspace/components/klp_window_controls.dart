import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// Host 提供的視窗命令；Kallopis 不擁有作業系統 runner 通道。
final class KlpWindowCommands {
	final void Function()? minimize;
	final void Function()? toggleMaximize;
	final void Function()? close;
	const KlpWindowCommands({this.minimize, this.toggleMaximize, this.close});
}

/// 視窗控制列的呈現資料；實際視窗操作由 host callback 擁有。
final class KlpWindowControls implements KlpNode {
	static const typeId = 'kallopis.window_controls';
	@override
	final KlpId id;
	final bool isMaximized;
	final KlpWindowCommands commands;
	KlpWindowControls({required this.id, required void Function()? onMinimize, required void Function()? onToggleMaximize, required void Function()? onClose, this.isMaximized = false})
		: commands = KlpWindowCommands(minimize: onMinimize, toggleMaximize: onToggleMaximize, close: onClose);
	@override
	Iterable<KlpNode> get children => const [];
	@override
	String get definitionId => typeId;
}
