import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  const weekdayLabels = ['一', '二', '三', '四', '五', '六', '日'];

  testWidgets('tapping an enabled day calls onDateSelected with that date', (
    tester,
  ) async {
    DateTime? picked;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpCalendar(
            month: DateTime(2026, 8),
            monthLabel: '2026 年 8 月',
            weekdayLabels: weekdayLabels,
            previousMonthLabel: '上個月',
            nextMonthLabel: '下個月',
            onDateSelected: (date) => picked = date,
          ),
        ),
      ),
    );

    await tester.tap(find.text('18'));
    await tester.pump();

    expect(picked, DateTime(2026, 8, 18));
  });

  testWidgets('disabled dates cannot be selected', (tester) async {
    var callCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpCalendar(
            month: DateTime(2026, 8),
            monthLabel: '2026 年 8 月',
            weekdayLabels: weekdayLabels,
            previousMonthLabel: '上個月',
            nextMonthLabel: '下個月',
            isDateDisabled: (date) => date.day == 18,
            onDateSelected: (_) => callCount++,
          ),
        ),
      ),
    );

    await tester.tap(find.text('18'));
    await tester.pump();

    expect(callCount, 0);
  });

  testWidgets('previous/next month buttons invoke their callbacks', (
    tester,
  ) async {
    var previousCount = 0;
    var nextCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpCalendar(
            month: DateTime(2026, 8),
            monthLabel: '2026 年 8 月',
            weekdayLabels: weekdayLabels,
            previousMonthLabel: '上個月',
            nextMonthLabel: '下個月',
            onPreviousMonth: () => previousCount++,
            onNextMonth: () => nextCount++,
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('上個月'));
    await tester.tap(find.bySemanticsLabel('下個月'));
    await tester.pump();

    expect(previousCount, 1);
    expect(nextCount, 1);
  });

  // DateTime 的建構子不是 const，因此這個測試不是 widget test，也不能用 const。
  test(
    'KlpCalendarRange.contains treats reversed endpoints as a valid span',
    () {
      final range = KlpCalendarRange(
        start: DateTime(2026, 8, 20),
        end: DateTime(2026, 8, 10),
      );

      expect(range.contains(DateTime(2026, 8, 15)), isTrue);
      expect(range.contains(DateTime(2026, 8, 9)), isFalse);
      expect(range.contains(DateTime(2026, 8, 21)), isFalse);
    },
  );

  testWidgets('renders without throwing in both brightnesses', (tester) async {
    for (final brightness in Brightness.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(brightness),
          home: Scaffold(
            body: KlpCalendar(
              month: DateTime(2026, 8),
              monthLabel: '2026 年 8 月',
              weekdayLabels: weekdayLabels,
              previousMonthLabel: '上個月',
              nextMonthLabel: '下個月',
              today: DateTime(2026, 8, 19),
              selectedDate: DateTime(2026, 8, 5),
              onDateSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    }
  });
  _dayContentSlotTests();
}

/// `dayContentBuilder` 是後加的 slot。它的重點不是「能放東西」，而是**放了東西之後
/// 格高會換一套 token**——沒有這個切換，日期數字加內容會擠在選擇器的格高裡糊成一團。
void _dayContentSlotTests() {
  testWidgets('沒有 dayContentBuilder 時用選擇器格高', (tester) async {
    late KlpTheme klp;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            klp = context.klp;
            return Scaffold(
              body: KlpCalendar(
                month: DateTime(2026, 8),
                monthLabel: '2026 年 8 月',
                weekdayLabels: const ['一', '二', '三', '四', '五', '六', '日'],
                previousMonthLabel: '上個月',
                nextMonthLabel: '下個月',
              ),
            );
          },
        ),
      ),
    );

    final cell = tester.getSize(find.text('15'));
    expect(cell.height, lessThanOrEqualTo(klp.space.controlHeightSmall));
  });

  testWidgets('給了 dayContentBuilder 就換成內容格高', (tester) async {
    late KlpTheme klp;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            klp = context.klp;
            return Scaffold(
              body: KlpCalendar(
                month: DateTime(2026, 8),
                monthLabel: '2026 年 8 月',
                weekdayLabels: const ['一', '二', '三', '四', '五', '六', '日'],
                previousMonthLabel: '上個月',
                nextMonthLabel: '下個月',
                dayContentBuilder: (date) =>
                    date.day == 18 ? const KlpText('每日回顧') : null,
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('每日回顧'), findsOneWidget, reason: 'slot 的內容要真的被渲染');

    final row = tester.getSize(
      find
          .ancestor(of: find.text('18'), matching: find.byType(Container))
          .first,
    );
    expect(
      row.height,
      klp.space.calendarContentCell,
      reason: '有內容時格高必須換成 calendarContentCell，否則內容會被擠爆',
    );
  });
}
