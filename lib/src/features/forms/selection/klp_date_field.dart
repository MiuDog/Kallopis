import '../internal/klp_form_dependencies.dart';
import '../../../foundation/interaction/primitives/klp_pointer_blocker.dart';
import 'klp_calendar.dart';
import 'klp_date_field_calendar.dart';

part 'internal/klp_date_field_state.dart';

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
