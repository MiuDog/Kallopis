import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// 互動狀態的紀律閘門。
///
/// 「hover 只有低對比虛線細框」這條規則散在十幾個元件裡，靠人看是守不住的：
/// 補一個 hover 變色回去不會出錯、不會被 analyze 抓到，只是規則從此有兩套。
void main() {
  const presets = <String, KlpThemeData>{
    'light': KlpThemeData.light,
    'dark': KlpThemeData.dark,
    'ultraDark': KlpThemeData.ultraDark,
  };

  group('hover 不改變欄位底色', () {
    presets.forEach((name, tokens) {
      test(name, () {
        expect(
          KlpFieldStyle.colorFor(tokens, KlpFieldFillState.hovered).toARGB32(),
          KlpFieldStyle.colorFor(tokens, KlpFieldFillState.rest).toARGB32(),
          reason: '$name 的欄位在 hover 時換了底色——hover 只能是外框',
        );
      });
    });
  });

  group('不合法輸入是半透明紅底', () {
    presets.forEach((name, tokens) {
      test(name, () {
        final error = KlpFieldStyle.colorFor(tokens, KlpFieldFillState.error);

        expect(
          error.a,
          lessThan(1.0),
          reason:
              '$name 的錯誤底色是不透明色。預混成不透明會在欄位被放到別的表面上時對不上；'
              '半透明才會跟著底下實際的表面走。',
        );
        expect(
          error.r,
          tokens.danger.r,
          reason: '$name 的錯誤底色不是從 danger 推導的，調整 danger 時會失去同步',
        );
      });
    });
  });

  testWidgets('hover 邊框是 guide 的低對比版本，且只有一個來源', (tester) async {
    late KlpTheme klp;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            klp = context.klp;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(klp.hoverBorder.a, klp.shape.dashedOpacity);
    expect(klp.hoverBorder.toARGB32(), isNot(klp.color.guide.toARGB32()));
    expect(
      klp.hoverBorder.toARGB32(),
      klp.color.guide.withValues(alpha: klp.shape.dashedOpacity).toARGB32(),
    );
  });

  testWidgets('KlpRegion 的內容不貼著面板邊緣', (tester) async {
    const contentKey = Key('region-content');

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const Center(
          child: SizedBox(
            width: 300,
            height: 200,
            child: KlpRegion(
              content: SizedBox.expand(
                child: ColoredBox(key: contentKey, color: Color(0xFF000000)),
              ),
            ),
          ),
        ),
      ),
    );

    final region = tester.getRect(find.byType(KlpRegion));
    final content = tester.getRect(find.byKey(contentKey));

    expect(content.left, greaterThan(region.left));
    expect(content.top, greaterThan(region.top));
    expect(content.right, lessThan(region.right));
    expect(content.bottom, lessThan(region.bottom));
  });

  test('亮態的分隔線用 ink100', () {
    expect(KlpThemeData.light.divider.toARGB32(), KlpPalette.ink100.toARGB32());
  });
}
