import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test('sliding selection geometry copies independently and round trips', () {
    final base = KlpVisualStyle.defaultStyle;
    final control = base.geometry.control;
    final customControl = control.copyWith(
      slidingSelectionHeight: 40,
      slidingSelectionSegmentWidth: 48,
      slidingSelectionPadding: 3,
      slidingSelectionIndicatorHeight: 32,
    );
    final encoded = KlpVisualStyleJson.encode(
      base.copyWith(geometry: base.geometry.copyWith(control: customControl)),
    );
    final decoded = KlpVisualStyleJson.decode(encoded).geometry.control;
    expect(decoded.slidingSelectionHeight, 40);
    expect(decoded.slidingSelectionSegmentWidth, 48);
    expect(decoded.slidingSelectionPadding, 3);
    expect(decoded.slidingSelectionIndicatorHeight, 32);
  });

  testWidgets(
    'sliding selection follows geometry and dispatches typed options',
    (tester) async {
      final base = KlpVisualStyle.defaultStyle;
      final custom = base.copyWith(
        geometry: base.geometry.copyWith(
          control: base.geometry.control.copyWith(
            slidingSelectionHeight: 40,
            slidingSelectionSegmentWidth: 48,
            slidingSelectionPadding: 3,
            slidingSelectionIndicatorHeight: 32,
          ),
        ),
      );
      int? selected;
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light, style: custom),
          home: Material(
            child: Center(
              child: KlpSlidingSelection(
                label: 'Mode',
                selectedIndex: 0,
                options: const [
                  KlpSelectionOption(
                    icon: KlpIcons.grid,
                    tone: KlpSelectionTone.info,
                  ),
                  KlpSelectionOption(
                    icon: KlpIcons.container,
                    tone: KlpSelectionTone.primary,
                  ),
                ],
                onSelected: (value) => selected = value,
              ),
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(KlpSlidingSelection)),
        const Size(104, 40),
      );
      await tester.tap(find.byKey(const ValueKey('pln-selection-hit-Mode-1')));
      expect(selected, 1);
    },
  );
}
