import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/features/forms/color/klp_oklch_chroma_range.dart';
import 'package:kallopis/src/features/forms/color/klp_oklch_color_editor.dart';
import 'package:kallopis/src/features/forms/color/klp_oklch_color_picker.dart';
import 'package:kallopis/src/features/forms/selection/klp_slider.dart';
import 'package:kallopis/src/foundation/klp_oklch_color.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_visual_style.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_visual_style_json.dart';

import 'style_fixture.dart';

void main() {
  test('sRGB 往返維持可見通道', () {
    const source = Color.fromARGB(204, 32, 128, 224);
    final converted = KlpOklchColor.fromColor(source).toColor();
    final sourceArgb = source.toARGB32();
    final convertedArgb = converted.toARGB32();

    for (final shift in [0, 8, 16, 24]) {
      final expected = (sourceArgb >> shift) & 0xff;
      final actual = (convertedArgb >> shift) & 0xff;
      expect(actual, closeTo(expected, 1));
    }
  });

  test('超出 sRGB 色域時保留判定並限制預覽通道', () {
    const value = KlpOklchColor(lightness: 0.7, chroma: 0.4, hue: 40);
    expect(value.isInSrgbGamut, isFalse);

    final argb = value.toColor().toARGB32();
    for (final shift in [0, 8, 16]) {
      expect((argb >> shift) & 0xff, inInclusiveRange(0, 255));
    }
  });

  test('brand 預設沿用 accent，但覆寫後不改變操作色', () {
    expect(KlpThemeData.light.brand, KlpThemeData.light.accent);
    const brand = Color.fromARGB(255, 32, 128, 224);
    final themed = KlpThemeData.light.copyWith(brand: brand);
    expect(themed.brand, brand);
    expect(themed.accent, KlpThemeData.light.accent);
    expect(themed.interaction, KlpThemeData.light.interaction);
  });

  test('brand 可由 visual style JSON 完整往返', () {
    const brand = Color.fromARGB(255, 32, 128, 224);
    final source = KlpVisualStyle.defaultStyle.copyWith(
      colors: KlpThemeData.light.copyWith(brand: brand),
    );
    final decoded = KlpVisualStyleJson.decode(
      KlpVisualStyleJson.encode(source),
    );
    expect(decoded.colors.brand, brand);
    expect(decoded.colors.accent, KlpThemeData.light.accent);
  });

  test('color plane geometry 可由 visual style JSON 完整往返', () {
    final source = KlpVisualStyle.defaultStyle.copyWith(
      geometry: KlpVisualStyle.defaultStyle.geometry.copyWith(
        control: KlpVisualStyle.defaultStyle.geometry.control.copyWith(
          colorPlaneExtent: 222,
        ),
      ),
    );
    final decoded = KlpVisualStyleJson.decode(
      KlpVisualStyleJson.encode(source),
    );
    expect(decoded.geometry.control.colorPlaneExtent, 222);
  });

  testWidgets('寬版橫排四軸，窄版依序換行', (tester) async {
    Widget subject(double width) {
      return MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            child: KlpOklchColorEditor(
              value: const KlpOklchColor(lightness: 0.6, chroma: 0.1, hue: 220),
              onChanged: (_) {},
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(subject(800));
    final wideY = [
      for (var index = 0; index < 4; index++)
        tester.getTopLeft(find.byType(KlpSlider).at(index)).dy,
    ];
    expect(wideY.toSet(), hasLength(1));

    await tester.pumpWidget(subject(160));
    final narrowY = [
      for (var index = 0; index < 4; index++)
        tester.getTopLeft(find.byType(KlpSlider).at(index)).dy,
    ];
    expect(narrowY[0], lessThan(narrowY[1]));
    expect(narrowY[1], lessThan(narrowY[2]));
    expect(narrowY[2], lessThan(narrowY[3]));
  });

  testWidgets('具名 Chroma 範圍會限制編輯器上限', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpOklchColorEditor(
            value: const KlpOklchColor(lightness: 0.6, chroma: 0.1, hue: 220),
            onChanged: (_) {},
            chromaRange: const KlpOklchChromaRange.custom(0.2),
          ),
        ),
      ),
    );

    final chromaSlider = tester.widget<Slider>(find.byType(Slider).at(1));
    expect(chromaSlider.max, 0.2);
  });

  for (final entry in {
    'default': KlpVisualStyle.defaultStyle,
    'contrasting': contrastingStyle,
  }.entries) {
    testWidgets('編輯器在 ${entry.key} 風格解析並傳回 Chroma', (tester) async {
      final semantics = tester.ensureSemantics();
      KlpOklchColor? changed;
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.dark, style: entry.value),
          home: Scaffold(
            body: KlpOklchColorEditor(
              value: const KlpOklchColor(lightness: 0.7, chroma: 0.4, hue: 40),
              onChanged: (value) => changed = value,
            ),
          ),
        ),
      );

      expect(find.byType(KlpSlider), findsNWidgets(4));
      expect(find.bySemanticsLabel(RegExp('Lightness')), findsWidgets);
      expect(find.bySemanticsLabel(RegExp('Chroma')), findsWidgets);
      expect(find.bySemanticsLabel(RegExp('Hue')), findsWidgets);
      expect(find.bySemanticsLabel(RegExp('Alpha')), findsWidgets);

      final chromaSlider = tester.widget<Slider>(find.byType(Slider).at(1));
      chromaSlider.onChanged!(0.2);
      expect(changed?.chroma, 0.2);
      semantics.dispose();
    });
  }

  test('sRGB fallback 保留 L、H 與 Alpha，只降低 Chroma', () {
    const source = KlpOklchColor(
      lightness: 0.7,
      chroma: 0.4,
      hue: 40,
      alpha: 0.8,
    );

    final fallback = source.closestSrgbFallback;

    expect(source.isInSrgbGamut, isFalse);
    expect(fallback.isInSrgbGamut, isTrue);
    expect(fallback.lightness, source.lightness);
    expect(fallback.hue, source.hue);
    expect(fallback.alpha, source.alpha);
    expect(fallback.chroma, lessThan(source.chroma));
  });

  test('已在 sRGB 色域內的值不需要 fallback', () {
    const source = KlpOklchColor(lightness: 0.6, chroma: 0.05, hue: 220);

    expect(identical(source.closestSrgbFallback, source), isTrue);
  });

  for (final entry in {
    'default': KlpVisualStyle.defaultStyle,
    'contrasting': contrastingStyle,
  }.entries) {
    testWidgets('picker 在 ${entry.key} 風格解析專用平面尺寸', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.dark, style: entry.value),
          home: Scaffold(
            body: KlpOklchColorPicker(
              value: const KlpOklchColor(
                lightness: 0.7,
                chroma: 0.4,
                hue: 40,
                alpha: 0.8,
              ),
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final lightnessPlane = find.bySemanticsLabel('Lightness plane');
      final planePaint = find.descendant(
        of: lightnessPlane,
        matching: find.byType(CustomPaint),
      );
      final expectedExtent = entry.key == 'default' ? 168.0 : 120.0;
      expect(tester.getSize(planePaint), Size.square(expectedExtent));
      expect(find.bySemanticsLabel('Chroma plane'), findsOneWidget);
      expect(find.bySemanticsLabel('Hue plane'), findsOneWidget);
      expect(find.bySemanticsLabel('Clipped original'), findsOneWidget);
      expect(find.bySemanticsLabel('sRGB fallback'), findsOneWidget);
      expect(
        find.text('Outside sRGB gamut; fallback reduces chroma.'),
        findsOneWidget,
      );
      semantics.dispose();
    });
  }

  testWidgets('平面可由指標與方向鍵更新，clip 外不接收事件', (tester) async {
    final semantics = tester.ensureSemantics();
    KlpOklchColor? changed;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpOklchColorPicker(
            value: const KlpOklchColor(lightness: 0.5, chroma: 0.1, hue: 180),
            onChanged: (value) => changed = value,
          ),
        ),
      ),
    );

    final plane = find.bySemanticsLabel('Lightness plane');
    final rect = tester.getRect(plane);
    await tester.tapAt(
      rect.topLeft + Offset(rect.width * 0.75, rect.height * 0.25),
    );
    expect(changed?.lightness, closeTo(0.75, 0.02));
    expect(changed?.chroma, closeTo(0.3, 0.02));

    changed = null;
    await tester.tapAt(rect.topLeft - const Offset(1, 1));
    expect(changed, isNull);

    await tester.tap(plane);
    changed = null;
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(changed?.chroma, closeTo(0.104, 0.001));
    expect(
      find.descendant(of: plane, matching: find.byType(ClipRRect)),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
