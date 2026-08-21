import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

/// 架構的驗收條件：**換一套視覺風格只需要換 theme。**
///
/// 若某個維度在兩套風格之間相同，代表該維度還沒進 theme——元件必然在自己那邊寫死了它。
void main() {
  group('KlpVisualStyle', () {
    test('對照風格與 modern 在每一個維度上都不同', () {
      const modern = KlpVisualStyle.defaultStyle;
      final contrasting = contrastingStyle;

      // 字體：對照風格全域等寬
      expect(
        contrasting.typography.uiFamily,
        contrasting.typography.monoFamily,
      );
      expect(modern.typography.uiFamily, isNot(modern.typography.monoFamily));

      // 形狀：對照風格全部直角
      expect(contrasting.shape.control, 0);
      expect(contrasting.shape.card, 0);
      expect(contrasting.shape.panel, 0);
      expect(modern.shape.control, greaterThan(0));

      // 密度：對照風格更緊湊
      expect(
        contrasting.spacing.controlHeight,
        lessThan(modern.spacing.controlHeight),
      );
      expect(
        contrasting.spacing.containerPadding,
        lessThan(modern.spacing.containerPadding),
      );

      // 動態：對照風格沒有過場
      expect(contrasting.motion.stateTransition, Duration.zero);
      expect(modern.motion.stateTransition, greaterThan(Duration.zero));

      // 分層手法：邊框 vs 陰影，兩者互斥
      expect(contrasting.surface.separation, KlpSurfaceSeparation.outline);
      expect(modern.surface.separation, KlpSurfaceSeparation.shadow);
      expect(
        contrasting.surface.overlayShadow(const Color(0xFF000000)),
        isEmpty,
      );
      expect(modern.surface.overlayShadow(const Color(0xFF000000)), isNotEmpty);
    });

    test('每套風格都提供完整的 extension 清單', () {
      for (final style in [KlpVisualStyle.defaultStyle, contrastingStyle]) {
        final types = style.extensions.map((e) => e.type).toSet();
        expect(
          types.length,
          style.extensions.length,
          reason: '${style.name} 有重複型別的 extension',
        );
        expect(types, contains(KlpThemeData));
        expect(types, contains(KlpTypographyTheme));
        expect(types, contains(KlpSpacingTheme));
        expect(types, contains(KlpShapeTheme));
        expect(types, contains(KlpMotionTheme));
        expect(types, contains(KlpSurfaceTheme));
        expect(types, contains(KlpComponentTheme));
      }
    });

    test('withReducedMotion 關掉互動過場但保留 toast 停留時間', () {
      final reduced = KlpVisualStyle.defaultStyle.withReducedMotion(true);
      expect(reduced.motion.stateTransition, Duration.zero);
      expect(reduced.motion.overlayEnter, Duration.zero);
      expect(
        reduced.motion.toastDwell,
        KlpVisualStyle.defaultStyle.motion.toastDwell,
        reason: 'toast 停留時間是可讀性需求，不是動態效果',
      );
    });
  });

  group('KlpTheme.of', () {
    Future<KlpTheme> resolve(WidgetTester tester, ThemeData theme) async {
      late KlpTheme captured;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Builder(
            builder: (context) {
              captured = context.klp;
              return const SizedBox();
            },
          ),
        ),
      );
      return captured;
    }

    testWidgets('讀得到已註冊的每一層', (tester) async {
      final tokens = await resolve(
        tester,
        ThemeData(extensions: contrastingStyle.extensions),
      );

      expect(tokens.shape.control, 0);
      expect(tokens.motion.stateTransition, Duration.zero);
      expect(tokens.type.uiFamily, KlpTypographyTheme.proportional.monoFamily);
      expect(tokens.surface.separation, KlpSurfaceSeparation.outline);
    });

    testWidgets('沒有註冊任何 extension 時回退到預設而非拋錯', (tester) async {
      final tokens = await resolve(tester, ThemeData());

      expect(tokens.shape.control, KlpShapeTheme.standardShape.control);
      expect(tokens.space.base, KlpSpacingTheme.comfortableDensity.base);
      expect(tokens.color, KlpThemeData.light);
    });

    testWidgets('component token 缺席時沿用 semantic', (tester) async {
      final tokens = await resolve(
        tester,
        ThemeData(extensions: KlpVisualStyle.defaultStyle.extensions),
      );

      expect(
        tokens.buttonRadius,
        KlpShapeTheme.standardShape.control,
        reason: 'inherited component theme 應該回落到 shape.control',
      );
      expect(
        tokens.buttonHeight,
        KlpSpacingTheme.comfortableDensity.controlHeight,
      );
    });

    testWidgets('component token 存在時覆蓋 semantic', (tester) async {
      final tokens = await resolve(
        tester,
        ThemeData(extensions: contrastingStyle.extensions),
      );

      expect(tokens.buttonRadius, 0);
      expect(
        tokens.buttonBorderWidth,
        greaterThan(0),
        reason: 'outline 分層時按鈕必須有可見邊框',
      );
    });
  });
}
