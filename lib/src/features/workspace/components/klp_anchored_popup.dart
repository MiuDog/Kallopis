import 'dart:async';

import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_workspace_block.dart';
import 'klp_workspace_command.dart';

/// 受控 popup 的開關原因；只描述呈現層請求，不代表 consumer 已接受。
enum KlpAnchoredPopupChangeReason { trigger, outside, escape, anchorUnavailable }

/// Popup 內容的非同步回饋狀態。
enum KlpAnchoredPopupState { loading, ready, error, result }

/// Popup 內的平面資料列；穩定身分與可重複顯示名稱彼此分離。
final class KlpAnchoredPopupItem {
	final KlpId id;
	final String label;
	final String? subtitle;
	final KlpWorkspaceIcon? icon;
	final bool current;
	final bool enabled;
	final FutureOr<void> Function()? onPressed;
	final List<KlpWorkspaceCommand> commands;

	KlpAnchoredPopupItem({required this.id, required this.label, this.subtitle, this.icon, this.current = false, this.enabled = true, this.onPressed, List<KlpWorkspaceCommand> commands = const []}) : commands = List.unmodifiable(commands) {
		if (label.trim().isEmpty) throw ArgumentError.value(label, 'label', 'Anchored popup item label must not be empty.');
		if (subtitle != null && subtitle!.trim().isEmpty) throw ArgumentError.value(subtitle, 'subtitle', 'Anchored popup item subtitle must not be empty.');
	}
}

/// 由單一 action trigger 錨定的受控 popup；產品資料與 open 權威留在 consumer。
final class KlpAnchoredPopup implements KlpCompositeNode {
	static const typeId = 'kallopis.anchored_popup';
	static final triggerSlot = KlpSlot<KlpWorkspaceBlock>(owner: typeId, name: 'trigger', min: 1, max: 1);

	@override
	final KlpId id;
	final KlpWorkspaceBlock trigger;
	final bool open;
	final String accessibilityLabel;
	final String? title;
	final List<KlpAnchoredPopupItem>? items;
	final List<KlpWorkspaceCommand>? actions;
	final KlpAnchoredPopupState state;
	final String? message;
	final void Function(bool, KlpAnchoredPopupChangeReason) onOpenChanged;
	@override
	final KlpChildren children;

	KlpAnchoredPopup({required this.id, required this.trigger, required this.open, required this.accessibilityLabel, this.title, List<KlpAnchoredPopupItem>? items, List<KlpWorkspaceCommand>? actions, this.state = KlpAnchoredPopupState.ready, this.message, required this.onOpenChanged})
		: items = items == null ? null : List.unmodifiable(items),
			actions = actions == null ? null : List.unmodifiable(actions),
			children = KlpChildren([triggerSlot.assign([trigger])]) {
		if (accessibilityLabel.trim().isEmpty) throw ArgumentError.value(accessibilityLabel, 'accessibilityLabel', 'Anchored popup accessibility label must not be empty.');
		if (title != null && title!.trim().isEmpty) throw ArgumentError.value(title, 'title', 'Anchored popup title must not be empty.');
		if (items == null && actions == null && state == KlpAnchoredPopupState.ready) throw ArgumentError('Anchored popup requires items, actions, or feedback.');
		if ((state == KlpAnchoredPopupState.error || state == KlpAnchoredPopupState.result) && (message == null || message!.trim().isEmpty)) throw ArgumentError.value(message, 'message', 'Anchored popup error and result states require a message.');
		if (trigger.kind != KlpWorkspaceBlockKind.action || trigger.action != null || trigger.onPressed != null || trigger.actions.isNotEmpty || trigger.selected) throw ArgumentError.value(trigger, 'trigger', 'Anchored popup trigger must be an unselected action without its own actions.');
		final ids = <KlpId>{};
		for (final item in this.items ?? const <KlpAnchoredPopupItem>[]) {
			if (!ids.add(item.id)) throw ArgumentError.value(item.id, 'items', 'Anchored popup item IDs must be unique.');
		}
	}

	@override
	String get definitionId => typeId;
}
