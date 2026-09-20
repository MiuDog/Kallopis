import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kallopis/src/features/actions/button/klp_button.dart';
import 'package:kallopis/src/features/actions/button/klp_icon_button.dart';
import 'package:kallopis/src/features/feedback/klp_feedback_tone.dart';
import 'package:kallopis/src/features/feedback/klp_inline_notice.dart';
import 'package:kallopis/src/features/feedback/klp_live_region.dart';
import 'package:kallopis/src/features/forms/input/klp_text_field.dart';
import 'package:kallopis/src/features/overlays/klp_context_menu.dart';
import 'package:kallopis/src/features/overlays/klp_dialog.dart';
import 'package:kallopis/src/features/overlays/klp_menu.dart';
import 'package:kallopis/src/features/overlays/primitives/klp_modal_frame.dart';
import 'package:kallopis/src/foundation/content/klp_text.dart';
import 'package:kallopis/src/foundation/interaction/klp_action_region.dart';
import 'package:kallopis/src/foundation/klp_geometric_spinner.dart';
import 'package:kallopis/src/foundation/klp_icon.dart';
import 'package:kallopis/src/foundation/klp_icons.dart';
import 'package:kallopis/src/foundation/layout/klp_box_insets.dart';
import 'package:kallopis/src/foundation/surface/klp_surface.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';

part 'klp_workspace_command.dart';
part 'internal/klp_anchored_popup_layout.dart';
part 'internal/klp_anchored_popup_panel.dart';
part 'internal/klp_anchored_popup_state.dart';
part 'internal/klp_workspace_command_flow.dart';

/// 受控 popup 的開關原因；只描述呈現層請求，不代表 consumer 已接受。
enum KlpAnchoredPopupChangeReason { trigger, outside, escape, anchorUnavailable }

/// Popup 內容的非同步回饋狀態。
enum KlpAnchoredPopupState { loading, ready, error, result }

/// Consumer 用既有 Widget 建立 trigger；Kallopis 注入 toggle 與 expanded 狀態。
typedef KlpAnchoredPopupTriggerBuilder = Widget Function(BuildContext context, VoidCallback toggle, bool expanded);

/// Popup 內的平面資料列；穩定身分與可重複顯示名稱彼此分離。
final class KlpAnchoredPopupItem {
	KlpAnchoredPopupItem({
		required this.id,
		required this.label,
		this.subtitle,
		this.icon,
		this.current = false,
		this.enabled = true,
		this.onPressed,
		List<KlpWorkspaceCommand> commands = const [],
	}) : commands = List.unmodifiable(commands) {
		if (id.trim().isEmpty) throw ArgumentError.value(id, 'id', 'Anchored popup item id must not be empty.');
		if (label.trim().isEmpty) throw ArgumentError.value(label, 'label', 'Anchored popup item label must not be empty.');
		if (subtitle != null && subtitle!.trim().isEmpty) throw ArgumentError.value(subtitle, 'subtitle', 'Anchored popup item subtitle must not be empty.');
	}

	final String id;
	final String label;
	final String? subtitle;
	final KlpIconData? icon;
	final bool current;
	final bool enabled;
	final FutureOr<void> Function()? onPressed;
	final List<KlpWorkspaceCommand> commands;
}

/// 由 trigger 實際 bounds 錨定的受控 popup。
final class KlpAnchoredPopup extends StatefulWidget {
	KlpAnchoredPopup({
		super.key,
		required this.triggerBuilder,
		required this.open,
		required this.accessibilityLabel,
		this.title,
		List<KlpAnchoredPopupItem>? items,
		List<KlpWorkspaceCommand>? actions,
		this.state = KlpAnchoredPopupState.ready,
		this.message,
		required this.onOpenChanged,
	}) : items = items == null ? null : List.unmodifiable(items),
		actions = actions == null ? null : List.unmodifiable(actions) {
		if (accessibilityLabel.trim().isEmpty) throw ArgumentError.value(accessibilityLabel, 'accessibilityLabel', 'Anchored popup accessibility label must not be empty.');
		if (title != null && title!.trim().isEmpty) throw ArgumentError.value(title, 'title', 'Anchored popup title must not be empty.');
		final hasItems = this.items?.isNotEmpty ?? false;
		final hasActions = this.actions?.isNotEmpty ?? false;
		if (!hasItems && !hasActions && state == KlpAnchoredPopupState.ready) throw ArgumentError('Anchored popup requires items, actions, or feedback.');
		if ((state == KlpAnchoredPopupState.error || state == KlpAnchoredPopupState.result) && (message == null || message!.trim().isEmpty)) throw ArgumentError.value(message, 'message', 'Anchored popup error and result states require a message.');

		final ids = <String>{};
		for (final item in this.items ?? const <KlpAnchoredPopupItem>[]) {
			if (!ids.add(item.id)) throw ArgumentError.value(item.id, 'items', 'Anchored popup item ids must be unique.');
		}
	}

	final KlpAnchoredPopupTriggerBuilder triggerBuilder;
	final bool open;
	final String accessibilityLabel;
	final String? title;
	final List<KlpAnchoredPopupItem>? items;
	final List<KlpWorkspaceCommand>? actions;
	final KlpAnchoredPopupState state;
	final String? message;
	final void Function(bool open, KlpAnchoredPopupChangeReason reason) onOpenChanged;

	@override
	State<KlpAnchoredPopup> createState() => _KlpAnchoredPopupState();
}
