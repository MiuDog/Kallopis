part of '../klp_date_field.dart';

/// 持有日期挑選面板的本地展開狀態。
class _KlpDateFieldState extends State<KlpDateField> {
	bool _expanded = false;

	@override
	Widget build(BuildContext context) {
		final calendar = widget.calendar;
		final field = KlpTextField(
			label: widget.label,
			initialValue: widget.value,
			placeholder: widget.placeholder,
			onChanged: widget.onChanged,
			readOnly: calendar != null,
			leadingIcon: calendar == null ? null : KlpIcons.calendar,
		);

		if (calendar == null) {
			return field;
		}

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpGestureRegion(
					behavior: HitTestBehavior.opaque,
					onTap: () => setState(() => _expanded = !_expanded),
					child: KlpPointerBlocker(child: field),
				),
				if (_expanded) ...[
					const KlpGap.heightSize(KlpSpaceSize.tight),
					KlpCalendar(
						month: calendar.month,
						monthLabel: calendar.monthLabel,
						weekdayLabels: calendar.weekdayLabels,
						previousMonthLabel: calendar.previousMonthLabel,
						nextMonthLabel: calendar.nextMonthLabel,
						selectedDate: calendar.selectedDate,
						today: calendar.today,
						isDateDisabled: calendar.isDateDisabled,
						onPreviousMonth: calendar.onPreviousMonth,
						onNextMonth: calendar.onNextMonth,
						onDateSelected: (date) {
							calendar.onDateSelected(date);
							setState(() => _expanded = false);
						},
					),
				],
			],
		);
	}
}
