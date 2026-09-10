part of '../klp_calendar.dart';

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
