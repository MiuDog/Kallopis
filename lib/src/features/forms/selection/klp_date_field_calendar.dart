import '../internal/klp_form_dependencies.dart';
import 'klp_calendar.dart';
import 'klp_date_field.dart';

/// [KlpDateField] 掛上月曆挑選面板所需的受控設定。
///
/// 月份、選取日期、停用規則全部由呼叫端持有並傳入，欄位本身不記憶任何日期。
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
