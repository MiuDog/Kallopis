import 'package:kallopis/src/capabilities/actions/klp_action.dart';
import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'package:kallopis/src/foundation/templates/klp_axis.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_workspace_command.dart';

/// 工作區區塊的封閉語意種類；不定義產品資料模型或提供自訂渲染器。
enum KlpWorkspaceBlockKind { identity, action, paper, sticky, search, settings, board, cards, dialog, toolbar }
/// 工作區區塊的材質語意選項；不保存色彩值或建立另一份主題。
enum KlpWorkspaceMaterial { standard, sage }
/// 工作區可選用的封閉圖示語意；不接受外部資產路徑或原生元件。
enum KlpWorkspaceIcon { search, settings, inbox, calendar, clipboard, archive, disclosure, folder, file, minimize, maximize, restore, close, check, link, info, sparkles, image, music, board, lightbulb, calendarCheck }
/// 工作區內容區塊的封閉語意種類；不提供正文編輯引擎或自訂排版規則。
enum KlpWorkspaceContentKind { text, heading, callout, divider, link, checklist, group, lead }

/// 工作區項目的文字、圖示、勾選與選取輸入及事件回呼；不自行維護產品狀態。
final class KlpWorkspaceItem {
	final String title;
	final String? subtitle;
	final String? symbol;
	final KlpWorkspaceIcon? icon;
	final bool? checked;
	final bool selected;
	final void Function()? onPressed;
	final void Function(bool)? onCheckedChanged;
	const KlpWorkspaceItem({required this.title, this.subtitle, this.symbol, this.icon, this.checked, this.selected = false, this.onPressed, this.onCheckedChanged});
}

/// 工作區選項的標籤、選取輸入與通知回呼；不自行變更選取權威。
final class KlpWorkspaceChoice {
	final String label;
	final bool selected;
	final void Function()? onSelected;
	const KlpWorkspaceChoice({required this.label, required this.selected, this.onSelected});
}

/// paper 內容唯一可用的受控線性容器。
final class KlpWorkspaceContent implements KlpCompositeNode {
	static const typeId = 'kallopis.workspace_content';
	static final childSlot = KlpSlot<KlpWorkspaceContentBlock>(owner: typeId, name: 'children', min: 1);

	@override
	final KlpId id;
	final KlpAxis axis;
	final List<KlpWorkspaceContentBlock> content;
	@override
	final KlpChildren children;

	KlpWorkspaceContent({required this.id, required List<KlpWorkspaceContentBlock> children, this.axis = KlpAxis.vertical})
		: content = List.unmodifiable(children),
			children = KlpChildren([childSlot.assign(children)]);

	@override
	String get definitionId => typeId;
}

/// paper 內的封閉語意節點；巢狀 row／column／callout 仍由 [children] 表達。
final class KlpWorkspaceContentBlock implements KlpCompositeNode {
	static const typeId = 'kallopis.workspace_content_block';
	static final childSlot = KlpSlot<KlpWorkspaceContentBlock>(owner: typeId, name: 'children');

	@override
	final KlpId id;
	final KlpWorkspaceContentKind kind;
	final String text;
	final String? subtitle;
	final KlpWorkspaceIcon? icon;
	final bool? checked;
	final void Function()? onPressed;
	final void Function(bool)? onCheckedChanged;
	final KlpAxis axis;
	final List<KlpWorkspaceContentBlock> content;
	@override
	final KlpChildren children;

	KlpWorkspaceContentBlock({
		required this.id,
		required this.kind,
		this.text = '',
		this.subtitle,
		this.icon,
		this.checked,
		this.onPressed,
		this.onCheckedChanged,
		this.axis = KlpAxis.vertical,
		List<KlpWorkspaceContentBlock> children = const [],
	}) : content = List.unmodifiable(children), children = KlpChildren([childSlot.assign(children)]) {
		if ((kind == KlpWorkspaceContentKind.text || kind == KlpWorkspaceContentKind.heading || kind == KlpWorkspaceContentKind.link || kind == KlpWorkspaceContentKind.checklist) && text.trim().isEmpty) {
			throw ArgumentError.value(text, 'text', 'Workspace content text must not be empty.');
		}
	}

	@override
	String get definitionId => typeId;
}

/// 通用工作區文字區塊；布局與視覺由 kind 的語意 recipe 決定。
final class KlpWorkspaceBlock implements KlpCompositeNode {
	static const typeId = 'kallopis.workspace_block';
	static final contentSlot = KlpSlot<KlpWorkspaceContent>(owner: typeId, name: 'content', max: 1);

	@override
	final KlpId id;
	final KlpWorkspaceBlockKind kind;
	final String title;
	final String? symbol;
	final KlpWorkspaceIcon? icon;
	final String? subtitle;
	final List<String> lines;
	final List<String> checklist;
	final String? checklistTitle;
	final List<KlpWorkspaceItem> items;
	final List<KlpWorkspaceChoice> choices;
	final String? query;
	final String? hint;
	final void Function(String)? onQueryChanged;
	final String? toggleLabel;
	final bool? toggleValue;
	final void Function(bool)? onToggleChanged;
	final KlpWorkspaceMaterial material;
	final bool shadowed;
	final bool selected;
	final KlpAction? action;
	final void Function()? onPressed;
	final String? secondaryActionLabel;
	final void Function()? onSecondaryAction;
	final String? tertiaryActionLabel;
	final void Function()? onTertiaryAction;
	final KlpWorkspaceContent? content;
	final List<KlpWorkspaceCommand> actions;
	final String actionsLabel;
	@override
	final KlpChildren children;

	KlpWorkspaceBlock({required this.id, required this.kind, required this.title, this.symbol, this.icon, this.subtitle, this.lines = const [], this.checklist = const [], this.checklistTitle, this.items = const [], this.choices = const [], this.query, this.hint, this.onQueryChanged, this.toggleLabel, this.toggleValue, this.onToggleChanged, this.material = KlpWorkspaceMaterial.standard, this.shadowed = true, this.selected = false, this.action, this.onPressed, this.secondaryActionLabel, this.onSecondaryAction, this.tertiaryActionLabel, this.onTertiaryAction, this.actions = const [], this.actionsLabel = 'More actions', this.content}) : children = KlpChildren([contentSlot.assign(content == null ? const [] : [content])]) {
		if (title.trim().isEmpty && kind != KlpWorkspaceBlockKind.identity && kind != KlpWorkspaceBlockKind.toolbar) throw ArgumentError.value(title, 'title', 'Workspace block title must not be empty.');
		if (actionsLabel.trim().isEmpty) throw ArgumentError.value(actionsLabel, 'actionsLabel', 'Workspace block actions label must not be empty.');
		if (action != null && kind != KlpWorkspaceBlockKind.action) throw ArgumentError.value(action, 'action', 'Workspace actions require KlpWorkspaceBlockKind.action.');
		if (action != null && onPressed != null) throw ArgumentError.value(action, 'action', 'Workspace block accepts either action or onPressed, not both.');
	}

	@override
	String get definitionId => typeId;
}
