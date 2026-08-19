import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('KlpPhaseToggle 支援圖示選項與選取切換', (tester) async {
    String? current = 'check';

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => KlpPhaseToggle<String>(
              options: const [
                KlpPhaseOption(value: 'x', icon: KlpIcons.x),
                KlpPhaseOption(
                  value: 'check',
                  icon: KlpIcons.check,
                  activeTone: KlpFeedbackTone.success,
                ),
              ],
              selected: current,
              onSelected: (v) => setState(() => current = v),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(KlpIcon), findsNWidgets(2));
    expect(current, 'check');

    // 點擊第一個選項 'x'
    await tester.tap(find.byType(KlpIcon).first);
    await tester.pumpAndSettle();

    expect(current, 'x');
  });

  testWidgets('KlpPhaseToggle 在深色模式下選取紅色 danger 選項呈現白色 icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: const Scaffold(
          body: KlpPhaseToggle<String>(
            options: [
              KlpPhaseOption(
                value: 'x',
                icon: KlpIcons.x,
                activeTone: KlpFeedbackTone.danger,
              ),
              KlpPhaseOption(value: 'slash', label: '/'),
            ],
            selected: 'x',
          ),
        ),
      ),
    );

    final icon = tester.widget<KlpIcon>(find.byType(KlpIcon).first);
    expect(icon.color, KlpPalette.ink50);
  });
}
