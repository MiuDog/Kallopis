import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// 互動狀態的紀律閘門。
///
/// **hover 與 selected 一律以高亮色表達，全庫不得用邊框表示 hover。** 先前
/// 一般元件走背景高亮、Explorer 與表單走虛線框，同一個狀態兩種畫法，消費者
/// 無從預期。這條規則若只靠人看，新增元件時必然再次分岔。
void main() {
  const presets = <String, KlpThemeData>{
    'light': KlpThemeData.light,
    'dark': KlpThemeData.dark,
    'ultraDark': KlpThemeData.ultraDark,
  };

  group('hover 以底色表達，不是靠外框', () {
    presets.forEach((name, tokens) {
      test(name, () {
        final rest = KlpFieldStyle.colorFor(tokens, KlpFieldFillState.rest);
        final hovered = KlpFieldStyle.colorFor(
          tokens,
          KlpFieldFillState.hovered,
        );
        final focused = KlpFieldStyle.colorFor(
          tokens,
          KlpFieldFillState.focused,
        );

        expect(
          hovered.toARGB32(),
          isNot(rest.toARGB32()),
          reason:
              '$name 的欄位 hover 時底色沒變。hover 現在只能靠底色表達，'
              '底色不變就等於沒有 hover 回饋。',
        );
        expect(
          focused.toARGB32(),
          isNot(hovered.toARGB32()),
          reason: '$name 的 focus 與 hover 底色相同，鍵盤使用者分不出焦點在哪',
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

  testWidgets('表單 hover 與 focus 用不同強度的底色，且完全不畫外框', (tester) async {
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
      find.descendant(of: field, matching: find.byType(KlpDashedBorder)),
      findsNothing,
      reason: '表單 hover 不得再畫虛線框',
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();

    expect(
      find.descendant(of: field, matching: find.byType(KlpDashedBorder)),
      findsNothing,
      reason: '表單 focus 也不得畫虛線框',
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

  test('沒有任何元件用邊框表達 hover', () {
    // 這是原始碼掃描，不是行為測試：行為測試只能覆蓋被寫進測試的那幾個元件，
    // 而這條規則要管的是**還沒被寫出來**的元件。
    //
    // 判準：同一段程式碼裡同時出現 hover 狀態與 KlpDashedBorder。
    final offenders = <String>[];
    final sources = Directory('../lib/src').existsSync()
        ? Directory('../lib/src')
        : Directory('lib/src');

    for (final file
        in sources
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
      final path = file.path.replaceAll(r'', '/');
      // 虛線框元件自己、以及「待填區域」的用途不在此限。
      if (path.endsWith('klp_dashed_border.dart') ||
          path.endsWith('klp_region_placeholder.dart') ||
          path.endsWith('klp_empty_state.dart') ||
          path.endsWith('klp_view_states.dart')) {
        continue;
      }

      final lines = file.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (!lines[i].contains('KlpDashedBorder(')) continue;
        // 往上看幾行，找是不是由 hover 狀態驅動。
        final from = i - 6 < 0 ? 0 : i - 6;
        final window = lines.sublist(from, i + 1).join('\n');
        if (RegExp(r'_?[hH]overed|isHovered').hasMatch(window)) {
          offenders.add('$path:${i + 1}  ${lines[i].trim()}');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          '這些地方用虛線框表達 hover：\n${offenders.join('\n')}\n'
          'hover 一律用 KlpStateHighlight 的高亮色。同一個狀態兩種畫法，'
          '消費者無從預期。',
    );
  });
}
