part of '../klp_calendar.dart';

class _KlpCalendarDayCell extends StatefulWidget {
	const _KlpCalendarDayCell({
		required this.label,
		required this.selected,
		required this.inRange,
		required this.isToday,
		required this.disabled,
		required this.onTap,
		required this.content,
	});

	/// 日期數字底下的內容。`null` 表示這一格只有數字。
	final Widget? content;
	final String label;
	final bool selected;
	final bool inRange;
	final bool isToday;
	final bool disabled;
	final VoidCallback? onTap;

	@override
	State<_KlpCalendarDayCell> createState() => _KlpCalendarDayCellState();
}
