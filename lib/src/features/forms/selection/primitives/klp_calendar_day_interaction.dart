part of '../klp_calendar.dart';

class _KlpCalendarDayInteraction extends StatelessWidget {
	const _KlpCalendarDayInteraction({
		required this.enabled,
		required this.selected,
		required this.onHoverChanged,
		required this.onTap,
		required this.child,
	});

	final bool enabled;
	final bool selected;
	final ValueChanged<bool> onHoverChanged;
	final VoidCallback? onTap;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return MouseRegion(
			onEnter: enabled ? (_) => onHoverChanged(true) : null,
			onExit: enabled ? (_) => onHoverChanged(false) : null,
			child: KlpGestureRegion(
				behavior: HitTestBehavior.opaque,
				onTap: enabled ? onTap : null,
				child: Semantics(
					button: true,
					enabled: enabled,
					selected: selected,
					child: child,
				),
			),
		);
	}
}
