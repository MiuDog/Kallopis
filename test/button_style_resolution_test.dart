import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis/src/foundation/interaction/internal/klp_button_style.dart';
import 'package:kallopis/src/styling/legacy_tokens/primitive_token.dart'
    as primitive;
import 'package:kallopis/src/styling/legacy_theme/klp_shape_theme.dart'
    as semantic;

/// 測試資料解析與注入邊界，不建立或定型新的畫面布局。
void main() {
  test('public entry exposes primitive scale and palette', () {
    expect(KlpPalette.ink900, primitive.KlpPalette.ink900);
    expect(KlpAccent.ink, primitive.KlpAccent.ink);
    expect(KlpScale.stroke200, primitive.KlpScale.stroke200);
    expect(
      semantic.KlpShapeTheme.standardShape.stroke,
      primitive.KlpScale.stroke200,
    );
  });

  test(
    'JSON overrides reach resolved button slots without replacing defaults',
    () {
      final original = KlpVisualStyleJson.encode(KlpVisualStyle.defaultStyle);
      final custom = KlpVisualStyleJson.decode({
        'schemaVersion': 2,
        'spacing': {'controlContentGap': 9.0, 'controlPaddingXSmall': 17.0},
        'components': {
          'buttonPaddingX': 31.0,
          'buttonRadius': 5.0,
          'buttonBorderWidth': 3.0,
        },
      });
      final tokens = _tokens(custom);
      final medium = _resolve(tokens, KlpControlSize.md);
      final small = _resolve(tokens, KlpControlSize.sm);
      expect(medium.insets.horizontal, 62);
      expect(
        medium.insets.vertical,
        0,
        reason: 'Existing button content uses horizontal padding only.',
      );
      expect(
        small.insets.horizontal,
        34,
        reason:
            'MD component overrides must not replace the small size mapping.',
      );
      expect(medium.radius, 5);
      expect(medium.border!.top.width, 3);
      expect(medium.contentGap, 9);
      expect(custom.typography, same(KlpVisualStyle.defaultStyle.typography));
      expect(KlpVisualStyleJson.encode(KlpVisualStyle.defaultStyle), original);
      expect(
        KlpVisualStyleJson.encode(
          KlpVisualStyleJson.decode(KlpVisualStyleJson.encode(custom)),
        ),
        KlpVisualStyleJson.encode(custom),
      );
    },
  );

  test('fresh theme snapshot replaces previously resolved button values', () {
    final first = _resolve(
      _tokens(KlpVisualStyle.defaultStyle),
      KlpControlSize.md,
    );
    final next = KlpVisualStyle.defaultStyle.copyWith(
      spacing: KlpVisualStyle.defaultStyle.spacing.copyWith(
        controlContentGap: 19,
      ),
      components: const KlpComponentTheme(buttonRadius: 13, buttonHeight: 57),
    );
    final second = _resolve(_tokens(next), KlpControlSize.md);
    expect(second.height, 57);
    expect(second.radius, 13);
    expect(second.contentGap, 19);
    expect(first.height, isNot(second.height));
    expect(first.radius, isNot(second.radius));
  });

  test(
    'button control spacing is isolated from content and action spacing',
    () {
      final original = KlpVisualStyle.defaultStyle;
      final custom = original.copyWith(
        spacing: original.spacing.copyWith(
          contentInlineGap: 31,
          contentStackGap: 37,
          contentInset: 41,
          actionGap: 43,
          controlContentGap: 13,
          controlInset: 17,
        ),
      );
      final extraSmall = _resolve(_tokens(custom), KlpControlSize.xs);
      final medium = _resolve(_tokens(custom), KlpControlSize.md);
      expect(extraSmall.insets.horizontal, 34);
      expect(extraSmall.contentGap, 13);
      expect(medium.contentGap, 13);
      expect(
        medium.insets,
        _resolve(_tokens(original), KlpControlSize.md).insets,
      );
    },
  );

  test('disabled state ignores both selected and active washes', () {
    final tokens = _tokens(KlpVisualStyle.defaultStyle);
    for (final tone in KlpButtonTone.values) {
      final style = KlpButtonStyle.resolve(
        klp: tokens,
        tone: tone,
        size: KlpControlSize.md,
        disabled: true,
        active: true,
        selected: true,
      );
      expect(style.background, tokens.color.surfaceInset);
      expect(style.foreground, tokens.color.textFaint);
    }
  });

  test('invalid JSON fails before a style can be injected', () {
    expect(
      () => KlpVisualStyleJson.decode({
        'spacing': {'controlContentGap': 'wide'},
      }),
      throwsFormatException,
    );
    expect(
      () => KlpVisualStyleJson.decode({'schemaVersion': 999}),
      throwsFormatException,
    );
  });
}

KlpTheme _tokens(KlpVisualStyle style) {
  final theme = buildKlpTheme(Brightness.light, style: style);
  return KlpTheme(
    color: theme.extension<KlpThemeData>()!,
    type: theme.extension<KlpTypographyTheme>()!,
    space: theme.extension<KlpSpacingTheme>()!,
    shape: theme.extension<KlpShapeTheme>()!,
    motion: theme.extension<KlpMotionTheme>()!,
    surface: theme.extension<KlpSurfaceTheme>()!,
    component: theme.extension<KlpComponentTheme>()!,
    geometry: theme.extension<KlpGeometryTheme>()!,
    dataVisualization: theme.extension<KlpDataVisualizationTheme>()!,
  );
}

KlpButtonStyle _resolve(KlpTheme tokens, KlpControlSize size) {
  return KlpButtonStyle.resolve(
    klp: tokens,
    tone: KlpButtonTone.secondary,
    size: size,
    disabled: false,
    active: false,
    selected: false,
  );
}
