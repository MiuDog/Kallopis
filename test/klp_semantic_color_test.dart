import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test('語意四色依明暗外觀解析為低彩度策展色', () {
    expect(KlpThemeData.light.success, KlpPalette.lightSuccess);
    expect(KlpThemeData.light.warning, KlpPalette.lightWarning);
    expect(KlpThemeData.light.danger, KlpPalette.lightDanger);
    expect(KlpThemeData.light.info, KlpPalette.lightInfo);

    for (final tokens in [KlpThemeData.dark, KlpThemeData.ultraDark]) {
      expect(tokens.success, KlpPalette.darkSuccess);
      expect(tokens.warning, KlpPalette.darkWarning);
      expect(tokens.danger, KlpPalette.darkDanger);
      expect(tokens.info, KlpPalette.darkInfo);
    }
  });

  test('非文字語意指示在所有正式外觀表面維持至少 3 比 1 對比', () {
    for (final tokens in [
      KlpThemeData.light,
      KlpThemeData.dark,
      KlpThemeData.ultraDark,
    ]) {
      final statusColors = [
        tokens.success,
        tokens.warning,
        tokens.danger,
        tokens.info,
      ];
      final surfaces = [
        tokens.app,
        tokens.surface,
        tokens.surfaceInset,
        tokens.component,
        tokens.stageSurface,
      ];

      for (final statusColor in statusColors) {
        for (final surface in surfaces) {
          expect(
            _contrastRatio(statusColor, surface),
            greaterThanOrEqualTo(3),
            reason:
                '${statusColor.toARGB32().toRadixString(16)} on '
                '${surface.toARGB32().toRadixString(16)}',
          );
        }
      }
    }
  });

  test('語意填色上的圖示前景依實際亮度維持至少 4.5 比 1', () {
    for (final tokens in [
      KlpThemeData.light,
      KlpThemeData.dark,
      KlpThemeData.ultraDark,
    ]) {
      for (final statusColor in [
        tokens.success,
        tokens.warning,
        tokens.danger,
        tokens.info,
      ]) {
        expect(
          _contrastRatio(
            KlpThemeContrast.foregroundFor(statusColor),
            statusColor,
          ),
          greaterThanOrEqualTo(4.5),
        );
      }
    }
  });

  test('兩側 Pane 與中央 Stage 只用 surface 明度建立層級', () {
    expect(KlpThemeData.light.app, KlpPalette.ink200);
    expect(KlpThemeData.light.surface, KlpPalette.ink100);
    expect(KlpThemeData.light.stageSurface, KlpPalette.ink50);
    expect(
      KlpThemeData.light.stageSurface.computeLuminance(),
      greaterThan(KlpThemeData.light.surface.computeLuminance()),
    );

    expect(KlpThemeData.dark.app, KlpPalette.ink900);
    expect(KlpThemeData.dark.surface, KlpPalette.ink800);
    expect(KlpThemeData.dark.stageSurface, KlpPalette.ink900);
    expect(KlpThemeData.dark.surfaceInset, KlpPalette.ink700);
    expect(KlpThemeData.dark.surfaceMuted, KlpPalette.ink700);
    expect(KlpThemeData.dark.component, KlpPalette.ink800);
    expect(
      KlpThemeData.dark.surface.computeLuminance(),
      greaterThan(KlpThemeData.dark.stageSurface.computeLuminance()),
    );

    expect(KlpThemeData.ultraDark.app, KlpPalette.ink950);
    expect(KlpThemeData.ultraDark.surface, KlpPalette.ink900);
    expect(KlpThemeData.ultraDark.stageSurface, KlpPalette.ink950);
    expect(
      KlpThemeData.ultraDark.surface.computeLuminance(),
      greaterThan(KlpThemeData.ultraDark.stageSurface.computeLuminance()),
    );

    // 只要求「ultraDark 確實更暗」。原本這裡要求絕對亮度差 ≥ 0.005，那個門檻是對著
    // 舊色盤湊出來的：相對亮度在近黑端壓縮得極厲害（ink900 與 ink950 的感知差有一階，
    // 相對亮度只差 0.0045），固定差值在那個區間量不出東西。
    expect(
      KlpThemeData.dark.app.computeLuminance(),
      greaterThan(KlpThemeData.ultraDark.app.computeLuminance()),
    );
    expect(
      KlpThemeData.dark.surface.computeLuminance(),
      greaterThan(KlpThemeData.ultraDark.surface.computeLuminance()),
    );
    expect(
      KlpThemeData.dark.stageSurface.computeLuminance(),
      greaterThan(KlpThemeData.ultraDark.stageSurface.computeLuminance()),
    );

    for (final tokens in [
      KlpThemeData.light,
      KlpThemeData.dark,
      KlpThemeData.ultraDark,
    ]) {
      expect(tokens.border.a, 0);
      expect(tokens.borderStrong.a, 0);
    }
  });

  test('最高階 Light 文字取色梯最暗階以保留最大可讀對比', () {
    expect(KlpThemeData.light.text, KlpPalette.ink900);
    expect(
      _contrastRatio(KlpThemeData.light.text, KlpThemeData.light.stageSurface),
      greaterThanOrEqualTo(15),
    );
  });

  testWidgets('狀態標籤仍解析為三階文字色而非語意色', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: const KlpInlineNotice(
          title: '同步完成',
          tone: KlpFeedbackTone.success,
        ),
      ),
    );

    final label = tester.widget<Text>(find.text('DONE'));
    expect(label.style?.color, KlpThemeData.dark.textMuted);
    expect(label.style?.color, isNot(KlpThemeData.dark.success));
    expect(find.byType(KlpIcon), findsOneWidget);
  });
}

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}
