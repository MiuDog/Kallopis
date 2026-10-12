import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('key value 元件由 typed width 解析主題幾何', (tester) async {
    final style = KlpVisualStyleJson.decode({
      'geometry': {
        'data': {
          'keyValueLabelWidthCompact': 37,
          'keyValueLabelWidthStandard': 53,
        },
      },
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light, style: style),
        home: KlpColumn(
          children: [
            const KlpKeyValueTable(
              rows: [KlpKeyValueRowData(label: 'Path', value: 'lib/src')],
              labelWidth: KlpKeyValueLabelWidth.compact,
            ),
            KlpKeyValueList(
              rows: const [
                KlpKeyValueItem(
                  id: 'owner',
                  label: 'Owner',
                  value: Text('Miu'),
                ),
              ],
              labelWidth: KlpKeyValueLabelWidth.standard,
            ),
          ],
        ),
      ),
    );

    final widths = tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .map((box) => box.width)
        .whereType<double>()
        .toSet();
    expect(widths, containsAll(<double>{37, 53}));
  });

  testWidgets('copyable row 回傳自身 id 並保留 verbatim 字體', (tester) async {
    String? copiedId;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpKeyValueList(
          rows: const [
            KlpKeyValueItem(
              id: 'path',
              label: 'Path',
              value: Text('lib/src'),
              verbatim: true,
              copyable: true,
            ),
          ],
          onCopy: (id) => copiedId = id,
        ),
      ),
    );

    final valueText = tester.widget<Text>(find.text('lib/src'));
    final valueContext = tester.element(find.byWidget(valueText));
    expect(
      DefaultTextStyle.of(valueContext).style.fontFamily,
      KlpTheme.of(valueContext).type.monoFamily,
    );

    await tester.tap(find.byKey(const ValueKey('pln-key-value-copy-path')));
    expect(copiedId, 'path');
  });

  testWidgets('empty key value list 使用呼叫端 empty state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const KlpKeyValueList(rows: [], emptyState: Text('No metadata')),
      ),
    );

    expect(find.text('No metadata'), findsOneWidget);
  });
}
