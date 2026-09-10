part of '../klp_rail_menu_entry.dart';

class _KlpRailPointerTracker extends StatelessWidget {
	const _KlpRailPointerTracker({
		required this.onPointerDown,
		required this.child,
	});

	final ValueChanged<Offset> onPointerDown;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Listener(
			onPointerDown: (event) => onPointerDown(event.position),
			child: child,
		);
	}
}
