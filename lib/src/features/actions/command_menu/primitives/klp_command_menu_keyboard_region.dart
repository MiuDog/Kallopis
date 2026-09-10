part of '../klp_command_menu.dart';

class _KlpCommandMenuKeyboardRegion extends StatelessWidget {
	const _KlpCommandMenuKeyboardRegion({
		required this.autofocus,
		required this.onKeyEvent,
		required this.child,
	});

	final bool autofocus;
	final FocusOnKeyEventCallback onKeyEvent;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Focus(
			autofocus: autofocus,
			onKeyEvent: onKeyEvent,
			child: child,
		);
	}
}
