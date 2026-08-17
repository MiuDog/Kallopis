import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test('語意四色依明暗外觀解析為低彩度策展色', () {
    expect(KlpThemeData.light.success, const Color(0xFF3B7240));
    expect(KlpThemeData.light.warning, const Color(0xFF7E6525));
    expect(KlpThemeData.light.danger, const Color(0xFFA14736));
    expect(KlpThemeData.light.info, const Color(0xFF466A7C));

    for (final tokens in [KlpThemeData.dark, KlpThemeData.ultraDark]) {
      expect(tokens.success, const Color(0xFF6BB371));
      expect(tokens.warning, const Color(0xFFCCAF66));
      expect(tokens.danger, const Color(0xFFD28D7F));
      expect(tokens.info, const Color(0xFF81A8BB));
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
    expect(KlpThemeData.light.app, const Color(0xFFE4E0D8));
    expect(KlpThemeData.light.surface, const Color(0xFFF2F0EB));
    expect(KlpThemeData.light.stageSurface, const Color(0xFFFFFEFC));
    expect(
      KlpThemeData.light.stageSurface.computeLuminance(),
      greaterThan(KlpThemeData.light.surface.computeLuminance()),
    );

    expect(KlpThemeData.dark.app, const Color(0xFF171513));
    expect(KlpThemeData.dark.surface, const Color(0xFF292622));
    expect(KlpThemeData.dark.stageSurface, const Color(0xFF211F1C));
    expect(KlpThemeData.dark.surfaceInset, const Color(0xFF34302C));
    expect(KlpThemeData.dark.surfaceMuted, const Color(0xFF34302C));
    expect(KlpThemeData.dark.component, const Color(0xFF211F1C));
    expect(
      KlpThemeData.dark.surface.computeLuminance(),
      greaterThan(KlpThemeData.dark.stageSurface.computeLuminance()),
    );

    expect(KlpThemeData.ultraDark.app, const Color(0xFF000000));
    expect(KlpThemeData.ultraDark.surface, const Color(0xFF121110));
    expect(KlpThemeData.ultraDark.stageSurface, const Color(0xFF0A0A09));
    expect(
      KlpThemeData.ultraDark.surface.computeLuminance(),
      greaterThan(KlpThemeData.ultraDark.stageSurface.computeLuminance()),
    );

    expect(
      KlpThemeData.dark.app.computeLuminance() -
          KlpThemeData.ultraDark.app.computeLuminance(),
      greaterThanOrEqualTo(0.005),
    );
    expect(
      KlpThemeData.dark.surface.computeLuminance() -
          KlpThemeData.ultraDark.surface.computeLuminance(),
      greaterThanOrEqualTo(0.01),
    );
    expect(
      KlpThemeData.dark.stageSurface.computeLuminance() -
          KlpThemeData.ultraDark.stageSurface.computeLuminance(),
      greaterThanOrEqualTo(0.008),
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

  test('最高階 Light 文字維持中性 ink 以保留最大可讀對比', () {
    expect(KlpThemeData.light.text, const Color(0xFF1D1D1D));
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
