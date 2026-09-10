import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('theme preview 自行收斂寬度並使用停用透明度 token', (tester) async {
    final base = KlpVisualStyle.defaultStyle;
    final style = base.copyWith(
      surface: base.surface.copyWith(themePreviewDisabledOpacity: 0.41),
    );

    await tester.pumpWidget(
      KlpApp(
        style: style,
        showWindowHeader: false,
        home: const KlpPanelFrame(
          content: KlpAppScreen(
            child: KlpAlign(
              alignment: Alignment.topLeft,
              child: KlpBox(
                width: 120,
                child: KlpThemePreviewTile(
                  mode: KlpThemePreviewMode.dark,
                  label: 'Dark',
                  description: 'Warm dark',
                  enabled: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final tile = find.byKey(const ValueKey('theme-preview-dark'));
    expect(tester.getSize(tile).width, 120);
    expect(
      tester
          .widget<Opacity>(
            find.descendant(of: tile, matching: find.byType(Opacity)),
          )
          .opacity,
      0.41,
    );
  });

  testWidgets('theme preview 派送受控選取事件', (tester) async {
    var selected = false;

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(
            child: KlpThemePreviewTile(
              mode: KlpThemePreviewMode.light,
              label: 'Light',
              description: 'Paper white',
              selected: true,
              onSelected: () => selected = true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('theme-preview-light')));
    expect(selected, isTrue);
  });

  test('theme preview 停用透明度可經 JSON round trip', () {
    final base = KlpVisualStyle.defaultStyle;
    final style = base.copyWith(
      surface: base.surface.copyWith(themePreviewDisabledOpacity: 0.43),
    );

    final decoded = KlpVisualStyleJson.decode(KlpVisualStyleJson.encode(style));
    expect(decoded.surface.themePreviewDisabledOpacity, 0.43);
  });
}
