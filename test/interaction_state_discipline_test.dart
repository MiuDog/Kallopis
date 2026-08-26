import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// 互動狀態的紀律閘門。
///
/// 實作準則 §2.1 定了三種狀態、三種手法，刻意互不相同：
///
/// - **hover → `1px dashed`**。暫時的，指標移開就沒了。
/// - **selected → 填色**，且**不得是 accent**（準則第 5 條）。
/// - **focus → `2px solid` 焦點環**（準則 §7，不得移除）。
///
/// 三者若混用，使用者分不出「指標剛好經過」「我選了這個」「鍵盤焦點在這」。
/// 這條規則若只靠人看，新增元件時必然分岔。
void main() {
  const presets = <String, KlpThemeData>{
    'light': KlpThemeData.light,
    'dark': KlpThemeData.dark,
    'ultraDark': KlpThemeData.ultraDark,
  };

  group('hover 與 focus 都不改變欄位底色', () {
    presets.forEach((name, tokens) {
      test(name, () {
        final rest = KlpFieldStyle.colorFor(tokens, KlpFieldFillState.rest);

        expect(
          KlpFieldStyle.colorFor(tokens, KlpFieldFillState.hovered).toARGB32(),
          rest.toARGB32(),
          reason:
              '$name 的欄位在 hover 時換了底色。準則 §2.1：hover 是暫時的，'
              '用 1px dashed 表達；填色留給 selected 那種會停留的狀態。',
        );
        expect(
          KlpFieldStyle.colorFor(tokens, KlpFieldFillState.focused).toARGB32(),
          rest.toARGB32(),
          reason: '$name 的欄位在 focus 時換了底色。focus 走 §7 的實線焦點環。',
        );
      });
    });
  });

  group('selected 不得使用 accent', () {
    // 準則第 5 條：accent 只用於主要 CTA、文字連結、鍵盤焦點與明確可執行的操作。
    // 用在 selected 上，會讓「可以按下去做某件事」與「你現在在這裡」用同一個
    // 顏色說話。
    testWidgets('選取色與 accent 不同', (tester) async {
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

      expect(
        klp.selectedSurface.toARGB32(),
        isNot(klp.color.accent.toARGB32()),
      );
      expect(
        klp.selectedSurface.toARGB32(),
        isNot(klp.color.interaction.toARGB32()),
      );
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

  testWidgets('表單 hover 是虛線、focus 是實線焦點環', (tester) async {
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

    expect(
      find.descendant(
        of: field,
        matching: find.byKey(const ValueKey('klp-state-hover-border')),
      ),
      findsOneWidget,
      reason: '準則 §2.1：欄位 hover 用 1px dashed',
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();

    expect(
      find.descendant(
        of: field,
        matching: find.byKey(const ValueKey('klp-state-focus-ring')),
      ),
      findsOneWidget,
      reason: '準則 §7：焦點環不得移除，鍵盤使用者沒有別的方式知道自己在哪',
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

  testWidgets('三種狀態用三種手法，互不混用', (tester) async {
    // 這是對 KlpStateHighlight 的行為驗證。全庫的狀態呈現都必須經由它——
    // 元件自己畫，就會出現「改了一份、另一份沒改」而且不會報錯。
    Future<void> pump(KlpHighlightState state) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: Scaffold(
            body: KlpStateHighlight(
              state: state,
              child: const SizedBox(width: 100, height: 40),
            ),
          ),
        ),
      );
    }

    await pump(KlpHighlightState.hover);
    expect(
      find.byKey(const ValueKey('klp-state-hover-border')),
      findsOneWidget,
      reason: '準則 §2.1：hover 是 1px dashed',
    );
    expect(find.byKey(const ValueKey('klp-state-highlight')), findsNothing);

    await pump(KlpHighlightState.selected);
    expect(
      find.byKey(const ValueKey('klp-state-highlight')),
      findsOneWidget,
      reason: '準則 §2.1：selected 是填色，不是虛線',
    );
    expect(find.byKey(const ValueKey('klp-state-hover-border')), findsNothing);

    await pump(KlpHighlightState.focus);
    expect(
      find.byKey(const ValueKey('klp-state-focus-ring')),
      findsOneWidget,
      reason: '準則 §7：焦點環不得移除',
    );

    await pump(KlpHighlightState.none);
    expect(find.byKey(const ValueKey('klp-state-hover-border')), findsNothing);
    expect(find.byKey(const ValueKey('klp-state-highlight')), findsNothing);
    expect(find.byKey(const ValueKey('klp-state-focus-ring')), findsNothing);
  });
}
