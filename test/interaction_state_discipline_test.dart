import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// 互動狀態的紀律閘門。
///
/// 一般元件使用背景高亮；Explorer 與表單保留低／高對比虛線。這條分界若只靠人看，
/// 新增元件時很容易讓兩套語言再次混用。
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

  testWidgets('一般 icon button hover 使用背景高亮而不是虛線框', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Scaffold(
          body: KlpIconButton(
            icon: KlpIcons.folderPlus,
            label: '新增',
            onPressed: () {},
          ),
        ),
      ),
    );

    final button = find.byType(KlpIconButton);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(button));
    await tester.pump();

    final material = find.descendant(
      of: button,
      matching: find.byType(Material),
    );
    final context = tester.element(button);

    expect(material, findsOneWidget);
    expect(
      tester.widget<Material>(material).color,
      Color.alphaBlend(context.klp.selectionWash, context.klp.color.component),
    );
    expect(
      find.descendant(of: button, matching: find.byType(KlpDashedBorder)),
      findsNothing,
    );
  });

  testWidgets('表單 hover 與 focus 分別使用低對比與高對比虛線框', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Scaffold(body: KlpTextField(focusNode: focusNode)),
      ),
    );

    final field = find.byType(KlpTextField);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(field));
    await tester.pump();

    var border = tester.widget<KlpDashedBorder>(
      find.descendant(of: field, matching: find.byType(KlpDashedBorder)),
    );
    expect(border.color, tester.element(field).klp.hoverBorder);

    await tester.tap(find.byType(TextFormField));
    await tester.pump();

    border = tester.widget<KlpDashedBorder>(
      find.descendant(of: field, matching: find.byType(KlpDashedBorder)),
    );
    expect(border.color, tester.element(field).klp.color.textMuted);
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
