import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test('filter value 使用等寬 caption 粗體角色', () {
    final type = KlpTypographyTheme.proportional;
    final definition = KlpTextStyles.definitionOf(
      KlpTextRole.monoCaptionStrong,
      type,
    );

    expect(definition.fontSize, type.caption);
    expect(definition.lineHeight, type.captionLeading);
    expect(definition.fontWeight, type.bold);
    expect(definition.family, KlpFontRole.mono);
  });

  testWidgets('filter bar 呈現插槽並派送篩選事件', (tester) async {
    String? selectedId;
    String? removedId;
    var added = false;
    var cleared = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpFilterBar(
          filters: const [
            KlpFilterOption(
              id: 'status',
              label: 'Status',
              value: 'Open',
              removable: true,
            ),
          ],
          selectedId: 'status',
          onSelected: (value) => selectedId = value,
          onRemove: (value) => removedId = value,
          onAddFilter: () => added = true,
          onClearAll: () => cleared = true,
          leading: const KlpText('Leading'),
          trailing: const KlpText('Trailing'),
        ),
      ),
    );

    for (final label in [
      'Leading',
      'Status',
      'Open',
      '+ Filter',
      'Clear all',
      'Trailing',
    ]) {
      expect(find.text(label), findsOneWidget);
    }

    final value = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'Open',
      ),
    );
    expect(value.role, KlpTextRole.monoCaptionStrong);

    await tester.tap(find.text('Status'));
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is KlpIcon && widget.icon == KlpIcons.close,
      ),
    );
    await tester.tap(find.text('+ Filter'));
    await tester.tap(find.text('Clear all'));

    expect(selectedId, 'status');
    expect(removedId, 'status');
    expect(added, isTrue);
    expect(cleared, isTrue);
  });

  testWidgets('selection toolbar 派送批次與清除事件', (tester) async {
    var applied = false;
    var cleared = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpSelectionToolbar(
          count: 2,
          countLabel: '2 selected',
          actions: [
            KlpSelectionAction(
              id: 'apply',
              label: 'Apply',
              onPressed: () => applied = true,
            ),
          ],
          onClear: () => cleared = true,
        ),
      ),
    );

    expect(find.byType(KlpDashedBorder), findsOneWidget);
    await tester.tap(find.text('Apply'));
    await tester.tap(find.text('Clear'));

    expect(applied, isTrue);
    expect(cleared, isTrue);
  });

  testWidgets('presence 與 shortcut 使用目前主題語意', (tester) async {
    late KlpThemeData colors;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            colors = context.klpColors;
            return const KlpColumn(
              children: [
                KlpPresenceIndicator(label: 'Online', active: true),
                KlpShortcutHint(label: 'Ctrl+K'),
              ],
            );
          },
        ),
      ),
    );

    final presenceText = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'Online',
      ),
    );
    expect(presenceText.color, colors.success);

    final shortcutText = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'Ctrl+K',
      ),
    );
    expect(shortcutText.role, KlpTextRole.code);
    expect(shortcutText.tone, KlpTextTone.muted);
  });
}
