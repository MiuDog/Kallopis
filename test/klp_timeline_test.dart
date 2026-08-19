import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/data/klp_timeline.dart';
import 'package:kallopis/src/theme/klp_theme.dart';
import 'package:kallopis/src/typography/klp_text.dart';

// 繞過 barrel 直接 import 原始檔，理由見 klp_accordion_test.dart 開頭的說明。

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(theme: buildKlpTheme(Brightness.light), home: child),
    );
  }

  testWidgets('依序渲染每個事件的標題與時間', (tester) async {
    await pump(
      tester,
      const KlpTimeline(
        items: [
          KlpTimelineItemData(title: '建立草稿', time: '09:00'),
          KlpTimelineItemData(title: '送出審核', time: '10:30'),
          KlpTimelineItemData(title: '核准', time: '14:00', highlighted: true),
        ],
      ),
    );

    expect(find.text('建立草稿'), findsOneWidget);
    expect(find.text('送出審核'), findsOneWidget);
    expect(find.text('核准'), findsOneWidget);
    expect(find.text('09:00'), findsOneWidget);
    expect(find.text('10:30'), findsOneWidget);
    expect(find.text('14:00'), findsOneWidget);
  });

  testWidgets('提供 content 時會一併渲染附加內容', (tester) async {
    await pump(
      tester,
      const KlpTimeline(
        items: [
          KlpTimelineItemData(
            title: '核准',
            content: KlpText('備註：無異議'),
          ),
        ],
      ),
    );

    expect(find.text('備註：無異議'), findsOneWidget);
  });

  testWidgets('提供 marker 時使用自訂標記而非預設圓點', (tester) async {
    const markerKey = Key('custom-marker');

    await pump(
      tester,
      KlpTimeline(
        items: [
          KlpTimelineItemData(
            title: '核准',
            marker: Container(key: markerKey),
          ),
        ],
      ),
    );

    expect(find.byKey(markerKey), findsOneWidget);
  });
}
