import 'package:flutter/widgets.dart';

import '../controls/klp_icon_button.dart';
import '../foundation/klp_icons.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 月曆的選取模式：單日或區間。
enum KlpCalendarSelectionMode { single, range }

/// 一段日期區間，用於 [KlpCalendarSelectionMode.range]。
///
/// [end] 為 `null` 表示只選了起點、尚未選終點——這時 [contains] 只有 [start]
/// 本身算落在區間內。
@immutable
class KlpCalendarRange {
  const KlpCalendarRange({required this.start, this.end});

  final DateTime start;
  final DateTime? end;

  /// [date] 是否落在（含端點）目前的區間內。[start] 與 [end] 先後顛倒時會自動校正。
  bool contains(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final startDay = DateTime(start.year, start.month, start.day);
    final endValue = end;
    if (endValue == null) return day == startDay;
    final endDay = DateTime(endValue.year, endValue.month, endValue.day);
    final lo = startDay.isAfter(endDay) ? endDay : startDay;
    final hi = startDay.isAfter(endDay) ? startDay : endDay;
    return !day.isBefore(lo) && !day.isAfter(hi);
  }
}

/// 月曆面板：月份切換、日期格、今天標記、選取狀態，並可停用特定日期。
///
/// **這是純顯示元件，不持有任何日期狀態**——目前顯示的月份、選取的日期都由呼叫端
/// 透過 [month]、[selectedDate]／[selectedRange] 傳入，切換月份與選日期一律經
/// [onPreviousMonth]／[onNextMonth]／[onDateSelected] 回呼，由呼叫端決定下一步狀態。
///
/// **不內建任何語言字串。** 月份標題（[monthLabel]）與星期縮寫（[weekdayLabels]）
/// 一律由呼叫端組出——本庫沒有 l10n 機制，不替產品決定用哪種語言、哪一天是一週的
/// 開始（見 [firstWeekday]）。
class KlpCalendar extends StatelessWidget {
  const KlpCalendar({
    super.key,
    required this.month,
    required this.monthLabel,
    required this.weekdayLabels,
    required this.previousMonthLabel,
    required this.nextMonthLabel,
    this.mode = KlpCalendarSelectionMode.single,
    this.selectedDate,
    this.selectedRange,
    this.today,
    this.isDateDisabled,
    this.onDateSelected,
    this.onPreviousMonth,
    this.onNextMonth,
    this.firstWeekday = DateTime.monday,
  }) : assert(
         weekdayLabels.length == 7,
         'weekdayLabels 必須剛好 7 個，對應一週七天。',
       );

  /// 目前顯示的月份；只有年與月有意義，日的部分會被忽略。
  final DateTime month;

  /// 月份標題文字，例如「2026 年 8 月」——由呼叫端組出。
  final String monthLabel;

  /// 星期縮寫，長度必須是 7，順序須對齊從 [firstWeekday] 起算的一週。
  final List<String> weekdayLabels;

  /// 「上一個月」按鈕的無障礙標籤。
  final String previousMonthLabel;

  /// 「下一個月」按鈕的無障礙標籤。
  final String nextMonthLabel;

  /// 單日或區間選取。
  final KlpCalendarSelectionMode mode;

  /// [KlpCalendarSelectionMode.single] 時使用的目前選取日期。
  final DateTime? selectedDate;

  /// [KlpCalendarSelectionMode.range] 時使用的目前選取區間。
  final KlpCalendarRange? selectedRange;

  /// 「今天」標記使用的日期，`null` 表示不畫標記。
  ///
  /// **本元件不會自行呼叫 `DateTime.now()`**——那會讓渲染結果依執行當下時間而異，
  /// golden test 也無法穩定比對；「今天」是誰由呼叫端決定並傳入。
  final DateTime? today;

  /// 判斷某個日期是否停用。回傳 `true` 的日期不可點擊，樣式也會轉為 faint。
  final bool Function(DateTime date)? isDateDisabled;

  /// 使用者點擊某個未停用日期時呼叫。
  final ValueChanged<DateTime>? onDateSelected;

  /// 使用者點擊「上一個月」時呼叫。傳 `null` 停用該按鈕。
  final VoidCallback? onPreviousMonth;

  /// 使用者點擊「下一個月」時呼叫。傳 `null` 停用該按鈕。
  final VoidCallback? onNextMonth;

  /// 一週的第一天，採 `DateTime.monday`（1）～`DateTime.sunday`（7）編碼。
  final int firstWeekday;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final firstOfMonth = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = (firstOfMonth.weekday - firstWeekday) % 7;
    final totalCells = leading + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            KlpIconButton(
              icon: KlpIcons.chevronDown,
              quarterTurns: 1,
              label: previousMonthLabel,
              onPressed: onPreviousMonth,
            ),
            Expanded(
              child: Center(
                child: KlpText(monthLabel, role: KlpTextRole.label),
              ),
            ),
            KlpIconButton(
              icon: KlpIcons.chevronDown,
              quarterTurns: 3,
              label: nextMonthLabel,
              onPressed: onNextMonth,
            ),
          ],
        ),
        SizedBox(height: klp.space.tight),
        Row(
          children: [
            for (final label in weekdayLabels)
              Expanded(
                child: Center(
                  child: KlpText(
                    label,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: klp.space.tight),
        for (var row = 0; row < rowCount; row++) ...[
          if (row > 0) SizedBox(height: klp.space.tight),
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(
                  child: _buildCell(context, row * 7 + col, leading, daysInMonth),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCell(
    BuildContext context,
    int index,
    int leading,
    int daysInMonth,
  ) {
    final dayNumber = index - leading + 1;
    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return SizedBox(height: context.klp.space.controlHeightSmall);
    }

    final date = DateTime(month.year, month.month, dayNumber);
    return _KlpCalendarDayCell(
      label: '$dayNumber',
      selected: _isSelected(date),
      inRange:
          mode == KlpCalendarSelectionMode.range &&
          selectedRange != null &&
          selectedRange!.contains(date),
      isToday: today != null && _isSameDay(date, today!),
      disabled: isDateDisabled?.call(date) ?? false,
      onTap: onDateSelected == null ? null : () => onDateSelected!(date),
    );
  }

  bool _isSelected(DateTime date) {
    if (mode == KlpCalendarSelectionMode.single) {
      return selectedDate != null && _isSameDay(date, selectedDate!);
    }
    final range = selectedRange;
    if (range == null) return false;
    return _isSameDay(date, range.start) ||
        (range.end != null && _isSameDay(date, range.end!));
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _KlpCalendarDayCell extends StatefulWidget {
  const _KlpCalendarDayCell({
    required this.label,
    required this.selected,
    required this.inRange,
    required this.isToday,
    required this.disabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool inRange;
  final bool isToday;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  State<_KlpCalendarDayCell> createState() => _KlpCalendarDayCellState();
}

class _KlpCalendarDayCellState extends State<_KlpCalendarDayCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final interactive = !widget.disabled && widget.onTap != null;

    final background = widget.selected
        ? tokens.selectionBackground
        : widget.inRange
        ? klp.selectionWash
        : null;

    Widget cell = Container(
      height: klp.space.controlHeightSmall,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(klp.shape.control),
        border: widget.isToday && !widget.selected
            ? Border.all(color: tokens.accent, width: klp.shape.hairline)
            : null,
      ),
      child: KlpText(
        widget.label,
        role: KlpTextRole.caption,
        tone: widget.disabled ? KlpTextTone.faint : KlpTextTone.automatic,
        color: widget.selected ? tokens.onSelection : null,
      ),
    );

    if (_hovered && interactive) {
      // 不傳 color——預設就是 guide 疊 dashedOpacity，與 hoverBorder 的算法相同。
      cell = KlpDashedBorder(radius: klp.shape.control, child: cell);
    }

    return MouseRegion(
      onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
      onExit: interactive ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: interactive ? widget.onTap : null,
        child: Semantics(
          button: true,
          enabled: interactive,
          selected: widget.selected,
          child: cell,
        ),
      ),
    );
  }
}
