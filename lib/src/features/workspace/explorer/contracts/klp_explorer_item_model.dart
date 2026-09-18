import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';

/// 結構角色與產品種類分離；圖示不決定角色或互動能力。
enum KlpExplorerRole { category, node }
enum KlpExplorerGlyph { file, folder, image, music, board }
enum KlpExplorerPrimaryAction { none, activate, toggleExpansion }
enum KlpExplorerCommandShortcut { rename, delete }

/// Explorer 命令只描述呈現與輸入需求；執行透過 feature intent 回報。
final class KlpExplorerCommand {

	final KlpId id;
	final String label;
	final bool enabled;
	final bool destructive;
	final String? inputLabel;
	final String? initialValue;
	final String? confirmation;
	final KlpExplorerCommandShortcut? shortcut;

	KlpExplorerCommand({required this.id, required this.label, this.enabled = true, this.destructive = false, this.inputLabel, this.initialValue, this.confirmation, this.shortcut}) {
		if (label.trim().isEmpty) throw KlpContractError('explorer_invalid_command', 'Explorer 命令標籤不得為空。');
		if (inputLabel != null && inputLabel!.trim().isEmpty) throw KlpContractError('explorer_invalid_command', 'Explorer 命令輸入標籤不得為空。');
		if (confirmation != null && confirmation!.trim().isEmpty) throw KlpContractError('explorer_invalid_command', 'Explorer 命令確認內容不得為空。');
		if (initialValue != null && inputLabel == null) throw KlpContractError('explorer_invalid_command', 'Explorer 命令初始值需要輸入欄位。');
	}
}

/// Consumer 只選擇既有能力，互動實現仍屬於 Kallopis。
final class KlpExplorerCapabilities {

	final bool selectable;
	final bool collapsible;
	final bool draggable;
	final KlpExplorerPrimaryAction primaryAction;

	const KlpExplorerCapabilities({this.selectable = false, this.collapsible = false, this.draggable = false, this.primaryAction = KlpExplorerPrimaryAction.none});
}

/// 固定列插槽的內容資料；兩種命令入口互不推導。
final class KlpExplorerRowData {

	final String title;
	final KlpExplorerGlyph? icon;
	final String? badge;
	final List<KlpExplorerCommand> inlineActions;
	final List<KlpExplorerCommand> contextActions;

	KlpExplorerRowData({required this.title, this.icon, this.badge, List<KlpExplorerCommand> inlineActions = const [], List<KlpExplorerCommand> contextActions = const []})
		: inlineActions = List.unmodifiable(inlineActions),
		contextActions = List.unmodifiable(contextActions);
}

/// 可由 consumer 實作的資料介面；不具有元件身分、Widget 或 renderer 插槽。
abstract interface class KlpExplorerItemModel {

	KlpId get id;
	KlpExplorerRole get role;
	bool get canHaveChildren;
	KlpExplorerRowData get row;
	KlpExplorerCapabilities get capabilities;
	List<KlpExplorerItemModel> get children;
}

/// 是否已有子項只由完整 children 推導，不作為另一份輸入。
extension KlpExplorerItemChildren on KlpExplorerItemModel {

	bool get hasChildren => children.isNotEmpty;
}

/// 通用節點資料；consumer 可用 method 固定特定產品種類的能力。
final class KlpExplorerNodeModel implements KlpExplorerItemModel {

	@override
	final KlpId id;
	@override
	final KlpExplorerRowData row;
	@override
	final bool canHaveChildren;
	@override
	final KlpExplorerCapabilities capabilities;
	@override
	final List<KlpExplorerItemModel> children;

	KlpExplorerNodeModel({required this.id, required this.row, required this.canHaveChildren, this.capabilities = const KlpExplorerCapabilities(), List<KlpExplorerItemModel> children = const []})
		: children = List.unmodifiable(children);

	@override
	KlpExplorerRole get role => KlpExplorerRole.node;
}

/// 分類只提供結構角色，不暗自覆蓋 consumer 的選取或收合能力。
final class KlpExplorerCategoryModel implements KlpExplorerItemModel {

	@override
	final KlpId id;
	@override
	final KlpExplorerRowData row;
	@override
	final KlpExplorerCapabilities capabilities;
	@override
	final List<KlpExplorerItemModel> children;

	KlpExplorerCategoryModel({required this.id, required this.row, this.capabilities = const KlpExplorerCapabilities(), List<KlpExplorerItemModel> children = const []})
		: children = List.unmodifiable(children);

	@override
	KlpExplorerRole get role => KlpExplorerRole.category;
	@override
	bool get canHaveChildren => true;
}
