part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀 popup 列資料；事件已由目前 frame lease 保護。
final class KlpBoundAnchoredPopupItem {
	final KlpId id;
	final String label;
	final String? subtitle;
	final int? icon;
	final bool current;
	final bool enabled;
	final FutureOr<void> Function()? onPressed;
	final List<KlpBoundWorkspaceCommand> commands;

	KlpBoundAnchoredPopupItem({required this.id, required this.label, this.subtitle, this.icon, required this.current, required this.enabled, this.onPressed, Iterable<KlpBoundWorkspaceCommand> commands = const []}) : commands = List.unmodifiable(commands);
}

/// 套件內部的唯讀 popup 呈現紀錄，保存已解析樣式、幾何與受控事件。
final class KlpBoundAnchoredPopup extends KlpBoundTemplate {
	final KlpBoundTemplate trigger;
	final bool open;
	final String accessibilityLabel;
	final String? title;
	final List<KlpBoundAnchoredPopupItem>? items;
	final List<KlpBoundWorkspaceCommand>? actions;
	final int state;
	final String? message;
	final void Function(bool, KlpAnchoredPopupChangeReason) onOpenChanged;
	final KlpColor surface;
	final KlpColor foreground;
	final KlpColor mutedForeground;
	final KlpColor interaction;
	final KlpColor shadow;
	final KlpColor destructive;
	final KlpDistance inset;
	final KlpDistance gap;
	final KlpDistance rowExtent;
	final KlpDistance viewportInset;
	final KlpDistance panelWidth;
	final KlpDistance shadowOffset;
	final KlpDistance shadowBlur;
	final KlpRadius radius;
	final KlpBoundTextStyle textStyle;

	KlpBoundAnchoredPopup({required this.trigger, required this.open, required this.accessibilityLabel, this.title, Iterable<KlpBoundAnchoredPopupItem>? items, Iterable<KlpBoundWorkspaceCommand>? actions, required this.state, this.message, required this.onOpenChanged, required this.surface, required this.foreground, required this.mutedForeground, required this.interaction, required this.shadow, required this.destructive, required this.inset, required this.gap, required this.rowExtent, required this.viewportInset, required this.panelWidth, required this.shadowOffset, required this.shadowBlur, required this.radius, required this.textStyle})
		: items = items == null ? null : List.unmodifiable(items),
			actions = actions == null ? null : List.unmodifiable(actions);
}
