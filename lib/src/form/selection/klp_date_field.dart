import '../internal/klp_form_dependencies.dart';
import 'klp_calendar.dart';

/// [KlpDateField] 掛上月曆挑選面板所需的設定。**這是唯一的日曆狀態來源**——
/// 月份、選取日期、停用規則全部由呼叫端持有並傳入，欄位本身不記憶任何日期。
///
/// 提供這個物件時，欄位右側會出現月曆圖示，點擊會展開 [KlpCalendar]；不提供
/// 就退化為單純文字輸入（[KlpDateField] 抽取自 Planist 時的原始行為）。
@immutable
class KlpDateFieldCalendar {
	const KlpDateFieldCalendar({
		required this.month,
		required this.monthLabel,
		required this.weekdayLabels,
		required this.previousMonthLabel,
		required this.nextMonthLabel,
		required this.onDateSelected,
		this.selectedDate,
		this.isDateDisabled,
		this.onPreviousMonth,
		this.onNextMonth,
		this.today,
	});

	/// 面板目前顯示的月份，轉發給 [KlpCalendar.month]。
	final DateTime month;
	final String monthLabel;
	final List<String> weekdayLabels;
	final String previousMonthLabel;
	final String nextMonthLabel;
	final DateTime? selectedDate;
	final DateTime? today;
	final bool Function(DateTime date)? isDateDisabled;

	/// 使用者在面板上點了某一天。欄位會在轉發這個回呼之後自行收起面板。
	final ValueChanged<DateTime> onDateSelected;
	final VoidCallback? onPreviousMonth;
	final VoidCallback? onNextMonth;
}
/// 日期輸入欄位。文字輸入永遠可用；提供 [calendar] 時額外接上 [KlpCalendar]
/// 作為挑選面板，兩套輸入路徑共用同一個文字結果，不是各自獨立的兩個元件。
class KlpDateField extends StatefulWidget {
	const KlpDateField({
		super.key,
		required this.label,
		required this.value,
		required this.onChanged,
		this.placeholder,
		this.calendar,
	});

	final String label;
	final String value;
	final ValueChanged<String>? onChanged;
	final String? placeholder;

	/// 月曆挑選面板的設定；`null` 時欄位維持純文字輸入。
	final KlpDateFieldCalendar? calendar;

	@override
	State<KlpDateField> createState() => _KlpDateFieldState();
}
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

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Row(
					crossAxisAlignment: CrossAxisAlignment.end,
					children: [
						Expanded(
							child: GestureDetector(
								behavior: HitTestBehavior.opaque,
								onTap: () => setState(() => _expanded = !_expanded),
								child: AbsorbPointer(child: field),
							),
						),
					],
				),
				if (_expanded) ...[
					SizedBox(height: context.klp.space.tight),
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
