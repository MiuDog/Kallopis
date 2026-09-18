import 'package:kallopis/src/features/workspace/components/klp_workspace_block.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// 選單的封閉項目資料；children 由庫管理層級導覽。
final class KlpMenuItem {

	final KlpId id;
	final String label;
	final KlpWorkspaceIcon? icon;
	final String? shortcut;
	final bool? toggleValue;
	final bool hasSubmenu;
	final List<KlpMenuItem> children;
	final bool destructive;
	final bool separatedBefore;
	final bool dashedSeparatorBefore;
	final bool selected;
	final bool enabled;
	final void Function()? onPressed;

	KlpMenuItem({
		required this.id,
		required this.label,
		this.icon,
		this.shortcut,
		this.toggleValue,
		bool hasSubmenu = false,
		List<KlpMenuItem> children = const [],
		this.destructive = false,
		this.separatedBefore = false,
		this.dashedSeparatorBefore = false,
		this.selected = false,
		this.enabled = true,
		this.onPressed,
	}) : hasSubmenu = hasSubmenu || children.isNotEmpty, children = List.unmodifiable(children) {
		if (this.children.isNotEmpty && onPressed != null) {
			throw KlpContractError('menu_branch_action', '子選單父項不可同時執行操作。');
		}
		if (label.trim().isEmpty) {
			throw KlpContractError('menu_empty_item_label', '選單項目標籤不可為空。');
		}

		if (separatedBefore && dashedSeparatorBefore) {
			throw KlpContractError('menu_conflicting_separator', '選單項目不可同時使用實線與虛線分隔。');
		}
	}
}
