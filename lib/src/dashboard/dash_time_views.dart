import 'package:flutter/material.dart';

import '../controls/pln_button.dart';
import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'dash_theme.dart';

@immutable
class DashCalendarEvent {
  const DashCalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.subtitle,
    this.allDay = false,
    this.colorIndex = 0,
  });

  final String id;
  final String title;
  final String? subtitle;
  final DateTime start;
  final DateTime end;
  final bool allDay;
  final int colorIndex;
}

@immutable
class DashDayValue {
  const DashDayValue({required this.date, required this.value});

  final DateTime date;
  final double value;
}

@immutable
class DashTimelineRow {
  const DashTimelineRow({
    required this.id,
    required this.label,
    required this.start,
    required this.end,
    this.progress,
    this.milestone = false,
    this.colorIndex = 0,
  });

  final String id;
  final String label;
  final DateTime start;
  final DateTime end;
  final double? progress;
  final bool milestone;
  final int colorIndex;
}

@immutable
class DashTimesheetRow {
  const DashTimesheetRow({
    required this.id,
    required this.label,
    required this.hours,
    this.locked = false,
  });

  final String id;
  final String label;
  final List<double> hours;
  final bool locked;
}

class DashDayCalendar extends StatelessWidget {
  const DashDayCalendar({
    super.key,
    required this.date,
    required this.events,
    this.startHour = 8,
    this.endHour = 20,
    this.onSelectEvent,
    this.onSelectTime,
  });

  final DateTime date;
  final List<DashCalendarEvent> events;
  final int startHour;
  final int endHour;
  final ValueChanged<String>? onSelectEvent;
  final ValueChanged<DateTime>? onSelectTime;

  @override
  Widget build(BuildContext context) {
    final hourCount = (endHour - startHour).clamp(1, 24);
    const hourHeight = 52.0;
    final timedEvents = events.where((event) => !event.allDay).toList();

    return Semantics(
      container: true,
      label: 'Day calendar, ${events.length} events',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (events.any((event) => event.allDay))
            _DashAllDayStrip(
              events: events.where((event) => event.allDay).toList(),
              onSelectEvent: onSelectEvent,
            ),
          SizedBox(
            height: hourCount * hourHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 52,
                  child: Column(
                    children: [
                      for (var hour = startHour; hour < endHour; hour++)
                        SizedBox(
                          height: hourHeight,
                          child: PlnText(
                            _hourLabel(hour),
                            role: PlnTextRole.code,
                            tone: PlnTextTone.faint,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: onSelectTime == null
                          ? null
                          : (details) {
                              final minutes =
                                  (details.localPosition.dy / hourHeight * 60)
                                      .round();
                              onSelectTime!(
                                DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  startHour,
                                ).add(Duration(minutes: minutes)),
                              );
                            },
                      child: Stack(
                        children: [
                          for (var hour = 0; hour <= hourCount; hour++)
                            Positioned(
                              top: hour * hourHeight,
                              left: 0,
                              right: 0,
                              child: Divider(
                                height: 1,
                                color: context.plnTheme.divider,
                              ),
                            ),
                          for (final event in timedEvents)
                            _DashPositionedDayEvent(
                              event: event,
                              startHour: startHour,
                              hourHeight: hourHeight,
                              width: constraints.maxWidth,
                              onSelectEvent: onSelectEvent,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashWeekCalendar extends StatelessWidget {
  const DashWeekCalendar({
    super.key,
    required this.weekStart,
    required this.events,
    this.onSelectEvent,
    this.onSelectDay,
  });

  final DateTime weekStart;
  final List<DashCalendarEvent> events;
  final ValueChanged<String>? onSelectEvent;
  final ValueChanged<DateTime>? onSelectDay;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Week calendar, ${events.length} events',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var dayIndex = 0; dayIndex < 7; dayIndex++)
            Expanded(
              child: _DashWeekDay(
                date: weekStart.add(Duration(days: dayIndex)),
                events: events
                    .where(
                      (event) => _sameDay(
                        event.start,
                        weekStart.add(Duration(days: dayIndex)),
                      ),
                    )
                    .toList(),
                onSelectEvent: onSelectEvent,
                onSelectDay: onSelectDay,
              ),
            ),
        ],
      ),
    );
  }
}

class DashMonthCalendar extends StatelessWidget {
  const DashMonthCalendar({
    super.key,
    required this.month,
    required this.events,
    this.onSelectEvent,
    this.onSelectDay,
  });

  final DateTime month;
  final List<DashCalendarEvent> events;
  final ValueChanged<String>? onSelectEvent;
  final ValueChanged<DateTime>? onSelectDay;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final offset = first.weekday % 7;
    final dayCount = DateTime(month.year, month.month + 1, 0).day;

    return Semantics(
      container: true,
      label: 'Month calendar, ${events.length} events',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.05,
          crossAxisSpacing: PlnSpace.xs,
          mainAxisSpacing: PlnSpace.xs,
        ),
        itemCount: offset + dayCount,
        itemBuilder: (context, index) {
          if (index < offset) return const SizedBox();
          final date = DateTime(month.year, month.month, index - offset + 1);
          return _DashMonthDay(
            date: date,
            events: events
                .where((event) => _sameDay(event.start, date))
                .toList(),
            onSelectEvent: onSelectEvent,
            onSelectDay: onSelectDay,
          );
        },
      ),
    );
  }
}

class DashHeatCalendar extends StatelessWidget {
  const DashHeatCalendar({
    super.key,
    required this.days,
    this.weeks = 16,
    this.onSelectDay,
  });

  final List<DashDayValue> days;
  final int weeks;
  final ValueChanged<DateTime>? onSelectDay;

  @override
  Widget build(BuildContext context) {
    final visible = days.length > weeks * 7
        ? days.sublist(days.length - weeks * 7)
        : days;
    final maxValue = visible.isEmpty
        ? 1.0
        : visible
              .map((day) => day.value.abs())
              .fold<double>(
                1,
                (maximum, value) => value > maximum ? value : maximum,
              );

    return Semantics(
      container: true,
      label: 'Activity heat calendar, ${visible.length} days',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var week = 0; week < (visible.length / 7).ceil(); week++)
              Padding(
                padding: const EdgeInsets.only(right: PlnSpace.xs),
                child: Column(
                  children: [
                    for (var day = 0; day < 7; day++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: PlnSpace.xs),
                        child: week * 7 + day >= visible.length
                            ? const SizedBox(width: 14, height: 14)
                            : _DashHeatDay(
                                day: visible[week * 7 + day],
                                ratio:
                                    visible[week * 7 + day].value.abs() /
                                    maxValue,
                                onSelectDay: onSelectDay,
                              ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DashAgendaList extends StatelessWidget {
  const DashAgendaList({super.key, required this.events, this.onSelectEvent});

  final List<DashCalendarEvent> events;
  final ValueChanged<String>? onSelectEvent;

  @override
  Widget build(BuildContext context) {
    final sorted = [...events]..sort((a, b) => a.start.compareTo(b.start));

    return Semantics(
      container: true,
      label: 'Agenda, ${events.length} events',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < sorted.length; index++) ...[
            if (index == 0 ||
                !_sameDay(sorted[index - 1].start, sorted[index].start))
              Padding(
                padding: const EdgeInsets.only(
                  top: PlnSpace.md,
                  bottom: PlnSpace.xs,
                ),
                child: PlnText(
                  _dateLabel(sorted[index].start),
                  role: PlnTextRole.label,
                  tone: PlnTextTone.muted,
                ),
              ),
            _DashAgendaEvent(
              event: sorted[index],
              onPressed: onSelectEvent == null
                  ? null
                  : () => onSelectEvent!(sorted[index].id),
            ),
          ],
        ],
      ),
    );
  }
}

class DashTimelineGantt extends StatelessWidget {
  const DashTimelineGantt({
    super.key,
    required this.windowStart,
    required this.windowEnd,
    required this.rows,
    this.onSelectRow,
  });

  final DateTime windowStart;
  final DateTime windowEnd;
  final List<DashTimelineRow> rows;
  final ValueChanged<String>? onSelectRow;

  @override
  Widget build(BuildContext context) {
    final minutes = windowEnd
        .difference(windowStart)
        .inMinutes
        .clamp(1, 1 << 31);

    return Semantics(
      container: true,
      label: 'Gantt timeline, ${rows.length} rows',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in rows)
            _DashGanttRow(
              row: row,
              windowStart: windowStart,
              windowMinutes: minutes,
              onPressed: onSelectRow == null
                  ? null
                  : () => onSelectRow!(row.id),
            ),
        ],
      ),
    );
  }
}

class DashTimerWidget extends StatelessWidget {
  const DashTimerWidget({
    super.key,
    required this.elapsed,
    this.entryLabel,
    this.running = false,
    this.onStart,
    this.onStop,
    this.onDiscard,
  });

  final Duration elapsed;
  final String? entryLabel;
  final bool running;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onDiscard;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: const EdgeInsets.all(PlnSpace.lg),
      decoration: BoxDecoration(
        color: context.plnTheme.component,
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: PlnText(
                  entryLabel ?? 'No active entry',
                  role: PlnTextRole.bodyStrong,
                ),
              ),
              if (running)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: context.plnTheme.interaction,
                    borderRadius: BorderRadius.circular(PlnRadius.full),
                  ),
                ),
            ],
          ),
          const SizedBox(height: PlnSpace.md),
          PlnText(
            _durationLabel(elapsed),
            role: PlnTextRole.display,
            textAlign: TextAlign.center,
          ),
          if (onStart != null || onStop != null || onDiscard != null) ...[
            const SizedBox(height: PlnSpace.md),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: PlnSpace.sm,
              children: [
                if (!running && onStart != null)
                  PlnButton(
                    label: 'Start',
                    tone: PlnButtonTone.primary,
                    onPressed: onStart,
                  ),
                if (running && onStop != null)
                  PlnButton(
                    label: 'Stop',
                    tone: PlnButtonTone.primary,
                    onPressed: onStop,
                  ),
                if (onDiscard != null)
                  PlnButton(
                    label: 'Discard',
                    tone: PlnButtonTone.ghost,
                    onPressed: onDiscard,
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    return Semantics(
      container: true,
      liveRegion: running,
      label:
          '${running ? 'Running' : 'Stopped'} timer, '
          '${entryLabel ?? 'no active entry'}, ${_durationLabel(elapsed)}',
      child: ExcludeSemantics(child: body),
    );
  }
}

class DashTimesheetTable extends StatelessWidget {
  const DashTimesheetTable({
    super.key,
    required this.weekStart,
    required this.rows,
    this.submitted = false,
    this.onEditHours,
    this.onSubmit,
  });

  final DateTime weekStart;
  final List<DashTimesheetRow> rows;
  final bool submitted;
  final void Function(String rowId, int dayIndex)? onEditHours;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final dayTotals = List<double>.generate(
      7,
      (day) => rows.fold<double>(
        0,
        (sum, row) => sum + (day < row.hours.length ? row.hours[day] : 0),
      ),
    );

    return Semantics(
      container: true,
      label:
          'Timesheet, ${rows.length} entries, '
          '${dayTotals.fold<double>(0, (sum, value) => sum + value)} hours',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 720,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DashTimesheetHeader(weekStart: weekStart),
              for (final row in rows)
                _DashTimesheetDataRow(
                  row: row,
                  submitted: submitted,
                  onEditHours: onEditHours,
                ),
              _DashTimesheetTotalRow(totals: dayTotals),
              if (onSubmit != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: PlnSpace.md),
                    child: PlnButton(
                      label: submitted ? 'Submitted' : 'Submit week',
                      tone: PlnButtonTone.primary,
                      onPressed: submitted ? null : onSubmit,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashAllDayStrip extends StatelessWidget {
  const _DashAllDayStrip({required this.events, this.onSelectEvent});

  final List<DashCalendarEvent> events;
  final ValueChanged<String>? onSelectEvent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PlnSpace.sm),
      child: Wrap(
        spacing: PlnSpace.xs,
        runSpacing: PlnSpace.xs,
        children: [
          for (final event in events)
            _DashEventChip(
              event: event,
              onPressed: onSelectEvent == null
                  ? null
                  : () => onSelectEvent!(event.id),
            ),
        ],
      ),
    );
  }
}

class _DashPositionedDayEvent extends StatelessWidget {
  const _DashPositionedDayEvent({
    required this.event,
    required this.startHour,
    required this.hourHeight,
    required this.width,
    this.onSelectEvent,
  });

  final DashCalendarEvent event;
  final int startHour;
  final double hourHeight;
  final double width;
  final ValueChanged<String>? onSelectEvent;

  @override
  Widget build(BuildContext context) {
    final startMinutes =
        event.start.hour * 60 + event.start.minute - startHour * 60;
    final durationMinutes = event.end
        .difference(event.start)
        .inMinutes
        .clamp(15, 1440);
    return Positioned(
      top: startMinutes / 60 * hourHeight,
      left: PlnSpace.xs,
      width: width - PlnSpace.sm,
      height: durationMinutes / 60 * hourHeight,
      child: _DashEventChip(
        event: event,
        expanded: true,
        onPressed: onSelectEvent == null
            ? null
            : () => onSelectEvent!(event.id),
      ),
    );
  }
}

class _DashEventChip extends StatelessWidget {
  const _DashEventChip({
    required this.event,
    this.expanded = false,
    this.onPressed,
  });

  final DashCalendarEvent event;
  final bool expanded;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dataTokens = context.plnDataVisualizationTheme;
    final body = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PlnSpace.sm,
        vertical: PlnSpace.xs,
      ),
      decoration: BoxDecoration(
        color: dataTokens.seriesWashColor(event.colorIndex),
        borderRadius: BorderRadius.circular(PlnRadius.sm),
        border: Border(
          left: BorderSide(
            color: dataTokens.seriesColor(event.colorIndex),
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlnText(
            event.title,
            role: PlnTextRole.caption,
            maxLines: expanded ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (expanded)
            PlnText(
              '${_timeLabel(event.start)}–${_timeLabel(event.end)}',
              role: PlnTextRole.code,
              tone: PlnTextTone.muted,
            ),
        ],
      ),
    );
    return Semantics(
      button: onPressed != null,
      label:
          '${event.title}, ${_timeLabel(event.start)} to ${_timeLabel(event.end)}',
      child: onPressed == null
          ? body
          : PlnPressable(onPressed: onPressed, child: body),
    );
  }
}

class _DashWeekDay extends StatelessWidget {
  const _DashWeekDay({
    required this.date,
    required this.events,
    this.onSelectEvent,
    this.onSelectDay,
  });

  final DateTime date;
  final List<DashCalendarEvent> events;
  final ValueChanged<String>? onSelectEvent;
  final ValueChanged<DateTime>? onSelectDay;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(PlnSpace.xs),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: context.plnTheme.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PlnText(
            '${date.day}',
            role: PlnTextRole.code,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PlnSpace.xs),
          for (final event in events.take(4)) ...[
            _DashEventChip(
              event: event,
              onPressed: onSelectEvent == null
                  ? null
                  : () => onSelectEvent!(event.id),
            ),
            const SizedBox(height: PlnSpace.xs),
          ],
          if (events.length > 4)
            PlnText(
              '+${events.length - 4}',
              role: PlnTextRole.caption,
              tone: PlnTextTone.faint,
            ),
        ],
      ),
    );
    return onSelectDay == null
        ? body
        : PlnPressable(onPressed: () => onSelectDay!(date), child: body);
  }
}

class _DashMonthDay extends StatelessWidget {
  const _DashMonthDay({
    required this.date,
    required this.events,
    this.onSelectEvent,
    this.onSelectDay,
  });

  final DateTime date;
  final List<DashCalendarEvent> events;
  final ValueChanged<String>? onSelectEvent;
  final ValueChanged<DateTime>? onSelectDay;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: const EdgeInsets.all(PlnSpace.xs),
      color: context.plnTheme.surfaceInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlnText('${date.day}', role: PlnTextRole.code),
          for (final event in events.take(2))
            Padding(
              padding: const EdgeInsets.only(top: PlnSpace.xxs),
              child: _DashEventChip(
                event: event,
                onPressed: onSelectEvent == null
                    ? null
                    : () => onSelectEvent!(event.id),
              ),
            ),
          if (events.length > 2)
            PlnText(
              '+${events.length - 2}',
              role: PlnTextRole.caption,
              tone: PlnTextTone.faint,
            ),
        ],
      ),
    );
    return onSelectDay == null
        ? body
        : PlnPressable(onPressed: () => onSelectDay!(date), child: body);
  }
}

class _DashHeatDay extends StatelessWidget {
  const _DashHeatDay({
    required this.day,
    required this.ratio,
    this.onSelectDay,
  });

  final DashDayValue day;
  final double ratio;
  final ValueChanged<DateTime>? onSelectDay;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: Color.lerp(
          context.plnDataVisualizationTheme.seriesWashColor(0),
          context.plnDataVisualizationTheme.seriesColor(0),
          ratio.clamp(0, 1),
        ),
        borderRadius: BorderRadius.circular(PlnRadius.sm),
      ),
    );
    return Semantics(
      button: onSelectDay != null,
      label: '${_dateLabel(day.date)}, ${day.value}',
      child: onSelectDay == null
          ? body
          : PlnPressable(onPressed: () => onSelectDay!(day.date), child: body),
    );
  }
}

class _DashAgendaEvent extends StatelessWidget {
  const _DashAgendaEvent({required this.event, this.onPressed});

  final DashCalendarEvent event;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.symmetric(vertical: PlnSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: PlnText(
              event.allDay ? 'All day' : _timeLabel(event.start),
              role: PlnTextRole.code,
              tone: PlnTextTone.muted,
            ),
          ),
          Container(
            width: 3,
            height: 34,
            color: context.plnDataVisualizationTheme.seriesColor(
              event.colorIndex,
            ),
          ),
          const SizedBox(width: PlnSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlnText(event.title, role: PlnTextRole.bodyStrong),
                if (event.subtitle != null)
                  PlnText(
                    event.subtitle!,
                    role: PlnTextRole.caption,
                    tone: PlnTextTone.muted,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    return onPressed == null
        ? body
        : PlnPressable(onPressed: onPressed, child: body);
  }
}

class _DashGanttRow extends StatelessWidget {
  const _DashGanttRow({
    required this.row,
    required this.windowStart,
    required this.windowMinutes,
    this.onPressed,
  });

  final DashTimelineRow row;
  final DateTime windowStart;
  final int windowMinutes;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final left = row.start.difference(windowStart).inMinutes / windowMinutes;
    final width = row.end.difference(row.start).inMinutes / windowMinutes;
    final dataTokens = context.plnDataVisualizationTheme;
    final content = SizedBox(
      height: 42,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: PlnText(
              row.label,
              role: PlnTextRole.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final x = left.clamp(0, 1).toDouble() * constraints.maxWidth;
                final barWidth = (width.clamp(0.015, 1) * constraints.maxWidth)
                    .clamp(4, constraints.maxWidth)
                    .toDouble();
                return Stack(
                  children: [
                    Positioned(
                      left: x,
                      width: barWidth,
                      top: PlnSpace.sm,
                      bottom: PlnSpace.sm,
                      child: row.milestone
                          ? Center(
                              child: Transform.rotate(
                                angle: 0.785398,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  color: dataTokens.seriesColor(row.colorIndex),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: dataTokens.seriesWashColor(
                                  row.colorIndex,
                                ),
                                borderRadius: BorderRadius.circular(
                                  PlnRadius.sm,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: row.progress?.clamp(0, 1) ?? 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: dataTokens.seriesColor(
                                      row.colorIndex,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      PlnRadius.sm,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
    return Semantics(
      button: onPressed != null,
      label: '${row.label}, ${_dateLabel(row.start)} to ${_dateLabel(row.end)}',
      child: onPressed == null
          ? content
          : PlnPressable(onPressed: onPressed, child: content),
    );
  }
}

class _DashTimesheetHeader extends StatelessWidget {
  const _DashTimesheetHeader({required this.weekStart});

  final DateTime weekStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.plnTheme.surfaceInset,
      child: Row(
        children: [
          const _DashTimesheetCell(
            width: 180,
            child: PlnText(
              'Entry',
              role: PlnTextRole.label,
              tone: PlnTextTone.muted,
            ),
          ),
          for (var day = 0; day < 7; day++)
            _DashTimesheetCell(
              child: PlnText(
                '${weekStart.add(Duration(days: day)).day}',
                role: PlnTextRole.code,
              ),
            ),
          const _DashTimesheetCell(
            child: PlnText('Total', role: PlnTextRole.label),
          ),
        ],
      ),
    );
  }
}

class _DashTimesheetDataRow extends StatelessWidget {
  const _DashTimesheetDataRow({
    required this.row,
    required this.submitted,
    this.onEditHours,
  });

  final DashTimesheetRow row;
  final bool submitted;
  final void Function(String rowId, int dayIndex)? onEditHours;

  @override
  Widget build(BuildContext context) {
    final total = row.hours.fold<double>(0, (sum, value) => sum + value);
    return Row(
      children: [
        _DashTimesheetCell(
          width: 180,
          child: Row(
            children: [
              Expanded(
                child: PlnText(
                  row.label,
                  role: PlnTextRole.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (row.locked)
                const PlnText(
                  'LOCKED',
                  role: PlnTextRole.label,
                  tone: PlnTextTone.faint,
                ),
            ],
          ),
        ),
        for (var day = 0; day < 7; day++)
          _DashTimesheetCell(
            child: _DashHourValue(
              value: day < row.hours.length ? row.hours[day] : 0,
              onPressed: submitted || row.locked || onEditHours == null
                  ? null
                  : () => onEditHours!(row.id, day),
            ),
          ),
        _DashTimesheetCell(
          child: PlnText(_hoursLabel(total), role: PlnTextRole.code),
        ),
      ],
    );
  }
}

class _DashTimesheetTotalRow extends StatelessWidget {
  const _DashTimesheetTotalRow({required this.totals});

  final List<double> totals;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.plnTheme.surfaceInset,
      child: Row(
        children: [
          const _DashTimesheetCell(
            width: 180,
            child: PlnText('Total', role: PlnTextRole.bodyStrong),
          ),
          for (final total in totals)
            _DashTimesheetCell(
              child: PlnText(_hoursLabel(total), role: PlnTextRole.code),
            ),
          _DashTimesheetCell(
            child: PlnText(
              _hoursLabel(totals.fold<double>(0, (sum, value) => sum + value)),
              role: PlnTextRole.code,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashTimesheetCell extends StatelessWidget {
  const _DashTimesheetCell({required this.child, this.width = 67.5});

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: PlnSpace.xs),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.plnTheme.divider)),
      ),
      child: child,
    );
  }
}

class _DashHourValue extends StatelessWidget {
  const _DashHourValue({required this.value, this.onPressed});

  final double value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = PlnText(_hoursLabel(value), role: PlnTextRole.code);
    if (onPressed == null) return label;
    return PlnPressable(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: PlnSpace.xs),
        child: label,
      ),
    );
  }
}

String _hourLabel(int hour) => '${hour.toString().padLeft(2, '0')}:00';

String _timeLabel(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';
}

String _dateLabel(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

String _durationLabel(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}

String _hoursLabel(double hours) {
  return hours == hours.roundToDouble()
      ? hours.toStringAsFixed(0)
      : hours.toStringAsFixed(1);
}

bool _sameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
