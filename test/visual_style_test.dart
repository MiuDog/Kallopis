import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// 架構的驗收條件：**換一套視覺風格只需要換 theme。**
///
/// 若某個維度在兩套風格之間相同，代表該維度還沒進 theme——元件必然在自己那邊寫死了它。
void main() {
  group('KlpVisualStyle', () {
    test('terminal 與 modern 在每一個維度上都不同', () {
      const modern = KlpVisualStyle.modern;
      const terminal = KlpVisualStyle.terminal;

      // 字體：終端機風全域等寬
      expect(terminal.typography.uiFamily, terminal.typography.monoFamily);
      expect(modern.typography.uiFamily, isNot(modern.typography.monoFamily));

      // 形狀：終端機風全部直角
      expect(terminal.shape.control, 0);
      expect(terminal.shape.card, 0);
      expect(terminal.shape.panel, 0);
      expect(modern.shape.control, greaterThan(0));

      // 密度：終端機風更緊湊
      expect(
        terminal.spacing.controlHeight,
        lessThan(modern.spacing.controlHeight),
      );
      expect(
        terminal.spacing.containerPadding,
        lessThan(modern.spacing.containerPadding),
      );

      // 動態：終端機風沒有過場
      expect(terminal.motion.stateTransition, Duration.zero);
      expect(modern.motion.stateTransition, greaterThan(Duration.zero));

      // 分層手法：邊框 vs 陰影，兩者互斥
      expect(terminal.surface.separation, KlpSurfaceSeparation.outline);
      expect(modern.surface.separation, KlpSurfaceSeparation.shadow);
      expect(terminal.surface.overlayShadow(const Color(0xFF000000)), isEmpty);
      expect(
        modern.surface.overlayShadow(const Color(0xFF000000)),
        isNotEmpty,
      );
    });

    test('每套風格都提供完整的 extension 清單', () {
      for (final style in [KlpVisualStyle.modern, KlpVisualStyle.terminal]) {
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
      final reduced = KlpVisualStyle.modern.withReducedMotion(true);
      expect(reduced.motion.stateTransition, Duration.zero);
      expect(reduced.motion.overlayEnter, Duration.zero);
      expect(
        reduced.motion.toastDwell,
        KlpVisualStyle.modern.motion.toastDwell,
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
        ThemeData(extensions: KlpVisualStyle.terminal.extensions),
      );

      expect(tokens.shape.control, 0);
      expect(tokens.motion.stateTransition, Duration.zero);
      expect(tokens.type.uiFamily, KlpTypographyTheme.monospaced.monoFamily);
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
        ThemeData(extensions: KlpVisualStyle.modern.extensions),
      );

      expect(
        tokens.buttonRadius,
        KlpShapeTheme.standardShape.control,
        reason: 'inherited component theme 應該回落到 shape.control',
      );
      expect(tokens.buttonHeight, KlpSpacingTheme.comfortableDensity.controlHeight);
    });

    testWidgets('component token 存在時覆蓋 semantic', (tester) async {
      final tokens = await resolve(
        tester,
        ThemeData(extensions: KlpVisualStyle.terminal.extensions),
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
