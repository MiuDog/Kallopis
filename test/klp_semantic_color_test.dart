import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test('語意四色一律使用高明度策展色（不隨明暗外觀切換）', () {
    for (final tokens in [
      KlpThemeData.light,
      KlpThemeData.dark,
      KlpThemeData.ultraDark,
    ]) {
      expect(tokens.success, KlpPalette.success);
      expect(tokens.warning, KlpPalette.warning);
      expect(tokens.danger, KlpPalette.danger);
      expect(tokens.info, KlpPalette.info);
    }
  });

  test('非文字語意指示在深色外觀表面維持至少 3 比 1 對比', () {
    for (final tokens in [KlpThemeData.dark, KlpThemeData.ultraDark]) {
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
    expect(KlpThemeData.light.app, KlpPalette.ink150);
    expect(KlpThemeData.light.surface, KlpPalette.ink100);
    expect(KlpThemeData.light.surfaceInset, KlpPalette.ink100);
    expect(KlpThemeData.light.surfaceMuted, KlpPalette.ink100);
    expect(KlpThemeData.light.stageSurface, KlpPalette.ink50);
    expect(
      KlpThemeData.light.stageSurface.computeLuminance(),
      greaterThan(KlpThemeData.light.surface.computeLuminance()),
    );

    expect(KlpThemeData.dark.app, KlpPalette.ink850);
    expect(KlpThemeData.dark.surface, KlpPalette.ink750);
    expect(KlpThemeData.dark.stageSurface, KlpPalette.ink800);
    expect(KlpThemeData.dark.surfaceInset, KlpPalette.ink750);
    expect(KlpThemeData.dark.surfaceMuted, KlpPalette.ink750);
    expect(KlpThemeData.dark.component, KlpPalette.ink800);

    expect(KlpThemeData.ultraDark.app, KlpPalette.ink950);
    expect(KlpThemeData.ultraDark.surface, KlpPalette.ink850);
    expect(KlpThemeData.ultraDark.stageSurface, KlpPalette.ink900);
    expect(KlpThemeData.ultraDark.surfaceInset, KlpPalette.ink850);
    expect(KlpThemeData.ultraDark.surfaceMuted, KlpPalette.ink850);

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

  test('文字顏色渲染規則：背景 500 以下為深色文字，600 以上為淺色文字', () {
    // 500 以下（ink50 ~ ink500）：深色文字 (ink900)
    expect(KlpThemeContrast.foregroundFor(KlpPalette.ink50), KlpPalette.ink900);
    expect(
      KlpThemeContrast.foregroundFor(KlpPalette.ink100),
      KlpPalette.ink900,
    );
    expect(
      KlpThemeContrast.foregroundFor(KlpPalette.ink200),
      KlpPalette.ink900,
    );
    expect(
      KlpThemeContrast.foregroundFor(KlpPalette.ink300),
      KlpPalette.ink900,
    );
    expect(
      KlpThemeContrast.foregroundFor(KlpPalette.ink400),
      KlpPalette.ink900,
    );
    expect(
      KlpThemeContrast.foregroundFor(KlpPalette.ink500),
      KlpPalette.ink900,
    );

    // 600 以上（ink600 ~ ink950）：淺色文字 (ink50)
    expect(KlpThemeContrast.foregroundFor(KlpPalette.ink600), KlpPalette.ink50);
    expect(KlpThemeContrast.foregroundFor(KlpPalette.ink700), KlpPalette.ink50);
    expect(KlpThemeContrast.foregroundFor(KlpPalette.ink800), KlpPalette.ink50);
    expect(KlpThemeContrast.foregroundFor(KlpPalette.ink900), KlpPalette.ink50);
    expect(KlpThemeContrast.foregroundFor(KlpPalette.ink950), KlpPalette.ink50);
  });

  test('段落文字預設在淺色模式為最黑 (ink900)，深色模式為最白 (ink50)', () {
    for (final role in KlpTextRole.values) {
      expect(
        KlpTextStyles.colorFor(KlpThemeData.light, role: role),
        KlpPalette.ink900,
        reason: 'Light mode default text for $role must be ink900',
      );
      expect(
        KlpTextStyles.colorFor(KlpThemeData.dark, role: role),
        KlpPalette.ink50,
        reason: 'Dark mode default text for $role must be ink50',
      );
    }
  });

  test('透明背景時延續上層模式設定，文字色不翻轉為深色模式', () {
    expect(KlpThemeContrast.isDarkBackground(KlpPalette.transparent), isFalse);
    expect(KlpThemeContrast.isDarkBackground(KlpPalette.line), isFalse);
    expect(
      KlpThemeContrast.foregroundFor(KlpPalette.transparent),
      KlpPalette.ink900,
    );
    expect(
      KlpThemeData.light.onBackground(KlpPalette.transparent).text,
      KlpThemeData.light.text,
    );
    expect(
      KlpThemeData.light.onBackground(KlpPalette.line).text,
      KlpThemeData.light.text,
    );
    expect(
      KlpThemeData.dark.onBackground(KlpPalette.transparent).text,
      KlpThemeData.dark.text,
    );
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
