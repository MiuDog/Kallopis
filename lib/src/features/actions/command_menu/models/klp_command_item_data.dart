part of '../klp_command_menu.dart';

@immutable
class KlpCommandItemData {
	const KlpCommandItemData({
		required this.label,
		this.onPressed,
		this.caption,
		this.shortcut,
		this.selected = false,
		this.danger = false,
	});

	final String label;
	final VoidCallback? onPressed;
	final String? caption;
	final String? shortcut;
	final bool selected;
	final bool danger;
}
