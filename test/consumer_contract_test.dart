import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

/// 從**消費者的位置**驗證這個庫。
///
/// 其餘測試都在庫內部，看得到 `lib/src/`，因此驗證不了「一個只 import
/// `package:kallopis/kallopis.dart` 的 app 能不能用」。這組測試只透過公開 barrel，
/// 而且刻意不提供任何 Kallopis 之外的鷹架——沒有 `Scaffold`、沒有手動包 `Material`。
///
/// 這道缺口是實測出來的：庫內 33 個測試全部通過的狀態下，第一個真實消費者一放上
/// `KlpTextField` 就拋 "No Material widget found"。編譯過不等於畫得出來。
void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    KlpVisualStyle? style,
  }) {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    return tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildKlpTheme(
          Brightness.light,
          style: style ?? KlpVisualStyle.modern,
        ),
        home: Center(child: child),
      ),
    );
  }

  group('元件不要求消費者自備 Material 祖先', () {
    final specimens = <String, Widget>{
      'KlpText': const KlpText('x'),
      'KlpSurface': const KlpSurface(child: KlpText('x')),
      'KlpBadge': const KlpBadge(label: 'x'),
      'KlpListTile': const KlpListTile(title: 'x'),
      'KlpDivider': const KlpDivider(),
      'KlpIcon': const KlpIcon(KlpIcons.check),
      'KlpButton': KlpButton(label: 'x', onPressed: () {}),
      'KlpIconButton': KlpIconButton(
        icon: KlpIcons.check,
        label: 'x',
        onPressed: () {},
      ),
      'KlpCheckbox': KlpCheckbox(value: true, label: 'x', onChanged: (_) {}),
      'KlpToggle': KlpToggle(value: true, label: 'x', onChanged: (_) {}),
      'KlpSelect': KlpSelect(label: 'x', value: 'one', onPressed: () {}),
      'KlpTabs': KlpTabs(
        tabs: const ['a', 'b'],
        selected: 0,
        onSelected: (_) {},
      ),
      // KlpTextField 內部使用 TextFormField，曾經要求消費者自己包一層 Material。
      'KlpTextField': const KlpTextField(label: 'x'),
    };

    specimens.forEach((name, widget) {
      testWidgets(name, (tester) async {
        await pump(tester, widget);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });

    testWidgets('KlpSlider', (tester) async {
      await pump(
        tester,
        SizedBox(
          width: 240,
          child: KlpSlider(label: 'x', value: 0.5, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('KlpAppScreen 提供 Material 祖先', () {
    // 少了 Material 祖先，MaterialApp 會在每一段文字下方畫黃色雙底線——那是 Flutter
    // 的除錯提示，不是設計。它不會拋錯、不會被 analyze 抓到，只會出現在畫面上。
    testWidgets('底下的文字不帶除錯用的底線裝飾', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: const KlpAppScreen(child: KlpText('x')),
        ),
      );
      await tester.pumpAndSettle();

      final style = DefaultTextStyle.of(
        tester.element(find.byType(KlpText)),
      ).style;

      expect(
        style.decoration,
        anyOf(isNull, TextDecoration.none),
        reason:
            'KlpAppScreen 之下的文字帶有 ${style.decoration} 裝飾，'
            '通常代表缺少 Material 祖先。',
      );
    });

    testWidgets('KlpAppScreen 之下可直接放需要 Material 的元件', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: const KlpAppScreen(child: KlpTextField(label: 'x')),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('消費者能組出一個完整畫面', () {
    Widget workbench() => KlpAppScreen(
      child: KlpWorkbenchShell(
        primary: const KlpSidebarFrame(
          header: KlpPanelHeader(title: 'nav'),
          rail: SizedBox.shrink(),
          content: KlpText('sidebar'),
        ),
        stage: KlpStageFrame(
          header: const KlpPanelHeader(title: 'stage'),
          content: KlpSection(
            title: 'section',
            child: KlpButton(label: 'ok', onPressed: () {}),
          ),
        ),
        secondary: const KlpPanelFrame(
          header: KlpPanelHeader(title: 'inspector'),
          content: KlpText('details'),
        ),
      ),
    );

    for (final style in [KlpVisualStyle.modern, contrastingStyle]) {
      testWidgets('${style.name} 風格下不丟例外', (tester) async {
        await pump(tester, workbench(), style: style);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('客製面對消費者可用', () {
    testWidgets('只覆寫色彩層，其餘沿用現成風格', (tester) async {
      const brandAccent = Color(0xFF3355FF);
      final brand = KlpVisualStyle.modern.copyWith(
        colors: KlpThemeData.light.copyWith(
          accent: brandAccent,
          interaction: brandAccent,
        ),
      );

      late KlpTheme tokens;
      await pump(
        tester,
        Builder(
          builder: (context) {
            tokens = context.klp;
            return const KlpText('x');
          },
        ),
        style: brand,
      );

      expect(tokens.color.accent, brandAccent);
      expect(
        tokens.space.base,
        KlpSpacingTheme.comfortableDensity.base,
        reason: '只覆寫色彩時，其餘各層必須原封不動',
      );
    });

    testWidgets('primitive 層對消費者可見，足以從零寫一套色盤', (tester) async {
      // KlpPalette 曾經沒有從 barrel 匯出，消費者拿不到 primitive 層。
      const custom = KlpThemeData(
        app: KlpPalette.night,
        surface: KlpPalette.nightInset,
        surfaceInset: KlpPalette.nightMuted,
        surfaceMuted: KlpPalette.nightMuted,
        component: KlpPalette.nightComponent,
        stageSurface: KlpPalette.nightStage,
        overlay: KlpPalette.nightMuted,
        surfaceRaised: KlpPalette.nightMuted,
        modalScrim: KlpPalette.modalScrim,
        guide: KlpPalette.nightGuide,
        divider: KlpPalette.nightDivider,
        text: KlpPalette.chalk,
        textMuted: KlpPalette.chalkMuted,
        textFaint: KlpPalette.chalkFaint,
        border: KlpPalette.nightLine,
        borderStrong: KlpPalette.nightLineStrong,
        accent: KlpPalette.chalk,
        accentSoft: KlpPalette.nightInset,
        interaction: KlpPalette.chalk,
        interactionSoft: KlpPalette.nightInteractionSoft,
        success: KlpPalette.darkSuccess,
        warning: KlpPalette.darkWarning,
        danger: KlpPalette.darkDanger,
        info: KlpPalette.darkInfo,
      );

      late KlpTheme tokens;
      await pump(
        tester,
        Builder(
          builder: (context) {
            tokens = context.klp;
            return const KlpText('x');
          },
        ),
        style: KlpVisualStyle.modern.copyWith(colors: custom),
      );

      expect(tokens.color.app, KlpPalette.night);
    });
  });

  test('公開 barrel 匯出 lib/src 下的每一個檔案', () {
    // 少匯出一個檔案不會有任何錯誤訊息，只會讓消費者拿不到某個型別。
    final barrel = File('lib/kallopis.dart').readAsStringSync();
    final missing = Directory('lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.path.replaceAll(r'\', '/'))
        .where((p) => p.endsWith('.dart'))
        .map((p) => p.replaceFirst('lib/', ''))
        .where((p) => !barrel.contains("export '$p';"))
        .toList();

    expect(
      missing,
      isEmpty,
      reason: '這些檔案沒有從 barrel 匯出：\n${missing.join('\n')}',
    );
  });
}
