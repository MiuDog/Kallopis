part of '../klp_calendar.dart';

class _KlpCalendarDayFrame extends StatelessWidget {
	const _KlpCalendarDayFrame({
		required this.hasContent,
		required this.inRange,
		required this.isToday,
		required this.selected,
		required this.child,
	});

	final bool hasContent;
	final bool inRange;
	final bool isToday;
	final bool selected;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final tokens = context.klpColors;
		return Container(
			height: hasContent
				? klp.space.calendarContentCell
				: klp.space.controlHeightSmall,
			alignment: hasContent ? Alignment.topLeft : Alignment.center,
			padding: hasContent ? EdgeInsets.all(klp.space.tight) : null,
			decoration: BoxDecoration(
				color: inRange ? klp.selectionWash : null,
				borderRadius: BorderRadius.circular(klp.shape.control),
				border: isToday && !selected
					? Border.all(color: tokens.accent, width: klp.shape.hairline)
					: null,
			),
			child: child,
		);
	}
}
