import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'dash_charts.dart';

enum DashRecordFieldKind { text, number, status, date, person }

@immutable
class DashRecordField {
  const DashRecordField({
    required this.id,
    required this.label,
    this.kind = DashRecordFieldKind.text,
    this.width = 140,
  });

  final String id;
  final String label;
  final DashRecordFieldKind kind;
  final double width;
}

@immutable
class DashRecord {
  const DashRecord({
    required this.id,
    required this.title,
    required this.values,
    this.subtitle,
    this.groupId,
    this.start,
    this.end,
    this.colorIndex = 0,
    this.selected = false,
  });

  final String id;
  final String title;
  final String? subtitle;
  final Map<String, Object?> values;
  final String? groupId;
  final DateTime? start;
  final DateTime? end;
  final int colorIndex;
  final bool selected;
}

@immutable
class DashBoardColumn {
  const DashBoardColumn({required this.id, required this.label, this.limit});

  final String id;
  final String label;
  final int? limit;
}

class DashTableView extends StatelessWidget {
  const DashTableView({
    super.key,
    required this.fields,
    required this.records,
    this.sortFieldId,
    this.sortAscending = true,
    this.onSelectRecord,
    this.onSort,
  });

  final List<DashRecordField> fields;
  final List<DashRecord> records;
  final String? sortFieldId;
  final bool sortAscending;
  final ValueChanged<String>? onSelectRecord;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final width =
        220 + fields.fold<double>(0, (sum, field) => sum + field.width);

    return Semantics(
      container: true,
      label: 'Table view, ${records.length} records, ${fields.length} fields',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: tokens.surfaceInset,
                child: Row(
                  children: [
                    _DashTableCell(
                      width: 220,
                      child: const PlnText(
                        'Record',
                        role: PlnTextRole.label,
                        tone: PlnTextTone.muted,
                      ),
                    ),
                    for (final field in fields)
                      _DashTableCell(
                        width: field.width,
                        child: _DashSortableHeader(
                          field: field,
                          sorted: sortFieldId == field.id,
                          ascending: sortAscending,
                          onSort: onSort,
                        ),
                      ),
                  ],
                ),
              ),
              for (final record in records)
                _DashRecordRow(
                  fields: fields,
                  record: record,
                  onPressed: onSelectRecord == null
                      ? null
                      : () => onSelectRecord!(record.id),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashBoardView extends StatelessWidget {
  const DashBoardView({
    super.key,
    required this.columns,
    required this.records,
    this.onSelectRecord,
  });

  final List<DashBoardColumn> columns;
  final List<DashRecord> records;
  final ValueChanged<String>? onSelectRecord;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Board view, ${columns.length} columns, ${records.length} records',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final column in columns) ...[
              SizedBox(
                width: 252,
                child: _DashBoardLane(
                  column: column,
                  records: records
                      .where((record) => record.groupId == column.id)
                      .toList(),
                  onSelectRecord: onSelectRecord,
                ),
              ),
              const SizedBox(width: PlnSpace.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class DashListView extends StatelessWidget {
  const DashListView({
    super.key,
    required this.fields,
    required this.records,
    this.onSelectRecord,
  });

  final List<DashRecordField> fields;
  final List<DashRecord> records;
  final ValueChanged<String>? onSelectRecord;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'List view, ${records.length} records',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final record in records)
            _DashRecordListTile(
              record: record,
              fields: fields.take(3).toList(),
              onPressed: onSelectRecord == null
                  ? null
                  : () => onSelectRecord!(record.id),
            ),
        ],
      ),
    );
  }
}

class DashGalleryView extends StatelessWidget {
  const DashGalleryView({
    super.key,
    required this.fields,
    required this.records,
    this.minimumCardWidth = 200,
    this.onSelectRecord,
  });

  final List<DashRecordField> fields;
  final List<DashRecord> records;
  final double minimumCardWidth;
  final ValueChanged<String>? onSelectRecord;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Gallery view, ${records.length} records',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = (constraints.maxWidth / minimumCardWidth)
              .floor()
              .clamp(1, 6);
          final width =
              (constraints.maxWidth - PlnSpace.sm * (columns - 1)) / columns;

          return Wrap(
            spacing: PlnSpace.sm,
            runSpacing: PlnSpace.sm,
            children: [
              for (final record in records)
                SizedBox(
                  width: width,
                  child: _DashRecordCard(
                    record: record,
                    fields: fields.take(3).toList(),
                    onPressed: onSelectRecord == null
                        ? null
                        : () => onSelectRecord!(record.id),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class DashFeedView extends StatelessWidget {
  const DashFeedView({
    super.key,
    required this.records,
    this.actorFieldId = 'actor',
    this.actionFieldId = 'action',
    this.timeFieldId = 'time',
    this.onSelectRecord,
  });

  final List<DashRecord> records;
  final String actorFieldId;
  final String actionFieldId;
  final String timeFieldId;
  final ValueChanged<String>? onSelectRecord;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: 'Activity feed, ${records.length} entries',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final record in records)
            _DashFeedEntry(
              record: record,
              actor: _valueLabel(record.values[actorFieldId]),
              action: _valueLabel(record.values[actionFieldId]),
              time: _valueLabel(record.values[timeFieldId]),
              onPressed: onSelectRecord == null
                  ? null
                  : () => onSelectRecord!(record.id),
            ),
        ],
      ),
    );
  }
}

class DashChartView extends StatelessWidget {
  const DashChartView({
    super.key,
    required this.records,
    required this.categoryFieldId,
    this.valueFieldId,
    this.height = 240,
    this.onSelectCategory,
  });

  final List<DashRecord> records;
  final String categoryFieldId;
  final String? valueFieldId;
  final double height;
  final ValueChanged<String>? onSelectCategory;

  @override
  Widget build(BuildContext context) {
    final totals = <String, double>{};
    for (final record in records) {
      final category = _valueLabel(record.values[categoryFieldId]);
      final rawValue = valueFieldId == null ? 1 : record.values[valueFieldId];
      final value = rawValue is num ? rawValue.toDouble() : 1.0;
      totals.update(category, (total) => total + value, ifAbsent: () => value);
    }
    final categories = totals.keys.toList();

    return DashColumnChart(
      categories: categories,
      height: height,
      series: [
        DashChartSeries(
          id: 'records',
          label: 'Records',
          values: [for (final category in categories) totals[category] ?? 0],
        ),
      ],
      onSelectCategory: onSelectCategory == null || categories.isEmpty
          ? null
          : (index) => onSelectCategory!(categories[index % categories.length]),
    );
  }
}

class DashCalendarView extends StatelessWidget {
  const DashCalendarView({
    super.key,
    required this.records,
    this.month,
    this.onSelectDay,
    this.onSelectRecord,
  });

  final List<DashRecord> records;
  final DateTime? month;
  final ValueChanged<DateTime>? onSelectDay;
  final ValueChanged<String>? onSelectRecord;

  @override
  Widget build(BuildContext context) {
    final visibleMonth =
        month ??
        (records.where((record) => record.start != null).firstOrNull?.start ??
            DateTime.now());
    final first = DateTime(visibleMonth.year, visibleMonth.month);
    final startOffset = first.weekday % 7;
    final days = DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;

    return Semantics(
      container: true,
      label: 'Calendar view, ${records.length} records',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.15,
          crossAxisSpacing: PlnSpace.xs,
          mainAxisSpacing: PlnSpace.xs,
        ),
        itemCount: startOffset + days,
        itemBuilder: (context, index) {
          if (index < startOffset) return const SizedBox();
          final date = DateTime(
            visibleMonth.year,
            visibleMonth.month,
            index - startOffset + 1,
          );
          final dayRecords = records
              .where((record) => _sameDay(record.start, date))
              .toList();
          return _DashCalendarCell(
            date: date,
            records: dayRecords,
            onSelectDay: onSelectDay,
            onSelectRecord: onSelectRecord,
          );
        },
      ),
    );
  }
}

class DashTimelineView extends StatelessWidget {
  const DashTimelineView({
    super.key,
    required this.records,
    this.windowStart,
    this.windowEnd,
    this.onSelectRecord,
  });

  final List<DashRecord> records;
  final DateTime? windowStart;
  final DateTime? windowEnd;
  final ValueChanged<String>? onSelectRecord;

  @override
  Widget build(BuildContext context) {
    final dated = records.where((record) => record.start != null).toList();
    final start =
        windowStart ??
        dated.map((record) => record.start!).reduceOrNull(_earlier) ??
        DateTime.now();
    final end =
        windowEnd ??
        dated
            .map((record) => record.end ?? record.start!)
            .reduceOrNull(_later) ??
        start.add(const Duration(days: 1));
    final duration = end.difference(start).inMinutes.clamp(1, 1 << 31);

    return Semantics(
      container: true,
      label: 'Timeline view, ${records.length} records',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final record in records)
            _DashTimelineRecord(
              record: record,
              windowStart: start,
              durationMinutes: duration,
              onPressed: onSelectRecord == null
                  ? null
                  : () => onSelectRecord!(record.id),
            ),
        ],
      ),
    );
  }
}

class _DashTableCell extends StatelessWidget {
  const _DashTableCell({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 38),
      padding: const EdgeInsets.symmetric(
        horizontal: PlnSpace.sm,
        vertical: PlnSpace.xs,
      ),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.plnTheme.divider)),
      ),
      child: child,
    );
  }
}

class _DashSortableHeader extends StatelessWidget {
  const _DashSortableHeader({
    required this.field,
    required this.sorted,
    required this.ascending,
    required this.onSort,
  });

  final DashRecordField field;
  final bool sorted;
  final bool ascending;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    final label = PlnText(
      sorted ? '${field.label} ${ascending ? '↑' : '↓'}' : field.label,
      role: PlnTextRole.label,
      tone: PlnTextTone.muted,
    );
    return onSort == null
        ? label
        : PlnPressable(
            onPressed: () => onSort!(field.id),
            child: Semantics(button: true, child: label),
          );
  }
}

class _DashRecordRow extends StatelessWidget {
  const _DashRecordRow({
    required this.fields,
    required this.record,
    this.onPressed,
  });

  final List<DashRecordField> fields;
  final DashRecord record;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        _DashTableCell(
          width: 220,
          child: PlnText(record.title, role: PlnTextRole.bodyStrong),
        ),
        for (final field in fields)
          _DashTableCell(
            width: field.width,
            child: PlnText(
              _valueLabel(record.values[field.id]),
              role: field.kind == DashRecordFieldKind.number
                  ? PlnTextRole.code
                  : PlnTextRole.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
    final selected = record.selected
        ? ColoredBox(color: context.plnTheme.selectionBackground, child: row)
        : row;
    return onPressed == null
        ? selected
        : PlnPressable(onPressed: onPressed, child: selected);
  }
}

class _DashBoardLane extends StatelessWidget {
  const _DashBoardLane({
    required this.column,
    required this.records,
    this.onSelectRecord,
  });

  final DashBoardColumn column;
  final List<DashRecord> records;
  final ValueChanged<String>? onSelectRecord;

  @override
  Widget build(BuildContext context) {
    final overLimit = column.limit != null && records.length > column.limit!;
    return Container(
      padding: const EdgeInsets.all(PlnSpace.sm),
      decoration: BoxDecoration(
        color: context.plnTheme.surfaceInset,
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: PlnText(column.label, role: PlnTextRole.bodyStrong),
              ),
              PlnText(
                column.limit == null
                    ? '${records.length}'
                    : '${records.length}/${column.limit}',
                role: PlnTextRole.code,
                color: overLimit ? context.plnTheme.danger : null,
              ),
            ],
          ),
          const SizedBox(height: PlnSpace.sm),
          for (final record in records) ...[
            _DashRecordCard(
              record: record,
              fields: const [],
              onPressed: onSelectRecord == null
                  ? null
                  : () => onSelectRecord!(record.id),
            ),
            const SizedBox(height: PlnSpace.sm),
          ],
        ],
      ),
    );
  }
}

class _DashRecordCard extends StatelessWidget {
  const _DashRecordCard({
    required this.record,
    required this.fields,
    this.onPressed,
  });

  final DashRecord record;
  final List<DashRecordField> fields;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: const EdgeInsets.all(PlnSpace.md),
      decoration: BoxDecoration(
        color: record.selected
            ? context.plnTheme.selectionBackground
            : context.plnTheme.component,
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlnText(record.title, role: PlnTextRole.bodyStrong),
          if (record.subtitle != null)
            PlnText(
              record.subtitle!,
              role: PlnTextRole.caption,
              tone: PlnTextTone.muted,
            ),
          for (final field in fields)
            Padding(
              padding: const EdgeInsets.only(top: PlnSpace.sm),
              child: Row(
                children: [
                  Expanded(
                    child: PlnText(
                      field.label,
                      role: PlnTextRole.caption,
                      tone: PlnTextTone.faint,
                    ),
                  ),
                  Flexible(
                    child: PlnText(
                      _valueLabel(record.values[field.id]),
                      role: field.kind == DashRecordFieldKind.number
                          ? PlnTextRole.code
                          : PlnTextRole.caption,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
    return Semantics(
      button: onPressed != null,
      selected: record.selected,
      label: record.title,
      child: onPressed == null
          ? body
          : PlnPressable(onPressed: onPressed, child: body),
    );
  }
}

class _DashRecordListTile extends StatelessWidget {
  const _DashRecordListTile({
    required this.record,
    required this.fields,
    this.onPressed,
  });

  final DashRecord record;
  final List<DashRecordField> fields;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PlnSpace.md,
        vertical: PlnSpace.sm,
      ),
      decoration: BoxDecoration(
        color: record.selected ? context.plnTheme.selectionBackground : null,
        border: Border(bottom: BorderSide(color: context.plnTheme.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PlnText(record.title, role: PlnTextRole.bodyStrong),
          ),
          for (final field in fields)
            Expanded(
              child: PlnText(
                _valueLabel(record.values[field.id]),
                role: field.kind == DashRecordFieldKind.number
                    ? PlnTextRole.code
                    : PlnTextRole.caption,
                tone: PlnTextTone.muted,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
    return onPressed == null
        ? tile
        : PlnPressable(onPressed: onPressed, child: tile);
  }
}

class _DashFeedEntry extends StatelessWidget {
  const _DashFeedEntry({
    required this.record,
    required this.actor,
    required this.action,
    required this.time,
    this.onPressed,
  });

  final DashRecord record;
  final String actor;
  final String action;
  final String time;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final entry = Padding(
      padding: const EdgeInsets.symmetric(vertical: PlnSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: PlnSpace.xs),
            decoration: BoxDecoration(
              color: context.plnTheme.textMuted,
              borderRadius: BorderRadius.circular(PlnRadius.full),
            ),
          ),
          const SizedBox(width: PlnSpace.sm),
          Expanded(
            child: PlnText(
              [
                actor,
                action,
                record.title,
              ].where((part) => part.isNotEmpty).join(' '),
              role: PlnTextRole.body,
            ),
          ),
          if (time.isNotEmpty)
            PlnText(time, role: PlnTextRole.caption, tone: PlnTextTone.faint),
        ],
      ),
    );
    return onPressed == null
        ? entry
        : PlnPressable(onPressed: onPressed, child: entry);
  }
}

class _DashCalendarCell extends StatelessWidget {
  const _DashCalendarCell({
    required this.date,
    required this.records,
    this.onSelectDay,
    this.onSelectRecord,
  });

  final DateTime date;
  final List<DashRecord> records;
  final ValueChanged<DateTime>? onSelectDay;
  final ValueChanged<String>? onSelectRecord;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: const EdgeInsets.all(PlnSpace.xs),
      color: context.plnTheme.surfaceInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlnText('${date.day}', role: PlnTextRole.code),
          for (final record in records.take(2))
            Padding(
              padding: const EdgeInsets.only(top: PlnSpace.xxs),
              child: PlnPressable(
                onPressed: onSelectRecord == null
                    ? null
                    : () => onSelectRecord!(record.id),
                child: PlnText(
                  record.title,
                  role: PlnTextRole.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (records.length > 2)
            PlnText(
              '+${records.length - 2}',
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

class _DashTimelineRecord extends StatelessWidget {
  const _DashTimelineRecord({
    required this.record,
    required this.windowStart,
    required this.durationMinutes,
    this.onPressed,
  });

  final DashRecord record;
  final DateTime windowStart;
  final int durationMinutes;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final start = record.start ?? windowStart;
    final end = record.end ?? start.add(const Duration(hours: 1));
    final left = start.difference(windowStart).inMinutes / durationMinutes;
    final width = end.difference(start).inMinutes / durationMinutes;
    final row = SizedBox(
      height: 38,
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: PlnText(
              record.title,
              role: PlnTextRole.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  Positioned(
                    left: left.clamp(0, 1) * constraints.maxWidth,
                    width: (width.clamp(0.02, 1) * constraints.maxWidth).clamp(
                      2,
                      constraints.maxWidth,
                    ),
                    top: PlnSpace.sm,
                    bottom: PlnSpace.sm,
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.plnTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(PlnRadius.sm),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return onPressed == null
        ? row
        : PlnPressable(onPressed: onPressed, child: row);
  }
}

String _valueLabel(Object? value) {
  return switch (value) {
    null => '—',
    DateTime value =>
      '${value.year}-${_twoDigits(value.month)}-${_twoDigits(value.day)}',
    Iterable<Object?> value => value.map(_valueLabel).join(', '),
    _ => value.toString(),
  };
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

bool _sameDay(DateTime? first, DateTime second) {
  return first != null &&
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

DateTime _earlier(DateTime first, DateTime second) {
  return first.isBefore(second) ? first : second;
}

DateTime _later(DateTime first, DateTime second) {
  return first.isAfter(second) ? first : second;
}

extension _DashReduceOrNull<T> on Iterable<T> {
  T? reduceOrNull(T Function(T first, T second) combine) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    var result = iterator.current;
    while (iterator.moveNext()) {
      result = combine(result, iterator.current);
    }
    return result;
  }
}
